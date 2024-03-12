package SONTEST.TEST03.fileControl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import SONTEST.TEST03.subWorkClass.commonObj;

public class exportComboList {
    public List<String> listLang = new ArrayList<>();
    public List<String> listCompany = new ArrayList<>();
    public List<String> listInch = new ArrayList<>();
    
    commonObj coj = new commonObj();
    
    
    public void getCodes() throws Exception {
        File file = new File("");
        String codePath = file.getAbsolutePath() + "\\resource\\codes.xml";
        
        FileInputStream fis = new FileInputStream(codePath);
        Reader reader = new InputStreamReader(fis, "UTF-8");
        BufferedReader br = new BufferedReader(reader);
        
        // xml 문서를 DOM 객체 타입으로 생성
        Document doc = coj.createDomObj(br);
        
        // XPath 객체 생성
        XPath xpath = XPathFactory.newInstance().newXPath();
        
        // Company 이름 얻기
        listCompany = getCompany(doc, xpath);
        
        // 언어명 얻기
        listLang = getLang(doc, xpath);
        
        // 인치 얻기
        listInch = getInch(doc, xpath);
    }
    
    // 회사 이름 얻기
    public List<String> getCompany(Document doc, XPath xpath) throws Exception {
        List<String> list = new ArrayList<>();
        
        String expression = "codes/companies/code/@data";
        NodeList nl = (NodeList) xpath.compile(expression).evaluate(doc, XPathConstants.NODESET);
        
        for(int i=0; i<nl.getLength(); i++) {
            String curItem = nl.item(i).getNodeValue().replace("_", "");
            list.add(curItem);
        }
        
        return list;
    }
    
    // 언어명 얻기
    public List<String> getLang(Document doc, XPath xpath) throws Exception {
        List<String> list = new ArrayList<>();
        // code의 @data 속성값 추출
        String expression = "codes/langs/code/@Fullname";
        NodeList nl = (NodeList) xpath.compile(expression).evaluate(doc, XPathConstants.NODESET);
        
        for(int i=0; i<nl.getLength(); i++) {
            String curItem = nl.item(i).getNodeValue();
            list.add(curItem);
        }
        
        return list;
    }
    
    // 인치 얻기
    public List<String> getInch(Document doc, XPath xpath) throws Exception {
        List<String> list = new ArrayList<>();
        
        // code의 @data 속성값 추출
        String expression = "codes/Inches/code/@data";
        NodeList nl = (NodeList) xpath.compile(expression).evaluate(doc, XPathConstants.NODESET);
        
        for(int i=0; i<nl.getLength(); i++) {
            String curItem = nl.item(i).getNodeValue();
            list.add(curItem);
        }
        
        return list;
    }
    
}
