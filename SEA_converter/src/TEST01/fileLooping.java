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
            // 파일의 절대 경로 추출
            File abFile = f.getAbsoluteFile();
            
            // 파일 이름 추출
            String fileName = f.getName();
//            System.out.println("파일 이름: " + fileName);
            
            String size = "";
            try {
                // 파일 사이즈 추출 - size() 메소드의 반환 타입은 kb 타입의 사이즈로 반환
                long byteSize = Files.size(f.toPath());
                size = fileSize(byteSize);
//                System.out.println("사이즈: " + size);
            } catch (IOException e) {
                String message = e.getMessage();
                System.out.println(message);
            }
            
            // createTableColumn 객체 호출하여 tableView의 각 칼럼의 목록 생성하기
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
