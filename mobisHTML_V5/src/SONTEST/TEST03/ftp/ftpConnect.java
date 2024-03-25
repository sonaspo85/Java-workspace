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
    
    // FTP 접속을 위한 FTPClient 객체 선언 
    FTPClient client = new FTPClient();
    List<String> filesList = new ArrayList<>();
    List<String> directoryList = new ArrayList<>();
    
    public static String root = "";
    public static String iniDir = "\\html_converter_xslt\\"; 
    
    public void runFTP() {
        System.out.println("runFTP 시작");
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
                
                ftpDownload();
                // ftp를 로그아웃
                client.logout();
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
                String adjust = file.replace(iniDir, "");
                
                try (FileOutputStream fo = new FileOutputStream(root + File.separator + adjust)) {
                    if (client.retrieveFile(file, fo)) {
                        System.out.println("Download - " + file);
                    }
                }
            }
        } else {
            // 리스트 취득 실패시 프로그램을 종료한다.
            System.out.println("File search Error!");
            return;
        }

    }
    
    private static boolean getFileList(FTPClient client, String cw, List < String > files, List < String > directories) throws Exception {
        if(cw.equals(File.separator) ) {
            cw = iniDir;
        } else {
            cw = cw;
        }
        
        if (client.changeWorkingDirectory(cw)) {
            for (FTPFile file: client.listFiles()) {
                // 리스트의 객체가 파일이면
                if (file.isFile()) {
                    // files 리스트에 경로를 추가
                    files.add(cw + file.getName());
                    System.out.println("files111: " + cw + file.getName());
                } else {
                    System.out.println("files222: " + cw + file.getName());
                    if (!getFileList(client, cw + file.getName() + File.separator, files, directories)) {
                        return false;
                    } else {
                        // directories 리스트에 디렉토리 경로를 추가
                        directories.add(cw + file.getName() + File.separator);
                    }
                    
                }
            }

            return client.changeWorkingDirectory(File.separator);
        }  // if문 닫기
        
        return false;
    }
    
    // 로그인
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
