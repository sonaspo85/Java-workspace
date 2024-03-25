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
        DefaultExecutor exec = new DefaultExecutor();
        exec.setExitValue(0);

        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        ByteArrayOutputStream errorStream = new ByteArrayOutputStream();
        PumpStreamHandler streamHandler = new PumpStreamHandler(outputStream, errorStream);
        exec.setStreamHandler(streamHandler);

        String outF = obj.projectDir + File.separator + "error-log.xml";
        
        try {
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
                String command = a;
                cmd.addArgument(command);
                
                try {
                	int exitValue = exec.execute(cmd, env);
                	String outTxt = outputStream.toString("EUC-KR");
                    String errorTxt = errorStream.toString("EUC-KR");
                    String result = outTxt + errorTxt;

                	try {
                        FileOutputStream fos = new FileOutputStream(outF);
                        Writer writer = new OutputStreamWriter(fos, "UTF-8");
                        BufferedWriter bw = new BufferedWriter(writer);
                        
                        if(result.contains("move-meta") | 
                                result.contains("Fail")| 
                                result.contains("has not been declared")|
                                result.contains("I/O error reported")|
                                result.contains("does not exist")) {
                            System.out.println("에러 발생, errorTxt 에러 참고");
                            
                            bw.write(result);
                            bw.flush();
                            bw.close();
                            throw new RuntimeException("errorTxt 에러 참고");
                        }
                        
                    } catch(Exception e1) {
                        throw new RuntimeException(e1.getMessage());
                    }
                	
                	
                } catch(Exception e) {
                    try {
                        String outTxt = outputStream.toString("UTF-8");
                        String errorTxt = errorStream.toString("UTF-8");
                        FileOutputStream fos = new FileOutputStream(outF);
                        Writer writer = new OutputStreamWriter(fos, "UTF-8");
                        BufferedWriter bw = new BufferedWriter(writer);
                        
                        bw.write(outTxt + errorTxt);
                        bw.flush();
                        bw.close();
                        throw new RuntimeException("errorTxt 에러 참고");
                        
                    } catch (Exception e1) {                        
                    } finally {
                        throw new RuntimeException("errorTxt 에러 참고");
                    }

                }
                
            });
            
        } catch (Exception e2) {
            throw new RuntimeException(e2.getMessage());
        }

    }

    
}
