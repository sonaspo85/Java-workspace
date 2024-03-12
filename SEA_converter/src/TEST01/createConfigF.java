package TEST01;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.URLDecoder;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;



public class createConfigF {
    Properties pro = new Properties();
    String modelStr, version, lang = "";
    String packageDir = "";
    File propf = null;
    
    public createConfigF(String modelStr, String version, String lang) {
        this.modelStr = modelStr;
        this.version = version;
        this.lang = lang;
        
        File file = new File("");
        packageDir = file.getAbsolutePath();
        propf = new File(packageDir +  "/config.properties");
    }
    
    public createConfigF() {
        File file = new File("");
        packageDir = file.getAbsolutePath();
        propf = new File(packageDir +  "/config.properties");
    }
    
    public List<String> readProps() {
        System.out.println("readProps() 시작");
        List<String> list = new ArrayList<>();
        
        // Properties 객체 생성
        String path = Paths.get(propf.toString()).toString();
        
        // Reader 문자 스트림으로 파일 읽기
        try {
            Reader reader = new FileReader(path);
         
            // URLDecoder 클래스의 decode() 메소드를 호출하여 파일의 인코딩 변경
            URLDecoder.decode(path, "utf-8");
            
            // Properties.load() 메소드는 매개변수로 Reader 타입을 할당 받는다.
            pro.load(reader);
        
            // getProperty() 메소드로 키 객체에 대한 값객체 추출
            modelStr = pro.getProperty("modelStr");
            version = pro.getProperty("version");
            lang = pro.getProperty("lang");
            
            System.out.println("modelStr: " + modelStr);
            System.out.println("version: " + version);
            System.out.println("lang: " + lang);
            
            
            list.add(modelStr);
            list.add(version);
            list.add(lang);
            
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        return list;
    }
    
    
    
    public void runProps() throws Exception {
        System.out.println("runProps() 시작");

        // 파일 생성
        if(!propf.exists()) {            
            System.out.println("파일 생성 하기");
            createPropertyFile(propf);
            
        } 
        
        // Properties 객체 생성
        
/*
        String path = Paths.get(propf.toString()).toString();
        
        // Reader 문자 스트림으로 파일 읽기
        Reader reader = new FileReader(path);
        
        // URLDecoder 클래스의 decode() 메소드를 호출하여 파일의 인코딩 변경
        URLDecoder.decode(path, "utf-8");
        
        // Properties.load() 메소드는 매개변수로 Reader 타입을 할당 받는다.
        pro.load(reader);

        // getProperty() 메소드로 키 객체에 대한 값객체 추출
        obj.idmlzipP = pro.getProperty("idmlzipP");
        obj.specSampleP = pro.getProperty("specSampleP");
        obj.spec2xmlP = pro.getProperty("spec2xml");
*/
        
        setkeyNvals();
    }
    
    public void setkeyNvals() throws Exception {
        System.out.println("setkeyNvals() 시작");
        
        // config.properties 파일에 키객체에 대한 값 객체 할당 하기
        pro.setProperty("modelStr", modelStr);
        pro.setProperty("version", version);
        pro.setProperty("lang", lang);
        
        
        try {
            // properties file 저장하기
            OutputStream output = new FileOutputStream(propf);
            
            pro.store(output, null);
            
        } catch(Exception e) {
            throw new Exception("config.properties 출력 실패");
        }
        
    }
    
    public void createPropertyFile(File propf) throws Exception {
        try {
            if(!propf.exists()) {
                System.out.println("aaa.properties 파일이 없습니다. 파일을 생성 합니다.");
                propf.createNewFile();
                
            } else {
                System.out.println("파일이 존재 합니다.");
                
            }
            
        } catch(Exception e) {
            System.out.println("config.properties 생성을 실패 하였습니다.");
            throw new Exception("config.properties 생성을 실패 하였습니다.");
        }
        
    }
    

}
