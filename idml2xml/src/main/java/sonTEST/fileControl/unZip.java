package main.java.sonTEST.fileControl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import main.java.commonObj.commonImpleObj;

public class unZip {
	Path zipPath;
	List<Path> zipList = new ArrayList<>();
	static int pos = 0;
	commonImpleObj coj = new commonImpleObj();
	
	
	public unZip(Path newDir) {
		this.zipPath = newDir;
		
	}
	
	public void runUnZip() {
		System.out.println("runUnZip 시작");
		
		try {
			DirectoryStream<Path> ds = Files.newDirectoryStream(zipPath);
			
			ds.forEach(a -> {
				String fileName = a.getFileName().toString(); 
				zipList.add(a);
				// 확장자 추출
				int lastDot = fileName.lastIndexOf(".");
				String extension = fileName.substring(lastDot);
				
				FileInputStream fis;
				try {
					fis = new FileInputStream(a.toString());
					
					Charset charset = Charset.forName("UTF-8");

					// ZipInputStream을 사용하여 zip 파일 읽기
					ZipInputStream zis = new ZipInputStream(fis, charset);
					
					try {
						// 다음 zip 항목을 읽어 데이터의 시작 부분에 스트림을 배치 
						ZipEntry ze = zis.getNextEntry();
						
						while(ze != null) {
							// zip 파일의 이름 추출
							String zeName = ze.getName(); 
							Path parentDirs = zipPath.getParent();
							
							// zip 파일을 unzip하여 새롭게 저장될 디렉토리로 출력하기 위해 fullPath 생성
							String newDirs = a.getParent() + File.separator + fileName.replace(extension, "") + File.separator + zeName;
							
							// 새로운 디렉토리내 각 파일들을 저장하기 위해 먼저 하위 디렉토리 생성
							Path newDirsPath = Paths.get(newDirs).getParent();
							
							// zip목록내 하위 디렉토리 생성
							Files.createDirectories(newDirsPath);
//							
							// 파일 출력 스트림
							FileOutputStream fos = new FileOutputStream(newDirs);
							
							int length;
							byte[] buffer = new byte[1024];
							
							// 데이터를 끝에 도달할때까지 반복
							while((length = zis.read(buffer)) != -1) {
								fos.write(buffer, 0, length);
							}
							
							fos.flush();
							fos.close();
							
							// 현재 파일의 목록을 데이터 끝까지 추출 완료 했으므로, 
							// 현재 목록을 닫고 다음 목록 읽기
							// closeEntry(): 현재 zip 항목을 닫고, 다음 항목을 읽을수 있도록 스트림을 배치
							zis.closeEntry();
							
							// 다음 zip 항목을 읽고, 데이터의 시작 부분에 스트림을 배치 
							ze = zis.getNextEntry();
						}
						
						// zip 파일의 모든 목록을 읽고 작업이 모두 완료된 경우 현재 zip 파일 닫기
						zis.closeEntry();
						zis.close();
						fis.close();
						
						
					} catch (IOException e) {
						e.printStackTrace();
					}
					
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} 

			});
			
			// zip 파일 삭제
			if(zipList.size() > 1) {
				deleteZip();
			}
			coj.zipDir = zipList;
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	public void deleteZip() {
		System.out.println("deleteZip 시작");
		
		zipList.forEach(a -> {
			try {
				String changeList = a.toString().replace(".zip", "");
				Path path = Paths.get(changeList);
				zipList.set(pos, path);
				Files.delete(a);
				
			} catch (IOException e) {
				e.printStackTrace();
			}
			pos++;
		});
	}
	
}
