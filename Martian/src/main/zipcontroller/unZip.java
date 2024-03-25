package main.zipcontroller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import main.Common.implementOBJ;



public class unZip {
	implementOBJ obj = new implementOBJ();
    String msg = "";
    List<Path> zipList = new ArrayList<>(); 
	
	public unZip() {
		
	}
	
	public void runUnzip() {
		try {
			DirectoryStream<Path> ds = Files.newDirectoryStream(obj.zipDirP);
			ds.forEach(a -> {
				String fileName = a.getFileName().toString();
				
				// 확장자 추출
				int lastDot = fileName.lastIndexOf(".");
				String extension = fileName.substring(lastDot);
				
				try {
					// zip파일을 하나씩 로드
					FileInputStream fis = new FileInputStream(a.toString());
					Charset charset = Charset.forName("UTF-8");
					ZipInputStream zis = new ZipInputStream(fis, charset); 
					ZipEntry ze = zis.getNextEntry();
					
					while(ze != null) {
						// zip 파일 이름 추출
						String zeName = ze.getName();
						String nonExtFullPath = a.getParent() + File.separator + fileName.replace(extension, "");
						String newFiles = nonExtFullPath + File.separator + zeName;
						Path newDirPath = Paths.get(newFiles).getParent();
						Files.createDirectories(newDirPath);
						FileOutputStream fos = new FileOutputStream(newFiles);
						
						int length = 0;
						byte[] buffer = new byte[1024];
						
						while((length = zis.read(buffer)) != -1) {
                            fos.write(buffer, 0, length);
                        }

						fos.flush();
						fos.close();
						zis.closeEntry();
						ze = zis.getNextEntry();
					}
					
					zis.closeEntry();
					zis.close();
					fis.close();
					
					
					
				} catch(Exception e) {
					msg = "zipDir 내 zip 파일 압축 해제 실패";
		            throw new RuntimeException(msg);
				}
				

			});
			
			
			
		} catch(Exception e) {
			msg = "zipDir 내 zip 파일 압축 해제 실패";
            throw new RuntimeException(msg);
		}
		
	}
	
	
}
