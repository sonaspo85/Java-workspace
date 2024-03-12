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
      System.out.println("mergedNewStr: " + mergedNewStr);
    }
    
    public void runCompare() {
        System.out.println("compareDB2 > runCompare() 시작");
        
        try {
            // 1. merged_new.xml 읽기
            Document doc = createDOM();
            
            // 2. merged.xml 문서내 최상위 요소 접근하기
            Element rootEle = doc.getDocumentElement();

            // 3. 최상위 요소 이름 및 속성 추출
            System.out.println("최상위 요소 이름: " + rootEle.getNodeName());
            
            NodeList nl = (NodeList) rootEle.getChildNodes();
            
            // 4. 데이터 추출하기
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
            
            // 5. 영문 modelname 과 url 비교
            if(srcModelname != "" & srcQrUrl != "") {
            	srcModelurlC = obj.compareModelName(srcModelname, srcQrUrl);
            	System.out.println("srcModelurlC: " + srcModelurlC);
            } 
            
            // 9. 비교 결과값 속성으로 넣기
            addCompareData(nl);
            
//            rootEle.appendChild(div);
            
            // 10. 파일로 추출
            setTransformer(doc);
            
        } catch(Exception e1) {
            System.out.println("mergedNew 파일 읽기 실패");

        }
        
    } 
    
    public void addCompareData(NodeList nl) {
        System.out.println("addCompareData() 시작");
        
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
        System.out.println("setTransformer() 시작");
        try {
            // 출력 파일 지정
          String mergedFinalStr = obj.tempDir + File.separator + "merged_final.xml";
//            String mergedFinalStr = "H:/JAVA/java-workspace/QRCodeChecker/temp" + File.separator + "merged_final.xml";
            
            File outF = new File(mergedFinalStr);
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
            System.out.println("Transformer 진행 실패");
            e.printStackTrace();
        }

    }
    
    public Document createDOM() throws Exception {
        
        // 1. FileInputStream 바이트 기반 입력 스트림으로 파일 읽기
        FileInputStream fis = new FileInputStream(mergedNewStr);

        // 2. 문자 기반 입력스트림으로 변환 하여 "UTF-8" 인코딩 방식으로 읽기
        Reader reader = new InputStreamReader(fis, "UTF-8");

        // 3. xml 문서를 UTF-8 기반으로 DOM 트리구조로 읽기 위해 InputSource 객체 사용
        InputSource is = new InputSource(reader);
        is.setEncoding("UTF-8");

        // 4. DocumnetBuilderFactory 객체로 xml 문서를 DOM 트리 구조로 읽기
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

        // 4-1 xml문서를 파싱할때 namespace 지원 여부 설정하기
        // xslt를 사용하기 위해서는 필수 옵션이다.
        dbf.setNamespaceAware(true);

        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(is);

        return doc;
    }
    
    
    
}
