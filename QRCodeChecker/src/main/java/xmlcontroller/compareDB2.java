package main.java.xmlcontroller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URI;
import java.util.StringTokenizer;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.CommonObj.implementOBJ;

public class compareDB2 {
    implementOBJ obj = new implementOBJ();
    String mergedNewStr = "";
    
    String srcTagName = "";
    String srcMeterialDB = "";
    String srcMeterialDoc = "";
    String srcModelname = "";
    String srcQrImg = "";
    String srcQrUrl = "";
    String srcModelurlC = "";
    
    String tarTagName = "";
    String tarMeterialDB = "";
    String tarMeterialDoc = "";
    String tarModelname = "";
    String tarQrImg = "";
    String tarQrUrl = "";
    String tarModelurlC = "";
    
    String STmodelNameC = "";
    String STurlC = "";
    
    public compareDB2() {
      mergedNewStr = obj.tempDir + File.separator + "merged_new.xml";
    }
    
    public void runCompare() {
        try {
            Document doc = createDOM();
            Element rootEle = doc.getDocumentElement();
            NodeList nl = (NodeList) rootEle.getChildNodes();
            
            // 데이터 추출
            for(int i=0; i<nl.getLength(); i++) {
                Node node = nl.item(i);
                
                if(node.getNodeType() == Node.ELEMENT_NODE) {
                    Element ele = (Element) node;
                    String tagName = ele.getTagName();
                    String type = ele.getAttribute("type");
                    
                    if(tagName.equals("Src")) {
                        srcTagName = tagName;
                        srcMeterialDB = ele.getAttribute("meterialCodeDB");
                        srcMeterialDoc = ele.getAttribute("meterialDoc");
                        srcModelname = ele.getAttribute("modelname");
                        srcQrImg = ele.getAttribute("qrcodImg");
                        srcQrUrl = ele.getAttribute("url");
                        
                    } 

                }

            }
            
            if(srcModelname != "" & srcQrUrl != "") {
            	srcModelurlC = obj.compareModelName(srcModelname, srcQrUrl);
            	System.out.println("srcModelurlC: " + srcModelurlC);
            } 
            
            addCompareData(nl);
            setTransformer(doc);
            
        } catch(Exception e1) {
        }
        
    } 
    
    public void addCompareData(NodeList nl) {
        for(int i=0; i<nl.getLength(); i++) {
            Node node = nl.item(i);
            
            if(node.getNodeType() == Node.ELEMENT_NODE) {
                Element ele = (Element) node;
                String tagName = ele.getTagName();

                if(tagName.equals("Src")) {
                    ele.setAttribute("nameNurlC", srcModelurlC);
                    ele.setAttribute("type", "단권");
                    
                } 

            }

        }
        
        
    }
    
    public void setTransformer(Document doc) {
        try {
            // 출력 파일 지정
            String mergedFinalStr = obj.tempDir + File.separator + "merged_final.xml";
            File outF = new File(mergedFinalStr);
            URI out2 = outF.toURI();
            
            // TransformerFactory 객체 생성
            TransformerFactory tff = TransformerFactory.newInstance();        
            Transformer trans = tff.newTransformer();
            trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            trans.setOutputProperty(OutputKeys.INDENT, "no");
            trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
            
            // DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
            Result result = new StreamResult(out2.toString());
            
            trans.transform(source, result);
            
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    
    public Document createDOM() throws Exception {
        FileInputStream fis = new FileInputStream(mergedNewStr);
        Reader reader = new InputStreamReader(fis, "UTF-8");
        InputSource is = new InputSource(reader);
        is.setEncoding("UTF-8");
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);

        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(is);

        return doc;
    }
    
    
    
}
