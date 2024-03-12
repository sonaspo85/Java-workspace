package sonaspo02.test02;

import java.net.URL;
import java.util.ResourceBundle;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.control.Slider;
import javafx.scene.text.Font;

public class RC implements Initializable {
    @FXML private Label label;
    @FXML private Slider slider;
    
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        // slider 컨트롤의 @value 속성을 감시
        // 만약, value 값이 변경되는 경우, Label 컨트롤의 폰트 크기 변경
        
        slider.valueProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
                Font font = new Font(newValue.doubleValue());
                label.setFont(font);
            }
            
        });
        
        
        
    }
    
}
