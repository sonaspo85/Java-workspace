package main.java.zipController.Common;

import java.nio.file.Path;

import org.w3c.dom.Document;

public interface commonOBJ {
    public abstract void recursDel(Path path);
    public abstract void createNewDir(Path path) throws Exception;
    public abstract Document createDOM() throws Exception;
    
}
