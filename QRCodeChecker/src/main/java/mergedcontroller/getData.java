package main.java.mergedcontroller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.google.zxing.DecodeHintType;
import com.google.zxing.EncodeHintType;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import main.java.CommonObj.implementOBJ;
import main.java.qrcodecontroller.QRcode;
import net.sf.saxon.lib.NamespaceConstant;

public class getData {
    implementOBJ obj = new implementOBJ();
    String tempDir = "";
    String qrCodeUrl = "";
    String modelName = "";
    String meterialVal = "";
    File projectDir = new File(""); 
    String linkFolderName = "";
    String lang = "";
    String msg = "";
    
    public getData() {
        
    }
    
    public void runGetDate() {
        tempDir = projectDir.getAbsolutePath() + File.separator + "temp";
        
        Path tempPath = Paths.get(tempDir);
        obj.tempDir = tempDir;
        
        try {
            DirectoryStream <Path> ds = Files.newDirectoryStream(tempPath);
            
            System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
            XPathFactory factory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
            XPath xpath = factory.newXPath();
            
            ds.forEach(c -> {
                String fullPath = c.toAbsolutePath().toString();
                String fileName = c.getFileName().toString();
                int lastUnber = fileName.lastIndexOf("_") + 1; 
                
                if(Files.isRegularFile(c)) {
                    lang = fileName.substring(lastUnber).replace(".xml", "");

                    try {
                        Document doc = createDOM(fullPath);
                        Element rootEle = doc.getDocumentElement();
                        getQrcodeUrl(xpath, doc, lang);
                        getModelName(xpath, doc, lang);
                        getMaterialName(xpath, doc, lang);
                         
                    } catch(Exception e1) {
                        msg = "DOM 객체 생성 실패";
                        throw new RuntimeException(msg);
                    }
                    
                } 
                
                else {
                    lang = fileName.substring(lastUnber).replace(".xml", "");
                    
                    try {
                        DirectoryStream <Path> ds2 = Files.newDirectoryStream(c);
                        
                        ds2.forEach(e -> {
                            if(Files.isDirectory(e) & e.getFileName().toString().contains("Links")) {
                                linkFolderName = e.getFileName().toString();
                            }
                            
                        });

                    } catch (IOException e) {
                        msg = "Links 폴더 찾기 실패";
                        throw new RuntimeException(msg);
                    }
                    
                    // qr 이미지명 추출
                    getQRImgPath(c, lang);
                    
                    // getmeterialPath 이미지명 추출
                    getmeterialPath(c, lang);

                }
                
            });
            
            
        } catch (Exception e) {
            msg = "merged 파일 읽기 실패";
            throw new RuntimeException(msg);
        } 
        
    }
    
    public Document createDOM(String fullPath) throws Exception {
        String mergedF = tempDir + File.separator + "merged.xml";
        // FileInputStream 바이트 기반 입력 스트림으로 파일 읽기
        FileInputStream fis = new FileInputStream(fullPath);
        Reader reader = new InputStreamReader(fis, "UTF-8");
        InputSource is = new InputSource(reader);
        is.setEncoding("UTF-8");
        
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(is);
        
        return doc;
    }
    
    public void getQrcodeUrl(XPath xpath, Document doc, String lang) throws Exception {
        String QRcodeImgExp = "//Link[matches(@LinkResourceURI, 'E-usermanual_')]";
        NodeList nl = (NodeList) xpath.compile(QRcodeImgExp).evaluate(doc, XPathConstants.NODESET);
        
        if(nl.getLength() >= 1) {
        	// 정규식으로 찾은 요소를 반복하여 추출 
            for(int y=0; y< nl.getLength(); y++) {
                Node node = nl.item(y);
                Element ele = (Element) node;
                qrCodeUrl = ele.getAttribute("LinkResourceURI");
                
                File imgFile = new File(qrCodeUrl);
                String imgName = imgFile.getName();
                
                if(lang.equals("Eng")) {
                    obj.qrCodeImgSrc = imgName;
                    
                } else if(lang.equals("multi")) {
                    obj.qrCodeImgTar = imgName;
                }

            }
            
        } else {
        	qrCodeUrl = "Null";
        	
        	if(lang.equals("Eng")) {
                obj.qrCodeImgSrc = "E-usermanual 시작하는 이미지 없음";
                
            } else if(lang.equals("multi")) {
                obj.qrCodeImgTar = "E-usermanual 시작하는 이미지 없음";
                
            }
        }
        
    }
    
    public void getModelName(XPath xpath, Document doc, String lang) throws Exception {
        String QRcodeImgExp = "//ParagraphStyleRange[matches(@AppliedParagraphStyle, 'ModelName-Cover$')]//Content";
        NodeList nl = (NodeList) xpath.compile(QRcodeImgExp).evaluate(doc, XPathConstants.NODESET);

        if(nl.getLength() > 1) {
        	moreModelName(nl);
        	
        } else {
        	// 정규식으로 찾은 요소를 반복하여 추출 
            for(int y=0; y< nl.getLength(); y++) {
                Node node = nl.item(y);
                Element ele = (Element) node;
                modelName = ele.getTextContent();
                
                int lastSlash = modelName.lastIndexOf("/");
                
                if(lastSlash == -1) {
                    lastSlash = modelName.length();
                } 

                String modelName2 = modelName.substring(0, lastSlash);

                if(lang.equals("Eng")) {
                    obj.modelNameSrc = modelName2;
                    
                } else if(lang.equals("multi")) {
                    obj.modelNameTar = modelName2;
                }

            }
        	
        	
        }

    }
    
