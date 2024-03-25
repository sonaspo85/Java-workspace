package main.java.idmlcontroller;

import java.io.File;
import java.io.IOException;
import java.io.Reader;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.CommonObj.implementOBJ;

public class allImdmlMerged {
	implementOBJ obj = new implementOBJ();
	Charset charset = Charset.forName("UTF-8");
	Document doc = null;
	
	public allImdmlMerged() {
		
	}
	
	public void runAllImdml() throws Exception {
		String getXmlF = obj.curXMLDir;
		Path outXmlDir = Paths.get(getXmlF);
		DirectoryStream<Path> ds = Files.newDirectoryStream(outXmlDir);
		
		// 빈 Document 객체 생성
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		doc = db.newDocument();
		
		// root 노드 생성
		Element rootEle = doc.createElement("docs");
		doc.appendChild(rootEle);		
		
		ds.forEach(a -> {
			try {
				String fileName = a.getFileName().toString();
				
				// 스트림으 얻은 각각의 파일들을 문자 입력 스트림으로 얻기
				Reader reader = Files.newBufferedReader(a, charset);
				InputSource is = new InputSource(reader);
				is.setEncoding("UTF-8");
				
				DocumentBuilderFactory dbf2 = DocumentBuilderFactory.newInstance();
                DocumentBuilder db2 = dbf2.newDocumentBuilder();
                Document doc2 = db2.parse(is);
                Element eleRoot = doc2.getDocumentElement();
                eleRoot.setAttribute("fileName", fileName);
                NodeList nl = doc2.getChildNodes();
                
                for(int i=0; i<nl.getLength(); i++) {
                	Node node = nl.item(i);
                	Node importedNode = doc.importNode(node, true);
                	rootEle.appendChild(importedNode);
                	
                }
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		});
		
		
		
		
	}
	
	public void outMergedF(String lang) {		
		File projectDir = new File("");
		String merged = projectDir.getAbsolutePath() + File.separator + "temp" + "/merged" + "_" + lang + ".xml";
		Path mergedPath = Paths.get(merged);
		
		obj.xmlTransform(merged, doc);
	}
	
}
