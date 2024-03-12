package excelTxml.runMain;

import java.nio.file.Path;
import java.nio.file.Paths;

public class Main {

	public static void main(String[] args) {
//	    String manualPathStr = args[0];
	    
	    /*String manualPathStr = "C:\\Users\\SMC\\Desktop\\IMAGE\\230410\\";
        Path manualPath = Paths.get(manualPathStr);
        String excelPath = manualPath + "\\SM-F711B_SPEC_Sample_v.4.0_211007_유럽.xlsx";
		excelPath = excelPath.replace('\\', '/');
		System.out.println("excelPath: " + excelPath);
		
		excelTxml exceltxml = new excelTxml(excelPath);
		
		try {
			exceltxml.runexcel();
		} catch (Exception e) {
		    System.out.println("excelTxml 객체 호출 실패");
			e.printStackTrace();
		}*/
		
		
		// spec2xml-data.xlsm 에서 데이터 추출
		String manualPathStr = "C:\\Users\\SMC\\Desktop\\IMAGE\\230410\\";
        Path manualPath = Paths.get(manualPathStr);
        String excelPath = manualPath + "\\spec2xml-data.xlsm";
		
		excelSpecTxml excelSpecTxml = new excelSpecTxml(excelPath);
        
        try {
            excelSpecTxml.runexcel();
        } catch (Exception e) {
            System.out.println("excelTxml 객체 호출 실패");
            e.printStackTrace();
        }
		
	}

}
