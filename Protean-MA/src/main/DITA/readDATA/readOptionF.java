package main.DITA.readDATA;

import java.util.ArrayList;
import java.util.List;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import main.DITA.Common.implementOBJ;

public class readOptionF {
	implementOBJ obj = new implementOBJ();
	List<String> templateList = new ArrayList<>();
	List<String> htmlList = new ArrayList<>();
	List<String> prodList = new ArrayList<>();
	Document doc = null;
	
	public void runReadOptionF() {
		try {
	        doc = obj.readFile(obj.optionListF);
	        
	        // root 요소에 접근
	        Element rootTag = doc.getDocumentElement();
	        XPathFactory xpathfactory = XPathFactory.newInstance();
	        XPath xpath = xpathfactory.newXPath();
	        getTemplateList(xpath);
	        getHtmlList(xpath);
	        getProdList(xpath);
	        obj.templateList = templateList;
	        obj.htmlList = htmlList;
	        obj.prodList = prodList; 
	        
		} catch (Exception e) {
			// optionListF 파일 읽기 실패
			e.printStackTrace();
		} 
		
		
	}
	
	public void getTemplateList(XPath xpath) {
		System.out.println("getTemplateList() 시작");
		
		String express = "root/div[@class = 'template']/option/@vals";
		try {
			NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
			
			for (int i = 0; i < nl.getLength(); i++) {
				String curItem = nl.item(i).getTextContent();
                templateList.add(curItem);
                System.out.println("curItem: " + curItem);

            }
			
		} catch (Exception e) {
			// 
			e.printStackTrace();
		}
		
	}
	
	public void getHtmlList(XPath xpath) {
		String express = "root/div[@class = 'html']/option/@vals";
		try {
			NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
			
			for (int i = 0; i < nl.getLength(); i++) {
                String curItem = nl.item(i).getTextContent();
                htmlList.add(curItem);
            }
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void getProdList(XPath xpath) {
		String express = "root/div[@class = 'prodtype']/option/@vals";
		try {
			NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
			
			for (int i = 0; i < nl.getLength(); i++) {
				String curItem = nl.item(i).getTextContent();
                prodList.add(curItem);

            }
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	
}
