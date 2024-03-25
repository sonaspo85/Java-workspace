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
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {
                    try {
                        recursDel(a);
                        
                    } catch (Exception e) {
                        String msg = e.getMessage();
                        throw new RuntimeException(msg);
                    }
                    
                } else {
                    try {
                        Files.delete(a);
                        
                    } catch (IOException e) {
                        String msg = e.getMessage();
                        throw new RuntimeException(msg);
                    }
                }
                
            });
            
            Files.delete(path);
            
            
        } catch(Exception e) {
            String msg = e.getMessage();
            throw new RuntimeException(msg);
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
    public Document readFile(String file) throws Exception {
    	Document doc = null;
    	FileInputStream fis;
		try {
			fis = new FileInputStream(file);
			
			Reader reader = new InputStreamReader(fis, "UTF-8");
			
			InputSource is = new InputSource(reader);
	        is.setEncoding("UTF-8");
	        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	        DocumentBuilder db = dbf.newDocumentBuilder();
	        doc = db.parse(is);
			
			
		} catch (Exception e) {
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
    
    @Override
    public String getDateTime() {
		LocalDateTime curDateTime = LocalDateTime.now();
        
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMddHHmmss"); 
        String str1 = curDateTime.format(dtf);
		return str1;
	}
    
    @Override
    public void moveFiles(Path form, Path to) {
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(form);
            
            ds.forEach(a -> {
                if(Files.isRegularFile(a)) {
                    String getName = a.getFileName().toString();
                  
                  Path parDir = a.getParent();
                  String newDir = to + File.separator + getName;
                  System.out.println("newDir: " + newDir);
                  Path qto = Paths.get(newDir);
                  
                  try {
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
			Transformer trans = tff.newTransformer();
			trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			trans.setOutputProperty(OutputKeys.INDENT, "no");
			trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
			
			// 3. DOMSource 객체 생성
			DOMSource source = new DOMSource(doc);
			File outFile = new File(filePath);
			StreamResult result = new StreamResult(outFile); 
			trans.transform(source, result);
			result.getOutputStream().close();

		} catch(Exception e1) {
			e1.printStackTrace();
		}
	}
    
    

}
