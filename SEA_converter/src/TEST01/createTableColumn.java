package TEST01;

import java.io.File;

import javafx.beans.property.SimpleStringProperty;

public class createTableColumn {
    private SimpleStringProperty filename;
    private SimpleStringProperty size;
    private File abFile;
    
    public createTableColumn(String fileName, String size, File abFile) {
        this.filename = new SimpleStringProperty(fileName);
        this.size = new SimpleStringProperty(size);
        this.abFile = abFile;
    }
    
    public String getFilename() {
        return filename.get();
    }
    
    public void setFilename(String filename) {
        this.filename.set(filename);
    }
    
    public String getSize() {
        return size.get();
    }
    
    public void setSize(String size) {
        this.size.set(size);
    }
    
    public File getAbfile() {
        return abFile;
    }
}
