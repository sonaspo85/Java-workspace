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
        System.out.println("runIdmltxml() 시작");
        
        // 파일 이름 에서 '[' 괄호 제거 하기
        idmlZipPath = rewriteDoc(idmlZipPath);
        
        String srcFile = idmlZipPath;
        Path srcPath = Paths.get(srcFile);
        
        obj.srcDir = srcPath.getParent().toString();
        
        // 파일 이름 추출 - 나중에 엑셀 파일 이름으로 사용할 예정
        String filename0 = srcPath.getFileName().toString();
        System.out.println("srcPath: " + srcPath);
        System.out.println("filename0: " + filename0);
        
        int lastIndex = filename0.lastIndexOf(".");
        String filename1 = filename0.substring(0, lastIndex).replace("_INDD", ""); 
        obj.srcFileName = filename1; 

        unZip unzip = new unZip(srcFile);
        CompressionUtil cu = new CompressionUtil();
        
        String srcUzipDirs = obj.srcDir + File.separator + filename0.substring(0, lastIndex);
        Path srcUzipPath = Paths.get(srcUzipDirs);
        obj.createNewDir(srcUzipPath);
        
        
        File in = new File(srcFile);
//        File out = new File(srcUzipDirs);
        
        
        System.out.println("srcFile: " + srcFile);
        
        unzipMain2 unzip2 = new unzipMain2(srcFile);
        // INDD.zip 파일 압축 해제 *****
        try {
            // 모든 idml 파일들을 압축하여 가지고있는 .zip 압축 풀기
//            cu.unzip(in, out);
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
        
        // 새로운 폴더로 복사한 zip 파일들을 압축 풀기 *****
        try {
            unzip.runLoop(newtarPath);
            
        } catch(Exception e3) {
            String msg = "idml 확장자를 zip으로 변경 실패";
            throw new Exception(msg);
        }
        
        // 압축 풀린 폴더를 xslt로 처리 *****
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
    	System.out.println("rewriteDoc() 시작");
    	
    	File oriIdmlZip = new File(srcPath);
    	String oriIdmlZipStr = oriIdmlZip.toString();
    	System.out.println("oriIdmlZip: " + oriIdmlZip);
    	
    	String parDirs = oriIdmlZip.getParent();
    	System.out.println("parDirs: " + parDirs);
    	
    	String fileName = oriIdmlZip.getName();
    	fileName = fileName.replace("[", "").replace("]", "_").replace("__", "_");
    	System.out.println("fileName: " + fileName);
    	
    	 
//    	String oriIdmlZipStr1 = oriIdmlZipStr.replace("[", "").replace("]", "_");
    	String newIdmlZipStr = parDirs + File.separator + fileName;
    	System.out.println("newIdmlZipStr: " + newIdmlZipStr);
    	
    	File newZipF = new File(newIdmlZipStr);
    	boolean result = oriIdmlZip.renameTo(newZipF);
    	System.out.println("결과: " + result + " 파일 이름 변경 완료");
    	
    	return newZipF.toString();
    }
    
}
