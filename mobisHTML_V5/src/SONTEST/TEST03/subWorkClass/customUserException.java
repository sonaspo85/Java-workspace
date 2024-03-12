package SONTEST.TEST03.subWorkClass;

public class customUserException extends Exception {
    // 일반 생성자
    public customUserException() {
        
    }
    
    public customUserException(String message) {
        super(message);  // 상위 예외 클래스를 호출 하여, 매개 변수 전달
                         // 이렇게 전달된 매개값은 catch 블록에서 출력 한다.
    }
    
}
