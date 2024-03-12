package excelTxml.runMain;

import java.nio.file.Path;
import java.nio.file.Paths;

public class Main {

	public static void main(String[] args) {
	    String manualPathStr = args[0];
	    
//	    String manualPathStr = "H:/DITA/Mobile/Bat/mobile-source";
        Path manualPath = Paths.get(manualPathStr);
		String excelPath = manualPath + "/out/skeleton.xlsx";
		excelPath = excelPath.replace('\\', '/');
		System.out.println("excelPath: " + excelPath);
		
		excelTxml exceltxml = new excelTxml(excelPath);
		
		try {
			exceltxml.runexcel();
			
		} catch (Exception e) {
		    System.out.println("excelTxml 객체 호출 실패");
			e.printStackTrace();
		}
		
		
	}

}
