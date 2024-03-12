package xmlTExcel.runMain;

import java.nio.file.Path;
import java.nio.file.Paths;
 
 
public class xmlTexcel {
 
    public static void main(String[] args) {
//        String manualPathStr = "H:/DITA/Mobile/Bat/mobile-source";
        String manualPathStr = args[0];
        System.out.println("manualPathStr: " + manualPathStr);
        
        String ScriptDir = args[1];
        Path manualPath = Paths.get(manualPathStr);
        System.out.println("ScriptDir: " + ScriptDir);
        
//        String templateExcel = manualPath + "/xsls/skeleton.xlsx";
        String templateExcel = ScriptDir + "/xsls/skeleton.xlsx";
        
//        String dbFile = "H:/DITA/Mobile/Bat/mobile-source/out/ExcelDB.xml";
        String dbFile = manualPath + "/out/ExcelDB.xml";
        String outExcelPath = manualPath + "/out/skeleton.xlsx";
        
        dbFiles db = new dbFiles(templateExcel, dbFile, outExcelPath);
        try {
            db.runDbFiles();
            
        } catch(Exception e1) {
            System.out.println("에러 발생!!");
            e1.printStackTrace();
        }
        
        
        
    }
}