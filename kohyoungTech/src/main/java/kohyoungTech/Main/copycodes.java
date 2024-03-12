package main.java.kohyoungTech.Main;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;

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
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class copycodes {
    implementOBJ obj = new implementOBJ();
    String codesF = "";
    List<String> selectedCheckBox = new ArrayList<>(); 
    String selectedLang = "";
    String msg = "";
    
    public copycodes(String codesF, List<String> selectedCheckBox) {
        this.codesF = codesF;
        this.selectedCheckBox = selectedCheckBox;
        
    }
    
    public void runCopyCodes() throws Exception {
        System.out.println("runCopyCodes() 시작");
        
        try {
            // 파일 읽기
            FileInputStream fis = new FileInputStream(codesF.toString());
            
            Reader reader = new InputStreamReader(fis, "UTF-8");
            InputSource is = new InputSource(reader);
            is.setEncoding("UTF-8");
            
            // 2. DocumentBuilderFactory 객체를 생성하고, XML DOM 트리 구조로 파일 읽기
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(is);

            // 3. root 태그에 접근
            Element rootTag = doc.getDocumentElement();         
            
            
            for(int k=0; k<selectedCheckBox.size(); k++) {
                String vals = selectedCheckBox.get(k); 
                selectedLang += vals;
                
                if(k != selectedCheckBox.size()-1) {
                    selectedLang += ", ";
                }
            }

            Node codesNode = doc.getFirstChild();
            if(codesNode.getNodeType() == Node.ELEMENT_NODE) {
                Element cElement = (Element) codesNode;             
                cElement.setAttribute("TotalLang", selectedLang);
            }
            
            setTransformer(doc);
            
        } catch (Exception e) {
            msg = "codes.xml 파일 복사 실패"; 
            throw new RuntimeException(msg);
        }
        
    }
    
    public void setTransformer(Document doc) {
        System.out.println("setTransformer() 시작");
        try {
//            codesF.delete();
            
            // 출력 파일 지정
            String newCodeF = obj.projectDir + File.separator + "temp/codes.xml";
            obj.codesF = newCodeF; 
            
            File outF = new File(newCodeF);
            URI out2 = outF.toURI();
            
            // 3. TransformerFactory 객체 생성
            TransformerFactory tff = TransformerFactory.newInstance();
            
            // 4. Transformer 객체 생성        
            Transformer trans = tff.newTransformer();
            
            // 5. 출력 포멧 설정
            trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            trans.setOutputProperty(OutputKeys.INDENT, "no");
            trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
            
            // 6. DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
            
            // 7. 출력 결과를 스트림을 생성
            Result result = new StreamResult(out2.toString());
            
            trans.transform(source, result);
            System.out.println("끝");
            
        } catch (Exception e) {
            System.out.println("codes.xml Transformer 실패");
            msg = "codes.xml Transformer 실패";
            throw new RuntimeException(msg);
        }

    }
}
