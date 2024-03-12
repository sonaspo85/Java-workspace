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
    // AST - 5.3.1, 타사 - 5.3.2, 신규 - 5.4
    static String programVer = "5.4";
    implementOBJ obj = new implementOBJ();
    
    @Override
    public void start(Stage primaryStage) throws Exception {
        // 1. FXMLLoader 객체 생성
        FXMLLoader loader = new FXMLLoader(Main.class.getClassLoader().getResource("main/java/fxcontroller/fxml/root.fxml"));
        
        // load() 인스턴스 메소드 호출하여, root.fxml 파일 로딩
        Parent root = loader.load();
        
        // 레이아웃을 장면(Scene) 으로 올림
        Scene scene = new Scene(root);
        primaryStage.setTitle("Spec Checker for QSG ver " + programVer);
        
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
        
        // 버전 비교 후, 알림 창 출력
        readFromUrl ru = new readFromUrl();
        String serVerver = ru.readFromurl();
        
        System.out.println("serVerver: " + serVerver);
        obj.programVer = programVer;
        
        if(programVer.equals(serVerver)) {
            System.out.println("버전이 같습니다.");
            
        } else {
            System.out.println("버전이 다릅니다.");
                        
            callPopup(serVerver, primaryStage);

        }
        
    } 
    
    public static void callPopup(String serVerver, Stage primaryStage) throws Exception {
        Popup pop = new Popup();
        
        // FXMLLoader.load() 메소드로 pop.fxml 파일 로드
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
        
        // 마우스 포커스를 다른 윈도우로 이동시 자동으로 팝업창 닫기
        pop.setAutoHide(true);
        
        pop.show(primaryStage);
    }
    
    public static void main(String[] args) throws Exception {
        launch(args);
       
    }
    
}
