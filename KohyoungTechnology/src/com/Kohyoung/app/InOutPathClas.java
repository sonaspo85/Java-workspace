package com.Kohyoung.app;

public class InOutPathClas {
    String in;
    String out;
    String xslt;
    String var0;
    
    
    public InOutPathClas(String in, String out, String xslt) {
        this.in = in;
        this.out = out;
        this.xslt = xslt;

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
    
    public String getvar0() {
        return var0;
    }
    
}

