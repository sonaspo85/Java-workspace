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
    
    public unzipMain2(String srcPathStr) {
        this.srcPathStr = srcPathStr;
    }
    
    public void unZipFile() throws Exception {
        File srcfile = new File(srcPathStr);
        String getDirs = srcfile.getParent();
        String getfileName = srcfile.getName().replace(".zip", "");
        String destFolder = getDirs + File.separator + getfileName + File.separator;
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
                if(entry.isDirectory()) {
                    File file = new File(destFolder + entry.getName());
                    String dir = file.toPath().toString().substring(0, file.toPath().toString().lastIndexOf("\\"));
                    File newDir = new File(dir + File.separator + entry);
                    
                    newDir.mkdirs();
                    
                } else {
                    File file = new File(destFolder + entry.getName());
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
        
    }
    
}
