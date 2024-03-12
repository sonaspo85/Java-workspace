package main.java.kohyoungTech.Main;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;

public class multiSearchControl {
	implementOBJ obj = new implementOBJ();
	Path multiSearchP = null;
	List<String> folderName = new ArrayList<>();
	List<String> lgnsList = new ArrayList<String>();
	String codesF = "";
	
	public void runSearchControl() {
		System.out.println("runSearchControl() 시작");
		
		multiSearchP = Paths.get(obj.multiSearchSrcDir);

		try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(multiSearchP);
            
            
            ds.forEach(a -> {
                if (Files.isDirectory(a)) {
                    String fileName = a.getFileName().toString();
//                    System.out.println("fileName: " + fileName);
                    folderName.add(fileName);

                    // 자식 폴더에 대해서 다시 반복문 하기
                    try {
						DirectoryStream<Path> ds2 = Files.newDirectoryStream(a);
						
						ds2.forEach(b -> {
			                if (Files.isDirectory(b)) {
			                    String fileName2 = b.getFileName().toString();
			                    System.out.println("fileName: " + fileName2);
			                    folderName.add(fileName2);
			                }
						});
						
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
                    
                } 
                
            });

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("디렉토리내 목록 없음");
        }
				
	}
	
	public boolean isStringUpperCase(String str) {
	    char[] charArray = str.toCharArray();

	    for (int index = 0; index < charArray.length; index++) {
	        if (!Character.isUpperCase(charArray[index]))
	            return false;
	    }
	    return true;
	}
	
	
	public LinkedHashSet<String> compareLang() {
		System.out.println("compareLang() 시작");
		
		List<String> lastName = new ArrayList<>();
		
		folderName.forEach(c -> {
			if(c.length() == 3 & isStringUpperCase(c)) {
				// 마지막 언어명 추출
		        int lastDot = c.lastIndexOf("_");
		        String lastStr = c.substring(lastDot + 1);
		        System.out.println("lastStr: " + lastStr);
		        lastName.add(lastStr);
			}

			
		});
		
		// 중복 항목 제거 - LinkedHashSet 객체 활용
		LinkedHashSet<String> uniqLastName = new LinkedHashSet<>(lastName);
		
		// index.html 에 넣기 위한 언어 목록 추출
		obj.multiFolderLang.addAll(uniqLastName);
		
		codesF = obj.projectDir + File.separator + "xsls" + File.separator + "codes.xml";
		getLanguageCode lc = new getLanguageCode(codesF);
		lgnsList = lc.getISOCode();
		System.out.println("aaa: " + lgnsList);
		
		// 일치하지 않는 언어 추출
		uniqLastName.removeAll(lgnsList);
		
		System.out.println("uniqLastName: " + uniqLastName.toString());
		return uniqLastName;
		
	}
	
	
	public boolean checkSCharacters(String str) {
	    boolean result = str.matches("[0-9|a-z|A-Z|\\-|_]*");
	    return result;
	}
}
