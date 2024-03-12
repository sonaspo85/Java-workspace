package main.java.sonTEST.fileControl;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import main.java.commonObj.commonImpleObj;

public class createEachChapterFiles {
	commonImpleObj coj = new commonImpleObj();
	Map<String, Element> eachChapMap = new HashMap<>();
	
	public createEachChapterFiles(Map<String, Element> eachChapMap) {
		this.eachChapMap = eachChapMap;
	}
	
	// 챕터별 xml 파일이 저장될 xml 폴더 생성하기
	public void getEachChapterFiles() {
		System.out.println("getEachChapterFiles 시작");
		try {
			createXMLDirs();
			System.out.println("챕터 xml이 저장될 폴더 생성 완료");
		} catch(Exception e) {
			System.out.println("xml 폴더 생성 실패");
			e.printStackTrace();
		}
		
		// 모든 챕터별로 story.xml를 merged 한 map 컬렉션을 스트림 하여, Transform 하여 출력     
		eachChapMap.entrySet().stream().sorted(Entry.comparingByKey()).forEachOrdered(y -> {
	        DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
	        DocumentBuilder docBuilder;
			try {
				docBuilder = docFactory.newDocumentBuilder();
				
				Document doc = docBuilder.newDocument();
		        doc.setXmlStandalone(true); //standalone="no" 를 없애준다.

		        Element root = doc.createElement("root");
		        doc.appendChild(root);
		        
				String getKey1 = y.getKey();
				String outPath = coj.srcPath + File.separator + "xml" + File.separator + getKey1 + ".xml";
				String outXMLPath = coj.srcPath + File.separator + "xml";
				coj.outXMLPath = outXMLPath;
				Path toPath = Paths.get(outPath);

				Element doc0Node = y.getValue();
				
	            root.appendChild(doc.adoptNode(doc0Node.cloneNode(true)));
				
	            // 챕터별 xml 추출 
	            coj.xmlTransform(toPath.toString(), doc);
	            
			} catch (ParserConfigurationException e4) {
				e4.printStackTrace();
			}

		});
		System.out.println("챕터별 xml 추출 완료");
	}
	
	public void createXMLDirs() throws Exception {
		// xml 파일이 저장될 폴더 생성
		String tarXMLPath = coj.srcPath + File.separator + "xml" + File.separator;
		Path xmlPath = Paths.get(tarXMLPath);
		
		// xml 폴더 존재 여부에 따라 삭제 또는 새롭게 생성
		if(Files.notExists(xmlPath)) {
			Files.createDirectories(xmlPath);
			
		} else {
			coj.recursDel(xmlPath);
			Files.createDirectories(xmlPath);
		}
	}
	
}
