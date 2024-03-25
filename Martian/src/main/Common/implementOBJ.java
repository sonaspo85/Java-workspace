package main.Common;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.Charset;
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
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class implementOBJ implements commonOBJ {
	public static String projectDir = "";
	public static Path srcPathP = null;
	public static Path resourceDir = null;
	public static Path tempDir = null;
	public static Path xslsDir = null;
	public static Path zipDirP = null;
	public static Path eachSrcP = null;
	public static Path excelTemplsPathP = null;
	public static Charset charset = Charset.forName("UTF-8");
	public static List<Path> srcDirFullpath = new ArrayList<>();
	public static List<String> workISO = new ArrayList<>();
	public static Map<String, String> matchlangMap = new HashMap<>();
	public static String type = "";
	public static String ver = "";
	public static String ridioTxt = "";
	public static String remoteswitch = "";
	public static String remoconTxt = "";
	public static String manualType = "";
	public static String modelNumber = "";
	public static List<String> langL2 = new ArrayList<>();
	

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
            
        } else {
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
    
    @Override
	public void xmlTransform(String filePath, Document doc) {
        System.out.println("xmlTransform() 시작: " + filePath);
		try {
			// 1. TransformerFactory 객체 생성
			TransformerFactory tff = TransformerFactory.newInstance();
			
			// 2. Transformer 객체 생성
			Transformer trans = tff.newTransformer();
			
			// 출력 속성 설정
			trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			trans.setOutputProperty(OutputKeys.INDENT, "no");
			trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
			
			// 3. DOMSource 객체 생성
			DOMSource source = new DOMSource(doc);
			
			File outFile = new File(filePath);
			
			// 4. 출력 결과를 스트림으로 생성
			StreamResult result = new StreamResult(outFile); 

			// 4. transform() 메소드 호출
			trans.transform(source, result);
			result.getOutputStream().close();

		} catch(Exception e1) {
			e1.printStackTrace();
		}
	}
    
    

}
