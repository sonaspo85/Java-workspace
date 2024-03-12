package main.othercontroller;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import main.Common.implementOBJ;



public class readlangxml {
    implementOBJ obj = new implementOBJ();
    String msg = "";
//    List<String> langL = new ArrayList<>();
    public Map<String, String> langMap = new HashMap<>();
    
    
    public void runReadF() throws Exception {
        System.out.println("runReadF() 시작");
        
        String langF = obj.resourceDir + File.separator + "language.xml";
        
        
        // 1. InputSource로 읽기
        Document doc = obj.readFile(langF);
        
        // 2. 문서의 루트 요소에 접근
        Element root = doc.getDocumentElement();
        
        NodeList nl = root.getChildNodes(); 
        
        for(int i=0; i<nl.getLength(); i++) {
            Node node1 = nl.item(i);
            
            if (node1.getNodeType() == Node.ELEMENT_NODE) {
                Element child = (Element) node1;
                
                String ISOCode = child.getAttribute("ISOCode").replaceAll("\\(", "_").replaceAll("\\)", "");
                String lang = child.getAttribute("language");
                        
//                langL.add(lang);
                
                langMap.put(lang, ISOCode);
                
            }
                
        }
        
//        return langL;
    }
    
    
    
}
