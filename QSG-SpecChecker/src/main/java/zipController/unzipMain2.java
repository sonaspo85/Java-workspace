package main.java.zipController;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveInputStream;
import org.apache.commons.compress.utils.IOUtils;

import main.java.zipController.Common.implementOBJ;

public class unzipMain2 {
    implementOBJ obj = new implementOBJ(); 
    String srcPathStr = "";   
//    String destFolder = "";
    
    public unzipMain2(String srcPathStr) {
        this.srcPathStr = srcPathStr;
//        destFolder = srcPathStr + File.separator + "out/";
    }
    
    public void unZipFile() throws Exception {
        System.out.println("unZipFile() 시작");
        
        File srcfile = new File(srcPathStr);
        String getDirs = srcfile.getParent();
        System.out.println("getDirs: " + getDirs);
        String getfileName = srcfile.getName().replace(".zip", "");
        System.out.println("getfileName: " + getfileName);
        
        String destFolder = getDirs + File.separator + getfileName + File.separator;
        System.out.println("destFolder: " + destFolder);
        
        Path destPath = Paths.get(destFolder);
        obj.createNewDir(destPath);
        
        // Create zip file stream.
        FileInputStream fis;
        try {
            fis = new FileInputStream(srcPathStr);
            System.out.println("srcPathStr: " + srcPathStr);
            BufferedInputStream bis = new BufferedInputStream(fis);
            ZipArchiveInputStream archive = new ZipArchiveInputStream(bis);

            ZipArchiveEntry entry;
            while ((entry = archive.getNextZipEntry()) != null) {
                // Print values from entry.
//                System.out.println(entry.getName());
//                System.out.println(entry.getMethod()); // ZipEntry.DEFLATED is int 8
                if(entry.isDirectory()) {
//                    System.out.println("entry: " + entry);
                    File file = new File(destFolder + entry.getName());
                    String dir = file.toPath().toString().substring(0, file.toPath().toString().lastIndexOf("\\"));
//                    System.out.println("dir: " + dir);
                    File newDir = new File(dir + File.separator + entry);
                    System.out.println("newDir: " + newDir);
                    newDir.mkdirs();
                    
                } else {
                    File file = new File(destFolder + entry.getName());
                    System.out.println("Unzipping - " + file);
                  // Stream file content
                  IOUtils.copy(archive, new FileOutputStream(file));
                    
                }
                  
            }
            
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
