package main.java.satisfy.Main;


import java.io.File;
import java.io.InputStream;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.fxml.FXMLLoader;
import javafx.geometry.Point2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.stage.Stage;
import main.java.satisfy.fxml.RC;

public class Main extends Application {
    
    public void start(Stage primaryStage) throws Exception {
        getlogoUI(primaryStage);
        
    }
    
    public static void main(String[] args) throws Exception {
        launch(args);
       
    }
    
    public void getlogoUI(Stage primaryStage) {
        System.out.println("getImgUI() 시작");
        
        try {
            Image image = new Image(Main.class.getResourceAsStream("/main/java/satisfy/fxml/logo.jpg"));
            
            // 1. FXMLLoader 객체 생성
            FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("main/java/satisfy/fxml/logoUI.fxml"));
            
            Parent root = loader.load();
            
            Scene scene = new Scene(root);

            ImageView imageView = (ImageView) root.lookup("#imageview");
            
            imageView.setImage(image);
            
            // Scene을 윈도우로 올리기
            primaryStage.setScene(scene);
            primaryStage.setTitle("Vendor Evaluation Tool");
            primaryStage.setResizable(false);
            primaryStage.show();
            
            
            Thread.sleep(50);
            
            Platform.runLater(()-> {
                try {
                    Thread.sleep(500);
                    
                    getMainUI(primaryStage);
                    
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                
            });
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
    }
    
    
    public void getMainUI(Stage primaryStage) {
        System.out.println("getMainUI() 시작");
        
        try {
            // 1. FXMLLoader 객체 생성
            FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("main/java/satisfy/fxml/root.fxml"));
            
            // load() 인스턴스 메소드 호출하여, root.fxml 파일 로딩
            Parent root = loader.load();
            
            RC con = loader.getController();
            con.setPrimaryStage(primaryStage);
            
            // 레이아웃을 장면(Scene) 으로 올림
            Scene scene = new Scene(root);

            // 외부 css 파일을 Scene에 적용
//            scene.getStylesheets().add(Main.class.getClassLoader().getResource("main/java/satisfy/fxml/app.css").toString());
            
            
            
            // Scene을 윈도우로 올리기
            primaryStage.setScene(scene);
            primaryStage.setTitle("Vendor Evaluation Tool");
            primaryStage.setResizable(false);
            primaryStage.setOnCloseRequest(event -> System.out.println("종료"));
            primaryStage.show();
            

            Point2D point = root.localToScene(-300.0, -200.0);
            primaryStage.setX(primaryStage.getX() + point.getX());
            primaryStage.setY(primaryStage.getY() + point.getY());
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        
    }

}
