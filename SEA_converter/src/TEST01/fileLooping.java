package TEST01;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.text.DecimalFormat;
import java.util.stream.Stream;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

public class fileLooping {
    ObservableList<createTableColumn> fileList = FXCollections.observableArrayList(); 
    
    public void runFLP(Stream<File> filterStream) {
        filterStream.forEach(f -> {
            File file = f;
            File abFile = f.getAbsoluteFile();
            String fileName = f.getName();
            String size = "";
            
            try {
                long byteSize = Files.size(f.toPath());
                size = fileSize(byteSize);
            } catch (IOException e) {
                String message = e.getMessage();
                System.out.println(message);
            }
            
            // createTableColumn ��ü ȣ���Ͽ� tableView�� �� Į���� ��� �����ϱ�
            createTableColumn ctc = new createTableColumn(fileName, size, abFile);
            fileList.add(ctc);
            
        });
    }
    
    private String fileSize(long fileSize) {
        DecimalFormat df = new DecimalFormat("0.00");
        
        float sizekb = 1024.0f;
        float sizeMb = sizekb * sizekb;
        float sizeGb = sizekb * sizeMb;
        float sizeTb = sizeMb * sizeGb;
        
        String size;
        if (fileSize < sizeMb) {
            size = df.format(fileSize / sizekb) + " Kb";
        } else if (fileSize < sizeGb) {
            size = df.format(fileSize / sizeMb) + " Mb";
        } else if (fileSize < sizeTb) {
            size = df.format(fileSize / sizeGb) + " Gb";
        } else {
            size = df.format(fileSize) + " Byte";
        }
        return size;
    }
    
    public ObservableList<createTableColumn> getFileList() {
        return fileList;
    } 
}
