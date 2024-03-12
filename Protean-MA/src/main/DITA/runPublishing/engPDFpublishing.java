package main.DITA.runPublishing;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import main.DITA.Common.implementOBJ;
import main.DITA.processBuilder.ditareadPath;
import main.DITA.processBuilder.processBuilder;

public class engPDFpublishing {
    implementOBJ obj = new implementOBJ();
    List<String> runList = new ArrayList<>();
    String msg ="";
    
    public void runCreateEngPDF(String outMapDir, String strlb1) {
        System.out.println("runCreateEngPDF() 시작");
        
        String switch1 = "dita";
        String inF = obj.libDir + File.separator + "z3-dita-outPDF.xml";
        
        
        String transtype = "protean_ma_um_en_2020pdf";
        ditareadPath ditaPath = new ditareadPath(outMapDir, outMapDir, transtype, strlb1);
        
        try {
            ditaPath.runReadPath(inF, switch1);
            runList = ditaPath.getPath();
            
            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
        } catch (Exception e1) {
            msg = "z3 dita 변환 실패!!";
            System.out.println("msg: " + msg);
            throw new RuntimeException(e1);
        }
        
    }
}
