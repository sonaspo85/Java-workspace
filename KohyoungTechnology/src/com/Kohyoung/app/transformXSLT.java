package com.Kohyoung.app;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.Reader;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Map;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.lib.NamespaceConstant;
//import net.sf.saxon.om.NamespaceConstant;

public class transformXSLT {
    public ArrayList<InOutPathClas> list = new ArrayList<>();
    public static String packageDir = "";
    String xslDir = "";
    String tempDir = ""; 
    String outDir = "";
    String outDir2 = "";
    String outputFolderName = "";
    String srcDir ="";
    
    public ArrayList<String> extensionRemoveVar = Varietyfunction.getExtensionRemoveList();
    public ArrayList<String> arrFileNameListVar = Varietyfunction.getarrFileNameList(); 
    public ArrayList<String> arrFileLanguageNameVar = Varietyfunction.getArrFileLanguageName();  
    
    public transformXSLT(String packageDir, String outDir, String outDir2, String outputFolderName, String srcDir) {
        this.packageDir = packageDir;
        this.outDir = outDir;
        this.outDir2 = outDir2;
        this.outputFolderName = outputFolderName;
        this.srcDir = srcDir;
        
        xslDir = packageDir + File.separator + "xsls";
        tempDir = packageDir + File.separator + "temp"; 
        
        System.out.println("srcDir000: " + srcDir);
        
        
//        System.out.println("extensionRemoveVar: " + extensionRemoveVar);
//        System.out.println("arrFileNameListVar: " + arrFileNameListVar);
//        System.out.println("arrFileLanguageNameVar: " + arrFileLanguageNameVar);
    }
    
    public static void addPath(String s) throws Exception {
	  File f = new File(s);
	  URL u = f.toURL();
	  URLClassLoader urlClassLoader = (URLClassLoader) ClassLoader.getSystemClassLoader();
	  Class urlClass = URLClassLoader.class;
	  Method method = urlClass.getDeclaredMethod("addURL", new Class[]{URL.class});
	  method.setAccessible(true);
	  method.invoke(urlClassLoader, new Object[]{u});
	}
    
