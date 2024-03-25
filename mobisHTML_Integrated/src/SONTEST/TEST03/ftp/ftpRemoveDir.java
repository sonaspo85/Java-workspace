package SONTEST.TEST03.ftp;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.regex.Pattern;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;

import SONTEST.TEST03.subWorkClass.commonObj;

public class ftpRemoveDir {
    boolean result;
    String msg = "";
    commonObj coj = new commonObj();
    FTPClient client = new FTPClient();
    List<String> filesList = new ArrayList<>();
    List<String> directoryList = new ArrayList<>();
    
    public static String root = "";
    public String iniDir = ""; 
    
    public ftpRemoveDir(String iniDir) {
        this.iniDir = iniDir;
    }
    
    public void ftpRemoveFolder() throws Exception {
        try {
            client.setControlEncoding("EUC-KR");
            
            // ftp 접속 주소 설정
            client.connect("10.10.10.6", 21);
            int resultCode = client.getReplyCode();
            
            if(!FTPReply.isPositiveCompletion(resultCode)) {
                System.out.println("FTP server refused connection!!");
                return;
                
            } else {
                client.setSoTimeout(1000);
                
                // 로그인
                accessLogin();
                ftpRemove();

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
                  
                } else {
                    files.add(curPath);
                }
            }
            
            return client.changeWorkingDirectory(File.separator);
        }
        
        return false;
    }
    
    // 로그인 하기
    public void accessLogin() throws Exception {
        String id = "mchtml";
        String pw = "ast141#";
        
        if(!client.login(id, pw)) {
            System.out.println("접속 실패");
            msg = "로그인 정보(ID, PW)가 잘못 되었습니다.";
            return;
        } else {
            System.out.println("로그인 완료");
        }

    }
    
    
}
