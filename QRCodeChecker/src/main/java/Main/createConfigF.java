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
        System.out.println("runProps() 시작");
        
        // 1. properties 파일이 저장될 위치 지정
        File projectDir = new File("");
       
        File propf = new File(projectDir.getAbsoluteFile() + File.separator + "config.properties");
        System.out.println("propf: " + propf);
        
        // 2. 파일 생성
        if(!propf.exists()) {
            System.out.println("properties 파일 생성하기");
            createPropertyFile(propf);
        }
        
        // 3. Properties 객체 생성
        String path = Paths.get(propf.toString()).toString();
        
        // 4. Reader 문자 입력 스트림으로 파일 읽기 준비
        Reader reader = new FileReader(path);
        
        // 5. URLDecoder 클래스의 decode() 메소드를 호출하여, 파일의 인코딩 변경
        URLDecoder.decode(path, "UTF-8");
        
        // 6. Properties 객체의 load() 메소드를 호출 하여 propf 변수를 인수로 할당하여 객체 로드
        pro.load(reader);
        
        // 7. getProperty() 메소드로 키 객체에 대한 값 객체 추출하여 변수에 저장
        obj.propfSrcZipF = pro.getProperty("propfSrcZipF");
        obj.propfTarZipF = pro.getProperty("propfTarZipF");
        
    }
    
    public void setkeyNvals(String propfSrcZipF, String propfTarZipF) {
        System.out.println("setkeyNvals() 시작");
        
        // config.properties 파일에 키객체에 대한 값객체 할당 하기
        pro.setProperty("propfSrcZipF", propfSrcZipF);
        pro.setProperty("propfTarZipF", propfTarZipF);
        
        // properties 파일 저장하기
        try {
            File projectDir = new File("");
            File propf = new File(projectDir.getAbsoluteFile() + File.separator + "config.properties");
            OutputStream os = new FileOutputStream(propf);
            
            pro.store(os, null);
            
        } catch(Exception e) {
            System.out.println("config.properties 파일 생성 실패");
            e.printStackTrace();
            
        }
        
    }
    
    public void createPropertyFile(File propf) {
        System.out.println("createPropertyFile() 시작");
        
        try {
            if(!propf.exists()) {
                System.out.println("config.properties 파일이 없습니다. 파일을 생성 합니다.");
                
                propf.createNewFile();
                
            } else {
                System.out.println("파일이 존재 합니다.");
            }
            
            
            
        } catch(Exception e) {
            System.out.println("config.properties 생성을 실패 하였습니다.");
            e.printStackTrace();
            
        }
        
    }
    
    
}
