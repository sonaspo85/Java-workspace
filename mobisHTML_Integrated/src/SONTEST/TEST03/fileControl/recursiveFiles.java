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
        // 파일을 복사시킬 하위 디렉토리 생성
        File createSubDir = new File(exePath + "\\resource\\temp\\idmlZip");
        
        if(createSubDir.exists()) {
            deleteFilesRecursively(createSubDir);            
        }
        createSubDir.mkdirs();
    }
    
    private boolean deleteFilesRecursively(File rootFile) {
        File[] allFiles = rootFile.listFiles();
        
        for(File file : allFiles) {
            if (file.isDirectory()) {
                deleteFilesRecursively(file);
            } else {
                file.delete();
            }
        }
        
        return rootFile.delete();
    }

}
