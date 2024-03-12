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
    
    // idml 파일을 새로운 디렉토리 idmlZip에 zip 확장자만 변경하여 복사 하기
    public void createIdmlFile(File absolutePath) throws Exception {
//        System.out.println("absolutePath: " + absolutePath);
        // 확장자 추출
        String extention = coj.getExt(absolutePath);
        String fileName = absolutePath.getName();
        
        // 확장자를 zip 으로 변경
        String zipFileName = coj.exePath + "\\resource\\temp\\idmlZip\\" + fileName.replace(extention, ".zip");
        
        Path from = absolutePath.toPath();
        Path to = Paths.get(zipFileName);
        
        Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
    }
}
