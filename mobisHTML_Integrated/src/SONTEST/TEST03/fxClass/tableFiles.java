package SONTEST.TEST03.fxClass;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.Optional;

import javafx.beans.property.SimpleLongProperty;
import javafx.beans.property.SimpleStringProperty;

public class tableFiles {
    private SimpleStringProperty files;
    private SimpleStringProperty filesize;
    private SimpleStringProperty filedate;
    private File abfile;
    
    
    
    // s
    public tableFiles(String files, String size, String date, File ab) {
        this.files = new SimpleStringProperty(files);
        this.filesize = new SimpleStringProperty(size);
        this.filedate = new SimpleStringProperty(date);
        this.abfile = ab;
    }
    
    public String getFiles() {
        return files.get();
    }
    
    public void setFiles(String files) {
        this.files.set(files);
    }
    
    public String getFilesize() {
        return filesize.get();
    }
    
    public void setFilesize(String filesize) {
        this.filesize.set(filesize);
    }
    
    public String getFiledate() {
        return filedate.get();
    }
    
    public void setFiledate(String filedate) { 
       this.filedate.set(filedate);
    }
    
    public String getAbfile() {
        return abfile.getAbsolutePath();
    }
    
    public String getExtension() {
        String fileName = files.getName();
        System.out.println("eee: " + fileName);

        // Optional 객체 생성 - ofNullable() 메소드 사용
        Optional<String> optional = Optional.ofNullable(fileName);
        
        // 확장자 추출
        String extension = optional.map(a -> a.substring(fileName.lastIndexOf(".") + 1)).get();
//        String extension = fileName;
        return extension;
    }
    
}