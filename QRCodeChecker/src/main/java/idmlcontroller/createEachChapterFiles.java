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
        try {
            createXMLDirs();
            
        } catch(Exception e) {
            msg = "xml 폴더 생성 실패";
            throw new RuntimeException(msg);
        }
        
        eachChapMap.forEach((e, f) -> {
            try {
                // eachChapMap 컬렉션으로 모은 노드들을 Document 문서에 입력 하기 위해 Document 객체 생성
                DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
                Document doc = docBuilder.newDocument();
                doc.setXmlStandalone(true); //standalone="no" 를 없애준다.
                
                // root 노드 생성
                Element root = doc.createElement("root");
                doc.appendChild(root);
                String getKey1 = e;
                String outPath = obj.curFirstZipDirs + File.separator + "xml" + File.separator + getKey1 + ".xml";
                Path toPath = Paths.get(outPath);

                XPathFactory xfactory = XPathFactory.newInstance();
                XPath xpath = xfactory.newXPath();
                String express = "/root/*";
                
                // f값 객체 노드 찾기
                NodeList rootNodes = (NodeList) xpath.compile(express).evaluate(f, XPathConstants.NODESET);
 
                // 반복 하여, doc 객체의 자식으로 노드를 추가
                for(int u=0; u<rootNodes.getLength(); u++) {
                    Node node = rootNodes.item(u);
                    Element ele = (Element) node;
                    Node importedNode = doc.importNode(node, true);
                    root.appendChild(importedNode);
                }

                obj.xmlTransform(toPath.toString(), doc);

            } catch (Exception e1) {
                msg = "runEachChapterFiles 예외 발생";
                throw new RuntimeException(msg);
            }
            
        });
    }
    
    public void createXMLDirs() throws Exception {
        String tarXMLPath = obj.curFirstZipDirs + File.separator + "xml" + File.separator;
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
