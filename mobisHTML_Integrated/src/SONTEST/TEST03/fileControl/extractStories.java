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
        if(Files.exists(zipDir.toPath())) {
            
            try {
                accessDir(zipDir);
                collectStoriesMerged.createMerged();
            } catch(Exception e1) {
                
            }
        }
        
    }
    
    private void accessDir(File zipDir) throws Exception {
        DirectoryStream<Path> ds = Files.newDirectoryStream(zipDir.toPath());
        
        ds.forEach(a -> {
            String extenstion = FileNameUtils.getExtension(a.toString());
            
            if(Files.isDirectory(a)) {
                Path DirName = a.getFileName();
                try {
                    deleteChapterDir(a);
                    
                } catch(Exception e1) {
                    
                }
                
            } 
            else if(Files.isRegularFile(a) && extenstion.equals("zip")) {  
                try {
                    Files.delete(a);
                    
                } catch (Exception e2) {
                    e2.printStackTrace();
                }
            }
        });

    }
    
    private void deleteChapterDir(Path chapterFile) throws Exception {
        DirectoryStream<Path> subEntry = Files.newDirectoryStream(chapterFile);
        
        subEntry.forEach(a -> {
            Path fileName = a.getFileName();
            
            try {
                if(Files.isDirectory(a) && !fileName.toString().equals("Stories")) {
                    coj.delteFolder(a);
                    
                } 
                else if(Files.isRegularFile(a) && fileName.toString().equals("designmap.xml")) {
                    Path designMapPath = a;
                    dmapAttr = new DmapAttr(a);
                    dmapAttr.extractAttrName();
                    mapStory = dmapAttr.getMapList();

                    // chapter 이름 추출
                    int pathNameCnt = a.getParent().getNameCount()-1;
                    chapterName = a.getName(pathNameCnt).toString();
                    NodeList designMapNodeL = extractMap(designMapPath);

                    collectStoriesMerged.setItems(mapStory, chapterName, zipPath, designMapNodeL); 
                    collectStoriesMerged.runCollectStories();
                    
                }
            } catch(Exception e1) {
                e1.printStackTrace();
            }
            
        });

    }
            
    public NodeList extractMap(Path designMapPath) throws Exception {
        Charset charset = Charset.forName("UTF-8");
        // 1. InputStream 으로 파일 읽기
        BufferedReader br = Files.newBufferedReader(designMapPath, charset);        
        Document doc = coj.createDomObj(br);
        
        // 5. 문서의 root 요소에 접근하기
        Element root = doc.getDocumentElement();
        XPath xpath = XPathFactory.newInstance().newXPath();
        String express = "Document/HyperlinkURLDestination | Document/Hyperlink";
        NodeList nodeList = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
        
        return nodeList;
    }

}
