package main.java.sonTEST.fileControl;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import main.java.commonObj.commonImpleObj;

public class ZipDirectories {
	public static commonImpleObj coj = new commonImpleObj();
	
	
	public static void zipDirectory() throws Exception {
		List<Path> zipDir = coj.zipDir; 
		
		zipDir.forEach(a -> {
			try {
				Path eachDir = a.toAbsolutePath();
				String chapName = a.getFileName().toString();
				String outZipPath = a + ".zip"; 
				
				FileOutputStream fos = new FileOutputStream(outZipPath);
		        ZipOutputStream zos = new ZipOutputStream(fos);
		        
		        // zip 확장자로 압축
		        zipSubDirectory("", eachDir, zos);
		        zos.close();
		        fos.close();
		        
		        
			} catch(Exception e1) {
				throw new RuntimeException(e1.getMessage());
				
			}

		});

    }
	
	// zip 확장자로 압축
	private static void zipSubDirectory(String basePath, Path dir, ZipOutputStream zos) throws IOException {
        byte[] buffer = new byte[4096];
        
        DirectoryStream<Path> ds = Files.newDirectoryStream(dir);
        
        ds.forEach(b -> {
        	try {
        		// 디렉토리인 경우
            	if(Files.isDirectory(b)) {
            		// 한번씩 돌때마다 basePath는 "" 에서 현재 디렉토리로 할당딤
            		String path = basePath + b.getFileName() + "/";
            		// 헌재 디렉토리를 새로운 zip 객체로 생성
                    ZipEntry ze = new ZipEntry(path);
                    
                    // 현재 zip 객체를 현재 데이터의 시작 부분에 스트림을 배치
                    zos.putNextEntry(ze);
                    
                    // 현재 디렉토리를 다시 재귀적 호출
                    zipSubDirectory(path, b, zos);
                    
                    // 현재 zip항목을 닫고 다음 zip 항목을 읽을수 있도록 스트림을 배치
                    zos.closeEntry();
                    
            	} else {
            		// 파일인 경우 FileInputStream 객체 생성
                    String is = b.toString(); 
                    FileInputStream fis = new FileInputStream(is); 
                    // 현재 파일 이름으로 ZipEntry 객체 생성
                    ZipEntry ze1 = new ZipEntry(basePath + b.getFileName());
                    
                    // 현재 zip 객체를 현재 데이터의 시작 부분에 스트림을 배치
                    zos.putNextEntry(ze1);
                    
                    int length;
                    
                    // FileInputStream 파일 입력 스트림을 read() 메소드로 읽기
                    while ((length = fis.read(buffer)) != -1) {
                        zos.write(buffer, 0, length);
                    }
                    
                    // 현재 zip항목을 닫고 다음 zip 항목을 읽을수 있도록 스트림을 배치
                    zos.closeEntry();
                    fis.close();
                    
            	}
            	
        	} catch(Exception e2) {
        		throw new RuntimeException(e2.getMessage());
        	}

        });
   
    }
	
	// zip 확장자를 idml로 변경
	public static void changeNdel() {
		try {
			String zipDir = coj.srcPath + "/zipDir";
//			String zipDir = "C:/Users/sonas/Desktop/Image/ddd/zipDir"; 
			Path path = Paths.get(zipDir);
		
			DirectoryStream<Path> ds = Files.newDirectoryStream(path);;
		
			ds.forEach(c -> {
				if(Files.isDirectory(c)) {
					coj.recursDel(c);
					
				} else { // zip 파일인 경우
					Path form = c;
					String getFileName = c.getFileName().toString().replace(".zip", ".idml");
					String tarPath = coj.srcPath + getFileName;
					Path to = Paths.get(tarPath);

					try {
						// zip 확장자 파일인 경우 파일 복사
						Files.copy(form, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
//						Files.delete(c);
						
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			});
			
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
}