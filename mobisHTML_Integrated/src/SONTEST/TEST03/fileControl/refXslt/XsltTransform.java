package SONTEST.TEST03.fileControl.refXslt;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import SONTEST.TEST03.subWorkClass.commonObj;
import SONTEST.TEST03.subWorkClass.customUserException;
import net.sf.saxon.lib.NamespaceConstant;

public class XsltTransform {
    ArrayList<InOutPathClas> list = new ArrayList<>();
    commonObj coj = new commonObj();
    
    String getInch = coj.inch;
    String getCompany = coj.company;
    String getLang = coj.lang;
    String uiTxt;
    
    String dataLanguage = "";
    String isoCode = "";
    String lgsRegion = "";
    String carName = "";
    String region = "";
        
        
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
            
//            System.out.println("inFile: " + inFile);
//            System.out.println("outFile: " + outFile);
//            System.out.println("xslFile: " + xslFile);
            
            
          // 1. xml 문서를 구현하는 StreamSource 객체를 Source 구현 객체로 할당
          // StreamSource: xml 문서를 입력 스트림으로 사용하기 위한 객체
          Source inXml = new StreamSource(inFile);
          
          // transform한 결과 문서를 저장하는데 필요한 정보를 포함하고 있다.
          // StreamResult: xml, txt, html 로 변환되는 결과물을 저장할 객체로 사용 
          Result outXml = new StreamResult(outFile);
          
          Source xslt = new StreamSource(xslFile);
          
//          System.setProperty("javax.xml.transform.TransformereFactory", "net.sf.saxon.TransformerFactoryImpl");
          System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
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
        
        try {
            getVarExtract();
        
            System.out.println("isoCode: " + coj.isoCode);
            System.out.println("lgsRegion: " + coj.lgsRegion);
            System.out.println("carName: " + coj.carName);
            System.out.println("region: " + coj.region);
            System.out.println("lang: " + coj.lang);
            System.out.println("inch: " + coj.inch);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        //if(uiTxt.contains("internal") && getLang.contains("Kor") && getInch.equals("10in")) {
        /*if(coj.region.contains("internal") && coj.lang.contains("Kor") && coj.inch.equals("10inch") && !coj.version.equals("6th")) {
            String QDirs ="";
            
            if (getCompany.contains("Hyun")) {
                QDirs = coj.exePath + "\\resource\\Quickguide\\Hyundai";
            } else if(getCompany.contains("Kia")) {
                QDirs = coj.exePath + "\\resource\\Quickguide\\Kia";
            } else {
                System.out.println("해당 사항 없음");
                return;
            }
            String Qto = coj.exePath + "\\output";
            File from = new File(QDirs);
            File to = new File(Qto);
            System.out.println("QDirs: " + from.getAbsolutePath());
            System.out.println("Qto: " + to.getAbsolutePath());
                
            coj.copyFolder(from, to);
        }*/
   
            System.out.println("완료!!");
    }
    
    public void getVarExtract() throws Exception {
        Path path = Paths.get(coj.mergedPath);
        Path verExract = Paths.get(path.getParent() + File.separator + "varExract.xml");
        
        File file = verExract.toFile();
        
        FileInputStream fis = new FileInputStream(file);
        Reader reader = new InputStreamReader(fis, "UTF-8");
        
        Document doc = coj.createDomObj(reader); 
        
        Element rootEle = doc.getDocumentElement();
        
        // root 요소의 자식요소에 접근
        NodeList childNode = rootEle.getChildNodes();
        
        for(int i=0; i<childNode.getLength(); i++) {
            Node node = childNode.item(i);
            
            // varExact.xml에서 값 추출하기
            getValues(node);
        }
        
        
    }
    
    // varExact.xml에서 값 추출하기
    public void getValues(Node node) {
        if(node.getNodeType() == Node.ELEMENT_NODE) {
            Element eleNode = (Element) node;
            
            switch(node.getLocalName()) {
                case "dataLanguage":
                    dataLanguage = eleNode.getAttribute("value");
                    commonObj.dataLanguage = dataLanguage;
                    break;
                    
                case "ISOCode":
                    isoCode = eleNode.getAttribute("value");
                    commonObj.isoCode = isoCode;
                    break;
                    
                case "lgsRegion":
                    lgsRegion = eleNode.getAttribute("value");
                    commonObj.lgsRegion = lgsRegion;
                    break;
                    
                case "carName":
                    carName = eleNode.getAttribute("value");
                    commonObj.carName = carName.substring(0,2);
                    break;
                    
                case "region":
                    region = eleNode.getAttribute("value");
                    commonObj.region = region;
                    break;

            }

        }

    }
        
}
