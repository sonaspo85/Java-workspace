package main.DITA.imgController;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import main.DITA.Common.implementOBJ;

public class imgDBTxml {
    implementOBJ obj = new implementOBJ();
    Map<String, List<String>> imgMap = null;
    String outMapDir = "";
    Document doc = null;
    Path imgsizeP = null;
    
    public imgDBTxml(Map<String, List<String>> imgMap, String outMapDir) {
        this.imgMap = imgMap;
        this.outMapDir = outMapDir;
    }
    
    public void runimgDBTxml() {
        createIdmlTemp();
        String imgsizeF = outMapDir + File.separator + "image_size.xml";
        System.out.println("imgsizeF: " + imgsizeF);
        imgsizeP = Paths.get(imgsizeF);
        
        // 빈 Document 객체 생성
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            doc = db.newDocument();

            // root 노드 생성
            Element rootEle = doc.createElement("Document");
            doc.appendChild(rootEle);

            imgMap.forEach((k, v) -> {
                String fileName = k;
                List<String> list = v;
                
                
                Element imgTag = doc.createElement("image");
                imgTag.setAttribute("file", fileName);
                rootEle.appendChild(imgTag);
                for(int i=0; i<list.size(); i++) {
                    if(i == 0) {
                        imgTag.setAttribute("width", list.get(i));
                        
                    } else if(i == 1) {
                        imgTag.setAttribute("height", list.get(i));
                        
                    } else if(i == 2) {
                        imgTag.setAttribute("dpi", list.get(i));
                        
                    } else if(i == 3) {
                        imgTag.setAttribute("unit", list.get(i));
                        
                    }
                    
                }

            });
            
            exportXML();
            
            
        } catch (ParserConfigurationException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        
    }
    
    public void exportXML() {
        System.out.println("exportXML 시작");
        try {
            // Transformer 생성
            TransformerFactory ttf = TransformerFactory.newInstance();
            Transformer tf = ttf.newTransformer();
            tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            tf.setOutputProperty(OutputKeys.INDENT, "yes");
            tf.setOutputProperty(OutputKeys.METHOD, "xml");
            tf.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
            
            // DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(imgsizeP.toUri().toString());
    
            tf.transform(source, result);
            result.getOutputStream().close();
            
        } catch(Exception e1) {
            e1.printStackTrace();
        }
    }
    
    public void createIdmlTemp() {
        String idmlTempS = outMapDir  + File.separator + "idmlTemp";
        Path idmlTempP = Paths.get(idmlTempS); 
        try {
            obj.createNewDir(idmlTempP);
            
        } catch (Exception e1) {
            e1.printStackTrace();
        }
        
    }
    
}
