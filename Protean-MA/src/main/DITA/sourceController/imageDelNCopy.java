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
        System.out.println("delImageinBasic() 시작");
        
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
        System.out.println("getImageinBasic() 시작");


        String oldImagePathS = sMapDir + File.separator + "BASIC/images" + File.separator + strcb1;
        System.out.println("oldImagePathS: " + oldImagePathS);
        Path oldImagePathP = Paths.get(oldImagePathS);

        // 새로 저장될 경로 설정
//        String newImagePathS = sMapDir + File.separator + "BASIC/images";

        // 언어별 폴더 존재하는지 확인
        if (Files.exists(oldImagePathP)) {
            System.out.println("언어별 폴더 존재 함");

            try {
                // 언어별 images 폴더가 있다면 복사함
                obj.dirCopy(newImagePathP, oldImagePathP);


            } catch (Exception e) {
                // 재귀적 파일 복사 실패
                msg = "BASIC/images" + strcb1 + " 폴더 복사 실패!!";
                throw new RuntimeException(msg);

            }

        }

    }
    
    public void copyidmlTemplates() {
        System.out.println("copyidmlTemplates() 시작");

        String oldidmltemplS = "";
        Path oldidmltemplP = null;

        // 새롭게 저장될 폴더 지정
        //        String newidmlTemplS = obj.libDir + File.separator + "idml-templates/template";
        String newidmlTemplS = obj.DiridmlTempls + File.separator;
        Path newidmltemplP = Paths.get(newidmlTemplS);

        if (strcb2.contains("OS_upgrade")) {
            oldidmltemplS = zDiridmlTempls + File.separator + "OS_upgrade" + File.separator + strcb1;

        } else if (strcb2.contains("default")) {
            oldidmltemplS = zDiridmlTempls + File.separator + "default" + File.separator + strcb1;
        }
        
        System.out.println("oldidmltemplS: " + oldidmltemplS);
        oldidmltemplP = Paths.get(oldidmltemplS);

        // 특정폴더만 골라 재귀적 복사
        copyTempls(newidmltemplP, oldidmltemplP);

    }
    
    public void copyTempls(Path newPath, Path oldPath) {
        System.out.println("copyTempls() 시작");
        System.out.println("oldPath: " + oldPath.toAbsolutePath());
        
        try {
            DirectoryStream <Path> ds = Files.newDirectoryStream(oldPath);

            ds.forEach(a -> {
                if (Files.isDirectory(a)) {
                    String getName = a.getFileName().toString();

                    if (getName.contains("Resources") | getName.contains("MasterSpreads") | getName.contains("Stories")) {
                        Path newDir = Paths.get(newPath + File.separator + getName);
                        System.out.println("newDir111: " + newDir);

                        try {
                            System.out.println("폴더 생성");

                            // 재귀적 호출
                            copyTempls(newDir, a);

                        } catch (Exception e) {
                            System.out.println("폴더 생성 실패");
                            e.printStackTrace();
                        }

                    }

                } else if (Files.isRegularFile(a)) {
                    String getName = a.getFileName().toString();
                    String getParent = a.getParent().getFileName().toString();
                    //                    System.out.println("getName: " + getName);
                    //                    System.out.println("getParent: " + getParent);

                    if (getParent.equals("Resources") | getParent.equals("MasterSpreads") | getParent.equals("Stories")) {

                        Path parDir = a.getParent();
                        String newDir = newPath + File.separator + getName;
                        System.out.println("zDir: " + a);
                        System.out.println("newDir: " + newDir);

                        File qdir = new File(a.toString());
                        Path qto = Paths.get(newDir);

                        try {
                            //                            System.out.println("파일 복사!!!");
                            Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        } catch (IOException e) {
                            msg = "idml templates 폴더 복사 실패";
                            throw new RuntimeException(msg);
                            //                            e.printStackTrace();

                        }

                    }

                }


            });


        } catch (Exception e) {
            System.out.println("implementObj -> dirCopy() 메소드 에러");
            System.out.println(e.getMessage());
//                      e.printStackTrace();
        }
    }
    
    public Path copyImgTidml() {
        System.out.println("copyImgTidml() 시작");

        String newImagePathS = outMapDir + File.separator + "2_IDML" + File.separator + strlb1 + File.separator + "images";
        Path newImagePathP = Paths.get(newImagePathS);

        // 언어코드/images 폴더 생성
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
        System.out.println("copyChapterImg() 시작");
        
        String commonImageS = obj.libDir + File.separator + "idml-template/imgTemplate/Common";
        copyUpgradeImg(commonImageS);
        
        if (strcb2.contains("OS_upgrade")) {
            System.out.println("aaaa");
                
            String templsImageS = obj.libDir + File.separator + "idml-template/imgTemplate/osUpgrade";
            copyUpgradeImg(templsImageS);

        } else if (strcb2.contains("default")) {
            System.out.println("bbbb");
            
            String templsImageS = obj.libDir + File.separator + "idml-template/imgTemplate/default";
            copyUpgradeImg(templsImageS);
        }
          
    }
    
    public void copyUpgradeImg(String ImageS) {
        System.out.println("copyUpgradeImg() 시작");

        Path commonImageP = Paths.get(ImageS);
        
        try {
            DirectoryStream <Path> ds = Files.newDirectoryStream(commonImageP);
            
            ds.forEach(a -> {
                String fileName = a.getFileName().toString();

                if (Files.isRegularFile(a)) {
                    // 저장될 경로 지정
                    String newImageS = outMapDir + File.separator + "2_IDML" + File.separator + strlb1 + File.separator + "images" + File.separator + fileName;
                    Path newImageP = Paths.get(newImageS);
                    
                    try {
                        System.out.println("파일 복사!!!");
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
