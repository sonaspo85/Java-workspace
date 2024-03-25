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
            URLDecoder.decode(path, "utf-8");
            pro.load(reader);
        
            // getProperty() 메소드로 키 객체에 대한 값객체 추출
            modelStr = pro.getProperty("modelStr");
            version = pro.getProperty("version");
            lang = pro.getProperty("lang");
            
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
        // 파일 생성
        if(!propf.exists()) {            
            createPropertyFile(propf);
            
        } 

        setkeyNvals();
    }
    
    public void setkeyNvals() throws Exception {
        pro.setProperty("modelStr", modelStr);
        pro.setProperty("version", version);
        pro.setProperty("lang", lang);
        
        
        try {
            OutputStream output = new FileOutputStream(propf);
            pro.store(output, null);
            
        } catch(Exception e) {
            throw new Exception("config.properties 출력 실패");
        }
        
    }
    
    public void createPropertyFile(File propf) throws Exception {
        try {
            if(!propf.exists()) {
                propf.createNewFile();
                
            } else {
            }
            
        } catch(Exception e) {
            throw new Exception("config.properties 생성을 실패 하였습니다.");
        }
        
    }
    

}
