package main.fxControll;

import java.io.File;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ResourceBundle;

import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Point2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.stage.FileChooser;
import javafx.stage.FileChooser.ExtensionFilter;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import main.oneClickAssist.runMain.excelTxml;
import main.oneClickAssist.runMain.executeOrder;

public class RC implements Initializable {
    @FXML
    private Button qrcode;
    @FXML
    private Button close;

    // 컨트롤러에서 다이얼로그 얻기
    private Stage primaryStage;

    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }

    String selectedFile = "";
    String srcPath = "";

//    FileChooser fc = new FileChooser();

    public static File jarPath = new File("").getAbsoluteFile();

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        qrcode.setOnAction(e -> excelTxml());
        close.setOnAction(e -> Platform.exit());

    }
    

    public void excelTxml() {
        FileChooser fc = new FileChooser();
        // 파일 확장명으로 필터링 정보 추가
        fc.getExtensionFilters().addAll(new ExtensionFilter("Excel", "*.xlsx"));

        // 다이얼로그 띄우기
        File selectF = fc.showOpenDialog(primaryStage);

        selectedFile = selectF.getPath();
        srcPath = selectF.getParent();
        excelTxml et = new excelTxml(selectedFile);
        
        Path tarDir = null;
        try {
            tarDir = et.runexcel();

            // xslt 실행하여 tags.xml 추출 하기
            xsltExecute(tarDir);
            
            // 종료 팝업
            finishedPop();
//            selectedFile = "";
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    

/*
    public boolean delteFolder(String qqq) {
        System.out.println("delteFolder 시작");
//        DirectoryStream<Path> ds = Files.newDirectoryStream(toPath);
        File file0 = new File(qqq);
        File[] contents = file0.listFiles();
        System.out.println("contents 개수: " + contents.length);
        for(File file : contents) {
            if(file.isDirectory()){
                System.out.println("yyy: " + file);
                Path path = Paths.get(file.getAbsolutePath());
                delteFolder(file.toString());

            } else {
                System.out.println(file + " :file 삭제");
                file.delete();
            }
        }
        return file0.delete();
        
    }*/

    public void xsltExecute(Path tarDir) {
        executeOrder eo = new executeOrder(tarDir, jarPath, srcPath);
        eo.setList();

    }

    

    public void finishedPop() {
        System.out.println("finishedPop 시작");
        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);

        dg.setTitle("작업이 완료 되었습니다.");

        try {
            // FXMLLoader.load() 메소드로 popup.fxml 파일 로드
            Parent parent = FXMLLoader.load(getClass().getResource("/main/fxml/finishPopup.fxml"));
            
            // Button 컨트롤이 ok인 컨트롤을 찾기 - lookup()
            Button bt = (Button) parent.lookup("#ok");
            bt.setOnAction(e -> dg.close());
            
            // Scene 객체 생성
            Scene scenePop = new Scene(parent);

            // 다이얼로그에 Scene 올리기
            dg.setScene(scenePop);
            dg.setResizable(false);
            dg.show();

            Point2D point = parent.localToScene(100.0, 100.0);
            dg.setX(primaryStage.getX() + point.getX());
            dg.setY(primaryStage.getY() + point.getY());

        } catch (Exception e1) {

        }
    }

}
