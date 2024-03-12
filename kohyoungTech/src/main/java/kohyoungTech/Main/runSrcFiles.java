package main.java.kohyoungTech.Main;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class runSrcFiles {
    implementOBJ obj = new implementOBJ();
    Path srcpath = null;
    String msg = "";
    
    public runSrcFiles() {
        srcpath = Paths.get(obj.srcDir);
    }
   
    
    
    public void batchEx(File batchFilePath) throws Exception {
        System.out.println("batchEx() 시작");
        int result;
        InputStreamReader isr = null;
        BufferedReader br = null;
        try {
            String command = batchFilePath.getAbsolutePath();          
            Process p =  Runtime.getRuntime().exec(command);        
            isr = new InputStreamReader(p.getInputStream());
            br = new BufferedReader(isr);
            String line = null;     
            while((line = br.readLine()) !=null){
                System.out.println("line : " + line);
            } 
            isr.close();
            br.close();
            int waitFor = p.waitFor();
        //          if(waitFor != 0) {
        //              System.out.println("waitFor != 0");
        //              return;
        //          }
            result = p.exitValue();       
            
        } catch (Exception e) {
            msg = "word2html.exe 실행 실패"; 
            throw new RuntimeException(msg);
        }

    }
    
/*
    public void word2htm() {
        System.out.println("word2htm() 시작");
        
        String word2htmlDirS = obj.projectDir + File.separator + "xsls" + File.separator + "word2html.exe";
       
        File[] contents = srcpath.toFile().listFiles();
        
        
        String s = null;
        for(File file : contents) {
            if(file.getName().endsWith(".docx")) {
                System.out.println("word2htm: " + file.getAbsolutePath());
                File newFile = new File(word2htmlDirS + " " + file);

                StringBuilder sb = new StringBuilder(2024);
                
                ProcessBuilder builder = new ProcessBuilder();
                Process process = null;
                builder.redirectErrorStream(false);
                
                builder.command("cmd.exe", "/c", newFile.toString());
                try {
                    process = builder.start();
                    
                    Reader reader = new InputStreamReader(process.getErrorStream(), "UTF-8");
                    BufferedReader stdError = new BufferedReader(reader);
                    
                    while ((s = stdError.readLine()) != null) {
                        if(s != null) {
                            sb.append(s);
                            String data = new String(sb); 
                            System.out.println("에러내용: " + data);
                            
                            process.getErrorStream().close();
                            process.getInputStream().close();
                            process.getOutputStream().close();
                            
//                            waitFor() 메서드: 현재 실행한 프로세스가 종료될 때까지 블록 
                            int exitCode = process.waitFor();
                         
                            // 프로세스 객체 내에 있는 서브프로세스를 강제로 종료
                            process.destroy();
                        }
                    }

                } catch (Exception e) {
                    msg = "story.xml 파일들을 모으기 위한 document 객체 생성 실패"; 
                    throw new RuntimeException(msg);
                }
            }

            System.out.println("word2htm 변환 완료!!!");
        }

    }
    */
    
    
}
