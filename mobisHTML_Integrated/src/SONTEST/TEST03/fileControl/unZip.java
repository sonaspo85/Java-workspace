package SONTEST.TEST03.fileControl;

import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import SONTEST.TEST03.subWorkClass.commonObj;
import SONTEST.TEST03.subWorkClass.customUserException;

public class unZip {
    commonObj coj = new commonObj();
    String zipPath = coj.exePath + "\\resource\\temp\\idmlZip";
    public String msg = "";
    
    public void runUnzip() throws Exception {
        File dir = new File(zipPath);
        Path path = dir.toPath();
        
        if(Files.exists(path)) {
                // 디렉토리의 모든 내용을 스트림으로 리턴 - newDirectoryStream()
                DirectoryStream<Path> ds = Files.newDirectoryStream(path);
                Charset charset = Charset.forName("UTF-8");
                
                ds.forEach(a -> {
                    String fileName = a.getFileName().toString();
                    String fileFullPath = a.toAbsolutePath().toString();
                    
                    String extention = coj.getExt(new File(fileFullPath));
                    
                    // idml 파일 이름으로 새로운 디렉토리 구조 생성
                    String newUnzipDir = fileFullPath.replace(extention, "");
                    
                    
                    try {
                        FileInputStream fis = new FileInputStream(fileFullPath); 
                        
                        // ZipInputStream 입력 스트림을 사용하여, zip 확장자 파일 읽기
                        ZipInputStream zis = new ZipInputStream(fis, charset); 
                        
                        // zip 파일내 모든 하위 디렉토리의 파일 항목을 읽고, 파일의 시작 부분에 스트림을 배치 
                        // 디렉토리는 추출하지 않음
                        ZipEntry ze = zis.getNextEntry();
                        
                        // zip 파일내 디렉토리내 파일 목록
                        while(ze != null) {
                            // 각 항목들의 이름 추출
                            String zeFileName = ze.getName();
                            
                            // zip 파일내 파일 및 디렉토리를 새로운 디렉토리로 복사 시키기 위해 먼저 디렉토리 구조 생성하기
//                            File newFile = new File(newUnzipDir + File.separator + zeFileName);
//                            new File(newFile.getParent()).mkdirs();
                            
                            Path newPath = Paths.get(newUnzipDir + File.separator + zeFileName);
                            Files.createDirectories(newPath.getParent());
                            
                            
                            // Entry 목록으로 추출된 파일들을 새로운 디렉토리로 복사 시키기
                            FileOutputStream fos = new FileOutputStream(newPath.toFile()); 
                            BufferedOutputStream bos = new BufferedOutputStream(fos); 
                            
                            byte[] buffer = new byte[(int) ze.getSize()];
//                            byte[] buffer = new byte[1024];
                            int byteCnt;
//                            
//                            while((byteCnt = zis.read(buffer)) != -1) {
//                                fos.write(buffer, 0, byteCnt);
//                            }
                            
                            while(true) {
                                byteCnt = zis.read(buffer);
                                
                                if(byteCnt == -1) {
                                    break;
                                }
                                bos.write(buffer, 0, byteCnt);
                            }
                            
                            bos.flush();
                            bos.close();
                            fos.close();
                            zis.closeEntry();
                            
                            ze = zis.getNextEntry();
                        }
                        
                        zis.closeEntry();
                        zis.close();
                        fis.close();
                        
                        
                    } catch(Exception e1) {
//                        msg = e1.getMessage();
//                        msg = "unZip.java 예외 발생";
                        e1.printStackTrace();
                    }
                });
        }
    }
}
