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
    
    // 파일 정보를 위한 리스트 컬렉션 생성
    List<String> filesList = new ArrayList<>();
    
    // 디렉토리 정보를 위한 리스트 변수
    List<String> directoryList = new ArrayList<>();
    
//    List<String> srcList = new ArrayList<>();
    
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
            
//          this.resourceDir = "G:/MS-Drive/OneDrive - UOU/WORK/Workspace/WORK/JAVA/java-workspace/CE-Air_Html_Converter/resource1";
            
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
            // connection 환경에서 인코딩 타입 설정
            client.setControlEncoding("EUC-KR");
            
            // ftp 접속 주소 설정
            client.connect("10.10.10.2", 21);
            
            // 올바르게 접속이 되었는지 확인하기
            int resultCode = client.getReplyCode();
            
            // 만약, 올바르게 접속이되지 않았다면, 에러 출력
            if(!FTPReply.isPositiveCompletion(resultCode)) {
                System.out.println("FTP server refused connection!!");
                return;
                
            } else {  // 올바르게 접속이 되었다면
                // 파일 전송간 접속 딜레이 설정 (1ms 단위이기 때문에, 1000 이면 1초)
                client.setSoTimeout(1000);
                
                // 로그인을 한다.
                accessLogin();
               
                ftpDownload();
                
                // ftp를 로그아웃한다.
                client.logout();
                System.out.println("ftpDownload 끝");

            }
            
        } catch (Exception e1) {
//            e1.printStackTrace();
//            throw new RuntimeException(e1.getMessage()); 
            throw new Exception("서버에 접속할 수 없습니다.");
            
        } finally {
            // ftp 커넥션이 연결되어 있으면 종료한다.
            try {
                if (client.isConnected()) {
                    System.out.println("ftp 연결 해제");
                    client.disconnect();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
//                throw new RuntimeException(e2.getMessage()); 
            }
        }
            
    }
    
    
    private void ftpDownload() throws Exception {
        System.out.println("ftpDownload() 시작");
//        resourceDir = obj.resourceDir + "\\output";
        

        getFileList(client, File.separator, filesList, directoryList);
        
        /*directoryList.forEach(a -> {
            System.out.println("디렉토리: " + a); 
        });
         
        filesList.forEach(a -> {
             System.out.println("파일: " + a); 
        });*/
        
        // 디렉토리 구조대로 로컬 디렉토리 생성
        createDir();
        
        // 파일 복사
        copyFiles();
    }
    
    private void copyFiles() {
        System.out.println("파일 복사");
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
                
//                System.out.println("tarDir: " + tarDir);
                
                FileOutputStream fo = new FileOutputStream(tarDir);

//               // FTPClient의 retrieveFile함수로 보내면 다운로드가 이루어 진다.
                if (client.retrieveFile(a, fo)) {
                    System.out.println("Download - " + a);
                    fo.close();
                }
                
            } catch (Exception e) {
                System.out.println("파일 복사 에러 발생");
                e.printStackTrace();
            }
            
        });
        
        System.out.println("파일 복사 완료!!!");
    }
    
    private void createDir() {
        System.out.println("디렉토리 생성");
        
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

            System.out.println("Directory - " + file.getAbsolutePath());
            if(!file.exists()) {
                file.mkdirs();
            }
 
        });
    }
    
    // FTP의 파일 리스트와 디렉토리 정보를 취득하는 함수
    private void getFileList(FTPClient client, String cw, List<String> files, List<String> directories) throws Exception {
        String cw0 = cw;

        if(cw0.equals(File.separator) ) {
            cw0 = iniDir;
            
        }
        
        // FTP의 디렉토리 커서를 이동한다.
        try {
            if(client.changeWorkingDirectory(cw0)) {
                // 해당 디렉토리의 파일 리스트를 취득한다.
                for (FTPFile file: client.listFiles()) {
                    String curPath = cw0 + "/" + file.getName();
                    
                    if(file.isDirectory()) {
                        System.out.println("folder00:" + curPath);
                        directories.add(curPath);
                        
                        // getFileList0() 메소드로 보내는 이유는, getFileList() 메소드로 다시 보낼경우,
                        // srcList.stream().forEach() 메소드에 의해 요소의 개수만큼 중복으로 재귀 한다.
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
        System.out.println("getFileList0 시작");
        
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
        System.out.println("accessLogin 시작");
        String id = "sonminchan";
        String pw = "astkorea1234";
        
        if(!client.login(id, pw)) {
            System.out.println("접속 실패");
            msg = "로그인 정보(ID, PW)가 잘못 되었습니다.";
            return;
        } else {
            System.out.println("로그인 완료");
        }
        
    }
    
    public void deleteFolder(Path xslDirP) throws Exception {
        System.out.println("deleteFolder() 시작");
        
        try {
            if(Files.exists(xslDirP)) {
                obj.recursDel(xslDirP);
            }
            
        } catch(Exception e) {
            throw new Exception("xsl 폴더 삭제 실패!");
        }
        
        
    }
    
}