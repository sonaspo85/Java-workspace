package main.java.zipController.excel2xml;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.text.StringEscapeUtils;
import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import main.java.zipController.Common.implementOBJ;

public class specsample {
    String msg = "";
    String excelPath = "";
    Path excelP = null;
    String excelName = "";
    static DataFormatter dfm = new DataFormatter();
    static DecimalFormat df = new DecimalFormat("###.###");
    static public Path crossF = null;
    implementOBJ obj = new implementOBJ();

    String mergedCellVal = "";

    int rowNum = 0;
    int colIndex = 0;

    public specsample(String path) { 
        this.excelPath = path;
        excelP = Paths.get(excelPath);

        // 엑셀 이름 추출
        excelName = excelP.getFileName().toString();
        System.out.println("excelPath: " + excelPath);
    }


    public String runexcel() throws Exception {
        try {
            Path newPath = createFolder(excelP.getParent());
            
        } catch (Exception e) {
            msg = "SPEC_Sample to xml 저장 폴더 생성 실패";
            throw new Exception(msg);
        }
      
        // 엑셀 파일 읽기
        FileInputStream fis;
        try {
            fis = new FileInputStream(excelPath);
            
        } catch (FileNotFoundException e) {
            msg = "SPEC_Sample 엑셀 파일 읽기 실패";
            throw new Exception(msg);
        }
        
        try {
            ZipSecureFile.setMinInflateRatio(0);
            Workbook wb = WorkbookFactory.create(fis);

            // sheet의 총 개수 파악
            int sheetCnt = wb.getNumberOfSheets();
            int switchModel = 0;

            for (int i = 0; i < sheetCnt; i++) {
                // 새로운 XML DOM 객체  생성
                Document doc = obj.createDOM();

                // root 요소 생성
                Element rootEle = doc.createElement("root");
                rootEle.setAttribute("fileName", excelName);
                doc.appendChild(rootEle);

                String getSheetName = wb.getSheetName(i);
                getSheetName = getSheetName.replace(" ", "_").toLowerCase();

                List <String> firstCellList = new ArrayList <>();
                Sheet sheet = wb.getSheetAt(i);
                String sheetName = sheet.getSheetName();

                if (!sheetName.equals("aaa")) {
                    Iterator <Row> rowIt = sheet.iterator();

                    int startNum = 0;
                    if (sheetName.contains("RED Band Mode")) {
                        startNum = 2;
                        switchModel = 1;
                        
                    } else if (sheetName.equals("SAR")) {
                        startNum = 1;
                        switchModel = 1;
                        
                    } else if (sheetName.equals("MEA_Turkish")) {
                        startNum = 3;
                        switchModel = 1;
                        
                    } else if (sheetName.equals("SEA_Indonesian")) {
                        switchModel = 0;
                        
                    } else if (sheetName.equals("Package contents")) {
                        startNum = 1;
                        switchModel = 1;
                        
                    } else if (sheetName.equals("Device")) {
                        switchModel = 0;
                        
                    } else if (sheetName.equals("Charging_support")) {
                        startNum = 1;
                        switchModel = 1;
                    }

                    if (switchModel == 0) {
                        callNoHeader(rowIt, sheetName, doc, rootEle, sheet);
                    }

                    // 각 row를 반복
                    while (rowIt.hasNext()) {
                        // 각 row를 하나씩 추출
                        Row row = rowIt.next();
                        int lastCell = 0;
                        
                        if (sheetName.contains("RED Band Mode")) {
                            lastCell = 4;
                            
                        } else if (sheetName.equals("SAR")) {
                            lastCell = 3;
                            
                        } else if (sheetName.equals("MEA_Turkish")) {
                            lastCell = 3;
                            
                        } else if (sheetName.equals("Package contents")) {
                            lastCell = 2;
                            
                        } else if (sheetName.equals("Charging_support")) {
                            lastCell = 3;
                        }

                        if (switchModel == 1) {
                            if (row.getRowNum() == startNum) {
                                // 시작 column 의 위치 지정
                                int c = 0;
                                if (sheetName.contains("RED Band Mode")) {
                                    c = 1;
                                    
                                } else if (sheetName.equals("SAR")) {
                                    c = 1;
                                    
                                } else if (sheetName.equals("MEA_Turkish")) {
                                    c = 0;
                                    
                                } else if (sheetName.equals("Package contents")) {
                                    c = 1;
                                    
                                } else if (sheetName.equals("Charging_support")) {
                                    c = 1;
                                    
                                } 

                                for (; c <= lastCell; c++) {
                                    Cell firstCell = row.getCell(c);
                                    String str1 = formatCell(firstCell);
                                    String str2 = str1.replace(" ", "_");
                                    String str3 = str2.replaceAll("(\\(.*\\))", "").replaceAll("_$", "");
                                    String str4 = str3.replaceAll("[\\(\\)&/]", "");
                                    String str5 = str4.replaceAll("(_)+", "_").replaceAll("[\n\r]", "");
                                    String str6 = StringEscapeUtils.escapeXml11(str5);
                                    firstCellList.add(str6);
                                }

                            } else {                     
                                if (!isEmpty(row) && row.getRowNum() > startNum) {
                                    Element listitem = doc.createElement("listitem");
                                    rootEle.appendChild(listitem);

                                    outter:
                                    for (int j = 0; j < lastCell; j++) {
                                        Cell cellVal = null;
                                        String mergedRange = "";
                                        if (sheetName.contains("RED Band Mode")) {
                                            cellVal = row.getCell(j + 1);
                                            
                                        } else if (sheetName.equals("SAR")) {
                                            cellVal = row.getCell(j + 1);
                                            
                                        } else if (sheetName.equals("MEA_Turkish")) {
                                            cellVal = row.getCell(j);
                                            
                                        } else if (sheetName.equals("SEA_Indonesian")) {
                                            cellVal = row.getCell(j + 1);
                                            
                                        } else if (sheetName.equals("Package contents")) {
                                            cellVal = row.getCell(j + 1);
                                            
                                        } else if (sheetName.equals("Charging_support")) {
                                            cellVal = row.getCell(j + 1);
                                        }

                                        String cellTxt0 = formatCell(cellVal);
                                        String cellTxt = StringEscapeUtils.escapeXml11(cellTxt0).replaceAll("[\n\r]", "&lt;br/&gt;");
                                        String rowNum0 = String.valueOf(row.getRowNum() + 1);
                                        String colNum0 = String.valueOf(j + 1);

                                        // header 셀의 각 요소들로 태그 생성
                                        Element listitemSub = doc.createElement(firstCellList.get(j).toString());
                                        listitemSub.setAttribute("class", rowNum0 + ":" + colNum0);
                                        listitem.appendChild(listitemSub);

                                        // Cell 값이 null이 아닌 경우
                                        if (cellVal != null) {
                                            for (int k = 0; k < sheet.getNumMergedRegions(); k++) {  
                                                CellRangeAddress region = sheet.getMergedRegion(k);
                                                mergedRange = region.formatAsString();
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

                                                List <String> list = new ArrayList <>();
                                                // 시트내 병합된 영역을 모두 찾아 list 컬렉션에 저장 
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

                                                    String colAlphabet = arrays[1];
                                                    String tColAlphabet = colAlphabet.replaceAll(("(\\d+)"), "");
                                                    int tColNum = Integer.valueOf(colAlphabet.replaceAll(("([a-zA-Z])"), ""));
                                                    
                                                    // rowspan인 경우
                                                    if (curAlphabet.equals(tRowAlphabet)) {
                                                        
                                                        if (curAlphabet.equals(tColAlphabet)) {
                                                            if (curRowNum > tRowNum & curRowNum <= tColNum) {
                                                                listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                                                listitem.appendChild(listitemSub);

                                                                continue;
                                                            }

                                                        }

                                                    }

                                                    // colspan인 경우
                                                    else if (curRowNum == tRowNum) {
                                                        if (curRowNum == tColNum) {
                                                            if (curAlphabet.codePointAt(0) > tRowAlphabet.codePointAt(0) & curAlphabet.codePointAt(0) <= tColAlphabet.codePointAt(0)) {
                                                                System.out.println("bbb: " + list.get(t));
                                                                listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                                                listitem.appendChild(listitemSub);
                                                                continue;
                                                            }

                                                        }

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

                    }
                                    
                    System.out.println("xml로 저장");
                    // excel을 xml 로 변환 추출
                    Path tarXML = Paths.get(obj.srcDir + "/temp/specSample/" + getSheetName + ".xml");
                    exportXML(doc, tarXML);

                }

            }
            
        } catch(Exception e) {
            msg = "excelTxml 객체 에러";
            throw new Exception(msg);
        }

        return obj.srcDir + "/temp/specSample";
    }
    
    public Path createFolder(Path newDirs) throws Exception {
        String newDir = obj.srcDir + "/temp/specSample";
        Path newPath = Paths.get(newDir);
        obj.createNewDir(newPath);
        
        return newPath;
    }
    
    // header row가 없는 시트인 경우
    public void callNoHeader(Iterator<Row> rowIt, String sheetName, Document doc, Element rootEle, Sheet sheet) {
        System.out.println("callNoHeader() 시작");
        int curRow = 0;
        int lastRow = 0;
        
        int pos = 0;
        Iterator <Row> rowIt2 = sheet.iterator();

        // row의 첫번째 셀이 값이 채워져 있는 셀의 개수 구하기
        try {
            while (rowIt2.hasNext()) {
                Row row2 = rowIt.next();
                Cell firstCell = row2.getCell(1);
                
                if(firstCell != null) {
                    if(firstCell.getStringCellValue().length() > 1) {
                        pos++;
                    }
                }

            }
        } catch(Exception e) {
        }

        if (sheetName.equals("SEA_Indonesian")) {
            lastRow = pos;
            
        } else if (sheetName.equals("Device")) {
            lastRow = pos;

        }

        rowIt = sheet.iterator();
        while (rowIt.hasNext()) {
            // 각 row를 하나씩 추출
            Row row = rowIt.next();
            String mergedCellVal = "";
            
            if (curRow < lastRow) {
                int r = 0;
                List<String> firstCellList = new ArrayList<>();

                int c = 0;
                int lastCell = 0;
                if (sheetName.equals("SEA_Indonesian")) {
                    lastCell = 2;
                    
                } else if (sheetName.equals("Device")) {
                    lastCell = 2;
                    
                }

                outter1:
                for (; c <= lastCell; c++) {
                    if (c == 1) {
                        Cell firstCell = row.getCell(1);
                        String getCellVal = firstCell.getStringCellValue();
                        String str1 = formatCell(firstCell);
                        String str2 = str1.replace(" ", "_");
                        String str3 = str2.replaceAll("(\\(.*\\))", "").replaceAll("_$", "");
                        String str4 = str3.replaceAll("[\\(\\)&/]", "");
                        String str5 = str4.replaceAll("(_)+", "_").replaceAll("[\n\r]", "");
                        String str6 = StringEscapeUtils.escapeXml11(str5);
                        firstCellList.add(str6);
                        curRow++;

                    } else {
                        Cell cellVal = null;

                        Element listitem = null;
                        String cellTxt = "";
                        String rowNum0 = "";
                        String colNum0 = "";

                        if (c == 2) {
                            listitem = doc.createElement("listitem");
                            rootEle.appendChild(listitem);

                            cellVal = row.getCell(c);
                            String cellTxt0 = formatCell(cellVal);
                            cellTxt = StringEscapeUtils.escapeXml11(cellTxt0).replaceAll("[\n\r]", "&lt;br/&gt;");

                            rowNum0 = String.valueOf(row.getRowNum() + 1);
                            colNum0 = String.valueOf(c + 1);
                            Element listitemSub = doc.createElement(firstCellList.get(r).toString());
                            listitemSub.setAttribute("class", rowNum0 + ":" + colNum0);
                            listitem.appendChild(listitemSub);
                            r++;
                            
                            if (cellVal != null) {
                                for (int k = 0; k < sheet.getNumMergedRegions(); k++) {  
                                    CellRangeAddress region = sheet.getMergedRegion(k);
                                    int rowNum = region.getFirstRow();
                                    int colIndex = region.getFirstColumn();

                                    // 병합된 영역의 첫번째 Cell 인지 확인 하는 if문 
                                    if (rowNum == cellVal.getRowIndex() && colIndex == cellVal.getColumnIndex()) {
                                        // 병합된 셀의 첫번째 셀인 경우 값 추출
                                        String getCellVal = sheet.getRow(rowNum).getCell(colIndex).getStringCellValue();
                                        mergedCellVal = StringEscapeUtils.escapeXml11(getCellVal);
                                        listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                        listitem.appendChild(listitemSub);

                                        continue outter1;
                                    }
                                }

                                if (cellVal.getCellType() == CellType.BLANK || cellVal == null) {
                                    listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                    listitem.appendChild(listitemSub);

                                    continue;
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
        }
    }

    public void exportXML(Document doc, Path tarXML) throws Exception {
        System.out.println("exportXML 시작");
        try {
            // Transformer 생성
            TransformerFactory ttf = TransformerFactory.newInstance();
            Transformer tf = ttf.newTransformer();
            tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            tf.setOutputProperty(OutputKeys.INDENT, "yes");
            tf.setOutputProperty(OutputKeys.METHOD, "xml");
            tf.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");

            // DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(tarXML.toUri().toString());

            tf.transform(source, result);
            result.getOutputStream().close();

        } catch (Exception e1) {
            String msg = "excelTxml.exportXML() 오류";
            throw new Exception(msg);
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

        Optional <String> op = Optional.ofNullable(str);
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
        Optional <Cell> op = Optional.ofNullable(cell);

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

}