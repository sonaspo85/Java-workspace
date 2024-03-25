package main.java.zipController.xml2excel;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.codec.binary.Hex;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.zipController.Common.implementOBJ;

public class dbFiles2excel {
    implementOBJ obj = new implementOBJ();
    String templateExcel = obj.packageDir + "/resource/template.xlsx";
    String dbFile = obj.resultDoc;

    Map<Integer, List<String>> map = new HashMap<>();
    String tarLang = "";
    
    
    
    public void runDbFiles() throws Exception {
        File file = new File(dbFile);
        FileInputStream fis = new FileInputStream(file); 
        Reader reader = new InputStreamReader(fis, "UTF-8");
        InputSource is = new InputSource(reader);
        is.setEncoding("UTF-8");

        // DocumentBuilderFactory 객체를 생성하고, XML DOM 트리 구조로 파일 로드
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(is);
        
        Element rootTag = doc.getDocumentElement();
        String region = rootTag.getAttribute("region"); 
        String zipName = rootTag.getAttribute("folderName") ;
        String coverModelName = rootTag.getAttribute("coverModelName");
        String productType = rootTag.getAttribute("productType");
        String opticalType = rootTag.getAttribute("opticalType");
        String errorCnt = rootTag.getAttribute("errorCnt");
        
        NodeList nl1 = rootTag.getChildNodes();
        File xlsxFile = new File(templateExcel);

        // 입력 스트림으로 파일 읽기
        FileInputStream excelis = new FileInputStream(xlsxFile);
        Workbook workbook = WorkbookFactory.create(excelis);
        Sheet sheet = workbook.getSheetAt(0);
        sheet.protectSheet("aaa");
        
        List<String> listVal = new ArrayList<>();
        int rowCount = 7;
        insertDocInfo(workbook, sheet, zipName, productType, opticalType, errorCnt);

        // doc 의 개수 만큼 반복
        for(int i=0; i<nl1.getLength(); i++) {
            int firstCheck = 0;

            Node node1 = nl1.item(i);
            
            if(node1.getNodeType() == Node.ELEMENT_NODE) {
                Element ele1 = (Element) node1;
                String attrLang = ele1.getAttribute("lang");
                NodeList nl2 = ele1.getChildNodes();
                Font defaultFont = workbook.createFont();
                defaultFont.setFontName("Arial");
                defaultFont.setBold(true);
                
                for(int j=0; j<nl2.getLength(); j++) {
                    Node node2 = nl2.item(j);
                    
                    CellStyle style = workbook.createCellStyle();
                    style.setVerticalAlignment(VerticalAlignment.CENTER);
                    
                    if(node2.getNodeType() == Node.ELEMENT_NODE) {
                        Element ele2 = (Element) node2;
                        String cell3 = ele2.getAttribute("desc");
                        String cell4 = ele2.getAttribute("specXML");
                        String cell5 = ele2.getAttribute("indesignData");
                        String cell6 = ele2.getAttribute("langXML");
                        String cell7 = ele2.getAttribute("compare");

                        Row eachRow = sheet.createRow(rowCount);
                        Cell cell = null;
                        
                        listVal.add(cell3);
                        listVal.add(cell4);
                        listVal.add(cell5);
                        listVal.add(cell6);
                        listVal.add(cell7);

                        if(firstCheck == 0) {
                            cell = eachRow.createCell(1);
                            
                            // 폰트 설정
                            XSSFFont font = (XSSFFont) workbook.createFont();
                            XSSFCellStyle cellStyle = (XSSFCellStyle) workbook.createCellStyle();
                            font.setFontName("Arial");
                            font.setBold(true);  // bold체 설정
                            cellStyle.setFont(font);  // style에 font 지정
                            cellStyle.setWrapText(true);
                            cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                            cellStyle.setLocked(true);
                            cell.setCellValue(attrLang);
                            cell.setCellStyle(cellStyle);
                            
                        } 

                        if(ele2.getNodeName().equals("enter")) {
                            cell = eachRow.createCell(1);
                            eachRow.setHeight((short) 50);
                            LostRowBackground(workbook, cell);
                        }
                        
                        for (int t=0; t<listVal.size(); t++) {
                            cell = eachRow.createCell(t + 2);

                            // 셀에 값 채우기
                            cell.setCellValue(listVal.get(t));
                            style.setWrapText(true);
                            cell.setCellStyle(style);

                            if(t == 0) {
                                XSSFFont font = (XSSFFont) workbook.createFont();
                                XSSFCellStyle cellStyle = (XSSFCellStyle) workbook.createCellStyle();
                                font.setFontName("Arial");
                                font.setBold(true);  // bold체 설정
                                cellStyle.setFont(font);  // style에 font 지정
                                cellStyle.setWrapText(true);
                                cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                                cell.setCellStyle(cellStyle);
                                
                            }
                            
                            // enter 태그일 경우 색깔 넣기
                            if(ele2.getNodeName().equals("enter")) {
                                LostRowBackground(workbook, cell);
                            }
                            
                            if (cell7.equals("Fail") | cell7.equals("Not Support")) {
                                XSSFCellStyle cellStyle = setFailBackground(workbook);
                                cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                                
                                if(t == 0) {
                                	cellStyle.setFont(defaultFont);
                                }
                                
                                cell.setCellStyle(cellStyle);
                            }
                            
                            // Success, Fail 셀일 경우 텍스트 중앙 정렬
                            if(t == 4) {        
                                String rgbS = "FFCCCC";
                                byte[] rgbB = Hex.decodeHex(rgbS);
                                XSSFColor color = new XSSFColor(rgbB, null);
                                XSSFCellStyle cellStyle = (XSSFCellStyle) workbook.createCellStyle();
                                cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                                cellStyle.setAlignment(HorizontalAlignment.CENTER);
                                
                                // Fail 셀 색 추가
                                if(cell7.equals("Fail") | cell7.equals("Not Support")) {
                                    cellStyle.setFillForegroundColor(color);
                                    cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                                    
                                }
                                
                                cell.setCellValue(listVal.get(t));
                                cell.setCellStyle(cellStyle);
                                
                                if(ele2.getNodeName().equals("enter")) {
                                    LostRowBackground(workbook, cell);
                                }
                            }
                        }
                        
                        listVal.clear();
                        firstCheck++;
                        rowCount++;
                    }
                }
                
            }
            
        }
        
        // 엑셀 입력 스트림 닫기
        excelis.close();
        
        // 날짜 생성 하기
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
        String strDate = sdf.format(date);
        String outExcelPath = obj.srcDir + File.separator + obj.srcFileName + "_사양점검결과_Ver" + obj.programVer + "_" + strDate + ".xlsx";        
        obj.outExcelPath = outExcelPath;
        FileOutputStream os = new FileOutputStream(outExcelPath);
        workbook.write(os);

        //Close the workbook and output stream
        workbook.close();
        os.close();
        
    }

