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


public class unZip2 {
    String srcFile = "";
    String getParent = "";
    String getFileName = "";
    String containIDMLPath = "";
    String msg ="";
    Path newtarPath = null;
    int pos = 0;
    List < Path > zipList = new ArrayList < > ();
    public Charset charset = Charset.forName("UTF-8");
    implementOBJ obj = new implementOBJ();
    
    public unZip2(String srcFile) {
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
            // zip 파일 읽기
            zis = new ZipInputStream(fis, charset);
        } catch (FileNotFoundException e) {
            String msg = ".zip 파일 읽기 실패";
            throw new Exception(msg);
        }
        
        try {
            // ZipInputStream 입력 스트림으로 로드한 zip 파일에서
            // 파일 및 디렉토리 목록의 시작 부분에 스트림을 배치
            ZipEntry ze = zis.getNextEntry();
            
            while (ze != null) {
                // zip 파일의 이름 추출
                String zeName = ze.getName();
                // 확장자가 .idml 이 아닌 파일은 제외 하기위해 zis.getNextEntry() 메소드를 호출하여,
                // 다음 반복으로 넘김
//                if (ze.isDirectory() | zeName.contains(".png") | zeName.contains(".ai") | zeName.contains(".pdf") | zeName.contains(".indd") | zeName.contains("TOC") | zeName.contains("Eng(LTN)")) {
                if (ze.isDirectory() | zeName.contains(".png") | zeName.contains(".ai") | zeName.contains(".pdf") | zeName.contains(".indd") | zeName.contains("TOC") | zeName.contains("Eng(LTN)")) {
                    System.out.println("zeName: " + zeName);
                    ze = zis.getNextEntry();
                    
                } else if (zeName.contains(".idml")) {
                    System.out.println("zeName222: " + zeName);
                    // zip 파일을 unzip 하여 새롭게 저장될 디렉토리로 출력하기 위해 fullPath 생성
                    String newDirs0 = getParent + File.separator + getFileName + File.separator + zeName;
                    // 새로운 디렉토리내 각 파일들을 저장하기 위해 먼저 하위 디렉토리 생성
                    Path newDirPath = Paths.get(newDirs0).getParent();
                    // 새롭게 저장될 디렉토리 생성
                    Files.createDirectories(newDirPath);
                    // 파일 출력 스트림
                    FileOutputStream fos = new FileOutputStream(newDirs0);
                    
                    int length;
                    byte[] buffer = new byte[2024];
                    
                    // 데이터를 끝에 도달할때 까지 반복
                    while ((length = zis.read(buffer)) != -1) {
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
            }
            
            // zip 파일의 모든 목록을 읽고 작업이 모두 완료된 경우 현재 zip 파일 닫기
            zis.closeEntry();
            zis.close();
            fis.close();
            System.out.println("끝!!!");
            
        } catch (Exception e1) {
            msg = "zip 파일 데이터 읽기 에러";
            throw new Exception(msg);
        }
    }
    
    // 새로운 폴더로 idml 파일을 zip 확장자로 변경하여 새로운 폴더로 복사 하기
    public String changeExt() throws Exception {
        System.out.println("subUnzip() 시작");
        Path getIdmlPath = Paths.get(containIDMLPath);
        
        // zip 파일을 저장할 폴더 생성
//        Path newPath = createZipFolder(getIdmlPath);
        String newDir = getIdmlPath + "/zipDir";
        Path newPath = Paths.get(newDir);
        obj.createNewDir(newPath);
        
        try {
            DirectoryStream <Path> ds = Files.newDirectoryStream(getIdmlPath);
            ds.forEach(c -> {
                String fileName = c.getFileName().toString();
                System.out.println("fileName: " + fileName);
                if (Files.isRegularFile(c)) {
                    // 파일 확장자 추출
                    int lastDot = fileName.lastIndexOf(".");
                    String extenstion = fileName.substring(lastDot);
                    
                    // 새로운 zip 파일명 생성
                    String newZipFile = fileName.replace(extenstion, ".zip");
                    newtarPath = Paths.get(newPath.toString() + File.separator + newZipFile);
                    
                    // 새로운 폴더로 idml 파일을 zip 확장자로 변경하여 새로운 폴더로 복사 하기
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
    
    // 새로운 폴더로 복사한 zip 파일들을 압축 풀기 *****
    public void runLoop(String newtarPath) throws Exception {
        System.out.println("runLoop() 시작");
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
                        // ZipInputStream을 사용하여 zip 파일 읽기
                        ZipInputStream zis = new ZipInputStream(fis, charset);
                        
                        try {
                            // 다음 zip 항목을 읽어 데이터의 시작 부분에 스트림을 배치
                            ZipEntry ze = zis.getNextEntry();
                            
                            while (ze != null) {
                                // zip 파일의 이름 추출
                                String zeName = ze.getName();
                                Path parentDirs = path.getParent();
                                // zip 파일을 unzip하여 새롭게 저장될 디렉토리로 출력하기 위해 fullPath 생성
                                String newDirs = a.getParent() + File.separator + fileName.replace(extension, "") + File.separator + zeName;
                                // 새로운 디렉토리내 각 파일들을 저장하기 위해 먼저 하위 디렉토리 생성
                                Path newDirsPath = Paths.get(newDirs).getParent();
                                // zip목록내 하위 디렉토리 생성
                                Files.createDirectories(newDirsPath);
                                
                                // 파일 출력 스트림
                                FileOutputStream fos = new FileOutputStream(newDirs);
                                
                                int length;
                                byte[] buffer = new byte[1024];
                                // 데이터를 끝에 도달할때까지 반복
                                while ((length = zis.read(buffer)) != -1) {
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
    
    // .zip 확장자로된 파일 삭제
    public void deleteZip() {
        System.out.println("deleteZip 시작");
        
        zipList.forEach(a -> {
            try {
//                String changeList = a.toString().replace(".zip", "");
                Files.delete(a);
                
            } catch (IOException e) {
                e.printStackTrace();
            }
            
            pos++;
        });
    }
}