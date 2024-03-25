package TEST01;

import java.util.Optional;

public class checkExtension {
    String fileName;
    
    
    public boolean bool(String fileName) {
      Optional<String> optional = Optional.ofNullable(fileName);
      Optional<String> optFilter = optional.filter(a -> a.contains(".htm") || a.contains(".mcbook"));
      
      if(optFilter.isPresent()) {
          String extenstion = optFilter.map(a -> a.substring(fileName.lastIndexOf(".") + 1)).get();
          
          if(extenstion.equals("htm") || extenstion.equals("html") || extenstion.equals("mcbook")) {
              return true;
          } else {            
              return false;
          }
      }
      
      return false;
    }
}
