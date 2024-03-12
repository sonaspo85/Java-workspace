package main.DITA.excelController;

import java.io.File;
import java.io.FileInputStream;
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

import org.apache.commons.text.StringEscapeUtils;
import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class tempHtml {
    File selectedExcelF = null;
    static DataFormatter dfm = new DataFormatter();
    static DecimalFormat df = new DecimalFormat("#");
    Path parDir = null;
    
    public tempHtml(File selectedExcelF) {
        this.selectedExcelF = selectedExcelF;
        
        parDir = Paths.get(selectedExcelF.getParent());
        
    }
    
    public String runtemphtml() {
        System.out.println("runtemphtml() 시작");
        
        Path tempP = null;
        
        try {
            // 엑셀 이름 추출
            String excelName = selectedExcelF.getName();
            System.out.println("excelPath: " + excelName);
            
            // 엑셀파일 읽기
            FileInputStream fis = new FileInputStream(selectedExcelF.toString());
            
            // Zip bomb~ 에러 방지
            // Workbook 객체를 생성하기 전에 추가 해야 한다.
            ZipSecureFile.setMinInflateRatio(0);
            Workbook wb = WorkbookFactory.create(fis);
            
            // sheet의 총 개수파악
            int sheetCnt = wb.getNumberOfSheets();
            
            // 시트를 반복
            for(int i=0; i<sheetCnt; i++) {
                // 새로운 XML DIM 객체 생성
                Document doc = createDOM();
                
                // 시트이름 추출
                String getSheetName = wb.getSheetName(i);
                
                // root 요소 생성
                Element rootEle = doc.createElement("root");
                rootEle.setAttribute("filename", excelName);
                rootEle.setAttribute("sheetname", getSheetName);
                doc.appendChild(rootEle);

                if (i == 0 | i == 1) {
                    // Header 셀값을 추출하여 담기 위해 list 컬렉션 생성
                    List<String> firstCellList = new ArrayList<>();
                    
                    Sheet sheet = wb.getSheet(getSheetName);
                    
                    // 시트에 접근하여 시트의 각 행을 Iterator 반복자를 사용하여 각 Row를 하나씩 반복
                    Iterator<Row> rowIt = sheet.iterator();
                    
                    // 첫번째 row의 셀 개수 할당
                    int totalCellCnt = 0;
                    
                    // 각 row를 반복
                    while(rowIt.hasNext()) {
                        // 각 row를 하나씩 추출
                        Row row = rowIt.next();
                        
                        // 엑셀에서 header 행의 위치가 첫번째 행인 경우 
                        if(row.getRowNum() == 0) {
                            // getPhysicalNumberOfCells(): 실제 셀에 값이 있는 경우의 셀 개수 반환
                            totalCellCnt = row.getPhysicalNumberOfCells();
                            System.out.println("totalCellCnt: " + totalCellCnt);
                            
                            // 0번째 행의 셀을 한번씩 돌아 셀의 값을 firstCellList 컬렉션으로 수집
                            // 수집하여 나중에 태그 이름으로 사용하기 위해..
                            for(int c=0; c<totalCellCnt; c++) {
                                // 첫번째 행의 각 셀의 값 추출
                                Cell firstCell = row.getCell(c);
                                
                                String str1 = formatCell(firstCell);
                                String str2 = str1.replace(" ", "_").replace(".", "");
                                String str3 = StringEscapeUtils.escapeXml11(str2);
                                
//                                System.out.println("str3: " + str3);
                                firstCellList.add(str3);
                            }

                        } else {  // 첫번째 행이 아닌 경우
                            // isEmpty() 메소드를 호출하여, row의 전체 셀이 비어 있지 않는 경우 확인
                            if (!isEmpty(row) && row.getRowNum() > 0) {
                                // row 한번씩 돌때마다 cellval listitem 태그 생성
                                Element listitem = doc.createElement("listitem");
                                rootEle.appendChild(listitem);
                                
                                for (int j = 0; j < totalCellCnt; j++) {
                                    Cell curCell = row.getCell(j);
                                    
                                    // 추출한 셀값을 포맷팅
                                    String cellTxt0 = formatCell(curCell);
                                    String cellTxt = StringEscapeUtils.escapeXml11(cellTxt0).replaceAll("[\n\r]", "&lt;br/&gt;");
                                    
                                    String rowNum = String.valueOf(row.getRowNum() + 1);
                                    String colNum = String.valueOf(j+1);
                                    
                                    // 셀을 한번씩 돌때마다 header값으로 태그를 만들고 값을 셀값으로 넣기
                                    Element listitemSub = doc.createElement(firstCellList.get(j).toString());
                                    listitemSub.setAttribute("class", rowNum + ":" + colNum);
                                    listitemSub.appendChild(doc.createTextNode(cellTxt));
                                    listitem.appendChild(listitemSub);

                                }
                                
                                
                            }
                            
                            
                        }
                        
                        
                        
                    }  // row 반복 닫기
                    
                    tempP = Paths.get(parDir + File.separator + "/temp-html");
                    if(Files.notExists(tempP)) {
                        Files.createDirectories(tempP);
                    }
                    
                    // excel 을 xml로 변환 추출        
                    Path tarXML = Paths.get(tempP + File.separator + getSheetName + ".xml");
                    exportXML(doc, tarXML);
                    
                }  // 1번째 시트, 2버째 시트 반복 닫기
                                
            }

        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } 
        
        return tempP.toString();
    }
    
    public void exportXML(Document doc, Path tarXML) {
        System.out.println("exportXML 시작");
        try {
            // Transformer 생성
            TransformerFactory ttf = TransformerFactory.newInstance();
            Transformer tf = ttf.newTransformer();
    
            // 출력 속성 설정
            tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            tf.setOutputProperty(OutputKeys.INDENT, "no");
            tf.setOutputProperty(OutputKeys.METHOD, "xml");
            tf.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
            
            // DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
    
            // 출력결과를 스트림으로 생성
            StreamResult result = new StreamResult(tarXML.toUri().toString());
    
            tf.transform(source, result);
            result.getOutputStream().close();
            
        } catch(Exception e1) {
            e1.printStackTrace();
        }
        
    }
    
    public boolean isEmpty(Row row) {
        // 셀 개수 파악
        int cellCnt = row.getPhysicalNumberOfCells();

        String str = "";

        for (int c = 1; c <= cellCnt; c++) {
            // 행의 각 셀의 값 추출
            Cell cellVal = row.getCell(c);

            str += cellVal;
        }

        Optional<String> op = Optional.ofNullable(str);
        boolean finalBool = false;

        if (op.isPresent()) {
            int len = op.get().length();

            if (len == 0) {
                finalBool = true;
            } else {
                finalBool = false;
            }
        }

        return finalBool;
    }
    
    public Document createDOM() throws Exception {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();

        Document doc = db.newDocument();
        doc.setXmlStandalone(true);

        return doc;
    }
    
    public static String formatCell(Cell cell) {
        Optional<Cell> op = Optional.ofNullable(cell);
        
        if(!op.isPresent()) {
            // null인 경우, 임의의 텍스트 입력
            return "";
        } else {
            Cell cell1 = op.get(); 
            switch(op.get().getCellType()) {
                case BLANK:
                    return "";
                    
                case BOOLEAN:
                    return Boolean.toString(cell1.getBooleanCellValue());
                    
                case ERROR:
                    return "*error*";
                  
                case NUMERIC:
//                  // 셀의 값이 날짜 타입일 경우
                    if(DateUtil.isCellDateFormatted(cell1)) {
                        return String.valueOf(cell1.getLocalDateTimeCellValue()).split("T")[0];
                        
                    } else {
                        return df.format(cell1.getNumericCellValue());
                    }
                    
                case STRING:
//                    return cell.getStringCellValue();
                    return dfm.formatCellValue(cell1);
                    
                
                    
                default:
                    return "<unknown value>";
            }
        }
    }

    
}
