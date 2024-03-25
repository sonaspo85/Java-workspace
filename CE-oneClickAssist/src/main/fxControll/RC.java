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
    private Stage primaryStage;

    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }

    String selectedFile = "";
    String srcPath = "";

    public static File jarPath = new File("").getAbsoluteFile();

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        qrcode.setOnAction(e -> excelTxml());
        close.setOnAction(e -> Platform.exit());

    }
    

    public void excelTxml() {
        FileChooser fc = new FileChooser();
        fc.getExtensionFilters().addAll(new ExtensionFilter("Excel", "*.xlsx"));
        File selectF = fc.showOpenDialog(primaryStage);
        selectedFile = selectF.getPath();
        srcPath = selectF.getParent();
        excelTxml et = new excelTxml(selectedFile);
        
        Path tarDir = null;
        try {
            tarDir = et.runexcel();
            xsltExecute(tarDir);
            finishedPop();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

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
            Parent parent = FXMLLoader.load(getClass().getResource("/main/fxml/finishPopup.fxml"));
            
            Button bt = (Button) parent.lookup("#ok");
            bt.setOnAction(e -> dg.close());
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
