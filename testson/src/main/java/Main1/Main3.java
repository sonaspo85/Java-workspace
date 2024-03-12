package main.java.Main1;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class Main3 {
	final static File outDir = new File("H:/DITA/Mobile/Bat/mobile-source/out2");
	public static List<String> list = new ArrayList<>();
	public static String data = "";
	
	
	
	private static void processBuilder(boolean isWindows, String[] args) throws IOException, InterruptedException {
		System.out.println(":: START :: Use ProcessBuilder ");
        
		// 데이터를 파일로 출력
        FileOutputStream fos = new FileOutputStream("C:/Protean-MA/log.txt");
        // 문자 기반 스트림으로 변환
        Writer writer = new OutputStreamWriter(fos);
        // 보조 보퍼
        BufferedWriter bw = new BufferedWriter(writer);
        
        ProcessBuilder builder = new ProcessBuilder();
        
        // 환경변수 설정
        Map<String, String> env = builder.environment();
        
		env.put("Path", "C:/Protean-MA/functions/jdk/bin;");
		
		String saxon ="C:/Protean-MA/functions/Saxonica/lib/saxon-ee-10.0.jar;";
		String resolver = "C:/Protean-MA/functions/Saxonica/lib/xml-resolver-1.2.jar;";
		env.put("CLASSPATH", saxon + resolver);
				
		
		
		// 윈도우 환경 이라면 
		if (isWindows) {
			// List 컬렉션 반복 하여 실행
			list.forEach(a -> {
				System.out.println("path111: " + a);
				StringBuilder sb = new StringBuilder(2024);
				
				String s = null;
				Process process = null;
				
				try {
					//표준 에러 출력 방법 설정
					// false: getErrorStream(), getOutputStream() 두가지 스트림으로 나누어서 출력
					// true : getOutputStream() 하나의 스트림으로 오류내용과 정상출력 내용이 모두 같이 출력
					builder.redirectErrorStream(false);
				
					// list의 목록들을 하나씩 꺼내와 콘솔창으로 실행
//					builder.command("cmd.exe", "/c", "java net.sf.saxon.Transform  -s:H:/DITA/Mobile/Bat/mobile-source/out/master.dita  -o:H:/DITA/Mobile/Bat/mobile-source/out/master-final.dita  -xsl:H:/DITA/Mobile/Bat/mobile-source/xsls/insert-idx.xsl  -catalog:C:/Protean-MA/dita-ot/catalog-dita.xml");
					builder.command("cmd.exe", "/c", a);
//					
					process = builder.start();

					// 에러 코드 출력					
					// 바이트 기반 입력 스트림을 문자 기반 스트림으로 변환
					Reader reader = new InputStreamReader(process.getErrorStream(), "EUC-KR");
					BufferedReader stdError = new BufferedReader(reader);

					int readCharNo;  // read() 메소드가 반환 하는 총 바이트 수 저장
			        char[] cbuf = new char[1024];  // 읽은 데이터를 저장할 배열
			        
					while ((s = stdError.readLine()) != null) {
				    	if(s != null) {
				    		sb.append(s);
				    		String data = new String(sb); 
				    		System.out.println("에러내용: " + data);
							bw.write(data);
							throw new Exception("에러발생!!!");
				    	}
					}
				    
				    process.getErrorStream().close();
				    process.getInputStream().close();
				    process.getOutputStream().close();
					
//					  waitFor() 메서드: 현재 실행한 프로세스가 종료될 때까지 블록 
					int exitCode = process.waitFor();
				
				} catch(Exception e) {
					try {
					System.out.println(e.getMessage() + " 프로그램 종료!!!");
						bw.flush();
						bw.close();
						
					} catch (IOException e1) {
						e1.printStackTrace();
					}
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
		/*
		String transform = "java net.sf.saxon.Transform";
		String catalog = "C:/Protean-MA/dita-ot/catalog-dita.xml".replaceAll(" ", "%20") + " ";
		String in = "H:/DITA/Mobile/Bat/mobile-source/out/master.dita".replaceAll(" ", "%20") + " ";
		String out = "H:/DITA/Mobile/Bat/mobile-source/out/master-final.dita".replaceAll(" ", "%20") + " ";
		String xslt = "H:/DITA/Mobile/Bat/mobile-source/xsls/insert-idx.xsl".replaceAll(" ", "%20") + " ";
		String var0 = "";
		String var1 = "";
		
//		String text = "java -cp C:/Protean-MA/functions/Saxonica/lib/saxon9ee.jar;C:/Protean-MA/dita-ot/lib/xml-resolver-1.2.jar net.sf.saxon.Transform  -s:{0} -o:{1} -xsl:{2} -catalog:{3}";
		String text = "java net.sf.saxon.Transform  -s:{0} -o:{1} -xsl:{2} -catalog:{3}";
		String result = MessageFormat.format(text, in, out, xslt, catalog);
		System.out.println("result: " + result);
		list.add(result);
		*/
		
		readPath rp = new readPath();
		try {
			rp.runReadPath();
			
			// path를 모은 list 컬렉션을 반환 받음
			list = rp.getPath();
			processBuilder(isWindows, args);
			
			
		} catch (Exception e) {
			// 
			e.printStackTrace();
		}
		
		

	}
	
	
}
