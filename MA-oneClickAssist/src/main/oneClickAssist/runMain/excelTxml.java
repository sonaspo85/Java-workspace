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
import javax.xml.parsers.ParserConfigurationException;
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
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class excelTxml {
	String excelPath = "";
	String excelName = "";
	static DataFormatter dfm = new DataFormatter();
    static DecimalFormat df = new DecimalFormat("#");
//    static List<String> firstCellList = new ArrayList<>();
    static public Path crossF = null;
    
    
	public excelTxml(String path) {
		this.excelPath = path;
        Path excelP = Paths.get(excelPath);
        excelName = excelP.getFileName().toString();
	}
	
	public void runexcel(List<String> getsheet) throws Exception {
		Path path = Paths.get(excelPath);
        Path tarDir = Paths.get(path.getParent() + "/temp");
        
        if(Files.notExists(tarDir)) {
            Files.createDirectories(tarDir);
        }
		
		getsheet.forEach(r -> {
            String getSeet = r;
            System.out.println("getSeet: " + getSeet);
            List<String> firstCellList = new ArrayList<>();

        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db;
        try {
            db = dbf.newDocumentBuilder();
            
        } catch (ParserConfigurationException e1) {
            throw new RuntimeException(e1.getMessage());              
        }
        
        Document doc = db.newDocument();
        doc.setXmlStandalone(true);

        Element rootEle = doc.createElement("root");
        rootEle.setAttribute("fileName", excelName);
        doc.appendChild(rootEle);

        try {
        	FileInputStream fis = new FileInputStream(path.toFile());
            Workbook wb = WorkbookFactory.create(fis);
            String mergedCellVal = "";            
            Sheet sheet = wb.getSheet(getSeet);
            Iterator <Row> rowIt = sheet.iterator();
            int totalCellCnt = 0;

            // 각 row를 반복 
            while (rowIt.hasNext()) {
                Row row = rowIt.next();
                
                if (row.getRowNum() == 7) {
                    totalCellCnt = row.getPhysicalNumberOfCells();
                    
                    for(int c=1; c<=totalCellCnt; c++) {
                        // 첫번째 행의 각 셀의 값 추출 
                        Cell firstCell = row.getCell(c);
                        
                        String str1 = formatCell(firstCell);
                        String str2 = str1.replace(" ", "_");
                        String str3 = str2.replaceAll("[\\(\\)]", "");
                        String str4 = StringEscapeUtils.escapeXml11(str3);
                        firstCellList.add(str4);
                    }
                    
                } else {
                    if (!isEmpty(row) && row.getRowNum() > 7) {
                        // row 한번씩 돌때마다cellVal listitem 태그 생성
                        Element listitem = doc.createElement("listitem");
                        rootEle.appendChild(listitem);
                        
                        outer:
                        // header row의 Cell개수 만큼 반복  
                        for (int j = 0; j < totalCellCnt; j++) {
                            Cell cellVal = row.getCell(j+1);
                            
                            String cellTxt0 = formatCell(cellVal);
                            String cellTxt = StringEscapeUtils.escapeXml11(cellTxt0);
                            String rowNum00 = String.valueOf(row.getRowNum() + 1);
                            String colNum00 = String.valueOf(j+1);
                            Element listitemSub = doc.createElement(firstCellList.get(j).toString());
                            listitemSub.setAttribute("class", rowNum00 + ":" + colNum00);
                            listitem.appendChild(listitemSub);
                            
                            // Cell 값이 null 이 아닌 경우
                            if (cellVal != null) {
                                for (int k = 0; k < sheet.getNumMergedRegions(); k++) {
                                    CellRangeAddress region = sheet.getMergedRegion(k);
                                    int rowNum = region.getFirstRow();
                                    int colIndex = region.getFirstColumn();
                                     
                                    if (rowNum == cellVal.getRowIndex() && colIndex == cellVal.getColumnIndex()) {
                                        String getCellVal = sheet.getRow(rowNum).getCell(colIndex).getStringCellValue();
                                        mergedCellVal = StringEscapeUtils.escapeXml11(getCellVal);
                                        listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                        listitem.appendChild(listitemSub);
                                        
                                        continue outer;
                                    }
                                }

                                if (cellVal.getCellType() == CellType.BLANK || cellVal == null) {
                                	// 병합된 첫번째 cell에서 추출한 값을 병합된 셀에서 가져와 사용
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
            
        } catch (Exception e) {
        }

        if(getSeet.contains("Cross")) {
            crossF = Paths.get(path.getParent() + "/temp/" + getSeet + ".xml");
            
        }
        
        // excel 을 xml로 변환 추출        
        Path tarXML = Paths.get(path.getParent() + "/temp/" + getSeet + ".xml");
        exportXML(doc, tarXML);

		});
		
	}
	
	public void exportXML(Document doc, Path tarXML) {
	    System.out.println("exportXML 시작");
		try {
			// Transformer 생성
	        TransformerFactory ttf = TransformerFactory.newInstance();
	        Transformer tf = ttf.newTransformer();
	        tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
	        tf.setOutputProperty(OutputKeys.INDENT, "yes");
	        tf.setOutputProperty(OutputKeys.METHOD, "xml");
	        tf.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");

	        DOMSource source = new DOMSource(doc);
	        StreamResult result = new StreamResult(tarXML.toUri().toString());
	
	        tf.transform(source, result);
	        result.getOutputStream().close();
	        
		} catch(Exception e1) {
			e1.printStackTrace();
		}
		
	}
	
	public boolean isEmpty(Row row) {
        int cellCnt = row.getPhysicalNumberOfCells();

        String str = "";

        for (int c = 1; c <= cellCnt; c++) {
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
    
}
