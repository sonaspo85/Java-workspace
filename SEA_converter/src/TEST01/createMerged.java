package TEST01;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class createMerged {
    private List<File> passList = new ArrayList<>();
    
    public createMerged(List<File> passList) {
        this.passList = passList;
    }
    
    public File runMerged() throws Exception {
        String sourcePath = passList.get(0).getParent();
        File defaultDir = new File("");
        String mergedDir = defaultDir.getAbsolutePath() + "\\temp\\merged.xml";
        File strMergedPath = new File(mergedDir);
        URI u = strMergedPath.toURI();
        
        try {
            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder documentBuilder = docFactory.newDocumentBuilder();
            Document doc = documentBuilder.newDocument();
            doc.setXmlStandalone(true);
            
            Element root = doc.createElement("root");
            root.setAttribute("sourcePath", "file:////" + sourcePath);
            doc.appendChild(root);
            
            for(File file : passList) {
                try {
                    FileInputStream fis = new FileInputStream(file);
                    Reader reader = new InputStreamReader(fis, StandardCharsets.UTF_8);
                    InputSource is = new InputSource(reader);
                    is.setEncoding("UTF_8"); 
                    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
                    dbf.setNamespaceAware(true);
                    DocumentBuilder db = dbf.newDocumentBuilder();
                    
                    try {
                        Document doc1 = db.parse(is);
                        Element root1 = doc1.getDocumentElement();
                        root1.setAttribute("fileName", file.getName());
                        root.appendChild(doc.adoptNode(root1.cloneNode(true)));
                        
                    } catch (Exception e3) {
                        String msg = e3.getMessage();
                        String result = "createMerged.java: {0} ���� �߻�";
                        String result1 = MessageFormat.format(result, msg);
                        throw new Exception(result1);
                    }
                } catch (Exception e4) {
                    String msg = e4.getMessage();
                    String result = "createMerged.java: {0} ���� �߻�";
                    String result1 = MessageFormat.format(result, msg);
                    throw new Exception(result1);
                } 
            }
            
            TransformerFactory tf = TransformerFactory.newInstance();
            try {
                Transformer transf = tf.newTransformer();
                transf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
                transf.setOutputProperty(OutputKeys.INDENT, "yes");
                transf.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
                DOMSource source = new DOMSource(doc);
                StreamResult result = new StreamResult(u.toString());
                
                try {
                    transf.transform(source, result);
                } catch (Exception e1) {
                    String msg = e1.getMessage();
                    String result0 = "createMerged.java: {0} ���� �߻�";
                    String result00 = MessageFormat.format(result0, msg);
                    throw new Exception(result00);
                }
                
            } catch (Exception e2) {
                String msg = e2.getMessage();
                String result2 = "createMerged.java: {0} ���� �߻�";
                String result3 = MessageFormat.format(result2, msg);
                throw new Exception(result3);
            }
            
            
            
        } catch (Exception e3) {
            String msg = e3.getMessage();
            String result3 = "createMerged.java: {0} ���� �߻�";
            String result4 = MessageFormat.format(result3, msg);
            throw new Exception(result4);
        }
        
        
        return new File(mergedDir); 
    }
}
