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
    
    // 소스 파일이 위치하고 있는 경로에 새로운 idmlZip 폴더 생성
    public void deleteAndCreateFolder() {        
        // 파일을 복사시킬 하위 디렉토리 생성
        File createSubDir = new File(exePath + "\\resource\\temp\\idmlZip");
        System.out.println("createSubDir: " + createSubDir);
        if(createSubDir.exists()) {
            deleteFilesRecursively(createSubDir);            
        }
        createSubDir.mkdirs();
    }
    
    // 만약, idmlZip 디렉토리가 존재 한다면 미리 삭제
    private boolean deleteFilesRecursively(File rootFile) {
        // 디렉토리내 모든 폴더 및 파일 추출
        File[] allFiles = rootFile.listFiles();
        
        for(File file : allFiles) {
            if (file.isDirectory()) {
                // 디렉토리 일 경우, 재귀적으로 해당 메소드를 다시 호출하여, allFiles 변수 생성
                deleteFilesRecursively(file);
            } else {
                // 파일일 경우 바로 삭제
                file.delete();
            }
        }
        
//        System.out.println("Remove files: " + rootFile.getPath());
        return rootFile.delete();
    }

}
