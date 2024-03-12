package main.java.satisfy.fxml;


import java.net.URL;
import java.util.ResourceBundle;

import javafx.fxml.Initializable;
import javafx.stage.Stage;
import main.java.satisfy.Common.implementOBJ;


public class logoRC implements Initializable {
    implementOBJ obj = new implementOBJ();
    //------------------------------------------------
    
    private Stage primaryStage;
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        System.out.println("logoRC 시작");
    }
    
       
}
