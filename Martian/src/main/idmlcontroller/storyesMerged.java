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

    	Set<Map.Entry<String, List<String>>> entrySet = storyPathCollect.entrySet();
    	Iterator<Map.Entry<String, List<String>>> iterator = entrySet.iterator();

    	
    	while(iterator.hasNext()) {
    		Map.Entry<String, List<String>> entry = iterator.next();
    		String keys = entry.getKey();
    		List<String> vals = entry.getValue();
    		
    		String isocode = isocurpath.get(keys);
    		try {
    			// 새로운 Document 객체를 생성하고, 루트 요소 만들기	
    			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
				DocumentBuilder db = dbf.newDocumentBuilder();
				Document doc0 = db.newDocument();
				
				// 루트 요소 만들기
				Element ele0 = doc0.createElement("root");
				ele0.setAttribute("filename", keys);
				ele0.setAttribute("isocode", isocode);
				doc0.appendChild(ele0);
				
				Element linkEle = doc0.createElement("linkcollect");
				ele0.appendChild(linkEle);
				
				// 각 idml 별로 hyperlink 요소 추가하기
				hyperlinkCollect.forEach((m,n) -> {
					String keys2 = m;
					NodeList nl2 = n;
					
					if(keys2.equals(keys)) {
						for(int q=0; q<nl2.getLength(); q++) {
							Node node = nl2.item(q);
							Element ele = (Element) node;
							Node importnode = doc0.importNode(node, true);
							linkEle.appendChild(importnode);
							
						}
						
					}
				});
				
                Element bodyEle = doc0.createElement("body");
                ele0.appendChild(bodyEle);
                
				vals.forEach(b -> {
					Path path = Paths.get(b);
					String fileName = path.getFileName().toString();
					
					if(Files.exists(path)) {
						try {
							Reader reader = Files.newBufferedReader(path);
							InputSource is = new InputSource(reader);
							is.setEncoding("UTF-8");
							
							DocumentBuilderFactory dbf1 = DocumentBuilderFactory.newInstance();
							DocumentBuilder db1 = dbf1.newDocumentBuilder();
							Document doc1 = db1.parse(is);
							Element rootEle = doc1.getDocumentElement();

							NodeList nl = doc1.getElementsByTagName("Contents");
							
							for(int j=0; j<nl.getLength(); j++) {
								Node node = nl.item(j);
								Element ele = (Element) node;
								
								NodeList nl2 = ele.getChildNodes();
								
								for(int f=0; f<nl2.getLength(); f++) {
									Node node2 = nl2.item(f);

									if(node2.getNodeType() == Node.CDATA_SECTION_NODE) {
										node2.setNodeValue("");
										
									} 
								}
							}
							
							Node importnode2 = doc0.importNode(rootEle, true);
							bodyEle.appendChild(importnode2);
							
						} catch(Exception e) {
							msg = "collectStoryByTopic() -> vals.forEach 에러";
			                throw new RuntimeException(msg);
							
						}
						
					}

				});
				
				eachIdmlCollect.put(keys, ele0);
				
    		} catch(Exception e) {
    			msg = "collectStoryByTopic() 메소드 에러";
                throw new RuntimeException(msg);
    		}
    		
    	}
    	
    }
    
    public static Map<String, Element> getIdmlCollect() {
    	return eachIdmlCollect;
    }
    
}
