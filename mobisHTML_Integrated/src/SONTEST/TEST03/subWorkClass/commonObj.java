package SONTEST.TEST03.subWorkClass;

import java.io.File;
import java.io.IOException;
import java.io.Reader;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Optional;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class commonObj implements commonInterface {
    private File file = null;
    public static String inch = null;
    public static String company = null;
    public static String lang = null;
    public static String excelLang = null;
    public static String version = null;
    public static String ccncVer = null;
    
    public static String dataLanguage = null;
    public static String isoCode = null;
    public static String lgsRegion = null;
    public static String carName = null;
    public static String region = null;

    public String exePath = new File("").getAbsolutePath();
    public static String mergedPath = null;
    
    // 파일 사이즈 생성
    @Override
    public String createSize(File file) {
        long fileSize = file.length();
        DecimalFormat df = new DecimalFormat("0.00");

        float sizeKb = 1024.0f;
        float sizeMb = sizeKb * sizeKb;
        float sizeGb = sizeMb * sizeKb;
        float sizeTerra = sizeGb * sizeKb;
       
        String size;
        if(fileSize < sizeMb) {
            size = df.format(fileSize / sizeKb)+ " Kb";
        } else if(fileSize < sizeGb) {
            size = df.format(fileSize / sizeMb) + " Mb";
        } else if (fileSize < sizeTerra) {
            size = df.format(fileSize / sizeGb) + " Gb";
        } else {
            size = df.format(fileSize) + " Byte";
        }
        
        return size;
    }
    
    // 날짜 생성
    @Override
    public String createDate(File file) {
        long lastEditDate = file.lastModified();
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy년MM월dd일 HH:mm"); 
        
        String formatDate = sdf.format(lastEditDate);
        
        return formatDate;
    }
    
    @Override
    public boolean getExtensionCheck(String str) {
        String fileName = str;

        Optional<String> optional = Optional.ofNullable(fileName); 
        
        // 파일객체들만 필터링
        Optional<String> optFilter = optional.filter(a -> a.contains("."));
        String extention = optFilter.map(a -> a.substring(fileName.lastIndexOf(".") + 1)).get();
        
        if(extention.equals("xml") || extention.equals("xlsx") || extention.equals("xls") || extention.equals("idml")) {
            return true;
        } else {
            return false;
        }
    }
    
    @Override
    public String getExt(File absolutePath) {
        Optional<File> optional = Optional.ofNullable(absolutePath); 
        Optional<File> optFilter = optional.filter(a -> a.getName().contains("."));
         
        int pos = absolutePath.getName().lastIndexOf(".") + 1;
        String extention = optFilter.map(a -> a.getName().substring(pos)).get();
        
        return "." + extention;
    }
    
    @Override
    public void copyFolder(File QDirs, File Qto) {
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
                    e.printStackTrace();
                }
                
            }
            
        }
        
    }
    
    @Override
    public void delteFolder(Path delFolder) throws Exception {
        DirectoryStream<Path> subEntry = Files.newDirectoryStream(delFolder);
        
        subEntry.forEach(a -> {
            Path fileName = a.getFileName();
            
            try {
                if(Files.isDirectory(a)) {
                    delteFolder(a);
                    
                } else if(Files.isRegularFile(a)) {
                    Files.delete(a);
                }
                
            } catch(Exception e1) {
                
            }

        });
        
        Files.delete(delFolder);
    }
    
    @Override
    public Document createDomObj(Object obj) throws Exception {
        // DOM 트리 객체 생성 하기
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        
        Document doc = null;
        if(obj instanceof Reader) {
            Reader reader = (Reader) obj;
            InputSource is = new InputSource(reader);
            is.setEncoding("UTF-8");
            
            doc = db.parse(is);
            
        } else {
            doc = db.newDocument();
        }
        
        doc.setXmlStandalone(true);
        
        return doc;
    }
}
