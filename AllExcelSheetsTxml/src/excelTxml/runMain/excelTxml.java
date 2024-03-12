package excelTxml.runMain;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
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

public class excelTxml {
    String excelPath = "";
    Path excelP = null;
    String excelName = "";
    static DataFormatter dfm = new DataFormatter();
    static DecimalFormat df = new DecimalFormat("#");
    static public Path crossF = null;


    String mergedCellVal = "";

    int rowNum = 0;
    int colIndex = 0;

    public excelTxml(String path) {
        System.out.println("excelTxml() 시작");
        this.excelPath = path;

        // 엑셀 경로를 Path 객체로 생성
        excelP = Paths.get(excelPath);

        // 엑셀 이름 추출
        excelName = excelP.getFileName().toString();
        System.out.println("excelPath: " + excelPath);
    }


    public void runexcel() throws Exception {
        System.out.println("runexcel 시작");
        
        
        // xml을 저장할 폴더 생성
        Path newPath = createZipFolder(excelP.getParent());
      
        // 엑셀 파일 읽기
        FileInputStream fis = new FileInputStream(excelPath);
        
        // Zip bomb~ 에러발생 방지
        // Workbook 객체를 생성하기 전에 추가 해야 한다.
        ZipSecureFile.setMinInflateRatio(0);
        Workbook wb = WorkbookFactory.create(fis);

        // sheet의 총 개수 파악
        int sheetCnt = wb.getNumberOfSheets();
        System.out.println("sheetCnt: " + sheetCnt);
        int switchModel = 0;

        for (int i = 0; i < sheetCnt; i++) {
            // 새로운 XML DOM 객체  생성
            Document doc = createDOM();

            // root 요소 생성
            Element rootEle = doc.createElement("root");
            rootEle.setAttribute("fileName", excelName);
            doc.appendChild(rootEle);

            // 시트 이름 추출
            String getSheetName = wb.getSheetName(i);
            getSheetName = getSheetName.replace(" ", "_").toLowerCase();
            System.out.println("getSheetName: " + getSheetName);

            List <String> firstCellList = new ArrayList < > ();
            // 시트에 접근
            Sheet sheet = wb.getSheetAt(i);
            String sheetName = sheet.getSheetName();

            // if(sheetName.equals("RED Band Mode") | sheetName.equals("SAR") | sheetName.equals("MEA_Turkish") | sheetName.equals("SEA_Indonesian") | sheetName.equals("Package contents")| sheetName.equals("Device")) {
            if (!sheetName.equals("ddd")) {
                // 시트의 각 행을 Iterator 반복자를 사용하여 각 Row를 하나씩 반복
                Iterator <Row> rowIt = sheet.iterator();

                // 첫번째 row의 셀 개수 할당
                int totalCellCnt = 0;
                /*if (sheetName.equals("RED Band Mode")) {
                    String devModel = sheet.getRow(1).getCell(1).getStringCellValue();
                    String replaceTxt = devModel.replaceAll("[\\s]+", "_");
                    rootEle.setAttribute("devModel", replaceTxt);
                }*/

                int startNum = 0;
                if (sheetName.equals("RED Band Mode")) {
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
                }

                // Device, SEA_Indonesian 시트는 header 가 없음
                if (switchModel == 0) {
                    System.out.println("해드 없음");
                    callNoHeader(rowIt, sheetName, doc, rootEle, sheet);

                }

                // 각 row를 반복
                while (rowIt.hasNext()) {
                    // 각 row를 하나씩 추출
                    Row row = rowIt.next();

                    // Row 의 header 행에서 실질적으로 가지고올 마지막 Cell 위치 지정
                    int lastCell = 0;
                    if (sheetName.equals("RED Band Mode")) {
                        lastCell = 4;
                    } else if (sheetName.equals("SAR")) {
                        lastCell = 3;
                    } else if (sheetName.equals("MEA_Turkish")) {
                        lastCell = 3;
                    } else if (sheetName.equals("Package contents")) {
                        lastCell = 2;
                    }

                    if (switchModel == 1) {
                        if (row.getRowNum() == startNum) {
                            // 시작 column 의 위치 지정
                            int c = 0;
                            if (sheetName.equals("RED Band Mode")) {
                                c = 1;
                            } else if (sheetName.equals("SAR")) {
                                c = 1;
                            } else if (sheetName.equals("MEA_Turkish")) {
                                c = 0;
                            } else if (sheetName.equals("Package contents")) {
                                c = 1;
                            }


                            // 1번째 행의 셀을 한번씩 돌아 셀의 값을 firstCellList 컬렉션에 수집
                            for (; c <= lastCell; c++) {
                                // 첫번째 행의 각 셀의 값 추출
                                Cell firstCell = row.getCell(c);
                                String str1 = formatCell(firstCell);
                                String str2 = str1.replace(" ", "_");
                                String str3 = str2.replaceAll("(\\(.*\\))", "").replaceAll("_$", "");
                                String str4 = str3.replaceAll("[\\(\\)&/]", "");
                                String str5 = str4.replaceAll("(_)+", "_").replaceAll("[\n\r]", "");
                                String str6 = StringEscapeUtils.escapeXml11(str5);
                                System.out.println("str6: " + str6);
                                firstCellList.add(str6);

                            }

                        } else { // row 행 인덱스가 2번째 행이 아닌 경우, 즉 header가 아닌 경우                     
                            // isEmpty() 메소드를 호출하여, row의 전체 셀이 비어 있지 않는 경우
                            // row.getRowNum() > 2 : 2번째 이후의 행에 대해서 for문 진행
                            if (!isEmpty(row) && row.getRowNum() > startNum) {
                                // row 한번씩 돌때마다 cellVal listitem 태그 생성
                                Element listitem = doc.createElement("listitem");
                                rootEle.appendChild(listitem);

                                outter: // 라벨을 사용하여, 병합된 첫번째 셀 작업후, 바로 바깥 for문으로 빠져나오기 위해 사용
                                for (int j = 0; j < lastCell; j++) {
                                    Cell cellVal = null;
                                    String mergedRange = "";
                                    if (sheetName.equals("RED Band Mode")) {
                                        cellVal = row.getCell(j + 1);
                                    } else if (sheetName.equals("SAR")) {
                                        cellVal = row.getCell(j + 1);
                                    } else if (sheetName.equals("MEA_Turkish")) {
                                        cellVal = row.getCell(j);
                                    } else if (sheetName.equals("SEA_Indonesian")) {
                                        cellVal = row.getCell(j + 1);
                                    } else if (sheetName.equals("Package contents")) {
                                        cellVal = row.getCell(j + 1);
                                    }

                                    String cellTxt0 = formatCell(cellVal);
                                    String cellTxt = StringEscapeUtils.escapeXml11(cellTxt0).replaceAll("[\n\r]", "&lt;br/&gt;");
                                    //                                System.out.println("cellTxt: " + cellTxt);

                                    String rowNum0 = String.valueOf(row.getRowNum() + 1);
                                    String colNum0 = String.valueOf(j + 1);
                                    //                                System.out.println("rowNum0: " + rowNum0 + " = " + "colNum0: " + colNum0);

                                    // 한번씩 돌때마다 header 의 각 셀값들로 요소들을 생성
                                    // header 셀의 각 요소들로 태그 생성
                                    Element listitemSub = doc.createElement(firstCellList.get(j).toString());
                                    listitemSub.setAttribute("class", rowNum0 + ":" + colNum0);
                                    listitem.appendChild(listitemSub);


                                    // Cell 값이 null이 아닌 경우
                                    if (cellVal != null) {
                                        // getNumMergedRegions(): '시트내 모든 병합'된 영역의 개수를 반환
                                        for (int k = 0; k < sheet.getNumMergedRegions(); k++) {
                                            // getMergedRegion(): 한번씩 반복될 때마다, '시트 전체 영역 내에서 찾은' 병합된 영역의 행과 열 인데스 반환  
                                            CellRangeAddress region = sheet.getMergedRegion(k);

                                            // formatAsString(): 병합된 영역의 위치의 행과열을 반환 받기
                                            // [B3:B5] 형태로 반환 됨
                                            mergedRange = region.formatAsString();
                                            String[] arrays = mergedRange.split(":");
                                            
                                            // getFirstRow(): 병합된 영역에서 첫번째 행의 왼쪽 행 번호 반환
                                            // getFirstColumn(): 병합된 영역에서 첫번째 Cell의 상단 열번호 반환
                                            rowNum = region.getFirstRow();
                                            colIndex = region.getFirstColumn();
                                            // System.out.println("eee: " + colIndex);
                                            // 병합된 영역의 첫번째 Cell 인지 확인 하는 if문
                                            // 확인 하는 이유는, 병합된 셀의 데이터는 항상 첫번째 Cell에 채워져 있다.
                                            // 만약, 병합된 영역의 첫번째 cell인 경우, 해당셀의 값을 전역 변수 mergedCellVal에 할당하여,
                                            // 병합된 영역의 첫번째 셀이 아닌 cell들일 경우 해당 값을 삽입하기 위해 사용 
                                            if (rowNum == cellVal.getRowIndex() && colIndex == cellVal.getColumnIndex()) {
                                                // 병합된 셀의 첫번째 셀인 경우 값 추출
                                                String getCellVal = sheet.getRow(rowNum).getCell(colIndex).getStringCellValue();
                                                mergedCellVal = StringEscapeUtils.escapeXml11(getCellVal);
                                                // System.out.println("mergedCellVal: " + mergedCellVal);
                                                listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                                listitem.appendChild(listitemSub);

                                                // continue outer; 없을 경우, 다음 for문을 돌기 때문에 빠져 나와야 한다.
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

                                            System.out.println("curAddr: " + curAddr);
                                            
                                            list.forEach(a -> {
                                               System.out.println("list: " + a); 
                                            });
                                            
                                            for (int t = 0; t < list.size(); t++) {
                                                String[] arrays = list.get(t).split(":");
                                                                                              // replaceAll() 메소드로 정규식을 이용하여, 현재 column의 셀 알파벳 뽑아 내기
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
//                                                            System.out.println("curRowNum: " + curRowNum);
//                                                            System.out.println("tRowNum: " + tRowNum);
//                                                            System.out.println("aaa: " + list.get(t));
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

                                        // 병합된 cell이 아닌 (1행:1열)로 생성된 cell 일 경우
                                        listitemSub.appendChild(doc.createTextNode(cellTxt));
                                        listitem.appendChild(listitemSub);

                                    } else {
                                        // cellVal이 null일 경우 else문이 없다면, <Tag /> 형태로 출력된다.
                                        // <Tag></Tag> 형태로 출력 하기 위해서 하기 구문 추가
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
                Path tarXML = Paths.get(excelP.getParent() + "/specSample/" + getSheetName + ".xml");
                exportXML(doc, tarXML);

            }

        }

        System.out.println("excel To xml 변환 완료!!");

    }
    
    public Path createZipFolder(Path newDirs) throws Exception {
        String newDir = newDirs + "/specSample";
        Path newPath = Paths.get(newDir);
        
        if(Files.notExists(newPath)) {
            Files.createDirectories(newPath);
            System.out.println("폴더 생성 완료!");
            
        } else {  // 폴더가 존재 한다면 재귀적 삭제 후, 폴더 재생성
            recursDel(newPath);
            Files.createDirectories(newPath);
        }
        
        return newPath;
    }
    
    public void recursDel(Path toPath) {
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(toPath);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {
                    recursDel(a);
                    
                } else {
                    try {
                        Files.delete(a);
                        
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                
            });
            
            Files.delete(toPath);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void callNoHeader(Iterator < Row > rowIt, String sheetName, Document doc, Element rootEle, Sheet sheet) {
        int curRow = 0;
        int lastRow = 0;
        if (sheetName.equals("SEA_Indonesian")) {
            lastRow = 1;
        } else if (sheetName.equals("Device")) {
            lastRow = 3;
        }

        while (rowIt.hasNext()) {
            // 각 row를 하나씩 추출
            Row row = rowIt.next();
            String mergedCellVal = "";
            //      System.out.println("lastRow: " + curRow);
            if (curRow < lastRow) {

                int r = 0;

                List <String> firstCellList = new ArrayList < > ();

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
                        System.out.println("str6: " + str6);
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
                            System.out.println("cellTxt: " + cellTxt);

                            rowNum0 = String.valueOf(row.getRowNum() + 1);
                            colNum0 = String.valueOf(c + 1);
                            //                  System.out.println(rowNum0 + ":" + colNum0);

                            Element listitemSub = doc.createElement(firstCellList.get(r).toString());
                            listitemSub.setAttribute("class", rowNum0 + ":" + colNum0);
                            listitem.appendChild(listitemSub);
                            r++;
                            if (cellVal != null) {
                                // getNumMergedRegions(): '시트내 모든 병합'된 영역의 개수를 반환
                                for (int k = 0; k < sheet.getNumMergedRegions(); k++) {
                                    // getMergedRegion(): 한번씩 반복될 때마다, '시트 전체 영역 내에서 찾은' 병합된 영역의 행과 열 인데스 반환  
                                    CellRangeAddress region = sheet.getMergedRegion(k);

                                    // getFirstRow(): 병합된 영역에서 첫번째 행의 왼쪽 행 번호 반환
                                    // getFirstColumn(): 병합된 영역에서 첫번째 Cell의 상단 열번호 반환
                                    int rowNum = region.getFirstRow();
                                    int colIndex = region.getFirstColumn();

                                    // 병합된 영역의 첫번째 Cell 인지 확인 하는 if문
                                    // 확인 하는 이유는, 병합된 셀의 데이터는 항상 첫번째 Cell에 채워져 있다.
                                    // 만약, 병합된 영역의 첫번째 cell인 경우, 해당셀의 값을 전역 변수 mergedCellVal에 할당하여,
                                    // 병합된 영역의 첫번째 셀이 아닌 cell들일 경우 해당 값을 삽입하기 위해 사용 
                                    if (rowNum == cellVal.getRowIndex() && colIndex == cellVal.getColumnIndex()) {
                                        // 병합된 셀의 첫번째 셀인 경우 값 추출
                                        String getCellVal = sheet.getRow(rowNum).getCell(colIndex).getStringCellValue();
                                        mergedCellVal = StringEscapeUtils.escapeXml11(getCellVal);

                                        listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                        listitem.appendChild(listitemSub);

                                        // continue outer; 없을 경우, 다음 for문을 돌기 때문에 빠져 나와야 한다.
                                        continue outter1;
                                    }
                                }

                                // BLANK, null이라는 의미는 병합된 첫번째 Cell이 아닌 나머지 인덱스 위치의 셀을 의미한다
                                if (cellVal.getCellType() == CellType.BLANK || cellVal == null) {
                                    // 병합된 첫번째 cell에서 추출한 값을 병합된 셀에서 가져와 사용
                                    listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                    listitem.appendChild(listitemSub);

                                    continue;
                                }
                                // 병합된 cell이 아닌 (1행:1열)로 생성된 cell 일 경우
                                listitemSub.appendChild(doc.createTextNode(cellTxt));
                                listitem.appendChild(listitemSub);
                            } else {
                                // cellVal이 null일 경우 else문이 없다면, <Tag /> 형태로 출력된다.
                                // <Tag></Tag> 형태로 출력 하기 위해서 하기 구문 추가
                                listitemSub.appendChild(doc.createTextNode(cellTxt));
                                listitem.appendChild(listitemSub);
                            }

                        }

                    }

                }
            }
        }
    }

    public Document createDOM() throws Exception {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();

        Document doc = db.newDocument();
        doc.setXmlStandalone(true);

        return doc;
    }

    public void exportXML(Document doc, Path tarXML) {
        System.out.println("exportXML 시작");
        try {
            // Transformer 생성
            TransformerFactory ttf = TransformerFactory.newInstance();
            Transformer tf = ttf.newTransformer();

            // 출력 속성 설정
            tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            tf.setOutputProperty(OutputKeys.INDENT, "yes");
            tf.setOutputProperty(OutputKeys.METHOD, "xml");
            tf.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");


            // DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);

            // 출력결과를 스트림으로 생성
            StreamResult result = new StreamResult(tarXML.toUri().toString());

            tf.transform(source, result);
            result.getOutputStream().close();

        } catch (Exception e1) {
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

}