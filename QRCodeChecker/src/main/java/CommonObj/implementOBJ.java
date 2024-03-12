package main.java.CommonObj;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.StringTokenizer;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;

public class implementOBJ implements commonOBJ {
    public static Path srcDir = null;
    public static Path tarDir = null;
    
    public static String langSrc = "";
    public static String langTar = "";
    
    public static String srcName = "";
    public static String tarName = "";
    
    public static String zipName = "";
    public static String curFirstZipDirs = "";
    
    public static String curXMLDir = "";
    public static String tempDir = "";
    
    // 추후 추출할 변수 qrCodeUrlSrc, qrCodeUrlTar, modelNameSrc, modelNameTar, meterialDBSrc, meterialDBTrc
    public static String qrCodeUrlSrc = "";
    public static String qrCodeUrlTar = "";
    public static String qrCodeImgSrc = "";
    public static String qrCodeImgTar = "";
    
    public static String modelNameSrc = "";
    public static String modelNameTar = "";
    
    public static String meterialValSrc = "";
    public static String meterialValTar = "";
    public static String meterialDBSrc = "";
    public static String meterialDBTar = "";
    
    public static String propfSrcZipF = "";
    public static String propfTarZipF = "";
    
    
    @Override
    public void recursDel(Path path) {
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {
                    recursDel(a);
                    
                } else {
                    try {
                        Files.delete(a);
                        
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                
            });
            
            Files.delete(path);
            
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
    }
    
    @Override
    public void createNewDir(Path newPath) throws Exception {
        if(Files.notExists(newPath)) {
            Files.createDirectories(newPath);
            System.out.println("폴더 생성 완료!");
            
        } else {  // 폴더가 존재 한다면 재귀적 삭제 후, 폴더 재생성
            recursDel(newPath);
            Files.createDirectories(newPath);
        }
    }
    
    @Override
    public Document createDOM() throws Exception {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();

        Document doc = db.newDocument();
        doc.setXmlStandalone(true);

        return doc;
    }
    
    @Override
    public void xmlTransform(String mergedDir, Document doc) {
        try {
            // 1. Transformer 객체 생성
            TransformerFactory tff = TransformerFactory.newInstance();
            
            // 2. Transformer 객체 생성
            Transformer trans = tff.newTransformer();
            trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            trans.setOutputProperty(OutputKeys.INDENT, "no");
            trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
            
            // 3. DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
            
            File outFile = new File(mergedDir);
            Result result = new StreamResult(outFile);
            
            // 4. transform() 메소드 호출
            trans.transform(source, result);
            ((StreamResult) result).getOutputStream().close();
            
        } catch(Exception e1) {
            e1.printStackTrace();
        }
    }
    
    @Override
    public String compareModelName(String srcModelname, String srcQrUrl) {
    	System.out.println("compareModelName() 시작");
    	
    	String result = "";
    	// 5. 영문 modelname 과 url 비교
    	if(srcModelname != "" & srcQrUrl != "") {
    	    if(srcModelname.contains(", ")) {
    	        // 1. StringTokenizer 클래스로 문자열 분리 하기
    	        StringTokenizer st = new StringTokenizer(srcModelname, ", "); 
    	        
    	        int cnt = st.countTokens();
    	        for(int i=0; i< cnt; i++) {
    	            // 토큰 꺼내기 - nextToken() 메소드 
    	            String token = st.nextToken();
    	            System.out.println("token: " + token);
    	            
    	            if(srcQrUrl.contains(token)) {
    	            	result = "True";
    	                System.out.println("uuuuuuu");
    	                break;
    	                
    	            } else {
    	            	result = "Fail";
    	                System.out.println("iiiiiii");
    	            }
    	                
    	        }
    	        
    	    } else {  // 모델 이름이 1개만 존재 하는 경우
    	        if(srcQrUrl.contains(srcModelname)) {
    	        	result = "True";
    	            
    	        } else {
    	        	result = "Fail";
    	        }
    	        
    	    }

    	} 
    	
    	return result;
    }
}
