package main.java.satisfy.Common;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import main.java.satisfy.modules.Company;

public class implementOBJ implements commonOBJ {
    public static String srcDir = "";
    public static String projectDir = "";
    public static String dbDir = "";
    public static String teplsDir = "";
    public static String tempDir = "";
    public static String excelXDir = "";
    public static ObservableList<Company> totalList1 = FXCollections.observableArrayList();
    public static ObservableList<Company> totalList2 = FXCollections.observableArrayList();
    public static ObservableList<Company> totalList3 = FXCollections.observableArrayList();
    public static ObservableList<Company> totalList4 = FXCollections.observableArrayList();
    public static ObservableList<Company> totalList5 = FXCollections.observableArrayList();
    public static ObservableList<Company> totalList6 = FXCollections.observableArrayList();
    
    public static Map<Integer, List<String>> tv1Map = new HashMap<>();
    public static Map<Integer, List<String>> tv2Map = new HashMap<>();
    public static Map<Integer, List<String>> tv3Map = new HashMap<>();
    public static Map<Integer, List<String>> tv4Map = new HashMap<>();
    public static Map<Integer, List<String>> tv5Map = new HashMap<>();
    public static Map<Integer, List<String>> tv6Map = new HashMap<>();
    
    public static List<String> perList = new ArrayList<>();
    
    public static List<String> excelDBF = new ArrayList<>();
    public static List<String> finalDBF = new ArrayList<>();
    
    public static Map<Integer, Map<String, List<String>>> finalDBmap = new HashMap<>();
    
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
    public void dirCopy(Path newPath, Path oldPath) throws Exception {
        System.out.println("dirCopy() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(oldPath);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {                    
                    String getName = a.getFileName().toString();
                    Path newDir = Paths.get(newPath + File.separator + getName);
                    
                    try {
                        Files.createDirectories(newDir);
                        dirCopy(newDir, a);
                        
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    
                } else if(Files.isRegularFile(a)) {
                    String getName = a.getFileName().toString();
                    Path parDir = a.getParent();
                    String newDir =  newPath + File.separator + getName;
                    Path qto = Paths.get(newDir);
                    
                    try {
                        Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                    
                    
            });
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        
    }
    
    

}
