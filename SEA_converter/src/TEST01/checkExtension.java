package TEST01;

import java.util.Optional;

public class checkExtension {
    String fileName;
    
    
    public boolean bool(String fileName) {
//      System.out.println("fileName: " + fileName);
      // String Ÿ���� ��ü�� Optional Ŭ������ �̿��Ͽ� ���� 
      Optional<String> optional = Optional.ofNullable(fileName);
      
      // htmȮ���ڸ� �����ϰ� �ִ�  Optional ��ü�� ���͸�
      Optional<String> optFilter = optional.filter(a -> a.contains(".htm") || a.contains(".mcbook"));
      
      if(optFilter.isPresent()) {
          String extenstion = optFilter.map(a -> a.substring(fileName.lastIndexOf(".") + 1)).get();
          
          // Ȯ���� ���� - ��Ʈ���� map() �߰� ó�� �޼ҵ带 �̿��Ͽ�, �����̸��� Ȯ���ڷ�  ���� 
          if(extenstion.equals("htm") || extenstion.equals("html") || extenstion.equals("mcbook")) {
              return true;
          } else {            
              return false;
          }
      }
      
      return false;
    }
}
