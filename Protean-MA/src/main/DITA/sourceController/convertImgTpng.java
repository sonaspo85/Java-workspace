package main.DITA.sourceController;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import main.DITA.Common.implementOBJ;
import main.DITA.processBuilder.processBuilder2;

public class convertImgTpng {
    implementOBJ obj = new implementOBJ();
    String sMapDir = null;
    String outMapDir = "";
    String  pvPath = "";
    String  strlb1 = "";
    String strcb1 = "";
    String newImagePathS = "";
    String msg = "";
    
    List<String> runList = new ArrayList<>();
    
    public convertImgTpng(Path sMapDir, String  outMapDir, String  pvPath, String  strlb1, String strcb1, String newImagePathS) {
        this.sMapDir = sMapDir.toString();
        this.outMapDir = outMapDir;
        this.pvPath = pvPath;
        this.strlb1 = strlb1;
        this.strcb1 = strcb1;
        this.newImagePathS = newImagePathS; 
    }
    
    public void runImgTpng() {
        try {
            // 저장 경로 설정
            String out1 = newImagePathS + File.separator + "out1";
            Path out1P = Paths.get(out1);
            
            if(Files.notExists(out1P)) {
                Files.createDirectories(out1P);
            }
            
            
            Path path = Paths.get(newImagePathS);
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                String fileName = a.getFileName().toString();
                
                if(fileName.endsWith(".ai")) {
                    String fullPath = a.toAbsolutePath().toString();
                    String newFileName = out1P + File.separator + fileName.replace(".ai", ".png");
                    String gsDir = obj.gsDir;
                    String optionTxt = "-sDEVICE=png16m -dBATCH -dNOPAUSE -dNOPROMPT -dQUIET -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -dInterpolateControl=-1 -r300";
                    String sOutputFile = newFileName;
                    String srcFile = a.toString();
                    String text = "{0} {1} -sOutputFile={2} {3}";
                    String result = MessageFormat.format(text, gsDir, optionTxt, sOutputFile, srcFile);
                    
                    runList.add(result);
                    
                    
                } else if(fileName.endsWith(".png")) {
                    String fullPath = a.toAbsolutePath().toString();
                    
                    String newFileName = out1P + File.separator + fileName;
                    Path newFileNameP = Paths.get(newFileName);
                    
                    File qdir = new File(a.toString());
                    Path qto = Paths.get(newFileName);
                    
                    try {
                        Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                    } catch (IOException e) {
                        
                        e.printStackTrace();
                    }
                    
                }
                    
            });
            
            
            // 
            String switch1 = "gs";
            processBuilder2 exeExcute = new processBuilder2(runList, switch1);
            exeExcute.runProcessBuilder();
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
    }
    
    public void getImageinBasic(Path newImagePathP) {
        System.out.println("getImageinBasic() 시작");


        String oldImagePathS = sMapDir + File.separator + "BASIC/images" + File.separator + strcb1;
        System.out.println("oldImagePathS: " + oldImagePathS);
        Path oldImagePathP = Paths.get(oldImagePathS);

        // 언어별 폴더 존재하는지 확인
        if (Files.exists(oldImagePathP)) {
            System.out.println("언어별 폴더 존재 함");

            try {
                obj.dirCopy(newImagePathP, oldImagePathP);


            } catch (Exception e) {
                msg = "BASIC/images" + strcb1 + " 폴더 복사 실패!!";
                throw new RuntimeException(msg);

            }

        }

    }
    
    
}
