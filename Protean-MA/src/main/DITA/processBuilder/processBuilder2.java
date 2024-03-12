package main.DITA.processBuilder;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.PumpStreamHandler;
import org.apache.commons.exec.environment.EnvironmentUtils;

import main.DITA.Common.implementOBJ;

public class processBuilder2 {
    implementOBJ obj = new implementOBJ();
    boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");
//    String runList = "";
    List<String> runList = new ArrayList<>();
    String switch1 = ""; 
    
    public processBuilder2(List<String> runList, String switch1) {
        this.runList = runList;
        this.switch1 = switch1; 
    }
    
    public void runProcessBuilder() {
        System.out.println("runProcessBuilder() 시작");
        
        DefaultExecutor exec = new DefaultExecutor();
        exec.setExitValue(0);
        
        // 에러 로그 출력
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        PumpStreamHandler streamHandler = new PumpStreamHandler(outputStream);
        exec.setStreamHandler(streamHandler);
//        String errorTxt = "";
        String outF = obj.projectDir + File.separator + "error-log.xml";
        
        
        try {
            // 환경 변수 설정
            Map<String, String> env = EnvironmentUtils.getProcEnvironment();
            
            if(switch1.equals("Integra")) {
                env.put("ANT_HOME", "");                    
            }
            
            runList.forEach(a -> {
//                String command = "H:/JAVA/java-workspace/Protean-MA/lib/idml2dita/idml2dita.exe";
//                System.out.println("console command111: " + a);
                CommandLine cmd = new CommandLine("cmd.exe");                
                cmd.addArgument("/c");

                /*
                if(switch1.equals("gs")) {
                    cmd.addArgument(obj.gsDir);
                    
                    cmd.addArgument("-sDEVICE=png16m");
                    cmd.addArgument("-dBATCH");
                    cmd.addArgument("-dNOPAUSE");
                    cmd.addArgument("-dNOPROMPT");
                    cmd.addArgument("-dQUIET");
                    cmd.addArgument("-dTextAlphaBits=4");
                    cmd.addArgument("-dGraphicsAlphaBits=4");
                    cmd.addArgument("-dInterpolateControl=-1");
                    cmd.addArgument("-r300");
                    
                    cmd.addArgument("-sOutputFile=");
                    cmd.addArgument("source");
                }
                */
                
                String command = a;
//                System.out.println("command: " + command);
                
                cmd.addArgument(command);
                
                try {
                    // execute() 메소드를 호출하여, 명령어및 환경 변수를 매개변수로 할당
                    int exitValue = exec.execute(cmd, env);
//                    System.out.println("exitValue : " + exitValue);
                    
                } catch(Exception e) {
                    
                }
                
                
                try {
                    // 에러 로그를 errorTxt 변수로 모음 
                    String errorTxt = outputStream.toString("EUC-KR");
                    FileOutputStream fos = new FileOutputStream(outF);
                    Writer writer = new OutputStreamWriter(fos, "UTF-8");
                    // 보조 보퍼
                    BufferedWriter bw = new BufferedWriter(writer);

                    // 출력 로그를 모은 errorTxt 변수가 move-meta, Fail 텍스트를 포함하고 있는 경우 예외 발생
                    if(errorTxt.contains("move-meta") | 
                       errorTxt.contains("Fail")| 
                       errorTxt.contains("has not been declared")|
                       errorTxt.contains("I/O error reported")|
                       errorTxt.contains("does not exist")) {
                        System.out.println("에러 발생, errorTxt 에러 참고");
                        bw.write(errorTxt);
                        bw.flush();
                        bw.close();
                        throw new RuntimeException("errorTxt 에러 참고");
                    }
                    
                    
                } catch(Exception e) {
                    System.out.println("ee1: " + e.getMessage());
                    throw new RuntimeException(e.getMessage());

                } 
                
                
            });
            
        } catch (Exception e2) {
            System.out.println("processBuilder2 변환실패");
            System.out.println("ee2: " + e2.getMessage());
            throw new RuntimeException(e2.getMessage());
        }
        
        System.out.println("processBuilder2 완료");

    }


}
