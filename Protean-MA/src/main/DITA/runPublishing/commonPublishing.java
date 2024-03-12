package main.DITA.runPublishing;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import main.DITA.Common.implementOBJ;
import main.DITA.processBuilder.ditareadPath;
import main.DITA.processBuilder.processBuilder;
import main.DITA.processBuilder.xsltreadPath;

public class commonPublishing {
    implementOBJ obj = new implementOBJ();

    String msg = "";
    
    Path sMapDir = null;
    String outMapDir = "";
    public String strlb1 = "";
    String pvPath = "";
    public String strcb1 = "";
    String strcb2 = "";
    String strcb3 = "";
    String strcb4 = "";
    
    xsltreadPath xsltreadPath = null;
    
    public commonPublishing(Path sMapDir, String outMapDir, String pvPath, String strcb2, String strcb3, String strcb4) {
    	this.sMapDir = sMapDir;
    	this.outMapDir = outMapDir;
    	this.pvPath = pvPath;
    	this.strcb2 = strcb2;
    	this.strcb3 = strcb3;
    	this.strcb4 = strcb4;
    	 
    }
    
    
    
    public void runMerged(String strcb1, String  strlb1) {
        System.out.println("runMerged() 시작");
        
        this.strcb1 = strcb1;
        this.strlb1 = strlb1;
        
        String inF = obj.libDir + File.separator + "z1-dita-merged.xml";
        
        String switch1 = "dita";
        String transtype = "merged";
        ditareadPath ditaPath = new ditareadPath(sMapDir.toString(), outMapDir, transtype, strlb1);
        try {
            ditaPath.runReadPath(inF, switch1);
            List<String> runList = ditaPath.getPath();
            
            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
        } catch (Exception e1) {
            msg = "z1 dita 변환 실패!!";
            System.out.println("msg: " + msg);
            throw new RuntimeException(e1);
        }
        
    }
    
    public void runMaster() {
        System.out.println("runMaster() 시작");
        String inF = obj.libDir + File.separator + "z2-0-xslt-final-master.xml";
        
        String switch1 = "xslt";
        
        // xsltreadPath 초기화
        xsltreadPath = new xsltreadPath(sMapDir.toString(), outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
        try {
            xsltreadPath.runReadPath(inF, switch1);
            List<String> runList = xsltreadPath.getPath();
            
            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
        } catch (Exception e1) {
//          msg = "z2 dita 변환 실패!!";
            msg = e1.getMessage();
            System.out.println("msg: " + msg);
            throw new RuntimeException(e1);
//          e1.printStackTrace();
        }
        
    }
    
    public void runTargetxsl() {
        System.out.println("runTargetxsl() 시작");
        
        String inF = obj.libDir + File.separator + "z2-1-xslt-target.xml";
        
        String switch1 = "xslt";
        xsltreadPath xsltreadPath = new xsltreadPath(sMapDir.toString(), outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
        try {
            xsltreadPath.runReadPath(inF, switch1);
            List<String> runList = xsltreadPath.getPath();
            
            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
        } catch (Exception e1) {
            msg = e1.getMessage();
            System.out.println("msg: " + msg);
            throw new RuntimeException(e1);
        }
    }
    
    public void runFinalLangxsl() {
        System.out.println("runFinalLangxsl() 시작");
        
        String inF = obj.libDir + File.separator + "z10-xslt-final-lang.xml";
        
        String switch1 = "xslt";
        xsltreadPath xsltreadPath = new xsltreadPath(sMapDir.toString(), outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
        try {
            xsltreadPath.runReadPath(inF, switch1);
            List<String> runList = xsltreadPath.getPath();
            
            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
        } catch (Exception e1) {
            msg = e1.getMessage();
            System.out.println("msg: " + msg);
            throw new RuntimeException(e1);
        }
    }
    
    
    public void finishMovePDF(String pdfPath) {
        System.out.println("finishMovePDF() 시작");
        
//        String oldPDFS = outMapDir + File.separator + "master-final.pdf";
//        String oldPDFS = outMapDir + File.separator + "final-" + strlb1 + ".pdf";
        String newPDFS = outMapDir + File.separator + "1_PDF" + File.separator + strlb1 + File.separator + strlb1 + ".pdf";  
        
        Path oldPDFP = Paths.get(pdfPath);
        Path newPDFP = Paths.get(newPDFS);
        Path newPDFDir = Paths.get(newPDFS).getParent();
        
        try {
            // 폴더 생성
            Files.createDirectories(newPDFDir);
            
            // 파일 이름 변경 및 이동
            Files.move(oldPDFP, newPDFP);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
    }
    
    public void setOutdir() throws Exception {
        System.out.println("setOutdir() 시작");
        
        Path outmapdir = Paths.get(outMapDir);
        
        if(Files.isDirectory(outmapdir)) {
            System.out.println("폴더 존재, 폴더 삭제!!");
            
            try {
                obj.recursDel(outmapdir);
                Files.createDirectories(outmapdir);
                
            } catch (Exception e1) {
                msg = "out 폴더 삭제 실패, 다른 프로그램이 out 폴더를 사용하고 있습니다.";
                System.out.println("msg: " + msg);
                throw new RuntimeException(msg);
            }
            
        } else {
            System.out.println("폴더 없음, 폴더 생성!!");
            try {
                Files.createDirectories(outmapdir);
                
            } catch (IOException e) {
                msg = "out 폴더 삭제 실패, 다른 프로그램이 out 폴더를 사용하고 있습니다.";
                System.out.println("msg: " + msg);
                throw new RuntimeException(msg);
            }
        }
    }
    
    
    
    
}
