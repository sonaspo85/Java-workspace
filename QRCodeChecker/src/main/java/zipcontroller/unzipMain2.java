package main.java.zipcontroller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveInputStream;
import org.apache.commons.compress.utils.IOUtils;

import main.java.CommonObj.implementOBJ;

public class unzipMain2 {
    implementOBJ obj = new implementOBJ(); 
    String curSrcPathStr = "";   
    String destFolder = "";
    
    public unzipMain2(String curSrcPathStr, String curfirstZipDirs) {
        this.curSrcPathStr = curSrcPathStr;
        destFolder = curfirstZipDirs + "\\";
    }
    
    public void unZipFile() throws Exception {
        System.out.println("unZipFile() 시작");
        
        File srcfile = new File(curSrcPathStr);
        String getDirs = srcfile.getParent();
        String getfileName = srcfile.getName().replace(".zip", ""); 
        
        FileInputStream fis;
        try {
            // 1. zip 파일을 입력 스트림으로 읽기
            fis = new FileInputStream(curSrcPathStr);
            BufferedInputStream bis = new BufferedInputStream(fis);
            ZipArchiveInputStream archive = new ZipArchiveInputStream(bis);

            ZipArchiveEntry entry;
            while ((entry = archive.getNextZipEntry()) != null) {
                // 2. zip 압축내 폴더 및 파일들의 각각의 목록들을 entry 변수에 할당 하고, null이 아닌 경우 
             
                // ZipEntry.DEFLATED is int 8
//                System.out.println(entry.getMethod()); 
                
                if(entry.isDirectory()) {
                    // 3. 압축 해제시 생성될 전체 폴더 경로 생성
                    File file = new File(destFolder + entry.getName());
                    String dir = file.toPath().toString().substring(0, file.toPath().toString().lastIndexOf("\\"));
                    File newDir = new File(dir + File.separator + entry);
                    
                    // 4. 폴더 생성
                    newDir.mkdirs();
                    
                } else {
                    File file = new File(destFolder + entry.getName());
//                    System.out.println("Unzipping - " + file);
                  // 5. 파일인 경우 zip 목록으로 부터  파일 출력 스트림을 활용하여 파일을 복사 시키기
                  IOUtils.copy(archive, new FileOutputStream(file));
                    
                }
                  
            }
            
            // 6. 스트림 닫기
            fis.close();
            bis.close();
            archive.close();
            
        } catch (Exception e1) {
            String msg = "zipDir 압축 해제 실패";
            throw new Exception(msg);
        }
        
        System.out.println("zipDir 압축 해제 완료!!");
       
    }
    
}
