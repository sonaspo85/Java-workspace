package main.java.Main;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import main.java.javafx.RC;


public class Main extends Application {    
    @Override
    public void start(Stage primaryStage) throws Exception {
        // FXMLLoader 객체 생성
        FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("main/java/javafx/fxml/root.fxml")); 
        Parent root = loader.load();
        Scene scene = new Scene(root);
        RC con = loader.getController();
        con.setPrimaryStage(primaryStage);
        
        // 윈도우에 장면 추가
        primaryStage.setScene(scene);
        primaryStage.setOnCloseRequest(e -> System.out.println("종료"));
        primaryStage.show();
        primaryStage.setResizable(false);

    }
    
    public static void main(String[] args) throws Exception {
        launch(args);

    }

    
 
}
