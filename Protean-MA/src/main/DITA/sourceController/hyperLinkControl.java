package main.DITA.sourceController;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.interactive.action.PDAction;
import org.apache.pdfbox.pdmodel.interactive.action.PDActionGoTo;
import org.apache.pdfbox.pdmodel.interactive.action.PDActionURI;
import org.apache.pdfbox.pdmodel.interactive.annotation.PDAnnotation;
import org.apache.pdfbox.pdmodel.interactive.annotation.PDAnnotationLink;
import org.apache.pdfbox.pdmodel.interactive.documentnavigation.destination.PDDestination;
import org.apache.pdfbox.pdmodel.interactive.documentnavigation.destination.PDNamedDestination;
import org.apache.pdfbox.pdmodel.interactive.documentnavigation.destination.PDPageDestination;

public class hyperLinkControl {
	String masterPDFPath = "";
	PDDocument doc = null;
	
	public hyperLinkControl(String masterPDFPath) {
		this.masterPDFPath = masterPDFPath;
		File file = new File(masterPDFPath);
		
		try {
			doc = PDDocument.load(file);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void accessLink() throws Exception {
		int pageNum = 0;
		
		for (PDPage page: doc.getPages()) {
		    pageNum++;
		    List <PDAnnotation> annotations = page.getAnnotations();
		    
		    for (PDAnnotation annot: annotations) {
		        if (annot instanceof PDAnnotationLink) {
		            PDAnnotationLink link = (PDAnnotationLink) annot;
		            PDAction action = link.getAction();
		            
		            // 어떤 특별한 경우 내부 링크 가져오기 
		            PDDestination pDestination = link.getDestination();

		            if (action != null) {  // 링크 객체의 동작이 null이 아닌 경우
		                if (action instanceof PDActionURI || action instanceof PDActionGoTo) {
		                    if (action instanceof PDActionURI) {
		                        PDActionURI uri = (PDActionURI) action;
		                        link.setHighlightMode(PDAnnotationLink.HIGHLIGHT_MODE_NONE);
		                        
		                    } 
		                    else {
		                        if (action instanceof PDActionGoTo) {
		                        	PDActionGoTo pagt = (PDActionGoTo) action;
		                            PDDestination destination = pagt.getDestination(); 
		                            PDPageDestination pageDestination;
		                            
		                            if (destination instanceof PDPageDestination) {
		                            	pageDestination = (PDPageDestination) destination;
		                            	
		                            	if(pageNum <= 4 & pageDestination != null) {
	                                    	link.setHighlightMode(PDAnnotationLink.HIGHLIGHT_MODE_NONE);
	                                    	
	                                    }
		                            	
		                            } else {
		                                if (destination instanceof PDNamedDestination) {
		                                	PDNamedDestination pdfNameDestination = (PDNamedDestination) destination;
		                                	PDDocumentCatalog pdfcatalog = doc.getDocumentCatalog();
		                                    pageDestination = pdfcatalog.findNamedDestinationPage(pdfNameDestination);
		                                    
		                                    if(pageNum <= 4 & pageDestination != null) {
		                                    	link.setHighlightMode(PDAnnotationLink.HIGHLIGHT_MODE_NONE);
		                                    	
		                                    }
		                                    
		                                } else {
		                                	System.out.println("에러 발생");
		                                    break;
		                                }
		                            }

		                            if (pageDestination != null) {
		                            }
		                        }
		                    }
		                }
		                
		            } else { // 링크 객체의 액션이 null인 경우
		                if (pDestination != null) {
		                    PDPageDestination pageDestination;
		                    
		                    if (pDestination instanceof PDPageDestination) {
		                        pageDestination = (PDPageDestination) pDestination;
		                        
		                    } else {
		                        if (pDestination instanceof PDNamedDestination) {
		                            pageDestination = doc.getDocumentCatalog().findNamedDestinationPage((PDNamedDestination) pDestination);
		                            
		                        } else {
		                            // error handling
		                            break;
		                        }
		                    }

		                    if (pageDestination != null) {
		                    }
		                } else {
		                }
		            }
		        }
		    }

		}  // for문 닫기
		
		savePDF();
		
	}
	
	public void savePDF() {
		try {
			int extensPos = masterPDFPath.lastIndexOf(".");
			String ExtensionNO = masterPDFPath.substring(0, extensPos);
			String newFileStr = ExtensionNO + "_new" + masterPDFPath.substring(extensPos);
			
			
			doc.save(newFileStr);
			doc.close();
			rewriteDoc(newFileStr);

		} catch(Exception e1) {
			e1.printStackTrace();
		}
		
	}
	
	public void rewriteDoc(String newPDFFile) {
		File originalPDF = new File(masterPDFPath);
		originalPDF.delete();
		 
		newPDFFile.replace("_new", "");
		File newpdfF = new File(newPDFFile);
		newpdfF.renameTo(originalPDF);
		
	}
	
	
}
