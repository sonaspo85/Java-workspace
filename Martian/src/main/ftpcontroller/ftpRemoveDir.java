package main.ftpcontroller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;

import main.Common.implementOBJ;



public class ftpRemoveDir {
    boolean result;
    String msg = "";
    implementOBJ obj = new implementOBJ();
    
    // FTP 접속을 위한 FTPClient 객체 선언 
    FTPClient client = new FTPClient();
    List<String> filesList = new ArrayList<>();
    List<String> directoryList = new ArrayList<>();
    
    public static String root = "";
    public String iniDir = ""; 
    
    public ftpRemoveDir(String iniDir) {
        this.iniDir = iniDir;
        accessFTP();
    }
    
    public void ftpRemoveFolder() throws Exception {
        try {
            client.setSoTimeout(1000);

            // FTP 디렉토리 삭제
            ftpRemove();

            // ftp를 로그아웃
            client.logout();
            
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
    
    public void ftpRemove() throws Exception {
        if (getFileList2(client, File.separator, filesList, directoryList)) {
            filesList.stream().forEach(a -> {
                String curPath = Paths.get(a).toString();
                curPath = curPath.replaceAll("\\\\", "/");
                
                try {
                    client.deleteFile(curPath);
                    
                } catch (IOException e) {
                    e.printStackTrace();
                }
                
            });

            // 디렉토리 삭제
            Collections.reverse(directoryList);
            directoryList.stream().forEach(a -> {
                String curPath = Paths.get(a).toString();
                curPath = curPath.replaceAll("\\\\", "/");

                try {
                    client.removeDirectory(curPath);
                    
                } catch (IOException e) {
                    e.printStackTrace();
                }                
            });

        } else {
            return;
        }  
    }
    
    private boolean getFileList2(FTPClient client, String cw, List<String> files, List<String> directories) throws Exception {
        if(cw.equals(File.separator)) {
            cw = iniDir;
        }
        
        if (client.changeWorkingDirectory(cw)) {
            for (FTPFile file4: client.listFiles()) {
                String curPath = cw + File.separator + file4.getName();
                if(file4.isDirectory()) {
                    directories.add(curPath);
                    getFileList2(client, curPath, files, directories);
                  
                } else {  // 파일인 경우
                    files.add(curPath);
                }
            }  // for문 닫기
           
            return client.changeWorkingDirectory(File.separator);
        }  // if문 닫기
        
        return false;
    }
    
    // 로그인 하기
    public void accessLogin() throws Exception {
        System.out.println("accessLogin 시작");
        String id = "ha";
        String pw = "ast141#";
        
        if(!client.login(id, pw)) {
            msg = "로그인 정보(ID, PW)가 잘못 되었습니다.";
            return;
        } else {
        }

    }
    
    public boolean checkingExists() {
        boolean stop = false;
        
        try {
            if (client.changeWorkingDirectory(iniDir)) {                
                FTPFile[] remoteFiles = client.listFiles(iniDir);

                if (remoteFiles.length > 0) {
                    stop = true;
                }
                
                else {
                    stop = false;
                }
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        
        return stop;
    }
    
    public void accessFTP() {
        try {
            client.setControlEncoding("EUC-KR");
            
            // ftp 접속 주소 설정
            client.connect("10.10.11.9", 21);
            int resultCode = client.getReplyCode();
            
            if(!FTPReply.isPositiveCompletion(resultCode)) {
                System.out.println("FTP server refused connection!!");
                return;
                
            } else {
                client.setSoTimeout(1000);
                
                // 로그인
                accessLogin();
               
            }
            
        } catch(Exception e) {
            msg = "FTP 접속 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        }

    }
        
}
