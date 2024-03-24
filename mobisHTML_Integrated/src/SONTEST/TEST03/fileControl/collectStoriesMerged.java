package SONTEST.TEST03.fileControl;

import java.io.BufferedReader;
import java.io.File;
import java.net.URI;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import SONTEST.TEST03.subWorkClass.commonObj;
import javafx.application.Platform;

public class collectStoriesMerged {
    commonObj coj = new commonObj();
    private String inch = coj.inch;
    private String company = coj.company;
    private String lang = coj.lang; 
    
    Map<Integer, String> mapStory = null;
    NodeList designMapNodeL = null;
    List<Element> storeList = new ArrayList<>();
    
    String chapterName = "";
    private String zipPath = "";
     
    public void setItems(Map<Integer, String> mapStory, String chapterName, String zipPath, NodeList designMapNodeL) {
        this.mapStory = mapStory;
        this.chapterName = chapterName;
        this.zipPath = zipPath; 
        this.designMapNodeL = designMapNodeL;
        
        String firstStr = company.substring(0, 1).toLowerCase();
        String remainStr = company.substring(1).toLowerCase();
        String result = firstStr + remainStr;
        company = result;
    }
    
    public void runCollectStories() throws Exception {
//        System.out.println("runCollectStories 시작");
        Document doc = coj.createDomObj(null);
        Element rootEle = doc.createElement("doc1");
        rootEle.setAttribute("doc-name", chapterName);
        doc.appendChild(rootEle);
        for(int u=0; u<designMapNodeL.getLength(); u++) {
            Node node = designMapNodeL.item(u);
            rootEle.appendChild(doc.adoptNode(node).cloneNode(true));
        }

        mapStory.forEach((k,v) -> {
            int keys = k;
            String vals = v;
            
            Path path = Paths.get(vals);
            try {
                Charset charset = Charset.forName("UTF-8");

                // 1. InputStream 으로 파일 읽기
                BufferedReader br = Files.newBufferedReader(path, charset);

                Document storyDoc = coj.createDomObj(br);
                
                Element root = storyDoc.getDocumentElement();
                NodeList nList = storyDoc.getElementsByTagName("Contents");
                
                for(int i=0; i<nList.getLength(); i++) {
                    Node contentNode = nList.item(i);
                    Element ele = (Element) nList.item(i);
                    NodeList childList = contentNode.getChildNodes();
                    
                    for(int j=0; j<childList.getLength(); j++) {
                        Node childNode = childList.item(j);
                        
                        if(childNode.getNodeType() == Node.CDATA_SECTION_NODE) {
//                            String cdataTxt = childNode.getTextContent().trim();

                            childNode.setNodeValue("");
                            Element toInsert = storyDoc.createElement("CDATA");
                            ele.appendChild(toInsert);
                        }
                    }
                }
                
                rootEle.appendChild(doc.adoptNode(root.cloneNode(true)));

            } catch (Exception e1) {
                e1.printStackTrace();
            }
            
        });
        
        storeList.add(rootEle);
    }
    
    public void createMerged() throws Exception {
        Document doc = coj.createDomObj(null);
        Element rootEle = doc.createElement("docs");
        doc.appendChild(rootEle);
        rootEle.setAttribute("inch", inch);
        String dtLanguage = company + "_" + lang;
        rootEle.setAttribute("data-language", dtLanguage);
        
        storeList.stream().forEach(a -> {
            Element nodeList = a;
            
            rootEle.appendChild(doc.adoptNode(nodeList.cloneNode(true)));
        });
        
        executeTransform(doc);
    }
    
    public void executeTransform(Document doc) throws Exception {
        String parentPath = zipPath + "\\..\\..";
        Path path = Paths.get(parentPath);
        String mergedFilePath = path.normalize().toString() + File.separator + "mergedXML" + ".xml";
        coj.mergedPath = mergedFilePath;
        Path tarPath = Paths.get(mergedFilePath);
        URI tarURI = tarPath.toUri();
        
        // 1. Transformer 실행
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        transformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
        
        // 3. DOMSource 객체 생성
        DOMSource source = new DOMSource(doc);
        Result result = new StreamResult(tarURI.toString());
        transformer.transform(source, result);
    }
    
}
