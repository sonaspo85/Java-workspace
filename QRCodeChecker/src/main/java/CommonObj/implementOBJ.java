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
            
        } else {
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
            // Transformer 객체 생성
            TransformerFactory tff = TransformerFactory.newInstance();
            
            Transformer trans = tff.newTransformer();
            trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            trans.setOutputProperty(OutputKeys.INDENT, "no");
            trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
            
            // DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
            File outFile = new File(mergedDir);
            Result result = new StreamResult(outFile);
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
    	// 영문 modelname 과 url 비교
    	if(srcModelname != "" & srcQrUrl != "") {
    	    if(srcModelname.contains(", ")) {
    	        StringTokenizer st = new StringTokenizer(srcModelname, ", "); 
    	        
    	        int cnt = st.countTokens();
    	        for(int i=0; i< cnt; i++) { 
    	            String token = st.nextToken();
    	            
    	            if(srcQrUrl.contains(token)) {
    	            	result = "True";
    	                break;
    	                
    	            } else {
    	            	result = "Fail";
    	            }
    	                
    	        }
    	        
    	    } else {
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
