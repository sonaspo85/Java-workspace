package SONTEST.TEST03.ftp;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;

import SONTEST.TEST03.subWorkClass.commonObj;

public class ftpCopyXslt {
    String msg = "";
    commonObj coj = new commonObj();
    
    FTPClient client = new FTPClient();
    List<String> filesList = new ArrayList<>();
    List<String> directoryList = new ArrayList<>();
    
    public static String iniDir = ""; 
    
    
    public ftpCopyXslt(String iniDir) {
        this.iniDir = iniDir; 
    }
    
    public void runFTP() throws Exception {
        try {
            client.setControlEncoding("EUC-KR");
            
            // ftp 접속 주소 설정
            client.connect("10.10.10.6", 21);
            int resultCode = client.getReplyCode();
            client.setFileType(client.BINARY_FILE_TYPE);
            
            if(!FTPReply.isPositiveCompletion(resultCode)) {
                System.out.println("FTP server refused connection!!");
                return;
                
            } else {
                client.setSoTimeout(1000);
                
                // 로그인
                accessLogin();
                ftpDownload();
                   
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
                e2.getStackTrace();
            }
        }
            
    }
    
    private void ftpDownload() throws Exception {
        String localPath = coj.exePath + "/xsls";
        
        if (getFileList(client, File.separator, filesList, directoryList)) {
            createDir(localPath);
            copyFiles(localPath);

        } else {
            return;
        }
    }
    
    private void copyFiles(String localPath) throws Exception {
        filesList.stream().forEach(a -> {
            String curPath = Paths.get(a).toString();
            curPath = curPath.replaceAll("\\\\", "/").replaceAll(iniDir, "");
            
            File fullPath = new File(localPath + curPath);
            try {
                FileOutputStream fos = new FileOutputStream(fullPath);
                
                if (client.retrieveFile(a, fos)) {
                    System.out.println("Download - " + a);
                }
                
            } catch (Exception e) {
                e.getStackTrace();
            } 
            
        });
    }
    
    private void createDir(String localPath) throws Exception {
        directoryList.stream().forEach(a -> {
            String curPath = Paths.get(a).toString();
            curPath = curPath.replaceAll("\\\\", "/").replaceAll(iniDir, "");
            
            File fullPath = new File(localPath + curPath);
            if(!fullPath.exists()) {
                fullPath.mkdirs();                
            }
        });
    }
    
    
    private static boolean getFileList(FTPClient client, String cw, List < String > files, List < String > directories) throws Exception {
        if(cw.equals(File.separator) ) {
            cw = iniDir;
        }
        
        if (client.changeWorkingDirectory(cw)) {
            for (FTPFile file: client.listFiles()) {
                String curPath = cw + File.separator + file.getName();
                
                if(file.isDirectory()) {
                    if (!getFileList(client, curPath, files, directories)) {
                        return false;
                        
                    } else {
                        directories.add(curPath);
                    }
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
        }
    }
    
}
