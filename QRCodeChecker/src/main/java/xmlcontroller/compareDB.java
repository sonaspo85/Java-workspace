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

public class compareDB {
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
    
    String msg = "";
    
    public compareDB() {
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
                        
                    } else if(tagName.equals("Tar") & !type.equals("None")) {
                        tarTagName = tagName;
                        tarMeterialDB = ele.getAttribute("meterialCodeDB");
                        tarMeterialDoc = ele.getAttribute("meterialDoc");
                        tarModelname = ele.getAttribute("modelname");
                        tarQrImg = ele.getAttribute("qrcodImg");
                        tarQrUrl = ele.getAttribute("url");
                    }

                }

            }
            
            // 영문 modelname 과 url 비교
            if(tarTagName != "" & srcModelname != "" & srcQrUrl != "") {
            	srcModelurlC = obj.compareModelName(srcModelname, srcQrUrl);
            	System.out.println("srcModelurlC: " + srcModelurlC);
            	
            }
            
            if(tarModelname != "" & tarQrUrl != "") {
            	tarModelurlC = obj.compareModelName(tarModelname, tarQrUrl);
            	System.out.println("srcModelurlC: " + tarModelurlC);
            	
            }
            
            // 다국어 Tar 가 있는 경우 
            if(srcModelurlC.equals("True") & tarModelurlC.equals("True")) {
                if(srcModelname.equals(tarModelname)) {
                    STmodelNameC = "True";
                    
                } else {
                    STmodelNameC = "Fail";
                }
                
            } else {
                STmodelNameC = "Fail";
            }
            
            // 영문 QRcodeUrl 과 다국어 QRcodeUrl 비교
            if(STmodelNameC.equals("True")) {
                if(srcQrUrl.equals(tarQrUrl)) {
                    STurlC = "Ture";
                    
                } else {
                    STurlC = "Fail";
                }
            } else {
                STurlC = "Fail";
            }
            
            addCompareData(nl);
            Element div = doc.createElement("total");
            div.setAttribute("nameC", STmodelNameC);
            div.setAttribute("urlC", STurlC);
            
            rootEle.appendChild(div);
            
            // 파일로 추출
            setTransformer(doc);
            
        } catch(Exception e1) {
            msg = "compareDB >mergedNew 파일 읽기 실패";
            throw new RuntimeException(msg);
        }
        
    } 
    
    public void compareModelName() {
    	if(srcModelname != "" & srcQrUrl != "") {
    	    if(srcModelname.contains(", ")) {
    	        // StringTokenizer 클래스로 문자열 분리
    	        StringTokenizer st = new StringTokenizer(srcModelname, ", "); 
    	        
    	        int cnt = st.countTokens();
    	        for(int i=0; i< cnt; i++) { 
    	            String token = st.nextToken();
    	            System.out.println("token: " + token);
    	            
    	            if(srcQrUrl.contains(token)) {
    	                srcModelurlC = "True";
    	                break;
    	                
    	            } else {
    	                srcModelurlC = "Fail";
    	            }
    	                
    	        }
    	        
    	    } else {
    	        if(srcQrUrl.contains(srcModelname)) {
    	            srcModelurlC = "True";
    	            
    	        } else {
    	            srcModelurlC = "Fail";
    	        }
    	        
    	    }

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
                    
                } else if(tagName.equals("Tar")) {
                    ele.setAttribute("nameNurlC", tarModelurlC);
                    
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
            DOMSource source = new DOMSource(doc);
            
            // 출력 결과를 스트림을 생성
            Result result = new StreamResult(out2.toString());
            
            trans.transform(source, result);
            
        } catch (Exception e) {
            msg = "compareDB > Transformer 진행 실패";
            throw new RuntimeException(msg);
            
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