    public void runSpec2xml(int i) {
        System.out.println("runSpec2xml() 시작");
        
             
        
//        System.out.println("111: " + packageDir);
//        System.out.println("222: " + outDir);
//        System.out.println("333: " + outDir2);
        
//        System.out.println("www: " + i);
        
        list.add(new InOutPathClas(xslDir + "/dummy.xml", tempDir + "/00-line-feed.xml", xslDir + "/00-line-feed.xsl"));
    	list.add(new InOutPathClas(tempDir + "/00-line-feed.xml", tempDir + "/01-orginal-source.xml", xslDir + "/01-extract-attr.xsl"));
    	list.add(new InOutPathClas(tempDir + "/01-extract-attr.xml", tempDir + "/02-create-attr.xml", xslDir + "/02-create-attr.xsl"));
    	list.add(new InOutPathClas(tempDir + "/02-create-attr.xml", tempDir + "/03-space-between-quot.xml", xslDir + "/03-space-between-quot.xsl"));
    	list.add(new InOutPathClas(tempDir + "/03-space-between-quot.xml", tempDir + "/04-self-closing_IDpos.xml", xslDir + "/04-self-closing_IDpos.xsl"));
    	list.add(new InOutPathClas(tempDir + "/01-orginal-source.xml", tempDir + "/05-groupid-source.xml", xslDir + "/05-groupid-source.xsl"));
    	list.add(new InOutPathClas(tempDir + "/05-groupid-source.xml", tempDir + "/06-createXML-structure.xml", xslDir + "/06-createXML-structure.xsl"));
    	list.add(new InOutPathClas(tempDir + "/06-createXML-structure.xml", tempDir + "/07-trash-tagClean.xml", xslDir + "/07-trash-tagClean.xsl"));
    	list.add(new InOutPathClas(tempDir + "/07-extract-styleInfo.xml", tempDir + "/08-make-styleinfo.xml", xslDir + "/08-make-styleinfo.xsl"));
    	list.add(new InOutPathClas(tempDir + "/08-make-styleinfo.xml", tempDir + "/09-clear-styleinfo.xml", xslDir + "/09-clear-styleinfo.xsl"));
    	list.add(new InOutPathClas(tempDir + "/07-trash-tagClean.xml", tempDir + "/10-attrname-define.xml", xslDir + "/10-attrname-define.xsl"));
    	list.add(new InOutPathClas(tempDir + "/10-attrname-define.xml", tempDir + "/11-trash-tagClean.xml", xslDir + "/11-trash-tagClean.xsl"));
    	list.add(new InOutPathClas(tempDir + "/11-trash-tagClean.xml", tempDir + "/12-grouping-inlineText.xml", xslDir + "/12-grouping-inlineText.xsl"));
    	list.add(new InOutPathClas(tempDir + "/12-grouping-inlineText.xml", tempDir + "/13-insert-destinationkeys.xml", xslDir + "/13-insert-destinationkeys.xsl"));
    	list.add(new InOutPathClas(tempDir + "/13-insert-destinationkeys.xml", tempDir + "/14-image-grouping.xml", xslDir + "/14-image-grouping.xsl"));
    	list.add(new InOutPathClas(tempDir + "/14-image-grouping.xml", tempDir + "/14-nest-image.xml", xslDir + "/14-nest-image.xsl"));
    	list.add(new InOutPathClas(tempDir + "/14-nest-image.xml", tempDir + "/15-grouping-SubList.xml", xslDir + "/15-grouping-SubList.xsl"));
    	list.add(new InOutPathClas(tempDir + "/15-grouping-SubList.xml", tempDir + "/16-grouping-ULLlist.xml", xslDir + "/16-grouping-ULLlist.xsl"));
    	list.add(new InOutPathClas(tempDir + "/16-grouping-ULLlist.xml", tempDir + "/17-grouping-OLLlist.xml", xslDir + "/17-grouping-OLLlist.xsl"));
    	list.add(new InOutPathClas(tempDir + "/17-grouping-OLLlist.xml", tempDir + "/18-change-OLULtagName.xml", xslDir + "/18-change-OLULtagName.xsl"));
    	list.add(new InOutPathClas(tempDir + "/18-change-OLULtagName.xml", tempDir + "/19-nested-OLUL.xml", xslDir + "/19-nested-OLUL.xsl"));
    	list.add(new InOutPathClas(tempDir + "/19-nested-OLUL.xml", tempDir + "/20-grouping-ULOL.xml", xslDir + "/20-grouping-ULOL.xsl"));
    	list.add(new InOutPathClas(tempDir + "/20-grouping-ULOL.xml", tempDir + "/21-delete-OLUL-umbering.xml", xslDir + "/21-delete-OLUL-umbering.xsl"));
    	list.add(new InOutPathClas(tempDir + "/21-delete-OLUL-umbering.xml", tempDir + "/22-tableControl.xml", xslDir + "/22-tableControl.xsl"));
    	list.add(new InOutPathClas(tempDir + "/22-tableControl.xml", tempDir + "/23-tableControl.xml", xslDir + "/23-tableControl.xsl"));
    	list.add(new InOutPathClas(tempDir + "/23-tableControl.xml", tempDir + "/24-grouping-note.xml", xslDir + "/24-grouping-note.xsl"));
    	list.add(new InOutPathClas(tempDir + "/24-grouping-note.xml", tempDir + "/25-grouping-noteList.xml", xslDir + "/25-grouping-noteList.xsl"));
    	list.add(new InOutPathClas(tempDir + "/25-grouping-noteList.xml", tempDir + "/26-grouping-ULOL.xml", xslDir + "/26-grouping-ULOL.xsl"));
    	list.add(new InOutPathClas(tempDir + "/26-grouping-ULOL.xml", tempDir + "/27-tagName-define.xml", xslDir + "/27-tagName-define.xsl"));
    	list.add(new InOutPathClas(tempDir + "/27-tagName-define.xml", tempDir + "/28-grouping-para.xml", xslDir + "/28-grouping-para.xsl"));
    	list.add(new InOutPathClas(tempDir + "/28-grouping-para.xml", tempDir + "/29-topicalize.xml", xslDir + "/29-topicalize.xsl"));
    	list.add(new InOutPathClas(tempDir + "/29-topicalize.xml", tempDir + "/30-grouping-midtitle.xml", xslDir + "/30-grouping-midtitle.xsl"));
    	list.add(new InOutPathClas(tempDir + "/30-grouping-midtitle.xml", tempDir + "/31-href-connection.xml", xslDir + "/31-href-connection.xsl"));
    	list.add(new InOutPathClas(tempDir + "/31-href-connection.xml", tempDir + "/32-final-cleaner.xml", xslDir + "/32-final-cleaner.xsl"));
    	list.add(new InOutPathClas(tempDir + "/32-final-cleaner.xml", tempDir + "/dummy.xml", xslDir + "/33-search_js.xsl"));
    	list.add(new InOutPathClas(tempDir + "/32-final-cleaner.xml", tempDir + "/dummy.xml", xslDir + "/34-search-html.xsl"));
    	list.add(new InOutPathClas(tempDir + "/32-final-cleaner.xml", tempDir + "/dummy.xml", xslDir + "/35-split-html.xsl"));
    	
    	
    	//잉글리쉬 =  _
//		Varietyfunction.folderCopy(arrFileNameListVar.get(i).replaceAll(".docx", "_files"), srcDir + "\\" + outputFolderName + "\\" + arrFileLanguageNameVar.get(i) +"\\images\\");
//		Varietyfunction.deleteAllFiles(arrFileNameListVar.get(i).replaceAll(".docx", "_files"));
//		Varietyfunction.deleteFile(arrFileNameListVar.get(i).replaceAll(".docx", ".htm"));
    	
		//코리아 = . 		
//		Varietyfunction.folderCopy(arrFileNameListVar.get(i).replaceAll(".docx", ".files") , textPane.getText() + "\\" + outputFolderName + "\\" + arrFileLanguageNameVar.get(i) +"\\images\\");
//		Varietyfunction.deleteAllFiles(arrFileNameListVar.get(i).replaceAll(".docx", ".files"));
//		Varietyfunction.deleteFile(arrFileNameListVar.get(i).replaceAll(".docx", ".htm"));								
		
		    	
    	try {
            executeXslt(i);
            System.out.println("xslt 작업 완료");
//            list.clone();
            
        } catch(Exception e1) {
            System.out.println("runSpec2xml xslt 변환 실패");
            e1.printStackTrace();
        }
        
    	System.out.println("runSpec2xml 작업 완료");

    }
    
