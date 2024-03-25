package main.DITA.sourceController;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import main.DITA.Common.implementOBJ;

public class imageDelNCopy {
    implementOBJ obj = new implementOBJ();
    String sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4 = "";
    String msg = "";
    String zDiridmlTempls = "";
    
    
    public imageDelNCopy(Path sMapDir, String outMapDir, String pvPath, String strlb1, String strcb1, String strcb2, String strcb3, String strcb4) {
        this.sMapDir = sMapDir.toString();
        this.outMapDir = outMapDir;
        this.pvPath = pvPath;
        this.strlb1 = strlb1;
        this.strcb1 = strcb1;
        this.strcb2 = strcb2;
        this.strcb3 = strcb3;
        this.strcb4 = strcb4;
        zDiridmlTempls = obj.zDiridmlTempls; 
    }
    
    public void delImageinBasic() {
        String oldImagePathS = sMapDir + File.separator + "BASIC/images";
        Path oldImagePathP = Paths.get(oldImagePathS);
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(oldImagePathP);
            
            ds.forEach(a -> {
                if(Files.isRegularFile(a)) {
                    try {
                        Files.delete(a);
                        
                    } catch (IOException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                    
                } 
                
            });
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
    public void getImageinBasic(Path newImagePathP) {
        String oldImagePathS = sMapDir + File.separator + "BASIC/images" + File.separator + strcb1;
        System.out.println("oldImagePathS: " + oldImagePathS);
        Path oldImagePathP = Paths.get(oldImagePathS);

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
    
    public void copyidmlTemplates() {
        System.out.println("copyidmlTemplates() 시작");

        String oldidmltemplS = "";
        Path oldidmltemplP = null;
        String newidmlTemplS = obj.DiridmlTempls + File.separator;
        Path newidmltemplP = Paths.get(newidmlTemplS);

        if (strcb2.contains("OS_upgrade")) {
            oldidmltemplS = zDiridmlTempls + File.separator + "OS_upgrade" + File.separator + strcb1;

        } else if (strcb2.contains("default")) {
            oldidmltemplS = zDiridmlTempls + File.separator + "default" + File.separator + strcb1;
        }
        
        System.out.println("oldidmltemplS: " + oldidmltemplS);
        oldidmltemplP = Paths.get(oldidmltemplS);

        copyTempls(newidmltemplP, oldidmltemplP);

    }
    
    public void copyTempls(Path newPath, Path oldPath) {
        try {
            DirectoryStream <Path> ds = Files.newDirectoryStream(oldPath);

            ds.forEach(a -> {
                if (Files.isDirectory(a)) {
                    String getName = a.getFileName().toString();

                    if (getName.contains("Resources") | getName.contains("MasterSpreads") | getName.contains("Stories")) {
                        Path newDir = Paths.get(newPath + File.separator + getName);

                        try {
                            copyTempls(newDir, a);

                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                    }

                } else if (Files.isRegularFile(a)) {
                    String getName = a.getFileName().toString();
                    String getParent = a.getParent().getFileName().toString();

                    if (getParent.equals("Resources") | getParent.equals("MasterSpreads") | getParent.equals("Stories")) {
                        Path parDir = a.getParent();
                        String newDir = newPath + File.separator + getName;
                        File qdir = new File(a.toString());
                        Path qto = Paths.get(newDir);

                        try {
                            Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        } catch (IOException e) {
                            msg = "idml templates 폴더 복사 실패";
                            throw new RuntimeException(msg);

                        }

                    }

                }


            });


        } catch (Exception e) {
        }
    }
    
    public Path copyImgTidml() {
        String newImagePathS = outMapDir + File.separator + "2_IDML" + File.separator + strlb1 + File.separator + "images";
        Path newImagePathP = Paths.get(newImagePathS);
        
        if (Files.notExists(newImagePathP)) {
            try {
                Files.createDirectories(newImagePathP);
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }

        return newImagePathP;

    }
    
    public void copyChapterImg() {
        String commonImageS = obj.libDir + File.separator + "idml-template/imgTemplate/Common";
        copyUpgradeImg(commonImageS);
        
        if (strcb2.contains("OS_upgrade")) {
            String templsImageS = obj.libDir + File.separator + "idml-template/imgTemplate/osUpgrade";
            copyUpgradeImg(templsImageS);

        } else if (strcb2.contains("default")) {
            String templsImageS = obj.libDir + File.separator + "idml-template/imgTemplate/default";
            copyUpgradeImg(templsImageS);
        }
          
    }
    
    public void copyUpgradeImg(String ImageS) {
        Path commonImageP = Paths.get(ImageS);
        
        try {
            DirectoryStream <Path> ds = Files.newDirectoryStream(commonImageP);
            
            ds.forEach(a -> {
                String fileName = a.getFileName().toString();

                if (Files.isRegularFile(a)) {
                    String newImageS = outMapDir + File.separator + "2_IDML" + File.separator + strlb1 + File.separator + "images" + File.separator + fileName;
                    Path newImageP = Paths.get(newImageS);
                    
                    try {
                        Files.copy(a, newImageP, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        
                    } catch (IOException e) {
                        e.printStackTrace();
                        msg = "idml templates 폴더 복사 실패";
                        throw new RuntimeException(msg);

                    }
                    
                }
                
            });
            
        } catch(Exception e) {
            msg = "chapter 이미지 복사 실패";
            throw new RuntimeException(msg);
            
        }
        
    }
    
    
}
