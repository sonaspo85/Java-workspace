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
        // Excel 템플릿 경로 얻기
        excelTemplsDirP = Paths.get(obj.resourceDir + File.separator + "excel-template");
        System.out.println("excelTemplsDirP: " + excelTemplsDirP);
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(excelTemplsDirP);
            
            ds.forEach(a -> {
                if(a.getFileName().toString().endsWith(".xlsx")) {
                    try {
                        String abpath = a.toAbsolutePath().toString();
                        String filename = a.getFileName().toString();
                        FileInputStream fis = new FileInputStream(abpath);
                        ZipSecureFile.setMinInflateRatio(0);
                        Workbook wb = WorkbookFactory.create(fis);
                        
                        int sheetCnt = wb.getNumberOfSheets();
                        System.out.println("sheetCnt: " + sheetCnt);
                        
                        // 시트 반복
                        for(int i=0; i<sheetCnt; i++) {
                            Document doc = createDOM();
                            
                            // root 요소 생성
                            Element rootEle = doc.createElement("root");
                            rootEle.setAttribute("filename", filename);
                            doc.appendChild(rootEle);
                            String getSheetName = wb.getSheetName(i).replace(" ", "_").toLowerCase();
                            
                            if(!getSheetName.equals("type-lang")) {
                                Sheet sheet = wb.getSheetAt(i);
                                Iterator<Row> rowIt = sheet.iterator();
                                
                                int startRowNum = 2;
                                int startColNum = 1;
                                
                                List<String> headCellList = new ArrayList<>();
                                int totalCellCnt = 0;
                                // 각 row 를 반복
                                while(rowIt.hasNext()) {
                                    Row row = rowIt.next();
                                    if(row.getRowNum() == 2) { 
                                        totalCellCnt = row.getPhysicalNumberOfCells();
                                        
                                        for(int c=1; c<=totalCellCnt; c++) {
                                            Cell headCell = row.getCell(c);
                                            String str1 = formatCell(headCell);
                                            String str2 = str1.replaceAll("[\\(\\)]", "_").replaceAll("[&/]", "").replaceAll("_$", "");
                                            String str3 = StringEscapeUtils.escapeXml11(str2);
    
                                            headCellList.add(str3);
                                            
                                        }
                                         
                                    } else {
                                        if (!isEmpty(row, totalCellCnt) && row.getRowNum() > startRowNum) { 
                                            Element listitem = doc.createElement("listitem");
                                            rootEle.appendChild(listitem);
                                            
                                            for(int j=1; j<=totalCellCnt; j++) {
                                               Cell cellVal = row.getCell(j);
    
                                               String cellTxt0 = formatCell(cellVal);
                                               String cellTxt = StringEscapeUtils.unescapeXml(cellTxt0).replaceAll("[\n\r]", "&lt;br/&gt;");
                                               
                                               String rowNum0 = String.valueOf(row.getRowNum()+1);
                                               String colNum0 = String.valueOf(j+1);
                                               Element listitemSub = doc.createElement(headCellList.get(j-1));
                                               listitemSub.setAttribute("class", rowNum0 + ":" + colNum0);

                                               // cell값 채우기
                                               listitemSub.appendChild(doc.createTextNode(cellTxt)); 
                                               listitem.appendChild(listitemSub);
                                               
                                            }
                                            
                                        }
    
                                    }
                                    
                                } 
                                
                                exportXML(doc, getSheetName);
                            }   
                        }
                        
                    } catch (Exception e) {
                        msg = "Excel load 실패1";
                        e.printStackTrace();
                    }
                }
                
            });
            
        } catch(Exception e) {
            msg = "Excel load 실패2";
            throw new RuntimeException(msg);
        }
    }
    
    public void exportXML(Document doc, String getSheetName) {
        try {
            String excelPathS = obj.tempDir + File.separator + "excelTempls/" + getSheetName + ".xml";
            Path excelDirs = Paths.get(obj.tempDir + File.separator + "excelTempls");
            Path excelPathP = Paths.get(excelPathS);
            
            if(!Files.exists(excelDirs)) {
                Files.createDirectories(excelDirs);
                
            }

            // 1. Transformer 객체 생성
            TransformerFactory ttf = TransformerFactory.newInstance(); 
            Transformer tf = ttf.newTransformer();
            tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            tf.setOutputProperty(OutputKeys.INDENT, "yes");
            tf.setOutputProperty(OutputKeys.METHOD, "xml");
            tf.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
            
            // 3. DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(excelPathP.toUri().toString());
            
            tf.transform(source, result);
            result.getOutputStream().close();
            
        } catch(Exception e) {
            msg = "Excel load 실패1";
            e.printStackTrace();
        }

    }
        
    
    
    
    public boolean isEmpty(Row row, int totalCellCnt) {
        String str = "";
        
        for(int c=1; c<=totalCellCnt; c++) {
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
        Optional<Cell> op = Optional.ofNullable(cell);
        
        if (!op.isPresent()) {
            return "";
            
        } else {
            Cell cellVal = op.get();

            switch (cellVal.getCellType()) {
                case BLANK:
                    return "";
                    
                case BOOLEAN:
                    return Boolean.toString(cellVal.getBooleanCellValue());
                
                case ERROR:
                    return "*error*";

                case NUMERIC:
                    return df.format(cellVal.getNumericCellValue());

                case STRING:
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
