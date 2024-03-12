package main.DITA.sourceController;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import main.DITA.Common.implementOBJ;

public class ZipDirectories {
    List<Path> zipDir = new ArrayList<>();
    implementOBJ obj = new implementOBJ();
    
    public List<Path> collectDirs(String idmlout) {
        System.out.println("collectDirs() 시작");
        
        
        Path path = Paths.get(idmlout);
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                zipDir.add(a);
                
            });
            
            
//            zipDirectory();
        } catch(Exception e) {
            
        }
        
        return zipDir;
        
    }
    
	public void zipDirectory(List<Path> zipDir) throws Exception {
	    System.out.println("zipDirectory() 시작");
		zipDir.forEach(a -> {
			try {
				Path eachDir = a.toAbsolutePath();
				String chapName = a.getFileName().toString();
				String outZipPath = a + ".zip"; 
				System.out.println("outZipPath11: " + outZipPath);
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
	public void changeNdel(String idmlout) {
	    System.out.println("changeNdel() 시작");
	    System.out.println("idmlout: " + idmlout);
	    Path path = Paths.get(idmlout);
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                if(Files.isRegularFile(a) & a.getFileName().toString().endsWith(".zip")) {
                    Path form = a;
                    String getDir = a.getParent().toString();
                    String getFileName = a.getFileName().toString().replace(".zip", ".idml");
                    String tarPath = getDir + File.separator + getFileName;
                    System.out.println("tarPath: " + tarPath);
                    
                    
                    Path to = Paths.get(tarPath);

                    try {
                        // zip 확장자 파일인 경우 파일 복사
                        Files.copy(form, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        
                        // zip 파일 삭제
                        Files.delete(a);
                        
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                   
                }                 
            });

            // idml 확장자로 바꾸고 나서 폴더는 삭제
            delDirs(idmlout);
            
        } catch(Exception e) {
            
        }

	}
	
	public void delDirs(String idmlout) {
	    System.out.println("delDirs() 시작");
	    
	    Path path = Paths.get(idmlout);
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                
                if(Files.isDirectory(a)) {
                    
                    try {
                        obj.recursDel(a);
                        
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                   
                }                 
            });
            
            
            
        } catch(Exception e) {
            
        }
	    
	    
	}
	
}