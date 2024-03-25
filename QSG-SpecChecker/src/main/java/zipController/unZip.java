package main.java.zipController;
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
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import main.java.zipController.Common.implementOBJ;


public class unZip {
    String srcFile = "";
    String getParent = "";
    String getFileName = "";
    String containIDMLPath = "";
    String msg ="";
    Path newtarPath = null;
    int pos = 0;
    List<Path>zipList = new ArrayList<>();
    public Charset charset = Charset.forName("UTF-8");
    implementOBJ obj = new implementOBJ();
    
    public unZip(String srcFile) {
        this.srcFile = srcFile;
        // 파일의 경로 추출
        File file = new File(srcFile);
        getParent = file.getParent();
        getFileName = file.getName().replace(".zip", "");
        containIDMLPath = getParent + File.separator + getFileName;
    }
    
    public void runUnzip(String srcFile) throws Exception {
        System.out.println("runUnzip() 시작");
        System.out.println("getFileName: " + getFileName);
        FileInputStream fis;
        ZipInputStream zis;
        
        try {
            // 파일 입력 스트림으로 파일 읽기
            fis = new FileInputStream(srcFile);
            zis = new ZipInputStream(fis, charset);
            
        } catch (FileNotFoundException e) {
            String msg = ".zip 파일 읽기 실패";
            throw new Exception(msg);
        }
        
        try {
            ZipEntry ze = zis.getNextEntry();
            
            while (ze != null) {
                String zeName = ze.getName();
                
                if (ze.isDirectory() | zeName.contains(".png") | zeName.contains(".ai") | zeName.contains(".pdf") | zeName.contains(".indd") | zeName.contains("TOC") | zeName.contains("Eng(LTN)")) {
                    ze = zis.getNextEntry();
                    
                } else if (zeName.contains(".idml")) {
                    // zip 파일을 unzip 하여 새롭게 저장될 디렉토리로 출력하기 위해 fullPath 생성
                    String newDirs0 = getParent + File.separator + getFileName + File.separator + zeName;
                    Path newDirPath = Paths.get(newDirs0).getParent();
                    
                    Files.createDirectories(newDirPath);

                    // 파일 출력 스트림
                    FileOutputStream fos = new FileOutputStream(newDirs0);
                    
                    int length;
                    byte[] buffer = new byte[2024];
                    
                    while ((length = zis.read(buffer)) != -1) {
                        fos.write(buffer, 0, length);
                    }
                    
                    fos.flush();
                    fos.close();
                    zis.closeEntry();
                    ze = zis.getNextEntry();
                }
            }
            
            zis.closeEntry();
            zis.close();
            fis.close();
            
        } catch (Exception e1) {
            msg = "zip 파일 데이터 읽기 에러";
            throw new Exception(msg);
        }
    }
    
    public String changeExt() throws Exception {
        Path getIdmlPath = Paths.get(containIDMLPath);
        String newDir = getIdmlPath + "/zipDir";
        Path newPath = Paths.get(newDir);
        obj.createNewDir(newPath);
        
        try {
            DirectoryStream <Path> ds = Files.newDirectoryStream(getIdmlPath);
            ds.forEach(c -> {
                String fileName = c.getFileName().toString();
                if (Files.isRegularFile(c) & fileName.contains(".idml")) {
                    System.out.println("fileName: " + fileName);
                    // 파일 확장자 추출
                    int lastDot = fileName.lastIndexOf(".");
                    String extenstion = fileName.substring(lastDot);
                    String newZipFile = fileName.replace(extenstion, ".zip");
                    newtarPath = Paths.get(newPath.toString() + File.separator + newZipFile);
                    copyFiles(c, newtarPath);
                    
                }
            });
            
        } catch (IOException e) {
            msg = "unzip된 idml 폴더 탐색 실패";
            throw new Exception(msg);
        }
        return newtarPath.getParent().toString();
    }
        
    // 새로운 폴더로 idml을 zip으로 복사
    public void copyFiles(Path c, Path newtarPath) {
        try {
            Files.copy(c, newtarPath, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
            
        } catch (Exception e) {
            msg = "새로운 폴더로 zip 파일 복사 실패";
            return;
        }
    }
    
    public void runLoop(String newtarPath) throws Exception {
        Path path = Paths.get(newtarPath);
        
        if (Files.exists(path)) {
            try {
                DirectoryStream <Path> ds = Files.newDirectoryStream(path);
                
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

                        // ZipInputStream을 사용하여 zip 파일 로드
                        ZipInputStream zis = new ZipInputStream(fis, charset);
                        
                        try {
                            ZipEntry ze = zis.getNextEntry();
                            
                            while (ze != null) {
                                // zip 파일의 이름 추출
                                String zeName = ze.getName();
                                Path parentDirs = path.getParent();
                                String newDirs = a.getParent() + File.separator + fileName.replace(extension, "") + File.separator + zeName;
                                Path newDirsPath = Paths.get(newDirs).getParent();
                                Files.createDirectories(newDirsPath);
                                FileOutputStream fos = new FileOutputStream(newDirs);
                                
                                int length;
                                byte[] buffer = new byte[1024];
                                while ((length = zis.read(buffer)) != -1) {
                                    fos.write(buffer, 0, length);
                                }
                                
                                fos.flush();
                                fos.close();
                                zis.closeEntry();
                                ze = zis.getNextEntry();
                            }
                            
                            // zip 작업이 모두 완료된 경우 zip 파일 닫기
                            zis.closeEntry();
                            zis.close();
                            fis.close();
                            
                        } catch (Exception e) {
                            msg = "unzip된 idml 폴더 탐색 실패";
                            e.printStackTrace();
                        }
                        
                    } catch (FileNotFoundException e) {
                        msg = "unzip된 idml 폴더 루프 실패0";
                        e.printStackTrace();
                    }
                });
                
                // zip 파일 삭제
                if (zipList.size() > 1) {
                    deleteZip();
                }
                
            } catch (Exception e) {
                msg = "unzip된 idml 폴더 루프 실패1";
                throw new Exception(msg);
            }
        }
    }
    
    public void deleteZip() {
        zipList.forEach(a -> {
            try {
                Files.delete(a);
                
            } catch (IOException e) {
                e.printStackTrace();
            }
            
            pos++;
        });
    }
}