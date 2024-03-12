package main.java.runMain;

public class PDFMain {
	
	public static void main(String[] args) throws Exception {
		String manualPDFPathStr = args[0];
//		String manualPDFPathStr = "C:/Users/SMC/Desktop/IMAGE/새 폴더/final-ar-SA.pdf";
        System.out.println("manualPathStr: " + manualPDFPathStr);
		
		hyperLinkControl hyperLink = new hyperLinkControl(manualPDFPathStr); 
		hyperLink.accessLink();
		
	}

	
}
