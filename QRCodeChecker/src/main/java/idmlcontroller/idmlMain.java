package main.java.idmlcontroller;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import main.java.CommonObj.implementOBJ;

public class idmlMain {
    implementOBJ obj = new implementOBJ(); 
    Path srcZipPath = null;
    Path newPath = null;  // zipDir 경로
    
    public Path getIdml2Zip() {
        System.out.println("getIdml2Zip() 시작");
        // idml 파일을 zip 으로 확장자 변경후 저장될 새로운 경로
        newPath = Paths.get(obj.curFirstZipDirs + "/zipDir");
        System.out.println("newPath: " + newPath);
        // zip 파일이 저장될 새로운 경로 생성
        try {
            obj.createNewDir(newPath);
            
        } catch (Exception e1) {
            System.out.println("zip 폴더 생성 실패");
            e1.printStackTrace();
        }
        
        // idml 폴더 접근
        srcZipPath = Paths.get(obj.curFirstZipDirs);
        
        DirectoryStream<Path> ds;
        try {
            ds = Files.newDirectoryStream(srcZipPath);
            
            ds.forEach(a -> {
                String fileName = a.getFileName().toString();
                
                // 디렉토리일 경우 
                if(Files.isDirectory(a)) {

                } else {  // 파일인 경우
                    if(fileName.contains(".idml")) {
                        // 확장자 변경 프로세스
                        int lastDot = fileName.lastIndexOf(".");
                        String extension = fileName.substring(lastDot);
                        
                        // 새로운 zip 파일명 생성
                        String newZipFile = fileName.replace(extension, ".zip");
                        
                        // 새로운 폴더 디렉토리 지정
                        Path tarPath = Paths.get(newPath + File.separator + newZipFile);
                        
                        // 새로운 폴더에 idml 파일을 zip 으로 변경하여 복사해서 넣기
                        copyFiles(a, tarPath);
                                    
                    }
                    
                }
                
            });
            
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        
        return newPath;

    }
    
    public void copyFiles(Path a, Path tarPath) {
        System.out.println("copyFiles() 시작");
        
        try {
            Files.copy(a, tarPath, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);

        } catch(Exception e) {
            System.out.println("idml 파일을 zip 확장자 변경 후 복사 실패");
            e.printStackTrace();
        }

    }
        
}
