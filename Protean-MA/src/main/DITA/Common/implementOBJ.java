package main.DITA.Common;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class implementOBJ implements commonOBJ {
	public static String projectDir = "";
	public static String libDir = "";
	public static String languagesF = "";
	public static String optionListF = "";
	public static String ditaotS = "";
	public static String filterS = "";
	public static String ditaxsls = "";
	public static String catalogDir = "";
	public static String zDirlib = "";
	public static String zDiridmlTempls = "";
	public static String zDirhtmlTempls = "";
	public static String pdfSetting = "";
	public static String jdkDir = "";
	public static String saxonDir = "";
	public static String DiridmlTempls = "";
	public static String gsDir = "";
	public static String templateExcel = "";
	
	// **** fxOptionList.xml 데이터 추출 시작 ****
	public static List<String> templateList = new ArrayList<>();
	public static List<String> htmlList = new ArrayList<>();
	public static List<String> prodList = new ArrayList<>();
	public static Map<String, String> langMap = new HashMap<>();
	// **** fxOptionList.xml 데이터 추출 끝 ****
	
	
	

    @Override
    public void recursDel(Path path) throws Exception {
        System.out.println("recursDel() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {
                    try {
                        recursDel(a);
                        
                    } catch (Exception e) {
                        String msg = e.getMessage();
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                } else {
                    try {
                        Files.delete(a);
                        
                    } catch (IOException e) {
                        String msg = e.getMessage();
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                }
                
            });
            
            Files.delete(path);
            
            
        } catch(Exception e) {
            String msg = e.getMessage();
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
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
    public Document readFile(String file) throws Exception {
    	Document doc = null;
    	FileInputStream fis;
		try {
			fis = new FileInputStream(file);
			
			Reader reader = new InputStreamReader(fis, "UTF-8");
			
			InputSource is = new InputSource(reader);
	        is.setEncoding("UTF-8");

	        // DocumentBuilderFactory 객체를 생성하고, XML DOM 트리 구조로 파일 읽기
	        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	        DocumentBuilder db = dbf.newDocumentBuilder();
	        doc = db.parse(is);
			
			
		} catch (Exception e) {
			// implementObj -> readFile() 메소드 에러
			System.out.println("implementObj -> readFile() 메소드 에러");
			throw new Exception("implementObj -> readFile() 메소드 에러");
//			e.printStackTrace();
		}
		
        
        return doc;
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
    
    // 재귀적 파일 복사
    @Override
    public void dirCopy(Path newPath, Path oldPath) throws Exception {
        System.out.println("dirCopy() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(oldPath);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {                    
                    String getName = a.getFileName().toString();
                    Path newDir = Paths.get(newPath + File.separator + getName);
                    System.out.println("newDir: " + newDir);
                    
                    try {
                        System.out.println("폴더 생성");
                        
                        Files.createDirectories(newDir);
                        
                        // 재귀적 호출
                        dirCopy(newDir, a);
                        
                    } catch (Exception e) {
                        System.out.println("폴더 생성 실패");
                        e.printStackTrace();
                    }
                    
                } else if(Files.isRegularFile(a)) {
                    String getName = a.getFileName().toString();
//                    System.out.println("getName222:" + getName);
                    
                    Path parDir = a.getParent();
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
    
    @Override
    public String getDateTime() {
		System.out.println("getDateTime() 시작");
		
		LocalDateTime curDateTime = LocalDateTime.now();
        
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMddHHmmss"); 
        String str1 = curDateTime.format(dtf);
        System.out.println("str1: " + str1);
        
		return str1;
	}
    
    @Override
    public void moveFiles(Path form, Path to) {
        System.out.println("modeFiles() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(form);
            
            ds.forEach(a -> {
                if(Files.isRegularFile(a)) {
                    String getName = a.getFileName().toString();
//                  System.out.println("getName222:" + getName);
                  
                  Path parDir = a.getParent();
                  String newDir = to + File.separator + getName;
                  System.out.println("newDir: " + newDir);
                  
//                  File qdir = new File(a.toString());
                  Path qto = Paths.get(newDir);
                  
                  try {
//                      System.out.println("파일 복사!!!");
//                      Files.move(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.ATOMIC_MOVE);
                      Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                  } catch (IOException e) {
                      
                      e.printStackTrace();
                  }
                    
                    
                }

            });

        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    

}