    public void executeXslt(int i) {
        System.out.println("executeXslt() 시작");
        
        Source resolved;
        ArrayList<InOutPathClas> remove = new ArrayList<>();
        
        
        System.out.println("list.size():" + list.size());
        for(int j=0; j<list.size(); j++) {
        	System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
            


            InOutPathClas iopc = list.get(j);
            
            File inFile = new File(iopc.getinFile());
            File outFile = new File(iopc.getoutFile());
            File xslFile = new File(iopc.getxslFile());
        	
//            System.out.println("inFile: " + inFile);
//            System.out.println("outFile: " + outFile);
//            System.out.println("xslFile: " + xslFile);
            
            if(xslFile.toString().contains("01-extract-attr")) {
          	  processBuilder();
//          	  list.remove(j);
          	  System.out.println("xslFile: " + xslFile + " 작업완료");
          	  continue;
            } else {
          	  	// 1. xml 문서를 구현하는 StreamSource 객체를 Source 구현 객체로 할당
                // StreamSource: xml 문서를 입력 스트림으로 사용하기 위한 객체
                Source inxml = new StreamSource(inFile);
                
                // 출력 스트림을 통해 생성될 파일 지정
                // transform한 결과 문서를 저장하는데 필요한 정보를 포함하고 있다.
                // StreamResult: xml, txt, html 로 변환되는 결과물을 저장할 객체로 사용
                Result outxml = new StreamResult(outFile);

                // xslt 지정
                Source xsltF = new StreamSource(xslFile);
                
                TransformerFactory factory = TransformerFactory.newInstance();
                
                try {
                    Transformer tf = factory.newTransformer(xsltF);
                    
                    if(xslFile.toString().contains("00-line-feed")) {
                        tf.setParameter("filename", extensionRemoveVar.get(i) + ".htm");
                        tf.setParameter("outfoldername", outputFolderName);
                        
                    } else if(xslFile.toString().contains("32-final-cleaner")) {
                  	  tf.setParameter("outputPath", srcDir);
                  	  
                    } 
                    
//                    else if(xslFile.toString().contains("01-extract-attr")) {
//                    	remove.add(iopc);
//                    }
                    
                    // xslt 프로세스 실행
                    tf.transform(inxml, outxml);
                    
                } catch(Exception tf) {
                    System.out.println("xslt 변환 실패");
                    tf.printStackTrace();
                    throw new RuntimeException("xslt 변환 실패");
                }
          	  
          	  
            }
//            System.out.println("변환 완료000!!");
            
            for (InOutPathClas name : remove) {
            	list.remove(name);
            } 
                 
        }

        System.out.println("변환 완료!!");
    }
    
