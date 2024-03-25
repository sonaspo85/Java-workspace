package main.DITA.Main;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import main.DITA.fxcontroller.fxml.RC;


public class Main extends Application  {
	@Override
	public void start(Stage primaryStage) throws Exception {
        FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("main/DITA/fxcontroller/fxml/root.fxml"));
        Parent root = loader.load();
        Scene scene = new Scene(root);
        RC con = loader.getController();
        con.setPrimaryStage(primaryStage);
        
        // 윈도우에 장면추가
        primaryStage.setScene(scene); 
        primaryStage.setOnCloseRequest(event -> System.out.println("종료"));
        primaryStage.setTitle("Protean-MA DITA 퍼블리싱");
        primaryStage.show();
        primaryStage.setResizable(false);
        
	}

	public static void main(String[] args) {
		System.out.println("Main() 시작");
		launch(args);
	}
	
	
}
