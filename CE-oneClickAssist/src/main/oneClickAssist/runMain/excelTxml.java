package main.oneClickAssist.runMain;

import java.io.FileInputStream;
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
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

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
	static DataFormatter dfm = new DataFormatter();
    static DecimalFormat df = new DecimalFormat("#");
    static List<String> firstCellList = new ArrayList<>();
    
    
	public excelTxml(String path) {
		this.excelPath = path;
		System.out.println("excelPath: " + excelPath);
	}
	
	public Path runexcel() {
	    Path tarXML = null;
	            
	    try {
		System.out.println("runexcel 시작");
		Path path = Paths.get(excelPath);
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
            Workbook wb = WorkbookFactory.create(fis);
            Sheet sheet = wb.getSheetAt(0);
//            Sheet sheet = wb.getSheet("Cross");

            // 시트의 각 행을 Iterator 반복자를 사용하여 각 Row를 하나씩 반복
            Iterator <Row> rowIt = sheet.iterator();

            // 첫번째 row의 셀 개수 할당
            int totalCellCnt = 0;

            // 각 row를 반복 
            while (rowIt.hasNext()) {
                // 각 row 하나씩 추출
                Row row = rowIt.next();
                
                // 엑셀에서 header 행이 8인경우 
                if (row.getRowNum() == 1) {
                    // getPhysicalNumberOfCells() : 실제 셀에 값이 있는 경우의 셀 개수 반환
                    totalCellCnt = row.getPhysicalNumberOfCells();
                    
                    // 8번째 행의 셀을 한번씩 돌아 셀의 값을 firstCellList 컬렉션에 수집
                    for(int c=1; c<=totalCellCnt; c++) {
                        // 첫번째 행의 각 셀의 값 추출 
                        Cell firstCell = row.getCell(c);
                        
                        String str1 = formatCell(firstCell);
                        String str2 = str1.replace(" ", "_");
                        String str3 = str2.replaceAll("[\\(\\)]", "");
                        System.out.println("str3: " + str3);
                        firstCellList.add(str3);
                    }
                    
                } else { //  row 행 인덱스가 8번째 행이 아닌 경우, 즉 header가 아닌 경우
                    // isEmpty() 메소드를 호출하여, row의 전체 셀이 비어 있지 않은 경우
                	// row.getRowNum() > 7 : 8번째 행(header) 이후의 행에대해서 for문 진행
                    if (!isEmpty(row) && row.getRowNum() > 1) {
                        // row 한번씩 돌때마다cellVal listitem 태그 생성
                        Element listitem = doc.createElement("listitem");
                        rootEle.appendChild(listitem);
                        
                        outer:  // 라벨을 사용하여 병합된 첫번째 셀 작업후, 바로 바깥 for문으로 빠져나오기 위해 사용
                        // header row의 Cell개수 만큼 반복  
                        for (int j = 0; j < totalCellCnt; j++) {
                            Cell cellVal = row.getCell(j+1);
                            
                            String cellTxt = formatCell(cellVal);  // cell 타입에 따라 출력할 값 컨트롤
                            String rowNum00 = String.valueOf(row.getRowNum() + 1);  // 해당 셀의 row 인덱스 위치 파악
                            String colNum00 = String.valueOf(j+1);  // 해당 셀의 column 인덱스 위치 파악
                            
                            // 한번씩 돌때마다 header의 각 셀값들로 요소들을 생성
                            Element listitemSub = doc.createElement(firstCellList.get(j).toString());
                            listitemSub.setAttribute("class", rowNum00 + ":" + colNum00);
                            listitem.appendChild(listitemSub);
                            
                            // Cell 값이 null 이 아닌 경우
                            if (cellVal != null) {
                                // getNumMergedRegions(): '시트내 모든 병합'된 영역의 개수를 반환
                                for (int k = 0; k < sheet.getNumMergedRegions(); k++) {
                                    // getMergedRegion(): 한번씩 반복될때마다, '시트 내에서 찾은' 병합된 영역의 행과 열 인덱스 반환
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
                                        mergedCellVal = sheet.getRow(rowNum).getCell(colIndex).getStringCellValue();
                                        listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                        listitem.appendChild(listitemSub);
                                        
                                        // continue outer; 없을 경우, 다음 for문을 돌기 때문에 빠져 나와야 한다.
                                        continue outer;
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
                            	// cellVal이 null일 경우 else문이 없다면, <Recommand /> 형태로 출력된다.
                            	// <Recommand></Recommand> 형태로 출력 하기 위해서 하기 구문 추가
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

        // temp 폴더 생성
        Path tarDir = Paths.get(path.getParent() + "/temp");
        if(Files.notExists(tarDir)) {
        	Files.createDirectories(tarDir);
        }
        
        // excel 을 xml로 변환 추출
        tarXML = Paths.get(path.getParent() + "/temp/QRcodes.xml");
        
        exportXML(doc, tarXML);
        
        System.out.println("runexcel 끝");
        
        
	    } catch(Exception e3) {
	        e3.getMessage();
	        e3.printStackTrace();
	    }
	    return tarXML;
	}
	
	public void exportXML(Document doc, Path tarXML) {
	    try {
			// Transformer 생성
	        TransformerFactory ttf = TransformerFactory.newInstance();
	        Transformer tf = ttf.newTransformer();
	
	        // 출력 속성 설정
	        tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
	        tf.setOutputProperty(OutputKeys.INDENT, "no");
	        tf.setOutputProperty(OutputKeys.METHOD, "xml");
	        tf.setOutputProperty(OutputKeys.STANDALONE, "yes");
	
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
    
    public static String formatCell(Cell cell) {
        Optional<Cell> op = Optional.ofNullable(cell);
        
        if(op.isEmpty()) {
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
    
}