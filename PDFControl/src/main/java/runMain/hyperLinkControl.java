package main.java.runMain;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.common.PDPageLabels;
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
			System.out.println("master.PDF 읽기 실패!");
			e.printStackTrace();
		}
	}
	
	public void accessLink() throws Exception {
		int pageNum = 0;
		for (PDPage page: doc.getPages()) {
		    pageNum++;

		    // getAnnotations(): PDF 문서내 모든 페이지에서 하이퍼 링크 객체를 List 컬렉션으로 수집
		    List <PDAnnotation> annotations = page.getAnnotations();
		    
		    // 추출한 모든 링크 객체에 대해 for문 실행
		    for (PDAnnotation annot: annotations) {
		        if (annot instanceof PDAnnotationLink) {
		            // 주석 가져 오기
		        	// PDAnnotationLink : 링크를 나타내는 객체
		            PDAnnotationLink link = (PDAnnotationLink) annot;
		            
		            // 링크 가져오기 작업에는 링크 URL 및 내부 링크가 포함됩니다.
		            // getAction() : 링크 객체가 활성화될 때 해당 링크 객체 작업을 가져 온다.
		            PDAction action = link.getAction();
		            
		            // 어떤 특별한 경우 내부 링크 가져오기 
		            // PDDestination : PDF 문서 객체를 의미
		            // getDestination() : 링크 객체가 활성화될 때 표시할 대상을 가져온다
		            PDDestination pDestination = link.getDestination();

		            if (action != null) {  // 링크 객체의 동작이 null이 아닌 경우
		                if (action instanceof PDActionURI || action instanceof PDActionGoTo) {
	                    	// PDActionURI : PDF 문서에서 실행할 수 있는 외부 URI 연결 링크를 나타내는 링크 객체일 경우
		                    if (action instanceof PDActionURI) {
		                        // 링크 주소 가져오기

		                    	// 페이지 이동 링크가 아니라 외부 연결 링크를 나타낸다
		                        PDActionURI uri = (PDActionURI) action;
//		                        System.out.println("external uri link: " + uri.getURI());
		                        
		                        // 외부 링크일 경우 링크 반전 없애기
		                        link.setHighlightMode(PDAnnotationLink.HIGHLIGHT_MODE_NONE);
		                        
		                    } 
		                    else {  // 내부 링크 얻기
		                    	// PDActionGoTo: PDF 문서내에서 이동 가능한 링크 객체 타입인 경우
		                        if (action instanceof PDActionGoTo) {
		                        	// PDActionGoTo : 링크 객체의 액션 객체를 PDF 문서에서 실행할 수 있는 이동 작업 객체로 강제 타입 변환 한다. 
		                        	PDActionGoTo pagt = (PDActionGoTo) action;
		                        	
		                        	// PDDestination : PDF 문서 객체를 의미
		                        	// getDestination() : 이동 객체타입으로 타입 변환 된 객체(pagt)로 부터 이동돌 목적지 주소를 PDDestination 객체로 생성 
		                            PDDestination destination = pagt.getDestination();
		                            
		                            // 이동 가능한 객체(PDActionGoTo)의 목적지 주소로 페이지 객체 타입으로 타입 변환 가능한 경우
		                            // 즉 링크 객체 클릭시 목적지 주소로 페이지로 이동시, 페이지 번호 접근하고 있는 경우 
		                            PDPageDestination pageDestination;
		                            if (destination instanceof PDPageDestination) {
		                            	// 이동될 목적지 주소의 문서 객체로 부터 페이지 객체 타입으로 타입 변환
		                            	pageDestination = (PDPageDestination) destination;
//		                            	System.out.println("링크 객체에 할당된 페이지 번호: " + pageDestination.getPageNumber());
		                            	
		                            	if(pageNum <= 4 & pageDestination != null) {
	                                    	// pdf 페이지 링크 반전 없애기
	                                    	link.setHighlightMode(PDAnnotationLink.HIGHLIGHT_MODE_NONE);
	                                    	
//	                                    	System.out.println("현재 페이지111: " + pageNum);
//	                                    	System.out.println("이동될 페이지 번호111: " + (pageDestination.retrievePageNumber()));
	                                    }
		                            	
		                            } else { // pdf 문서 객체가 페이지 번호로 이동할 수 없는 경우
		                            	// PDNamedDestination : pdf 객체를 이름으로 페이지를 참조하는 객체 타입으로 변환 가능한 경우
		                            	// 링크 객체 클릭시 목적지 주소로 페이지로 이동시, 지정된 페이지 이름으로 접근하고 있는 경우
		                                if (destination instanceof PDNamedDestination) {
		                                	PDNamedDestination pdfNameDestination = (PDNamedDestination) destination;
		                                	
		                                	// findNamedDestinationPage() : 매개 변수로 PDNamedDestination 객체를 할당하여, 목적지 객체 찾기 
		                                	PDDocumentCatalog pdfcatalog = doc.getDocumentCatalog();
		                                    pageDestination = pdfcatalog.findNamedDestinationPage(pdfNameDestination);
		                                    
		                                    if(pageNum <= 4 & pageDestination != null) {
		                                    	// pdf 페이지 링크 반전 없애기
		                                    	link.setHighlightMode(PDAnnotationLink.HIGHLIGHT_MODE_NONE);
		                                    	
//		                                    	System.out.println("현재 페이지111: " + pageNum);
//		                                    	System.out.println("이동될 페이지 번호111: " + (pageDestination.retrievePageNumber()));
		                                    }
		                                    
		                                } else {
		                                    // error handling
		                                	System.out.println("에러 발생");
		                                    break;
		                                }
		                            }

		                            if (pageDestination != null) {
		                            	// retrievePageNumber() : 페이지 번호인지 페이지에 대한 참조인지 여부에 관계없이 이 대상의 페이지 번호를 반환
//		                                System.out.println("page move111: " + (pageDestination.retrievePageNumber() + 1));
		                            }
		                        }
		                    }
		                }  // PDActionURI, PDActionGoTo 활성화 할수 있는 경우 끝
		                
		            } else { // 링크 객체의 액션이 null인 경우
		                if (pDestination != null) {  // 링크 객체가 대상으로 이동될 수 없는 객체인 경우
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
		                    	// retrievePageNumber() : 페이지 번호인지 페이지에 대한 참조인지 여부에 관계없이 이 대상의 페이지 번호를 반환
		                        System.out.println("page move222: " + (pageDestination.retrievePageNumber() + 1));
		                    }
		                } else {
		                    //    
		                }
		            }
		        }
		    }

		}  // for문 닫기
		
		// PDF 문서 객체 닫기
		savePDF();
		
	}
	
	public void savePDF() {
		try {
			int extensPos = masterPDFPath.lastIndexOf(".");
			String ExtensionNO = masterPDFPath.substring(0, extensPos);
			String newFileStr = ExtensionNO + "_new" + masterPDFPath.substring(extensPos);
			
			
			doc.save(newFileStr);
			doc.close();
			
			// 기존 문서 에 덮어쓰기
			rewriteDoc(newFileStr);
			
			System.out.println("PDF 링크 정리 완료!");
			
			
			
		} catch(Exception e1) {
			System.out.println("PDF 문서 저장 실패!");
			e1.printStackTrace();
		}
		
	}
	
	public void rewriteDoc(String newPDFFile) {
		File originalPDF = new File(masterPDFPath);
		originalPDF.delete();
		
		// renameTo() 메소드를 사용하여, 기존이름으로 새로운 파일을 이동 및 파일명 변경을 한다 
		newPDFFile.replace("_new", "");
		File newpdfF = new File(newPDFFile);
		newpdfF.renameTo(originalPDF);
		
	}
	
	
}
