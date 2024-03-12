package TEST01;

public class IOXclasses {
    String in;
    String out;
    String xslt;
    
    public IOXclasses(String in, String out, String xslt) {
        this.in = in;
        this.out = out;
        this.xslt = xslt;
    }
    
    public String getInFile() {
        return in;
    }
    
    public String getoutFile() {
        return out;
    }
    
    public String getxsltFile() {
        return xslt;
    }
}
