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
	        doc = obj.readFile(obj.languagesF);
	        Element rootTag = doc.getDocumentElement();
	        XPathFactory xpathfactory = XPathFactory.newInstance();
	        XPath xpath = xpathfactory.newXPath();
	        getLanguageList(xpath);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
	} 
	
	public void getLanguageList(XPath xpath) throws Exception {
		String express = "root/language";
		try {
			NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
			
			for (int i = 0; i < nl.getLength(); i++) {
				Node node = nl.item(i);
				Element eleLang = (Element) node;
				
				String name = eleLang.getAttribute("name");
				String code = eleLang.getAttribute("code");

                langMap.put(name, code);
                obj.langMap = langMap; 
                
            }
			
		} catch (Exception e) { 
			msg = "readLanguagesF -> getLanguageList() 에러";
			throw new Exception(msg);

		}
		
	}
	
	
}
