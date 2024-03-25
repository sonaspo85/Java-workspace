package main.java.zipController;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import main.java.zipController.Common.implementOBJ;

public class readMergedF {
    implementOBJ obj = new implementOBJ();
    
    public void runReadMergedF() {
        try {
            String path = obj.srcDir + File.separator + "temp" +  File.separator + "idmlMergedXML.xml";
            File file = new File(path);
            FileInputStream fis = new FileInputStream(file);
            
            Reader reader = new InputStreamReader(fis, "UTF-8");
            InputSource is = new InputSource(reader);
            is.setEncoding("UTF-8");
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            dbf.setNamespaceAware(true);
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(is);

            // 문서내 최상위 root 요소에 접근
            Element rootEle = doc.getDocumentElement();
            String region = rootEle.getAttribute("region");
            obj.fileRegion = region;
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    }
    
    
}
