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
                DirectoryStream<Path> ds = Files.newDirectoryStream(path);
                Charset charset = Charset.forName("UTF-8");
                
                ds.forEach(a -> {
                    String fileName = a.getFileName().toString();
                    String fileFullPath = a.toAbsolutePath().toString();
                    String extention = coj.getExt(new File(fileFullPath));
                    String newUnzipDir = fileFullPath.replace(extention, "");
                    
                    
                    try {
                        FileInputStream fis = new FileInputStream(fileFullPath); 
                        ZipInputStream zis = new ZipInputStream(fis, charset); 
                        ZipEntry ze = zis.getNextEntry();
                        
                        // zip 파일내 디렉토리내 파일 목록
                        while(ze != null) {
                            String zeFileName = ze.getName();
                            Path newPath = Paths.get(newUnzipDir + File.separator + zeFileName);
                            Files.createDirectories(newPath.getParent());
                            
                            // Entry 목록으로 추출된 파일들을 새로운 디렉토리로 복사 시키기
                            FileOutputStream fos = new FileOutputStream(newPath.toFile()); 
                            BufferedOutputStream bos = new BufferedOutputStream(fos); 
                            
                            byte[] buffer = new byte[(int) ze.getSize()];
                            int byteCnt;
                            
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
                        e1.printStackTrace();
                    }
                });
        }
    }
}
