package main.java.zipController.Common;

import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;

public class implementOBJ implements commonOBJ {
    public static String srcDir = "";
    public static String srcFileName = "";
    public static String packageDir = "";
    public static String modelStr = "";
    public static String productStr = "";
    public static String opticalStr = "";
    public static String idmlzipP = "";
    public static String specSampleP = "";
    public static String spec2xmlP = "";
    public static String validationF = "";
    public static String languagesF = "";
    public static String resultDoc = "";
    public static String outExcelPath = "";
    public static String programVer = "";
    public static String fileRegion = "";
    

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

}
