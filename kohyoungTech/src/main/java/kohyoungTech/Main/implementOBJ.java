package main.java.kohyoungTech.Main;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

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
    public static String projectDir = "";
    public static String xslDir = "";
    public static String codesF = "";
    public static String tempF = "";
    public static String srcDir = "";
    public static String tarDir = "";
    public static String curFileName = "";
    public static String curLastLang = "";
    public static String outFolderName = "";
    public static String templateType = "";
    public static String templateDir = "";
    public static String multiSearchSrcDir = "";
    public static List<String> lgnsList = new ArrayList<String>();
    public static LinkedHashSet<String> multiFolderLang = new LinkedHashSet<>();
    public static Map<String, String> opMap = new HashMap<>();
    public static String multiTemplateDir = "";
    
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
    public void copyFolder(File QDirs, File Qto) {
        System.out.println("copyFolder() 시작");
        
        File[] Qfiles = QDirs.listFiles();
        
        for(File fileVal : Qfiles) {
            File temp = new File(Qto.getAbsoluteFile() + File.separator + fileVal.getName());
            
            if(fileVal.isDirectory()) {
                temp.mkdir();
                copyFolder(fileVal, temp);
            } else {
                String fileName = fileVal.getName();
                Path from = Paths.get(fileVal.toURI());
                Path to = Paths.get(temp.toURI());
                
                try {
                    Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                
            }
            
        }
        
    }
}