    public void insertDocInfo(Workbook workbook, Sheet sheet, String zipName, String productType, String opticalType, String errorCnt) {
        Cell acell = sheet.getRow(2).createCell(2);
        acell.setCellValue(zipName);
        
        // version 넣기
        acell = sheet.getRow(0).createCell(6);
        acell.setCellValue(obj.programVer);
        
        // 제품 타입 넣기
        acell = sheet.getRow(3).createCell(2);
        acell.setCellValue(productType);
        
        // 지문 인식 넣기
        acell = sheet.getRow(4).createCell(2);
        acell.setCellValue(opticalType);
        
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setColor(HSSFColor.HSSFColorPredefined.DARK_RED.getIndex());
        style.setFont(font);
        
        // 오류 개수
        acell = sheet.getRow(5).createCell(2);
        acell.setCellValue(errorCnt);
        acell.setCellStyle(style);
    }
    
    public void LostRowBackground(Workbook workbook, Cell cell) {
        CellStyle style = workbook.createCellStyle();
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setFillForegroundColor(IndexedColors.DARK_TEAL.getIndex());
        cell.setCellStyle(style);
    }
    
    public XSSFCellStyle setFailBackground(Workbook workbook) {
        XSSFCellStyle cellStyle = null;
        try {
            String rgbS = "FFCCCC";
            byte[] rgbB = Hex.decodeHex(rgbS);
            XSSFColor color = new XSSFColor(rgbB, null);
            cellStyle = (XSSFCellStyle) workbook.createCellStyle();
            cellStyle.setFillForegroundColor(color);
            cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            cellStyle.setWrapText(true);
            
        } catch(Exception e1) {
           throw new RuntimeException(e1.getMessage()); 
           
        }
        
        return cellStyle;
    }

}
