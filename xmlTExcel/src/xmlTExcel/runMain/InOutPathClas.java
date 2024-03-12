package xmlTExcel.runMain;

public class InOutPathClas {
    String in;
    String out;
    String xslt;

    
    
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
    

    
}
