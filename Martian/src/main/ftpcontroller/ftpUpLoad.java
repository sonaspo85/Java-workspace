package main.ftpcontroller;

import java.io.FileInputStream;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;

import main.Common.implementOBJ;

public class ftpUpLoad {
    String msg = "";
    implementOBJ obj = new implementOBJ();
    
    // FTP 접속을 위한 FTPClient 객체 선언 
    FTPClient client = new FTPClient();
    List<String> filesList = new ArrayList<>();
    List<String> directoryList = new ArrayList<>();
    
    public String iniDir = ""; 
    String outDir = "";
    
    public ftpUpLoad(String iniDir) {
        this.iniDir = iniDir; 
    }
    
    public void runFTP() throws Exception {
        try {
            client.setControlEncoding("EUC-KR");
            
            // ftp 접속 주소 설정
            client.connect("10.10.11.9", 21);
            int resultCode = client.getReplyCode();
            if(!FTPReply.isPositiveCompletion(resultCode)) {
                return;
                
            } else {
                client.setSoTimeout(1000);
                client.setFileType(client.BINARY_FILE_TYPE);
                // 로그인
                accessLogin();
                
                // ftp 파일 업로드
                ftpUpload();

                // ftp를 로그아웃
                client.logout();

            }
            
        } catch (Exception e1) { 
            throw new Exception("서버에 접속할 수 없습니다.");
            
        } finally {
            try {
                if (client.isConnected()) {
                    client.disconnect();
                }
                
            } catch (Exception e2) { 
            }
        }
            
    }
    
    public void ftpUpload() throws Exception {
        outDir = obj.srcPathP + "\\output";
        getUploadList(outDir, filesList, directoryList);
        
        // 디렉토리 생성
        Collections.reverse(directoryList);
        for (String directory : directoryList) {
            client.makeDirectory(directory);
        }

        // 파일 업로드
        for (String file: filesList) {.
            FileInputStream fis = new FileInputStream(file);
            client.storeFile(file.replace(outDir, iniDir), fis);
            System.out.println("Upload - " + file);
            fis.close();
            
        }

        
    }
    
    private void getUploadList(String localDir, List<String> files, List<String> directories) throws Exception {
        Path path = Paths.get(localDir);
        
        if(Files.exists(path)) {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                try {
                      if(Files.isDirectory(a)) {
                          getUploadList(a.toString(), files, directories);
                          directories.add(a.toString().replace(outDir, iniDir));
                          
                      } else {  // 파일인 경우
                        files.add(a.toString());
                        
                      }
                      
                    } catch (Exception e) {
                      e.printStackTrace();
                }
                                
            });
            
        }

    }

    // 로그인 하기
    public void accessLogin() throws Exception {
        String id = "ha";
        String pw = "ast141#";
        
        if(!client.login(id, pw)) {
            System.out.println("접속 실패");
            msg = "로그인 정보(ID, PW)가 잘못 되었습니다.";
            return;
        } else {
        }

    }
    
}
