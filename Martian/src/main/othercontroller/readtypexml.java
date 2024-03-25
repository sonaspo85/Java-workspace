package main.othercontroller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import main.Common.implementOBJ;



public class readtypexml {
    implementOBJ obj = new implementOBJ();
    String msg = "";
    List<String> typeL = new ArrayList<>();
    
    
    public List<String> runtypeReadF() throws Exception {
        String langF = obj.resourceDir + File.separator + "type.xml";
        Document doc = obj.readFile(langF);
        Element root = doc.getDocumentElement();
        NodeList nl = root.getChildNodes(); 
        
        for(int i=0; i<nl.getLength(); i++) {
            Node node1 = nl.item(i);
            
            if (node1.getNodeType() == Node.ELEMENT_NODE) {
                Element child = (Element) node1;
                String typestr = child.getAttribute("type");
                        
                typeL.add(typestr);
            }
                
        }
        
        return typeL;
    }
    
    
    
}
