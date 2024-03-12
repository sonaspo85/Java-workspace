package main.java.Main;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import main.java.javafx.RC;


public class Main extends Application {
//    static String msg = "";
//    public static implementOBJ obj = new implementOBJ();
//    static Map<String, String> map = new HashMap<>();
    
    @Override
    public void start(Stage primaryStage) throws Exception {
        // 1. FXMLLoader 객체 생성
        FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("main/java/javafx/fxml/root.fxml")); 
        
        // 2. load() 인스턴스 메소드를 호출하여, root.fxml 파일 로딩
        Parent root = loader.load();
        
        // 3. 레이아웃을 장면으로 올림
        Scene scene = new Scene(root);
        
        // 4. 컨트롤러로 primaryStage 전달 하기
        RC con = loader.getController();
        
        // 5. con 객체의 setPrimaryStage() 메소드를 호출하여 PrimaryStage 전달
        con.setPrimaryStage(primaryStage);
        
        // 6. 윈도우에 장면 추가
        primaryStage.setScene(scene);
        
        // 7. 윈도우 종료 버튼 눌렀을 경우, 프로그램 종료시키는 ActionEvent 처리 - setOnCloseRequest() 메소드
        primaryStage.setOnCloseRequest(e -> System.out.println("종료"));
        primaryStage.show();
        
        // 윈도우창 크기를 변경할 수 없도록 리사이즈 금지
        primaryStage.setResizable(false);

    }
    
    public static void main(String[] args) throws Exception {
        System.out.println("main() 시작");
        
        launch(args);

    }

    
 
}
