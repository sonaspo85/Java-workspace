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
        System.out.println("runGetDate() 시작");
        
        System.out.println();
        tempDir = projectDir.getAbsolutePath() + File.separator + "temp";
        
        Path tempPath = Paths.get(tempDir);
        System.out.println("tempPath: " + tempPath);
        obj.tempDir = tempDir;
        
        try {
            DirectoryStream <Path> ds = Files.newDirectoryStream(tempPath);
            
            System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
            
            // 3. Xpath 객체 생성
            XPathFactory factory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
            XPath xpath = factory.newXPath();
            
            ds.forEach(c -> {
                String fullPath = c.toAbsolutePath().toString();
                String fileName = c.getFileName().toString();
                int lastUnber = fileName.lastIndexOf("_") + 1; 
                
                if(Files.isRegularFile(c)) {
                    lang = fileName.substring(lastUnber).replace(".xml", "");

                    try {
                        // 1. merged.xml 파일 읽기
                        Document doc = createDOM(fullPath);
                        // 2. merged.xml 문서내 최상위 요소 접근하기
                        Element rootEle = doc.getDocumentElement();
                        
                        // 최상위 요소 이름 및 속성 추출
//                        System.out.println("최상위 요소 이름: " + rootEle.getNodeName());
                        
                        // 4. 정규식으로 찾을 Xpath 구조 지정
                        getQrcodeUrl(xpath, doc, lang);
                        
                        // 6. 모델 이름 추출
                        getModelName(xpath, doc, lang);
                        
                        // 9. 자재코드 이름 추출
                        getMaterialName(xpath, doc, lang);
                         
                    } catch(Exception e1) {
                        msg = "DOM 객체 생성 실패";
                        throw new RuntimeException(msg);
                    }
                    
                } 
                
                else {
                    lang = fileName.substring(lastUnber).replace(".xml", "");
                    
                    // 9. Links 라는 폴더 이름이 유동적인 이름이기 때문에, 정확한 이름 출력이 필요
                    try {
                        DirectoryStream <Path> ds2 = Files.newDirectoryStream(c);
                        
                        ds2.forEach(e -> {
                            if(Files.isDirectory(e) & e.getFileName().toString().contains("Links")) {
                                linkFolderName = e.getFileName().toString();
                            }
                            
                        });

                    } catch (IOException e) {
                        System.out.println("Links 폴더 찾기 실패");
                        msg = "Links 폴더 찾기 실패";
                        throw new RuntimeException(msg);
                    }
                    
                    // 8. qr 이미지명 추출
                    getQRImgPath(c, lang);
                    
                    // 10. getmeterialPath 이미지명 추출
                    getmeterialPath(c, lang);

                }
                
            });
            
            
        } catch (Exception e) {
            System.out.println("merged 파일 읽기 실패");
            msg = "merged 파일 읽기 실패";
            throw new RuntimeException(msg);
        } 
        
    }
    
    public Document createDOM(String fullPath) throws Exception {
        System.out.println("createDOM() 시작");
        
        String mergedF = tempDir + File.separator + "merged.xml";
        // 1. FileInputStream 바이트 기반 입력 스트림으로 파일 읽기
        FileInputStream fis = new FileInputStream(fullPath);
        
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
    
    public void getQrcodeUrl(XPath xpath, Document doc, String lang) throws Exception {
        System.out.println("getQrcodeUrl() 시작");
        
        String QRcodeImgExp = "//Link[matches(@LinkResourceURI, 'E-usermanual_')]";
        NodeList nl = (NodeList) xpath.compile(QRcodeImgExp).evaluate(doc, XPathConstants.NODESET);
        System.out.println("nl의 개수: " + nl.getLength());
        
        if(nl.getLength() >= 1) {
        	System.out.println("E-usermanual 시작하는 요소가 1개 이상입니다.");
        	
        	// 5. 정규식으로 찾은 요소를 반복하여 추출 
            for(int y=0; y< nl.getLength(); y++) {
                Node node = nl.item(y);
                Element ele = (Element) node;
                
                // 6. qrCode 이미지의 경로 추출 
                qrCodeUrl = ele.getAttribute("LinkResourceURI");
                System.out.println("qrCodeUrl: " + qrCodeUrl);
                
                File imgFile = new File(qrCodeUrl);
                String imgName = imgFile.getName();
                
                if(lang.equals("Eng")) {
                    obj.qrCodeImgSrc = imgName;
                    System.out.println("aaa333: " + imgName);
                    
                } else if(lang.equals("multi")) {
                    obj.qrCodeImgTar = imgName;
                    System.out.println("bbb333: " + imgName);
                }

            }
            
        } else {
        	System.out.println("E-usermanual 시작하는 요소가 0개 입니다.");
        	
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
//        String QRcodeImgExp = "//ParagraphStyleRange[@AppliedParagraphStyle = 'ModelName-Cover']//Content";
        NodeList nl = (NodeList) xpath.compile(QRcodeImgExp).evaluate(doc, XPathConstants.NODESET);
        
        // nl의 개수가 1개 이상일 경우 distinct() 메소드로 중복 제거후 저장
        if(nl.getLength() > 1) {
        	System.out.println("모델 이름이 1개 이상임");
        	moreModelName(nl);
        	
        } else {
            System.out.println("모델 이름이 1개 임");
        	// 5. 정규식으로 찾은 요소를 반복하여 추출 
            for(int y=0; y< nl.getLength(); y++) {
                Node node = nl.item(y);
                Element ele = (Element) node;
                
                modelName = ele.getTextContent();
                System.out.println("modelNamewww: " + modelName);
                
                int lastSlash = modelName.lastIndexOf("/");
                
                if(lastSlash == -1) {
                    lastSlash = modelName.length();
                } 

                String modelName2 = modelName.substring(0, lastSlash);

                if(lang.equals("Eng")) {
                    obj.modelNameSrc = modelName2;
//                    System.out.println("aaa222: " + obj.modelNameSrc);
                    
                } else if(lang.equals("multi")) {
                    obj.modelNameTar = modelName2;
//                    System.out.println("bbb222: " + obj.modelNameSrc);
                }

            }
        	
        	
        }

    }
    
    public void moreModelName(NodeList nl) {
    	System.out.println("moreModelName() 시작");
    	
    	List<String> tempList = new ArrayList<>();
    	// 5. 정규식으로 찾은 요소를 반복하여 추출 
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
        
        // nl의 개수가 1개 이상일 경우, distinct() 메소드로 중복 제거
        List<String> finalList = tempList.stream()
        								 .distinct()
        								 .collect(Collectors.toList());
        
        String joinModelName = String.join(", ", finalList);
        
        
        if(finalList.size() == 1) {
        	if(lang.equals("Eng")) {
                obj.modelNameSrc = finalList.get(0);
//                System.out.println("aaa000: " + obj.modelNameSrc);
                
            } else if(lang.equals("multi")) {
                obj.modelNameTar = finalList.get(0);
//                System.out.println("bbb000: " + obj.modelNameSrc);
            }
        	
        } else {
        	if(lang.equals("Eng")) {
                obj.modelNameSrc = joinModelName;
//                System.out.println("aaa111: " + obj.modelNameSrc);
                
            } else if(lang.equals("multi")) {
                obj.modelNameTar = joinModelName;
//                System.out.println("bbb111: " + obj.modelNameSrc);
            }
        }
    	
    	
    	
    }
    
    
    
    public void getQRImgPath(Path c, String lang) {
        System.out.println("getQRImgPath() 시작");
        
        if(!qrCodeUrl.equals("Null")) {
        	System.out.println("qrCodeUrl 가 Null이 아닌 경우");
        	
	        File imgFile = new File(qrCodeUrl);
	        String imgName = imgFile.getName();
	        
	        String fullPath = c.toAbsolutePath().toString();
	        String fileName = c.getFileName().toString();
	        
	        try {
	            // 10. QRcode 이미지의 전체 경로 지정
	            String imgFullPath = fullPath + File.separator + linkFolderName + File.separator + imgName;
	            
	            File ifp = new File(imgFullPath);
	            
	            if(ifp.exists()) {
	                // 11. QRcode의 데이터 추출 하기
	                Map<EncodeHintType, ErrorCorrectionLevel> hashMap = new HashMap<EncodeHintType, ErrorCorrectionLevel>();
	                hashMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
	                
	                QRcode qrcode = new QRcode();
	                
	                String qrStr = qrcode.readQR(imgFullPath, hashMap);
	                System.out.println("qrCode: " + qrStr);
	                
	                if(lang.equals("Eng")) {
	                    obj.qrCodeUrlSrc = qrStr;
	                    
	                } else if(lang.equals("multi")) {
	                    obj.qrCodeUrlTar = qrStr;
	                }
	            }
	            
	        } catch(Exception e) {
	            System.out.println("QR 주소 출력 실패");
	            msg = "QR 주소 출력 실패";
	            throw new RuntimeException(msg);
	        }
	        
        } else {  // qrCodeUrl 이미지 경로가 추출을 할수 없는 경우, Null 인 경우
        	if(lang.equals("Eng")) {
                obj.qrCodeUrlSrc = "QR코드 데이터 읽기 실패";
                
            } else if(lang.equals("multi")) {
                obj.qrCodeUrlTar = "QR코드 데이터 읽기 실패";
            }
        	
        	
        }
    }
    
    public void getMaterialName(XPath xpath, Document doc, String lang) throws Exception {
        System.out.println("getMaterialName() 시작");
        
//        String meterialExp = "//ParagraphStyleRange[@AppliedParagraphStyle = 'ParagraphStyle/Description-Cover-Back-R'][descendant::Content]//Content";
        String meterialExp = "//ParagraphStyleRange[matches(@AppliedParagraphStyle, '^(ParagraphStyle/Description-Cover-Back-R|ParagraphStyle/Description-Cover-Back-R_Language)$')][descendant::Content]//Content";
        NodeList nl = (NodeList) xpath.compile(meterialExp).evaluate(doc, XPathConstants.NODESET);
        
//        System.out.println("hhh: " + nl.getLength());
        // 5. 정규식으로 찾은 요소를 반복하여 추출 
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
        System.out.println("getmeterialPath() 시작");
        String meterialName = "";
        
        if(lang.equals("Eng")) {
            meterialName = obj.meterialValSrc + ".png";
            
        } else {
            meterialName = obj.meterialValTar + ".png";
        }
        
        String fullPath = c.toAbsolutePath().toString();
        String fileName = c.getFileName().toString();
        
        try {
            // 10. meterialDataStr 이미지의 전체 경로 지정
            String meterialFullPath = fullPath + File.separator + linkFolderName + File.separator + meterialName;
            System.out.println("meterialFullPath: " + meterialFullPath);
            
            File mfp = new File(meterialFullPath);
            
            if(mfp.exists()) {
                // 11. meterialDataStr의 데이터 추출 하기
                HashMap<DecodeHintType, Object> decodeHintMap = new HashMap<DecodeHintType, Object>();
                decodeHintMap.put(DecodeHintType.PURE_BARCODE, Boolean.TRUE);
                
                QRcode qrcode = new QRcode();

                String meterialDataStr = qrcode.readDataMatrix(meterialFullPath, decodeHintMap);

                System.out.println("meterialDataStr: " + meterialDataStr);
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
            System.out.println("meterialData 추출 실패");
            msg = "meterialData 추출 실패";
            throw new RuntimeException(msg);
        }
        
    }

}
