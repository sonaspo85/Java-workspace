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
            
//                System.out.println("inFile: " + inFile);
//                System.out.println("outFile: " + outFile);
//                System.out.println("xslFile: " + xslFile);
            
            
          // 1. xml 문서를 구현하는 StreamSource 객체를 Source 구현 객체로 할당
          // StreamSource: xml 문서를 입력 스트림으로 사용하기 위한 객체
          Source inXml = new StreamSource(inFile);
          
          // transform한 결과 문서를 저장하는데 필요한 정보를 포함하고 있다.
          // StreamResult: xml, txt, html 로 변환되는 결과물을 저장할 객체로 사용 
          Result outXml = new StreamResult(outFile);
          
          Source xslt = new StreamSource(xslFile);
          
          System.setProperty("javax.xml.transform.TransformereFactory", "net.sf.saxon.TransformerFactoryImpl");
          TransformerFactory factory = TransformerFactory.newInstance();
          

          
          try {
              Transformer tf = factory.newTransformer(xslt);
              tf.transform(inXml, outXml);
          } catch(Exception e1) {
              throw new RuntimeException(e1.getMessage());
          }
            
        });
        
        // internal 이고, 10in 이며, Kor 인 경우 Quickguide를 output 폴더로 복사
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
