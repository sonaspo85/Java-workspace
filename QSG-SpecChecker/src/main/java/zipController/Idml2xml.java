package main.java.zipController;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

import main.java.zipController.Common.implementOBJ;

public class Idml2xml {
    implementOBJ obj = new implementOBJ();
    String idmlZipPath = "";
    
    public Idml2xml(String idmlZipPath) {
        this.idmlZipPath = idmlZipPath;
    }
    
    public void runIdmltxml() throws Exception {
        idmlZipPath = rewriteDoc(idmlZipPath);
        String srcFile = idmlZipPath;
        Path srcPath = Paths.get(srcFile);
        obj.srcDir = srcPath.getParent().toString();
        
        // 파일 이름 추출
        String filename0 = srcPath.getFileName().toString();
        
        int lastIndex = filename0.lastIndexOf(".");
        String filename1 = filename0.substring(0, lastIndex).replace("_INDD", ""); 
        obj.srcFileName = filename1; 

        unZip unzip = new unZip(srcFile);
        CompressionUtil cu = new CompressionUtil();
        
        String srcUzipDirs = obj.srcDir + File.separator + filename0.substring(0, lastIndex);
        Path srcUzipPath = Paths.get(srcUzipDirs);
        obj.createNewDir(srcUzipPath);
        File in = new File(srcFile);
        unzipMain2 unzip2 = new unzipMain2(srcFile);
        try {
            // 모든 idml 파일들을 압축하여 가지고있는 .zip 압축 해제
            unzip2.unZipFile();
            
        } catch(Exception e1) {
            String msg = "~INDD.zip 압축 해제에 실패 하였습니다. \nidml 파일 포함 여부 확인 해주세요.";
            throw new Exception(msg);
        }
        
        // idml 확장자를 zip으로 변경 *****
        String newtarPath ="";

        try {
            newtarPath = unzip.changeExt();
            
        } catch(Exception e2) {
            String msg = "idml 확장자를 zip으로 변경 실패";
            throw new Exception(msg);
        }
        
        // 새로운 폴더로 복사한 zip 파일들을 압축 해제
        try {
            unzip.runLoop(newtarPath);
            
        } catch(Exception e3) {
            String msg = "idml 확장자를 zip으로 변경 실패";
            throw new Exception(msg);
        }
        
        // 압축 풀린 폴더를 xslt로 처리
        try {
            transformXSLT tf = new transformXSLT(newtarPath);
            tf.runIDML2xml();
            
        } catch(Exception e4) {
            String msg = "압축 풀린 폴더를 xslt로 처리 실패";
            throw new Exception(msg);
        }
        
        // @region 추출 하기
        readMergedF rmf = new readMergedF();
        rmf.runReadMergedF();

    }
    
    public String rewriteDoc(String srcPath) {
    	File oriIdmlZip = new File(srcPath);
    	String oriIdmlZipStr = oriIdmlZip.toString();
    	String parDirs = oriIdmlZip.getParent();
    	String fileName = oriIdmlZip.getName();
    	fileName = fileName.replace("[", "").replace("]", "_").replace("__", "_");
    	String newIdmlZipStr = parDirs + File.separator + fileName;
    	File newZipF = new File(newIdmlZipStr);
    	boolean result = oriIdmlZip.renameTo(newZipF);
    	
    	return newZipF.toString();
    }
    
}
