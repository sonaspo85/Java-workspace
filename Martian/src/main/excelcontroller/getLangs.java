package main.excelcontroller;

import java.io.File;
import java.io.FileInputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Iterator;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import main.Common.implementOBJ;



public class getLangs {
    implementOBJ obj = new implementOBJ();
    String msg = "";
    

    public void runLangs() {
        try {
            String langExcelF = obj.excelTemplsPathP + "/language.xlsx";
            FileInputStream fis = new FileInputStream(langExcelF);
            ZipSecureFile.setMinInflateRatio(0);
            Workbook wb = WorkbookFactory.create(fis);

            int sheetCnt = wb.getNumberOfSheets();
            
            for(int y=0; y<sheetCnt; y++) {
                Document doc = createDOM();
                Element rootEle = doc.createElement("root");
                doc.appendChild(rootEle);
                String getSheetName = wb.getSheetName(y);
                getSheetName = getSheetName.replace(" ", "_").toLowerCase();
                
                if (!getSheetName.equals("type-lang")) {
                    Sheet sheet = wb.getSheetAt(y);
                    int totalCellCnt = 0;
                    Iterator<Row> rowIt = sheet.iterator();
                    
                    while(rowIt.hasNext()) {
                        Row row = rowIt.next();
                        Element listitem = doc.createElement("listitem");
                        
                        if(row.getRowNum() == 1) {
                            totalCellCnt = row.getPhysicalNumberOfCells();
                            
                        } else if(row.getRowNum() > 1) {
                            for(int j=1; j<=totalCellCnt; j++) {
                                Cell cellVal = row.getCell(j);
                                String str1 = cellVal.toString().replace(" ", "_");
                                
                                if (getSheetName.equals("language")) {
                                    if (j == 1) {
                                        listitem.setAttribute("language", str1);
                                        
                                    } else if (j == 2) {
                                        listitem.setAttribute("ISOCode", str1);
                                        
                                    }  
                                } else if(getSheetName.equals("type")) {
                                    if (j == 1) {
                                        listitem.setAttribute("type", str1);
                                        
                                    }
                                    
                                } else if(getSheetName.equals("version")) {
                                    if (j == 1) {
                                        listitem.setAttribute("version", str1);
                                        
                                    }
                                    
                                }
    
                            }
                            
                            rootEle.appendChild(listitem);
                        }
    
                    }
                    exportXML(doc, getSheetName);
                    
                } else if(getSheetName.equals("type-lang")) {
                    Sheet sheet = wb.getSheet("Type-lang");
                    calleucommon(sheet, doc, rootEle);
                    calleu(sheet, doc, rootEle);
                    callturcommon(sheet, doc, rootEle);
                    callus(sheet, doc, rootEle);
                    callcis(sheet, doc, rootEle);
                    
                    exportXML(doc, getSheetName);
    
                }
                
            }
            
        } catch(Exception e) {
            msg = "language Excel load 실패";
            throw new RuntimeException(msg);
            
        }
        
    }
    
    public void exportXML(Document doc, String getSheetName) {
        System.out.println("exportXML() 시작");
        
        try {
            String langPathS = obj.resourceDir + File.separator + getSheetName + ".xml";
            Path langPathP = Paths.get(langPathS);
            
            // Transformer 객체 생성
            TransformerFactory ttf = TransformerFactory.newInstance(); 
            Transformer tf = ttf.newTransformer();
            tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            tf.setOutputProperty(OutputKeys.INDENT, "yes");
            tf.setOutputProperty(OutputKeys.METHOD, "xml");
            tf.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
            
            // DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(langPathP.toUri().toString());
            
            tf.transform(source, result);
            result.getOutputStream().close();
            
        } catch(Exception e) {
            msg = "Excel load 실패1";
            e.printStackTrace();
            
        }
        
    }
    
    
    
    public Document createDOM() throws Exception {
        Document doc = null;
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            dbf.setNamespaceAware(true);
            DocumentBuilder db = dbf.newDocumentBuilder();

            doc = db.newDocument();
            doc.setXmlStandalone(true);
            
        } catch(Exception e) {
            msg = "new DOM Tree 생성 실패";
            throw new RuntimeException(msg);
            
        }
        
        return doc;
        
    }
    
    public void callcis(Sheet sheet, Document doc, Element rootEle) {
        int fac = 6;
        
        for(int q=1; q<fac; q++) {
            Row row = sheet.getRow(q);
            
            if (q==1) {
                Cell cell = row.getCell(9);
                Element listitem = doc.createElement("listitem");
                listitem.setAttribute("type", cell.toString());
                
                for(int e=2; e<fac; e++) {
                    cell = sheet.getRow(e).getCell(9);
                    Element item = doc.createElement("item");
                    item.setAttribute("lang", cell.toString());
                    listitem.appendChild(item);
                    
                }

                rootEle.appendChild(listitem);
            } 

        }
        
    }
    
    public void callus(Sheet sheet, Document doc, Element rootEle) {
        int fac = 7;
        
        for(int q=1; q<fac; q++) {
            Row row = sheet.getRow(q);
            
            if (q==1) {
                Cell cell = row.getCell(7);
                Element listitem = doc.createElement("listitem");
                listitem.setAttribute("type", cell.toString());
                
                for(int e=2; e<fac; e++) {
                    cell = sheet.getRow(e).getCell(7);
                    Element item = doc.createElement("item");
                    item.setAttribute("lang", cell.toString());
                    listitem.appendChild(item);
                    
                }

                rootEle.appendChild(listitem);
            } 

        }
        
    }
    
    
    
    public void callturcommon(Sheet sheet, Document doc, Element rootEle) {
        int fac = 11;
        
        for(int q=1; q<fac; q++) {
            Row row = sheet.getRow(q);
            
            if (q==1) {
                Cell cell = row.getCell(5);
                Element listitem = doc.createElement("listitem");
                listitem.setAttribute("type", cell.toString());
                
                for(int e=2; e<fac; e++) {
                    cell = sheet.getRow(e).getCell(5);
                    Element item = doc.createElement("item");
                    item.setAttribute("lang", cell.toString());
                    listitem.appendChild(item);
                    
                }

                rootEle.appendChild(listitem);
            } 

        }
        
    }
    
    
    public void calleucommon(Sheet sheet, Document doc, Element rootEle) {
        int fac = 28;
        
        for(int q=1; q<fac; q++) {
            Row row = sheet.getRow(q);
            
            if (q==1) {
                Cell cell = row.getCell(1);
                Element listitem = doc.createElement("listitem");
                listitem.setAttribute("type", cell.toString());
                
                for(int e=2; e<fac; e++) {
                    cell = sheet.getRow(e).getCell(1);
                    Element item = doc.createElement("item");
                    item.setAttribute("lang", cell.toString());
                    listitem.appendChild(item);
                    
                }

                rootEle.appendChild(listitem);
            } 

        }
        
    }
    
    public void calleu(Sheet sheet, Document doc, Element rootEle) {
        int rac = 12;
        
        for(int q=1; q<rac; q++) {
            Row row = sheet.getRow(q);
            
            if (q==1) {
                Cell cell = row.getCell(3);
                Element listitem = doc.createElement("listitem");
                listitem.setAttribute("type", cell.toString());
                
                for(int e=2; e<rac; e++) {
                    cell = sheet.getRow(e).getCell(3);
                    Element item = doc.createElement("item");
                    item.setAttribute("lang", cell.toString());
                    listitem.appendChild(item);
                    
                }

                rootEle.appendChild(listitem);
            } 

        }
        
    }
    
}
