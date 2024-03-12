package main.java.idmlcontroller;

import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Stream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.CommonObj.implementOBJ;

public class mergedStoryF {
    implementOBJ obj = new implementOBJ();
    Map<String, List<String>> storyPathMap = new HashMap<>();
    Map<String, NodeList> getHyperLink = new HashMap<>();
    static Map<String, Element> eachChapMap = new HashMap<>();
    
    String msg = "";
    
    public mergedStoryF(Map<String, List<String>> storyPathMap, Map<String, NodeList> getHyperLink) {
        this.storyPathMap = storyPathMap;
        this.getHyperLink = getHyperLink;
        
    }
    
    public void runMergedStory() {
        System.out.println("runMergedStory() 시작");
        
        // 1. entrySet() 메소드로 Map.Entry 객체 타입으로 Set 컬랙션으로 반환
        Set<Map.Entry<String, List<String>>> entryset = storyPathMap.entrySet();
        
        // 2. Set 컬렉션 객체로 부터 스트림 얻기
        Stream<Map.Entry<String, List<String>>> streamEntry = entryset.stream();

        streamEntry.forEach(m -> {
            // 키 객체 얻기 - getKey() 메소드
            String getKey = m.getKey();

            // 값 객체 얻기 - getValue() 메소드
            List<String> list = m.getValue();
            
            try {
                // 3. 빈 Document 객체 생성
                DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
                DocumentBuilder db = dbf.newDocumentBuilder();
                Document doc = db.newDocument();
                
                // 4. root 태그 및 속성 생성
                Element rootEle = doc.createElement("root")                ;
                rootEle.setAttribute("idmlName", getKey);
                doc.appendChild(rootEle);
                
                // 각 idml 폴더내 designmap.xml 로부터 수집한 HyperLink를 모아놓은 
                // getHyperLink 컬랙션 객체를 root 태그의 자식으로 추가 하기
                Element mapEle = doc.createElement("mapLink");
                rootEle.appendChild(mapEle);
                
                // 5. getHyperLink map 컬렉션을 반복문으로, 추출
                // getKey 변수를 넘겨 주는 이유는 HyperLink 컬렉션 객체의 키 객체와 비교 하여 일치할 경우 추가 하기 위해
                addHyperLink(mapEle, getKey, doc);
                
                // 8. storyPathMap 컬렉션 객체 반복하여, Story.xml 경로 추출
                getStoryNode(list, rootEle, doc);
                
                // getStoryNode() 메소드 호출이 끝나고 나면 rootEle 태그의 자식으로 모든 Story.xml 의 노드들이 들어가 있을 것이다. 
                // 14. <idml이름, idml폴더내 모든 Story.xml를 묶은 root> 형태의 map 컬렉션을 생성하여, Main 클래스로 넘겨 준다.
                eachChapMap.put(getKey, rootEle);
                               
                
                
                
            } catch(Exception e) {
                msg = "story.xml 파일들을 모으기 위한 document 객체 생성 실패"; 
                throw new RuntimeException(msg);
            }

        });

    }
    
    public void addHyperLink(Element mapEle, String getKey, Document doc) {
        System.out.println("addHyperLink() 시작");
        
        getHyperLink.forEach((k, v) -> {
            String getkey2 = k;
            NodeList getvals2 = v;
            
            // NodeList 반복하여 하나씩 꺼내옴
            // 6. storyPathMap 의 키객체와 같은 경우에 NodeList 로부터 노드를 가져와 추가
            if(getkey2.equals(getKey)) {
                // NodeList를 반복하여 하나씩 가져와서 추가
                for(int i=0; i<getvals2.getLength(); i++) {
                    Node node = getvals2.item(i);
                    Element ele = (Element) node;
                    
//                    mapEle.appendChild(doc.adoptNode(node).cloneNode(true));

                    // 7. 새로 만든 doc 객체에 복제할 노드를 추가
                    Node importedNode = doc.importNode(node, true);
                    mapEle.appendChild(importedNode);
                }
                
            }
                    
        });

    }
    
    public void getStoryNode(List<String> list, Element rootEle, Document doc) {
        System.out.println("getStoryNode() 시작");
        
        // 9. 각각의 Story.xml 파일들을 읽기 위해 반복문
        list.forEach(c -> {
            Path path = Paths.get(c);
           
            // 9. StoryList의 모든 목록이 story.xml 파일로 존재하는것이 아니기 때문에,
            // 존재하는 것만 파일 입력 스트림으로 생성
            if(Files.exists(path)) {
                try {
                    // 문자 기반 입력스트림 생성
                    Reader reader = Files.newBufferedReader(path);
                    
                    InputSource is = new InputSource(reader);
                    is.setEncoding("UTF-8");
                    
                    // 10. Document 객체 생성, Story.xml이 한번씩 돌아갈때 마다 Story.xml을 DOM 객체로 읽어 컨트롤하기
                    DocumentBuilderFactory dbf1 = DocumentBuilderFactory.newInstance();
                    DocumentBuilder db1 = dbf1.newDocumentBuilder();
                    Document doc1 = db1.parse(is);
                    Element storyRoot = doc1.getDocumentElement();
                    
                    // 11. Contents 요소를 추출하여, CDATA 제거 하기
                    NodeList nl = doc1.getElementsByTagName("Contents");
                    
                    for(int j=0; j<nl.getLength(); j++) {
                        Node node = nl.item(j);
                        Element ele = (Element) node;
                        
                        NodeList nl2 = ele.getChildNodes();
                        
                        // 12. Stream의 iterate 반복스트림
                        // java8 버전에서는 종료조건을 limit() 메소드로 지정해 주어야 한다.
                        Stream.iterate(0, a -> a+1).limit(nl2.getLength()).forEach(a -> {
                            Node node2 = nl2.item(a);
                            
                            // CDATA를 노드로 가지고 있는 Contents 를 찾아 자식 노드 삭제
                            node2.setNodeValue("");
                            
                        });
                    }
                    
                    // 13. 새로만든 doc 객체(59번 라인에서 생성한 doc 객체)에 기존 노드를 복제 한다.
                    rootEle.appendChild(doc.adoptNode(storyRoot.cloneNode(true)));
                    
                    
                } catch(Exception e) {
                    msg = "Stories/story.xml 파일 읽기 실패";
                    throw new RuntimeException(msg);
                }
                
            }
            
        });
    }
    
    public static Map<String, Element> getChapMapCollect() {
        System.out.println("exportChapFiles 시작");
        return eachChapMap;

    }
    
}
