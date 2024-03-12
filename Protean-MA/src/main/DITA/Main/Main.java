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
		// TODO Auto-generated method stub
		// 1. FXMLLoader 객체 생성
        FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("main/DITA/fxcontroller/fxml/root.fxml"));
        
        // load() 인스턴스 메소드 호출하여, root.fxml 파일 로딩
        Parent root = loader.load();
        
        // 레이아웃을 장면(Scene) 으로 올림
        Scene scene = new Scene(root);

        // 컨트롤러로 primaryStage 전달하기
        RC con = loader.getController();
        
        // con 객체의 setPrimaryStage() 메소드를 호출하여, primaryStage 전달
        con.setPrimaryStage(primaryStage);
        
        // 윈도우에 장면추가
        primaryStage.setScene(scene);
        // 윈도우 종료 버튼 눌렀을 경우 프로그램을 종료 시키는 ActionEvent 처리 - setOnCloseRequest() 메소드 
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
