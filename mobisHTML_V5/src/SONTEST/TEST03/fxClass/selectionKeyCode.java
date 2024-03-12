package SONTEST.TEST03.fxClass;

import java.util.List;

import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.ComboBox;
import javafx.scene.control.ListView;
import javafx.scene.control.skin.ComboBoxListViewSkin;
import javafx.scene.input.KeyEvent;

public class selectionKeyCode implements EventHandler<KeyEvent> {
    public ComboBox combo;
    
    
    
    public selectionKeyCode(ComboBox combo) {
        this.combo = combo;
        
    }
    
    @Override
    public void handle(KeyEvent event) {
        String s = jumpTo(event.getText(), (String) combo.getValue(), combo.getItems());
        
        if (s != null) {
            combo.setValue(s);
        }
    }
    
    public String jumpTo(String keyPressed, String currentlySelected, List<String> items) {
        String key = keyPressed.toUpperCase();
        
        if (key.matches("^[A-Z]$")) {
            boolean letterFound = false;
            boolean foundCurrent = currentlySelected == null;

            for (int i=0; i< items.size(); i++) {
                if (items.get(i).toUpperCase().startsWith(key)) {
                    ComboBoxListViewSkin<?> skin = (ComboBoxListViewSkin<?>) combo.getSkin();
                    ListView<?> list = (ListView<?>) skin.getPopupContent();
                    list.scrollTo(i);
                    
                    letterFound = true;
                    if (foundCurrent) {
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
