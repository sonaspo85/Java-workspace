package SONTEST.TEST03.Main;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Paths;


import SONTEST.TEST03.fxClass.RC;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;



public class Main extends Application { 
    
    @Override
    public void start(Stage primaryStage) {
        try {
            FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("SONTEST/TEST03/fxml/root.fxml"));
            
            Parent root = loader.load();
            RC con = loader.getController();
            con.setPrimaryStage(primaryStage);
            
            Scene scene = new Scene(root);
            
            primaryStage.setTitle("mobisHTML 변환기");
            primaryStage.setScene(scene);
            primaryStage.setResizable(false);
            primaryStage.setOnCloseRequest(event -> System.out.println("종료"));
            primaryStage.show();

        } catch (IOException e) {
            e.printStackTrace();
        }
        
    }
    
    public static void main(String[] args) {
        launch(args);
    }

}
