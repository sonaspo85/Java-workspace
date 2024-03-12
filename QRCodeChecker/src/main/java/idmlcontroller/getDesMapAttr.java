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
    
    // idml 별로 모든 HyperLink를 모은 map 컬렉션
    Map<String, NodeList> getHyperLink = new HashMap<>();

    String msg = "";
    
    public getDesMapAttr(Path newZipDir) {
        this.newZipDir = newZipDir;
    }
    
    
    public void runDesMap() {
        System.out.println("runDesMap() 시작");
        
        // 1. zipDir 폴더내 각 idml 폴더에 대해 접근
        try(DirectoryStream<Path> ds = Files.newDirectoryStream(newZipDir);) {
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {
                    Path fileName = a.getFileName();
                    System.out.println("fileName: " + fileName);
                    
                    // 2. 각 idml폴더내 하위 디렉토리 접근
                    accessSubList(a);
                }
                
            });
            
            
        } catch(Exception e) {
            msg = "zipDir 디렉토리 하위 폴더 접근 실패";
//            throw new RuntimeException(msg);
            e.printStackTrace();
        }

    }
    
    public void accessSubList(Path a) {
        System.out.println("accessSubList() 시작");
        System.out.println("aaaa: " + a);
        // 3. zipDir내 각 idml 폴더에 접근
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(a);
            
            ds.forEach(b -> {
                String getName = b.getFileName().toString();
                System.out.println("getName: " + getName);
                // 4. 파일인 경우
                if(Files.isRegularFile(b)) {
                    // 5. 파일이름이 designmap.xml 인경우
                    if(getName.equals("designmap.xml")) {
                        try {
                            // 6. 각 idml 폴더내 designmap.xml 접근
                            accessMapF(b.toAbsolutePath());
                            
                        } catch(Exception e) {
                            System.out.println("designmap.xml 문서 접속 오류");
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
        
        // designmap.xml 의 부모 디렉토리의 절대 경로 추출
        String mapPath = mapF.toAbsolutePath().getParent().toString();
        
        try {
            // 7. designmap.xml 파일 읽기
            Document doc = readMapF(mapF);
            
            // 9. designmap.xml 문서내 노드에 접근하여, @StoryList를 List 컬렉션의 요소로 추출
            getsListinFiles(doc, idmlName);
            
            
            // 13. Story.xml 파일들의 위치를 컬렉션으로 수집
            getStoryPath(mapPath);
            
            // 16. storyPathMap 컬렉션으로 수집한 Story.xml 경로에 접근 하여, Story.xml 내 루트 노드에 접근
            mergedStoryF mergedStory = new mergedStoryF(storyPathMap, getHyperLink);
            mergedStory.runMergedStory();
            
        } catch (Exception e) {
            System.out.println("designmap.xml 파일 읽기 실패");
            msg = "designmap.xml 파일 읽기 실패";
            throw new RuntimeException(msg);
        }
        
        
    }
    
    public Document readMapF(Path mapF) throws Exception {
        System.out.println("readMapF() 시작");
        
        Charset charset = Charset.forName("UTF-8");
        Document doc = null;
        try {
            // 8. Files 객체의 newBufferedReader() 메소드 호출하여,
            // 문자 기반 입력스트림 객체 생성
            BufferedReader br = Files.newBufferedReader(mapF, charset);
            
            // xml 문서를 DOM 구조로 읽기 위해 InputSource 객체 생성
            InputSource is = new InputSource(br);
            
            // 인코딩 방식 지정
            is.setEncoding("UTF-8");
            
            // DocumentBuilderFactory 객체 생성
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            
            // DocumentBuilder 객체 생성
            DocumentBuilder db = dbf.newDocumentBuilder();
            
            // Document 객체 생성, 매개 변수로 xml 문서 할당
            doc = db.parse(is);
            
        } catch (IOException e) {
            msg = "readMapF() 메소드 에러";
            throw new RuntimeException(msg);
        }
        
        return doc;
    }
    
    
    public void getsListinFiles(Document doc, String idmlName) throws Exception {
        System.out.println("inSideFiles() 시작");

        // 10. 문서의 루트 요소에 접근하기
        Element root = doc.getDocumentElement();
        
        // regex2.0을 사용하기 위해 Saxon 객체의 XPathFactory 객체로 설정
        System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
        XPathFactory xfactory = XPathFactory.newInstance();
        
        // XPath 객체 생성
        XPath xpath = xfactory.newXPath();
        String express = "Document/@StoryList";
        
        // xpath 객체를 사용하여 regex 에 일치하는 @StoryList 속성을 찾아 값 추출
        String AttrStoryList = (String) xpath.compile(express).evaluate(doc, XPathConstants.STRING);
        
        // 추출한 AttrStoryList의 값을 공백으로 분리하여 배열로 저장
        String[] sListArr = AttrStoryList.split(" ");
        
        // 11. asList() 메소드로 배열을 List 컬렉션의 목록으로 저장
        storyVals = Arrays.asList(sListArr);
        
        // 12. designmap.xml 파일에서 Hyperlink 요소만 추출하여 map 컬렉션으로 수집
        getHyperLink(xpath, doc, idmlName);
    }
    
    public void getStoryPath(String mapPath) {
        System.out.println("getStoryPath() 시작");
        
        // idml 이름 추출
        Path path = Paths.get(mapPath);
        String idmlName = path.getFileName().toString();
        
        // 14. Story.xml 경로를 List 컬렉션으로 저장
        // 여기서 storyFList 컬렉션을 생성하는 이유는
        // 전역 변수로 생성할 경우 idml 폴더를 반복할때마다 초기화 되는것이 아니라, 계속 차곡차곡 쌓이게 된다.
        List<String> storyFList = new ArrayList<>();
        
        storyVals.forEach(a -> {
            String fileName = a + ".xml";
            String storyFPath = mapPath + File.separator + "Stories" + File.separator + "Story_" + fileName;
            
            storyFList.add(storyFPath);
        });
        
        // 15. map 컬렉션으로 키객체: idml 폴더 이름, 
        // 값객체: story.xml 경로로 수집
        storyPathMap.put(idmlName, storyFList);
        
        
    }
    
    
    public void getHyperLink(XPath xpath, Document doc, String idmlName) {
        System.out.println("getHyperLink() 시작");
        
        String express = "Document/Hyperlink | Document/HyperlinkURLDestination";
        NodeList nl = null;
        try {
            nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
            
        } catch(Exception e) {
            System.out.println("nl 추출 실패");
            msg = "nl 추출 실패";
            throw new RuntimeException(msg);
        }
        
        // 13. designmap.xml 파일에서 변수 express 를 챕터 이름 별로 map 컬렉션으로 수집
        getHyperLink.put(idmlName, nl);

        
    }
    
    
}
