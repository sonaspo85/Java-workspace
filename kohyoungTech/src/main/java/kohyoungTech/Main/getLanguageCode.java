package main.java.kohyoungTech.Main;

import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
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

import net.sf.saxon.lib.NamespaceConstant;

public class getLanguageCode {
	implementOBJ obj = new implementOBJ();
	String codesF = null;
	List<String> lgnsList = new ArrayList<>(); 
	
	public getLanguageCode(String codesF) {
		this.codesF = codesF;
	}
	
	public List<String> getISOCode() {
	    System.out.println("getISOCode() 시작");
	    
		try {
		    System.out.println("codesF: " + codesF);
		    
		    Document doc = createDOM();
		    
		    
            // 최상위 노드 접근
			Element root = doc.getDocumentElement();
			
			System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
            // 3. Xpath 객체 생성
            XPathFactory factory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
            XPath xpath = factory.newXPath();
            
            
			// XPath로 xml의 요소 접근
			String express = "codes/option";
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
			
            
            
            
            for(int i=0; i<nl.getLength(); i++) {
                Node node = nl.item(i);
                Element ele = (Element) node;
//                System.out.println(ele.getAttribute("lang"));
                lgnsList.add(ele.getAttribute("lang"));
            }
            
//            lgnsList.stream().distinct().forEach(a -> {
//                System.out.println("qqq: " + a);
//            });
            
			
		} catch(Exception e1) {
			e1.printStackTrace();
		}
		
		// list 컬렉션 반환
//		lgnsList = lgnsList.stream().distinct().filter(a -> !a.equals("en-GB")).collect(Collectors.toList());
//		List<String> list = lgnsList.stream().distinct().collect(Collectors.toList());
		
		return lgnsList;
	}
	
	public Document createDOM() throws Exception {
//        String mergedF = tempDir + File.separator + "merged.xml";
        // 1. FileInputStream 바이트 기반 입력 스트림으로 파일 읽기
        FileInputStream fis = new FileInputStream(codesF);

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
}
