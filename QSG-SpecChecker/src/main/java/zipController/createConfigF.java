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
        File propf = new File(obj.packageDir +  "/config.properties");

        // 파일 생성
        if(!propf.exists()) {            
            createPropertyFile(propf);
            
        } 
        
        String path = Paths.get(propf.toString()).toString();
        
        // Reader 문자 스트림으로 파일 로드
        Reader reader = new FileReader(path);
        URLDecoder.decode(path, "utf-8");
        pro.load(reader);
        String idmlzipS = pro.getProperty("idmlzipP");
        String specSampleS = pro.getProperty("specSampleP");
        String spec2xmlS = obj.packageDir + File.separator + "resource/spec2xml-data.xlsm";

        obj.idmlzipP = idmlzipS;
        obj.specSampleP = specSampleS;
        obj.spec2xmlP = spec2xmlS;

    }
    
    public void setkeyNvals(String idmlzip, String specSample, String spec2xml) throws Exception {
        String idmlzipS = idmlzip.replace("\\", "/");
        String specSampleS = specSample.replace("\\", "/");
        String spec2xmlS = obj.packageDir + File.separator + "resource/spec2xml-data.xlsm";
        pro.setProperty("idmlzipP", idmlzipS);
        pro.setProperty("specSampleP", specSampleS);
        pro.setProperty("spec2xml", spec2xmlS);
        
        
        try {
            // properties file 저장
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
                propf.createNewFile();
                
            } else {
            }
            
        } catch(Exception e) {
            throw new customException("config.properties 생성을 실패 하였습니다.");
        }
        
    }
    

}
