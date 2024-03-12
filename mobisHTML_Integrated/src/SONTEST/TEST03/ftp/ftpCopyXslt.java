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
    
    // FTP 접속을 위한 FTPClient 객체 선언 
    FTPClient client = new FTPClient();
    
    // 파일 정보를 위한 리스트 컬렉션 생성
    List<String> filesList = new ArrayList<>();
    
    // 디렉토리 정보를 위한 리스트 변수
    List<String> directoryList = new ArrayList<>();
    
    public static String iniDir = ""; 
    
    
    public ftpCopyXslt(String iniDir) {
        this.iniDir = iniDir; 
    }
    
    public void runFTP() throws Exception {
        System.out.println("runFTP 시작");
        try {
            // connection 환경에서 인코딩 타입 설정
            client.setControlEncoding("EUC-KR");
            
            // ftp 접속 주소 설정
            client.connect("10.10.10.6", 21);
            
            // 올바르게 접속이 되었는지 확인하기
            int resultCode = client.getReplyCode();
            client.setFileType(client.BINARY_FILE_TYPE);
            
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
            throw new Exception("서버에 접속할 수 없습니다.");
            
        } finally {
            try {
                // ftp 커넥션이 연결되어 있으면 종료한다.
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
        
        // FTP에서 파일 리스트와 디렉토리 정보를 추출한다.
        if (getFileList(client, File.separator, filesList, directoryList)) {
            
            // 디렉토리 생성
            createDir(localPath);
            
            // 파일 다운로드
            copyFiles(localPath);

        } else {
            // 리스트 취득 실패시 프로그램을 종료한다.
            System.out.println("File search Error!");
            return;
        }
    }
    
    private void copyFiles(String localPath) throws Exception {
        System.out.println("xslt 파일 복사");
        
        filesList.stream().forEach(a -> {
            String curPath = Paths.get(a).toString();
            curPath = curPath.replaceAll("\\\\", "/").replaceAll(iniDir, "");
            
            File fullPath = new File(localPath + curPath);
            try {
                FileOutputStream fos = new FileOutputStream(fullPath);
                
                // FTPClient의 retrieveFile함수로 보내면 다운로드가 이루어 진다.
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
    
    
    // FTP의 파일 리스트와 디렉토리 정보를 취득하는 함수.
    private static boolean getFileList(FTPClient client, String cw, List < String > files, List < String > directories) throws Exception {
        if(cw.equals(File.separator) ) {
            cw = iniDir;
        }
        
        // FTP의 디렉토리 커서를 이동한다.
        if (client.changeWorkingDirectory(cw)) {
            // 해당 디렉토리의 파일 리스트를 취득한다.
            for (FTPFile file: client.listFiles()) {
                String curPath = cw + File.separator + file.getName();
                
                if(file.isDirectory()) {
                    // 하위 디렉토리가 존재 한다면 함수의 재귀적 방식으로 하위 탐색을 시작
                    if (!getFileList(client, curPath, files, directories)) {
                        return false;
                        
                    } else {
                        directories.add(curPath);
                    }
                } else {
                    files.add(curPath);
                }
            }  // for문 닫기
            
            // FTP의 디렉토리 커서를 이동한다.
            return client.changeWorkingDirectory(File.separator);
        }  // if문 닫기
        
        // 커서 이동에 실패하면 false를 리턴한다.
        return false;
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
