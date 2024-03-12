package main.java.sonTEST.fileControl;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import main.java.commonObj.commonImpleObj;

public class idmlControl {
	commonImpleObj coj = new commonImpleObj();
	String manualPath = "";
	Path srcPath;
	Path newPath;
	
	public idmlControl(String manualPath) {
		this.manualPath = manualPath;
		
	}
	
	public void defaultSet() {
		System.out.println("defaultSet() 시작");
//		manualPath ="C:\\Users\\SMC\\Desktop\\IMAGE\\vvv\\idml\\";
		coj.srcPath = manualPath;

		srcPath = Paths.get(manualPath);
		System.out.println("srcPath: " + srcPath);
		// zipDir, xml 폴더가 존재하면 삭제
		delZipXmlPath(srcPath);
	}
	
	public void delZipXmlPath(Path srcPath) {
		System.out.println("delZipXmlPath() 시작");
		try {
			DirectoryStream<Path> ds = Files.newDirectoryStream(srcPath);
			
			ds.forEach(c -> {
				String fileName = c.getFileName().toString();
//				System.out.println("fileName: " + fileName);
						
				if(Files.isDirectory(c) && !fileName.contains("_Links")) {
					coj.recursDel(c);
				}
			});
			
		} catch(Exception e5) {
			e5.printStackTrace();
		}
		
	}
	
	public Path createNewDir() {
		System.out.println("createNewDir 시작");
		try {
			String newDir = srcPath + "/zipDir";
			newPath = Paths.get(newDir);
			
			if(Files.notExists(newPath)) {
				Files.createDirectories(newPath);
				System.out.println("디렉토리 생성 완료");
				
			} else {  // 폴더가 존재 한다면 재귀적 삭제 후, 폴더 재생성
				coj.recursDel(newPath);
				Files.createDirectories(newPath);
			}
			
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return newPath;
	}
	
	public void loopFiles() {
		System.out.println("loopFiles() 시작");
		
		// idml 디렉토리가 존재 한다면
		if(Files.exists(srcPath)) {
			try {
				DirectoryStream<Path> ds = Files.newDirectoryStream(srcPath);
				
				ds.forEach(a -> {
					if(Files.isRegularFile(a)) {  // 파일이라면
						String fileName = a.getFileName().toString();
						
						// 파일 확장자 추출
						int lastDot = fileName.lastIndexOf(".");
						String extension = fileName.substring(lastDot);
						
						// 새로운 zip 파일명 생성
						String newZipFile = fileName.replace(extension, ".zip");
						Path tarPath = Paths.get(newPath.toString() + File.separator + newZipFile);
						
						// 새로운 폴더로 idml을 zip으로 복사
						copyFiles(a, tarPath);

					}
				});
				
				// zip 파일 삭제
//	            if(zipList.size() > 1) {
//	                deleteZip();
//	            }
				
			} catch (IOException e) {
				e.printStackTrace();
				System.out.println("디렉토리내 목록 없음");
			}
		}

	}
	
	// 새로운 폴더로 idml을 zip으로 복사
	public void copyFiles(Path a, Path tarPath) {
		try {
			Files.copy(a, tarPath, StandardCopyOption.REPLACE_EXISTING);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

}

