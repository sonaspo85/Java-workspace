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
        // list �÷����� Stream ���� ����
        Stream<File> stream = list.stream();
        // html ���ϸ� �߷� ����
        
        // Stream<File> filterStream = stream.filter(e -> checkExtension(e.getName()) == true);
        Stream<File> filterStream = stream.filter(e -> ce.bool(e.getName()) == true);
        
        // filterStream ���� �߷��� ������ �̿��Ͽ�, TableView ��� ���� �ϱ�
        flp.runFLP(filterStream);
        fileList = flp.getFileList();
        return fileList;
    }
}
