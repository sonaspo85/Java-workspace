package main.java.satisfy.modules;

import java.io.File;
import java.io.FileInputStream;
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
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellReference;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import main.java.satisfy.Common.implementOBJ;

public class excelTxml {
    implementOBJ obj = new implementOBJ();
    String excelPath = "";
    String exceltype = "";
    static DataFormatter dfm = new DataFormatter();
    static DecimalFormat df = new DecimalFormat("###.###");
    static List<String> firstCellList = new ArrayList<>();
    
    int rowNum = 0;
    int colIndex = 0;
    
    String fileName = "";
    
    int startRow = 0;
    int startCol = 0;
    int startColBody = 0;
    
    
    public excelTxml(String path, String exceltype) {
        this.excelPath = path;
        fileName = new File(path).getName();
        this.exceltype = exceltype;
    }
    
    public Path runexcel() throws Exception {
        Path path = Paths.get(excelPath);
        String mergedCellVal = "";


        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.newDocument();
        doc.setXmlStandalone(true);

        Element rootEle = doc.createElement("root");
        rootEle.setAttribute("filename", fileName);
        
        doc.appendChild(rootEle);

        try {
            FileInputStream fis = new FileInputStream(path.toFile());
            Workbook wb = WorkbookFactory.create(fis);
            
            // 엑셀의 시작 시트 설정
            int startsheet = 0;
            if (exceltype.equals("othertype")) {
                startsheet = 0;
                
            } else if(exceltype.equals("satisfy")) {
                startsheet = 2;
            }
            
            Sheet sheet = wb.getSheetAt(startsheet);
            
            // 가중치 구하기
            String percent = sheet.getRow(4).getCell(2).toString();
            rootEle.setAttribute("percentage", percent);
            Iterator <Row> rowIt = sheet.iterator();
            int totalCellCnt = 0;
            setStartRowCell();
            
            // 각 row를 반복 
            while (rowIt.hasNext()) {
                // 각 row 하나씩 추출
                Row row = rowIt.next();
                 
                if (row.getRowNum() == startRow) {
                    if (exceltype.equals("othertype")) {
                        totalCellCnt = row.getPhysicalNumberOfCells();
                        
                    } else if(exceltype.equals("satisfy")) {
                        totalCellCnt = row.getPhysicalNumberOfCells() + 1;
                    }
                    
                    for(int c=startCol; c<=totalCellCnt; c++) {
                        Cell firstCell = row.getCell(c);
                        
                        if(exceltype.equals("satisfy") && c == 1) {
                            firstCell.setCellValue("항목");
                        }
                        
                        String str1 = formatCell(firstCell);
                        String str2 = str1.replace(" ", "_");
                        String str3 = str2.replaceAll("[\\(\\)]", "");
                        String str4 = StringEscapeUtils.escapeHtml4(str3);
                        firstCellList.add(str4);
                    }
                    
                } 
                
                else {                     
                    if (!isEmpty(row) && row.getRowNum() > startColBody && 
                            row.getRowNum() < 20) {
                        Element listitem = doc.createElement("listitem");
                        rootEle.appendChild(listitem);

                        outter:
                        for (int j=startCol; j<totalCellCnt; j++) {
                            Cell cellVal = row.getCell(j);
                            String mergedRange = "";
                            String cellTxt0 = formatCell(cellVal);
                            String cellTxt = StringEscapeUtils.escapeXml11(cellTxt0).replaceAll("[\n\r]", "&lt;br/&gt;");
                            String rowNum0 = String.valueOf(row.getRowNum() + 1);
                            String colNum0 = String.valueOf(j + 1);
                            Element listitemSub = null;
                            
                            if (exceltype.equals("othertype")) {
                                listitemSub = doc.createElement(firstCellList.get(j).toString());
                                
                            } else if(exceltype.equals("satisfy")) {
                                listitemSub = doc.createElement(firstCellList.get(j-1).toString());
                            }
                            
                            
                            listitemSub.setAttribute("class", rowNum0 + ":" + colNum0);
                            listitem.appendChild(listitemSub);
                            
                            // Cell 값이 null이 아닌 경우
                            if (cellVal != null) {
                                for (int k=0; k<sheet.getNumMergedRegions(); k++) {  
                                    CellRangeAddress region = sheet.getMergedRegion(k);
                                    mergedRange = region.formatAsString();
//                                    String[] arrays = mergedRange.split(":");
                                    rowNum = region.getFirstRow();
                                    colIndex = region.getFirstColumn();
                                    
                                    // 병합된 영역의 첫번째 Cell 인지 확인 하는 if문 
                                    if (rowNum == cellVal.getRowIndex() && colIndex == cellVal.getColumnIndex()) {
                                        // 병합된 셀의 첫번째 셀인 경우 값 추출
                                        String getCellVal = sheet.getRow(rowNum).getCell(colIndex).getStringCellValue();
                                        mergedCellVal = StringEscapeUtils.escapeXml11(getCellVal);
                                        listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                        listitem.appendChild(listitemSub);
                                        continue outter;
                                    }

                                }

                                if (cellVal.getCellType() == CellType.BLANK || cellVal == null) {
                                    int curRow = cellVal.getRowIndex();
                                    int curColumn = cellVal.getColumnIndex();
                                    String curAddr = cellVal.getAddress().formatAsString();
                                    String curAlphabet = curAddr.replaceAll(("(\\d+)"), "");
                                    
                                    int curRowNum = Integer.valueOf(curAddr.replaceAll(("([a-zA-Z])"), ""));

                                    List <String> list = new ArrayList<>(); 
                                    for (int u = 0; u < sheet.getNumMergedRegions(); u++) {
                                        CellRangeAddress region = sheet.getMergedRegion(u);
                                        String checkedRange = region.formatAsString();

                                        list.add(checkedRange);
                                    } // for문 닫기

                                    for (int t = 0; t < list.size(); t++) {
                                        String[] arrays = list.get(t).split(":");
                                        String rowAlphabet = arrays[0];
                                        String tRowAlphabet = rowAlphabet.replaceAll(("(\\d+)"), "");
                                        
                                        int tRowNum = Integer.valueOf(rowAlphabet.replaceAll(("([a-zA-Z])"), ""));
                                        
                                        // col 알파벳
                                        String colAlphabet = arrays[1];
                                        String tColAlphabet = colAlphabet.replaceAll(("(\\d+)"), "");
                                        int tColNum = Integer.valueOf(colAlphabet.replaceAll(("([a-zA-Z])"), ""));
                                        
                                        // rowspan인 경우
                                        if (curAlphabet.equals(tRowAlphabet) && 
                                                (tRowNum < curRowNum && curRowNum <= tColNum )) {
                                            if (rowAlphabet.matches(curAlphabet + "\\d+")) {
                                                CellReference ref = new CellReference(rowAlphabet);
                                                Row r = sheet.getRow(ref.getRow());
                                                Cell c = null;
                                                if (r != null) {
                                                    c = r.getCell(ref.getCol());
//                                                    System.out.println("rowspan인 경우 " + rowAlphabet + ": " + c);
                                                }
                                                
                                                listitemSub.appendChild(doc.createTextNode(c.getStringCellValue()));
                                                listitem.appendChild(listitemSub);

                                                continue;

                                            }

                                        }

                                        // colspan인 경우
                                        else if (curRowNum == tRowNum && 
                                                (tRowAlphabet.codePointAt(0) < curAlphabet.codePointAt(0) && curAlphabet.codePointAt(0) <= tColAlphabet.codePointAt(0) )) {
                                            CellReference ref = new CellReference(rowAlphabet);
                                            Row r = sheet.getRow(ref.getRow());
                                            Cell c = null;
                                            if (r != null) {
                                                c = r.getCell(ref.getCol());
                                            }
                                            
                                            listitemSub.appendChild(doc.createTextNode(c.getStringCellValue()));
                                            listitem.appendChild(listitemSub);
                                            continue;
     
                                        }

                                    }

                                }

                                listitemSub.appendChild(doc.createTextNode(cellTxt));
                                listitem.appendChild(listitemSub);

                            } else {
                                listitemSub.appendChild(doc.createTextNode(cellTxt));
                                listitem.appendChild(listitemSub);
                            }
                            
                        }

                    }

                }

            }

        } catch (Exception e) {
            System.out.println("엑셀 로드 실패");
            e.printStackTrace();
        }
        
        Path tarXML = null;
        
        if (exceltype.equals("othertype")) {
            tarXML = Paths.get(obj.excelXDir + File.separator + fileName.replace(".xlsx", ".xml"));
            obj.excelDBF.add(tarXML.toString());
            
        } else if(exceltype.equals("satisfy")) {
            tarXML = Paths.get(obj.excelXDir + File.separator + "/satisfy" + File.separator + fileName.replace(".xlsx", ".xml"));
        }
        
        exportXML(doc, tarXML);
        
        startRow = 0;
        startCol = 0;
        startColBody = 0;
        firstCellList.clear();
        return tarXML;
    }
    
