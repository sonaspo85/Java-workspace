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
    public void dirCopy(Path newPath, Path oldPath) throws Exception {
        System.out.println("dirCopy() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(oldPath);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {                    
                    // 파일 이름 추출
                    String getName = a.getFileName().toString();
                    
                    // 새로운 경로에 저장하기 위해 새 디렉토리 경로 생성
                    Path newDir = Paths.get(newPath + File.separator + getName);
                    System.out.println("newDir: " + newDir);
                    
                    try {
                        System.out.println("폴더 생성");
                        
                        // 폴더 생성
                        Files.createDirectories(newDir);
                        
                        // 재귀적 호출
                        dirCopy(newDir, a);
                        
                    } catch (Exception e) {
                        System.out.println("폴더 생성 실패");
                        e.printStackTrace();
                    }
                    
                } else if(Files.isRegularFile(a)) {
                    // 파일 이름 추출
                    String getName = a.getFileName().toString();
//                    System.out.println("getName222:" + getName);
                    
                    Path parDir = a.getParent();
                    
                    // 새로운 경로에 파일 복사 시키기 위해 새로운 경로 이름 생성
                    String newDir =  newPath + File.separator + getName;

                    Path qto = Paths.get(newDir);
                    
                    try {
                        //System.out.println("aa: " + a);
                        // System.out.println("bb: " + qto);
                        Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        
                    } catch (IOException e) {
                        
                        e.printStackTrace();
                    }
                }
                    
                    
            });
            
        } catch(Exception e) {
            System.out.println("implementObj -> dirCopy() 메소드 에러");
//            throw new Exception("implementObj -> dirCopy() 메소드 에러");
            e.printStackTrace();
        }
        
        
    }
    
    

}
