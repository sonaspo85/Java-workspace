package SONTEST.TEST03.subWorkClass;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;

import org.w3c.dom.Document;

public interface commonInterface {
    public abstract String createSize(File file);
    public abstract String createDate(File file);
    public abstract boolean getExtensionCheck(String str);
    public abstract String getExt(File str);
    public abstract void copyFolder(File QDirs, File Qto);
    public abstract void delteFolder(Path outFolder) throws Exception;
    public abstract Document createDomObj(Object obj) throws Exception;
}
