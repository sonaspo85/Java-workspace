package main.java.zipController;

import java.io.File;
import java.io.FileInputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.zipController.Common.implementOBJ;

public class readValidF {
    implementOBJ obj = new implementOBJ();
    
    
    public void runReadxml() throws Exception {
        File file = new File(obj.validationF);
        
        if(file.exists()) {
            FileInputStream fis = new FileInputStream(file);
            InputSource is = new InputSource(fis);
            is.setEncoding("UTF-8");
            
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(is);
              
            Element rootTag = doc.getDocumentElement();
            
            NodeList nl = rootTag.getChildNodes(); 
            
            for(int i=0; i<nl.getLength(); i++) {
                Node node1 = nl.item(i);
                Element ele1 = (Element) node1;
                
                if(ele1.getNodeName().equals("model")) {
                    obj.modelStr = ele1.getAttribute("name");
                    
                } else if(ele1.getNodeName().equals("product")) {
                    obj.productStr = ele1.getAttribute("type");
                    
                } else if(ele1.getNodeName().equals("optical")) {
                    obj.opticalStr = ele1.getAttribute("type");
                    
                }

            }

            fis.close();
              
        } else {
            return;
        }
    }
}