    public void exportXML(Document doc, Path tarXML) {
        try {
            // Transformer 생성
            TransformerFactory ttf = TransformerFactory.newInstance();
            Transformer tf = ttf.newTransformer();
            tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            tf.setOutputProperty(OutputKeys.INDENT, "yes");
            tf.setOutputProperty(OutputKeys.METHOD, "html");
    
            // DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
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
    
    public static String formatCell(Cell cell) {
        Optional<Cell> op = Optional.ofNullable(cell);
        
        if(!op.isPresent()) {
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
                    return df.format(cell1.getNumericCellValue());
                    
                case STRING:
                    return cell.getStringCellValue();
                    
                default:
                    return "<unknown value>";
            }
        }
    }
    
    public void setStartRowCell() {
        System.out.println("setStartRowCell() 시작");
        
        startRow = 0;
        if (exceltype.equals("othertype")) {
            startRow = 0;
            
        } else if(exceltype.equals("satisfy")) {
            startRow = 5;
        }
        
        startCol = 0;
        if (exceltype.equals("othertype")) {
            startCol = 0;
            
        } else if(exceltype.equals("satisfy")) {
            startCol = 1;
        }
        
        startColBody = 0;
        if (exceltype.equals("othertype")) {
            startColBody = 0;
            
        } else if(exceltype.equals("satisfy")) {
            startColBody = 5;
        }
        
    }
    
}
