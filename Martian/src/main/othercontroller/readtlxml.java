package main.othercontroller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import main.Common.implementOBJ;



public class readtlxml {
    implementOBJ obj = new implementOBJ();
    String msg = "";
    Map<String, List<String>> typelangMap = new HashMap<>();
    
    
    public Map<String, List<String>> runtlReadF() throws Exception {
        String langF = obj.resourceDir + File.separator + "type-lang.xml";
        
        Document doc = obj.readFile(langF);
        Element root = doc.getDocumentElement();
        NodeList nl = root.getChildNodes(); 
        
        for(int i=0; i<nl.getLength(); i++) {
            Node node1 = nl.item(i);
            
            if (node1.getNodeType() == Node.ELEMENT_NODE) {
                Element child = (Element) node1;
                String typestr = child.getAttribute("type");
                NodeList nl2 = child.getChildNodes();
                List<String> list = new ArrayList<>();
                
                
                for(int r=0; r<nl2.getLength(); r++) {
                    Node node2 = nl2.item(r);
                    
                    if (node2.getNodeType() == Node.ELEMENT_NODE) {
                        Element child2 = (Element) node2;
                        String langStr = child2.getAttribute("lang");
                        list.add(langStr);

                        typelangMap.put(typestr, list);

                    }

                }
                
            }
                
        }

        return typelangMap;
    }
    
    
    
}
