package runMain;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;



public class Main {
	final static File outDir = new File("H:/DITA/Mobile/Bat/mobile-source/out2");

	private static void processBuilder(boolean isWindows, String[] args) throws IOException, InterruptedException {
		System.out.println(":: START :: Use ProcessBuilder ");
		
//        System.setProperty("javax.xml.transform.TransformereFactory", "net.sf.saxon.TransformerFactoryImpl");
        
        List<String> list = new ArrayList<>();
//        list.add("java net.sf.saxon.Transform  -s:H:\\DITA\\Mobile\\Bat\\idmlTdita\\resource\\xml\\newMerged.xml  -o:H:\\DITA\\Mobile\\Bat\\idmlTdita\\temp\\00-skeleton.xml  -xsl:H:\\DITA\\Mobile\\Bat\\idmlTdita\\xsls\\00-skeleton.xsl");
//        list.add("java net.sf.saxon.Transform  -s:H:\\DITA\\Mobile\\Bat\\idmlTdita\\temp\\00-skeleton.xml  -o:H:\\DITA\\Mobile\\Bat\\idmlTdita\\temp\\01-clearAttr.xml  -xsl:H:\\DITA\\Mobile\\Bat\\idmlTdita\\xsls\\01-clearAttr.xsl");
        
				
		
        ProcessBuilder builder = new ProcessBuilder();
		
        Map<String, String> env = builder.environment();
//		env.put("PING_WEBSITE", "stackabuse.com");
		env.put("JAVA_HOME", "C:\\Program Files\\Java\\openjdk-18.0.1");
		env.put("Path", "%JAVA_HOME%\\bin;%Path%");
		env.put("SAXON_DIR", "C:\\Saxonica\\");
		env.put("CLASSPATH", "%SAXON_DIR%lib;%CLASSPATH%");
		env.put("CLASSPATH", "%SAXON_DIR%lib\\saxon-ee-test-10.0.jar;%CLASSPATH%");
//		env.put("CLASSPATH", "");
		env.put("ditavalDIR", "H:\\DITA\\Mobile\\Bat\\mobile-source\\_filters\\");
		env.put("dita", "C:\\DITA-OT-MA\\bin\\");
		env.put("ditaval", "en-GB.ditaval");

		list.add("call %dita%dita.bat  --input=H:\\DITA\\Mobile\\Bat\\mobile-source\\PROJECT.ditamap  --transtype=merged  --output=H:\\DITA\\Mobile\\Bat\\mobile-source\\out  --args.filter=%ditavalDIR%%ditaval%");
		
		if (isWindows) {
			// List 컬렉션 반복 하여 실행
			list.forEach(a -> {
				StringBuilder sb = new StringBuilder(2024);
				String s = null;
				
				Process process = null;
				
				try {
					builder.command("cmd.exe", "/c", a);
					
					
					process = builder.start();
					
					// 에러 코드 출력
					BufferedReader stdError = new BufferedReader(new InputStreamReader(process.getErrorStream()));
					
				    while ((s = stdError.readLine()) != null) {
				    	if(s != null) {
				    		sb.append(s);
							System.out.println("에러코드: " + sb);
							
							throw new Exception("에러발생!!!");
				    	}
					}
				    
				    
				    process.getErrorStream().close();
				    process.getInputStream().close();
				    process.getOutputStream().close();
					
					//  waitFor() 메서드: 현재 실행한 프로세스가 종료될 때까지 블록 
					int exitCode = process.waitFor();
				
				} catch(Exception e) {
					System.out.println(e.getMessage() + " 프로그램 종료!!!");
					
					// 에러 발생시 시스템 종료하기
					System.exit(0);
					
				} finally {
					if(process != null) {
						System.out.println("현제 프로세스 완료, 다음 프로세스 실행");
					} 
					
					try { 
						// 프로세스 객체 내에 있는 서브프로세스를 강제로 종료
						process.destroy();
						
					} catch(Exception e2) {

					}
					
				}
				
			});
			System.out.println("프로세스 작동 완료");
		}
		
		else {
		    builder.command("sh", "-c", "ls -l | grep P");
		}
		
		
	}
	

	public static void main(String[] args) throws IOException, InterruptedException {
		boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");
		processBuilder(isWindows, args);
		
		
		/*
//		-----------------------------------------------
//		https://stackabuse.com/managing-environment-variables-in-java/
		// Setting up the environment...
		ProcessBuilder processBuilder = new ProcessBuilder();
		Map<String, String> env = processBuilder.environment();
//		env.put("PING_WEBSITE", "stackabuse.com");
		env.put("JAVA_HOME", "C:\\Program Files\\Java\\jdk-18.0.1");
		env.put("Path", "%JAVA_HOME%\\bin;%Path%");
		env.put("SAXON_DIR", "C:\\Saxonica\\");
		env.put("CLASSPATH", "%SAXON_DIR%lib;%CLASSPATH%");
		env.put("CLASSPATH", "%SAXON_DIR%lib\\saxon-ee-test-10.0.jar;%CLASSPATH%");
//		env.put("CLASSPATH", "");
		env.put("ditavalDIR", "H:\\DITA\\Mobile\\Bat\\mobile-source\\_filters\\");
		env.put("dita", "C:\\DITA-OT-MA\\bin\\");
		env.put("ditaval", "en-GB");
//		processBuilder.command("cmd.exe", "/c", " echo %ditaval%");
		

		if (System.getProperty("os.name").startsWith("Windows")) {
//		    processBuilder.command("cmd.exe", "/c", " echo=%aaa%");
			processBuilder.command("cmd.exe", "/c", "call %dita%dita.bat  --input=H:\\DITA\\Mobile\\Bat\\mobile-source\\PROJECT.ditamap  --transtype=merged  --args.filter=%ditavalDIR%%ditaval%");
		    
		} else {
//		    processBuilder.command("/bin/bash", "-c", "ping $PING_WEBSITE$");
		}

		try {
		    // Starting the process...
		    Process process = processBuilder.start();

		    // Reading the output of the process
		    try (BufferedReader reader = new BufferedReader(
		            new InputStreamReader(process.getInputStream()))) {

		        String line;

		        while ((line = reader.readLine()) != null) {
		             System.out.println(line);
		        }
		    }

		    // Catch the exit code of our process
		    int ret = process.waitFor();

		    System.out.printf("Program exited with code: %d", ret);

		} catch (IOException | InterruptedException e) {
		    // Handle exception...
		    e.printStackTrace();
		}*/
		
		
		
		
		
	}
	
	
	
}
