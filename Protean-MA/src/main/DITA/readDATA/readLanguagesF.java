package main.DITA.readDATA;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


import main.DITA.Common.implementOBJ;

public class readLanguagesF {
	implementOBJ obj = new implementOBJ();
	Document doc = null;
	Map<String, String> langMap = new HashMap<>();
	String msg = "";
	
	public void runReadLanguagesF() {
		System.out.println("runReadLanguagesF() 시작");
		
		try {
			// 파일 읽기
	        doc = obj.readFile(obj.languagesF);
	        
	        // root 요소에 접근
	        Element rootTag = doc.getDocumentElement();
//	        System.out.println("tagName: " + rootTag.getTagName());
	        
	        // XPath 객체 생성
	        XPathFactory xpathfactory = XPathFactory.newInstance();
	        XPath xpath = xpathfactory.newXPath();
	        
	        // language 요소들 얻기
	        getLanguageList(xpath);
		} catch (Exception e) {
			// optionListF 파일 읽기 실패
			e.printStackTrace();
		} 
		
	} 
	
	public void getLanguageList(XPath xpath) throws Exception {
		System.out.println("getLanguageList() 시작");
		
		String express = "root/language";
		try {
			NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
			
			System.out.println("nl 개수: " + nl.getLength());
			for (int i = 0; i < nl.getLength(); i++) {
				Node node = nl.item(i);
				Element eleLang = (Element) node;
				
				String name = eleLang.getAttribute("name");
				String code = eleLang.getAttribute("code");

//				System.out.println("name: " + name);
//				System.out.println("code: " + code);
				
                langMap.put(name, code);
                obj.langMap = langMap; 
                
            }
			
		} catch (Exception e) {
			// 
			System.out.println("readLanguagesF -> getLanguageList() 에러");
			msg = "readLanguagesF -> getLanguageList() 에러";
			throw new Exception(msg);

		}
		
	}
	
	
}
