package main.java.sonTEST.fileControl;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.commonObj.commonImpleObj;
import net.sf.saxon.om.NamespaceConstant;

public class accessDesignmap {
	commonImpleObj coj = new commonImpleObj();
	List<String> sList = new ArrayList<>();
	Map<String, List<String>> storyPathCollect = new HashMap<>();
	
	// 챕터별로 모든 story.xml를 모든 map 컬렉션
	Map<String, NodeList> mapGetNodes = new HashMap<>();
	
	List<Path> zipList = new ArrayList<>();
	
	public void eachDirs() throws Exception {
		System.out.println("eachDirs 시작");
		
		// zip 디렉토리내 모든 챕터 디렉토리를 추출하여 list 컬렉션으로 저장
		getchapDirs(); 
				
		zipList.forEach(a -> {
			String abPath = a.toString();
			String getName = a.getFileName().toString();
			
			// 각 챕터폴더의 하위 디렉토리 접속
			accessSubLists(a);
		});
		
		// 챕터별 xml파일로 추출하기
		exportChapFiles();
	}
	
	// 각 챕터 폴더의 하위 디렉토리 접속
	public void accessSubLists(Path a) {
		System.out.println("accessSubLists 시작");
		try {
			DirectoryStream<Path> ds = Files.newDirectoryStream(a);
			
			ds.forEach(b -> {
				String getName = b.getFileName().toString();
				
				if(Files.isRegularFile(b)) {  // 파일인 경우
					if(getName.equals("designmap.xml")) {
						try {
							accessMapFile(b.toAbsolutePath());
							
						} catch (Exception e) {
							System.out.println("designmap.xml 문서 접속 오류");
							e.printStackTrace();
						}
					}
				}
				
			});
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	// designmap.xml 파일을 Document 객체로 읽어 @StoryList을 map 컬렉션으로 수집 
	public void accessMapFile(Path mapFile) throws Exception {
		System.out.println("accessMapFile 시작");
		
		// 각 IDML 폴덜 이름 추출
		String charName = mapFile.getParent().getFileName().toString();
//		System.out.println("charName: " + charName);
		String abPath = mapFile.toAbsolutePath().getParent().toString();
		
		try {
			Charset charset = Charset.forName("UTF-8");
			
			// Files 객체의 newBufferedReader() 메소드를 호출하여,
			// 문자 기반 입력 스트림 객체 생성
			BufferedReader br = Files.newBufferedReader(mapFile, charset);
			
			// xml 문서를 읽기 위해 InputSource 객체 생성
			InputSource is = new InputSource(br);
			is.setEncoding("UTF-8");
			
			// Document 객체를 생성하기 위해 DocumentBuilderFactory 객체 생성
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			// DocumentBuilder 객체 생성
			DocumentBuilder db = dbf.newDocumentBuilder();
			
			// Document 객체 생성, 매개변수로 xml 문서를 할당
			Document doc = db.parse(is);
			
			// 문서의 루트 요소에 접근하기
			Element root = doc.getDocumentElement();
//			System.out.println("root: " + root.getNodeName());
			
			// regex 2.0을 사용하기 위해 Saxon 객체의 XPathFactory 객체로 설정
			System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
			XPathFactory xfactory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
			
			// XPath 객체 생성
			XPath xpath = xfactory.newXPath();
			String express = "Document/@StoryList";
			String storyList = (String) xpath.compile(express).evaluate(doc, XPathConstants.STRING);
			
			// @StoryList 속성의 값을 공백으로 분리하여 list 컬렉션으로 할당
			sList = Arrays.asList(storyList.split(" "));
			
			// Story 파일들의 위치를 컬렉션으로 수집
			createStoryPath(abPath);
			
			// designmap.xml 파일에서 Hyperlink 요소만 추출하기
			extractNodes(xpath, doc, charName);
			
			// storyPathCollect 으로 수집한 모든 story 파일에 접근
			storyesMerged sm = new storyesMerged(storyPathCollect, mapGetNodes);
			sm.collectStorybyTopic();
			
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
	
	// Story 파일들의 위치를 컬렉션으로 수집
	public void createStoryPath(String abPath) {
		System.out.println("createStoryPath() 시작");
		
		// 챕터명 추출
		String charName = Paths.get(abPath).getFileName().toString();
		
		List<String> list = new ArrayList<>();
		sList.forEach(a -> {
			String fileName = a + ".xml";
			String storyPath = abPath + File.separator + "Stories" + File.separator + "Story_" + fileName;
			
			list.add(storyPath);

		});
		
		// map 컬렉션으로 키객체:챕터이름, 값객체:story.xml 수집
		storyPathCollect.put(charName, list);
		
	}
	
	public void extractNodes(XPath xpath, Document doc, String charName) {
		System.out.println("extractNodes() 시작");
		NodeList nl = null;
		try {
			String express = "Document/Hyperlink | Document/HyperlinkURLDestination";

			nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
			
		} catch (XPathExpressionException e) {
			System.out.println("Hyperlink 요소 추출 실패");
			e.printStackTrace();
		}
		
		// designmap.xml 파일에서 변수 express 를 챕터 이름 별로 map 컬렉션으로 수집
		mapGetNodes.put(charName, nl);
	}
	
	// 챕터별 파일 추출하기
	public void exportChapFiles() throws Exception {
		System.out.println("exportChapFiles() 시작");
		System.out.println("챕터별 xml 추출 시작");
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
	
	public void getchapDirs() {
		System.out.println("getchapDirs() 시작");
		try {
			Path dsPath = Paths.get(coj.srcPath + File.separator + "zipDir");
			DirectoryStream<Path> zPath = Files.newDirectoryStream(dsPath);
			
			// zip 디렉토리내 모든 챕터 디렉토리 경로를 추출하여 list 컬렉션으로 저장
			zPath.forEach(g -> {
				Path getFullPath = g.toAbsolutePath();
				zipList.add(getFullPath);
			});
			
		} catch(Exception e1) {
			e1.printStackTrace();
		}
		
	}

}
