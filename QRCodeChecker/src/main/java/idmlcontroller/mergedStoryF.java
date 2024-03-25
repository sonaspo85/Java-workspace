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
        Set<Map.Entry<String, List<String>>> entryset = storyPathMap.entrySet();
        Stream<Map.Entry<String, List<String>>> streamEntry = entryset.stream();

        streamEntry.forEach(m -> {
            String getKey = m.getKey();
            List<String> list = m.getValue();
            
            try {
                // 빈 Document 객체 생성
                DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
                DocumentBuilder db = dbf.newDocumentBuilder();
                Document doc = db.newDocument();
                
                // root 태그 및 속성 생성
                Element rootEle = doc.createElement("root")                ;
                rootEle.setAttribute("idmlName", getKey);
                doc.appendChild(rootEle);
                Element mapEle = doc.createElement("mapLink");
                rootEle.appendChild(mapEle);
                
                // map 컬렉션을 반복문으로, 추출
                addHyperLink(mapEle, getKey, doc);
                getStoryNode(list, rootEle, doc);
                eachChapMap.put(getKey, rootEle);
                               
                
                
                
            } catch(Exception e) {
                msg = "story.xml 파일들을 모으기 위한 document 객체 생성 실패"; 
                throw new RuntimeException(msg);
            }

        });

    }
    
    public void addHyperLink(Element mapEle, String getKey, Document doc) {
        getHyperLink.forEach((k, v) -> {
            String getkey2 = k;
            NodeList getvals2 = v;

            if(getkey2.equals(getKey)) {
                for(int i=0; i<getvals2.getLength(); i++) {
                    Node node = getvals2.item(i);
                    Element ele = (Element) node;

                    // 새로 만든 doc 객체에 복제할 노드를 추가
                    Node importedNode = doc.importNode(node, true);
                    mapEle.appendChild(importedNode);
                }
                
            }
                    
        });

    }
    
    public void getStoryNode(List<String> list, Element rootEle, Document doc) {
        // Story들을 읽기 위해 반복문
        list.forEach(c -> {
            Path path = Paths.get(c);
           
            // 존재하는 것만 파일 입력 스트림으로 생성
            if(Files.exists(path)) {
                try {
                    // 문자 기반 입력스트림 생성
                    Reader reader = Files.newBufferedReader(path);
                    
                    InputSource is = new InputSource(reader);
                    is.setEncoding("UTF-8");
                    DocumentBuilderFactory dbf1 = DocumentBuilderFactory.newInstance();
                    DocumentBuilder db1 = dbf1.newDocumentBuilder();
                    Document doc1 = db1.parse(is);
                    Element storyRoot = doc1.getDocumentElement();
                    NodeList nl = doc1.getElementsByTagName("Contents");
                    
                    for(int j=0; j<nl.getLength(); j++) {
                        Node node = nl.item(j);
                        Element ele = (Element) node;
                        
                        NodeList nl2 = ele.getChildNodes();
                        
                        // Stream의 iterate 반복스트림
                        Stream.iterate(0, a -> a+1).limit(nl2.getLength()).forEach(a -> {
                            Node node2 = nl2.item(a);
                            node2.setNodeValue("");
                            
                        });
                    }
                    
                    rootEle.appendChild(doc.adoptNode(storyRoot.cloneNode(true)));
                    
                    
                } catch(Exception e) {
                    msg = "Stories/story.xml 파일 읽기 실패";
                    throw new RuntimeException(msg);
                }
                
            }
            
        });
    }
    
    public static Map<String, Element> getChapMapCollect() {
        return eachChapMap;

    }
    
}
