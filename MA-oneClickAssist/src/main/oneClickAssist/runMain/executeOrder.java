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
		String tarStr = tarF.toString();
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
		
		else if(tarStr.contains("contents")) {
		    list.add(new InOutPathClas(getResourceAsFile("main/xslt/dummy.xml").getPath(), srcDir + "/out/dummy.xml", cl.getResourceAsStream("main/xslt/006.xsl")));
        }
		
		try {
		    if(tarStr.contains("contents")) {
		        Path con = Paths.get("contents");
		        executeXslt(con);
		        
		    } else {
		        executeXslt(tarDir);
		    }
		    
		} catch(Exception e4) {
		    e4.printStackTrace();
		}
        
		if(tarStr.contains("start") || tarStr.contains("search") || tarStr.contains("bookmark")) {
			try {
				Path searchNew = null;
				
				if(tarStr.contains("search")) {
					searchNew = Paths.get(tarDir + "\\search_new.html");
					
				} else if(tarStr.contains("start")) {
					searchNew = Paths.get(tarDir + "\\start_here_new.html");
					
				} 
				
				Files.copy(searchNew, tarF, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
				Files.delete(searchNew);
				
			} catch (IOException e) {
			    throw new RuntimeException(e.getMessage());
			}
				
		}
	}
	
	public File getResourceAsFile(String resourcePath) {
        try {
            ClassLoader cl = executeOrder.class.getClassLoader();
            InputStream in = cl.getResourceAsStream(resourcePath);
            
            if (in == null) {
                return null;
            }
            File tempFile = File.createTempFile(String.valueOf(in.hashCode()), ".tmp");

            tempFile.deleteOnExit();

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
				Result outxml = new StreamResult(out);
				Source xsltF = new StreamSource(xslt);
				URI tempD1 = null;
				File srcD = null;
				
				if(tarDir != null) {
				    File tempD = new File(tarDir.toString());
				    tempD1 = tempD.toURI();
				    
				} 
				if(srcDir != null) {
				    srcD = new File(srcDir.toString());
				}
				
				System.setProperty("javax.xml.xpath.XPathFactory:"+NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
		        TransformerFactory factory = TransformerFactory.newInstance();
				
		        try {	
		              Transformer tf = factory.newTransformer(xsltF);
 
		              if(tempD1 != null) {
		                  tf.setParameter("tempPath", tempD1);
		              }
		              if (srcD != null) {
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
