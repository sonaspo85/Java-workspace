package main.java.sonTEST.fxFiles;

import javafx.beans.property.SimpleStringProperty;

public class tableFiles {
    private SimpleStringProperty id;
    private SimpleStringProperty src;
    private SimpleStringProperty tar;
    
    
    
    //s 
    public tableFiles(String id, String src, String tar) {
        this.id = new    SimpleStringProperty(id);
        this.src = new SimpleStringProperty(src);
        this.tar = new SimpleStringProperty(tar);
    }
    
    public String getFiles() {
        return id.get();
    }
    
    public String getSrc() {
        return src.get();
    }
    
    public String getTar() {
        return tar.get();
    }
    
    
}
