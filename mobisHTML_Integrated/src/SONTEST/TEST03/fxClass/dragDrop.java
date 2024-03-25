package SONTEST.TEST03.fxClass;

import java.io.File;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;
import java.util.stream.Stream;

import SONTEST.TEST03.subWorkClass.commonObj;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

public class dragDrop {
    private List<File> list;
    public ObservableList<tableFiles> fileList = FXCollections.observableArrayList();
    commonObj coj = new commonObj();
    
    
    public dragDrop(List<File> list) {
        this.list = list;
    }
    
    
    public void runDragDrop() {
        Stream<File> stream = list.stream();
        Stream<File> filterStream = stream.filter(a -> getExtensionCheck(a.getName()) == true);
        filterStream.forEach(a -> createRow(a.getAbsoluteFile()));

    }
    
    // 파일의 확장자를 체크
    public boolean getExtensionCheck(String str) {
        return coj.getExtensionCheck(str);
    }
    
    public void createRow(File file) {
        String formatDate = createDate(file);
        String formatSize = createSize(file);
        
        tableFiles tf = new tableFiles(file.getName(), formatSize, formatDate, file.getAbsoluteFile());
        fileList.add(tf);
    }
    
    // 파일 사이즈 생성
    public String createSize(File file) {
        coj = new commonObj();
        return coj.createSize(file);
    }
    
    
    // 파일의 날짜 생성
    public String createDate(File file) {
        coj = new commonObj();
        return coj.createDate(file);
    }
    
    public ObservableList<tableFiles> getFileList() {
        return fileList;
    }
    
}
