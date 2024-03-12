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
    
    //s 
    public void setItems(Map<Integer, String> mapStory, String chapterName, String zipPath, NodeList designMapNodeL) {
        this.mapStory = mapStory;
        this.chapterName = chapterName;
        this.zipPath = zipPath; 
        this.designMapNodeL = designMapNodeL;
        
        
        // 회사명 소문자로 변경 -----
        String firstStr = company.substring(0, 1).toLowerCase();
        String remainStr = company.substring(1).toLowerCase();
        String result = firstStr + remainStr;
        company = result;
    }
    
    public void runCollectStories() throws Exception {
//        System.out.println("runCollectStories 시작");
        // 빈 DOM 트리 객체 생성
        Document doc = coj.createDomObj(null);
        
        // 최상위 root 요소 생성
        Element rootEle = doc.createElement("doc1");
        rootEle.setAttribute("doc-name", chapterName);
        doc.appendChild(rootEle);
        
        //---------------------------------------
        // designmap.xml 에서 추출한 HyperlinkURLDestination, Hyperlink를 doc 객체에 삽입
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
                
                // 노드 이름이 Contents 태그를 찾음, 찾아서 지우기 위해, CDATA를 가지고 있는 불필요한 부분임
                NodeList nList = storyDoc.getElementsByTagName("Contents");
                
                for(int i=0; i<nList.getLength(); i++) {
                    Node contentNode = nList.item(i);
                    Element ele = (Element) nList.item(i);
                    
                    // contentNode의 자식 노드들을 얻어, CDATA 타입인 자식 노드가 있는지 찾기
                    NodeList childList = contentNode.getChildNodes();
                    
                    for(int j=0; j<childList.getLength(); j++) {
                        Node childNode = childList.item(j);
                        
                        if(childNode.getNodeType() == Node.CDATA_SECTION_NODE) {
//                            String cdataTxt = childNode.getTextContent().trim();
                            
                            // CDATA 데이터를 비우고,
                            childNode.setNodeValue("");
                            
                            // 새로운 Element 생성하여 추가 하기
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
        
//        System.out.println("storeList 개수: " + storeList.size());
    }
    
    // list 컬렉션의 요소로 모은 store.xml 의 root 엘리먼트를 하나의 xml 파일로 추출
    public void createMerged() throws Exception {
     // stories 들을 하나로 모으기 위해 빈 Dom 트리 객체 생성 하기
        Document doc = coj.createDomObj(null);
        
        // 최상위 root  요소 생성
        Element rootEle = doc.createElement("docs");
        doc.appendChild(rootEle);
        
        // 최상위 요소 속성 생성
        rootEle.setAttribute("inch", inch);
        String dtLanguage = company + "_" + lang;
        rootEle.setAttribute("data-language", dtLanguage);
        
        storeList.stream().forEach(a -> {
            Element nodeList = a;
            
            rootEle.appendChild(doc.adoptNode(nodeList.cloneNode(true)));
        });
        
        // Transformer 객체를 사용하여 merged.xml 추출
        executeTransform(doc);
    }
    
    public void executeTransform(Document doc) throws Exception {
        // merged.xml 파일이 생성될 경로를 상대 경로로 생성
        String parentPath = zipPath + "\\..\\..";
        Path path = Paths.get(parentPath);
        String mergedFilePath = path.normalize().toString() + File.separator + "mergedXML" + ".xml";
        coj.mergedPath = mergedFilePath;
        
        // 저장할 위치 정보를 가지고 있는 StreamResult 객체 생성
        Path tarPath = Paths.get(mergedFilePath);
        URI tarURI = tarPath.toUri();
        
        // 1. Transformer 실행
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        
        // 2. setOutputProperty() 메소드로 출력 포멧 설정
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        transformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
        
        // 3. DOMSource 객체 생성
        // 저장할 대상인 원본 XML 문서를 Source객체로 생성
        DOMSource source = new DOMSource(doc);
        
        // 4. StreamResult 객체 생성
        // 저장할 위치 정보를 가지고 있는 StreamResult 객체 생성
        
        Result result = new StreamResult(tarURI.toString());
        
        // 5. transform() 메소드를 호출하여 파일로 저장하기
        transformer.transform(source, result);
    }
    
}
