package main.DITA.sourceController;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;

import main.DITA.Common.implementOBJ;
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.exception.ZipException;

public class zipNunZipController {
    implementOBJ obj = new implementOBJ();
    File selectedExcelF = null;
    String excelDir = "";

    
    public zipNunZipController(File selectedExcelF) {
        this.selectedExcelF = selectedExcelF;
        excelDir = selectedExcelF.getParent();
        System.out.println("excelDir: " + excelDir);
    } 
    
    public void runZip(Path zipDirP) {
        System.out.println("runZip() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(zipDirP);
            
            ds.forEach(a -> {
                String fileName = a.getFileName().toString();

                if(Files.isDirectory(a)) {
                    runZip(a);
                    
                } else {
                    if(fileName.contains("start_here.html")) {
                        String fullPath = a.toAbsolutePath().toString();
                        String parPath = a.getParent().getFileName().toString();
                        System.out.println("parPath: " + parPath);
                        String newZipF = excelDir + File.separator + "D00_Html" + File.separator + parPath + ".zip"; 
                        System.out.println("newZipF: " + newZipF);
                        
                        try {
                            // zip으로 압출될 이름 지정
                            ZipFile zf = new ZipFile(newZipF);

                            // 압축할 파일 지정
                            zf.addFile(fullPath);
                            
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                    
                }
                
            });
             
            // 폴더 삭제
            delTempDir(zipDirP);
            
            
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }
    
    public void runMultiZip(Path zipDirP) {
        System.out.println("runMultiZip() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(zipDirP);
            
            ds.forEach(a -> {
                String fileName = a.getFileName().toString();
                String fullPath = a.toAbsolutePath().toString();
                String parPath = a.getParent().toString();
                String newZipF = parPath.concat(".zip");
                
                System.out.println("newZipF: " + newZipF);
                
                // zip으로 압출될 이름 지정
                ZipFile zf = new ZipFile(newZipF);
                
                
                if(Files.isDirectory(a)) {
                    try {
                        zf.addFolder(new File(fullPath));

                    } catch (ZipException e) {
                        e.printStackTrace();
                    }
                    
                } else {
                    try {
                        zf.addFile(new File(fullPath));
                        
                        
                    } catch (ZipException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                    
                }
                
            });
            
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    }
    
    public void delTempDir(Path zipDirP) {
        System.out.println("delTempDir() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(zipDirP);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {
                    delTempDir(a);
                    
                    try {
                        Files.delete(a);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    
                } else {
                    if(!a.toString().endsWith(".zip")) {
                        try {
                            Files.delete(a);
                            
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        
                    }

                }
                
            });
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
    }
    
    
}
