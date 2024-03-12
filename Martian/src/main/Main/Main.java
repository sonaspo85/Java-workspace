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
        // 1. FXMLLoader 객체 생성
        FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("main/fxcontroller/root.fxml"));

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
//                e.printStackTrace();
                throw new RuntimeException(msg);
                
            }
            
            
            try {
                String resourcePath = "/tcs/confidential/Martian/resource/excel-template";
                
                ftpDownLoad ftpD = new ftpDownLoad(resourcePath, "resource");
                ftpD.runFTP();

            } catch (Exception e) {
                String msg = "ftp 서버 접속 실패!";
//                e.printStackTrace();
                throw new RuntimeException(msg);
                
            }
        }
        
    }



}
