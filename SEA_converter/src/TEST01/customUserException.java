package TEST01;

public class customUserException extends Exception {
    // �Ϲ� ������
    public customUserException() {
        
    }
    
    public customUserException(String message) {
        super(message);  // ���� ���� Ŭ������ ȣ�� �Ͽ�, �Ű� ���� ����
                         // �̷��� ���޵� �Ű����� catch ��Ͽ��� ��� �Ѵ�.
    }
    
}
