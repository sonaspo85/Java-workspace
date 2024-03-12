package aaa.bbb;

import java.util.List;

import aaa.bbb.model.Contact;
import aaa.bbb.util.ContactUtil;



public class Main {

    public static void main(String[] args) {
        /*//-----------------------------------------
        // 일반적으로 위 방식으로 정렬 기능을 코딩하여 작성할 필요는 없다.
        // 자바에 내장된 스트림의 sorted() 메소드를 호출하여, 쉽게 처리 할 수도 있다.
        ContactUtil contactUtil = new ContactUtil();
        List<Contact> contacts = contactUtil.getContacts();
        contacts.stream().sorted((a,b) -> {
            return a.getLastName().compareTo(b.getLastName());
        }).forEach(a -> System.out.println(a.toString()));*/
        
        
        // Contact 객체의 요소를 두번째 매개값인 lastName 으로 정렬 하여 출력 하기
       /* ContactUtil contactUtil = new ContactUtil();
        SortUtil sortUtil = new SortUtil();
        List<Contact> contacts = contactUtil.getContacts();
        sortUtil.sortList(contacts);
        System.out.println(contacts);*/
        
        System.out.println("aaaaaaaa");
        
                
        
    }

}
