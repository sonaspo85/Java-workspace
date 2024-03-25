package SONTEST.TEST03.fileControl;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import SONTEST.TEST03.subWorkClass.commonObj;

public class createIdmlFile {
    // 구현 객체 생성
    commonObj coj = new commonObj();
    
    public void createIdmlFile(File absolutePath) throws Exception {
        String extention = coj.getExt(absolutePath);
        String fileName = absolutePath.getName();
        String zipFileName = coj.exePath + "\\resource\\temp\\idmlZip\\" + fileName.replace(extention, ".zip");
        
        Path from = absolutePath.toPath();
        Path to = Paths.get(zipFileName);
        
        Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
    }
}
