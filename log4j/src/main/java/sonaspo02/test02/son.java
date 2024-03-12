package sonaspo02.test02;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class son extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception {
        // 1. FXMLLoader 객체 생성
        // getResource("/Main"): src 폴더를 기준으로 절대경로로 fxml 파일 검색
        FXMLLoader loader = new FXMLLoader(son.class.getResource("/sonaspo02/test02/fxml/root.fxml"));
//        FXMLLoader loader = new FXMLLoader(son.class.getResource("root.fxml"));
        
        // load() 인스턴스 메소드 호출
        Parent root = loader.load();
        
        //------------------------------
        // 정적 load() 메소드 호출 방법
        // fxml 파일이 클래스 파일과 동일한 경로에 있을 경우
//        FXMLLoader loader = new FXMLLoader.load(getClass().getResource("root.fxml"));
        
        Scene scene = new Scene(root);
        
        primaryStage.setScene(scene);
        primaryStage.show();
    }

    public static void main(String[] args) {
        // 메인 클래스의 메인 메소드에서 launch() 메소드를 호출함으로써, JavaFX어플리케이션을 실행할 수 있다.
        launch(args);
        
        

    }

}
