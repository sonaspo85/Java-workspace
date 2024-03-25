package SONTEST.TEST03.fileControl.refXslt;

import java.io.File;
import java.util.ArrayList;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import SONTEST.TEST03.subWorkClass.commonObj;
import SONTEST.TEST03.subWorkClass.customUserException;

public class XsltTransform {
    ArrayList<InOutPathClas> list = new ArrayList<>();
    commonObj coj = new commonObj();
    
    String getInch = coj.inch;
    String getCompany = coj.company;
    String getLang = coj.lang;
    String uiTxt;
        
        
    public XsltTransform(ArrayList<InOutPathClas> list, String uiTxt) {
        this.list = list;
        this.uiTxt = uiTxt;
    }
        
    public void runXslTranform() throws Exception {
        System.out.println("runXslTranform 시작");
        
        list.stream().forEach(a -> {
            InOutPathClas iopc = a;
            
            File inFile = new File(iopc.getinFile());
            File outFile = new File(iopc.getoutFile());
            File xslFile = new File(iopc.getxslFile());
            
          Source inXml = new StreamSource(inFile);
          Result outXml = new StreamResult(outFile);          
          Source xslt = new StreamSource(xslFile);
          
          TransformerFactory factory = TransformerFactory.newInstance();
          try {
              Transformer tf = factory.newTransformer(xslt);
              tf.transform(inXml, outXml);
          } catch(Exception e1) {
              throw new RuntimeException(e1.getMessage());
          }
            
        });
        
        copyquickguide();
    }
        
    // internal 이고, 10in 이며, Kor 인 경우 Quickguide를 output 폴더로 복사
    private void copyquickguide() {
        System.out.println("copyquickguide 시작");

        if(!getCompany.contains("Genesis") && uiTxt.contains("internal") && getLang.contains("Kor") && getInch.equals("10in") && !uiTxt.contains("CV")) {
            File file = new File("");
            String QDirs ="";
            
            if (getCompany.contains("Hyun")) {
                QDirs = file.getAbsolutePath() + "\\resource\\Quickguide\\Hyundai";
            } else if(getCompany.contains("Kia")) {
                QDirs = file.getAbsolutePath() + "\\resource\\Quickguide\\Kia";
            }
            
            String Qto = file.getAbsolutePath() + "\\output";
                File from = new File(QDirs);
                File to = new File(Qto);
                
                coj.copyFolder(from, to);
            }
   
            System.out.println("완료!!");
    }
        
}
