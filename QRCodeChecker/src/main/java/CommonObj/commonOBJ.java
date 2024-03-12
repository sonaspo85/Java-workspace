package main.java.CommonObj;

import java.nio.file.Path;

import org.w3c.dom.Document;

public interface commonOBJ {
    public abstract void recursDel(Path path);
    public abstract void createNewDir(Path path) throws Exception;
    public abstract Document createDOM() throws Exception;
    public abstract void xmlTransform(String mergedDir, Document doc);
    public abstract String compareModelName(String srcModelname, String srcQrUrl);
    
    
}
