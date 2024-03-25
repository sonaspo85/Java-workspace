package main.java.zipController.Main;

import main.java.fxcontroller.interf.RC;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.stage.Popup;
import javafx.stage.Stage;
import main.java.zipController.Common.implementOBJ;
import main.java.zipController.verCheck.readFromUrl;


public class Main extends Application {
    static String programVer = "5.4.1";
    implementOBJ obj = new implementOBJ();
    
    @Override
    public void start(Stage primaryStage) throws Exception {
        FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("main/java/fxcontroller/fxml/root.fxml"));
        Parent root = loader.load();
        Scene scene = new Scene(root);
        primaryStage.setTitle("Spec Checker for QSG ver " + programVer);
        RC con = loader.getController();
        con.setPrimaryStage(primaryStage);
        
        // 윈도우에 장면추가
        primaryStage.setScene(scene); 
        primaryStage.setOnCloseRequest(event -> System.out.println("종료"));
        primaryStage.show();
        primaryStage.setResizable(false);

        readFromUrl ru = new readFromUrl();
        String serVerver = ru.readFromurl();
        
        System.out.println("serVerver: " + serVerver);
        obj.programVer = programVer;
        
        if(programVer.equals(serVerver)) {

        } else {
            callPopup(serVerver, primaryStage);

        }
        
    } 
    
    public static void callPopup(String serVerver, Stage primaryStage) throws Exception {
        Popup pop = new Popup();
        Parent parent = FXMLLoader.load(Main.class.getClassLoader().getResource("main/java/fxcontroller/fxml/vercheckErr.fxml"));
        
        Button b1 = (Button) parent.lookup("#b1");
        b1.setOnMouseClicked(event -> pop.hide());
        
        Label t1 = (Label) parent.lookup("#l11");
        t1.setText("프로그램 버전: " + programVer);
        t1.setStyle("-fx-text-fill: blue;");
        
        Label t2 = (Label) parent.lookup("#l22");
        t2.setText("정식 버전: " + serVerver);
        t2.setStyle("-fx-text-fill: blue;");
        
        pop.getContent().add(parent);
        pop.setAutoHide(true);
        pop.show(primaryStage);
    }
    
    public static void main(String[] args) throws Exception {
        launch(args);
       
    }
    
}
