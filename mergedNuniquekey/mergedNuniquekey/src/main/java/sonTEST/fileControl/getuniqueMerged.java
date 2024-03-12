package main.java.sonTEST.fileControl;

import java.io.BufferedReader;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Stream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.commonObj.commonImpleObj;

public class getuniqueMerged {
	commonImpleObj coj = new commonImpleObj();
	Map<String, Element> storyMap = new HashMap<>();
	
	// newMerged.xml 파일의 모든 idPkg:Story 를 map 컬렉션으로 수집 
	public void runUniqueMerged() throws Exception {
		String uMergedFile = coj.outXMLPath + File.separator + "newMerged.xml";
//		System.out.println("uMergedFile: " + uMergedFile);
		Path mergedFilePath = Paths.get(uMergedFile); 
		
		BufferedReader br = Files.newBufferedReader(mergedFilePath, coj.charset);
		InputSource is = new InputSource(br);
		is.setEncoding("UTF-8");
		
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		Document doc = db.parse(is);
		
		Element eleRoot = doc.getDocumentElement();
		
		NodeList docNodes = eleRoot.getChildNodes();
		
		Stream.iterate(0, q-> q<docNodes.getLength(), q->q+1).forEach(q -> {
			Node node1 = docNodes.item(q);
			Element ele1 = (Element) node1;
			
			String chapName = ele1.getAttribute("chapName");
			String zipChapterDir = coj.srcPath + File.separator + "zipDir" + File.separator + chapName + File.separator + "Stories";
			
			NodeList storyNodes = ele1.getChildNodes();
			for(int w=0; w<storyNodes.getLength(); w++) {
				Node node2 = storyNodes.item(w);
				Element ele2 = (Element) node2;
				
				if(ele2.getNodeName().equals("idPkg:Story")) {
					String storyName = ele2.getAttribute("storyName");
					String tarStoryDir = zipChapterDir + File.separator + storyName;
					
					storyMap.put(tarStoryDir, ele2);
				}
			}

		});
	
		outStoryXML();
		
	}
	
	public void outStoryXML() throws Exception {
		storyMap.forEach((k,v) -> {
			try {
				DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
				DocumentBuilder db = dbf.newDocumentBuilder();
				Document doc = db.newDocument();
//				Element eee = doc.createElement("ddd");
//				doc.appendChild(eee);
				
//				storyFile = k;
				Element ele = v;
				
				doc.appendChild(doc.adoptNode(ele.cloneNode(true)));
				
				coj.xmlTransform(k, doc);
				
			} catch(Exception e1) {
				e1.printStackTrace();
			}
			
		});
		
	}
	
}
