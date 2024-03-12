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
        System.out.println("excelPath: " + excelPath);
        
        fileName = new File(path).getName();
        
        this.exceltype = exceltype;
    }
    
    public Path runexcel() throws Exception {
        System.out.println("runexcel() 시작");
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
//            Sheet sheet = wb.getSheet("Sheet1");
            System.out.println("이름: " + sheet.getSheetName());
            
            // 가중치 구하기
            String percent = sheet.getRow(4).getCell(2).toString();
                    
            rootEle.setAttribute("percentage", percent);
            
            // 시트의 각 행을 Iterator 반복자를 사용하여 각 Row를 하나씩 반복
            Iterator <Row> rowIt = sheet.iterator();

            // 첫번째 row의 총 Cell 개수 할당
            int totalCellCnt = 0;
            
            // 시트마다 Row와 Cell의 시작 지점 설정
            setStartRowCell();
            
            // 각 row를 반복 
            while (rowIt.hasNext()) {
                // 각 row 하나씩 추출
                Row row = rowIt.next();
                
                // 엑셀에서 header 행이 4인경우 
                if (row.getRowNum() == startRow) {
                    // getPhysicalNumberOfCells() : 실제 셀에 값이 있는 경우의 셀 개수 반환
                    
                    if (exceltype.equals("othertype")) {
                        totalCellCnt = row.getPhysicalNumberOfCells();
                        
                    } else if(exceltype.equals("satisfy")) {
                        totalCellCnt = row.getPhysicalNumberOfCells() + 1;
                    }
                    
                    // 8번째 행의 셀을 한번씩 돌아 셀의 값을 firstCellList 컬렉션에 수집
                    for(int c=startCol; c<=totalCellCnt; c++) {
                        // 첫번째 행의 각 셀의 값 추출 
                        Cell firstCell = row.getCell(c);
                        
                        if(exceltype.equals("satisfy") && c == 1) {
                            
                            firstCell.setCellValue("항목");
                        }
                        
                        String str1 = formatCell(firstCell);
                        String str2 = str1.replace(" ", "_");
                        String str3 = str2.replaceAll("[\\(\\)]", "");
                        String str4 = StringEscapeUtils.escapeHtml4(str3);
                        
//                        System.out.println("str4: " + str4);
                        firstCellList.add(str4);
                    }
                    
                } 
                
                else {  // row 행 인덱스가 2번째 행이 아닌 경우, 즉 header가 아닌 경우                     
                        // isEmpty() 메소드를 호출하여, row의 전체 셀이 비어 있지 않는 경우
                        // row.getRowNum() > 2 : 2번째 이후의 행에 대해서 for문 진행
                    
                    if (!isEmpty(row) && row.getRowNum() > startColBody && 
                            row.getRowNum() < 20) {
                        // row 한번씩 돌때마다 cellVal listitem 태그 생성
                        Element listitem = doc.createElement("listitem");
                        rootEle.appendChild(listitem);

                        outter: // 라벨을 사용하여, 병합된 첫번째 셀 작업후, 바로 바깥 for문으로 빠져나오기 위해 사용
                        for (int j=startCol; j<totalCellCnt; j++) {
//                            System.out.println("j: " + j);
//                            System.out.println("totalCellCnt: " + totalCellCnt);
                            Cell cellVal = row.getCell(j);
                            String mergedRange = "";
                            
                            String cellTxt0 = formatCell(cellVal);
//                            System.out.println("cellTxt000: " + cellTxt0);
                            
                            
                            String cellTxt = StringEscapeUtils.escapeXml11(cellTxt0).replaceAll("[\n\r]", "&lt;br/&gt;");

                            String rowNum0 = String.valueOf(row.getRowNum() + 1);
                            String colNum0 = String.valueOf(j + 1);
                            // System.out.println("rowNum0: " + rowNum0 + " = " + "colNum0: " + colNum0);

                            // 한번씩 돌때마다 header 의 각 셀값들로 요소들을 생성
                            // header 셀의 각 요소들로 태그 생성
                            
                            Element listitemSub = null;
                            
                            if (exceltype.equals("othertype")) {
                                listitemSub = doc.createElement(firstCellList.get(j).toString());
                                
                            } else if(exceltype.equals("satisfy")) {
//                                System.out.println("jjj: " + j);
                                listitemSub = doc.createElement(firstCellList.get(j-1).toString());
                            }
                            
                            
                            listitemSub.setAttribute("class", rowNum0 + ":" + colNum0);
                            listitem.appendChild(listitemSub);
                            
                            // Cell 값이 null이 아닌 경우
                            if (cellVal != null) {
                                // getNumMergedRegions(): '시트내 모든 병합'된 영역의 개수를 반환
                                for (int k=0; k<sheet.getNumMergedRegions(); k++) {
                                    // getMergedRegion(): 한번씩 반복될 때마다, '시트 전체 영역 내에서 찾은' 병합된 영역의 행과 열 인데스 반환  
                                    CellRangeAddress region = sheet.getMergedRegion(k);

                                    // formatAsString(): 병합된 영역의 위치의 행과열을 반환 받기
                                    // [B3:B5] 형태로 반환 됨
                                    mergedRange = region.formatAsString();
//                                    String[] arrays = mergedRange.split(":");
                                    
                                    // getFirstRow(): 병합된 영역에서 첫번째 행의 왼쪽 행 번호 반환
                                    // getFirstColumn(): 병합된 영역에서 첫번째 Cell의 상단 열번호 반환
                                    rowNum = region.getFirstRow();
                                    colIndex = region.getFirstColumn();
                                    
                                    // 병합된 영역의 첫번째 Cell 인지 확인 하는 if문
                                    // 확인 하는 이유는, 병합된 셀의 데이터는 항상 첫번째 Cell에 채워져 있다.
                                    // 만약, 병합된 영역의 첫번째 cell인 경우, 해당셀의 값을 전역 변수 mergedCellVal에 할당하여,
                                    // 병합된 영역의 첫번째 셀이 아닌 cell들일 경우 해당 값을 삽입하기 위해 사용 
                                    if (rowNum == cellVal.getRowIndex() && colIndex == cellVal.getColumnIndex()) {
                                        // 병합된 셀의 첫번째 셀인 경우 값 추출
                                        String getCellVal = sheet.getRow(rowNum).getCell(colIndex).getStringCellValue();
//                                        String mergedCellVal = "";
                                        
                                        mergedCellVal = StringEscapeUtils.escapeXml11(getCellVal);
                                         System.out.println("mergedCellVal: " + mergedCellVal);
                                        
                                        listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                        listitem.appendChild(listitemSub);

                                        // continue outer; 없을 경우, 다음 for문을 돌기 때문에 빠져 나와야 한다.
                                        continue outter;
                                    }

                                }

                                // BLANK, null이라는 의미는 병합된 첫번째 Cell이 아닌 나머지 인덱스 위치의 셀을 의미한다
                                if (cellVal.getCellType() == CellType.BLANK || cellVal == null) {
                                    int curRow = cellVal.getRowIndex();
                                    int curColumn = cellVal.getColumnIndex();
                                    String curAddr = cellVal.getAddress().formatAsString();
                                    String curAlphabet = curAddr.replaceAll(("(\\d+)"), "");
                                    
                                    int curRowNum = Integer.valueOf(curAddr.replaceAll(("([a-zA-Z])"), ""));

                                    List <String> list = new ArrayList<>();
                                    // 시트내 병합된 영역을 모두 찾아 list 컬렉션에 저장 
                                    for (int u = 0; u < sheet.getNumMergedRegions(); u++) {
                                        CellRangeAddress region = sheet.getMergedRegion(u);
                                        String checkedRange = region.formatAsString();

                                        list.add(checkedRange);
                                    } // for문 닫기

                                    
                                    // 반복문 돌려 병합된셀 출력 해보기
//                                    list.forEach(a -> {
//                                       System.out.println("list: " + a); 
//                                    });
                                    
                                    for (int t = 0; t < list.size(); t++) {
                                        String[] arrays = list.get(t).split(":");
                                        
                                        // replaceAll() 메소드로 정규식을 이용하여, 현재 column의 셀 알파벳 뽑아 내기
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
//                                            System.out.println("colspan인 경우");
//                                            System.out.println("curAddr22222: " + curAddr);

                                            CellReference ref = new CellReference(rowAlphabet);
                                            Row r = sheet.getRow(ref.getRow());
                                            Cell c = null;
                                            if (r != null) {
                                                c = r.getCell(ref.getCol());
//                                                System.out.println("ccc: " + c);
                                            }
                                            
                                            listitemSub.appendChild(doc.createTextNode(c.getStringCellValue()));
                                            listitem.appendChild(listitemSub);
                                            continue;
     
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

        } catch (Exception e) {
            System.out.println("엑셀 로드 실패");
            e.printStackTrace();
        }
        
        // excel 을 xml로 변환 추출
        Path tarXML = null;
        
        if (exceltype.equals("othertype")) {
            tarXML = Paths.get(obj.excelXDir + File.separator + fileName.replace(".xlsx", ".xml"));
            obj.excelDBF.add(tarXML.toString());
            
        } else if(exceltype.equals("satisfy")) {
            tarXML = Paths.get(obj.excelXDir + File.separator + "/satisfy" + File.separator + fileName.replace(".xlsx", ".xml"));
        }
        
        
//        System.out.println("tarXML: " + tarXML.toString());
        
        
        exportXML(doc, tarXML);
        
        
        startRow = 0;
        startCol = 0;
        startColBody = 0;
        firstCellList.clear();
        
        System.out.println("runexcel 끝");
        
        return tarXML;
    }
    
    public void exportXML(Document doc, Path tarXML) {
        try {
            // Transformer 생성
            TransformerFactory ttf = TransformerFactory.newInstance();
            Transformer tf = ttf.newTransformer();
    
            // 출력 속성 설정
            tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            tf.setOutputProperty(OutputKeys.INDENT, "yes");
            tf.setOutputProperty(OutputKeys.METHOD, "html");
    
            // DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
    
            // 출력결과를 스트림으로 생성
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
            // null인 경우, 임의의 텍스트 입력
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
