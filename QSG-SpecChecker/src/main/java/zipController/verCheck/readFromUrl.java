package main.java.zipController.verCheck;

import java.io.InputStream;
import java.net.URL;

public class readFromUrl {
    URL url = null;
    String result = "";
    
    public String readFromurl() {
        System.out.println("readFromurl() 시작");
        try {
            url = new URL("https://guest.astkorea.net/TCS/specChecker-ver-son.html");
            
            InputStream in = url.openStream();
            byte[] buffer = new byte[128];
            int readCount = 0;
            
            while((readCount = in.read(buffer)) != -1) {
                String part = new String(buffer, 0, readCount);
                result += part;
            }   
           
        } catch(Exception e1) {
        }
        
        return result;
    }

}
