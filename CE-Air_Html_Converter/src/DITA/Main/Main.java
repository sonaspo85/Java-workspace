package DITA.Main;

import DITA.ftp.ftpDownLoad;
import DITA.fxcontroller.RC;
//import atlantafx.base.theme.PrimerDark;
//import atlantafx.base.theme.PrimerLight;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;


public class Main extends Application {
    

    @Override
    public void start(Stage primaryStage) throws Exception {
        // 1. FXMLLoader 객체 생성
        FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("DITA/fxcontroller/root.fxml"));
        
//        URL url = new URL("G:/Test/root.fxml");
//        FXMLLoader loader = new FXMLLoader(url);

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
//      downResource();
        
//        Application.setUserAgentStylesheet(new PrimerDark().getUserAgentStylesheet());
        System.out.println("Main() 시작");
        launch(args);

    }
    
    
    public static void downResource() {
        System.out.println("downResource() 시작");
        
        try {
            String xsltPath = "/tcs/confidential/CE-HTML-Converter/resource/xsls";
            
            ftpDownLoad ftpD = new ftpDownLoad(xsltPath, "xslt");
            ftpD.runFTP();

        } catch (Exception e) {
            e.printStackTrace();
            
        }
        
        
        try {
            String resourcePath = "/tcs/confidential/CE-HTML-Converter/resource/excel-template";
            
            ftpDownLoad ftpD = new ftpDownLoad(resourcePath, "resource");
            ftpD.runFTP();

        } catch (Exception e) {
            e.printStackTrace();
            
        }
    }



}
