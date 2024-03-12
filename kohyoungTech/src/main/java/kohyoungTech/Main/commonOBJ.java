package main.java.kohyoungTech.Main;

import java.io.File;
import java.nio.file.Path;

import org.w3c.dom.Document;

public interface commonOBJ {
    public abstract void recursDel(Path path);
    public abstract void createNewDir(Path path) throws Exception;
    public abstract Document createDOM() throws Exception;
    public abstract void xmlTransform(String mergedDir, Document doc);
    public abstract void copyFolder(File QDirs, File Qto);
    
    
}
