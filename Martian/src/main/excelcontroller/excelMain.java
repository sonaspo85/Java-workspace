package main.excelcontroller;

import java.io.File;
import java.io.FileInputStream;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

//import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.text.StringEscapeUtils;
import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import main.Common.implementOBJ;



public class excelMain {
    implementOBJ obj = new implementOBJ();
    String msg = "";
    Path excelTemplsDirP = null;
    
    static DecimalFormat df = new DecimalFormat("###.###");
    static DataFormatter dfm = new DataFormatter(); 
    
    
    public void runExcelMain() {
        System.out.println("runExcelMain() 시작");
        
        // 1. Excel 템플릿 경로 얻기
        excelTemplsDirP = Paths.get(obj.resourceDir + File.separator + "excel-template");
        System.out.println("excelTemplsDirP: " + excelTemplsDirP);
        
        // 2. Excel 템플릿 경로내 Excel 파일 접근하기
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(excelTemplsDirP);
            
            ds.forEach(a -> {
                if(a.getFileName().toString().endsWith(".xlsx")) {
                    try {
                        String abpath = a.toAbsolutePath().toString();
                        String filename = a.getFileName().toString();
                        
                        // 1. 엑셀 파일 읽기
                        FileInputStream fis = new FileInputStream(abpath);
                        
                        // Zip bomb~ 에러 방지
                        // Workbook 객체를 생성하기전에 추가 해야 한다.
                        ZipSecureFile.setMinInflateRatio(0);
                        Workbook wb = WorkbookFactory.create(fis);
                        
                        // 2. sheet 의 총 개수 파악
                        int sheetCnt = wb.getNumberOfSheets();
                        System.out.println("sheetCnt: " + sheetCnt);
                        
                        // 3. 시트 반복
                        for(int i=0; i<sheetCnt; i++) {
                            // 4. 새로운 XML DOM 객체 생성
                            Document doc = createDOM();
                            
                            // 5. root 요소 생성
                            Element rootEle = doc.createElement("root");
                            rootEle.setAttribute("filename", filename);
                            doc.appendChild(rootEle);
                            
                            // 6. 시트 이름 추출
                            String getSheetName = wb.getSheetName(i).replace(" ", "_").toLowerCase();
                            
                            // 7. 시트에 접근
                            Sheet sheet = wb.getSheetAt(i);
                            
                            // 8. 시트의 각 행을 Iterator 반복자를 사용하여 각 Row를 하나씩 반복
                            Iterator<Row> rowIt = sheet.iterator();
                            
                            int startRowNum = 2;
                            int startColNum = 1;
                            
                            List<String> headCellList = new ArrayList<>();
                            int totalCellCnt = 0;
                            // 9. 각 row 를 반복
                            while(rowIt.hasNext()) {
                                // 10. 각 row를 하나씩 추출
                                Row row = rowIt.next();
                                
                                // 11. header row를 찾아 각셀 반복
                                if(row.getRowNum() == 2) {
                                    // 12. getPhysicalNumberOfCells() : 실제 셀에 값이 채워져 있는 셀의 총 개수를 반환 
                                    totalCellCnt = row.getPhysicalNumberOfCells();
                                    
                                    // 13. head row의 각 셀을 반복하여 firstCellList 컬렉션으로 수집
                                    // c가 1부터 시작하는 이유는 두번째 col 부터 데이터가 채워져 있기 때문에
                                    for(int c=1; c<=totalCellCnt; c++) {
                                        // 14. 각 셀의 값 추출
                                        Cell headCell = row.getCell(c);
                                        
                                        String str1 = formatCell(headCell);
                                        // 특수문자인 경우 삭제
//                                        String str2 = str1.replaceAll("[\\(\\)&/]", "").replaceAll("_$", "");
                                        String str2 = str1.replaceAll("[\\(\\)]", "_").replaceAll("[&/]", "").replaceAll("_$", "");
                                        String str3 = StringEscapeUtils.escapeXml11(str2);
//                                        System.out.println("str3: " + str3);

                                        headCellList.add(str3);
                                        
                                    }
                                     
                                } else {  // row 가 head 행이 아닌 경우
                                    // isEmpty() 메소드를 호출하여 row 전체 셀이 비어 있지 않는 경우
                                    if (!isEmpty(row, totalCellCnt) && row.getRowNum() > startRowNum) {
                                        // row 한번씩 돌때마다 listitem 태그 생성 
                                        Element listitem = doc.createElement("listitem");
                                        rootEle.appendChild(listitem);
                                        
                                        for(int j=1; j<=totalCellCnt; j++) {
                                           Cell cellVal = row.getCell(j);

                                           String cellTxt0 = formatCell(cellVal);

//                                           String cellTxt = StringEscapeUtils.escapeXml11(cellTxt0).replaceAll("[\n\r]", "&lt;br/&gt;");
                                           String cellTxt = StringEscapeUtils.unescapeXml(cellTxt0).replaceAll("[\n\r]", "&lt;br/&gt;");
                                           
                                           String rowNum0 = String.valueOf(row.getRowNum()+1);
                                           String colNum0 = String.valueOf(j+1);
                                           
                                           // 한번씩 돌때마다 header의 각 셀값들로 요소들 생성
                                           Element listitemSub = doc.createElement(headCellList.get(j-1));
                                           listitemSub.setAttribute("class", rowNum0 + ":" + colNum0);
                                           // cell값 채우기
                                           listitemSub.appendChild(doc.createTextNode(cellTxt)); 
                                           listitem.appendChild(listitemSub);
                                           
                                        }
                                        
                                    }

                                }
                                
                            } // row 반복 닫기 
                            
                            exportXML(doc, getSheetName);
                            System.out.println("exportXML 완료!!!");
                                
                        }
                        
                    } catch (Exception e) {
                        msg = "Excel load 실패1";
                        System.out.println("msg: " + msg);
//                        throw new RuntimeException(msg);
                        e.printStackTrace();
                    }
                }
                
            });
            
        } catch(Exception e) {
            msg = "Excel load 실패2";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        }
    }
    
    public void exportXML(Document doc, String getSheetName) {
        System.out.println("exportXML() 시작");
        
        try {
            // excel을 xml로 추출
            String excelPathS = obj.tempDir + File.separator + "excelTempls/" + getSheetName + ".xml";
            Path excelDirs = Paths.get(obj.tempDir + File.separator + "excelTempls");
            
            // excelTempls 폴더 생성 
            if(!Files.exists(excelDirs)) {
                Files.createDirectories(excelDirs);
                
            }
            
            Path excelPathP = Paths.get(excelPathS);
            
            
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
            StreamResult result = new StreamResult(excelPathP.toUri().toString());
            
            tf.transform(source, result);
            result.getOutputStream().close();
            
        } catch(Exception e) {
            msg = "Excel load 실패1";
            System.out.println("msg: " + msg);
//            throw new RuntimeException(msg);
            e.printStackTrace();
        }

    }
        
    
    
    
    public boolean isEmpty(Row row, int totalCellCnt) {
//        System.out.println("isEmpty() 시작");
        
        // 셀 개수 파악
        String str = "";
        
        for(int c=1; c<=totalCellCnt; c++) {
            // 행의 각 셀의 값 추출
            Cell cellVal = row.getCell(c);
            str += cellVal;
            
        }
        
        Optional<String> op = Optional.ofNullable(str);
        
        boolean finalBool = false;
        if(op.isPresent()) {
            // 문자열 길이 추출
            int strLen = op.get().length();
            
            if(strLen == 0) {
                finalBool = true;
                
            } else {
                finalBool = false;
            }
            
        }
        
        return finalBool;
    }
    
    public String formatCell(Cell cell) {
//        System.out.println("formatCell() 시작");
        
        Optional<Cell> op = Optional.ofNullable(cell);
        
        if (!op.isPresent()) {
            // op 객체가 null을 반환 하는 경우 제로 텍스트 입력
            return "";
            
        } else {
            Cell cellVal = op.get();
            
            // Cell 타입 확인
            switch (cellVal.getCellType()) {
                case BLANK:
                    return "";
                    
                case BOOLEAN:
                    return Boolean.toString(cellVal.getBooleanCellValue());
                
                case ERROR:
                    return "*error*";

                case NUMERIC:
                    return df.format(cellVal.getNumericCellValue());

                case STRING: // 날짜 타입인 경우 문자열 형태로 출력
                    // return cell.getStringCellValue();
                    return dfm.formatCellValue(cellVal);
                    
                default:
                    return "<unknown value>";
            
            }
            
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
