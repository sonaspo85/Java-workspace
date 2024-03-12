package TEST01;

import java.util.Optional;

public class checkExtension {
    String fileName;
    
    
    public boolean bool(String fileName) {
//      System.out.println("fileName: " + fileName);
      // String 타입의 객체를 Optional 클래스를 이용하여 포장 
      Optional<String> optional = Optional.ofNullable(fileName);
      
      // htm확장자를 포함하고 있는  Optional 객체만 필터링
      Optional<String> optFilter = optional.filter(a -> a.contains(".htm") || a.contains(".mcbook"));
      
      if(optFilter.isPresent()) {
          String extenstion = optFilter.map(a -> a.substring(fileName.lastIndexOf(".") + 1)).get();
          
          // 확장자 추출 - 스트림의 map() 중간 처리 메소드를 이용하여, 파일이름을 확장자로  매핑 
          if(extenstion.equals("htm") || extenstion.equals("html") || extenstion.equals("mcbook")) {
              return true;
          } else {            
              return false;
          }
      }
      
      return false;
    }
}
