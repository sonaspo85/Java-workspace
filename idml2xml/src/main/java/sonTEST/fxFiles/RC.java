package main.java.sonTEST.fxFiles;

import java.io.File;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.input.DragEvent;
import javafx.scene.input.TransferMode;
import javafx.scene.web.WebEngine;
import javafx.scene.web.WebView;
import javafx.stage.Stage;

public class RC implements Initializable  {
//    @FXML private TableView<tableFiles> tableView;
    @FXML private WebView webView; 
    
    // 컨트롤러에서 다이얼로그 얻기
    private Stage primaryStage;
    
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        webView.setOnDragOver(event -> dragOver(event));
        webView.setOnDragDropped(event -> dragDrop(event));
//        tableView.setOnDragExited(event -> dragExit(event));
    }
    
    
 // 드래그 중인 경우
    public void dragOver(DragEvent e) {
        System.out.println("dragOver 시작 ");
        
        if(e.getGestureSource() != webView && e.getDragboard().hasFiles()) {
            System.out.println("aaa");
            webView.setStyle(
                "-fx-border-color:red;" + 
                "-fx-background-color: ANTIQUEWHITE;"
            );
            e.acceptTransferModes(TransferMode.COPY_OR_MOVE);
        }
        e.consume();
    } 
    
    // 드래그 드랍한 경우
    public void dragDrop(DragEvent e) {
        System.out.println("dragDrop 시작");
        boolean success = false;
        
        // 드래그앤 드롭 작업을 시작한 원본 객체가 TableView가 아니고,
        // tableview로 드래그 드롭한 객체가 파일이 존재 하는 경우 
        if(e.getGestureSource() != webView && e.getDragboard().hasFiles()) {
            System.out.println("bbb");
            List<File> list = e.getDragboard().getFiles();
            
            WebEngine webEngine = webView.getEngine();
            URL url;
            try {
                File f = new File(list.get(0).toString());
                System.out.println("ff: " + f);
                webEngine.load(f.toURI().toString());
                
                
                
                
            } catch (Exception e1) {
                System.out.println("URL 에러");
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }
            
            
        }
    
    } 
    
}
