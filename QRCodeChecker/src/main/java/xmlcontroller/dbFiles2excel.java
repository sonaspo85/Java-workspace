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
        System.out.println("dbFile: " + dbFile);
        if(obj.tarDir != null) {
            outExcelPath = obj.tarDir.toString() + File.separator + obj.tarName.replace(".zip", "") + "_비교 결과" + ".xlsx";
            
        } else {
            outExcelPath = obj.srcDir.toString() + File.separator + obj.srcName.replace(".zip", "") + "_비교 결과" + ".xlsx";;
        }
    }
    
    public void runDB2Excel() {
        System.out.println("runDB2Excel() 시작");
        
        System.out.println("templateExcel: " + templateExcel);
        System.out.println("dbFile: " + dbFile);
        System.out.println("outExcelPath: " + outExcelPath);
        
        try {
            // 1. DB 파일 읽기
            File dbF = new File(dbFile);
            FileInputStream fis = new FileInputStream(dbF);
            Reader reader = new InputStreamReader(fis, "UTF-8");
            InputSource is = new InputSource(reader);
            is.setEncoding("UTF-8");
            
            // 2. DocumentBuilderFactory 객체를 생성하고, XML DOM 트리 구조로 파일 읽기
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(is);

            // 3. root 태그에 접근
            Element rootTag = doc.getDocumentElement();
            
            // 4. 자식 Src, Tar, Total 태그에 접근
            NodeList nl1 = rootTag.getChildNodes();
            
            
            // 5. 엑셀 탬플릿 읽기
            readExeltemplate(nl1);
            
        } catch (Exception e) {
            System.out.println("dbFiles2excel > DB 파일 읽기 실패");
            msg = "dbFiles2excel > DB 파일 읽기 실패";
            throw new RuntimeException(msg);
        } 
        
        
    }
    
    public void readExeltemplate(NodeList nl1) {
        System.out.println("readExeltemplate() 시작");
        
        try {
            // 1. 입력 스트림으로 엑셀 탬플릿 파일 읽기
            FileInputStream excelfis = new FileInputStream(templateExcel);
            
            
            // 2. 입력 스트림으로 읽은 엑셀 파일로 워크 시트 생성하기
            Workbook workbook = WorkbookFactory.create(excelfis);
            
            Sheet sheet = workbook.getSheetAt(0);
            Row eachRow = sheet.createRow(0);
            
            // cell에 스타일 추가
            CellStyle style = workbook.createCellStyle();
            
            // Cell값이 false인 경우 셀 배경색을 지정하기 위해 생성함
            // 위 style 변수를 이용하여 setFillForegroundColor 를 할당할 경우 모든 셀이 배경색이 채워지기 때문에,
            // 변수를 새로 만들어서 스타일을 지정함
            CellStyle styleBackground = workbook.createCellStyle();
            
            // cell border 테두리 지정
            CellStyle styleBorder = workbook.createCellStyle();
            setBorderSyle(styleBorder);

            // 3. 파일이름 채우기
            insertDocInfo(workbook, sheet);
            
            // 데이터를 채울 시작 Row 할당
            int rowCount = 6;
            
            // DB 데이터를 list 컬렉션에 모으기 위해 사용
            List<String> listVal = new ArrayList<>();
            

            // 4. 데이터 채우기
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
//                            System.out.println("aaa: " + vals2);
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
                        
                    }  // for문 닫기

                    // total 입력 하기
                    insertTotal(workbook, sheet);
                    
                    
                    // clear() 를 해주지 않으면 계속 컬렉션 목록이 쌓이기 때문에 
                    // 새로운 행에서 진행될 경우 값을 초기화 시키고 다시 컬렉션 목록을 추가 해줘야 한다.
                    listVal.clear();
                    System.out.println("rowCount: " + rowCount);
                    rowCount++;
                }
                
            }
            
            // 엑셀 입력 스트림 닫기
            excelfis.close();

            FileOutputStream os = new FileOutputStream(outExcelPath);
            workbook.write(os);

            //Close the workbook and output stream
            workbook.close();
            os.close();
            System.out.println("엑셀 생성 완료!!");
            
        } catch(Exception e) {
            System.out.println("dbFiles2excel > 엑셀 탬플릿 파일 읽기 실패");
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

        // 1. srcName 입력 하기
        Cell cell = sheet.getRow(1).createCell(2);
        cell.setCellValue(srcName);
        cell.setCellStyle(infoStyle);
        
        // 2. tarName 입력 하기
        cell = sheet.getRow(2).createCell(2);
        cell.setCellValue(tarName);
        cell.setCellStyle(infoStyle);
        
    }
    
    public static String formatCell(Cell cell) {
        Optional<Cell> op = Optional.ofNullable(cell);

        if (!op.isPresent()) {
            // null인 경우, 임의의 텍스트 입력
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
                    //                    return cell.getStringCellValue();
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
