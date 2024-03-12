package main.java.kohyoungTech.Main;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import org.apache.poi.hssf.record.WSBoolRecord;

public class templateCopy {
    implementOBJ obj = new implementOBJ();
    String outHtmlS = "";
    String msg = "";
    
    public templateCopy(String outHtmlS) {
        this.outHtmlS = outHtmlS;
    }
    
    public void templateFontCopy2(Path htmlP, Path templateP) {
        System.out.println("templateFontCopy2() 시작");

        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(templateP);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {                    
                    String getName = a.getFileName().toString();
                    

                    Path newDir = Paths.get(htmlP + File.separator + getName);
//                    System.out.println("newDir111: " + newDir);
                    try {
                        System.out.println("폴더 생성");
                        Files.createDirectories(newDir);
                        
                        templateFontCopy2(newDir, a);
                        
                    } catch (IOException e) {
                        msg = "templateA 폴더내 서브 폴더 복사 실패"; 
                        throw new RuntimeException(msg);
                    }

                } else if(Files.isRegularFile(a)) {
                    String getName = a.getFileName().toString();
                    Path parDir = a.getParent();
                    String newDir =  htmlP + File.separator + getName; 
                    
                    Path qto = Paths.get(newDir);
                    
                    if(obj.curLastLang.equals("ENG") & (getName.contains("MyriadPro-Regular.eot") | getName.contains("MyriadPro-Regular.otf"))) {
                        System.out.println("qto2: " + qto);
                        
                        try {
                            System.out.println("파일 복사!!!");
                            Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        } catch (IOException e) {
                            msg = "ENG font 복사 실패"; 
                            throw new RuntimeException(msg);
                        }
                        
                    } else if(obj.curLastLang.equals("KOR") & (getName.contains("NotoSansKR-Regular-Alphabetic.eot"))) {
                        System.out.println("qto2: " + qto);
                        
                        try {
                            System.out.println("파일 복사!!!");
                            Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        } catch (IOException e) {
                            msg = "KOR font 복사 실패"; 
                            throw new RuntimeException(msg);
                        }
                        
                    } else if(obj.curLastLang.equals("JPN") & (getName.contains("meiryo.ttc"))) {
                        System.out.println("qto2: " + qto);
                        
                        try {
                            System.out.println("파일 복사!!!");
                            Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        } catch (IOException e) {
                            msg = "JPN font 복사 실패"; 
                            throw new RuntimeException(msg);
                        }
                        
                    } else if(obj.curLastLang.equals("CHN") & (getName.contains("simsun.ttc"))) {
                        System.out.println("qto2: " + qto);
                        
                        try {
                            System.out.println("파일 복사!!!");
                            Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        } catch (IOException e) {
                            msg = "CHN font 복사 실패"; 
                            throw new RuntimeException(msg);
                        }
                        
                    } else if(getName.contains(".css") | getName.contains(".js") | getName.contains(".png")
                            | getName.contains(".svg") | getName.contains(".jpg") | getName.contains(".gif")) {
                        System.out.println("qto2: " + qto);
                        
                        try {
                            System.out.println("파일 복사!!!");
                            Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        } catch (IOException e) {
                            msg = "나머지 확장자 복사 실패"; 
                            throw new RuntimeException(msg);
                        }
                    }

                }

            });
            

        } catch (IOException e) {
            msg = "templateA 폴더 읽기 실패"; 
            throw new RuntimeException(msg);
        }
        
    }
    
}
