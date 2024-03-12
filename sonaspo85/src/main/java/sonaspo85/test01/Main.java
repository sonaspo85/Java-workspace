package sonaspo85.test01;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URI;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.poi.EncryptedDocumentException;
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


public class Main {
    static DataFormatter dfm = new DataFormatter();

    public static void main(String[] args) throws Exception {
        List < String > fristCellList = new ArrayList < String > ();

        String srcFile = "C:\\Users\\DESK-02 4756\\Desktop\\IMAGE\\test.xlsx";
        Path path = Paths.get(srcFile);
        String mergedCellVal = "";


        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.newDocument();
        doc.setXmlStandalone(true);

        Element rootEle = doc.createElement("root");
        doc.appendChild(rootEle);


        try {
            FileInputStream fis = new FileInputStream(path.toFile());

            try {
                Workbook wb = WorkbookFactory.create(fis);
                Sheet sheet = wb.getSheetAt(0);

                // 시트의 각 행을 Iterator 반복자를 사용하여 각 Row를 하나씩 반복
                Iterator < Row > rowIt = sheet.iterator();

                // 첫번째 row의 셀 개수 할당
                int totalCellCnt = 0;

                // 각 row를 반복 
                while (rowIt.hasNext()) {
                    // 각 row 하나씩 추출
                    Row row = rowIt.next();

                    if (row.getRowNum() == 1) {
                        // getPhysicalNumberOfCells() : 실제 셀에 값이 있는 경우의 셀 개수 반환
                        totalCellCnt = row.getPhysicalNumberOfCells();

                    } else { //  row 행 인덱스가 1이 아닌 경우, 즉 header가 아닌 경우
                        // isEmpty() 메소드를 호출하여, row의 전체 셀이 비어 있지 않은 경우
                        if (!isEmpty(row) && row.getRowNum() > 0) {
                            // row 한번씩 돌때마다 listitem 태그 생성
                            Element listitem = doc.createElement("listitem");
                            rootEle.appendChild(listitem);
                                
                                outer:  // 라벨을 사용하여 병합된 첫번째 샐 작업후, 바로 바깥 for문으로 빠져나오기 위해 사용
                                // row의 각 Cell에 대해 반복  
                                for (int j = 1; j <= totalCellCnt; j++) {
                                    Cell cellVal = row.getCell(j);
                                    
                                    // formatCellValue(): 셀의 값을 문자 그대로 출력
                                    String vals = dfm.formatCellValue(cellVal);
                                    Element listitemSub = doc.getDocumentElement();
                                    
                                    // Cell 값이 null 이 아닌 경우
                                    if (cellVal != null) {
                                        // getNumMergedRegions(): '시트내 모든 병합'된 영역의 수를 반환
                                        for (int k = 0; k < sheet.getNumMergedRegions(); k++) {
                                            // getMergedRegion(): 한번씩 반복될때마다, '시트 내에서 찾은' 병합된 영역의 행과 열 인덱스 반환
                                            CellRangeAddress region = sheet.getMergedRegion(k);
                                            
                                            // getFirstColumn(): 병합된 영역에서 첫번째 Cell의 상단 열번호 반환
                                            // getFirstRow(): 병합된 영역에서 첫번째 행의 왼쪽 행 번호 반환
                                            int colIndex = region.getFirstColumn();
                                            int rowNum = region.getFirstRow();
                                            
                                            // 영역의 첫번째 Cell 인지 확인 하는 if문
                                            // 확인 하는 이유는, 병합된 셀의 데이터는 항상 첫번째 Cell에 채워져 있다.
                                            if (rowNum == cellVal.getRowIndex() && colIndex == cellVal.getColumnIndex()) {
                                                mergedCellVal = sheet.getRow(rowNum).getCell(colIndex).getStringCellValue();

//                                                listitemSub = doc.createElement(sheet.getRow(1).getCell(colIndex).getStringCellValue());
                                                listitemSub = doc.createElement(sheet.getRow(1).getCell(cellVal.getColumnIndex()).getStringCellValue());
                                                listitemSub.setAttribute("class", (cellVal.getRowIndex() + 1) + ":" + cellVal.getColumnIndex());
                                                listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                                listitem.appendChild(listitemSub);
                                                
                                                // continue outer; 없을 경우, 다음 for문을 돌기 때문에 빠져 나와야 한다.
                                                continue outer;
                                            }
                                        }

                                        // BLANK, null이라는 의미는 병합된 첫번째 Cell이 아닌 나머지 인덱스 위치의 셀을 의미한다
                                        if (cellVal.getCellType() == CellType.BLANK || cellVal == null) {
                                            String str1 = mergedCellVal;

                                            listitemSub = doc.createElement(sheet.getRow(1).getCell(cellVal.getColumnIndex()).getStringCellValue());
                                            listitemSub.setAttribute("class", (cellVal.getRowIndex() + 1) + ":" + cellVal.getColumnIndex());
                                            listitemSub.appendChild(doc.createTextNode(str1));
                                            listitem.appendChild(listitemSub);
                                            continue;
                                        }
                                        
                                        // 병합된 첫번째 Cell이 아니고, 병합된 나머지 Cell 이 아닌, 각 row의 Cell값들이 개별적으로 채워져 있는 경우
                                        String str2 = dfm.formatCellValue(cellVal);
                                        listitemSub = doc.createElement(sheet.getRow(1).getCell(cellVal.getColumnIndex()).getStringCellValue());
                                        listitemSub.setAttribute("class", (cellVal.getRowIndex() + 1) + ":" + cellVal.getColumnIndex());
                                        listitemSub.appendChild(doc.createTextNode(str2));
                                        listitem.appendChild(listitemSub);

                                    }
                                }
                        }
                        System.out.println();

                    }

                }

            } catch (EncryptedDocumentException | IOException e) {
                System.out.println("엑셀 로드 실패");
            }

        } catch (FileNotFoundException e) {
            System.out.println("파일 읽기 실패");
        }


        // Transformer 생성
        TransformerFactory ttf = TransformerFactory.newInstance();
        Transformer tf = ttf.newTransformer();

        // 출력 속성 설정
        tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        tf.setOutputProperty(OutputKeys.INDENT, "yes");
        tf.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");

        // DOMSource 객체 생성
        DOMSource source = new DOMSource(doc);

        // 출력결과를 스트림으로 생성
        // 출력 Path 지정
        File f = new File("C:\\Users\\DESK-02 4756\\Desktop\\IMAGE\\bbb.xml");
        URI u = f.toURI();

        Result result = new StreamResult(u.toString());

        tf.transform(source, result);

    }

    public static boolean isEmpty(Row row) {
        // 셀 개수 파악
        int cellCnt = row.getPhysicalNumberOfCells();

        String str = "";

        for (int c = 1; c <= cellCnt; c++) {
            // 행의 각 셀의 값 추출
            Cell cellVal = row.getCell(c);

            str += cellVal;
        }

        Optional < String > op = Optional.ofNullable(str);
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

}