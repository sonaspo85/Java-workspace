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
		String key = keyPressed.toUpperCase();
		
		if(key.matches("^[A-Z]$")) {
			boolean letterFound = false;
			boolean foundCurrent = currentlySelected == null;

			for(int i=0; i<items.size(); i++) {
				if(items.get(i).toUpperCase().startsWith(key)) {
					letterFound = true;
					
					ComboBoxListViewSkin<?> skin = (ComboBoxListViewSkin<?>) combo.getSkin();
					ListView<?> list = (ListView<?>) skin.getPopupContent();
                    list.scrollTo(i);

                    if (foundCurrent) {
                    	// 현재 선택한 목록을 반환
                        return items.get(i);
                    }
                     
                    foundCurrent = items.get(i).equals(currentlySelected);
                    
				}
				
			}
			
			if (letterFound) {
                return jumpTo(keyPressed, null, items);
            }

		}
		
		return null;
	}
	
	
}
