package main.java.satisfy.modules;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
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
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.satisfy.Common.implementOBJ;

public class readFinallyDB {
    implementOBJ obj = new implementOBJ();
    
    Document doc = null;
    String msg = "";
    XPath xpath = XPathFactory.newInstance().newXPath();
    
    int o = 0;
    public Map<Integer, Map<String, List<String>>> totalDBmap2 = new HashMap<>();
    
    public void runDBxml(String dbFStr) {
        Map<Integer, Map<String, List<String>>> totalDBmap = new HashMap<>();
        
        try {
            File file = new File(dbFStr);
            FileInputStream fis = new FileInputStream(file);
            Reader reader = new InputStreamReader(fis, "UTF-8");
            InputSource is = new InputSource(reader);
            is.setEncoding("UTF-8");
            
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            dbf.setNamespaceAware(true);
            DocumentBuilder db = dbf.newDocumentBuilder();
            doc = db.parse(is);
            Element rootEle = doc.getDocumentElement();
            
            xpath = XPathFactory.newInstance().newXPath();
            
            String express = "root//dbtempls/competitive_price//item"; 
            String attrType = "t1cell1";
            getData(doc, express, attrType, totalDBmap);
            
            express = "root//dbtempls/automation//item"; 
            attrType = "t2cell1";
            getData(doc, express, attrType, totalDBmap);
            
            express = "root//dbtempls/safety//grouped"; 
            attrType = "t3cell1";
            getData2(doc, express, attrType, totalDBmap);
            
            express = "root//dbtempls/quality//item"; 
            attrType = "t4cell1";
            getData(doc, express, attrType, totalDBmap);
            
            express = "root//dbtempls/delivery_compliance//item"; 
            attrType = "t5cell1";
            getData(doc, express, attrType, totalDBmap);
            
            express = "root//dbtempls/satisfy//items"; 
            attrType = "null";
            getData3(doc, express, attrType, totalDBmap);
            
            totalDBmap2 = totalDBmap;
        } catch (Exception e) {
            msg = "final-database.xml 파일 읽기 실패";
            throw new RuntimeException(msg);
        }
        
    }
    
    public void getData(Document doc, String express, String attrType, Map<Integer, Map<String, List<String>>> totalDBmap) {
        System.out.println("getData() 시작");
        
        try {
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
            
            for (int i=0; i<nl.getLength(); i++) {
                List<String> list = new ArrayList<>();
                Map<String, List<String>> finalDBmap = new HashMap<>();
                
                Node node = nl.item(i);
                Element ele = (Element) node;
                String type = ele.getAttribute(attrType);
                
                if(attrType.equals("t1cell1")) {
                    list.add(ele.getAttribute("result"));
                    
                } else if(attrType.equals("t2cell1")) {
                    list.add(ele.getAttribute("t2cell5"));
                      
                } else if(attrType.equals("t4cell1")) {
                    list.add(ele.getAttribute("t4cell5"));
                    
                } else if(attrType.equals("t5cell1")) {
                    list.add(ele.getAttribute("t5cell5"));
                    
                }   
                
                list.add(ele.getAttribute("ranking"));
                
                finalDBmap.put(type, list);
//                obj.finalDBmap.put(o, finalDBmap);
                totalDBmap.put(o, finalDBmap);
                
                o += 1;
            }
            
        } catch(Exception e) {
            msg = "competitive_price 태그 읽기 실패";
            throw new RuntimeException(msg);
            
        }
        
    }
    
    public void getData2(Document doc, String express, String attrType, Map<Integer, Map<String, List<String>>> totalDBmap) {
        System.out.println("getData2() 시작");
        
        try {
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);

            for (int i=0; i<nl.getLength(); i++) {
                List<String> list = new ArrayList<>();
                Map<String, List<String>> finalDBmap = new HashMap<>();
                
                Node node = nl.item(i);
                Element ele = (Element) node;
                
                if(attrType.equals("t3cell1")) {
                    list.add(ele.getAttribute("result"));
                    
                }
                
                list.add(ele.getAttribute("ranking"));

                NodeList nl2 = ele.getChildNodes();
                
                int y = 0;
                for(int j=0; j<nl2.getLength(); j++) {
                    Node node2 = nl2.item(j);
                    
                    
                    if(node2.getNodeType() == Node.ELEMENT_NODE) {
                        Element ele2 = (Element) node2;
                        
                        if(y == 0) {
                            String type = ele2.getAttribute(attrType);
//                            System.out.println("type: " + type);
                            finalDBmap.put(type, list);                            
//                            obj.finalDBmap.put(o, finalDBmap);
                            totalDBmap.put(o, finalDBmap);
                            o += 1;
                        }
                        
                        y += 1;
                        
                    }
                     
                }

            }
            
        } catch(Exception e) {
            msg = "competitive_price 태그 읽기 실패";
            throw new RuntimeException(msg);
            
        }
        
    }
    
    public void getData3(Document doc, String express, String attrType, Map<Integer, Map<String, List<String>>> totalDBmap) {
        System.out.println("getData3() 시작");
        
        try {
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);

            for (int i=0; i<nl.getLength(); i++) {
                List<String> list = new ArrayList<>();
                Map<String, List<String>> finalDBmap = new HashMap<>();
                
                Node node = nl.item(i);
                Element ele = (Element) node;
                String type = "만족도 조사";
                
                list.add(ele.getAttribute("result"));
                list.add(ele.getAttribute("ranking"));
                
                finalDBmap.put(type, list);
                totalDBmap.put(o, finalDBmap);
                o += 1;
            }
            
        } catch(Exception e) {
            msg = "competitive_price 태그 읽기 실패";
            throw new RuntimeException(msg);
            
        }
        
    }
    
    public Map<Integer, Map<String, List<String>>> getFinalMap() {
        return totalDBmap2;
        
        
    }
    
    
}
