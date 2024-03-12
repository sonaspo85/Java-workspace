package main.java.idmlcontroller;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import main.java.CommonObj.implementOBJ;

public class createEachChapterFiles {
    implementOBJ obj = new implementOBJ();
    Map<String, Element> eachChapMap = null;
    String msg = "";
    
    public createEachChapterFiles(Map<String, Element> eachChapMap) {
        this.eachChapMap = eachChapMap;
    }
    
    public void runEachChapterFiles() {
        System.out.println("runEachChapterFiles() 시작");
        
        try {
            // 1. xml이 저장될 폴더 생성
            createXMLDirs();
            System.out.println("챕터 xml이 저장될 폴더 생성 완료");
            
        } catch(Exception e) {
            msg = "xml 폴더 생성 실패";
            throw new RuntimeException(msg);
        }
        
        // 2. 모든 챕터별로 story.xml를 merged 한 map 컬렉션을 스트림 하여, Transform 하여 출력
        eachChapMap.forEach((e, f) -> {
            try {
                // 3. eachChapMap 컬렉션으로 모은 노드들을 Document 문서에 입력 하기 위해 Document 객체 생성하기
                DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
                Document doc = docBuilder.newDocument();
                doc.setXmlStandalone(true); //standalone="no" 를 없애준다.
                
                // 4. root 노드 생성
                Element root = doc.createElement("root");
                doc.appendChild(root);
                
                // 5. 키 객체 추출
                String getKey1 = e;
                
                // 6. idml.xml 이 저장될 경로 설정
                String outPath = obj.curFirstZipDirs + File.separator + "xml" + File.separator + getKey1 + ".xml";
                Path toPath = Paths.get(outPath);

                // 7. XPath 객체 생성
                // 해당 작업을 해주는 이유는 값객체인 f는 root 태그로 감싸져 있기 때문에,
                // 삭제 해주어야 한다. 그렇지 않으면 root가 두번 찍힘
                XPathFactory xfactory = XPathFactory.newInstance();
                XPath xpath = xfactory.newXPath();

                String express = "/root/*";
                
                // 8. f값 객체를 xpath 객체로 해당 노드들 찾기
                NodeList rootNodes = (NodeList) xpath.compile(express).evaluate(f, XPathConstants.NODESET);

                // 9. root 태그 하위의 모든 노드들을 찾은 rootNodes를 반복 
                // 반복 하여, doc 객체의 자식으로 노드를 추가
                for(int u=0; u<rootNodes.getLength(); u++) {
                    Node node = rootNodes.item(u);
                    Element ele = (Element) node;
//                    root.appendChild(doc.adoptNode(ele.cloneNode(true)));

                    // 새로 만든 doc 객체에 복제할 노드를 추가
                    Node importedNode = doc.importNode(node, true);
                    root.appendChild(importedNode);
                }
                
                // 챕터별 xml 추출 
                obj.xmlTransform(toPath.toString(), doc);

            } catch (Exception e1) {
                msg = "runEachChapterFiles 예외 발생";
                throw new RuntimeException(msg);
            }
            
        });
        
        System.out.println("챕터별 xml 추출 완료");
    }
    
    public void createXMLDirs() throws Exception {
        // xml 파일이 저장될 폴더 생성
        String tarXMLPath = obj.curFirstZipDirs + File.separator + "xml" + File.separator;
        
        // idml 폴더내 xml 폴더를 curXMLDir 변수에 할당 
        obj.curXMLDir = tarXMLPath;
        Path xmlPath = Paths.get(tarXMLPath);
        
        // xml 폴더 존재 여부에 따라 삭제 또는 새롭게 생성
        if (Files.notExists(xmlPath)) {
            Files.createDirectories(xmlPath);

        } else {
            obj.recursDel(xmlPath);
            Files.createDirectories(xmlPath);
        }
    }

}
