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
    
    // 구현 객체 생성
    commonObj coj = new commonObj();
    
    // s
    public dragDrop(List<File> list) {
        this.list = list;
    }
    
    
    public void runDragDrop() {
        Stream<File> stream = list.stream();
        
        // 확장자가 xml, idml 인 파일만 필터링
        Stream<File> filterStream = stream.filter(a -> getExtensionCheck(a.getName()) == true);
        
        // 파일의 절대 경로 추출하여, tableView의 각 행에 들어갈 목록을 만듦
        filterStream.forEach(a -> createRow(a.getAbsoluteFile()));

    }
    
    // 파일의 확장자를 정규식으로 체크하여, 해당하는 확장파 파일일 경우 true 반환
    public boolean getExtensionCheck(String str) {
        // 구현 객체
        return coj.getExtensionCheck(str);
    }
    
    // tableView의 각 row에 들어갈 목록 생성
    public void createRow(File file) {
        // 파일 날짜
        String formatDate = createDate(file);
        
        // 파일 사이즈 
        String formatSize = createSize(file);
        
        tableFiles tf = new tableFiles(file.getName(), formatSize, formatDate, file.getAbsoluteFile());
        fileList.add(tf);
    }
    
    // 파일 사이즈 생성
    public String createSize(File file) {
        // 구현 객체
        coj = new commonObj();
        return coj.createSize(file);
    }
    
    
    // 파일의 날짜 생성
    public String createDate(File file) {
        // 구현 객체
        coj = new commonObj();
        return coj.createDate(file);
    }
    
    public ObservableList<tableFiles> getFileList() {
        return fileList;
    }
    
}
