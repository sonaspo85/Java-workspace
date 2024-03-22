package main.idmlcontroller;

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

import main.Common.implementOBJ;
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
        System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(obj.zipDirP);
            
            ds.forEach(a -> {
                String getName = a.getFileName().toString();
                accessSubLists(a);
                
            });
            
        } catch(Exception e) {
            msg = "각 idml 폴더 접근 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        }
        
    }
    
    public void accessSubLists(Path a) {
        System.out.println("accessSubLists() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(a);
            
            ds.forEach(b -> {
                String getName = b.getFileName().toString();
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
        
        String idmlName = dmap.getParent().getFileName().toString();
        String parDir = dmap.getParent().toString();
        String fullPath = dmap.toAbsolutePath().toString();
        
        Charset charset = Charset.forName("UTF-8");
        
        try { 
            // 1. 문서 읽기
            Document doc = obj.readFile(fullPath);
            
            // 2. 루트 요소 접근
            Element root = doc.getDocumentElement();
            XPathFactory xfactory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
            XPath xpath = xfactory.newXPath();
            String express = "Document/@StoryList";
            String storyList = (String) xpath.compile(express).evaluate(doc, XPathConstants.STRING);
            sList = Arrays.asList(storyList.split(" "));
            
            createStoryPath(parDir);
            gethyperNode(xpath, doc, idmlName);
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
        
        String idmlName = Paths.get(parDir).getFileName().toString();
        List<String> storyFullPath = new ArrayList<>();
        
        sList.forEach(a -> {
            String fileName = a + ".xml";
            String storyPath = parDir + File.separator + "Stories" + File.separator + "Story_" + fileName;
            storyFullPath.add(storyPath);
        });
        
        storyPathCollect.clear();
        storyPathCollect.put(idmlName, storyFullPath);
        
    }
    
    public void gethyperNode(XPath xpath, Document doc, String idmlName) {
        System.out.println("gethyperNode() 시작");
        
        String express = "Document/Hyperlink | Document/HyperlinkURLDestination";
        
        try {
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
            hyperlinkCollect.put(idmlName, nl);
            
        } catch (Exception e) {
            msg = "Hyperlink 추출 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        } 
        
    }
    
}
