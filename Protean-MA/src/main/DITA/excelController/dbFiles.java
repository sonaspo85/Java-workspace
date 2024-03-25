package main.DITA.excelController;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.text.StringEscapeUtils;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.DITA.Common.implementOBJ;

public class dbFiles {
    implementOBJ obj = new implementOBJ();
    String templateExcel = "";
    String dbFile = "";
    String outExcelPath = "";
    Map<Integer, List<String>> map = new HashMap<>();
    Path sMapDir = null;
    String outMapDir = "";
    String pvPath = "";
    String strlb1 = "";
    String tarLang = "";
    
    public dbFiles(Path sMapDir, String outMapDir, String pvPath, String strlb1) {
        this.sMapDir = sMapDir;
        this.outMapDir = outMapDir;
        this.pvPath = pvPath;
        this.strlb1 = strlb1;
        
        dbFile = outMapDir + "/ExcelDB" + File.separator + strlb1 + File.separator + "exceldb.xml";
        templateExcel = obj.templateExcel;
        outExcelPath = outMapDir + "/ExcelDB" + File.separator + strlb1 + File.separator + "skeleton.xlsx";
    }
    
    
    public void runDbFiles() throws Exception {
    	System.out.println("runDbFiles() 시작");
        copyExcel();
        File file = new File(dbFile);
        FileInputStream fis = new FileInputStream(file);
        
        Reader reader = new InputStreamReader(fis, "UTF-8");
        
        InputSource is = new InputSource(reader);
        is.setEncoding("UTF-8");
        
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder documentBuilder = factory.newDocumentBuilder();
        Document doc = documentBuilder.parse(is);
        XPath xpath = XPathFactory.newInstance().newXPath();
        String expression = "root/items";
        
        NodeList nl = (NodeList) xpath.compile(expression).evaluate(doc, XPathConstants.NODESET);
        
        
        for(int i=0; i<nl.getLength(); i++) {
            Node node = nl.item(i);
            Element ele = (Element) node;

            String pos = ele.getAttribute("pos");
            String chapName = ele.getAttribute("chapName");
            NodeList nl2 = ele.getElementsByTagName("item");
            List<String> mapList = new ArrayList<>();
            
            for(int j=0; j<nl2.getLength(); j++) {
                Node node2 = nl2.item(j);
                Element ele2 = (Element) node2;

                String lang = ele2.getAttribute("lang");
                String icon = "";
                String parastyle = "";
                String fileName = "";
                
                if(j == 0) {
                    fileName = ele2.getAttribute("fragment");
                    icon = ele2.getAttribute("icon");
                    parastyle = ele2.getAttribute("class");
                    
                    mapList.add(fileName);
                    mapList.add(chapName);
                    mapList.add(parastyle);
                    mapList.add(icon);
                }
                
                String titleTxt = StringEscapeUtils.escapeXml11(ele2.getTextContent());
                
                mapList.add(titleTxt);
               
                if(Integer.parseInt(pos) == 1 && j == 1) {
                    tarLang = lang;
                }
                
            }

            map.put(Integer.parseInt(pos), mapList);
            
        }
        
        getExcelTemplate();

    }
    
