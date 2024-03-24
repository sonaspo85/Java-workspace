package SONTEST.TEST03.fileControl;

import java.io.File;
import java.io.FileInputStream;
import java.net.URI;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

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
    commonObj coj = new commonObj();

    public void createExcelFile(File absolutePath) throws Exception {
        List<String> list = new ArrayList<>();
        String extention = coj.getExt(absolutePath);
        String fileName = absolutePath.getName();
        
        if(fileName.contains("_UI_")) {
            fileName = "UITxt.xml";
            
        } else if(fileName.contains("_ID_")) {
            String originalName = fileName;
            fileName = "IDTxt.xml";
        } 
        
        String ExcelFileName = coj.exePath + "\\resource\\" + fileName;
        System.out.println("ExcelFileName: " + ExcelFileName);
       
        // 1. 파일 입력 스트림 생성
        FileInputStream fis = new FileInputStream(absolutePath); 
        
        // 엑셀 로드, Workbook 객체 생성
        Workbook wb = WorkbookFactory.create(fis);

        // 빈 DOM 트리 객체 생성 하기
        Document doc = coj.createDomObj(null);
        
        Element rootEle = doc.createElement("root");
        rootEle.setAttribute("fileName", absolutePath.getName());
        rootEle.setAttribute("version", coj.version);
        rootEle.setAttribute("ccncVer", coj.ccncVer);
        doc.appendChild(rootEle);
        Sheet sheet = wb.getSheetAt(0);
        
        boolean firstRow = true;
        int rowCellCnt = 0;
        int rowIndex = 0;
        int lastRowNum = sheet.getLastRowNum()+1;
        
        // 행을 하나씩 출력
        for(int k= 0; k<lastRowNum; k++) {
            Row row = sheet.getRow(k);
            
            if(row.getRowNum() == 0) {
                rowCellCnt = row.getPhysicalNumberOfCells();
                
                for(int i=0; i<rowCellCnt; i++) {
                    Cell firstCell = row.getCell(i);
                    String replace01 = formatCell(firstCell).replace(" ", "_");
                    String replace02 = replace01.replaceAll("contents_string\\(.*\\)", "contents_string");
                    String replace03 = textReplaceing(replace02);
                    String replace04 = StringEscapeUtils.escapeHtml4(replace03);
                    list.add(replace04);
                }
                
            } else {
                if(isEmpty(row) == false) {
                    Element listitem = doc.createElement("listitem");
                    rootEle.appendChild(listitem);

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
        trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        trans.setOutputProperty(OutputKeys.INDENT, "yes");
        trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
        
        DOMSource source = new DOMSource(doc);
        Result result = new StreamResult(u.toString());
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
