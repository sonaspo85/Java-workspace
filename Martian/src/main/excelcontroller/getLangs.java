package main.excelcontroller;

import java.io.File;
import java.io.FileInputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Iterator;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import main.Common.implementOBJ;



public class getLangs {
    implementOBJ obj = new implementOBJ();
    String msg = "";
    

    public void runLangs() {
        System.out.println("runLangs() 시작");
        
        try {
            // 
            String langExcelF = obj.excelTemplsPathP + "/language.xlsx";
            
            // 1. 엑셀 파일 읽기
            FileInputStream fis = new FileInputStream(langExcelF);
            
            // Zip bomb 에러 방지
            ZipSecureFile.setMinInflateRatio(0);
            
            // 2. 엑셀 파일 접근
            Workbook wb = WorkbookFactory.create(fis);
            
            // 3. 시트 접근
            // 시트 총 개수 파악
            int sheetCnt = wb.getNumberOfSheets();
            
            for(int y=0; y<sheetCnt; y++) {
                Document doc = createDOM();
                
                Element rootEle = doc.createElement("root");
                doc.appendChild(rootEle);
                
                // 시트 이름 추출
                String getSheetName = wb.getSheetName(y);
                getSheetName = getSheetName.replace(" ", "_").toLowerCase();
                
                // 시트에 접근
                Sheet sheet = wb.getSheetAt(y);
                
                int totalCellCnt = 0;
                
                Iterator<Row> rowIt = sheet.iterator();
                
                while(rowIt.hasNext()) {
                    Row row = rowIt.next();
                    Element listitem = doc.createElement("listitem");
                    
                    if(row.getRowNum() == 1) {
                        totalCellCnt = row.getPhysicalNumberOfCells();
                        
                    } else if(row.getRowNum() > 1) {
                        for(int j=1; j<=totalCellCnt; j++) {
                            Cell cellVal = row.getCell(j);
                            String str1 = cellVal.toString().replace(" ", "_");
                            
                            if (getSheetName.equals("language")) {
                                if (j == 1) {
                                    listitem.setAttribute("language", str1);
//                                    System.out.println("language: " + str1);
                                    
                                } else if (j == 2) {
                                    listitem.setAttribute("ISOCode", str1);
//                                    System.out.println("ISOCode: " + str1);
                                    
                                }  
                            } else if(getSheetName.equals("type")) {
                                if (j == 1) {
                                    listitem.setAttribute("type", str1);
//                                    System.out.println("language: " + str1);
                                    
                                }
                                
                            }

                        }
                        
                        rootEle.appendChild(listitem);
                    }

                }  // row 반복 닫기
                
                exportXML(doc, getSheetName);
            }
            
        } catch(Exception e) {
            msg = "language Excel load 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
//            e.printStackTrace();
            
        }
        
    }
    
    public void exportXML(Document doc, String getSheetName) {
        System.out.println("exportXML() 시작");
        
        try {
            // excel을 xml로 추출
            String langPathS = obj.resourceDir + File.separator + getSheetName + ".xml";
            Path langPathP = Paths.get(langPathS);
            
            // 1. Transformer 객체 생성
            TransformerFactory ttf = TransformerFactory.newInstance(); 
            Transformer tf = ttf.newTransformer();
            
            // 2. 출력 속성 설정
            tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            tf.setOutputProperty(OutputKeys.INDENT, "yes");
            tf.setOutputProperty(OutputKeys.METHOD, "xml");
            tf.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
            
            // 3. DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
            
            // 출력 결과를 스트림으로 생성
            StreamResult result = new StreamResult(langPathP.toUri().toString());
            
            tf.transform(source, result);
            result.getOutputStream().close();
            
        } catch(Exception e) {
            msg = "Excel load 실패1";
            System.out.println("msg: " + msg);
//            throw new RuntimeException(msg);
            e.printStackTrace();
            
        }
        
    }
    
    
    
    public Document createDOM() throws Exception {
        System.out.println("createDOM() 시작");
        
        Document doc = null;
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            dbf.setNamespaceAware(true);
            DocumentBuilder db = dbf.newDocumentBuilder();

            doc = db.newDocument();
            doc.setXmlStandalone(true);
            
        } catch(Exception e) {
            msg = "new DOM Tree 생성 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
            
        }
        
        return doc;
        
    }
    
}
