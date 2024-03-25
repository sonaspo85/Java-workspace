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
        Stream<File> stream = list.stream();
        Stream<File> filterStream = stream.filter(e -> ce.bool(e.getName()) == true);
        flp.runFLP(filterStream);
        fileList = flp.getFileList();
        return fileList;
    }
}
