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
		System.out.println("runReadOptionF() 시작");
		
		try {
			// 파일 읽기
	        doc = obj.readFile(obj.optionListF);
	        
	        // root 요소에 접근
	        Element rootTag = doc.getDocumentElement();
//	        System.out.println("tagName: " + rootTag.getTagName());
	        
	        // XPath 객체 생성
	        XPathFactory xpathfactory = XPathFactory.newInstance();
	        XPath xpath = xpathfactory.newXPath();
	        
	        // template 요소들 얻기
	        getTemplateList(xpath);
	        
	        // html 요소들 얻기
	        getHtmlList(xpath);
	        
	        // prodtype 얻기
	        getProdList(xpath);
			
			// obj 로 할당하기
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
		System.out.println("getHtmlList() 시작");
		
		String express = "root/div[@class = 'html']/option/@vals";
		try {
			NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
			
			for (int i = 0; i < nl.getLength(); i++) {
                String curItem = nl.item(i).getTextContent();
                htmlList.add(curItem);
//                System.out.println("htmlList: " + curItem);

            }
			
		} catch (Exception e) {
			// 
			e.printStackTrace();
		}
		
	}
	
	public void getProdList(XPath xpath) {
		System.out.println("getProdList() 시작");
		
		String express = "root/div[@class = 'prodtype']/option/@vals";
		try {
			NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
			
			for (int i = 0; i < nl.getLength(); i++) {
				String curItem = nl.item(i).getTextContent();
                prodList.add(curItem);
//                System.out.println("prodList: " + curItem);

            }
			
		} catch (Exception e) {
			// 
			e.printStackTrace();
		}
		
	}
	
	
	
}
