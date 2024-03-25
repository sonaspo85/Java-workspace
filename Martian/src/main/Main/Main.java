package main.Main;



import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import main.ftpcontroller.ftpDownLoad;
import main.fxcontroller.RC;


public class Main extends Application {
    @Override
    public void start(Stage primaryStage) throws Exception {
        FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("main/fxcontroller/root2.fxml"));
        Parent root = loader.load();
        Scene scene = new Scene(root);
        RC con = loader.getController();
        con.setPrimaryStage(primaryStage);
        primaryStage.setScene(scene);
        primaryStage.setOnCloseRequest(event -> System.out.println("종료"));
        primaryStage.show();
        
        primaryStage.setResizable(false);
    }

    public static void main(String[] args) {
        downResource();
        
        System.out.println("Main() 시작");
        launch(args);

    }
    
    
    public static void downResource() {
        System.out.println("downResource() 시작");
        String userName = System.getProperty("user.name");  // SMC
        
        if(!userName.matches("SMC")) {
            try {
                String xsltPath = "/tcs/confidential/Martian/resource/xsls";
                
                ftpDownLoad ftpD = new ftpDownLoad(xsltPath, "xslt");
                ftpD.runFTP();

            } catch (Exception e) {
                String msg = "ftp 서버 접속 실패!";
                throw new RuntimeException(msg);
                
            }
            
            
            try {
                String resourcePath = "/tcs/confidential/Martian/resource/excel-template";
                
                ftpDownLoad ftpD = new ftpDownLoad(resourcePath, "resource");
                ftpD.runFTP();

            } catch (Exception e) {
                String msg = "ftp 서버 접속 실패!";
                throw new RuntimeException(msg);
                
            }
        }
        
    }



}
