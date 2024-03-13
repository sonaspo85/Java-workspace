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
    
    // 파일 정보를 위한 리스트 컬렉션 생성
    List<String> filesList = new ArrayList<>();
    
    // 디렉토리 정보를 위한 리스트 변수
    List<String> directoryList = new ArrayList<>();
    
    public static String root = "";
    public String iniDir = ""; 
    
    public ftpRemoveDir(String iniDir) {
        this.iniDir = iniDir;
        System.out.println("iniDir: " + iniDir);
        
        accessFTP();
    }
    
    public void ftpRemoveFolder() throws Exception {
        System.out.println("ftpRemoveFolder() 시작");
        System.out.println("ftpRemoveFolder(): " + iniDir);
        
        try {
            // 파일 전송간 접속 딜레이 설정 (1ms 단위이기 때문에, 1000 이면 1초)
            client.setSoTimeout(1000);

            // FTP 디렉토리 삭제
            ftpRemove();

            // ftp를 로그아웃한다.
            client.logout();
            
        } catch (Exception e1) {
            throw new Exception("서버에 접속할 수 없습니다.");
            
        } finally {
            try {  // ftp 커넥션이 연결되어 있으면 종료한다.
                if (client.isConnected()) {
                    client.disconnect();
                }
                
            } catch (Exception e2) { 
            }
        }
        
    }
    
    public void ftpRemove() throws Exception {
        if (getFileList2(client, File.separator, filesList, directoryList)) {
            // 모든 파일을 지운다.
            filesList.stream().forEach(a -> {
                String curPath = Paths.get(a).toString();
                curPath = curPath.replaceAll("\\\\", "/");
                System.out.println("파일 삭제: " + curPath);
                
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
                
                System.out.println("폴더 삭제: " + curPath);
                try {
                    client.removeDirectory(curPath);
                    
                } catch (IOException e) {
                    e.printStackTrace();
                }                
            });

        } else {
            // 리스트 취득 실패시 프로그램을 종료한다.
            System.out.println("File search Error!");
            return;
        }  
    }
    
    private boolean getFileList2(FTPClient client, String cw, List<String> files, List<String> directories) throws Exception {
        if(cw.equals(File.separator)) {
            cw = iniDir;
        }
        
        // FTP의 디렉토리 커서를 이동한다.
        if (client.changeWorkingDirectory(cw)) {
            // 해당 디렉토리의 파일 리스트를 취득한다.
            for (FTPFile file4: client.listFiles()) {
                String curPath = cw + File.separator + file4.getName();
                if(file4.isDirectory()) {
                    directories.add(curPath);
                    getFileList2(client, curPath, files, directories);
                  
                } else {  // 파일인 경우
//                    System.out.println("파일인 경우: " + cw + File.separator + file4.getName());
                    files.add(curPath);
                }
            }  // for문 닫기
           
            // FTP의 디렉토리 커서를 '/'로 이동한다.
            return client.changeWorkingDirectory(File.separator);
        }  // if문 닫기
        
        // 커서 이동에 실패하면 false를 리턴한다.
        return false;
    }
    
    // 로그인 하기
    public void accessLogin() throws Exception {
        System.out.println("accessLogin 시작");
        String id = "ha";
        String pw = "ast141#";
        
        if(!client.login(id, pw)) {
            System.out.println("접속 실패");
            msg = "로그인 정보(ID, PW)가 잘못 되었습니다.";
            return;
        } else {
            System.out.println("로그인 완료");
        }

    }
    
    public boolean checkingExists() {
        System.out.println("checkingExists() 시작");
        boolean stop = false;
        
        try {
            if (client.changeWorkingDirectory(iniDir)) {
                System.out.println("ftp url 존재");
                
                FTPFile[] remoteFiles = client.listFiles(iniDir);
                if (remoteFiles.length > 0) {
//                    System.out.println("File " + remoteFiles[0].getName() + " exists");
                    System.out.println("디렉토리내 파일 및 폴더 존재");
                    stop = true;
                }
                
                else {
                    System.out.println("디렉토리내 파일 및 폴더 없음");
                    stop = false;
                }
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        
        return stop;
    }
    
    public void accessFTP() {
        System.out.println("accessFTP() 시작");
        
        try {
         // connection 환경에서 인코딩 타입 설정
            client.setControlEncoding("EUC-KR");
            
            // ftp 접속 주소 설정
            client.connect("10.10.11.9", 21);
            
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
               
            }
            
        } catch(Exception e) {
            msg = "FTP 접속 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        }
        
        
    }
    
    
}