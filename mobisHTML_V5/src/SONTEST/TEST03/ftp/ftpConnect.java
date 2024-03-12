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
    
    // 파일 정보를 위한 리스트 컬렉션 생성
    List<String> filesList = new ArrayList<>();
    
    // 디렉토리 정보를 위한 리스트 변수
    List<String> directoryList = new ArrayList<>();
    
    public static String root = "";
    public static String iniDir = "\\html_converter_xslt\\"; 
    
    
    public void runFTP() {
        System.out.println("runFTP 시작");
        try {
            // connection 환경에서 인코딩 타입 설정
            client.setControlEncoding("EUC-KR");
            
            // ftp 접속 주소 설정
            client.connect("10.10.10.6", 21);
            
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
        } catch (Throwable e) {
            e.printStackTrace();
        } finally {
            // ftp 커넥션이 연결되어 있으면 종료한다.
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
//        root = "C:\\Temp";
        root = coj.exePath + "\\xsls";
        
        // FTP에서 파일 리스트와 디렉토리 정보를 추출한다.
        if (getFileList(client, File.separator, filesList, directoryList)) {
            // root 디렉토리 생성
            File createIniDir = new File(root);
            createIniDir.mkdirs();
            
            // 디렉토리 구조대로 로컬 디렉토리 생성
            System.out.println("디렉토리 생성");
            for(int i=directoryList.size()-1; i >= 0; i--) {
                  File fullPath = new File(directoryList.get(i));
                  String adjust = directoryList.get(i).replace(iniDir, "");
                  
                  File file = new File(root + File.separator + adjust);
                  System.out.println("file: " + file.getAbsolutePath());
                  file.mkdirs();
            }
                    
            for (String file: filesList) {
                // 파일의 OutputStream을 가져온다.
                System.out.println("다운로드: " + file);
                String adjust = file.replace(iniDir, "");
                
                try (FileOutputStream fo = new FileOutputStream(root + File.separator + adjust)) {
                    // FTPClient의 retrieveFile함수로 보내면 다운로드가 이루어 진다.
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
        // ftp를 로그아웃한다.
//        client.logout();
    }
    
    // FTP의 파일 리스트와 디렉토리 정보를 취득하는 함수.
    private static boolean getFileList(FTPClient client, String cw, List < String > files, List < String > directories) throws Exception {
        if(cw.equals(File.separator) ) {
            cw = iniDir;
        } else {
            cw = cw;
        }
        
        // FTP의 디렉토리 커서를 이동한다.
        if (client.changeWorkingDirectory(cw)) {
            // 해당 디렉토리의 파일 리스트를 취득한다.
            for (FTPFile file: client.listFiles()) {
                // 리스트의 객체가 파일이면
                if (file.isFile()) {
                    // files 리스트에 경로를 추가한다.
                    files.add(cw + file.getName());
                    System.out.println("files111: " + cw + file.getName());
                } else {
                    System.out.println("files222: " + cw + file.getName());
                    // 디렉토리리면 함수의 재귀적 방식으로 하위 탐색을 시작한다.
                    if (!getFileList(client, cw + file.getName() + File.separator, files, directories)) {
                        return false;
                    } else {
                        // directories 리스트에 디렉토리 경로를 추가한다.
                        directories.add(cw + file.getName() + File.separator);
                    }
                    
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
            msg = "로그인 정보(ID, PW)가 잘못 되었습니다.";
            return;
        }
        
        
    }
    
}
