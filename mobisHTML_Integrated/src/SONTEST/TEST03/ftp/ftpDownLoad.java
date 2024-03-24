package SONTEST.TEST03.ftp;

import java.io.File;
import java.io.FileNotFoundException;
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

public class ftpDownLoad {
    boolean result;
    String msg = "";
    commonObj coj = new commonObj();
    
    FTPClient client = new FTPClient();
    List<String> filesList = new ArrayList<>();
    List<String> directoryList = new ArrayList<>();
    List<String> srcList = new ArrayList<>();
    
    public static String root = "";
    public String iniDir = ""; 
    
    public ftpDownLoad(List<String> srcList) {
        srcList.forEach(a -> {
            String a1 = Paths.get(a).toFile().toString();
            this.srcList.add(a1);
        });
    }
    
    public void runFTP() throws Exception {
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
                System.out.println("ftpDownload 끝");

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
    
    
    private void ftpDownload() throws Exception {
        System.out.println("ftpDownload() 시작");
        root = coj.exePath + "\\output";

        getFileList(client, File.separator, filesList, directoryList);
        createDir();
        copyFiles();
    }
    
    private void copyFiles() {
        filesList.stream().forEach(a -> {
            iniDir = a.replaceAll("\\\\", "/");
            
            srcList.forEach(b -> {
                String iniDir2 = b.replaceAll("\\\\", "/");
                iniDir = iniDir.replace(iniDir2, "");
            });
            
            try {
                String tarDir = root + iniDir;
                FileOutputStream fo = new FileOutputStream(tarDir);

                if (client.retrieveFile(a, fo)) {
                    System.out.println("Download - " + a);
                }
                
            } catch (Exception e) {
                e.printStackTrace();
            }
            
        });
        
        
    }
    
    private void createDir() {
        System.out.println("디렉토리 생성");
        directoryList.stream().forEach(a -> {
            iniDir = a.replaceAll("\\\\", "/");
            
            srcList.forEach(b -> {
                String iniDir2 = b.replaceAll("\\\\", "/");
                iniDir = iniDir.replace(iniDir2, "");
            });
            
            // 디렉토리 생성
            File file = new File(root + File.separator + iniDir);
            System.out.println("Directory - " + file.getAbsolutePath());
            if(!file.exists()) {
                file.mkdirs();
            }
 
        });
    }
    
    private void getFileList(FTPClient client, String cw, List<String> files, List<String> directories) throws Exception {
        srcList.stream().forEach(a -> {
            String cw0 = cw;

            if(cw0.equals(File.separator)) {
                cw0 = a;
            }
            
            try {
                if(client.changeWorkingDirectory(cw0)) {
                    for (FTPFile file: client.listFiles()) {
                        String curPath = cw0 + File.separator + file.getName();
                        
                        if(file.isDirectory()) {
                            directories.add(curPath);
                            getFileList0(client, curPath, files, directories);
                        }
                        
                        else {
                            files.add(curPath);
                        }
                        
                    }
                    
                    client.changeWorkingDirectory(File.separator);
                }
                
            } catch (Exception e) {
                e.printStackTrace();
            }
            
        });
        
    }
    
    private void getFileList0(FTPClient client, String cw, List<String> files, List<String> directories) throws Exception {
        if (client.changeWorkingDirectory(cw)) {
            for (FTPFile file: client.listFiles()) {
                String curPath = cw + File.separator + file.getName();
              
              if(file.isDirectory()) {
                  directories.add(curPath);
                  getFileList0(client, curPath, files, directories);
              } 
              
              else {
                  files.add(curPath);
              }
             
          }
            
          client.changeWorkingDirectory(File.separator);
        }

    }
    
    // 로그인 하기
    public void accessLogin() throws Exception {
        System.out.println("accessLogin 시작");
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