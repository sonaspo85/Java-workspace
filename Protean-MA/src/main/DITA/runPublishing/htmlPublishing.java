package main.DITA.runPublishing;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

import main.DITA.Common.implementOBJ;
import main.DITA.processBuilder.ditareadPath;
import main.DITA.processBuilder.processBuilder;
import main.DITA.processBuilder.xsltreadPath;

public class htmlPublishing {
    implementOBJ obj = new implementOBJ();
    List <String> runList = new ArrayList<>();
    String sMapDir = "";
    String outMapDir = "";
    String pvPath = "";
    String strlb1 = "";
    String strcb4 = "";
    String idmlTempsDir = "";
    String msg = "";

    
    public htmlPublishing(Path sMapDir, String outMapDir, String pvPath, String strlb1, String strcb4) {
        this.sMapDir = sMapDir.toString();
        this.outMapDir = outMapDir;
        this.pvPath = pvPath;
        this.strlb1 = strlb1;
        this.strcb4 = strcb4;
    }


    public void runHtmlPublishing() {
        String inF = obj.libDir + File.separator + "z15-xslt-skeleton.xml";
        String switch1 = "html";
        xsltreadPath xsltreadPath = new xsltreadPath(sMapDir, outMapDir, pvPath, strlb1, inF, switch1);
        try {
            xsltreadPath.runReadPath(inF, switch1);
            runList = xsltreadPath.getPath();

            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();

        } catch (Exception e1) {
            msg = e1.getMessage();
            throw new RuntimeException(e1);
        }
    }
    
    public void runCreateHTML() {
        String switch1 = "dita";
        String inF = obj.libDir + File.separator + "z16-dita-html-publishing.xml";
        
        
        String transtype = "maHTML5";
        ditareadPath ditaPath = new ditareadPath(outMapDir, outMapDir, transtype, strlb1);
        
        try {
            ditaPath.runReadPath(inF, switch1);
            runList = ditaPath.getPath();
            
            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
        } catch (Exception e1) {
            msg = "z16 dita 변환 실패!!";
            throw new RuntimeException(e1);
        }
        
    }
    
    public void runExcelDB() {
        String inF = obj.libDir + File.separator + "z17-xslt-exceldb.xml";
        String switch1 = "xslt";
        xsltreadPath xsltreadPath = new xsltreadPath(sMapDir, outMapDir, pvPath, strlb1, inF, switch1);
        try {
            xsltreadPath.runReadPath(inF, switch1);
            runList = xsltreadPath.getPath();

            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();

        } catch (Exception e1) {
            msg = e1.getMessage();
            System.out.println("msg: " + msg);
            throw new RuntimeException(e1);
        }
    }
    
    public void runHtmlConvert() {
        String inF = obj.libDir + File.separator + "z18-xslt-html-convert.xml";
        String switch1 = "html";
        
        xsltreadPath xsltreadPath = new xsltreadPath(sMapDir, outMapDir, pvPath, strlb1, inF, switch1);
        try {
            xsltreadPath.runReadPath(inF, switch1);
            runList = xsltreadPath.getPath();
            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();

        } catch (Exception e1) {
            msg = e1.getMessage();
            throw new RuntimeException(e1);
        }
    }
    
    public void runTagsxml() {
        String inF = obj.libDir + File.separator + "z19-xslt-tagsxml.xml";
        String switch1 = "html";
        xsltreadPath xsltreadPath = new xsltreadPath(sMapDir, outMapDir, pvPath, strlb1, inF, switch1);
        
        try {
            xsltreadPath.runReadPath(inF, switch1);
            runList = xsltreadPath.getPath();

            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();

        } catch (Exception e1) {
            msg = e1.getMessage();
            throw new RuntimeException(e1);
        }
    }
    
    public void runUiText() {
        String inF = obj.libDir + File.separator + "z20-xslt-ui-text.xml";
        String switch1 = "html";
        xsltreadPath xsltreadPath = new xsltreadPath(sMapDir, outMapDir, pvPath, strlb1, inF, switch1);
        
        try {
            xsltreadPath.runReadPath(inF, switch1);
            runList = xsltreadPath.getPath();

            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();

        } catch (Exception e1) {
            msg = e1.getMessage();
            throw new RuntimeException(e1);
        }
    }
    
    public void copyHtmlTempls() {
        String newDirS = outMapDir + File.separator + "3_HTML" + File.separator + strlb1;
        Path newDirP = Paths.get(newDirS);

        String templsDirS = "";
        String templsTypeDirS = "";
        if(strlb1.matches("(ar-SA|he-IL|ur-PK)")) {
            System.out.println("RTL 복사 시작");
            templsDirS = obj.zDirhtmlTempls + File.separator + "RtoL";
            
            String newIconDirS = outMapDir + File.separator + "3_HTML" + File.separator + strlb1 + "/contents/images/number_icon";
            Path newIconDirP = Paths.get(newIconDirS);

            if(Files.notExists(newIconDirP)) {
                try {
                    Files.createDirectories(newIconDirP);
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
            
            String zhtmlTemps = "";
            if(strlb1.matches("(ar-SA|fa-IR|he-IL|ur-PK)")) {
                zhtmlTemps = obj.zDirhtmlTempls + File.separator + "_number_icon" + File.separator + strlb1;
                
                Path numbericonP = Paths.get(zhtmlTemps);
                try {
                    obj.dirCopy(newIconDirP, numbericonP);
                    
                    
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            
        } else {
            System.out.println("LTR 복사 시작");
            templsDirS = obj.zDirhtmlTempls + File.separator + "LtoR";

        }
        
        templsTypeDirS = obj.zDirhtmlTempls + File.separator + "type" + File.separator + strcb4;
        
        Path templsDirP = Paths.get(templsDirS);
        try {
            obj.dirCopy(newDirP, templsDirP);
            Path templsTypeDirP = Paths.get(templsTypeDirS);
            
            obj.dirCopy(newDirP, templsTypeDirP);
            
        } catch (Exception e) {
            System.out.println("html 폴더 복사 실패");
            e.printStackTrace();
        }
        
    }
    

}