package main.java.idmlcontroller;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import net.sf.saxon.lib.NamespaceConstant;



public class getDesMapAttr {
    Path newZipDir = null;
    List<String> storyVals = new ArrayList<>();
    Map<String, List<String>> storyPathMap = new HashMap<>();
    Map<String, NodeList> getHyperLink = new HashMap<>();
    String msg = "";
    
    public getDesMapAttr(Path newZipDir) {
        this.newZipDir = newZipDir;
    }
    
    
    public void runDesMap() {
        try(DirectoryStream<Path> ds = Files.newDirectoryStream(newZipDir);) {
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {
                    Path fileName = a.getFileName();
                    accessSubList(a);
                }
                
            });
            
            
        } catch(Exception e) {
            msg = "zipDir 디렉토리 하위 폴더 접근 실패";
            e.printStackTrace();
        }

    }
    
    public void accessSubList(Path a) {
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(a);
            
            ds.forEach(b -> {
                String getName = b.getFileName().toString();

                // 4. 파일인 경우
                if(Files.isRegularFile(b)) {
                    if(getName.equals("designmap.xml")) {
                        try {
                            accessMapF(b.toAbsolutePath());
                            
                        } catch(Exception e) {
                            msg = "designmap.xml 문서 접속 오류";
                            throw new RuntimeException(msg);
                        }

                    }
                }

            });
            
        } catch(Exception e1) {
        	msg = "designmap.xml 문서 접속 오류";
            throw new RuntimeException(msg);
        }
        
    }
    
    public void accessMapF(Path mapF) {
        System.out.println("accessMapF() 시작");
        System.out.println("mapF: " + mapF);
        // idml 이름 추출
        String idmlName = mapF.getParent().getFileName().toString();
        String mapPath = mapF.toAbsolutePath().getParent().toString();
        
        try {
            Document doc = readMapF(mapF);
            
            // StoryList를 List 컬렉션의 요소로 추출
            getsListinFiles(doc, idmlName);
            getStoryPath(mapPath);
            mergedStoryF mergedStory = new mergedStoryF(storyPathMap, getHyperLink);
            mergedStory.runMergedStory();
            
        } catch (Exception e) {
            msg = "designmap.xml 파일 읽기 실패";
            throw new RuntimeException(msg);
        }
        
        
    }
    
    public Document readMapF(Path mapF) throws Exception {
        Charset charset = Charset.forName("UTF-8");
        Document doc = null;
        try {
            BufferedReader br = Files.newBufferedReader(mapF, charset);
            InputSource is = new InputSource(br);
            is.setEncoding("UTF-8");
            
            // DocumentBuilderFactory 객체 생성
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            doc = db.parse(is);
            
        } catch (IOException e) {
            msg = "readMapF() 메소드 에러";
            throw new RuntimeException(msg);
        }
        
        return doc;
    }
    
    
    public void getsListinFiles(Document doc, String idmlName) throws Exception {
        System.out.println("inSideFiles() 시작");

        Element root = doc.getDocumentElement();
        System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
        XPathFactory xfactory = XPathFactory.newInstance();
        XPath xpath = xfactory.newXPath();
        String express = "Document/@StoryList";
        String AttrStoryList = (String) xpath.compile(express).evaluate(doc, XPathConstants.STRING);
        
        // 추출한 AttrStoryList의 값을 공백으로 분리하여 배열로 저장
        String[] sListArr = AttrStoryList.split(" ");
        storyVals = Arrays.asList(sListArr);
        
        // map 컬렉션으로 수집
        getHyperLink(xpath, doc, idmlName);
    }
    
    public void getStoryPath(String mapPath) {
        // idml 이름 추출
        Path path = Paths.get(mapPath);
        String idmlName = path.getFileName().toString();
        List<String> storyFList = new ArrayList<>();
        
        storyVals.forEach(a -> {
            String fileName = a + ".xml";
            String storyFPath = mapPath + File.separator + "Stories" + File.separator + "Story_" + fileName;
            
            storyFList.add(storyFPath);
        });
        
        storyPathMap.put(idmlName, storyFList);
        
    }
    
    
    public void getHyperLink(XPath xpath, Document doc, String idmlName) {
        String express = "Document/Hyperlink | Document/HyperlinkURLDestination";
        NodeList nl = null;
        try {
            nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
            
        } catch(Exception e) {
            msg = "nl 추출 실패";
            throw new RuntimeException(msg);
        }
        
        getHyperLink.put(idmlName, nl);
    }
    
    
}
