package SONTEST.TEST03.fxClass;

import java.io.File;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import SONTEST.TEST03.subWorkClass.commonObj;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

public class menuTableRowCreate {
    List<File> selectedFiles;
    public ObservableList<tableFiles> fileList = FXCollections.observableArrayList();
    
    // 구현 객체 생성
    public commonObj coj;
    
    public menuTableRowCreate(List<File> fileList) {
        this.selectedFiles = fileList;
    }
    
    
    public void runMenuTableRowCreate() {
        if(selectedFiles != null) {
            for(int i=0; i< selectedFiles.size(); i++) {
                File file = selectedFiles.get(i);
                // 구현 객체
                coj = new commonObj();
                
                // 파일 날짜
                String formatDate = createDate(file);
                
                // 파일 사이즈 
                String formatSize = createSize(file);
                
                tableFiles tf = new tableFiles(file.getName(), formatSize, formatDate, file.getAbsoluteFile());
                fileList.add(tf);
            }

        }
    }
    
    // 파일의 날짜 생성
    public String createDate(File file) {
        return coj.createDate(file);
    }
    
    // 파일 사이즈 생성
    public String createSize(File file) {
        return coj.createSize(file);
    }
    
    public ObservableList<tableFiles> getFileList() {
        return fileList;
    }    

}
