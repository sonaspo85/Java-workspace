package main.java.zipController;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.URLDecoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;

import main.java.zipController.Common.implementOBJ;

public class createConfigF {
    implementOBJ obj = new implementOBJ();
    Properties pro = new Properties();
    
    public void runProps() throws Exception {
        System.out.println("runProps() 시작");
        File propf = new File(obj.packageDir +  "/config.properties");

        // 파일 생성
        if(!propf.exists()) {            
            System.out.println("파일 생성 하기");
            createPropertyFile(propf);
            
        } 
        
        // Properties 객체 생성
        String path = Paths.get(propf.toString()).toString();
        
        // Reader 문자 스트림으로 파일 읽기
        Reader reader = new FileReader(path);
        
        // URLDecoder 클래스의 decode() 메소드를 호출하여 파일의 인코딩 변경
        URLDecoder.decode(path, "utf-8");
        
        // Properties.load() 메소드는 매개변수로 Reader 타입을 할당 받는다.
        pro.load(reader);
        
        
        String idmlzipS = pro.getProperty("idmlzipP");
        String specSampleS = pro.getProperty("specSampleP");
//        String spec2xmlS = pro.getProperty("spec2xml");
        String spec2xmlS = obj.packageDir + File.separator + "resource/spec2xml-data.xlsm";

        // getProperty() 메소드로 키 객체에 대한 값객체 추출
        obj.idmlzipP = idmlzipS;
        obj.specSampleP = specSampleS;
        obj.spec2xmlP = spec2xmlS;

    }
    
    public void setkeyNvals(String idmlzip, String specSample, String spec2xml) throws Exception {
        System.out.println("setkeyNvals() 시작");
        
        String idmlzipS = idmlzip.replace("\\", "/");
        String specSampleS = specSample.replace("\\", "/");
//        String spec2xmlS = spec2xml.replace("\\", "/");
        String spec2xmlS = obj.packageDir + File.separator + "resource/spec2xml-data.xlsm";

        // config.properties 파일에 키객체에 대한 값 객체 할당 하기
        pro.setProperty("idmlzipP", idmlzipS);
        pro.setProperty("specSampleP", specSampleS);
        pro.setProperty("spec2xml", spec2xmlS);
        
        
        try {
            // properties file 저장하기
            File propf = new File(obj.packageDir +  "/config.properties");
            OutputStream output = new FileOutputStream(propf);
            
            pro.store(output, null);
            
        } catch(Exception e) {
            throw new customException("config.properties 출력 실패");
        }
        
    }
    
    public void createPropertyFile(File propf) throws Exception {
        try {
            if(!propf.exists()) {
                System.out.println("config.properties 파일이 없습니다. 파일을 생성 합니다.");
                propf.createNewFile();
                
            } else {
                System.out.println("파일이 존재 합니다.");
                
            }
            
        } catch(Exception e) {
            System.out.println("config.properties 생성을 실패 하였습니다.");
            throw new customException("config.properties 생성을 실패 하였습니다.");
        }
        
    }
    

}
