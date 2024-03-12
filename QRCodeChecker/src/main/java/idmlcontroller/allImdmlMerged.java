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
		System.out.println("runAllImdml() 시작");
		
		String getXmlF = obj.curXMLDir;
		Path outXmlDir = Paths.get(getXmlF);
		
		// 1. idml.xml 파일이 있는 폴더내 모든 요소를 스트림으로 얻음
		DirectoryStream<Path> ds = Files.newDirectoryStream(outXmlDir);
		
		// 2. 빈 Document 객체 생성, 생성하는 이유는 각각의 idml.xml 파일을 한데 모을 문서이기 때문에
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		doc = db.newDocument();
		
		// 3. root 노드 생성
		Element rootEle = doc.createElement("docs");
		doc.appendChild(rootEle);		
		
		// 4. idml.xml 파일이 있는 폴더 반복
		ds.forEach(a -> {
			try {
				String fileName = a.getFileName().toString();
				
				// 5. 스트림으 얻은 각각의 파일들을 문자 입력 스트림으로 얻기
				Reader reader = Files.newBufferedReader(a, charset);
				
				// xml 문서를 DOM 구조로 얻기 위해 InputSource 객체 생성
				InputSource is = new InputSource(reader);
				is.setEncoding("UTF-8");
				
				DocumentBuilderFactory dbf2 = DocumentBuilderFactory.newInstance();
                DocumentBuilder db2 = dbf2.newDocumentBuilder();
                Document doc2 = db2.parse(is);
				
                // 6. root 노드에 접근
                Element eleRoot = doc2.getDocumentElement();
                eleRoot.setAttribute("fileName", fileName);
                
                // 7. root 노드의 자식 노드에 접근
                NodeList nl = doc2.getChildNodes();
                
                // 8. NodeList를 반복하여 하나씩 가져와서 새로운 root노드의 자식으로 입력
                for(int i=0; i<nl.getLength(); i++) {
                	Node node = nl.item(i);
                	
                	// 9. 41번 라인에서 새롭게 만든 doc 객체에 복제할 노드 추가
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
		System.out.println("outMergedF() 시작");
		// 10. DOM 구조의 데이터를 xml 문서로 출력하기. 
		
		// 11. merged 파일 경로 지정		
		File projectDir = new File("");
		String merged = projectDir.getAbsolutePath() + File.separator + "temp" + "/merged" + "_" + lang + ".xml";
		Path mergedPath = Paths.get(merged);
		
		
		obj.xmlTransform(merged, doc);
		System.out.println("merged.xml 생성 완료");
	}
	/*
	public void delFoldder() {
	    
	    DirectoryStream<Path> ds;
        try {
            ds = Files.newDirectoryStream(obj.srcDir);
            
            ds.forEach(c -> {
                if(Files.isDirectory(c) && !c.getFileName().toString().equals("temp")) {
                    System.out.println("fileName: " + c.getFileName());
                    obj.recursDel(c);
                }
                
            });
            
            
        } catch (IOException e) {
            
            System.out.println("폴더 삭제 실패");
            e.printStackTrace();
        }
	    
	}*/
	
	
}
