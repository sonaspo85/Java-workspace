package SONTEST.TEST03.fileControl;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import SONTEST.TEST03.subWorkClass.commonObj;

public class recursiveFiles {
    private String exePath;
    commonObj coj = new commonObj();
    
    public void setPath(String exePath) {
        this.exePath = exePath;
    }
    
    public void deleteAndCreateFolder() {        
        File createSubDir = new File(exePath + "\\resource\\temp\\idmlZip");
        
        if(createSubDir.exists()) {
            deleteFilesRecursively(createSubDir);            
        }
        createSubDir.mkdirs();
    }
    
    private boolean deleteFilesRecursively(File rootFile) {
        // 디렉토리내 모든 폴더 및 파일 추출
        File[] allFiles = rootFile.listFiles();
        
        for(File file : allFiles) {
            if (file.isDirectory()) {
                deleteFilesRecursively(file);
            } else {
                // 파일일 경우 바로 삭제
                file.delete();
            }
        }
        
        return rootFile.delete();
    }

}
