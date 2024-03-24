package SONTEST.TEST03.ftp;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;

import SONTEST.TEST03.subWorkClass.commonObj;

public class ftpConnect {
    String msg = "";
    commonObj coj = new commonObj();
    
    FTPClient client = new FTPClient();
    List<String> filesList = new ArrayList<>();
    List<String> directoryList = new ArrayList<>();
    
    public static String root = "";
    public static String iniDir = "\\html_converter_xslt\\"; 
    
    
    public void runFTP() {
        System.out.println("runFTP 시작");
        try {
            client.setControlEncoding("EUC-KR");
            client.connect("10.10.10.6", 21);
            int resultCode = client.getReplyCode();
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
                System.out.println("ftpDownload 끝");
            }
        } catch (Throwable e) {
            e.printStackTrace();
        } finally {
            try {
                if (client.isConnected()) {
                    client.disconnect();
                }
            } catch (Throwable e) {
                e.printStackTrace();
            }
        }
            
    }
    
    
    private void ftpDownload() throws Exception {
        root = coj.exePath + "\\xsls";
        
        // FTP에서 파일 리스트와 디렉토리 정보를 추출
        if (getFileList(client, File.separator, filesList, directoryList)) {
            // root 디렉토리 생성
            File createIniDir = new File(root);
            createIniDir.mkdirs();

            for(int i=directoryList.size()-1; i >= 0; i--) {
                  File fullPath = new File(directoryList.get(i));
                  String adjust = directoryList.get(i).replace(iniDir, "");
                  
                  File file = new File(root + File.separator + adjust);
                  System.out.println("file: " + file.getAbsolutePath());
                  file.mkdirs();
            }
                    
            for (String file: filesList) {
                System.out.println("다운로드: " + file);
                String adjust = file.replace(iniDir, "");
                
                try (FileOutputStream fo = new FileOutputStream(root + File.separator + adjust)) {
                    if (client.retrieveFile(file, fo)) {
                        System.out.println("Download - " + file);
                    }
                }
            }
        } else {
            System.out.println("File search Error!");
            return;
        }
//        client.logout();
    }
    
    private static boolean getFileList(FTPClient client, String cw, List < String > files, List < String > directories) throws Exception {
        if(cw.equals(File.separator) ) {
            cw = iniDir;
        } else {
            cw = cw;
        }
        
        if (client.changeWorkingDirectory(cw)) {
            for (FTPFile file: client.listFiles()) {
                if (file.isFile()) {
                    files.add(cw + file.getName());
                } else {
                    if (!getFileList(client, cw + file.getName() + File.separator, files, directories)) {
                        return false;
                    } else {
                        directories.add(cw + file.getName() + File.separator);
                    }
                    
                }
            }

            return client.changeWorkingDirectory(File.separator);
        }
        
        return false;
    }
    
    // 로그인 하기
    public void accessLogin() throws Exception {
        System.out.println("accessLogin 시작");
        String id = "mchtml";
        String pw = "ast141#";
        
        if(!client.login(id, pw)) {
            msg = "로그인 정보(ID, PW)가 잘못 되었습니다.";
            return;
        }
        
        
    }
    
}
