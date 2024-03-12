package copyFiles.Main;

import fxControl.RC;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class runMain extends Application {
	@Override
	public void start(Stage primaryStage) throws Exception {
		// FXML 로딩
		FXMLLoader loader = new FXMLLoader(runMain.class.getResource("/fxml/root.fxml"));

		// load() 인스턴스 메소드 호출
		Parent root = loader.load();
		
		// 컨트롤러로 primaryStage 넘기기
		RC con = loader.getController();
		con.setPrimaryStage(primaryStage);
		
		// Scene 객체 생성후, fxml을 올리기
		Scene scene = new Scene(root);
		
		primaryStage.setScene(scene);
		primaryStage.show();
		primaryStage.setResizable(false);
	}

	public static void main(String[] args) {
		launch(args);
		
	}

}
