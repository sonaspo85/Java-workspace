package main.newMain;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.DataFormatter;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import main.fxControll.RC;

public class excelMain extends Application {
    static DataFormatter dfm = new DataFormatter();
    static DecimalFormat df = new DecimalFormat("#");
    static List<String> firstCellList = new ArrayList<>();
    
    
    @Override
    public void start(Stage primaryStage) {
    	try {
	    	// FXMLLoader 객체 생성
//	    	FXMLLoader loader = new FXMLLoader(excelMain.class.getResource("/main/fxml/root.fxml"));
    		FXMLLoader loader = new FXMLLoader(excelMain.class.getClassLoader().getResource("main/fxml/root.fxml"));
	    	// 장면에 올라갈 레이아웃 객체 생성
	    	Parent root = loader.load();
	    	
	    	// Stage를 컨트롤러로 보내기
	    	RC controller = loader.getController();
	    	controller.setPrimaryStage(primaryStage);
	    	
	    	// 레이아웃을 Scene객체로 올림
	        Scene scene = new Scene(root);
	    	
	    	// 윈도우에 장면추가
	    	primaryStage.setTitle("원클릭 보조 도구");
	    	primaryStage.setScene(scene);
	    	primaryStage.setResizable(false);
	        primaryStage.show();
//	    	primaryStage.setOnCloseRequest(e -> System.out.println("종료"));
	    	    	
    	} catch(Exception e1) {
    		e1.printStackTrace();
    	}

    }
    
    
    public static void main(String[] args) {
    	launch(args);
    }

}

