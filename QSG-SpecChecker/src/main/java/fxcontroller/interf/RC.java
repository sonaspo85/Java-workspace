package main.java.fxcontroller.interf;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.concurrent.Task;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Point2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.ProgressBar;
import javafx.scene.control.TextField;
import javafx.scene.input.DragEvent;
import javafx.scene.input.TransferMode;
import javafx.stage.FileChooser;
import javafx.stage.FileChooser.ExtensionFilter;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import main.java.zipController.Idml2xml;
import main.java.zipController.createConfigF;
import main.java.zipController.readValidF;
import main.java.zipController.transformXSLT;
import main.java.zipController.Common.implementOBJ;
import main.java.zipController.excel2xml.spec2xml;
import main.java.zipController.excel2xml.specsample;
import main.java.zipController.xml2excel.dbFiles2excel;


public class RC implements Initializable {
    @FXML private Button bt1;
    @FXML private Button bt2;
    @FXML private Button bt3;
    @FXML private Button bt4;
    @FXML private TextField tf1;
    @FXML private TextField tf2;
    @FXML private TextField tf3;
    @FXML private CheckBox ch1;
    String idmlZipPath = "";
    String specsamplePath = "";
    String spec2dataPath = "";
    implementOBJ obj = new implementOBJ();
    
    @FXML private ProgressBar pb;
    @FXML private Label lb2;
    

