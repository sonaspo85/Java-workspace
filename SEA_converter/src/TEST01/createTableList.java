package TEST01;

import java.io.File;
import java.util.List;
import java.util.stream.Stream;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

public class createTableList {
    private List<File> list;
    checkExtension ce = new checkExtension();
    fileLooping flp = new fileLooping();
    ObservableList<createTableColumn> fileList = FXCollections.observableArrayList();
    
    public createTableList(List<File> list) {
        this.list = list;
    }
    
    public ObservableList<createTableColumn> runCTL() {
        // list 컬렉션을 Stream 으로 얻음
        Stream<File> stream = list.stream();
        // html 파일만 추려 내기
        
        // Stream<File> filterStream = stream.filter(e -> checkExtension(e.getName()) == true);
        Stream<File> filterStream = stream.filter(e -> ce.bool(e.getName()) == true);
        
        // filterStream 으로 추려진 파일을 이용하여, TableView 목록 생성 하기
        flp.runFLP(filterStream);
        fileList = flp.getFileList();
        return fileList;
    }
}
