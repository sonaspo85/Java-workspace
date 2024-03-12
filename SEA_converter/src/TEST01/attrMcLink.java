package TEST01;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;



public class attrMcLink {
    private File mcbook;
    private List<File> passList = new ArrayList<>();
    
    public attrMcLink(File mcbook, List<File> passList) {
        this.mcbook = mcbook;
        this.passList = passList;
    }
    
    public List<File> runXpath() throws Exception {
        FileInputStream fis = new FileInputStream(mcbook); 
        InputSource is = new InputSource(fis);
        is.setEncoding("UTF-8");
        
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(is);
        
        XPath xpath = XPathFactory.newInstance().newXPath();
        String express = "MadCapBook/Chapter/@Link";
        NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
        
        List<File> sortFiles = new ArrayList<>();
        
        for(int i=0; i<nl.getLength(); i++) {
            Node node = nl.item(i);
            
            for(File each : passList) {
                String fileName = each.getName();
                
                if(node.getNodeValue().equals(fileName)) {
                    sortFiles.add(each);
                }
            }
        }

        return sortFiles;
    }
}