    // 템플릿 엑셀 파일을 다른 경로로 복사
    public void copyExcel() {
    	System.out.println("copyExcel() 시작");
        Path from = Paths.get(templateExcel);
        Path to = Paths.get(outExcelPath);
        
        try {
            Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
            
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
       
    public CellStyle addCellStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setAlignment(HorizontalAlignment.CENTER);
        
        // Cell background 설정
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorderSyle(style);
        
        // 폰트 설정 하기
        XSSFWorkbook xssfWork = (XSSFWorkbook) workbook;
        XSSFFont font = xssfWork.createFont();
        
        font.setBold(true);
        font.setFontName("Arial");
        style.setFont(font);
        
        return style;
    }
    
    public void setBorderSyle(CellStyle style) {
        style.setBorderBottom(BorderStyle.THIN);  
        style.setBottomBorderColor(IndexedColors.BLUE.getIndex());  
        
        style.setBorderRight(BorderStyle.THIN);  
        style.setRightBorderColor(IndexedColors.BLUE.getIndex());  
        
        style.setBorderLeft(BorderStyle.THIN);  
        style.setLeftBorderColor(IndexedColors.BLUE.getIndex());  
        
        style.setBorderTop(BorderStyle.THIN);  
        style.setTopBorderColor(IndexedColors.BLUE.getIndex());  
    }
    
    private void autoSizeColumns(Sheet sheet, Row eachRow) {
        int rowCount = sheet.getPhysicalNumberOfRows();

        Iterator<Cell> cellIterator = eachRow.cellIterator();
        
        while (cellIterator.hasNext()) {
           Cell cell = cellIterator.next();
           int columnIndex = cell.getColumnIndex();
           sheet.autoSizeColumn(columnIndex);
        }
        
     }
    
    public void getExcelTemplate() {
        File xlsxFile = new File(templateExcel);

        try {
            FileInputStream inputStream = new FileInputStream(xlsxFile);
            Workbook workbook = WorkbookFactory.create(inputStream);
            setCellValues(workbook);
            inputStream.close();
            outExcelF(workbook);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        
    }
    
    public void setCellValues(Workbook workbook) {
        Sheet sheet = workbook.getSheetAt(0);
        setHeaderCell(sheet, workbook);
	    
        //Getting the count of existing records
        int rowCount = 2;
        
        Set<Map.Entry<Integer, List<String>>> entrySet = map.entrySet();
        Iterator<Map.Entry<Integer, List<String>>> iterator1 = entrySet.iterator();
        
        while(iterator1.hasNext()) {
            Map.Entry<Integer, List<String>> entry = iterator1.next();
            int key = entry.getKey();
            
            Row eachRow = sheet.createRow(rowCount++);
            Cell idCell = eachRow.createCell(1);
            idCell.setCellValue(key);
            
            CellStyle style = addCellStyle(workbook);
            idCell.setCellStyle(style);
            
            // List 컬렉션을 반복하여, 나머지 셀값들 얻어 Cell에 채우기
            List<String> listVal = entry.getValue();
            
            for(int t=0; t<listVal.size(); t++) {
                Cell cell = eachRow.createCell(t+2);
                CellStyle bodyStyle = workbook.createCellStyle();
                setBorderSyle(bodyStyle);
                cell.setCellStyle(bodyStyle);
                
                // Cell 자동 줄바꿈
                bodyStyle.setWrapText(true); 
                bodyStyle.setVerticalAlignment(VerticalAlignment.TOP);
                cell.setCellValue(listVal.get(t));
                
                
            }
            
            for(int t=0; t<listVal.size(); t++) {
                Cell cell = eachRow.createCell(8);

                CellStyle bodyStyle = workbook.createCellStyle();
                setBorderSyle(bodyStyle);
                cell.setCellStyle(bodyStyle);
                
                // Cell 자동 줄바꿈
                bodyStyle.setWrapText(true); 
                bodyStyle.setVerticalAlignment(VerticalAlignment.TOP);
                
            }
        }  	
    	
    }
    
    public void setHeaderCell(Sheet sheet, Workbook workbook) {
    	Row headRow = sheet.getRow(1);
	    Cell tarlgnsCell = headRow.createCell(7);
	    tarlgnsCell.setCellValue(tarLang);
	    
	    Cell recommemdCell = headRow.createCell(8);
	    recommemdCell.setCellValue("Recommend");
	    Iterator<Cell> it2 = headRow.cellIterator();
	    
	    while(it2.hasNext()) {
	    	Cell cellVal = it2.next();
	    	
	    	// 각 Cell에 스타일 추가
            CellStyle style = addCellStyle(workbook);
	    	cellVal.setCellStyle(style);
	    	sheet.autoSizeColumn(8);
	    }
	    
    }
    
    public void outExcelF(Workbook workbook) {
    	System.out.println("outExcelF() 시작");
    	
        //Crating output stream and writing the updated workbook
        try {
            FileOutputStream os = new FileOutputStream(outExcelPath);
            workbook.write(os);
            
            //Close the workbook and output stream
            workbook.close();
            os.flush();
            os.close();
            System.out.println("엑셀 생성 완료!!");
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    }
    
}
