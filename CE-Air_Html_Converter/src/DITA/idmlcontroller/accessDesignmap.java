package DITA.idmlcontroller;

import java.io.File;
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

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import DITA.Common.implementOBJ;
import net.sf.saxon.lib.NamespaceConstant;

public class accessDesignmap {
    implementOBJ obj = new implementOBJ();
    String msg = "";
    List<String> sList = new ArrayList<>();
    Map<String, List<String>> storyPathCollect = new HashMap<>();
    Map<String, NodeList> hyperlinkCollect = new HashMap<>();
    Map<String, String> isocurpath = new HashMap<>();
    
    
    
    public void eachDirs(Map<String, String> isocurpath) {
        System.out.println("eachDirs() 시작");
        
        this.isocurpath = isocurpath;
        
        // 3. regex2.0 을 사용하기 위해 Saxon 객체의 XPathFactory 객체 설정
        System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(obj.zipDirP);
            
            ds.forEach(a -> {
                String getName = a.getFileName().toString();
//                System.out.println("uuu: " + a.toAbsolutePath().toString());
                
                // 6. zipDir 디렉토리내 압축 해제된 하위 디렉토리 접속
                accessSubLists(a);
                
            });
            
        } catch(Exception e) {
            msg = "각 idml 폴더 접근 실패";
            System.out.println("msg: " + msg);
//            e.printStackTrace();
            throw new RuntimeException(msg);
        }
        
    }
    
    public void accessSubLists(Path a) {
        System.out.println("accessSubLists() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(a);
            
            ds.forEach(b -> {
                String getName = b.getFileName().toString();
                
                // designmap.xml 파일 인 경우 designmap.xml 파일 읽기
                if(Files.isRegularFile(b) && getName.equals("designmap.xml")) {
                    accessDMapF(b);
                }
            });
            
        } catch(Exception e) {
            msg = "designmap.xml 읽기 실패1";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        }
        
        
    }
    
    public void accessDMapF(Path dmap) {
        System.out.println("accessDMapF() 시작");
        
        // 각 IDML 폴더 이름 및 풀 경로 추출
        String idmlName = dmap.getParent().getFileName().toString();
        String parDir = dmap.getParent().toString();
        String fullPath = dmap.toAbsolutePath().toString();
        
        Charset charset = Charset.forName("UTF-8");
        
        try { 
            // 1. designmap.xml 을 DocumentBuilder 와 InputSource로 읽기
            Document doc = obj.readFile(fullPath);
            
            // 2. 문서의 루트 요소에 접근하기
            Element root = doc.getDocumentElement();
            
//            // 3. regex2.0 을 사용하기 위해 Saxon 객체의 XPathFactory 객체 설정
//            System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
            XPathFactory xfactory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
            
            // 4. XPath 객체 생성
            XPath xpath = xfactory.newXPath();
            
            // 5. 정규표현식으로 Document/@StoryList 속성값을 추출
            String express = "Document/@StoryList";
            String storyList = (String) xpath.compile(express).evaluate(doc, XPathConstants.STRING);
            
            // 6. 추출된 @StoryList 속성값을 공백으로 분리하여 List 컬렉션으로 수집
//            List<String> sList = new ArrayList<>();
            sList = Arrays.asList(storyList.split(" "));
            
            // 7. sList로 수집한 각각의 값들로 Stories 디렉토리내 모든 xml 파일들을 절대 경로로 생성하기
            createStoryPath(parDir);
            
            // 8. designmap.xml 파일내 접근하여 Hyperlink 요소 추출 하기
            gethyperNode(xpath, doc, idmlName);
            
            // 9. storyPathCollect 로 수집한 map 컬렉션과 hyperlink 를 수집한 hyperlinkCollect를 storyesMerged 으로 전달
            storyesMerged sm = new storyesMerged(hyperlinkCollect, storyPathCollect, isocurpath);
            sm.collectStoryByTopic();

        } catch (Exception e) {
            msg = "designmap.xml 읽기 실패2";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        }
        
        
        
    }
    
    public void createStoryPath(String parDir) {
        System.out.println("createStoryPath 시작");
        
        // idml 폴더 이름 추출
        String idmlName = Paths.get(parDir).getFileName().toString();
        
        // sList로 수집한 컬렉션을 전체 경로로 조합 하여 List 컬렉션으로 수집하기
        List<String> storyFullPath = new ArrayList<>();
        
        sList.forEach(a -> {
            String fileName = a + ".xml";
            String storyPath = parDir + File.separator + "Stories" + File.separator + "Story_" + fileName;
//            System.out.println("storyPath: " + storyPath);
            storyFullPath.add(storyPath);
        });
        
        // 만약, map 컬렉션이 비어 있지 않다면 초기화
        storyPathCollect.clear();
        
        // map 컬렉션으로 키객체: idml 폴더 이름, 값 객체:story.xml 이 위치한 전체 경로를 수집
        storyPathCollect.put(idmlName, storyFullPath);
        
    }
    
    public void gethyperNode(XPath xpath, Document doc, String idmlName) {
        System.out.println("gethyperNode() 시작");
        
        // Hyperlink 노드와 HyperlinkURLDestination를 추출
        String express = "Document/Hyperlink | Document/HyperlinkURLDestination";
        
        try {
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
            
            // idml 별로 Hyperlink 노드의 집합인 NodeList 를 map 컬렉션으로 반환 
            hyperlinkCollect.put(idmlName, nl);
            
        } catch (Exception e) {
            msg = "Hyperlink 추출 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        } 
        
    }
    
}
