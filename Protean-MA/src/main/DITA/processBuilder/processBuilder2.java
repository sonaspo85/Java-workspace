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
        DefaultExecutor exec = new DefaultExecutor();
        exec.setExitValue(0);
        
        // 에러 로그 출력
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        PumpStreamHandler streamHandler = new PumpStreamHandler(outputStream);
        exec.setStreamHandler(streamHandler);
//        String errorTxt = "";
        String outF = obj.projectDir + File.separator + "error-log.xml";
        
        
        try {
            Map<String, String> env = EnvironmentUtils.getProcEnvironment();
            
            if(switch1.equals("Integra")) {
                env.put("ANT_HOME", "");                    
            }
            
            runList.forEach(a -> {
                CommandLine cmd = new CommandLine("cmd.exe");                
                cmd.addArgument("/c");

                String command = a;
                cmd.addArgument(command);
                
                try {
                    int exitValue = exec.execute(cmd, env);
                } catch(Exception e) {
                    
                }
                
                
                try {
                    String errorTxt = outputStream.toString("EUC-KR");
                    FileOutputStream fos = new FileOutputStream(outF);
                    Writer writer = new OutputStreamWriter(fos, "UTF-8");
                    BufferedWriter bw = new BufferedWriter(writer);
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
            throw new RuntimeException(e2.getMessage());
        }

    }


}
