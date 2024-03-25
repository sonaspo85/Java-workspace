package main.java.xmlcontroller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.CommonObj.implementOBJ;

public class dbFiles2excel {
    implementOBJ obj = new implementOBJ();
    String templateExcel = "";
    String dbFile = "";
    String outExcelPath = "";
    String nameC = "";
    String urlC = "";
    String msg = "";
    static DataFormatter dfm = new DataFormatter();
    static DecimalFormat df = new DecimalFormat("###.###");
    
    public dbFiles2excel() {
        File projectDir = new File(""); 
        templateExcel = projectDir.getAbsolutePath() + File.separator + "jre" + File.separator + "lib/resource" + File.separator + "sampleTemplate.xlsx";
        dbFile = obj.tempDir + File.separator + "merged_final.xml";
        
        if(obj.tarDir != null) {
            outExcelPath = obj.tarDir.toString() + File.separator + obj.tarName.replace(".zip", "") + "_비교 결과" + ".xlsx";
        
        } else {
            outExcelPath = obj.srcDir.toString() + File.separator + obj.srcName.replace(".zip", "") + "_비교 결과" + ".xlsx";;
        }
    }
    
    public void runDB2Excel() {
        try {
            // DB 파일 로드
            File dbF = new File(dbFile);
            FileInputStream fis = new FileInputStream(dbF);
            Reader reader = new InputStreamReader(fis, "UTF-8");
            InputSource is = new InputSource(reader);
            is.setEncoding("UTF-8");
            
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(is);
            Element rootTag = doc.getDocumentElement();
            NodeList nl1 = rootTag.getChildNodes();
            
            readExeltemplate(nl1);
            
        } catch (Exception e) {
            msg = "dbFiles2excel > DB 파일 읽기 실패";
            throw new RuntimeException(msg);
        } 
        
        
    }
    
    public void readExeltemplate(NodeList nl1) {
        try {
            FileInputStream excelfis = new FileInputStream(templateExcel);
            Workbook workbook = WorkbookFactory.create(excelfis);
            
            Sheet sheet = workbook.getSheetAt(0);
            Row eachRow = sheet.createRow(0);
            
            // cell에 스타일 추가
            CellStyle style = workbook.createCellStyle();

            // 변수를 새로 만들어서 스타일을 지정
            CellStyle styleBackground = workbook.createCellStyle();
            CellStyle styleBorder = workbook.createCellStyle();
            setBorderSyle(styleBorder);

            // 파일이름 채우기
            insertDocInfo(workbook, sheet);
            
            int rowCount = 6;
            List<String> listVal = new ArrayList<>();
            
            // 데이터 추출
            for(int i=0; i<nl1.getLength(); i++) {
                Node node = nl1.item(i);
                
                if(node.getNodeType() == Node.ELEMENT_NODE) {
                    Element ele = (Element) node;
                    String tagName = ele.getNodeName();
                    eachRow = sheet.getRow(rowCount);
                    
                    Cell cell = null;
                    CellStyle styleWrap = workbook.createCellStyle();
                    String type = ele.getAttribute("type");
                    String modelname = ele.getAttribute("modelname");
                    String QRimages = ele.getAttribute("qrcodImg");
                    String QRcodeURL = ele.getAttribute("url");
                    String meterialDoc = ele.getAttribute("meterialDoc");
                    String meterialCodeDB = ele.getAttribute("meterialCodeDB");
                    String modelNQRC = ele.getAttribute("nameNurlC");
                    nameC = ele.getAttribute("nameC");
                    urlC = ele.getAttribute("urlC");
                    
                    listVal.add(type);
                    listVal.add(modelname);
                    listVal.add(QRimages);
                    listVal.add(QRcodeURL);
                    listVal.add(meterialDoc);
                    listVal.add(meterialCodeDB);
                    listVal.add(modelNQRC);
                    
                    for (int t = 0; t < listVal.size(); t++) {
                        String vals = listVal.get(t);
                        String vals2 = vals.replace("_x", "_X");
                        
                        if(tagName.equals("Src")) {
                            cell = eachRow.createCell(t + 1);
                            cell.setCellValue(vals2);
                            styleBorder.setWrapText(true);
                            styleBorder.setVerticalAlignment(VerticalAlignment.CENTER);
                            cell.setCellStyle(styleBorder);
                           
                            if(vals2.equals("false")) {
                                styleBackground.setFillForegroundColor(IndexedColors.CORAL.getIndex());
                                styleBackground.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                                styleBackground.setVerticalAlignment(VerticalAlignment.CENTER);
                                cell.setCellStyle(styleBackground);
                            }
                            
                        } else if(tagName.equals("Tar") & type.equals("합본")) {
                            cell = eachRow.createCell(t + 1);
                            cell.setCellValue(vals2);
                            styleBorder.setWrapText(true);
                            styleBorder.setVerticalAlignment(VerticalAlignment.CENTER);
                            cell.setCellStyle(styleBorder);
                            
                            if(vals2.equals("false")) {
                                setBorderSyle(styleBackground);
                                styleBackground.setFillForegroundColor(IndexedColors.CORAL.getIndex());
                                styleBackground.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                                styleBackground.setVerticalAlignment(VerticalAlignment.CENTER);
                                cell.setCellStyle(styleBackground);

                            }
                            
                        } 
                        
                    }

                    insertTotal(workbook, sheet);
                    listVal.clear();
                    System.out.println("rowCount: " + rowCount);
                    rowCount++;
                }
                
            }
            
            excelfis.close();

            FileOutputStream os = new FileOutputStream(outExcelPath);
            workbook.write(os);
            workbook.close();
            os.close();
            
        } catch(Exception e) {
            msg = "dbFiles2excel > 엑셀 탬플릿 파일 읽기 실패";
            throw new RuntimeException(msg);
        }
         
    }
    
