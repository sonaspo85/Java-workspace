package main.java.Main;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.URLDecoder;
import java.nio.file.Paths;
import java.util.Properties;

import main.java.CommonObj.implementOBJ;

public class createConfigF {
    implementOBJ obj = new implementOBJ();
    Properties pro = new Properties();
    
    
    public void runProps() throws Exception {
        File projectDir = new File("");
        File propf = new File(projectDir.getAbsoluteFile() + File.separator + "config.properties");
        
        // 파일 생성
        if(!propf.exists()) {
            createPropertyFile(propf);
        }
        
        String path = Paths.get(propf.toString()).toString();
        // Reader 문자 입력 스트림으로 파일 읽기 준비
        Reader reader = new FileReader(path);
        URLDecoder.decode(path, "UTF-8");
        pro.load(reader);
        
        // getProperty() 메소드로 키 객체에 대한 값 객체 추출하여 변수에 저장
        obj.propfSrcZipF = pro.getProperty("propfSrcZipF");
        obj.propfTarZipF = pro.getProperty("propfTarZipF");
        
    }
    
    public void setkeyNvals(String propfSrcZipF, String propfTarZipF) {
        pro.setProperty("propfSrcZipF", propfSrcZipF);
        pro.setProperty("propfTarZipF", propfTarZipF);
        
        // properties 파일 저장
        try {
            File projectDir = new File("");
            File propf = new File(projectDir.getAbsoluteFile() + File.separator + "config.properties");
            OutputStream os = new FileOutputStream(propf);
            
            pro.store(os, null);
            
        } catch(Exception e) {
            e.printStackTrace();
            
        }
        
    }
    
    public void createPropertyFile(File propf) {
        try {
            if(!propf.exists()) {
                propf.createNewFile();
                
            } else {
            }
            
            
            
        } catch(Exception e) {
            e.printStackTrace();
            
        }
        
    }
    
    
}
