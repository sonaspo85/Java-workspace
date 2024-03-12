package main.DITA.runPublishing;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

import main.DITA.Common.implementOBJ;
import main.DITA.processBuilder.ditareadPath;
import main.DITA.processBuilder.processBuilder;
import main.DITA.processBuilder.xsltreadPath;

public class idmlPublishing {
    implementOBJ obj = new implementOBJ();
    List < String > runList = new ArrayList < > ();
    
    String outMapDir = "";
    String idmlTempsDir = "";
    String msg = "";
    String strlb1 ="";

    
    public idmlPublishing(String outMapDir, String strlb1) {
        this.outMapDir = outMapDir;
        this.idmlTempsDir = outMapDir + File.separator + "idmlTemp";
        
        this.strlb1 = strlb1;
    }


    public void runIdmlPublishing() {
        System.out.println("runIdmlPublishing() 시작");

        String inF = obj.libDir + File.separator + "z4-xslt-idml-publishing.xml";

        String switch1 = "idml";
        xsltreadPath xsltreadPath = new xsltreadPath(outMapDir, strlb1);
        try {
            xsltreadPath.runReadPath(inF, switch1);
            runList = xsltreadPath.getPath();

            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();

        } catch (Exception e1) {
            msg = e1.getMessage();
            System.out.println("msg: " + msg);
            throw new RuntimeException(e1);
        }
    }
    
    public void copyIdml(String idmlout, String newIdmlS) {
        System.out.println("copyIdml() 시작");

        Path oldIdmlP = Paths.get(idmlout);
        
        try {
            DirectoryStream <Path> ds = Files.newDirectoryStream(oldIdmlP);
            
            ds.forEach(a -> {
                String fileName = a.getFileName().toString();

                if (Files.isRegularFile(a)) {
                    // 저장될 경로 지정
                    String newIdmlS2 = newIdmlS + File.separator + fileName;
                    Path newImageP = Paths.get(newIdmlS2);
                    
                    try {
                        System.out.println("파일 복사!!!");
                        Files.copy(a, newImageP, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        
                    } catch (IOException e) {
                        e.printStackTrace();
                        msg = "idml 파일 복사 실패";
                        throw new RuntimeException(msg);

                    }
                    
                }
                
            });
            
        } catch(Exception e) {
            msg = "idml 폴더 읽기 실패";
            throw new RuntimeException(msg);
            
        }
        
    }


}