package TEST01;

import java.net.URL;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class Main extends Application {
    @Override
    public void start(Stage primaryStage) throws Exception {
        URL ur = Main.class.getClassLoader().getResource("TEST01/fxml/root.fxml");
        FXMLLoader loader = new FXMLLoader(ur);
        Parent root = loader.load();
        RC rc = loader.getController(); 
        rc.setPrimaryStage(primaryStage);
        Scene scene = new Scene(root);        
        primaryStage.setScene(scene);
        
        // 윈도우로 장면 올리기
        primaryStage.setOnCloseRequest(event -> System.out.println("종료"));
        primaryStage.setResizable(false);
        primaryStage.show();
        
        
    }
    
    
    public static void main(String[] args) {
        launch(args);
    }


}
