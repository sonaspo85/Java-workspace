package SONTEST.TEST03.fileControl;

import java.io.File;
import java.io.FileInputStream;
import java.net.URI;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.text.StringEscapeUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import SONTEST.TEST03.subWorkClass.commonObj;

        
public class createExcelFile {
    static DecimalFormat df = new DecimalFormat("#");
    
    // 구현 객체 생성
    commonObj coj = new commonObj();

    public void createExcelFile(File absolutePath) throws Exception {
        List<String> list = new ArrayList<>();

        // 확장자 추출
        String extention = coj.getExt(absolutePath);
        String fileName = absolutePath.getName();
        
        if(fileName.contains("ui_text")) {
            fileName = "ui_text" + extention;
            
        } else if(fileName.contains("ID,Float")) {
            fileName = "links_id_float" + extention;

        } 
        
        // 엑셀의 확장자를 xml 로 변경
        String ExcelFileName = coj.exePath + "\\resource\\" + fileName.replace(extention, ".xml");
        // D:\GitProject\JAVA\java-workspace\mobisHTML\resource\links_id_float.xml
        
        
        //------------------------------------
        // 1. 파일 입력 스트림 생성
        FileInputStream fis = new FileInputStream(absolutePath); 
        
        // 엑셀 로드, Workbook 객체 생성
        Workbook wb = WorkbookFactory.create(fis);

        //------------------
        // 빈 DOM 트리 객체 생성 하기
        Document doc = coj.createDomObj(null);
        
        Element rootEle = doc.createElement("root");
        rootEle.setAttribute("fileName", absolutePath.getName());
        doc.appendChild(rootEle);
        
        // 첫번째 시트 로드
        Sheet sheet = wb.getSheetAt(0);
        
        boolean firstRow = true;
        int rowCellCnt = 0;
        
        int rowIndex = 0;        

        // 시트의 마지막 Row
        int lastRowNum = sheet.getLastRowNum()+1;
        
        // 행을 하나씩 출력
        for(int k= 0; k<lastRowNum; k++) {
            Row row = sheet.getRow(k);
            
            // 첫번째 행인 경우
            if(row.getRowNum() == 0) {
                // 첫번째 행의 셀수 파악
                rowCellCnt = row.getPhysicalNumberOfCells();
                
                for(int i=0; i<rowCellCnt; i++) {
                    // 첫번째 행의 각 셀값 추출
                    Cell firstCell = row.getCell(i);
                    
                    String replace01 = formatCell(firstCell).replace(" ", "_");
                    String replace02 = replace01.replaceAll("contents_string\\(.*\\)", "contents_string");
                    String replace03 = textReplaceing(replace02);
                    String replace04 = StringEscapeUtils.escapeHtml4(replace03);
                    list.add(replace04);
                }
                
            } else {  // 첫번째 행 이후의 행들
                // 행의 각셀 모두 비어 있지 않은 행의 경우
                if(isEmpty(row) == false) {
                    Element listitem = doc.createElement("listitem");
                    rootEle.appendChild(listitem);
                    
                    // 첫번째 행의 셀수 만큼 반복
                    for(int i=0; i<rowCellCnt; i++) {
                        Cell currCell = row.getCell(i);
                        
                        String values ="";
                        values = new DataFormatter().formatCellValue(currCell);

                        Element listitemSub = doc.createElement(list.get(i).toString().trim());
                        listitem.appendChild(listitemSub);
                        listitemSub.appendChild(doc.createTextNode(values));
                    }
                       
                }  
                                
            }

        }
        
        callTransformer(doc, ExcelFileName);   
    }
    
    private void callTransformer(Document doc, String ExcelFileName) throws Exception {
        File f = new File(ExcelFileName);
        URI u = f.toURI();
        
        // Transformer 생성
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer trans = tf.newTransformer();
        trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");  // 출력 인코딩 방식은 UTF-8 
        trans.setOutputProperty(OutputKeys.INDENT, "yes");  // 정렬 스페이스 4칸
        trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
        
        // 저장할 doc 객체를 Source 객체로 생성 한다.
        DOMSource source = new DOMSource(doc);
        
        // 저장할 위치 정보를 가지고 있는 StreamResult 객체 생성
        Result result = new StreamResult(u.toString());
        
        // transform() 메소드를 호출하여 파일로 출력
        trans.transform(source, result);
    }
    
    private boolean isEmpty(Row row) {
        int rowCellCnt = row.getPhysicalNumberOfCells();
        
        boolean finalBool = false;
        String str = null;
        
        for(int i=0; i<rowCellCnt; i++) {
            Cell currCell = row.getCell(i);

            str += currCell;
        }
        
        Optional<String> op = Optional.ofNullable(str);
        
        if(op.isPresent()) {
            finalBool = false;
        } else {
            finalBool = true;
        }

        return finalBool;
    }


    private static String formatCell(Cell cell) {
        if(cell == null) {
            return "";
        }
        
        switch(cell.getCellType()) {
            case BLANK:
                return "";
            
            case BOOLEAN:
                return Boolean.toString(cell.getBooleanCellValue());
                
            case ERROR:
                return "*error*";
                
            case NUMERIC:
                return createExcelFile.df.format(cell.getNumericCellValue());
                
            case STRING:
                return cell.getStringCellValue();
                
            default:
                return "<unknown value>";
        }
    }
    
    private String textReplaceing(String replace01) {
        switch(replace01) {
            case "바로가기_적용_ID":
                replace01 = replace01.replace("바로가기_적용_ID", "shortcutID");
            break;
            
            case "파일명":
                replace01 = replace01.replace("파일명", "fileName");
            break;
            
            case "플로팅_메뉴_적용":
                replace01 = replace01.replace("플로팅_메뉴_적용", "floating");
            break;
            
            case "contents_string(English)":
                replace01 = replace01.replace("contents_string(English)", "contents_string");
            break;
            
            case "LANGUAGE2":
                replace01 = replace01.replace("LANGUAGE2", "language_header");
            break;
        
        }
        return replace01;
    }
    
}
