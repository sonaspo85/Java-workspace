package main.java.satisfy.modules;

import java.io.File;
import java.net.URI;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import main.java.satisfy.Common.implementOBJ;
import net.sf.saxon.lib.NamespaceConstant;

public class saveDBF2 {
    implementOBJ obj = new implementOBJ();
    String express = "";
    String lbid = "";
    String dbFStr = "";
    String per = "";
    
    public void setInit(String lbid, String dbFStr, String per) {
        System.out.println("setInit() 시작");
        this.lbid = lbid;
        this.dbFStr = dbFStr;
        this.per = per;
        
    }
    
    public void updateXMLFile() {
        System.out.println("updateXMLFile() 시작");
        
        try {
            File file = new File(dbFStr);
            
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(file);
            Element rootEle = doc.getDocumentElement();
            
            XPathFactory factory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
            XPath xpath = factory.newXPath();
            
            if(lbid.equals("per1")) {
                express = "root//competitive_price";
                
            } else if(lbid.equals("per2")) {
                express = "root//automation";
                
            } else if(lbid.equals("per3")) {
                express = "root//safety";
                
            } else if(lbid.equals("per4")) {
                express = "root//quality";
                
            } else if(lbid.equals("per5")) {
                express = "root//delivery_compliance";
                
            } else if(lbid.equals("per6")) {
                express = "root//satisfy";
                
            }
            
            
            System.out.println("express: " + express);
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
            
            for (int i = 0; i < nl.getLength(); i++) {
                Node node = nl.item(i);
                Element ele = (Element) node;
                
                ele.setAttribute("percentage", per);
            }
            
            try {
                // 출력 파일 지정
                File outF = new File(dbFStr);
                URI out2 = outF.toURI();
                
                // 1. TransformerFactory 객체 생성
                TransformerFactory transformerFactory = TransformerFactory.newInstance();
                // 2. Transformer 객체 생성 
                Transformer trans = transformerFactory.newTransformer();
                trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
                trans.setOutputProperty(OutputKeys.INDENT, "no");
                trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
                
                // 4. DOMSource 객체 생성
                DOMSource source = new DOMSource(doc);
                Result result = new StreamResult(out2.toString());
                trans.transform(source, result);

            } catch(Exception e4) {
                e4.printStackTrace();
                
            }
            

        } catch(Exception e3) {
            e3.printStackTrace();
        }
        
    }
    
}
