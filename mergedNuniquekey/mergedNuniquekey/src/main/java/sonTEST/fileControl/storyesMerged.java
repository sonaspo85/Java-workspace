package main.java.sonTEST.fileControl;

import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Stream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.commonObj.commonImpleObj;



public class storyesMerged {
	commonImpleObj coj = new commonImpleObj();
	Map<String, List<String>> storyPathCollect = new HashMap<>();
	NodeList getNodes;
	List<Element> eachChapList = new ArrayList<>();
	static Map<String, Element> eachChapMap = new HashMap<>();
	Map<String, NodeList> mapGetNodes = new HashMap<>();
	
	public storyesMerged(Map<String, List<String>> storyPathCollect, Map<String, NodeList> mapGetNodes) {
		this.storyPathCollect = storyPathCollect;
		this.mapGetNodes = mapGetNodes;
	}
	
	// designmap.xml을 루프하여 챕터별로 모든 story.xml를 수집하여 map 컬렉션으로 반환
	public void collectStorybyTopic() {
		System.out.println("collectStorybyTopic 시작");
		storyPathCollect.entrySet().stream().sorted(Entry.comparingByKey()).forEachOrdered((m) -> {
			String getKey = m.getKey();
	//			System.out.println("getKey1: " + getKey);
			List<String> list = m.getValue();
			
			try {
				DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
				DocumentBuilder db = dbf.newDocumentBuilder();
				Document doc0 = db.newDocument();
				
				Element ele0 = doc0.createElement("doc");
				ele0.setAttribute("chapName", getKey);
				doc0.appendChild(ele0);
				
				// 각 챕터별 xml 파일내 hyperlink 요소 추가
				Element dMapEle = doc0.createElement("dMap");
				ele0.appendChild(dMapEle);
				
				mapGetNodes.entrySet().stream().sorted(Entry.comparingByKey()).forEachOrdered((w) -> {
					String getKey2 = w.getKey();
					NodeList nl2 = w.getValue();
					
					if(getKey2.equals(getKey)) {
//						System.out.println("getKey2: " + getKey2);
//						System.out.println("nl2: " +  nl2.getLength());
						for(int q=0; q<nl2.getLength(); q++) {
							Node node = nl2.item(q);
							dMapEle.appendChild(doc0.adoptNode(node).cloneNode(true));
							
						}
					}
					
				});
				
				// designmap.xml의 @StoryList 정보를 수집한 list 컬렉션을 반복 하여, 
				// 챕터별 story.xml 수집하기
				list.forEach(b -> {
					Path path = Paths.get(b);
					String getFileName = path.getFileName().toString(); 
					// StoryList의 모든 목록이 story.xml 파일로 존재하는것이 아니기 때문에,
					// 존재하는 것만 파일 입력 스트림으로 생성
					if(Files.exists(path)) {
						try {
							Reader reader = Files.newBufferedReader(path);
							InputSource is = new InputSource(reader);
							is.setEncoding("UTF-8");
							
							DocumentBuilderFactory dbf1 = DocumentBuilderFactory.newInstance();
							DocumentBuilder db1 = dbf1.newDocumentBuilder();
							Document doc1 = db1.parse(is);
							Element storyRoot = doc1.getDocumentElement();
							storyRoot.setAttribute("storyName", getFileName);
							
							// Contents 요소를 추출하여, CDATA 제거 하기
							NodeList nl = doc1.getElementsByTagName("Contents");
							
							for(int j=0; j<nl.getLength(); j++) {
								Node node = nl.item(j);
								Element ele = (Element) node;
								
								NodeList nl2 = ele.getChildNodes();
								
								Stream.iterate(0, f -> f<nl2.getLength(), f->f+1).forEach(f -> {
									Node node2 = nl2.item(f);
									
									// CDATA 를 노드로 가지고 있는 Contents를 찾아 자식 노드 삭제
									if(node2.getNodeType() == Node.CDATA_SECTION_NODE) {
										node2.setNodeValue("");
										
									} 
								});
								
							}  // for문 닫기
							
							// 챕터별 doc1 객체에 story.xml 파일의 노드들을 하나씩 추가
							ele0.appendChild(doc0.adoptNode(storyRoot.cloneNode(true)));
							
						} catch (Exception e2) {
							System.out.println("Stories/story.xml 파일 읽기 실패");
							e2.printStackTrace();
						}
					}
					
				});  // list 컬렉션 for문 닫기
				eachChapMap.put(getKey, ele0);
				
			} catch(Exception e1) {
				e1.printStackTrace();
			}
		});
		
	}
	
	// 챕터별 파일로 추출
	public static Map<String, Element> getChapMapCollect() {
		System.out.println("exportChapFiles 시작");
		return eachChapMap;

	}
	
}
