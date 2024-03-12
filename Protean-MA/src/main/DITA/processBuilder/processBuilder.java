package main.DITA.processBuilder;

import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteWatchdog;
import org.apache.commons.exec.PumpStreamHandler;
import org.apache.commons.exec.environment.EnvironmentUtils;

import main.DITA.Common.implementOBJ;

public class processBuilder {
    implementOBJ obj = new implementOBJ();
    boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");
    List<String> runList = new ArrayList<>();
    String switch1 = "";
    String msg = "";
    String data11 = "";
    
    public processBuilder(List<String> runList, String switch1) {
        this.runList = runList;
        this.switch1 = switch1; 
    }
    
    @SuppressWarnings("finally")
    public void runProcessBuilder() {
        System.out.println("runProcessBuilder() 시작");
        
        DefaultExecutor exec = new DefaultExecutor();
        exec.setExitValue(0);

        // 에러 로그 출력
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        ByteArrayOutputStream errorStream = new ByteArrayOutputStream();
        PumpStreamHandler streamHandler = new PumpStreamHandler(outputStream, errorStream);
//        PumpStreamHandler streamHandler = new PumpStreamHandler(System.out);
        exec.setStreamHandler(streamHandler);

        String outF = obj.projectDir + File.separator + "error-log.xml";
        
        try {
            // 환경 변수 설정
            Map<String, String> env = EnvironmentUtils.getProcEnvironment();

            env.put("Path", obj.jdkDir + File.separator + "bin;");
            
            env.put("_JAVA_OPTIONS", "-Xmx2048m -Xms2048m -XX:+HeapDumpOnOutOfMemoryError");
            env.put("ANT_OPTS", "-Xmx2048M");
            env.put("ANT_OPT", obj.pdfSetting + File.separator + "pdf-settings.xml");
            env.put("AHF71_32_FONT_CONFIGFILE", obj.pdfSetting + File.separator + "font-config.xml");
            
            String saxon = obj.saxonDir + File.separator + "saxon-ee-10.0.jar;";
            String resolver = obj.saxonDir + File.separator + "xml-resolver-1.2.jar";
            
            if(switch1.equals("dita")) {
                System.out.println("run dita-process");
                env.put("CLASSPATH", "");
                
            } else if(switch1.equals("xslt") | switch1.equals("idml") | switch1.equals("html")) {
                System.out.println("run xslt-process");
                env.put("CLASSPATH", saxon + resolver);
                
            }

            runList.forEach(a -> {
                System.out.println("console command: " + a);
                CommandLine cmd = new CommandLine("cmd.exe");
                cmd.addArgument("/c");
//                String command = "C:\\DITA-OT-MA\\bin\\dita.bat --input=H:\\DITA\\Mobile\\Bat\\mobile-source\\PROJECT.ditamap --output=H:\\DITA\\Mobile\\Bat\\mobile-source\\out --transtype=merged --args.filter=H:\\DITA\\Mobile\\Bat\\mobile-source\\_filters\\en-GB.ditaval";
                String command = a;
                cmd.addArgument(command);
                
                try {
                	// execute() 메소드를 호출하여, 명령어및 환경 변수를 매개변수로 할당
                	int exitValue = exec.execute(cmd, env);
                	System.out.println("exitValue : " + exitValue);

                	String outTxt = outputStream.toString("EUC-KR");
                    String errorTxt = errorStream.toString("EUC-KR");
                    
                    String result = outTxt + errorTxt;
                    
                    // 콘솔창에서 에러를 발생하지만, 중지되지 않는 경우
                	try {
                        // 에러 로그를 errorTxt 변수로 모음
                        FileOutputStream fos = new FileOutputStream(outF);
                        Writer writer = new OutputStreamWriter(fos, "UTF-8");
                        // 보조 보퍼
                        BufferedWriter bw = new BufferedWriter(writer);

                        // 출력 로그를 모은 errorTxt 변수가 move-meta, Fail 텍스트를 포함하고 있는 경우 예외 발생
                        if(result.contains("move-meta") | 
                                result.contains("Fail")| 
                                result.contains("has not been declared")|
                                result.contains("I/O error reported")|
                                result.contains("does not exist")) {
                            System.out.println("에러 발생, errorTxt 에러 참고");
//                            bw.write(errorTxt);
                            
                            bw.write(result);
                            bw.flush();
                            bw.close();
                            throw new RuntimeException("errorTxt 에러 참고");
                        }
                        
                    } catch(Exception e1) {
                        throw new RuntimeException(e1.getMessage());
                    }
                	
                	
                } catch(Exception e) {
                    // 콘솔창에서 에러를 발생하여, 중지되는 경우
                    try {
                        String outTxt = outputStream.toString("UTF-8");
                        String errorTxt = errorStream.toString("UTF-8");

                        // 출력 로그를 모은 errorTxt 변수가 move-meta, Fail 텍스트를 포함하고 있는 경우 예외 발생
                        FileOutputStream fos = new FileOutputStream(outF);
                        Writer writer = new OutputStreamWriter(fos, "UTF-8");
                        // 보조 보퍼
                        BufferedWriter bw = new BufferedWriter(writer);
                        
                        bw.write(outTxt + errorTxt);
                        bw.flush();
                        bw.close();
                        throw new RuntimeException("errorTxt 에러 참고");
                        
                    } catch (Exception e1) {
                        System.out.println("e22: " + e1.getMessage());
//                        throw new RuntimeException(e1.getMessage());
                        
                    } finally {
                        System.out.println("finally!!!");
                        throw new RuntimeException("errorTxt 에러 참고");
                    }

                }
                
            });
            
        } catch (Exception e2) {
            System.out.println("processBuilder2 변환실패");
            System.out.println("e333: " + e2.getMessage());
            throw new RuntimeException(e2.getMessage());
//            e2.printStackTrace();
        }
        
        System.out.println("processBuilder2 완료");
    }

    
}
