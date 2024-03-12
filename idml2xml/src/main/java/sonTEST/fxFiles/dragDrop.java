package main.java.sonTEST.fxFiles;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import net.sf.saxon.om.NamespaceConstant;

public class dragDrop {
    private List<File> list;
    public Map<String, List<String>> map = new HashMap<>();
    
    public Charset charset = Charset.forName("UTF-8");
    
    
    
    
    // s
    public dragDrop(List<File> list) {
        this.list = list;
    }
    
    
    public void readDataF() throws Exception {
        System.out.println("readDataF 시작");
//        System.out.println(list.get(0));
        
        
        try {
            Document doc = connectF();

            // 7. 문서내 최상위 요소에 접근 하기
            Element rootEle = doc.getDocumentElement();
            
            System.out.println("ddd: " + rootEle.getNodeName());
            System.out.println("bbb: " + rootEle.getAttribute("class"));
            
            try {
                Verification(doc);
                
            } catch(Exception e2) {
                System.out.println("xpath 검증 실패");
                e2.printStackTrace();
            }
            
        } catch(Exception e1) {
            System.out.println("파일 읽기 실패");
            e1.printStackTrace();
        }
        
    }
    
    public void Verification(Document doc) throws Exception {
        System.out.println("Verification 시작");
        
        System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
        XPathFactory factory = XPathFactory.newInstance();
        XPath xpath = factory.newXPath();
        
        String expressID = "root/div[@key]";
        
        NodeList nl = (NodeList) xpath.compile(expressID).evaluate(doc, XPathConstants.NODESET);
        
        for(int i=0; i<nl.getLength(); i++) {
            Node node1 = nl.item(i);
            Element tag1 = (Element) node1;
            
            String id = tag1.getAttribute("key");
            System.out.println("id: " + id);
            
            NodeList nl2 = (NodeList) tag1.getChildNodes();
//            System.out.println("nl2: " + nl2.getLength());
            
            for(int j=0; j<nl2.getLength(); j++) {
                Node node2 = nl2.item(j);
                if(node2.getNodeType() == Node.ELEMENT_NODE) {
                    Element tag2 = (Element) node2;

//                  String ddd = StringEscapeUtils.unescapeXml(tag2.getTextContent());
//                  System.out.println(tag2.getNodeValue().get);
                }
                
            }
            
        }
        
        
    }
    
    public Document connectF() throws Exception {
        File file = new File(list.get(0).toString());
        System.out.println("file: " + file.getAbsolutePath());
        
        // 1. FileInputStream 으로 바이트 기반 입력 스트림으로 읽기 
        FileInputStream fis = new FileInputStream(file); 
        
        // 2. UTF-8 문자셋으로 읽기 위해 InputStreamReader 보조 스트림 객체 생성
        Reader reader = new InputStreamReader(fis, charset);
        
        //3. xml 문서를 UTF-8로 일기 위해 InputSource 객체를 생성하여 문자셋 지정
        InputSource is = new InputSource(reader);
        is.setEncoding("UTF-8");
        
        // 4. DocumentBuilderFactory 객체 생성
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        
        // 5. DocumentBuilder 객체 생성
        DocumentBuilder db = dbf.newDocumentBuilder();
        
     // 6. InputSource 객체로 읽은 파일를 DOM 트리 객체로 변환 후 Document 객체에 할당
        Document doc = db.parse(is);
        
        return doc;
    }
    
}
