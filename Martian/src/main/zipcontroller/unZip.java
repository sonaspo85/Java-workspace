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
		System.out.println("runUnzip() 시작");
		System.out.println("obj.zipDirP: " + obj.zipDirP);
		
		try {
			DirectoryStream<Path> ds = Files.newDirectoryStream(obj.zipDirP);
			ds.forEach(a -> {
				String fileName = a.getFileName().toString();
//				System.out.println("aaa: " + a);
//				zipList.add(a);
				
				// 확장자 추출
				int lastDot = fileName.lastIndexOf(".");
				String extension = fileName.substring(lastDot);
				
				try {
					// zip파일을 하나씩 읽기
					FileInputStream fis = new FileInputStream(a.toString());
					Charset charset = Charset.forName("UTF-8");
					ZipInputStream zis = new ZipInputStream(fis, charset); 
					
					// zip 항목을 읽어 데이터의 시작 부분에 스트림 배치
					ZipEntry ze = zis.getNextEntry();
					
					while(ze != null) {
						// zip 파일 이름 추출
						String zeName = ze.getName();
						
						// zip 파일내 파일 및 폴더를 새로운 폴더를 생성 한 후, 그 폴더내로 복사 시키기
						String nonExtFullPath = a.getParent() + File.separator + fileName.replace(extension, "");
						String newFiles = nonExtFullPath + File.separator + zeName;
//						System.out.println("newDirs: " + nonExtFullPath);
						
						// 새로운 디렉토리로 파일들을 저장하기 위해 먼저 zip 파일내의 디렉토리를 확인 하여 로컬 경로에 디렉토리 먼저 생성 하기
						Path newDirPath = Paths.get(newFiles).getParent();
						
						// 새로운 디렉토리에 폴더 생성 하기
						Files.createDirectories(newDirPath);
						
						// 디렉토리를 생성 하였으니, 파일을 읽어, 새로운 디렉토리로 복사 하기
						FileOutputStream fos = new FileOutputStream(newFiles);
						
						int length = 0;
						byte[] buffer = new byte[1024];
						
						// 파일내 데이터를 읽는데 끝까지 읽을때까지 반복
						while((length = zis.read(buffer)) != -1) {
                            fos.write(buffer, 0, length);
                        }

						fos.flush();
						fos.close();
						
						// 현재 zip 항목을 닫고 다음 항목을 읽일수 있도록 스트림을 배치
						zis.closeEntry();
						
						// 다음 zip 항목을 읽고, 데이터의 시작 부분에 스트림을 배치
						ze = zis.getNextEntry();
					}
					
					// 현재 zip 파일의 모든 목록을 읽고 새로운 폴더로 복사가 끝난 경우 현재 zip 파일 닫기
					zis.closeEntry();
					zis.close();
					fis.close();
					
					
					
				} catch(Exception e) {
					msg = "zipDir 내 zip 파일 압축 해제 실패";
		            System.out.println("msg: " + msg);
		            throw new RuntimeException(msg);
				}
				

			});
			
			
			
		} catch(Exception e) {
			msg = "zipDir 내 zip 파일 압축 해제 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
		}
		
	}
	
	
}