    public void insertTotal(Workbook workbook, Sheet sheet) {
        System.out.println("insertTotal() 시작");
        CellStyle totalStyle = workbook.createCellStyle();
        // 새로 정렬
        totalStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        // 가로 정렬
        totalStyle.setAlignment(HorizontalAlignment.CENTER);
        setBorderSyle(totalStyle);
        Cell cell = sheet.getRow(11).createCell(2);
        cell.setCellValue(nameC);
        cell.setCellStyle(totalStyle);
        cell = sheet.getRow(12).createCell(2);
        cell.setCellValue(urlC);
        cell.setCellStyle(totalStyle);
        
    }
    
    public void insertDocInfo(Workbook workbook, Sheet sheet) {
        System.out.println("insertDocInfo() 시작");
        
        // CellStyle 객체 생성 
        CellStyle infoStyle = workbook.createCellStyle();
        setBorderSyle(infoStyle);
        String srcName = obj.srcName; 
        String tarName = obj.tarName;
        Cell cell = sheet.getRow(1).createCell(2);
        cell.setCellValue(srcName);
        cell.setCellStyle(infoStyle);
        cell = sheet.getRow(2).createCell(2);
        cell.setCellValue(tarName);
        cell.setCellStyle(infoStyle);
        
    }
    
    public static String formatCell(Cell cell) {
        Optional<Cell> op = Optional.ofNullable(cell);

        if (!op.isPresent()) {
            return "";
        } else {
            Cell cell1 = op.get();
            switch (op.get().getCellType()) {
                case BLANK:
                    return "";

                case BOOLEAN:
                    return Boolean.toString(cell1.getBooleanCellValue());

                case ERROR:
                    return "*error*";

                case NUMERIC:
                    return df.format(cell1.getNumericCellValue());

                case STRING:
                    return dfm.formatCellValue(cell1);
                default:
                    return "<unknown value>";
            }
        }
    }
    
    public void setBorderSyle(CellStyle style) {
        style.setBorderBottom(BorderStyle.THIN);  
        style.setBottomBorderColor(IndexedColors.BLACK.getIndex());  
        style.setBorderRight(BorderStyle.THIN);  
        style.setRightBorderColor(IndexedColors.BLACK.getIndex());  
        style.setBorderLeft(BorderStyle.THIN);  
        style.setLeftBorderColor(IndexedColors.BLACK.getIndex());  
        style.setBorderTop(BorderStyle.THIN);  
        style.setTopBorderColor(IndexedColors.BLACK.getIndex());  
    }
    
    
}
