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

public class transformXSLT2 {
    implementOBJ obj = new implementOBJ();
    public ArrayList<InOutPathClas> list = new ArrayList<>();
    
    String msg = "";
    
    public transformXSLT2() {

    }
    
    
    public void runDBF() {
        System.out.println("runDBF() 시작");
        
//        obj.multiSearchSrcDir = "H:/WORK/kohyung/kohyoung-searchDB/resource";
        System.out.println("obj.multiSearchSrcDir: " + obj.multiSearchSrcDir);
        
        list.add(new InOutPathClas(obj.xslDir + "/dummy.xml", obj.multiSearchSrcDir + "/_db/search_db.js", obj.xslDir + "/01-marged.xsl"));
        
    	try {
            executeXslt();
            System.out.println("xslt 작업 완료");
            list.clear();
            
        } catch(Exception e1) {
            list.clear();
            msg = "xslt 변환 실패"; 
            throw new RuntimeException(msg);
        }
        
    	System.out.println("runSpec2xml 작업 완료");

    }
    
    public void executeXslt() {
        System.out.println("executeXslt() 시작");
        
        ArrayList<InOutPathClas> remove = new ArrayList<>();

        for(int j=0; j<list.size(); j++) {
        	System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
            InOutPathClas iopc = list.get(j);
            
            File inFile = new File(iopc.getinFile());
            File outFile = new File(iopc.getoutFile());
            File xslFile = new File(iopc.getxslFile());
        	
//            System.out.println("inFile: " + inFile);
//            System.out.println("outFile: " + outFile);
//            System.out.println("xslFile: " + xslFile);
            
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
                
                tf.setParameter("targetPath", obj.multiSearchSrcDir);
                
                // xslt 프로세스 실행
                tf.transform(inxml, outxml);
                
            } catch(Exception tf) {
                System.out.println("xslt 변환 실패");
                msg = "xslt 변환 실패"; 
                throw new RuntimeException(msg);
            }
            
            for (InOutPathClas name : remove) {
            	list.remove(name);
            } 
                 
        }

        System.out.println("xslt 변환 완료!!");
    }
    
    public void processBuilder() {
    	System.out.println("processBuilder() 시작");
    	
    	String libDir = obj.projectDir + File.separator + "lib/saxon9.jar";
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
