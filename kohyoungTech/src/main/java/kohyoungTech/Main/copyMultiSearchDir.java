package main.java.kohyoungTech.Main;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

public class copyMultiSearchDir {
	implementOBJ obj = new implementOBJ();
	String msg = "";
	String multiSearchSrcDir = ""; 
	String multiTemplateDir = "";
	
	public copyMultiSearchDir() {
		
	}
	
	public void templateSearchCopy(Path templateDir, Path srcDirP) {
		System.out.println("templateSearchCopy() 시작");
		
		
		try {
			DirectoryStream<Path> ds = Files.newDirectoryStream(templateDir);
			
			ds.forEach(a -> {
				if(Files.isDirectory(a)) {
					String getName = a.getFileName().toString();
					Path newDir = Paths.get(templateDir + File.separator + getName);
					System.out.println("newDir: " + newDir);
					
					Path tarDir = Paths.get(srcDirP + File.separator + getName);
					
					try {
						System.out.println("폴더 생성");
						Files.createDirectories(tarDir);
						
						// 재귀적 호출
						templateSearchCopy(newDir, tarDir);

					} catch (IOException e) {
						System.out.println("폴더 생성 실패");
						e.printStackTrace();
					}
					
				} else if(Files.isRegularFile(a) & !a.toString().contains("index.html")) {
					String getName = a.getFileName().toString();
					Path parDir = a.getParent();
					
					// 속하고 있는 경로 추출
					String extraDir = parDir.toString().replace(obj.multiTemplateDir, "");
					Path tarP = Paths.get(srcDirP + File.separator + getName);
					
					try {
						System.out.println("파일 복사!!!");
						Files.copy(a, tarP, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
						
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}

			});
			

		} catch (IOException e) {
			System.out.println("templateSearchCopy 읽기 실패");
			msg = "templateSearchCopy 읽기 실패";
            throw new RuntimeException(msg);

		}
		
		
	}
}
