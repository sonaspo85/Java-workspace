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
//            result = new StringBuilder();
            
            // 데이터를 더이상 읽을수 없는 상태가 될때까지 반복
            while((readCount = in.read(buffer)) != -1) {
                String part = new String(buffer, 0, readCount);
                result += part;
            }   
           
        } catch(Exception e1) {
            System.out.println("url로 부터 데이터 읽기 실패!!");
//            e1.printStackTrace();
        }
        
//        System.out.println(result);
        return result;
    }

}
