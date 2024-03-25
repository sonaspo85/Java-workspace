package main.java.zipcontroller;

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

import main.java.CommonObj.implementOBJ;

public class unzipMain {
    implementOBJ obj = new implementOBJ();
    Path srcPath = null;
    String curSrcPathStr = "";   
    String lang = "";
    List<Path>zipList = new ArrayList<>();
    String msg ="";
    int pos = 0;
    		
    
    
    public unzipMain() {
    }
    
    public void setPath(String srcPathStr, String lang) {
        this.curSrcPathStr = srcPathStr;
        this.lang = lang;
        
        srcPath = Paths.get(srcPathStr);
    }
    
    public void runUnzip() throws Exception {
        System.out.println("runUnzip() 시작");
        
        // 경로 추출
        getsrcNtarDirs();
        String curFName = srcPath.getFileName().toString();
        int LastDot = curFName.lastIndexOf(".");
        curFName = curFName.substring(0, LastDot);
        
        // 압축 해제 경로 설정
        File projectDir = new File(""); 
        String curfirstZipDirs = projectDir.getAbsolutePath() + File.separator + "temp" + File.separator + curFName + "_" + lang;
        obj.curFirstZipDirs = curfirstZipDirs; 
        
        File in = new File(curSrcPathStr);
        File out = new File(curfirstZipDirs);
        
        if(!out.exists()) {
            // 경로 생성
            out.mkdirs();
            
        } else {
            // 폴더가 존재 한다면 삭제
            obj.recursDel(Paths.get(out.toString()));
            out.mkdirs();
        }

        unzipMain2 eachPath = new unzipMain2(curSrcPathStr, curfirstZipDirs);
        
        try {
            // 압축 해제
            eachPath.unZipFile();
            
        } catch (Exception e) {
            msg = "압축 해제 실패";
            throw new Exception(msg);
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
                        ZipInputStream zis = new ZipInputStream(fis, charset);
                        
                        try {
                            ZipEntry ze = zis.getNextEntry();
                            
                            while (ze != null) {
                                // zip 파일의 이름 추출
                                String zeName = ze.getName();
                                Path parentDirs = path.getParent();
                                String newDirs = a.getParent() + File.separator + fileName.replace(extension, "") + File.separator + zeName;
                                
                                // 새로운 디렉토리내 각 파일들을 저장하기 위해 먼저 하위 디렉토리 생성
                                Path newDirsPath = Paths.get(newDirs).getParent();
                                
                                // zip목록내 하위 디렉토리 생성
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
                            
                            zis.closeEntry();
                            zis.close();
                            fis.close();
                            
                        } catch (Exception e) {
                            msg = "unzip된 idml 폴더 탐색 실패";
                            throw new RuntimeException(msg);
                        }
                        
                    } catch (FileNotFoundException e) {
                        msg = "unzip된 idml 폴더 루프 실패0";
                        throw new RuntimeException(msg);
                    }
                });
                
                // zip 파일 삭제
                if (zipList.size() > 1) {
                    deleteZip();
                }
                
            } catch (Exception e) {
                msg = "unzip된 idml 폴더 루프 실패1";
                throw new RuntimeException(msg);
            }
        }
    }
    
    public void deleteZip() {
        zipList.forEach(a -> {
            try {
                Files.delete(a);
                
            } catch (IOException e) {
            	msg = ".zip 확장자로된 파일 삭제 실패";
            	throw new RuntimeException(msg);
            }
            
            pos++;
        });
    }
    
    public void getsrcNtarDirs() {
      Path srcPath = Paths.get(curSrcPathStr);
      Path parDirs = srcPath.getParent();
      String zipname = srcPath.getFileName().toString();
      
      if(lang.equals("Eng")) {
          obj.srcDir = parDirs;
          obj.srcName = zipname;
      
      } else if(lang.equals("multi") & obj.tarName != null) {
          obj.tarDir = parDirs;
          obj.tarName = zipname;

      }
        
    }
    
}
