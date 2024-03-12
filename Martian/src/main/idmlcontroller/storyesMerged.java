package main.idmlcontroller;

import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.Common.implementOBJ;



public class storyesMerged {
    implementOBJ obj = new implementOBJ();
    String msg = "";
    Map<String, List<String>> storyPathCollect = new HashMap<>();
    Map<String, NodeList> hyperlinkCollect = new HashMap<>();
    static Map<String, Element> eachIdmlCollect = new HashMap<>();
    Map<String, String> isocurpath = new HashMap<>();
    
    
    
    public storyesMerged(Map<String, NodeList> hyperlinkCollect, Map<String, List<String>> storyPathCollect, Map<String, String> isocurpath) {
        this.storyPathCollect = storyPathCollect;
        this.hyperlinkCollect = hyperlinkCollect;
        this.isocurpath = isocurpath;
    }
    
    public void collectStoryByTopic() {
    	System.out.println("collectStoryByTopic() 시작");
    	
    	
    	/*
    	String isocode = "";
    	Path curpath = null;
    	
    	Set<Map.Entry<String, Path>> initVals = isocurpath.entrySet();
    	Iterator<Map.Entry<String, Path>> it = initVals.iterator();
    	
    	while(it.hasNext()) {
    	    Map.Entry<String, Path> entry = it.next();
    	    
    	    isocode = entry.getKey();
    	    curpath = entry.getValue();
    	    
    	    System.out.println("isocode: " + isocode);
    	    System.out.println("curpath" + curpath.toString());
    	}
    	*/
    	
    	
    	// 1. entrySet() 메소드로 키와 값 쌍으로 이루어진 Map.Entry 객체구조의 Set 컬렉션 객체로 반환
    	Set<Map.Entry<String, List<String>>> entrySet = storyPathCollect.entrySet();
    	
    	// Iterator 반복자 사용, 'idmlName : {fullpath}_story.xml' 모은 컬렉션을 반복
    	Iterator<Map.Entry<String, List<String>>> iterator = entrySet.iterator();
    	
    	// 가져올 객체가 있다면
    	while(iterator.hasNext()) {
    		// 객체 가져 오기
    		Map.Entry<String, List<String>> entry = iterator.next();
    		
    		String keys = entry.getKey();
    		List<String> vals = entry.getValue();
    		
    		String isocode = isocurpath.get(keys);
    		
//    		System.out.println("keys: " + keys);
//    		System.out.println("vals: " + vals);
    		
    		try {
    			// 새로운 Document 객체를 생성하고, 루트 요소 만들기	
    			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
				DocumentBuilder db = dbf.newDocumentBuilder();
				Document doc0 = db.newDocument();
				
				// 루트 요소 만들기
				Element ele0 = doc0.createElement("root");
				ele0.setAttribute("filename", keys);
				ele0.setAttribute("isocode", isocode);
//				ele0.setAttribute("curpath", curpath.toAbsolutePath().toString());
				
				
				// 새롭게 만든 Doc 객체에 ele0 요소 추가하기
				doc0.appendChild(ele0);
				
				// dMap 요소를 만들어 hyperlinkCollect map 컬렉션으로 모은 hyperlink 노드들을 dMap 태그 자식으로 추가하기
				Element linkEle = doc0.createElement("linkcollect");
				ele0.appendChild(linkEle);
				
				// 각 idml 별로 hyperlink 요소 추가하기
				hyperlinkCollect.forEach((m,n) -> {
					String keys2 = m;
					NodeList nl2 = n;
					
					// hyperlinkCollect 컬렉션의 idmlname과 storyPathCollect컬렉션의 idmlname이 같은 경우
					if(keys2.equals(keys)) {
						// nl2를 반복하여 각 hyperlink 요소를 가져와 추가하기
						for(int q=0; q<nl2.getLength(); q++) {
							Node node = nl2.item(q);
							Element ele = (Element) node;
							
							// iomportNode() 메소드 - nl2 의 각 노드들을 복사
							// true : 자식 노드 포함
							Node importnode = doc0.importNode(node, true);
							linkEle.appendChild(importnode);
							
						}
						
					}
				});
				
                Element bodyEle = doc0.createElement("body");
                ele0.appendChild(bodyEle);
                
				// story.xml의 전체 경로를 모은 storyPathCollect 컬렉션을 반복하여 파일 스트림으로 읽기
				vals.forEach(b -> {
					Path path = Paths.get(b);
					String fileName = path.getFileName().toString();
					
					// vals로 모은 story.xml 의 풀경로는 Stories 폴더내에 무조건 존재 하는것이 아니기 때문에,
					// 존재하는 것만 파악하여 파일 입력 스트림으로 출력
					if(Files.exists(path)) {
						try {
//							System.out.println("path111: " + path);
							// 문자 입력 스트림으로 읽기
							Reader reader = Files.newBufferedReader(path);
							InputSource is = new InputSource(reader);
							is.setEncoding("UTF-8");
							
							DocumentBuilderFactory dbf1 = DocumentBuilderFactory.newInstance();
							DocumentBuilder db1 = dbf1.newDocumentBuilder();
							Document doc1 = db1.parse(is);
							Element rootEle = doc1.getDocumentElement();
//							rootEle.setAttribute("storyName", fileName);
							
							// Contents 요소를 추출하여 CDATA 제거하기
							NodeList nl = doc1.getElementsByTagName("Contents");
							
							for(int j=0; j<nl.getLength(); j++) {
								Node node = nl.item(j);
								Element ele = (Element) node;
								
								NodeList nl2 = ele.getChildNodes();
								
								for(int f=0; f<nl2.getLength(); f++) {
									Node node2 = nl2.item(f);
									
									// CDATA 를 노드로 가지고 있는 Contents를 찾아 자식 노드 삭제
									if(node2.getNodeType() == Node.CDATA_SECTION_NODE) {
										node2.setNodeValue("");
										
									} 
								}
							}  // for문 닫기
							
							// adoptNode() 메소드, cloneNode() 메소드로 새로운 ele0 노드에 복제 시키기
//							ele0.appendChild(doc0.adoptNode(storyRoot.cloneNode(true)));
							
							// idml 별 ele0(64번라인) 요소에 추가 
							// iomportNode() 메소드 - nl2 의 각 노드들을 복사
							// true : 자식 노드 포함
							Node importnode2 = doc0.importNode(rootEle, true);
							bodyEle.appendChild(importnode2);
							
						} catch(Exception e) {
							msg = "collectStoryByTopic() -> vals.forEach 에러";
			                System.out.println("msg: " + msg);
			                throw new RuntimeException(msg);
//			                e.printStackTrace();
							
						}
						
					}

				});
				
				// map 컬렉션으로 'idml 이름 : doc0 객체' 형태로 모음
				// 이렇게 모은 eachIdmlCollect 컬렉션을 파일로 추출할 것임
				eachIdmlCollect.put(keys, ele0);
				
    			
    		} catch(Exception e) {
    			msg = "collectStoryByTopic() 메소드 에러";
                System.out.println("msg: " + msg);
                throw new RuntimeException(msg);
    		}
    		
    	}
    	
    }
    
    public static Map<String, Element> getIdmlCollect() {
    	System.out.println("getIdmlCollect() 시작");
    	return eachIdmlCollect;
    }
    
}
