package main.DITA.excelController;

import java.io.File;
import java.io.FileInputStream;
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
	static DataFormatter dfm = new DataFormatter();
    static DecimalFormat df = new DecimalFormat("#");
    static public Path crossF = null;
    
    Path sMapDir = null;
    String outMapDir = "";
    String pvPath = "";
    String strlb1 = "";
    
    String excelPath = "";
    Path excelP = null;
    String excelName = "";
    
    List<String> getsheet = Arrays.asList("recommend", "tagsValue", "Message");
    
    
	public excelTxml(Path sMapDir, String outMapDir, String pvPath, String strlb1) {
		System.out.println("excelTxml() 시작");
		this.sMapDir = sMapDir;
        this.outMapDir = outMapDir;
        this.pvPath = pvPath;
        this.strlb1 = strlb1;
		
        excelPath = outMapDir + "/ExcelDB" + File.separator + strlb1 + File.separator + "skeleton.xlsx";
		// 엑셀 경로를 Path 객체로 생성
        excelP = Paths.get(excelPath);
        
        // 엑셀 이름 추출
        excelName = excelP.getFileName().toString();
		System.out.println("excelPath: " + excelPath);
	}
	
	public void runexcel() throws Exception {
		System.out.println("runexcel 시작");
        
		getsheet.forEach(r -> {
            String getSeet = r;
            System.out.println("getSeet: " + getSeet);
            
            List<String> firstCellList = new ArrayList<>();

	        try {
	        	// 새로운 XML DOM 객체 생성
	        	DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	            dbf.setNamespaceAware(true);
	        	DocumentBuilder db = dbf.newDocumentBuilder();
	            
	        	Document doc = db.newDocument();
		        doc.setXmlStandalone(true);
		        
		        // root 요소 생성
		        Element rootEle = doc.createElement("root");
		        rootEle.setAttribute("fileName", excelName);
		        doc.appendChild(rootEle);
		        
		        // 엑셀 파일 읽기
		        FileInputStream fis = new FileInputStream(excelPath);
		        ZipSecureFile.setMinInflateRatio(0);
		        Workbook wb = WorkbookFactory.create(fis);

		        String mergedCellVal = "";

		        Sheet sheet = wb.getSheet(getSeet);

		        // 시트의 각 행을 Iterator 반복자를 사용하여 각 Row를 하나씩 반복
		        Iterator <Row> rowIt = sheet.iterator();

		        // 첫번째 row의 셀 개수 할당
		        int totalCellCnt = 0;

		        // 각 row를 반복 
		        while (rowIt.hasNext()) {
		            // 각 row 하나씩 추출
		            Row row = rowIt.next();
		            
		            // 엑셀에서 header 행의 위치가 첫번째 행인 경우 
		            if (row.getRowNum() == 1) {
		                // getPhysicalNumberOfCells() : 실제 셀에 값이 있는 경우의 셀 개수 반환
		                totalCellCnt = row.getPhysicalNumberOfCells();
		                
		                // 1번째 행의 셀을 한번씩 돌아 셀의 값을 firstCellList 컬렉션에 수집
		                // xml로 추출시 태그로 사용하기 위해 추출함
		                for(int c=1; c<=totalCellCnt; c++) {
		                    // 첫번째 행의 각 셀의 값 추출 
		                    Cell firstCell = row.getCell(c);
		                    
		                    String str1 = formatCell(firstCell);
		                    String str2 = str1.replace(" ", "_");
		                    String str3 = str2.replaceAll("[\\(\\)]", "");
		                    String str4 = StringEscapeUtils.escapeXml11(str3);
//		                    System.out.println("str4: " + str4);
		                    firstCellList.add(str4);
		                }
		                
		            } else { //  row 행 인덱스가 1번째 행이 아닌 경우, 즉 header가 아닌 경우
		                // isEmpty() 메소드를 호출하여, row의 전체 셀이 비어 있지 않은 경우
		                // row.getRowNum() > 1 : 1번째 행(header) 이후의 행에대해서 for문 진행
		            	if (!isEmpty(row) && row.getRowNum() > 1) {
		                    // row 한번씩 돌때마다cellVal listitem 태그 생성
		                    Element listitem = doc.createElement("listitem");
		                    rootEle.appendChild(listitem);
		                    
		                    outer:  // 라벨을 사용하여 병합된 첫번째 셀 작업후, 바로 바깥 for문으로 빠져나오기 위해 사용
		                    // header row의 Cell개수 만큼 반복  
		                    for (int j = 0; j < totalCellCnt; j++) {
		                        Cell cellVal = row.getCell(j+1);
		                        
		                        String cellTxt0 = formatCell(cellVal);
		                        
		                        String cellTxt = StringEscapeUtils.escapeXml11(cellTxt0);
		                       
		                        
//		                        String cellTxt = formatCell(cellVal);  // cell 타입에 따라 출력할 값 컨트롤
		                        String rowNum00 = String.valueOf(row.getRowNum() + 1);  // 해당 셀의 row 인덱스 위치 파악
		                        String colNum00 = String.valueOf(j+1);  // 해당 셀의 column 인덱스 위치 파악
		                        
		                        // 한번씩 돌때마다 header의 각 셀값들로 태그 생성
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
		                                	// 병합된 셀의 첫번째 셀인 경우 값 추출
		                                    String getCellVal = sheet.getRow(rowNum).getCell(colIndex).getStringCellValue();
		                                    mergedCellVal = StringEscapeUtils.escapeXml11(getCellVal);
		                                    
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
		        
		        // excel 을 xml로 변환 추출        
		        Path tarXML = Paths.get(excelP.getParent() + "/" + getSeet + ".xml");
		        exportXML(doc, tarXML);
		        
		        // 파일 스트림 및 워크 북 닫기
		        fis.close();
                wb.close();
                
	        } catch (Exception e1) {
	        	System.out.println("엑셀 로드 실패");
	            throw new RuntimeException(e1.getMessage());              
	        }

	        System.out.println("excel To xml 변환 완료!!");
		});
		
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
//                    return cell.getStringCellValue();
                    return dfm.formatCellValue(cell1);
                default:
                    return "<unknown value>";
            }
        }
    }
    
}
