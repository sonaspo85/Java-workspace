package main.java.zipController.excel2xml;

import java.io.FileInputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
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

public class spec2xml {
    String excelPath = "";
    Path excelP = null;
    String excelName = "";
    static DataFormatter dfm = new DataFormatter();
    static DecimalFormat df = new DecimalFormat("#");
    static public Path crossF = null;
    String sheetName = "";
    String mergedCellVal = "";
    String spec2xmlDir = "";
    String msg = "";
    
    int rowNum = 0;
    int colIndex = 0;
    
    implementOBJ obj = new implementOBJ();

    public spec2xml(String path) {
        System.out.println("excelTxml() 시작");
        this.excelPath = path;
        excelP = Paths.get(excelPath);

        // 엑셀 이름 추출
        excelName = excelP.getFileName().toString();
        System.out.println("excelPath: " + excelPath);
    }


    public String runexcel() throws Exception {
        createNewFolder();
        
        // 엑셀 파일 로드
        FileInputStream fis = new FileInputStream(excelPath);
        ZipSecureFile.setMinInflateRatio(0);
        Workbook wb = WorkbookFactory.create(fis);

        // sheet의 총 개수 파악
        int sheetCnt = wb.getNumberOfSheets();
        System.out.println("sheetCnt: " + sheetCnt);
        int switchModel = 0;

        for (int i = 0; i < sheetCnt; i++) {
            Document doc = createDOM();

            // root 요소 생성
            Element rootEle = doc.createElement("root");
            doc.appendChild(rootEle);

            // 시트 이름 추출
            String getSheetName = wb.getSheetName(i);
            getSheetName = getSheetName.replace(" ", "_").toLowerCase();

            List<String> firstCellList = new ArrayList<>();
            Sheet sheet = wb.getSheetAt(i);
            sheetName = sheet.getSheetName();
            rootEle.setAttribute("fileName", sheetName);
            
            if (!sheetName.equals("aaa")) {
                Iterator<Row> rowIt = sheet.iterator();

                int startNum = 0;
                switchModel = 1;
                Row headerRow = sheet.getRow(0);
                int headerCellCnt = headerRow.getLastCellNum() - 1;
                
                List<String> columnAtt = new ArrayList<>();
                int cnt = 0;

                // 첫번째 column 의 셀값들을 속성값으로 사용
                Iterator<Row> rowIt0 = sheet.iterator();
                while (rowIt0.hasNext()) {
                    Row row = rowIt0.next();
                    
                    int lastCell = 0;
                    
                    if (row.getRowNum() > 0) {
                        cnt++;
                        for (int y=0; y<=lastCell; y++) {
                            Cell firstCell = row.getCell(y);
                            String str1 = formatCell(firstCell);
                            columnAtt.add(str1);
                        }
                        
                    }
                        
                }
                
                columnAtt = columnAtt.stream().filter(a -> !a.isEmpty()).collect(Collectors.toList());
                
                // 각 row를 반복
                while (rowIt.hasNext()) {
                    // 각 row를 하나씩 추출
                    Row row = rowIt.next();
                    int lastCell = 0;
                    lastCell = headerCellCnt;

                    if (switchModel == 1) {
                        if (row.getRowNum() == startNum) {
                            int c = 1;
                            
                            for (; c <= lastCell; c++) {
                                // 첫번째 행의 각 셀의 값 추출
                                Cell firstCell = row.getCell(c);
                                String str1 = formatCell(firstCell);
                                String str2 = str1.trim();
                                String str3 = str2.replaceAll("[\\(\\)]", "_");
                                String str6 = StringEscapeUtils.escapeXml11(str3);
                                firstCellList.add(str6);
                                
                            }
                            
                        } 
                        else {                     
                            if (!isEmpty(row) && row.getRowNum() > startNum) {
                                Element listitem = doc.createElement("listitem");
                                int rowNum = row.getRowNum();
                                String getAttr = setAttr(rowNum, columnAtt);
                                
                                listitem.setAttribute("class", getAttr);
                                rootEle.appendChild(listitem);

                                outter:
                                for (int j = 0; j < lastCell; j++) {
                                    Cell cellVal = null;
                                    String mergedRange = "";
                                    
                                    cellVal = row.getCell(j + 1);

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
                                            
                                            List <String> list = new ArrayList<>(); 
                                            
                                            for (int u = 0; u < sheet.getNumMergedRegions(); u++) {
                                                CellRangeAddress region = sheet.getMergedRegion(u);
                                                String checkedRange = region.formatAsString();

                                                list.add(checkedRange);
                                            }

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
                Path tarXML = Paths.get(obj.srcDir + "/temp/spec2xmlData/" + getSheetName + ".xml");
                exportXML(doc, tarXML);
                
                if(spec2xmlDir.equals("")) {
                    spec2xmlDir = tarXML.getParent().toString();
                }
            }

        }
        
        return spec2xmlDir;
    }

    public Document createDOM() throws Exception {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();

        Document doc = db.newDocument();
        doc.setXmlStandalone(true);

        return doc;
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
            msg = "spec2xml-data.xls to xml 변환 실패";
            throw new Exception(msg);
            
        }

    }

    public boolean isEmpty(Row row) {
        // 셀 개수 파악
        int cellCnt = row.getPhysicalNumberOfCells();

        String str = "";

        for (int c = 1; c <= cellCnt; c++) {
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
    
    public String setAttr(int rowNum, List<String> columnAtt) {
        String getVal = "";

        if(sheetName.equals("Package-contents") | sheetName.contains("Band-mode") | sheetName.equals("INDIA-BIS") | sheetName.equals("opensource") | sheetName.equals("Green issue")) {
            getVal = columnAtt.get(0);
            
        } else if(sheetName.equals("SAR")) {
            if(rowNum>=1 && rowNum<=5) {
                getVal = columnAtt.get(0);
                        
            } else if(rowNum>=6 && rowNum<=7) {
                getVal = columnAtt.get(1);
                
            } else if(rowNum == 8) {
                getVal = columnAtt.get(2);
                
            } else if(rowNum == 9) {
                getVal = columnAtt.get(3);
            } else if(rowNum == 10) {
                getVal = columnAtt.get(4);
            }
            
        } else if(sheetName.equals("unit")) {
            if(rowNum==1) {
                getVal = columnAtt.get(0);
                        
            } else if(rowNum==2) {
                getVal = columnAtt.get(1);
                
            } else if(rowNum>=3 && rowNum<=11) {
                getVal = columnAtt.get(2);
                
            }
            
        } else if(sheetName.equals("Fingerprint-sensor")) {
            if(rowNum==1) {
                getVal = columnAtt.get(0);
                        
            } else if(rowNum==2) {
                getVal = columnAtt.get(1);
            }
        } else if(sheetName.equals("Charging-support")) {
            if(rowNum==1) {
                getVal = columnAtt.get(0);
                        
            } else if(rowNum==2) {
                getVal = columnAtt.get(1);
                
            } else if(rowNum==3) {
                getVal = columnAtt.get(2);
                
            } else if(rowNum==4) {
                getVal = columnAtt.get(3);
            }
            
        } else if(sheetName.equals("Safety-info")) {
            if(rowNum==1) {
                getVal = columnAtt.get(0);
                        
            } else if(rowNum==2) {
                getVal = columnAtt.get(1);
            }
            
        } else if(sheetName.equals("PO-BOX")) {
            if(rowNum==1) {
                getVal = columnAtt.get(0);
                
            } else if(rowNum==2) {
                getVal = columnAtt.get(1);
            }
        } else if(sheetName.equals("e-DoC")) {
            if(rowNum==1) {
                getVal = columnAtt.get(0);
                        
            } else if(rowNum==2) {
                getVal = columnAtt.get(1);
                
            } else if(rowNum==3) {
                getVal = columnAtt.get(2);
                
            } else if(rowNum==4) {
                getVal = columnAtt.get(3);
            }
            
        } else if(sheetName.equals("WLAN")) {
            if(rowNum==1) {
                getVal = columnAtt.get(0);
                        
            } else if(rowNum==2) {
                getVal = columnAtt.get(1);
                
            } else if(rowNum==3) {
                getVal = columnAtt.get(2);
                
            } else if(rowNum==4) {
                getVal = columnAtt.get(3);
                
            } 
            
        }
        
        return getVal;
        
    }
    
    public void createNewFolder() throws Exception {
        String newDir = obj.srcDir + "/temp/spec2xmlData";
        Path newPath = Paths.get(newDir);
        
        try {
            obj.createNewDir(newPath);
            
        } catch(Exception e1) {
            msg = "/temp/spec2xmlData 폴더 생성 실패";
            throw new Exception(msg);
        }
                
    }

}
