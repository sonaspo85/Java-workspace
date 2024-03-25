package main.java.mergedcontroller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.CommonObj.implementOBJ;
import net.sf.saxon.lib.NamespaceConstant;

public class getData2 {
    implementOBJ obj = new implementOBJ();
    String tempDir = "";
    String qrCodeUrlTar = "";
    String modelNameTar = "";
    
    
    public getData2() {
        
    }
    
    public void runGetDate() {
        tempDir = obj.srcDir + File.separator + "temp";
        obj.tempDir = tempDir;
        
        try {
            // 파일 로드
            Document doc = createDOM();
            
            // 문서내 최상위 요소 접근하기
            Element rootEle = doc.getDocumentElement();
            System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
            XPathFactory factory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
            XPath xpath = factory.newXPath();
            getQrcodeUrl(xpath, doc);
            
            // 모델 이름 추출
            getModelName(xpath, doc);
            
        } catch (Exception e) {
            e.printStackTrace();
        } 
        
    }
    
    public Document createDOM() throws Exception {
        String mergedF = tempDir + File.separator + "merged.xml";
        FileInputStream fis = new FileInputStream(mergedF);
        
        // "UTF-8" 인코딩 방식으로 로드
        Reader reader = new InputStreamReader(fis, "UTF-8");
        InputSource is = new InputSource(reader);
        is.setEncoding("UTF-8");
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(is);
        
        return doc;
    }
    
    public void getQrcodeUrl(XPath xpath, Document doc) throws Exception {
        String QRcodeImgExp = "//Link[matches(@LinkResourceURI, 'E-usermanual_')]";
        NodeList nl = (NodeList) xpath.compile(QRcodeImgExp).evaluate(doc, XPathConstants.NODESET);
        
        // 정규식으로 찾은 요소를 반복하여 추출 
        for(int y=0; y< nl.getLength(); y++) {
            Node node = nl.item(y);
            Element ele = (Element) node;
            
            qrCodeUrlTar = ele.getAttribute("LinkResourceURI");
            obj.qrCodeUrlTar = qrCodeUrlTar;
            
        }
    }
    
    public void getModelName(XPath xpath, Document doc) throws Exception {
        String QRcodeImgExp = "//ParagraphStyleRange[matches(@AppliedParagraphStyle, 'ModelName-Cover')]//Content";
        NodeList nl = (NodeList) xpath.compile(QRcodeImgExp).evaluate(doc, XPathConstants.NODESET);
  
        for(int y=0; y< nl.getLength(); y++) {
            Node node = nl.item(y);
            Element ele = (Element) node;
            
            modelNameTar = ele.getTextContent();
            obj.modelNameTar = modelNameTar;
            
        }
        
    }

}
