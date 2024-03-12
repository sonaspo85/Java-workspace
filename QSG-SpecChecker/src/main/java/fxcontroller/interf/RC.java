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
        System.out.println("obj.packageDir: " + obj.packageDir);
        // config.properties 파일 생성 및 텍스트 호출
        recallPropertyInfo();
        
        // 체크박스 기본으로 선택 상태로 출력
        ch1.setSelected(true);
        
        // 텍스트 필드 기본 비활성화 상태로 출력
        tf3.setDisable(true);
        
        // 체크 박스 감시
        checkboxLook();
        
         // 파일을 드래그 오버 방식
        batchWork(tf1);
        batchWork(tf2);
        batchWork(tf3);
        
        // 다이얼로그로 파일 선택 
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

            System.out.println("idmlzipP: " + obj.idmlzipP);
            System.out.println("specSampleP: " + obj.specSampleP);
            System.out.println("spec2xmlP: " + obj.spec2xmlP);
            
        } catch (Exception e1) {
            e1.printStackTrace();
        }
    }
    
    public void workStart(ActionEvent e) {
        System.out.println("workStart() 시작");

        // 버튼 비활성화
        DisabledControl();
        
        idmlZipPath = tf1.getText();
        specsamplePath = tf2.getText();
        spec2dataPath = tf3.getText();
        
        Task<Void> task2 = new Task<Void>() {
            // 에러 메시지를 전역 변수로 생성
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
                    // 에러 메시지 전역 변수의 값으로 할당
                    msg = e2.getMessage();
                    customException(msg);
                    e2.printStackTrace();
                }
                
                updateProgress(40, 100);
                updateMessage(String.valueOf(40));

                // spec2xml-data 을 xml로 변환 시작 *************************
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
                System.out.println("excelSpecTxml 완료");
                
                
                // SPEC_Sample 을 xml 로 변환 시작 *****************************
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
                
                // 수치값 넣기
//                System.out.println("validationF: " + obj.validationF);
//                System.out.println("validationF: " + obj.languagesF);
                
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
                System.out.println("exceltxml 완료");
                
                // validation.xml 파일을 읽어 model, product, optical 정보 추출 하기
                readValidF readV = new readValidF();
                
                try {
                    readV.runReadxml();
                    
                    System.out.println("obj.modelStr: " + obj.modelStr);
                    System.out.println("obj.productStr: " + obj.productStr);
                    System.out.println("obj.opticalStr: " + obj.opticalStr);
                    
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
                
                // product 타입에 따라서 bat 파일 실행 시작 *************************
                transformXSLT tf = new transformXSLT(obj.srcDir);

                try {
                    if(obj.productStr.equals("Mobile phone") | obj.productStr.equals("Tablet")) {
                        System.out.println("Mobile phone|Tablet");
                        tf.runMobilebatch();
                        
                    } else {
                        System.out.println("악세사리");
                        tf.runAccbatch();            
                    }
                    
                } catch(Exception e) {
//                    String msg = "Validation.xml 파일 읽기 오류";
                    System.out.println(e.getMessage());
                    msg = e.getMessage();
                    customException(msg);
//                    e.printStackTrace();
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
                DeletefinalTempDirs();
                
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
                System.out.println("succeeded(): 최종 완료");
                
                // 작업 완료 팝업창
                completePopup();
                activateControl();
            }
            
            @Override
            protected void failed() {
                System.out.println("failed(): " + msg);
                customException(msg);
                
                // 버튼을 다시 활성화 하기
                activateControl();
                
                // Progressbar 초기 상태로 변경
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
        System.out.println("DeletefinalTempDirs() 시작");
        /*
        String tempDirs0 = obj.srcDir + "/temp";
        Path tempDirs = Paths.get(tempDirs0);
        
        String zipDirs0 = obj.srcDir + File.separator + obj.srcFileName + "_INDD";
        System.out.println("zipDirs0: " + zipDirs0);
        Path zipDirs00 = Paths.get(zipDirs0);
       
        
        if(Files.exists(tempDirs) | Files.exists(zipDirs00)) {
            obj.recursDel(tempDirs);
            obj.recursDel(zipDirs00);
        }
        */
        

        
        try {

            Path getFolder = Paths.get(idmlZipPath);
            Path pardir = getFolder.getParent();
//            System.out.println("pardir: " + pardir);
            String srcName = getFolder.getFileName().toString().replace(".zip", "");
            System.out.println("srcName: " + srcName);
            
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
    
    // 체크 박스 감시 하여, TextField 비활성화 하기
    public void checkboxLook() {
        ch1.selectedProperty().addListener(new ChangeListener<Boolean>() {
            @Override
            public void changed(ObservableValue < ? extends Boolean > observable, Boolean oldValue, Boolean newValue) {
                if(newValue) {
                    System.out.println("선택");
                    tf3.setDisable(true);
                    
                } else {
                    System.out.println("해제");
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

        // 선택된 파일 경로 얻기 - File.getPath() 메소드
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
                    System.out.println("사용할 수 없음");
                } else {
                    tf.setText(spec2dataPath);
                    System.out.println("spec2dataPath: " + spec2dataPath);
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
            
            // acceptTransferModes(): 드래그앤 드롭에 대한 전송 모드를 지정한다.
            e.acceptTransferModes(TransferMode.COPY_OR_MOVE);
        }
        // consume(): 드래그 이벤트를 소비된것(완료된 것)으로 표시하고, 추가적인 전파를 중지 시킨다.
        e.consume();

    }
    
    // 드래그 드랍한 경우
    public void dragDrop(DragEvent e, TextField tf) {
        boolean success = false;
        
        if(e.getGestureSource() != tf && e.getDragboard().hasFiles()) {
            getFiles = e.getDragboard().getFiles();
            
            // 디렉토리는 삭제
            getFiles.removeIf(a -> a.isDirectory());
            
            // 파일의 절대 경로 추출
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
        System.out.println("selectedPopup() 메소드 호출");
        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        // FXMLLoader.load() 메소드로 팝업 로드
        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/java/fxcontroller/fxml/verError.fxml"));
            parent.setStyle("-fx-background-color: ANTIQUEWHITE");
            //버튼 찾기 
            Button sebt = (Button) parent.lookup("#errBt");
            sebt.setOnAction(ev -> dg.close());
            
            // 라벨 컨트롤 찾기
            Label selb = (Label) parent.lookup("#errLb1");
            selb.setText(msg);
            
            // Scene 객체 생성
            Scene scenePop = new Scene(parent);
            
            // 다이얼로그에 Scene 올리기
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
        System.out.println("completePopup() 메소드 호출");
        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        // FXMLLoader.load() 메소드로 팝업 로드
        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/java/fxcontroller/fxml/completePopup.fxml"));
            parent.setStyle("-fx-background-color: ANTIQUEWHITE");
            //버튼 찾기 
            Button sebt = (Button) parent.lookup("#completeBt1");
            sebt.setOnAction(ev -> dg.close());
            
            // Scene 객체 생성
            Scene scenePop = new Scene(parent);
            
            // 다이얼로그에 Scene 올리기
            dg.setScene(scenePop);
            dg.setResizable(false);
            dg.show();
            
            Point2D point = parent.localToScene(100.0, 100.0);
            dg.setX(primaryStage.getX() + point.getX());
            dg.setY(primaryStage.getY() + point.getY());

        } catch (IOException e1) {
            System.out.println("completePopup() 메소드 에러");
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
