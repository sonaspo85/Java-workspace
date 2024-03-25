package main.java.xmlcontroller;

import java.io.File;
import java.net.URI;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import main.java.CommonObj.implementOBJ;

public class db2xml {
    implementOBJ obj = new implementOBJ();
    String msg = "";
    
    public void runDB2xml() {
        Document doc = createdoc();
        Element root = doc.createElement("root");
        doc.appendChild(root);
        
        Element childSrc = doc.createElement("Src");
        // modelName 할당
        childSrc.setAttribute("type", "단권");
        childSrc.setAttribute("url", obj.qrCodeUrlSrc);
        childSrc.setAttribute("modelname", obj.modelNameSrc);
        childSrc.setAttribute("meterialCodeDB", obj.meterialDBSrc);
        childSrc.setAttribute("meterialDoc", obj.meterialValSrc);
        childSrc.setAttribute("qrcodImg", obj.qrCodeImgSrc);
        
        root.appendChild(childSrc);
        
        if(obj.tarDir != null) {
            Element childTar = doc.createElement("Tar");
            // QRcode 할당
            childTar.setAttribute("type", "합본");
            childTar.setAttribute("url", obj.qrCodeUrlTar);
            childTar.setAttribute("modelname", obj.modelNameTar);
            childTar.setAttribute("meterialCodeDB", obj.meterialDBTar);
            childTar.setAttribute("meterialDoc", obj.meterialValTar);
            childTar.setAttribute("qrcodImg", obj.qrCodeImgTar);
            root.appendChild(childTar);
        }

        
        // Transformer 객체 생성
        setTransformer(doc);
        
    }
    
    public Document createdoc() {
        System.out.println("createdoc() 시작");
        
        DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
        Document doc = null; 
        try {
            DocumentBuilder documentBuilder = docFactory.newDocumentBuilder();
            doc = documentBuilder.newDocument();
            doc.setXmlStandalone(true);

        } catch (ParserConfigurationException e) {
            msg = "documentBuilder 파싱 실패!";
            throw new RuntimeException(msg);
        }
        
        return doc;
    }
    
    public void setTransformer(Document doc) {
        try {
            // 출력 파일 지정
            String mergedNew = obj.tempDir + File.separator + "merged_new.xml";
            File outF = new File(mergedNew);
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
            msg = "Transformer 진행 실패";
            throw new RuntimeException(msg);
        }

    }
}
