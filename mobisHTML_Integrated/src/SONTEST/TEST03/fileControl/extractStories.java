package SONTEST.TEST03.fileControl;

import java.io.BufferedReader;
import java.io.File;
import java.net.URI;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.compress.utils.FileNameUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import SONTEST.TEST03.subWorkClass.commonObj;


public class extractStories {
    private String zipPath;
    
    List<String> chapterList = new ArrayList<>();
    Map<Integer, String> mapStory = new HashMap<>();
    String mergedFilePath ="";
    List<Element> storeList = new ArrayList<>();
    DmapAttr dmapAttr;
    String chapterName;
    
    commonObj coj = new commonObj();
    collectStoriesMerged collectStoriesMerged = new collectStoriesMerged(); 
    
    public extractStories(String zipPath) {
        this.zipPath = zipPath;
        
    }
    
  
    public void runExctractStory() {
        File zipDir = new File(zipPath);
        // zipDir: C:\workspace\SONTEST\resource\temp\idmlZip
        
        if(Files.exists(zipDir.toPath())) {
            
            try {
                // idmlZip디렉토리내 각 하위 챕터 디렉토리에 접근
                accessDir(zipDir);
                
                // merged.xml 생성하기
                collectStoriesMerged.createMerged();
            } catch(Exception e1) {
                
            }
        }
        
    }
    
    // idmlZip 디렉토리의 하위 디렉토리에 접근 
    private void accessDir(File zipDir) throws Exception {
        DirectoryStream<Path> ds = Files.newDirectoryStream(zipDir.toPath());
        
        // chapter 디렉토리 반복문 실행
        ds.forEach(a -> {
            String extenstion = FileNameUtils.getExtension(a.toString());
            
            if(Files.isDirectory(a)) {
                Path DirName = a.getFileName();
//                System.out.println("aaa: " + a.toString());
                try {
                    // Stories 및 designmap.xml 을 제외한 파일 모두 삭제
                    deleteChapterDir(a);
                    
                } catch(Exception e1) {
                    
                }
                
            } 
            else if(Files.isRegularFile(a) && extenstion.equals("zip")) {  // chapter별 zip파일 삭제, 압축을 풀었으니 더이상 필요 없기 때문에,  
                try {
                    Files.delete(a);
                    
                } catch (Exception e2) {
                    e2.printStackTrace();
                }
            }
        });

    }
    
    // Stories 및 designmap.xml 제외한 파일 모두 삭제
    private void deleteChapterDir(Path chapterFile) throws Exception {
        DirectoryStream<Path> subEntry = Files.newDirectoryStream(chapterFile);
        
        subEntry.forEach(a -> {
            Path fileName = a.getFileName();
            
            try {
                if(Files.isDirectory(a) && !fileName.toString().equals("Stories")) {
                    coj.delteFolder(a);
                    
                } 
                else if(Files.isRegularFile(a) && fileName.toString().equals("designmap.xml")) {
                    // designmap 파일에서 @StoryList 값 추출
                    Path designMapPath = a;
                    dmapAttr = new DmapAttr(a);
                    
                    // Stories 파일들을 mapStory 컬렉션 객체 목록으로 수집하기
                    dmapAttr.extractAttrName();
                    mapStory = dmapAttr.getMapList();

                    // chapter 이름 추출
                    int pathNameCnt = a.getParent().getNameCount()-1;
                    chapterName = a.getName(pathNameCnt).toString();
                    
                    // designmap.xml 파일에서 HyperlinkURLDestination, Hyperlink 만 걸러내기
                    NodeList designMapNodeL = extractMap(designMapPath);
                    
                    //---------------------------------
                    // mapStory 맵 컬렉션으로 모은 모든 Stories.xml 파일에 접근하여, 
                    // 파일의 root 엘리먼트를 챕터 마다 Stories를 그룹화
                    collectStoriesMerged.setItems(mapStory, chapterName, zipPath, designMapNodeL); 
                    collectStoriesMerged.runCollectStories();
                    
                }
            } catch(Exception e1) {
                e1.printStackTrace();
            }
            
        });

    }
            
    // designmap.xml 파일에서 쓸모있는 정보인 HyperlinkURLDestination, Hyperlink 만 걸러내기
    public NodeList extractMap(Path designMapPath) throws Exception {
        Charset charset = Charset.forName("UTF-8");
        // 1. InputStream 으로 파일 읽기
        BufferedReader br = Files.newBufferedReader(designMapPath, charset);
        
        // DOM 트리 객체 생성 하기
        Document doc = coj.createDomObj(br);
        
        // 5. 문서의 root 요소에 접근하기
        Element root = doc.getDocumentElement();
        
        // XPath 객체 생성
        XPath xpath = XPathFactory.newInstance().newXPath();
        
        // 찾을 정규식
        String express = "Document/HyperlinkURLDestination | Document/Hyperlink";
        NodeList nodeList = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
        
        return nodeList;
    }

}
