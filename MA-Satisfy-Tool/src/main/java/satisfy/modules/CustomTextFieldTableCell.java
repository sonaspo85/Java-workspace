package main.java.satisfy.modules;

import javafx.scene.control.TableCell;
import javafx.scene.control.TableColumn;
import javafx.scene.control.cell.TextFieldTableCell;
import javafx.scene.text.Text;
import javafx.scene.text.TextAlignment;
import javafx.util.Callback;
import javafx.util.StringConverter;

public class CustomTextFieldTableCell extends TextFieldTableCell<Company, String> {
    TableColumn<Company, String> column = null;
    
    public CustomTextFieldTableCell(StringConverter<String> var0, TableColumn<Company, String> column) {
        super(var0);
        this.column = column;

    }
    
    {   
        setWrapText(true);
        setStyle("-fx-text-fill: green; -fx-border-color: red; -fx-border-width: 0.2; -fx-font-size: 10pt;");
        
    }

    @Override
    public void updateItem(String value, boolean empty){
        super.updateItem(value, empty);
        if (value == null || empty) {
            setText("");
            setStyle("");
            
        } else {
//            if (value % 2 == 0)
//                setBorder(new Border(new BorderStroke(Color.BLUE, BorderStrokeStyle.DASHED, new CornerRadii(4), new BorderWidths(1))));
//            setStyle("-fx-text-fill: blue; -fx-border-color: blue; -fx-border-width: 0.2; -fx-font-size: 10pt; -fx-alignment: CENTER_LEFT;");
//            setText(value.toString());
            
            // 텍스트 줄바꿈 하기
            Text text = new Text(value);
            
            
            // text를 감싸고 있는 TableColumn의 id 얻기
            String tcid = getTableColumn().getId();
            if(tcid.contains("cell1")) {
                text.setTextAlignment(TextAlignment.LEFT);
                
            } else if(tcid.contains("t3cell2")) {
                text.setTextAlignment(TextAlignment.LEFT);
                
            } else {
                text.setTextAlignment(TextAlignment.CENTER);
            }
            
            text.setStyle("-fx-text-fill: blue; -fx-border-color: blue; -fx-border-width: 0.2; -fx-font-size: 10pt;");                      
            text.wrappingWidthProperty().bind(getTableColumn().widthProperty());
            setGraphic(text);
            
        }
    }

    public static <Company, String> Callback<TableColumn<Company, String>, TableCell<Company, String>> forTableColumn(StringConverter<String> var0, TableColumn<Company, String> column) {
        return new Callback<TableColumn<Company, String>, TableCell<Company, String>>() {
            @Override
            public TableCell<Company, String> call(TableColumn<Company, String> var1) {
                return (TableCell<Company, String>) new CustomTextFieldTableCell((StringConverter<java.lang.String>) var0, (TableColumn<main.java.satisfy.modules.Company, java.lang.String>) column);
                
                
            }
        };
    }
    
    
}
