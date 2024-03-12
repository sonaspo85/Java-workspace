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

        // 컨트롤러에서 다이얼로그를 얻기 위해서는 메인 클래스에서 primaryStage를 전달해야 한다.
        // Scene 객체로 올라갈 레이아웃 생성
        // 1. FXMLLoader 객체 생성 - 객체로 생성하는 이유는 getController() 메소드가 인스턴스 메소드이기 때문에,
        URL ur = Main.class.getClassLoader().getResource("TEST01/fxml/root.fxml");
        FXMLLoader loader = new FXMLLoader(ur);
        
        // 2. load() 인스턴스 메소드로 root.fxml 파일 로딩
        Parent root = loader.load();
        
        // FXMLLoader 객체의 getController() 메소드를 호출하여 RC 객체 호출  
        RC rc = loader.getController();
        
        // rc 객체의 임의 생성한 setPrimaryStage(); 메소드를 호출하여 primaryStage 전달 
        rc.setPrimaryStage(primaryStage);

        // Scene 객체로 레이아웃 올림
        Scene scene = new Scene(root);        
        
        // 윈도우로 Scene 객체 올림
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
