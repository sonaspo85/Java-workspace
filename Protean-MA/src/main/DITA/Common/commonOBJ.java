package main.DITA.Common;

import java.nio.file.Path;

import org.w3c.dom.Document;

public interface commonOBJ {
    public abstract void recursDel(Path path) throws Exception;
    public abstract void createNewDir(Path path) throws Exception;
    public abstract Document createDOM() throws Exception;
    public abstract Document readFile(String file) throws Exception;
    public abstract void dirCopy(Path newPath, Path oldPath) throws Exception;
    public abstract String getDateTime(); 
    public abstract void moveFiles(Path form, Path to);
    
}
