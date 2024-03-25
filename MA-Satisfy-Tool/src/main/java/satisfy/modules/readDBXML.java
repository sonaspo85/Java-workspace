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

public class readDBXML {
    implementOBJ obj = new implementOBJ();
    Map<Integer, List<String>> tv1Map = new HashMap<>();
    Map<Integer, List<String>> tv2Map = new HashMap<>();
    Map<Integer, List<String>> tv3Map = new HashMap<>();
    Map<Integer, List<String>> tv4Map = new HashMap<>();
    Map<Integer, List<String>> tv5Map = new HashMap<>();
    Map<Integer, List<String>> tv6Map = new HashMap<>();
    
    List<String> perList = new ArrayList<>();
    
    Document doc = null;
    String msg = "";
    XPath xpath = XPathFactory.newInstance().newXPath();
    
    public void runDBxml(String dbFStr) {
        System.out.println("runDBxml() 시작");
        
        
        try {
            System.out.println("dbFStr: " + dbFStr);
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
            getTV1(doc);
            getTV2(doc);
            getTV3(doc);
            getTV4(doc);
            getTV5(doc);
            getTV6(doc);
            
            // obj에 저장
            obj.tv1Map = tv1Map; 
            obj.tv2Map = tv2Map;
            obj.tv3Map = tv3Map;
            obj.tv4Map = tv4Map;
            obj.tv5Map = tv5Map;
            obj.tv6Map = tv6Map;
            
            
            
        } catch (Exception e) {
            msg = "final-database.xml 파일 읽기 실패";
            throw new RuntimeException(msg);
        }
        
    }
    
    public void getTV1(Document doc) {
        try {
            String express = "root//competitive_price//item";
            
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);

            for (int i=0; i<nl.getLength(); i++) {
                List<String> tv1list = new ArrayList<>();
                Node node = nl.item(i);
                Element ele = (Element) node;
                int id = Integer.parseInt(ele.getAttribute("id"));
                
                tv1list.add(ele.getAttribute("t1cell1"));
                tv1list.add(ele.getAttribute("t1cell2"));
                tv1list.add(ele.getAttribute("t1cell3"));
                tv1list.add(ele.getAttribute("t1cell4"));
                
                tv1Map.put(id, tv1list);

            }
            
        } catch(Exception e) {
            msg = "competitive_price 태그 읽기 실패";
            throw new RuntimeException(msg);
            
        }
        
    }
    
    public List<String> percentage(String dbFStr) {
        List<String> perList = new ArrayList<>();
        
        try {
            File file = new File(dbFStr);
            FileInputStream fis = new FileInputStream(file);
            Reader reader = new InputStreamReader(fis, "UTF-8");
            InputSource is = new InputSource(reader);
            is.setEncoding("UTF-8");

            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            dbf.setNamespaceAware(true);
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(is);
            Element rootEle = doc.getDocumentElement();

            XPath xpath = XPathFactory.newInstance().newXPath();
            
            String express = "root/dbtempls/*";
            NodeList nl1 = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);

            

            for(int i=0; i<nl1.getLength(); i++) {
                Node node = nl1.item(i);
                Element ele = (Element) node;
                String percent = ele.getAttribute("percentage");

                perList.add(percent);
            }


            
            
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        return perList;
        
    }
    
    public void getTV2(Document doc) {
        try {
            String express = "root//automation//items//item";
            
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
            
            for (int i=0; i<nl.getLength(); i++) {
                List<String> tv2list = new ArrayList<>();
                Node node = nl.item(i);
                Element ele = (Element) node;
                int id = Integer.parseInt(ele.getAttribute("id"));
                
                tv2list.add(ele.getAttribute("t2cell1"));
                tv2list.add(ele.getAttribute("t2cell2"));
                tv2list.add(ele.getAttribute("t2cell3"));
                tv2list.add(ele.getAttribute("t2cell4"));
                tv2list.add(ele.getAttribute("t2cell5"));
                
                tv2Map.put(id, tv2list);
            }
            
        } catch(Exception e) {
            msg = "automation 태그 읽기 실패";
            throw new RuntimeException(msg);
            
        }
        
    }
    
    public void getTV3(Document doc) {
        try {
            String express = "root//safety//items//item";
            
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
            
            for (int i=0; i<nl.getLength(); i++) {
                List<String> tv3list = new ArrayList<>();
                Node node = nl.item(i);
                Element ele = (Element) node;
                int id = Integer.parseInt(ele.getAttribute("id"));
                
                tv3list.add(ele.getAttribute("t3cell1"));
                tv3list.add(ele.getAttribute("t3cell2"));
                tv3list.add(ele.getAttribute("t3cell3"));
                tv3list.add(ele.getAttribute("t3cell4"));

                tv3Map.put(id, tv3list);
                
            }

        } catch(Exception e) {
            msg = "safety 태그 읽기 실패";
            throw new RuntimeException(msg);
            
        }
        
    }
    
    public void getTV4(Document doc) {
        try {
            String express = "root//quality//items//item";
            
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
            
            for (int i=0; i<nl.getLength(); i++) {
                List<String> tv4list = new ArrayList<>();
                Node node = nl.item(i);
                Element ele = (Element) node;
                int id = Integer.parseInt(ele.getAttribute("id"));
                
                tv4list.add(ele.getAttribute("t4cell1"));
                tv4list.add(ele.getAttribute("t4cell2"));
                tv4list.add(ele.getAttribute("t4cell3"));
                tv4list.add(ele.getAttribute("t4cell4"));
                tv4list.add(ele.getAttribute("t4cell5"));

                tv4Map.put(id, tv4list);
                
            }

        } catch(Exception e) {
            msg = "safety 태그 읽기 실패";
            throw new RuntimeException(msg);
            
        }
        
    }
    
    public void getTV5(Document doc) {
        try {
            String express = "root//delivery_compliance//items//item";
            
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
            
            for (int i=0; i<nl.getLength(); i++) {
                List<String> tv5list = new ArrayList<>();
                Node node = nl.item(i);
                Element ele = (Element) node;
                int id = Integer.parseInt(ele.getAttribute("id"));
                
                tv5list.add(ele.getAttribute("t5cell1"));
                tv5list.add(ele.getAttribute("t5cell2"));
                tv5list.add(ele.getAttribute("t5cell3"));
                tv5list.add(ele.getAttribute("t5cell4"));
                tv5list.add(ele.getAttribute("t5cell5"));

                tv5Map.put(id, tv5list);
                
            }

        } catch(Exception e) {
            msg = "safety 태그 읽기 실패";
            throw new RuntimeException(msg);
            
        }
        
    }
    
    public void getTV6(Document doc) {
        try {
            String express = "root//satisfy//items//item";
            
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
            
            for (int i=0; i<nl.getLength(); i++) {
                List<String> tv6list = new ArrayList<>();
                Node node = nl.item(i);
                Element ele = (Element) node;
                int id = Integer.parseInt(ele.getAttribute("id"));
                
                tv6list.add(ele.getAttribute("t6cell1"));
                tv6list.add(ele.getAttribute("t6cell2"));
                tv6list.add(ele.getAttribute("t6cell3"));
                tv6list.add(ele.getAttribute("t6cell4"));
                tv6list.add(ele.getAttribute("t6cell5"));
                tv6list.add(ele.getAttribute("t6cell6"));
                
                tv6Map.put(id, tv6list);
                
            }
            
        } catch(Exception e) {
            msg = "satisfy 태그 읽기 실패";
            throw new RuntimeException(msg);
            
        }
        
    }
}
