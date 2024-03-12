package xmlTExcel.runMain;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;


import net.sf.saxon.lib.NamespaceConstant;


public class transformXSLT {
    String msg = "";
    String tempP = "";
    String idmlDir = "";
    
    
    
    
    public ArrayList<InOutPathClas> list = new ArrayList<>();
    
    
    
    public transformXSLT(String tempP) {
        this.tempP = tempP;
    }
    
    public void setList() {
        System.out.println("setList() 시작");
        Path path = Paths.get(tempP);
        String ditaxsls = "Z:/lib/xsls/temp-html";
        
        list.add(new InOutPathClas(ditaxsls + "/dummy.xml", tempP + "/01-merged.xml", ditaxsls + "/01-merged.xsl"));
        
        executeXslt();
    }

    
    
    
    public void executeXslt() {
        System.out.println("executeXslt() 시작");
        
        list.stream().forEach(a -> {
            
            
            InOutPathClas iopc = a;
            
            File inFile = new File(iopc.getinFile());
            File outFile = new File(iopc.getoutFile());
            File xslFile = new File(iopc.getxslFile());

//            System.out.println("para000: " + paraStrPath);
 
              System.out.println("inFile: " + inFile);
              System.out.println("outFile: " + outFile);
              System.out.println("xslFile: " + xslFile);
              System.out.println("tempP: " + tempP);
          
            // 1. xml 문서를 구현하는 StreamSource 객체를 Source 구현 객체로 할당
            // StreamSource: xml 문서를 입력 스트림으로 사용하기 위한 객체
            Source inxml = new StreamSource(inFile);
            
            // 출력 스트림을 통해 생성될 파일 지정
            // transform한 결과 문서를 저장하는데 필요한 정보를 포함하고 있다.
            // StreamResult: xml, txt, html 로 변환되는 결과물을 저장할 객체로 사용
            Result outxml = new StreamResult(outFile);

            // xslt 지정
            Source xsltF = new StreamSource(xslFile);
            
            System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
                        
            TransformerFactory factory = TransformerFactory.newInstance();
            try {
                Transformer tf = factory.newTransformer(xsltF);
                tf.setParameter("sMapDir", "C:/Users/SMC/Desktop/IMAGE/testdita/excel/temp-html");
                /*
                if(xslFile.toString().contains("01-merged")) {
                    tf.setParameter("sMapDir", tempP);

                } 
                */
                tf.transform(inxml, outxml);
                
            } catch(Exception tf) {
                System.out.println("xslt 변환 실패");
//                throw new RuntimeException();
                tf.printStackTrace();
            }

        });
        
        System.out.println("변환 완료!!");
    }

    
    
}
