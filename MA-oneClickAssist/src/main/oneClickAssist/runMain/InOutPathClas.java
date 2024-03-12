package main.oneClickAssist.runMain;

import java.io.InputStream;

public class InOutPathClas {
    String in;
    String out;
    String xslt;
    InputStream is;
    
    
    public InOutPathClas(String in, String out, String xslt) {
        this.in = in;
        this.out = out;
        this.xslt = xslt;
    }
    
    public InOutPathClas(String in, String out, InputStream is) {
        this.in = in;
        this.out = out;
        this.is = is;
    }
    
    public String getinFile() {
        return in;
    }
    
    public String getoutFile() {
        return out;
    }
    
    public InputStream getisFile() {
        return is;
    }
    
    public String getxslFile() {
        return xslt;
    }
}
