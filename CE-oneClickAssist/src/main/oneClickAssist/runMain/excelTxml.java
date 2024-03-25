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
	}
	
	public Path runexcel() {
	    Path tarXML = null;
	            
	    try {
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
            Iterator <Row> rowIt = sheet.iterator();

            // 첫번째 row의 셀 개수 할당
            int totalCellCnt = 0;

            // 각 row를 반복 
            while (rowIt.hasNext()) {
                Row row = rowIt.next();
                 
                if (row.getRowNum() == 1) {
                    totalCellCnt = row.getPhysicalNumberOfCells();
                    
                    for(int c=1; c<=totalCellCnt; c++) { 
                        Cell firstCell = row.getCell(c);
                        String str1 = formatCell(firstCell);
                        String str2 = str1.replace(" ", "_");
                        String str3 = str2.replaceAll("[\\(\\)]", "");
                        System.out.println("str3: " + str3);
                        firstCellList.add(str3);
                    }
                    
                } else {
                    if (!isEmpty(row) && row.getRowNum() > 1) {
                        Element listitem = doc.createElement("listitem");
                        rootEle.appendChild(listitem);
                        
                        outer:
                            
                        for (int j = 0; j < totalCellCnt; j++) {
                            Cell cellVal = row.getCell(j+1);
                            
                            String cellTxt = formatCell(cellVal);
                            String rowNum00 = String.valueOf(row.getRowNum() + 1);
                            String colNum00 = String.valueOf(j+1);
                            Element listitemSub = doc.createElement(firstCellList.get(j).toString());
                            listitemSub.setAttribute("class", rowNum00 + ":" + colNum00);
                            listitem.appendChild(listitemSub);

                            if (cellVal != null) {
                                for (int k = 0; k < sheet.getNumMergedRegions(); k++) {
                                    CellRangeAddress region = sheet.getMergedRegion(k);
                                    int rowNum = region.getFirstRow();
                                    int colIndex = region.getFirstColumn();
 
                                    if (rowNum == cellVal.getRowIndex() && colIndex == cellVal.getColumnIndex()) {
                                        mergedCellVal = sheet.getRow(rowNum).getCell(colIndex).getStringCellValue();
                                        listitemSub.appendChild(doc.createTextNode(mergedCellVal));
                                        listitem.appendChild(listitemSub);
                                        
                                        continue outer;
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

        } catch (Exception e) {
        	e.printStackTrace();
        }

        // temp 폴더 생성
        Path tarDir = Paths.get(path.getParent() + "/temp");
        if(Files.notExists(tarDir)) {
        	Files.createDirectories(tarDir);
        }
        
        tarXML = Paths.get(path.getParent() + "/temp/QRcodes.xml");
        exportXML(doc, tarXML);
        
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
	        tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
	        tf.setOutputProperty(OutputKeys.INDENT, "no");
	        tf.setOutputProperty(OutputKeys.METHOD, "xml");
	        tf.setOutputProperty(OutputKeys.STANDALONE, "yes");
	
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
        
        if(op.isEmpty()) {
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
