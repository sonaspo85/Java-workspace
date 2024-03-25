package main.oneClickAssist.runMain;

import java.io.InputStream;
import java.nio.file.Path;

public class InOutPathClas {
//    String in;
    String out;
    String xslt;
    InputStream is;
    Path in;
    
   
    
    public InOutPathClas(Path in, String out, InputStream xslt) {
        this.in = in;
        this.out = out;
        this.is = xslt;
    }
    
    public Path getinFile() {
        return in;
    }
    
    public String getoutFile() {
        return out;
    }
    
    public InputStream getxslFile() {
        return is;
    }
}
