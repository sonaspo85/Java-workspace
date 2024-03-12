package main.oneClickAssist.runMain;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.om.NamespaceConstant;

public class executeOrder {
	Path tarF = null;
	Path tarDir = null;
	Path xslPath = null;
	Path srcDir = null;
	
	public ArrayList<InOutPathClas> list = new ArrayList<>();
	
	
	public executeOrder(Path tarF, File jarPath, Path srcDir) {
		this.tarF = tarF;
		tarDir = tarF.getParent(); 
		this.xslPath = Paths.get(jarPath + File.separator + "xsls");
		this.srcDir = srcDir;
	}
	
	public void setList() throws URISyntaxException {
		System.out.println("setList 시작");
		String tarStr = tarF.toString();
//		System.out.println("tarStr: " + tarStr);
//		System.out.println(srcDir + "\\tags.xml");
		ClassLoader cl = executeOrder.class.getClassLoader();
		
		if(tarStr.contains("Cross")) {			
			list.add(new InOutPathClas(tarF.toString(), tarDir + "\\001.xml", cl.getResourceAsStream("main/xslt/001.xsl")));
			list.add(new InOutPathClas(tarDir + "\\001.xml", tarDir + "\\002.xml", cl.getResourceAsStream("main/xslt/002.xsl")));
			list.add(new InOutPathClas(tarDir + "\\002.xml", tarDir + "\\003.xml", cl.getResourceAsStream("main/xslt/003.xsl")));
			list.add(new InOutPathClas(tarDir + "\\003.xml", tarDir + "\\003_1.xml", cl.getResourceAsStream("main/xslt/003_1.xsl")));
			list.add(new InOutPathClas(tarDir + "\\003_1.xml", tarDir + "\\003_2.xml", cl.getResourceAsStream("main/xslt/003_2.xsl")));
			list.add(new InOutPathClas(tarDir + "\\003_2.xml", tarDir + "\\003_3.xml", cl.getResourceAsStream("main/xslt/003_3.xsl")));
			list.add(new InOutPathClas(tarDir + "\\003_3.xml", srcDir + "\\tags.xml", cl.getResourceAsStream("main/xslt/003_4.xsl")));
			

		} 
		/*
		else if(tarStr.contains("search")) {
			list.add(new InOutPathClas(tarF.toString(), tarDir + "\\search_new.html", cl.getResourceAsStream("main/xslt/004.xsl")));
			
		} else if(tarStr.contains("start")) {
		    list.add(new InOutPathClas(tarF.toString(), tarDir + "\\start_here_new.html", cl.getResourceAsStream("main/xslt/005.xsl")));
			
		} */
		else if(tarStr.contains("contents")) {
		    list.add(new InOutPathClas(getResourceAsFile("main/xslt/dummy.xml").getPath(), srcDir + "/out/dummy.xml", cl.getResourceAsStream("main/xslt/006.xsl")));
        }
		
		// xslt 실행
		try {
		    System.out.println("tarDir: " + tarDir);
//		    executeXslt(tarDir);
		    if(tarStr.contains("contents")) {
		        Path con = Paths.get("contents");
		        executeXslt(con);
		        
		    } else {
		        executeXslt(tarDir);
		    }
		    
		} catch(Exception e4) {
		    // Stream에서 예외 발생시 즉시 예외를 처리 하고 RC 컨트롤러로 되돌아감
		    e4.printStackTrace();
//		    throw new RuntimeException(e4.getMessage());
		}
        
		// 기존 search.html 을 삭제 하고 새로운 search_new.html 파일명을 변경 하기
		if(tarStr.contains("start") || tarStr.contains("search") || tarStr.contains("bookmark")) {
			try {
				Path searchNew = null;
//				System.out.println("tarDir111: " + tarDir.getParent());
				
				if(tarStr.contains("search")) {
					searchNew = Paths.get(tarDir + "\\search_new.html");
					
				} else if(tarStr.contains("start")) {
					searchNew = Paths.get(tarDir + "\\start_here_new.html");
					
				} 
				
				// search_new.html 파일을 기존 기존 search.html에 덮어씌움 
				Files.copy(searchNew, tarF, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
				Files.delete(searchNew);
				
			} catch (IOException e) {
			    throw new RuntimeException(e.getMessage());
			}
				
		}
	}
	
	public File getResourceAsFile(String resourcePath) {
        try {
//            InputStream in = ClassLoader.getSystemClassLoader().getResourceAsStream(resourcePath);
            ClassLoader cl = executeOrder.class.getClassLoader();
            InputStream in = cl.getResourceAsStream(resourcePath);
            if (in == null) {
                System.out.println("in은 null 이다");
                return null;
            }
            File tempFile = File.createTempFile(String.valueOf(in.hashCode()), ".tmp");
//            System.out.println("ddd: "+ tempFile.toPath());
            tempFile.deleteOnExit(); // 해당 경로된 디렉토리 파일을 삭제함 (컴파일이 종료 되는 시점에)

            try (FileOutputStream out = new FileOutputStream(tempFile)) {
                // copy stream
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
            return tempFile;
            
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
	
	public void executeXslt(Path tarDir) {
		System.out.println("executeXslt 시작");
		
		try {
			list.forEach(a -> {
				File in = new File(a.getinFile());
				File out = new File(a.getoutFile());
				InputStream xslt = a.getisFile();
				
				// 1. xml 파일을 스트림으로 얻어 Source 객체로 생성
				Source inxml = new StreamSource(in);
				
				// 출력 스트림을 통해 생성될 파일 지정 
				Result outxml = new StreamResult(out);
				
				// xslt 지정
				Source xsltF = new StreamSource(xslt);
				
//				File tempD = new File(tarDir.toString());
				URI tempD1 = null;
				File srcD = null;
				
				if(tarDir != null) {
				    File tempD = new File(tarDir.toString());
				    tempD1 = tempD.toURI();
				    
				} 
				if(srcDir != null) {
//				    System.out.println("srcDir222: " + srcDir);
				    srcD = new File(srcDir.toString());
				}
				
				System.setProperty("javax.xml.xpath.XPathFactory:"+NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
		        TransformerFactory factory = TransformerFactory.newInstance();
				
		        try {
		        	  // Transformer 객체를 생성하는데 매개 변수로 xslt 파일을 입력스트림으로 사용하고 있는 변수 할당	
		              Transformer tf = factory.newTransformer(xsltF);
//		              tf.setParameter("tempPath", tempD1);
		              
		              if(tempD1 != null) {
		                  tf.setParameter("tempPath", tempD1);
		              }
		              if (srcD != null) {
//		                  System.out.println("srcPath333: " + srcD.toURI());
		                  tf.setParameter("srcPath", srcD.toURI());
		              }
		              
		              tf.transform(inxml, outxml);
		                    
		          } catch(Exception e1) {
		              throw new RuntimeException(e1.getMessage());
		          }
			});
			
			list.clear();
			System.out.println("끝");
			
		} catch(Exception e1) {
		    throw new RuntimeException(e1.getMessage());
		}
		
	}
	
}
