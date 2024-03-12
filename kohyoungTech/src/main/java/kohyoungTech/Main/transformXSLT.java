package main.java.kohyoungTech.Main;

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
    implementOBJ obj = new implementOBJ();
    public ArrayList<InOutPathClas> list = new ArrayList<>();
    String curFullPath = null;
    String msg = "";
    
    public transformXSLT(String curFullPath) {
        this.curFullPath = curFullPath;
    }
    
    
    public ArrayList<InOutPathClas> setList() {
        System.out.println("runSpec2xml() 시작");

        list.add(new InOutPathClas(obj.xslDir + "/dummy.xml", obj.tempF + "/00-line-feed.xml", obj.xslDir + "/00-line-feed.xsl"));
        list.add(new InOutPathClas(obj.tempF + "/00-line-feed.xml", obj.tempF + "/01-orginal-source.xml", obj.xslDir + "/01-extract-attr.xsl"));
        list.add(new InOutPathClas(obj.tempF + "/01-extract-attr.xml", obj.tempF + "/02-create-attr.xml", obj.xslDir + "/02-create-attr.xsl"));
        list.add(new InOutPathClas(obj.tempF + "/02-create-attr.xml", obj.tempF + "/03-space-between-quot.xml", obj.xslDir + "/03-space-between-quot.xsl"));
        list.add(new InOutPathClas(obj.tempF + "/03-space-between-quot.xml", obj.tempF + "/04-self-closing_IDpos.xml", obj.xslDir + "/04-self-closing_IDpos.xsl"));
        list.add(new InOutPathClas(obj.tempF + "/01-orginal-source.xml", obj.tempF + "/05-groupid-source.xml", obj.xslDir + "/05-groupid-source.xsl"));
        list.add(new InOutPathClas(obj.tempF + "/05-groupid-source.xml", obj.tempF + "/06-createXML-structure.xml", obj.xslDir + "/06-createXML-structure.xsl"));
        list.add(new InOutPathClas(obj.tempF + "/06-createXML-structure.xml", obj.tempF + "/07-trash-tagClean.xml", obj.xslDir + "/07-trash-tagClean.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/07-extract-styleInfo.xml", obj.tempF + "/08-make-styleinfo.xml", obj.xslDir + "/08-make-styleinfo.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/08-make-styleinfo.xml", obj.tempF + "/09-clear-styleinfo.xml", obj.xslDir + "/09-clear-styleinfo.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/07-trash-tagClean.xml", obj.tempF + "/10-attrname-define.xml", obj.xslDir + "/10-attrname-define.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/10-attrname-define.xml", obj.tempF + "/11-trash-tagClean.xml", obj.xslDir + "/11-trash-tagClean.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/11-trash-tagClean.xml", obj.tempF + "/12-grouping-inlineText.xml", obj.xslDir + "/12-grouping-inlineText.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/12-grouping-inlineText.xml", obj.tempF + "/13-insert-destinationkeys.xml", obj.xslDir + "/13-insert-destinationkeys.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/13-insert-destinationkeys.xml", obj.tempF + "/14-image-grouping.xml", obj.xslDir + "/14-image-grouping.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/14-image-grouping.xml", obj.tempF + "/14-nest-image.xml", obj.xslDir + "/14-nest-image.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/14-nest-image.xml", obj.tempF + "/15-grouping-SubList.xml", obj.xslDir + "/15-grouping-SubList.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/15-grouping-SubList.xml", obj.tempF + "/16-grouping-ULLlist.xml", obj.xslDir + "/16-grouping-ULLlist.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/16-grouping-ULLlist.xml", obj.tempF + "/17-grouping-OLLlist.xml", obj.xslDir + "/17-grouping-OLLlist.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/17-grouping-OLLlist.xml", obj.tempF + "/18-change-OLULtagName.xml", obj.xslDir + "/18-change-OLULtagName.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/18-change-OLULtagName.xml", obj.tempF + "/19-nested-OLUL.xml", obj.xslDir + "/19-nested-OLUL.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/19-nested-OLUL.xml", obj.tempF + "/20-grouping-ULOL.xml", obj.xslDir + "/20-grouping-ULOL.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/20-grouping-ULOL.xml", obj.tempF + "/21-delete-OLUL-umbering.xml", obj.xslDir + "/21-delete-OLUL-umbering.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/21-delete-OLUL-umbering.xml", obj.tempF + "/22-tableControl.xml", obj.xslDir + "/22-tableControl.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/22-tableControl.xml", obj.tempF + "/23-tableControl.xml", obj.xslDir + "/23-tableControl.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/23-tableControl.xml", obj.tempF + "/24-grouping-note.xml", obj.xslDir + "/24-grouping-note.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/24-grouping-note.xml", obj.tempF + "/25-grouping-noteList.xml", obj.xslDir + "/25-grouping-noteList.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/25-grouping-noteList.xml", obj.tempF + "/26-grouping-ULOL.xml", obj.xslDir + "/26-grouping-ULOL.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/26-grouping-ULOL.xml", obj.tempF + "/27-tagName-define.xml", obj.xslDir + "/27-tagName-define.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/27-tagName-define.xml", obj.tempF + "/28-grouping-para.xml", obj.xslDir + "/28-grouping-para.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/28-grouping-para.xml", obj.tempF + "/29-topicalize.xml", obj.xslDir + "/29-topicalize.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/29-topicalize.xml", obj.tempF + "/30-grouping-midtitle.xml", obj.xslDir + "/30-grouping-midtitle.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/30-grouping-midtitle.xml", obj.tempF + "/31-href-connection.xml", obj.xslDir + "/31-href-connection.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/31-href-connection.xml", obj.tempF + "/32-final-cleaner.xml", obj.xslDir + "/32-final-cleaner.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/32-final-cleaner.xml", obj.tempF + "/dummy.xml", obj.xslDir + "/33-search_js.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/32-final-cleaner.xml", obj.tempF + "/dummy.xml", obj.xslDir + "/34-search-html.xsl"));
    	list.add(new InOutPathClas(obj.tempF + "/32-final-cleaner.xml", obj.tempF + "/dummy.xml", obj.xslDir + "/35-split-html.xsl"));
    		
    	/*
    	try {
            executeXslt();
            System.out.println("xslt 작업 완료");
            list.clear();
            
        } catch(Exception e1) {
            list.clear();
            msg = "xslt 변환 실패"; 
            throw new RuntimeException(msg);
        }*/
        
    	System.out.println("setList 작업 완료");
    	return list;
    }
    
    public void executeXslt(InOutPathClas iopc) {
        System.out.println("executeXslt() 시작");
        
        try {
            ArrayList < InOutPathClas > remove = new ArrayList < > ();

            File inFile = new File(iopc.getinFile());
            File outFile = new File(iopc.getoutFile());
            File xslFile = new File(iopc.getxslFile());

            // System.out.println("inFile: " + inFile);
            // System.out.println("outFile: " + outFile);
            // System.out.println("xslFile: " + xslFile);

            if (xslFile.toString().contains("01-extract-attr")) {
                processBuilder();
                System.out.println("xslFile: " + xslFile + " 작업완료");

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

                    if (xslFile.toString().contains("00-line-feed")) {
                        tf.setParameter("filename", curFullPath);
                        tf.setParameter("outfoldername", obj.outFolderName);

                    } else if (xslFile.toString().contains("32-final-cleaner")) {
                        tf.setParameter("outputPath", obj.tarDir);

                    }

                    // xslt 프로세스 실행
                    tf.transform(inxml, outxml);

                } catch (Exception tf) {
                    System.out.println("Transformer 변환 실패");
                    msg = "Transformer 변환 실패";
                    throw new RuntimeException(msg);
                }

            }

            for (InOutPathClas name: remove) {
                list.remove(name);
            }
         
        } catch(Exception e) {
            System.out.println("xslt 변환 실패");
            msg = "xslt 변환 실패"; 
            throw new RuntimeException(msg);
        }
        
        System.out.println("xslt 변환 완료!!");
    }
    
    public void processBuilder() {
    	System.out.println("processBuilder() 시작");
    	
    	String libDir = obj.projectDir + File.separator + "bin/saxon9.jar";
    	System.out.println("libDir: " + libDir);
    	ProcessBuilder builder = new ProcessBuilder();
        
        // 환경변수 설정
        Map<String, String> env = builder.environment();
       
        env.put("CLASSPATH", libDir + ";%CLASSPATH%");

        String in = obj.tempF + "/00-line-feed.xml";
        String out = obj.tempF + "/01-orginal-source.xml";
        String xslt = obj.xslDir + "/01-extract-attr.xsl";
        
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
            
            // 프로세스 객체 내에 있는 서브프로세스를 강제로 종료
            process.destroy();
            
            return;
        } catch(Exception e) {
            // 에러 발생시 시스템 종료하기
            msg = "processBuilder 실행 실패"; 
            throw new RuntimeException(msg);
        } 
        
    }
    
}
