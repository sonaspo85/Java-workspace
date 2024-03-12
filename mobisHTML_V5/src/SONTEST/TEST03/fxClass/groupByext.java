package SONTEST.TEST03.fxClass;

import java.io.File;

public class groupByext {    
    public enum Ext {
        xml,
        idml,
        xlsx,
        xls
    }

    public String fileName;
    private Ext ext;
    public File fullPath;
    
    public groupByext(String str, Ext ext, File fullPath) {
        this.fileName = str;
        this.ext = ext;
        this.fullPath = fullPath;
    }
    
    public String getName() {
        return fileName;
    }
    
    public File getFullPath() {
        return fullPath;
    }
    
    public Ext getExt() {
        return ext;
    }
    
}
