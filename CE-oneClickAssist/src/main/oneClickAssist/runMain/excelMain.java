package main.oneClickAssist.runMain;

import java.io.File;
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
    		FXMLLoader loader = new FXMLLoader(excelMain.class.getClassLoader().getResource("main/fxml/root.fxml"));
	    	Parent root = loader.load();
	    	RC controller = loader.getController();
	    	controller.setPrimaryStage(primaryStage);
	        Scene scene = new Scene(root);
	    	primaryStage.setTitle("원클릭 보조 도구");
	    	primaryStage.setScene(scene);
	        primaryStage.show();
	    	
    	} catch(Exception e1) {
    		e1.printStackTrace();
    	}
    	
    	
    }
    
    
    public static void main(String[] args) {
    	launch(args);
    }

}