    public void moreModelName(NodeList nl) {
    	List<String> tempList = new ArrayList<>(); 
    	
        for(int y=0; y< nl.getLength(); y++) {
            Node node = nl.item(y);
            Element ele = (Element) node;
            String ModelNameS = ele.getTextContent();
            int lastSlash = ModelNameS.lastIndexOf("/");
        	
        	if(lastSlash == -1) {
        		lastSlash = ModelNameS.length();
        	} 

            String modelName2 = ModelNameS.substring(0, lastSlash);
        	tempList.add(modelName2);

        }
        
        // nl의 개수가 1개 이상일 경우
        List<String> finalList = tempList.stream()
        								 .distinct()
        								 .collect(Collectors.toList());
        
        String joinModelName = String.join(", ", finalList);
        
        
        if(finalList.size() == 1) {
        	if(lang.equals("Eng")) {
                obj.modelNameSrc = finalList.get(0);

            } else if(lang.equals("multi")) {
                obj.modelNameTar = finalList.get(0);

            }
        	
        } else {
        	if(lang.equals("Eng")) {
                obj.modelNameSrc = joinModelName;

                
            } else if(lang.equals("multi")) {
                obj.modelNameTar = joinModelName;
            }
        }
    	
    	
    	
    }
    
    
    
    public void getQRImgPath(Path c, String lang) {
        if(!qrCodeUrl.equals("Null")) {
	        File imgFile = new File(qrCodeUrl);
	        String imgName = imgFile.getName();
	        String fullPath = c.toAbsolutePath().toString();
	        String fileName = c.getFileName().toString();
	        
	        try {
	            // QRcode 이미지의 전체 경로 지정
	            String imgFullPath = fullPath + File.separator + linkFolderName + File.separator + imgName;
	            File ifp = new File(imgFullPath);
	            
	            if(ifp.exists()) {
	                // QRcode의 데이터 추출 하기
	                Map<EncodeHintType, ErrorCorrectionLevel> hashMap = new HashMap<EncodeHintType, ErrorCorrectionLevel>();
	                hashMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
	                QRcode qrcode = new QRcode();
	                String qrStr = qrcode.readQR(imgFullPath, hashMap);
	                
	                if(lang.equals("Eng")) {
	                    obj.qrCodeUrlSrc = qrStr;
	                    
	                } else if(lang.equals("multi")) {
	                    obj.qrCodeUrlTar = qrStr;
	                }
	            }
	            
	        } catch(Exception e) {
	            msg = "QR 주소 출력 실패";
	            throw new RuntimeException(msg);
	        }
	        
        } else {
        	if(lang.equals("Eng")) {
                obj.qrCodeUrlSrc = "QR코드 데이터 읽기 실패";
                
            } else if(lang.equals("multi")) {
                obj.qrCodeUrlTar = "QR코드 데이터 읽기 실패";
            }
        	
        	
        }
    }
    
    public void getMaterialName(XPath xpath, Document doc, String lang) throws Exception {
        String meterialExp = "//ParagraphStyleRange[matches(@AppliedParagraphStyle, '^(ParagraphStyle/Description-Cover-Back-R|ParagraphStyle/Description-Cover-Back-R_Language)$')][descendant::Content]//Content";
        NodeList nl = (NodeList) xpath.compile(meterialExp).evaluate(doc, XPathConstants.NODESET);

        // 요소를 반복하여 추출 
        for(int y=0; y< nl.getLength(); y++) {
            Node node = nl.item(y);
            Element ele = (Element) node;
            
            meterialVal = ele.getTextContent();
            
            if(meterialVal.contains("Rev")) {
                
                if(lang.equals("Eng")) {
                    obj.meterialValSrc = meterialVal;
                    
                } else if(lang.equals("multi")) {
                    obj.meterialValTar = meterialVal;
                }
            }
            

        }
        
    }
    
    public void getmeterialPath(Path c, String lang) {
        String meterialName = "";
        
        if(lang.equals("Eng")) {
            meterialName = obj.meterialValSrc + ".png";
            
        } else {
            meterialName = obj.meterialValTar + ".png";
        }
        
        String fullPath = c.toAbsolutePath().toString();
        String fileName = c.getFileName().toString();
        
        try {
            // meterialDataStr 이미지의 전체 경로 지정
            String meterialFullPath = fullPath + File.separator + linkFolderName + File.separator + meterialName;
            System.out.println("meterialFullPath: " + meterialFullPath);
            
            File mfp = new File(meterialFullPath);
            
            if(mfp.exists()) {
                HashMap<DecodeHintType, Object> decodeHintMap = new HashMap<DecodeHintType, Object>();
                decodeHintMap.put(DecodeHintType.PURE_BARCODE, Boolean.TRUE);
                QRcode qrcode = new QRcode();
                String meterialDataStr = qrcode.readDataMatrix(meterialFullPath, decodeHintMap);
                
                if(lang.equals("Eng")) {
                    obj.meterialDBSrc = meterialDataStr;
                    
                } else {
                    obj.meterialDBTar = meterialDataStr;
                }
                
            } else {
            	obj.meterialDBSrc = "자재코드 없음";
            	obj.meterialDBTar = "자재코드 없음";
            }
            
        } catch(Exception e) {
            msg = "meterialData 추출 실패";
            throw new RuntimeException(msg);
        }
        
    }

}
