package TEST01;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.MessageFormat;
import java.util.List;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class xslTransform {
    List<IOXclasses> list = null;
    String modelStr;
    String lang;
    String srcPath;
    static String defaultOutFolder = null;
    String switch1 = "";
    String projectDir = "";
    
    public xslTransform(List<IOXclasses> list, String srcPath, String switch1) {
        this.list = list;
        this.srcPath = srcPath;
        this.switch1 = switch1; 
        
        File file = new File("");
        projectDir = file.getAbsolutePath();
    }
    
    public xslTransform(List<IOXclasses> list, String modelStr, String lang, String srcPath, String switch1) {
        this.list = list;
        this.modelStr = modelStr;
        this.lang = lang;
        this.srcPath = srcPath;
        this.switch1 = switch1;
        
        File file = new File("");
        projectDir = file.getAbsolutePath();
    }
    
    public void runXslt() throws Exception {
        for(IOXclasses eachVal : list) {
            File inFile = new File(eachVal.in);
            File outFile = new File(eachVal.out);
            File xslFile = new File(eachVal.xslt);
            
            Source inXml = new StreamSource(inFile);
            Result outXml = new StreamResult(outFile);
            Source xslt = new StreamSource(xslFile);
            
            System.setProperty("javax.xml.transform.TransformereFactory", "net.sf.saxon.TransformerFactoryImpl");
            
            // TransformerFactory 클래스를 사용하여 Transformer 객체 생성 하기 
            TransformerFactory factory = TransformerFactory.newInstance();
            
            try {
                Transformer tf = factory.newTransformer(xslt);
                try {
                    if(switch1.equals("html")) {
                        tf.setParameter("language", lang);
                        tf.setParameter("model", modelStr);
                    }
                    
                    tf.transform(inXml, outXml);
                    
                    try {
                        Thread.sleep(10);
                        System.out.println("xslt 변환 완료");
                        
                    } catch(Exception e1) {
//                        e1.printStackTrace();
                        String msg = e1.getMessage();
                        String result = "xslTransform.java: {0} 예외 발생";
                        String result1 = MessageFormat.format(result, msg);
                        throw new Exception(result1);
                    }
                    
                } catch(Exception e2) {
                    String msg = e2.getMessage();
                    String result = "xslTransform.java: {0} 예외 발생";
                    String result1 = MessageFormat.format(result, msg);
                    throw new Exception(result1);
                }
                
            } catch(Exception e3) {
                String msg = e3.getMessage();
                String result = "xslTransform.java: {0} 예외 발생";
                String result1 = MessageFormat.format(result, msg);
                throw new Exception(result1);
            }

            if(outFile.getName().equals("finalize.html")) {
                defaultOutFolder = outFile.getParent();
                
                Path from = Paths.get(outFile.toURI());
                Path to = Paths.get(srcPath + "/finalize.html");                
                
                try {
                    Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                    
                    // temp 폴더내 final 파일 삭제
                    Files.delete(from);
                    
                } catch (Exception e4) {
                    String msg = e4.getMessage();
                    String result = "xslTransform.java: {0} 예외 발생";
                    String result1 = MessageFormat.format(result, msg);
                    throw new Exception(result1);
                }
            }
        }
         
    }
    
    // resource 폴더 복사
    public void copyTemplates(File eachF) throws Exception {
        File file = new File("");
        String templatesDir = file.getAbsolutePath() + "\\templates\\";
        String fromTemplateF = templatesDir;
        Path fromTemplateF01 = Paths.get(fromTemplateF).normalize();
        String toTemplateF = null;
        File[] fromF = null;
        
        if(eachF == null) {
            fromF = new File(fromTemplateF01.toString()).listFiles();
            
        } else {
            Path eachFAb = Paths.get(eachF.toURI()).normalize();
            fromF = new File(eachFAb.toString()).listFiles();
            String toTemplateF00 = eachFAb.toString().replace(fromTemplateF01.toString(), "");
            toTemplateF = srcPath + "\\output" + toTemplateF00;
        }
        
        
        
        
        for(File eachFF : fromF) {
            String relativeFolder = eachFF.toString().replace(fromTemplateF01.toString(), "");
            toTemplateF = srcPath + "\\output\\" + relativeFolder;
            File toCopy = new File(toTemplateF);
            
            if(eachFF.isDirectory()) {
                toCopy.mkdirs();
                copyTemplates(eachFF);
                
            } else {
                Path from = Paths.get(eachFF.toURI());
                Path to = Paths.get(toCopy.toURI());
                Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
            }
        }
        
    }
    
}
