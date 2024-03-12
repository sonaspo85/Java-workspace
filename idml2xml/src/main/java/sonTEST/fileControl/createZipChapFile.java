package main.java.sonTEST.fileControl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import main.java.commonObj.commonImpleObj;

public class createZipChapFile {
	commonImpleObj coj = new commonImpleObj();
	boolean isChk = false;
	ZipOutputStream zos;
	
	
	public void runCreateZip() {
		List<Path> zipDir = new ArrayList<>();
		zipDir.addAll(coj.zipDir);
//		zipDir = Arrays.asList(
//			Paths.get("C:/Users/sonas/Desktop/Image/ddd/zipDir/001_Cover")
//			Paths.get("C:/Users/sonas/Desktop/Image/ddd/zipDir/002_TOC")
//			Paths.get("C:/Users/sonas/Desktop/Image/ddd/zipDir/003_Basics"),
//			Paths.get("C:/Users/sonas/Desktop/Image/ddd/zipDir/004_Applications"),
//			Paths.get("C:/Users/sonas/Desktop/Image/ddd/zipDir/005_Settings"),
//			Paths.get("C:/Users/sonas/Desktop/Image/ddd/zipDir/006_Appendix"),
//			Paths.get("C:/Users/sonas/Desktop/Image/ddd/zipDir/007_Copyright")
				
//		);
		
		zipDir.forEach(a -> {
			try {
				Path path = a.toAbsolutePath();
				File file = new File(path.toString());
				String fileName = a.getFileName().toString();
				System.out.println(fileName);
				String outZipPathName = a + ".zip";
				
				FileOutputStream fos = new FileOutputStream(outZipPathName);
		        ZipOutputStream zipOut = new ZipOutputStream(fos);
				
		        zipFile(path, fileName, zipOut);
//		        zipFile(path, "\\", zipOut);
		        zipOut.close();
		        fos.close();
		        
			} catch(Exception e1) {
				e1.printStackTrace();
			}
				
		});
		
		
	}
	
	public void zipFile(Path path, String fileName, ZipOutputStream zipOut) throws IOException {
        if (Files.isHidden(path)) {
            return;
        }
        
        if (Files.isDirectory(path)) {
            if (fileName.endsWith("/")) {
            	System.out.println("aaa: " + fileName);
                zipOut.putNextEntry(new ZipEntry(fileName));
                zipOut.closeEntry();
                
            } else {
            	System.out.println("bbb: " + fileName);
                zipOut.putNextEntry(new ZipEntry(fileName + "/"));
                zipOut.closeEntry();
            }
            
            
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(f -> {
            	Path path1 = f.toAbsolutePath();
            	String fileName1 = f.getFileName().toString();
            	try {
					zipFile(path1, fileName + File.separator + fileName1, zipOut);
            		
				} catch (IOException e) {
					e.printStackTrace();
				}
            });
            
            
            return;
        }
        
        FileInputStream fis = new FileInputStream(path.toString());  
        ZipEntry zipEntry = new ZipEntry(fileName);
        zipOut.putNextEntry(zipEntry);
        
        byte[] bytes = new byte[1024];
        int length;
        
        while ((length = fis.read(bytes)) >= 0) {
            zipOut.write(bytes, 0, length);
        }
        fis.close();
    }
}
