package DITA.ftp;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;
import java.util.Collections;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;

import DITA.Common.implementOBJ;

import javafx.application.Platform;

public class ftpUpLoad {
    String msg = "";
    implementOBJ obj = new implementOBJ();
    
    // FTP 접속을 위한 FTPClient 객체 선언 
    FTPClient client = new FTPClient();
    
    // 파일 정보를 위한 리스트 컬렉션 생성
    List<String> filesList = new ArrayList<>();
    
    // 디렉토리 정보를 위한 리스트 변수
    List<String> directoryList = new ArrayList<>();
    
    public String iniDir = ""; 
    String outDir = "";
    
    public ftpUpLoad(String iniDir) {
        this.iniDir = iniDir; 
        System.out.println("iniDir: " + iniDir);
    }
    
    public void runFTP() throws Exception {
        System.out.println("runFTP 시작");
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
                client.setFileType(client.BINARY_FILE_TYPE);
                // 로그인 하기
                accessLogin();
                
                // ftp 파일 업로드 하기
                ftpUpload();

                // ftp를 로그아웃한다.
                client.logout();
                System.out.println("ftpDownload 끝");

            }
            
        } catch (Exception e1) { 
            throw new Exception("서버에 접속할 수 없습니다.");
            
        } finally {
            // ftp 커넥션이 연결되어 있으면 종료한다.
            try {
                if (client.isConnected()) {
                    client.disconnect();
                }
                
            } catch (Exception e2) { 
            }
        }
            
    }
    
    public void ftpUpload() throws Exception {
        System.out.println("ftpUpload() 시작");
        
        outDir = obj.srcPathP + "\\output";

        // 로컬 디렉토리 파일과 디렉토리 정보를 취득
        getUploadList(outDir, filesList, directoryList);
        
        // 디렉토리 생성
        // 컬렉션의 마지막 부터 호출해서 디렉토리 생성해야함
        Collections.reverse(directoryList);
        for (String directory: directoryList) {
            client.makeDirectory(directory);
        }

        // 파일 업로드
        for (String file: filesList) {
//            System.out.println("파일 업로드: "+file);

            // 파일 InputStream을 가져온다.
            FileInputStream fis = new FileInputStream(file);
            client.storeFile(file.replace(outDir, iniDir), fis);
            System.out.println("Upload - " + file);
        }

        
    }
    
    // 로컬의 파일 리스트와 디렉토리 정보를 취득하는 함수.
    private void getUploadList(String localDir, List<String> files, List<String> directories) throws Exception {
        System.out.println("getUploadList 시작");
        Path path = Paths.get(localDir);
        
        System.out.println("localDir: " + localDir);
        System.out.println("iniDir: " + iniDir);
        if(Files.exists(path)) {
            System.out.println("폴더 존재 함");
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                try {
                      if(Files.isDirectory(a)) {
                          // 디렉토리리면 함수의 재귀적 방식으로 하위 탐색을 시작한다.
                          getUploadList(a.toString(), files, directories);

                          // directories 리스트에 디렉토리 경로를 추가한다.
                          directories.add(a.toString().replace(outDir, iniDir));
//                          System.out.println("업로드 디렉토리: "+ a.toString().replace(outDir, iniDir));
                          
                      } else {  // 파일인 경우
                        files.add(a.toString());
//                        System.out.println("업로드 파일: "+ a.toString().replace(outDir, iniDir));
                      }
                      
                    } catch (Exception e) {
                      e.printStackTrace();
                }
                                
            });
            
        }

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
    
}
