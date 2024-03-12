package xmlTExcel.runMain;

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

public class dbFiles {
    String templateExcel = "";
    String dbFile = "";
    String outExcelPath = "";
    Map<Integer, List<String>> map = new HashMap<>();
    
    String tarLang = "";
    
    public dbFiles(String templateExcel, String dbFile, String outExcelPath) {
        this.templateExcel = templateExcel;
        this.dbFile = dbFile;
        this.outExcelPath = outExcelPath;
    }
    
    
    public void runDbFiles() throws Exception {
    	System.out.println("runDbFiles() 시작");
        // template 엑셀 파일을 새로운 경로로 복사
        copyExcel();
        
        // db.xml 파일 읽기
        File file = new File(dbFile);
        FileInputStream fis = new FileInputStream(file);
        
        Reader reader = new InputStreamReader(fis, "UTF-8");
        
        InputSource is = new InputSource(reader);
        is.setEncoding("UTF-8");
        
        // DocumentBuilderFactory 객체를 생성 하고, xml DOM 트리 구조로 파일 읽기
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder documentBuilder = factory.newDocumentBuilder();
        Document doc = documentBuilder.parse(is);
        
        // XPath 객체 생성
        XPath xpath = XPathFactory.newInstance().newXPath();
        
        String expression = "root/items";
        
        NodeList nl = (NodeList) xpath.compile(expression).evaluate(doc, XPathConstants.NODESET);
        
        
        for(int i=0; i<nl.getLength(); i++) {
            Node node = nl.item(i);
            Element ele = (Element) node;
            
            // ID 값으로 사용할 번호 추출
            String pos = ele.getAttribute("pos");
            String chapName = ele.getAttribute("chapName");
//            System.out.println("chapName: " + chapName);
            
            // items 요소 밑에 item 요소 찾아 들어가기
            NodeList nl2 = ele.getElementsByTagName("item");
            List<String> mapList = new ArrayList<>();
            
            for(int j=0; j<nl2.getLength(); j++) {
                Node node2 = nl2.item(j);
                Element ele2 = (Element) node2;
                
                // ISO 언어코드 얻기
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
//                    System.out.println("lang: " + lang);
                    tarLang = lang;
                }
                
            }

            map.put(Integer.parseInt(pos), mapList);
            
        }
        
        
        // 템플릿으로 사용할 엑셀 파일 읽기
        getExcelTemplate();

    }
    
    // 템플릿 엑셀 파일을 다른 경로로 복사
    public void copyExcel() {
    	System.out.println("copyExcel() 시작");
        Path from = Paths.get(templateExcel);
        Path to = Paths.get(outExcelPath);
        
        try {
            Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
            System.out.println("파일 복사 완료");
            
        } catch (IOException e) {
            System.out.println("파일 복사 실패");
            e.printStackTrace();
        }

    }
       
    // Cell에 스타일 추가 하기
    public CellStyle addCellStyle(Workbook workbook) {
        // cell에 스타일 추가
        CellStyle style = workbook.createCellStyle();
        
        // 세로 중앙 정렬
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        
        // 가로 중앙 정렬
        style.setAlignment(HorizontalAlignment.CENTER);
        
        // Cell background 설정
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        // Cell 에 border 설정
        setBorderSyle(style);
        
        // 폰트 설정 하기
        // workbook 을 XSSFWorkbook 객체로 변환 
        XSSFWorkbook xssfWork = (XSSFWorkbook) workbook;

        // 폰트 설정
        XSSFFont font = xssfWork.createFont();
        font.setBold(true);  // bold체 설정
//        font.setFontHeight((short) (20*20));  // 20pt로 설정
        font.setFontName("Arial"); // font-family 설정
//        font.setFontHeightInPoints((short) 12);  // font size 설정
        style.setFont(font);  // style에 font 지정
        
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

//        eachRow = sheet.getRow(2);
        Iterator<Cell> cellIterator = eachRow.cellIterator();
        
        while (cellIterator.hasNext()) {
           Cell cell = cellIterator.next();
           int columnIndex = cell.getColumnIndex();
           sheet.autoSizeColumn(columnIndex);
        }
        
     }
    
    public void getExcelTemplate() {
    	System.out.println("getExcelTemplate() 시작");
        File xlsxFile = new File(templateExcel);

        try {
            //Creating input stream
            FileInputStream inputStream = new FileInputStream(xlsxFile);
             
            //Creating workbook from input stream
            Workbook workbook = WorkbookFactory.create(inputStream);
            
            // 엑셀의 각 Cell에 데이터 입력 하기
            setCellValues(workbook);

            //Close input stream
            inputStream.close();
            
            outExcelF(workbook);
            
            System.out.println();
             
            System.out.println("Excel file has been updated successfully.");
           
            
        } catch (Exception e) {
            System.err.println("Exception while updating an existing excel file.");
            e.printStackTrace();
        }
        
        
    }
    
    public void setCellValues(Workbook workbook) {
    	//Reading first sheet of excel file
        Sheet sheet = workbook.getSheetAt(0);
        
        // Header Cell 생성하기
        setHeaderCell(sheet, workbook);
	    
        //Getting the count of existing records
        int rowCount = 2;

        // Map 컬렉션으로 모은 데이터를 하나씩 추출하기
        Set<Map.Entry<Integer, List<String>>> entrySet = map.entrySet();
        Iterator<Map.Entry<Integer, List<String>>> iterator1 = entrySet.iterator();
        
        while(iterator1.hasNext()) {
            Map.Entry<Integer, List<String>> entry = iterator1.next();
            int key = entry.getKey();
            
            Row eachRow = sheet.createRow(rowCount++);
            Cell idCell = eachRow.createCell(1);
            idCell.setCellValue(key);
            
            // 각 Cell에 스타일 추가
            CellStyle style = addCellStyle(workbook);
            idCell.setCellStyle(style);
            
            // List 컬렉션을 반복하여, 나머지 셀값들 얻어 Cell에 채우기
            List<String> listVal = entry.getValue();
            
            for(int t=0; t<listVal.size(); t++) {
                Cell cell = eachRow.createCell(t+2);
                
                //	cell에 스타일 추가
                CellStyle bodyStyle = workbook.createCellStyle();
                setBorderSyle(bodyStyle);
                cell.setCellStyle(bodyStyle);
                
                // Cell 자동 줄바꿈
                bodyStyle.setWrapText(true); 
                // Cell 새로 정렬
                bodyStyle.setVerticalAlignment(VerticalAlignment.TOP);
                cell.setCellValue(listVal.get(t));
                
                
            }
            
            // Recommend 셀 만들기
            for(int t=0; t<listVal.size(); t++) {
                Cell cell = eachRow.createCell(8);
                
                //	cell에 스타일 추가
                CellStyle bodyStyle = workbook.createCellStyle();
                setBorderSyle(bodyStyle);
                cell.setCellStyle(bodyStyle);
                
                // Cell 자동 줄바꿈
                bodyStyle.setWrapText(true); 
                // Cell 새로 정렬
                bodyStyle.setVerticalAlignment(VerticalAlignment.TOP);
                
            }
            
            // 각 Cell 사이즈 자동 조절 하기
//            autoSizeColumns(sheet, eachRow);
        }  	
    	
    }
    
    public void setHeaderCell(Sheet sheet, Workbook workbook) {
    	Row headRow = sheet.getRow(1);
	    Cell tarlgnsCell = headRow.createCell(7);
	    tarlgnsCell.setCellValue(tarLang);
	    
	    Cell recommemdCell = headRow.createCell(8);
	    recommemdCell.setCellValue("Recommend");
	    
	    // Row 의 첫번째 행(head row) 을 반복 하여 스타일 추가 하기
	    Iterator<Cell> it2 = headRow.cellIterator();
	    
	    // Head row의 각 cell을 반복하여 스타일 추가
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
            os.close();
            System.out.println("엑셀 생성 완료!!");
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    }
    
    
//    public List<String> getList() {
//        return list;
//    } 
}
