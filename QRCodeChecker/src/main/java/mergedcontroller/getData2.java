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
        System.out.println("runGetDate() 시작");
        
        System.out.println();
        tempDir = obj.srcDir + File.separator + "temp";
//        tempDir = "C:/Users/SMC/Desktop/IMAGE/qsg/test/temp";
        obj.tempDir = tempDir;
        
        try {
            // 1. merged.xml 파일 읽기
            Document doc = createDOM();
            
            // 2. merged.xml 문서내 최상위 요소 접근하기
            Element rootEle = doc.getDocumentElement();
            
            // 최상위 요소 이름 및 속성 추출
            System.out.println("최상위 요소 이름: " + rootEle.getNodeName());
            
            System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
            // 3. Xpath 객체 생성
            XPathFactory factory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
            XPath xpath = factory.newXPath();
            
            // 4. 정규식으로 찾을 Xpath 구조 지정
            getQrcodeUrl(xpath, doc);
            
            // 6. 모델 이름 추출
            getModelName(xpath, doc);
            
            
        } catch (Exception e) {
            System.out.println("merged 파일 읽기 실패");
            e.printStackTrace();
        } 
        
    }
    
    public Document createDOM() throws Exception {
        String mergedF = tempDir + File.separator + "merged.xml";
        // 1. FileInputStream 바이트 기반 입력 스트림으로 파일 읽기
        FileInputStream fis = new FileInputStream(mergedF);
        
        // 2. 문자 기반 입력스트림으로 변환 하여 "UTF-8" 인코딩 방식으로 읽기
        Reader reader = new InputStreamReader(fis, "UTF-8");
        
        // 3. xml 문서를 UTF-8 기반으로 DOM 트리구조로 읽기 위해 InputSource 객체 사용
        InputSource is = new InputSource(reader);
        is.setEncoding("UTF-8");
        
        // 4. DocumnetBuilderFactory 객체로 xml 문서를 DOM 트리 구조로 읽기
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        
        // 4-1 xml문서를 파싱할때 namespace 지원 여부 설정하기
        // xslt를 사용하기 위해서는 필수 옵션이다.
        dbf.setNamespaceAware(true);
        
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(is);
        
        return doc;
    }
    
    public void getQrcodeUrl(XPath xpath, Document doc) throws Exception {
        String QRcodeImgExp = "//Link[matches(@LinkResourceURI, 'E-usermanual_')]";
        NodeList nl = (NodeList) xpath.compile(QRcodeImgExp).evaluate(doc, XPathConstants.NODESET);
        

        // 5. 정규식으로 찾은 요소를 반복하여 추출 
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
        
        
        // 5. 정규식으로 찾은 요소를 반복하여 추출 
        for(int y=0; y< nl.getLength(); y++) {
            Node node = nl.item(y);
            Element ele = (Element) node;
            
            modelNameTar = ele.getTextContent();
            obj.modelNameTar = modelNameTar;
            
        }
        
    }

}
