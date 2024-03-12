package main.idmlcontroller;

import java.io.File;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;

import main.Common.implementOBJ;



public class changeExtIdmltZip {
    implementOBJ obj = new implementOBJ();
    String msg = "";
    public Map<String, String> isocurpath = new HashMap<>();
    
    
    public changeExtIdmltZip() {
        
    }
    
    public void loopIdml() {
        System.out.println("loopIdml() 시작");
        
        obj.srcDirFullpath.forEach(c -> {
            String fullpath = c.toAbsolutePath().toString();
            System.out.println("fullpath: " + fullpath);
            
            
            // idml 디렉토리가 존재 한다면 루프
            if(Files.exists(c)) {
                try {
                    DirectoryStream<Path> ds = Files.newDirectoryStream(c);
                    
                    ds.forEach(a -> {
                        String fileName = a.getFileName().toString();
                        
                        
                        if(Files.isRegularFile(a) && fileName.endsWith(".idml")) {
                            setisocurpath(a);
                            
                            // 확장자 추출
                            int lastDot = fileName.lastIndexOf(".");
                            String extension = fileName.substring(lastDot);
//                            System.out.println("extension: " + extension);
                            
                            // zip 확장자로 이름 변경
                            String newIdmlZipF = fileName.replace(extension, ".zip");
                            Path idmlZipP = Paths.get(obj.zipDirP + File.separator + newIdmlZipF);
//                            System.out.println("idmlZipP: " + idmlZipP.toString());

                            // zipDir 폴더로 zip 확장자로 변경한 후 파일 복사
                            copyFiles(a, idmlZipP);

                        }
                        
                    });
                    
                } catch(Exception e) {
                    msg = "idml 폴더 읽기 실패";
                    System.out.println("msg: " + msg);
                    throw new RuntimeException(msg);
                }
            }
            
        });
        
    }
    
    public void setisocurpath(Path a) {
        System.out.println("setisocurpath() 시작");
        
        String fullpath = a.toAbsolutePath().toString();
        String srcDirS = obj.srcPathP.toAbsolutePath().toString();
        
        String getTxt = fullpath.replace(srcDirS, "").replaceAll("^[\\\\]", "").replace(".idml", "");
        String[] splitTxt = getTxt.split("\\\\");
        
        isocurpath.put(splitTxt[1], splitTxt[0]);
        
    }
    
    public void copyFiles(Path a, Path idmlZipP) {
        System.out.println("copyFiles() 시작");
        
        try {
            Files.copy(a, idmlZipP, StandardCopyOption.COPY_ATTRIBUTES, StandardCopyOption.REPLACE_EXISTING);
            
            
        } catch(Exception e) {
            msg = "idml 파일 zipDir 폴더로 복사 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
            
        }
        
    }
    
    
}
