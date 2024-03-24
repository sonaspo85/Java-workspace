package SONTEST.TEST03.subWorkClass;

public class customUserException extends Exception {
    // 일반 생성자
    public customUserException() {
        
    }
    
    public customUserException(String message) {
        super(message);
    }
    
}