    private Stage primaryStage;
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }
    
    List<String> list = new ArrayList<String>();
    List<File> getFiles = new ArrayList<>();
    ArrayList<String> list1 = new ArrayList<>(); 
    createConfigF cf = new createConfigF();
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        File file = new File("");
        obj.packageDir = file.getAbsolutePath();
        recallPropertyInfo();
        ch1.setSelected(true);
        tf3.setDisable(true);
        checkboxLook();
        
         // 파일을 드래그 오버 방식
        batchWork(tf1);
        batchWork(tf2);
        batchWork(tf3);
        bt1.setOnAction(e -> openDialog(tf1));
        bt2.setOnAction(e -> openDialog(tf2));
        bt3.setOnAction(e -> openDialog(tf3));
     
        // 프로세스 실행
        bt4.setOnAction(e -> workStart(e));
    }
    
    public void recallPropertyInfo() {
        try {
            cf.runProps();
            
            if(obj.idmlzipP != null | obj.specSampleP != null | obj.spec2xmlP != null) {
                tf1.setText(obj.idmlzipP);
                tf2.setText(obj.specSampleP);
                String spec2F = obj.packageDir + File.separator + "resource/spec2xml-data.xlsm";
                tf3.setText(spec2F);
                
            }

        } catch (Exception e1) {
            e1.printStackTrace();
        }
    }
    
    public void workStart(ActionEvent e) {
        // 버튼 비활성화
        DisabledControl();
        
        idmlZipPath = tf1.getText();
        specsamplePath = tf2.getText();
        spec2dataPath = tf3.getText();
        
        Task<Void> task2 = new Task<Void>() {
            String msg = "";
            
            @Override
            protected Void call() {
                try {
                    cf.setkeyNvals(tf1.getText(), tf2.getText(), tf3.getText());
                } catch (Exception e1) {
                    String msg = "config.properties 파일로 path 전달 실패";
                    customException(msg);
                    e1.printStackTrace();
                }
                
                updateProgress(20, 100);
                updateMessage(String.valueOf(20));
                // idml to xml 로 변환
                try {
                    Idml2xml idmltxml = new Idml2xml(idmlZipPath);
                    idmltxml.runIdmltxml();
                    
                } catch(Exception e2) {
                    msg = e2.getMessage();
                    customException(msg);
                    e2.printStackTrace();
                }
                
                updateProgress(40, 100);
                updateMessage(String.valueOf(40));

                // spec2xml-data 을 xml로 변환 시작
                String spec2xmlDataPath = spec2dataPath;
                spec2xml spec2xml = new spec2xml(spec2xmlDataPath);
                
                try {
                    String spec2xmlDir = spec2xml.runexcel();
                    transformXSLT tf = new transformXSLT(spec2xmlDir);
                    tf.runSpec2xml();
                    
                } catch (Exception e3) {
                    msg = e3.getMessage();
                    customException(msg);
                    e3.printStackTrace();
                }

                updateProgress(60, 100);
                updateMessage(String.valueOf(60));

                String specSampleF = specsamplePath;
                specsample specsample = new specsample(specSampleF);
                
                try {
                    String specSampleDir = specsample.runexcel();
                    
                    transformXSLT tf = new transformXSLT(specSampleDir);
                    tf.runSpecsample();
                    
                } catch (Exception e4) {
                    String msg = e4.getMessage();
                    customException(msg);
                    e4.printStackTrace();
                }

                // temp 폴더
                String srcTempDir = obj.srcDir + File.separator +"temp";
                
                try {
                    transformXSLT tf = new transformXSLT(srcTempDir);
                    tf.runInsertDecimal();
                    
                } catch(Exception e4) {
                    String msg = e4.getMessage();
                    customException(msg);
                    e4.printStackTrace();
                }
                
                updateProgress(80, 100);
                updateMessage(String.valueOf(80));
                
                readValidF readV = new readValidF();
                
                try {
                    readV.runReadxml();
                    
                } catch(Exception e5) {
                    String msg = "Validation.xml 파일 읽기 오류";
                    customException(msg);
                    e5.printStackTrace();
                }
                
                try {
                    Thread.sleep(1000);
                } catch(Exception e) {
                    
                }
                
                updateProgress(90, 100);
                updateMessage(String.valueOf(90));
                
                // product 타입에 따라서 bat 파일 실행
                transformXSLT tf = new transformXSLT(obj.srcDir);

                try {
                    if(obj.productStr.equals("Mobile phone") | obj.productStr.equals("Tablet")) {
                        tf.runMobilebatch();
                        
                    } else {
                        tf.runAccbatch();            
                    }
                    
                } catch(Exception e) {
                    System.out.println(e.getMessage());
                    msg = e.getMessage();
                    customException(msg);
                }
                
                // resultDoc을 excel 로 변환
                dbFiles2excel db2excel = new dbFiles2excel(); 
                try {
                    db2excel.runDbFiles();
                    
                } catch (Exception e6) {
                    String msg = "resultDoc 파일을 excel로 변환 실패!";
                    customException(msg);
                    e6.printStackTrace();
                }
                
                updateProgress(95, 100);
                updateMessage(String.valueOf(95));

                // temp 폴더 삭제
//                DeletefinalTempDirs();
                
                try {
                    Thread.sleep(500);
                } catch(Exception e) {
                    
                }

                updateProgress(100, 100);
                updateMessage(String.valueOf(100));
                
                return null;
             
            }
            
            @Override
            protected void succeeded() {
                completePopup();
                activateControl();
            }
            
            @Override
            protected void failed() {
                customException(msg);
                
                activateControl();
                updateProgress(0, 100);
                
            }
        };
        
        pb.progressProperty().bind(task2.progressProperty());
        lb2.textProperty().bind(task2.messageProperty());
        
        Thread thread2 = new Thread(task2);
        thread2.setDaemon(true);
        thread2.start();
    }
    
    public void DeletefinalTempDirs() {
        try {
            Path getFolder = Paths.get(idmlZipPath);
            Path pardir = getFolder.getParent();
            String srcName = getFolder.getFileName().toString().replace(".zip", "");
            
            DirectoryStream <Path> ds = Files.newDirectoryStream(pardir);
                            
            ds.forEach(c -> {
                String fileName = c.getFileName().toString();
                
                if (Files.isDirectory(c)) {
                    if(fileName.contains(srcName) | fileName.matches("^temp$") ) {
                        obj.recursDel(c);
                    }
                    
                    
                }
            });
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
    // 체크 박스 감시 하여, TextField 비활성화
    public void checkboxLook() {
        ch1.selectedProperty().addListener(new ChangeListener<Boolean>() {
            @Override
            public void changed(ObservableValue < ? extends Boolean > observable, Boolean oldValue, Boolean newValue) {
                if(newValue) {
                    tf3.setDisable(true);
                    
                } else {
                    tf3.setDisable(false);
                }

            }
        });
    }
    
    public void openDialog(TextField tf) {
        FileChooser fc = new FileChooser();
        
        fc.getExtensionFilters().addAll(
            new ExtensionFilter("All Files", "*.*"),
            new ExtensionFilter("zip file", "*.zip")
        );
        
        File selectedFile = fc.showOpenDialog(primaryStage);

        // 선택된 파일 경로 추출
        if(selectedFile != null) {
            if(tf.getId().equals("tf1")) {
                idmlZipPath = selectedFile.getPath();
                tf.setText(idmlZipPath);
                
            } else if(tf.getId().equals("tf2")) {
                specsamplePath = selectedFile.getPath();
                tf.setText(specsamplePath);
            } else if(tf.getId().equals("tf3")) {
                spec2dataPath = selectedFile.getPath();
                
                if(tf.isDisabled()) {
                } else {
                    tf.setText(spec2dataPath);
                }
                
            }
        }
        
    }
    
    public void batchWork(TextField tf) {
        tf.setOnDragOver(e -> dragOver(e, tf));
        tf.setOnDragDropped(e -> dragDrop(e, tf));
        tf.setOnDragExited(e -> dragExit(e, tf));
        
    }
    
    private void dragOver(DragEvent e, TextField tf) {
        if(e.getGestureSource() != tf && e.getDragboard().hasFiles()) {
            tf.setStyle(
                "-fx-border-color: red;" +  
                "-fx-background-color: ANTIQUEWHITE;"
            );
            
            e.acceptTransferModes(TransferMode.COPY_OR_MOVE);
        }
        e.consume();

    }
    
    // 드래그 드랍한 경우
    public void dragDrop(DragEvent e, TextField tf) {
        boolean success = false;
        
        if(e.getGestureSource() != tf && e.getDragboard().hasFiles()) {
            getFiles = e.getDragboard().getFiles();
            
            // 디렉토리는 삭제
            getFiles.removeIf(a -> a.isDirectory());
            String getParentPath = getFiles.get(0).getAbsolutePath();
            
            if(tf.getId().equals("tf1")) {
                idmlZipPath = getParentPath;
                tf.setText(idmlZipPath);
                
            } else if(tf.getId().equals("tf2")) {
                specsamplePath = getParentPath;
                tf.setText(specsamplePath);
                
            } else if(tf.getId().equals("tf3")) {
                spec2dataPath = getParentPath;
                tf.setText(spec2dataPath);
            }
            
            // TextField에 부모 디렉토리 입력
            tf.setText(getParentPath);
            
            success = true;
        }
        
        e.setDropCompleted(success);
        e.consume();
    }
    
    
    // 드래그를 끝마친 경우 경우
    public void dragExit(DragEvent e, TextField tf) {
        tf.setStyle("-fx-background-color: #ffc0cb;");
    } 
    
    // 예외 발생시 호출될 메소드
    public void customException(String msg) {
        System.out.println("customException() 메소드 호출");
        errorPopup(msg);
        return;
    }
    
    public void errorPopup(String msg) {
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/java/fxcontroller/fxml/verError.fxml"));
            parent.setStyle("-fx-background-color: ANTIQUEWHITE");
            Button sebt = (Button) parent.lookup("#errBt");
            sebt.setOnAction(ev -> dg.close());
            Label selb = (Label) parent.lookup("#errLb1");
            selb.setText(msg);
            Scene scenePop = new Scene(parent);
            dg.setScene(scenePop);
            dg.setResizable(false);
            dg.show();
            
            Point2D point = parent.localToScene(100.0, 100.0);
            dg.setX(primaryStage.getX() + point.getX());
            dg.setY(primaryStage.getY() + point.getY());

        } catch (IOException e1) {
            e1.printStackTrace();
        }
    }
    
    private void completePopup() {
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/java/fxcontroller/fxml/completePopup.fxml"));
            parent.setStyle("-fx-background-color: ANTIQUEWHITE");
            Button sebt = (Button) parent.lookup("#completeBt1");
            sebt.setOnAction(ev -> dg.close());
            Scene scenePop = new Scene(parent);
            dg.setScene(scenePop);
            dg.setResizable(false);
            dg.show();
            
            Point2D point = parent.localToScene(100.0, 100.0);
            dg.setX(primaryStage.getX() + point.getX());
            dg.setY(primaryStage.getY() + point.getY());

        } catch (IOException e1) {
        }
    }
    
    public void DisabledControl() {
        tf1.setDisable(true);
        tf2.setDisable(true);
        tf3.setDisable(true);
        
        bt1.setDisable(true);
        bt2.setDisable(true);
        bt3.setDisable(true);
        bt4.setDisable(true);
    }
    
    public void activateControl() {
        tf1.setDisable(false);
        tf2.setDisable(false);
        tf3.setDisable(false);
        
        bt1.setDisable(false);
        bt2.setDisable(false);
        bt3.setDisable(false);
        bt4.setDisable(false);
    }
 
}