    public void processBuilder() {
    	System.out.println("processBuilder() 시작");
    	
    	String libDir = packageDir + File.separator + "lib/saxon9.jar";
    	System.out.println("libDir: " + libDir);
    	ProcessBuilder builder = new ProcessBuilder();
        
        // 환경변수 설정
        Map<String, String> env = builder.environment();
       
        env.put("CLASSPATH", libDir + ";%CLASSPATH%");
        
//        list.add(new InOutPathClas(xslDir + "/dummy.xml", tempDir + "/00-line-feed.xml", xslDir + "/00-line-feed.xsl"));
        
        String in = tempDir + "/00-line-feed.xml";
        String out = tempDir + "/01-orginal-source.xml";
        String xslt = xslDir + "/01-extract-attr.xsl";
        
        String text = "java -cp " + libDir + " net.sf.saxon.Transform" + " -s:{0} -o:{1} -xsl:{2}";
        String result = MessageFormat.format(text, in, out, xslt);
        
        
        StringBuilder sb = new StringBuilder(2024);
        
        String s = null;
        Process process = null;
        
        try {
            //표준 에러 출력 방법 설정
            // false: getErrorStream(), getOutputStream() 두가지 스트림으로 나누어서 출력
            // true : getOutputStream() 하나의 스트림으로 오류내용과 정상출력 내용이 모두 같이 출력
            builder.redirectErrorStream(false);
        
            // list의 목록들을 하나씩 꺼내와 콘솔창으로 실행
            builder.command("cmd.exe", "/c", result);
            process = builder.start();

            // 에러 코드 출력                 
            // 바이트 기반 입력 스트림을 문자 기반 스트림으로 변환
            Reader reader = new InputStreamReader(process.getErrorStream(), "UTF-8");
            BufferedReader stdError = new BufferedReader(reader);

            int readCharNo;  // read() 메소드가 반환 하는 총 바이트 수 저장
            char[] cbuf = new char[1024];  // 읽은 데이터를 저장할 배열
            
            while ((s = stdError.readLine()) != null) {
                if(s != null) {
                    sb.append(s);
                    String data = new String(sb); 
                    System.out.println("에러내용: " + data);
                    
                    throw new Exception("ProcessBuilder 에러발생!");
                }
            }
            
            process.getErrorStream().close();
            process.getInputStream().close();
            process.getOutputStream().close();
            
//            waitFor() 메서드: 현재 실행한 프로세스가 종료될 때까지 블록 
//            int exitCode = process.waitFor();
            System.out.println("ProcessBuilder 작업 완료 1");
            process.destroy();
            
            return;
        } catch(Exception e) {
            // 에러 발생시 시스템 종료하기
        	
//            System.exit(0);
        	e.printStackTrace();
            
        } 
        
        /*
        finally {
            if(process != null) {
                System.out.println("현제 프로세스 완료, 다음 프로세스 실행");
            } 
            
            try { 
                // 프로세스 객체 내에 있는 서브프로세스를 강제로 종료
                System.out.println("ProcessBuilder 작업 완료 2");
                System.out.println("끝!!!!!!");
                process.destroy();
            } catch(Exception e2) {
            	System.out.println("gggggggggggg");
            	e2.printStackTrace();
            }
            
        }
        */
    	
    }
    
}