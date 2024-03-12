package main.DITA.fxcontroller.fxml;

import java.util.List;

import javafx.event.EventHandler;
import javafx.scene.control.ComboBox;
import javafx.scene.control.ListView;
import javafx.scene.control.skin.ComboBoxListViewSkin;
import javafx.scene.input.KeyEvent;

public class selectionKeyCode implements EventHandler<KeyEvent> {
	public ComboBox combo;
	String firstChar = "";
	
	public selectionKeyCode(ComboBox combo) {
		this.combo = combo;
//		this.firstChar = firstChar;
//		System.out.println("firstChar222: "  + firstChar);
		
	}
	
	@Override
	public void handle(KeyEvent event) {
		String eventTxt = event.getText();
		String comboTxt = combo.getValue().toString();
		List<String> items = combo.getItems();
		
		String s = jumpTo(eventTxt, comboTxt, items);
		
		if (s != null) {
            combo.setValue(s);
        }
	}
	
	
	public String jumpTo(String keyPressed, String currentlySelected, List<String> items) {
		System.out.println("jumpTo() 시작");
		
		// 키보드로 누른 키 대문자로 변경
		String key = keyPressed.toUpperCase();
//		String key = firstChar.toUpperCase();
		
		// 키보드론 누른 문자가 A-Z 사이인 경우
		if(key.matches("^[A-Z]$")) {
			boolean letterFound = false;
			
			// 75번 jumpTo() 메소드를 재구 호출할때 currentlySelected 는 null로 반환 되므로,
			// foundCurrent 는 true로 할당 된다.
			boolean foundCurrent = currentlySelected == null;
			
			
			// combo 박스에 개수 만큼 반복
			for(int i=0; i<items.size(); i++) {
				// 선택된 목록을 대문자로 변경 후, 시작문자가 키보드로 누른 문자와 일치 하는 경우
				if(items.get(i).toUpperCase().startsWith(key)) {
					// 키보드로 누른 문자를 combo 에서 찾을 수 있는 경우 letterFound 를 true 로 할당
					letterFound = true;
					
					ComboBoxListViewSkin<?> skin = (ComboBoxListViewSkin<?>) combo.getSkin();
					ListView<?> list = (ListView<?>) skin.getPopupContent();
					
					// 키보드로 누른 목록으로 점프 하기
                    list.scrollTo(i);

					
                    // for문 한번돌고나서 jumpTo() 메소드가 재귀 호출될시에 foundCurrent 가 true가 되어
                    // 해당 조건문에 접근 가능함
                    if (foundCurrent) {
                    	// 현재 선택한 목록을 반환
                        return items.get(i);
                    }
                    
                    // 키보드로 입려한 문자가 더있는 경우 combo 목록의 현재 선택한 요소 이후의 요소를 선택 함 
                    foundCurrent = items.get(i).equals(currentlySelected);
                    
				}
				
			}
			
			// letterFound 는 처음에는 false 이라서, 처음 for문 동작시에는 목록이 선택되지 않지만,  
			// for문 한번돌고난 이후에는 52번라인에서 true로 되므로 해당 목록으로 접근 가능함
			if (letterFound) {
				// jumpTo() 메소드 재귀 호출
				// 두번째 매개변수 currentlySelected 를 null로 할당하면 44번 라인이 true로 재할당 됨
                return jumpTo(keyPressed, null, items);
            }

		}
		
		return null;
	}
	
	
}
