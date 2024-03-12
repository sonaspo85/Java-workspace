package main.java.zipController;

public class InOutPathClas {
    String in;
    String out;
    String xslt;
    String para;
    
    
    public InOutPathClas(String in, String out, String xslt, String para) {
        this.in = in;
        this.out = out;
        this.xslt = xslt;
        this.para = para;
    }
    
    public String getinFile() {
        return in;
    }
    
    public String getoutFile() {
        return out;
    }
    
    public String getxslFile() {
        return xslt;
    }
    
    public String getpara() {
        return para;
    }
    
}
