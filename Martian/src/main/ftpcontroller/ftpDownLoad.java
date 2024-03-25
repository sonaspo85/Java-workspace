package main.ftpcontroller;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;

import main.Common.implementOBJ;



public class ftpDownLoad {
    boolean result;
    String msg = "";
    implementOBJ obj = new implementOBJ();
    
    // FTP 접속을 위한 FTPClient 객체 선언 
    FTPClient client = new FTPClient();
    List<String> filesList = new ArrayList<>();
    List<String> directoryList = new ArrayList<>();
    
    public String resourceDir = "";
    public String xslDir = "";
    public String iniDir = ""; 
    public String defaultftpURL = "";
    public String outputpath = "";
    public String flag = "";
    
    
    public ftpDownLoad(String iniDir, String flag) throws Exception {
        this.iniDir = iniDir; 
        this.defaultftpURL = iniDir; 
        this.flag = flag;
        
        
        File file = new File("");
        String projectDir = file.getAbsolutePath();
        

        
        if (flag.equals("xslt")) {
            this.xslDir = projectDir + File.separator + "jre/lib/xsls";
            Path xslDirP = Paths.get(this.xslDir);
            
            
            if(Files.exists(xslDirP)) {
                obj.recursDel(xslDirP);
                Files.createDirectories(xslDirP);
                
            } else {
                Files.createDirectories(xslDirP);
            }
            
        } else if(flag.equals("resource")) {
            this.resourceDir = projectDir + File.separator + "jre/lib/resource/excel-template";
            Path exceltemP = Paths.get(this.resourceDir);
            
            if(Files.exists(exceltemP)) {
                obj.recursDel(exceltemP);
                Files.createDirectories(exceltemP);
                
            } else {
                Files.createDirectories(exceltemP);
            }
            
        }
        
        
        

        
        
    }
    
    public ftpDownLoad(String iniDir, String outputpath, String flag) {
        this.iniDir = iniDir; 
        this.defaultftpURL = iniDir; 
        

        
        this.outputpath = outputpath;
        this.flag = flag;

    }
    
    public void runFTP() throws Exception {
        System.out.println("runFTP 시작");
        try {
            client.setControlEncoding("EUC-KR");
            
            // ftp 접속 주소 설정
            client.connect("10.10.10.2", 21);
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
                e2.printStackTrace();
            }
        }
            
    }
    
    
    private void ftpDownload() throws Exception {
        getFileList(client, File.separator, filesList, directoryList);
        
        // 디렉토리 구조대로 로컬 디렉토리 생성
        createDir();
        
        // 파일 복사
        copyFiles();
    }
    
    private void copyFiles() {
        String cw0 = defaultftpURL;
        
        filesList.stream().forEach(a -> {
            iniDir = a.replaceAll("\\\\", "/");
            String iniDir2 = iniDir.replace(cw0, "");
            
            try {
                String tarDir = "";
                
                if (flag.equals("htmlTempls")) {
                    tarDir = outputpath + iniDir2;
                    
                } else if(flag.equals("resource")) {
                    tarDir = resourceDir + iniDir2;
                    
                } else if(flag.equals("xslt")) {
                    tarDir = xslDir + iniDir2;
                }

                FileOutputStream fo = new FileOutputStream(tarDir);

                if (client.retrieveFile(a, fo)) {
                    fo.close();
                }
                
            } catch (Exception e) {
                e.printStackTrace();
            }
            
        });

    }
    
    private void createDir() {
        String cw0 = defaultftpURL;
        directoryList.stream().forEach(a -> {
            iniDir = a.replaceAll("\\\\", "/");
            
            String iniDir2 = iniDir.replace(cw0, "");

            // 디렉토리 생성
            File file = null;
            
            if (flag.equals("htmlTempls")) {
                file = new File(outputpath + File.separator + iniDir2);
                
            } else if(flag.equals("resource")) {
                file = new File(resourceDir + File.separator + iniDir2);
                
            } else if(flag.equals("xslt")) {
                file = new File(xslDir + File.separator + iniDir2);
            }

            if(!file.exists()) {
                file.mkdirs();
            }
 
        });
    }
    
    private void getFileList(FTPClient client, String cw, List<String> files, List<String> directories) throws Exception {
        String cw0 = cw;

        if(cw0.equals(File.separator) ) {
            cw0 = iniDir;
            
        }
        
        try {
            if(client.changeWorkingDirectory(cw0)) {
                for (FTPFile file: client.listFiles()) {
                    String curPath = cw0 + "/" + file.getName();
                    
                    if(file.isDirectory()) {
                        directories.add(curPath);
                        getFileList0(client, curPath, files, directories);
                    }
                    
                    else {  // 파일인 경우
                        System.out.println("file00: " + curPath);
                        files.add(curPath);
                    }
                    
                }  // for문 닫기
                
                client.changeWorkingDirectory(File.separator);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
    private void getFileList0(FTPClient client, String cw, List<String> files, List<String> directories) throws Exception {
        if (client.changeWorkingDirectory(cw)) {
            for (FTPFile file: client.listFiles()) {
                String curPath = cw + "/" + file.getName();
                
              if(file.isDirectory()) {
                  directories.add(curPath);
                  getFileList0(client, curPath, files, directories);
              } 
              
              else {  // 파일인 경우
                  files.add(curPath);
              }
             
          }  // for문 닫기
            
          client.changeWorkingDirectory(File.separator);
        }

    }
    
    // 로그인 하기
    public void accessLogin() throws Exception {
        String id = "sonminchan";
        String pw = "astkorea1234";
        
        if(!client.login(id, pw)) {
            System.out.println("접속 실패");
            msg = "로그인 정보(ID, PW)가 잘못 되었습니다.";
            return;
        } else {
        }
        
    }
    
    public void deleteFolder(Path xslDirP) throws Exception {
        try {
            if(Files.exists(xslDirP)) {
                obj.recursDel(xslDirP);
            }
            
        } catch(Exception e) {
            throw new Exception("xsl 폴더 삭제 실패!");
        }
        
        
    }
    
}