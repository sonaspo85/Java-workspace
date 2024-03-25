package main.java.javafx;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import org.w3c.dom.Element;

import javafx.concurrent.Task;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Point2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.ProgressBar;
import javafx.scene.control.TextArea;
import javafx.scene.input.DragEvent;
import javafx.scene.input.TransferMode;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import main.java.CommonObj.implementOBJ;
import main.java.Main.createConfigF;
import main.java.idmlcontroller.allImdmlMerged;
import main.java.idmlcontroller.createEachChapterFiles;
import main.java.idmlcontroller.getDesMapAttr;
import main.java.idmlcontroller.idmlMain;
import main.java.idmlcontroller.mergedStoryF;
import main.java.mergedcontroller.getData;
import main.java.xmlcontroller.compareDB;
import main.java.xmlcontroller.compareDB2;
import main.java.xmlcontroller.db2xml;
import main.java.xmlcontroller.dbFiles2excel;
import main.java.zipcontroller.unzipMain;

public class RC implements Initializable {
    @FXML private TextArea tf1;
    @FXML private TextArea tf2;
    @FXML private Button bt1;

    @FXML private ProgressBar pb;
    @FXML private Label lb2;
    
    int i = 0;
    
    
    implementOBJ obj = new implementOBJ();
    List<File> getFiles = new ArrayList<>();
    String idmlSrcZipPath = "";
    String idmlTarZipPath = "";
    createConfigF cf = new createConfigF();
    
    static String msg = "";
  
    static Map<String, String> map = new HashMap<>();
    
    private Stage primaryStage;
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }
    
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        recallPropertyInfo();
        batchWork(tf1);
        batchWork(tf2);
        
        // 프로세스 실행
        bt1.setOnAction(e -> workStart(e));
        
    }
    
    public void workStart(ActionEvent e) {
        System.out.println("workStart() 시작");
        
        // 버튼 비활성화
        DisabledControl();
        
        // temp 삭제
        initialTempDelete();

        Task<Void> task = new Task<Void>() {
            String msg = "";
            
            @Override
            protected Void call() {
                // 새로운 값을 재할당 하기
                try {
                    cf.setkeyNvals(tf1.getText(), tf2.getText());
                    
                    
                } catch(Exception e) {
                    msg = "config.properties 파일로 path 전달 실패";
                    customException(msg);
                    e.printStackTrace();
                }
                
                updateProgress(5, 100);
                updateMessage(String.valueOf(5));
                
                // 소스 및 타겟 경로 설정
                idmlSrcZipPath = tf1.getText();
                
                if(tf2.getText() != null) {
                	idmlTarZipPath = tf2.getText();                	
                }
                
                String langSrc = "Eng";
                String langTar = "None";
                
                if(idmlTarZipPath != null & !idmlTarZipPath.equals("")) {
                	langTar = "multi";
                }
                
                obj.langSrc = langSrc;
                obj.langTar = langTar;

                File srcF = new File(idmlSrcZipPath); 
                obj.srcName = srcF.getName();
                
                
                if(!idmlTarZipPath.equals("")) {
                	File tarF = new File(idmlTarZipPath); 
                    obj.tarName = tarF.getName();
                }
                
                map.put(langSrc, idmlSrcZipPath);
                
                if(!idmlTarZipPath.equals("")) {
                	map.put(langTar, idmlTarZipPath);                	
                }
                 
                map.forEach((k, v) -> {
                    String lang = k;
                    String srcPathStr = v;
                    
                    unzipMain unzipmain = new unzipMain();
                    unzipmain.setPath(srcPathStr, lang);
                    
                    try { 
						unzipmain.runUnzip();
						
					} catch (Exception e) {
						msg = e.getMessage();
						customException(msg);
						e.printStackTrace();
					}
                    
                    if(i == 0) {
                    	i = 20;
                    } else {
                    	i += 5;
                    }
                    
                    updateProgress(i, 100);
                    updateMessage(String.valueOf(i));

                    idmlMain idmain = new idmlMain();
                    
                    // idml 파일들만 새로운 zipDir 경로에 zip 확장자로 변경하여 복사
                    Path newZipDir = idmain.getIdml2Zip();
                    
                    try {
                        unzipmain.runLoop(newZipDir.toString());

                    } catch (Exception e) {
                        System.out.println("newZipDir 폴더 접근 실패");
                        msg = e.getMessage();
                        customException(msg);
                        e.printStackTrace();
                    }
                    
                    i += 5;
                    updateProgress(i, 100);
                    updateMessage(String.valueOf(i));

                    // 각 폴더내 접근 및 디자인 맵 얻기
                    try {
                    	getDesMapAttr gdma = new getDesMapAttr(newZipDir);
                        gdma.runDesMap();
                    	
                    } catch(Exception e) {
                    	msg = e.getMessage();
                    	customException(msg);
                    	e.printStackTrace();
                    }
                    
                    
                    i += 5;
                    updateProgress(i, 100);
                    updateMessage(String.valueOf(i));
                    
                    Map<String, Element> eachChapMap = null;
                    try {
                        eachChapMap = mergedStoryF.getChapMapCollect();

                    } catch(Exception e) {
                    	msg = e.getMessage();
                    	customException(msg);
                    	e.printStackTrace();
                    }
                    
                    i += 5;
                    updateProgress(i, 100);
                    updateMessage(String.valueOf(i));
                    
                    try {
                    	createEachChapterFiles ecf = new createEachChapterFiles(eachChapMap);
                    	ecf.runEachChapterFiles();
                    } catch(Exception e) {
                    	msg = e.getMessage();
                    	customException(msg);
                    	e.printStackTrace();
                    }
                    
                    eachChapMap.clear();
                    
                    i += 5;
                    updateProgress(i, 100);
                    updateMessage(String.valueOf(i));
                    
                    try {
                        allImdmlMerged createMerged = new allImdmlMerged(); 
                        createMerged.runAllImdml();
                        createMerged.outMergedF(lang);
                        
                    } catch(Exception e) {
                        msg = e.getMessage();
                        customException(msg);
                        e.printStackTrace();
                    }
					
                    i += 5;
                    updateProgress(i, 100);
                    updateMessage(String.valueOf(i));
                    
                });
                
                if(idmlTarZipPath != null & idmlTarZipPath != "") {
                	i = 80;
                	
                } else if (idmlTarZipPath.equals("")) {
                	i = 80;
                }
                
                // 파일로부터 데이터 추출하기
                try {
                	getData dg = new getData();
                    dg.runGetDate();
                    
                } catch(Exception e) {
                	msg = e.getMessage();
                    customException(msg);
                    e.printStackTrace();
                }

                i += 5;
                updateProgress(i, 100);
                updateMessage(String.valueOf(i));
                 
                try {
                	db2xml db2xml = new db2xml();
                    db2xml.runDB2xml();
                    
                } catch(Exception e) {
                	msg = e.getMessage();
                    customException(msg);
                    e.printStackTrace();
                }
                
                i += 5;
                updateProgress(i, 100);
                updateMessage(String.valueOf(i));
                
                // 추출된 데이터 비교
                compareDB compare = new compareDB();
                compareDB2 compare2 = new compareDB2();
                
                try {
                	if(obj.langTar.equals("multi")) {
                    	System.out.println("단권과 합본 비교");
                    	compare.runCompare();
                    	
                    } else if(obj.langTar.equals("None")) {
                    	System.out.println("단권만 비교");
                    	compare2.runCompare();
                    }
                	
                } catch(Exception e) {
                	msg = e.getMessage();
                    customException(msg);
                    e.printStackTrace();
                }
                
                i += 5;
                updateProgress(i, 100);
                updateMessage(String.valueOf(i));
                
                try {
                	dbFiles2excel db2excel = new dbFiles2excel();
                    db2excel.runDB2Excel();
                	
                } catch(Exception e) {
                	msg = e.getMessage();
                    customException(msg);
                    e.printStackTrace();
                }
                
                i += 5;
                updateProgress(i, 100);
                updateMessage(String.valueOf(i));
                
                // temp 폴더 삭제
                try {
                	Path tempDirPath = Paths.get(obj.tempDir);
                	obj.recursDel(tempDirPath);
                	
                } catch(Exception e) {
                	msg = e.getMessage();
                    customException(msg);
                    e.printStackTrace();
                }

                return null;
                
            }
            
            @Override
            protected void succeeded() {
                i = 0;
                completePopup();
                activateControl();
            }
            
            @Override
            protected void failed() {
                customException(msg);
                i = 0;
                activateControl();
                updateProgress(0, 100);
                
            }
            
        };
        
        pb.progressProperty().bind(task.progressProperty());
        lb2.textProperty().bind(task.messageProperty());
        
        Thread thread = new Thread(task);
        thread.setDaemon(true);
        thread.start();
        
    }
    
    public void recallPropertyInfo() {
        try {
            cf.runProps();
            
            if(obj.propfSrcZipF != null | obj.propfTarZipF != null) {
                tf1.setText(obj.propfSrcZipF);
                tf2.setText(obj.propfTarZipF);
            }
            
        } catch(Exception e) {
            e.printStackTrace();
            
        }

    }
    
    public void DisabledControl() {
        tf1.setDisable(true);
        tf2.setDisable(true);
        bt1.setDisable(true);
    }
    
    public void batchWork(TextArea tf) {
        tf.setOnDragOver(e -> dragOver(e, tf));
        tf.setOnDragDropped(e -> dragDrop(e, tf));
        tf.setOnDragExited(e -> dragExit(e, tf));
        
    }
    
    private void dragOver(DragEvent e, TextArea tf) {
        if(e.getGestureSource() != tf && e.getDragboard().hasFiles()) {
        	tf.setStyle("-fx-background-color: red; -fx-text-fill:blue;");
            e.acceptTransferModes(TransferMode.COPY_OR_MOVE);
        }
        e.consume();

    }
    
    // 드래그 드랍한 경우
    public void dragDrop(DragEvent e, TextArea tf) {
        boolean success = false;
        
        if(e.getGestureSource() != tf && e.getDragboard().hasFiles()) {
            getFiles = e.getDragboard().getFiles();
            
            // 디렉토리는 삭제
            getFiles.removeIf(a -> a.isDirectory());
            
            String getParentPath = getFiles.get(0).getAbsolutePath();

            // TextField에 부모 디렉토리 입력
            tf.setText(getParentPath);
            
            success = true;
        }
        
        e.setDropCompleted(success);
        e.consume();
    }
    
    
    // 드래그를 끝마친 경우 경우
    public void dragExit(DragEvent e, TextArea tf) {
        tf.setStyle("-fx-background-color: #ffc0cb;");
    } 
    
    // 예외 발생시 호출될 메소드
    public void customException(String msg) {
        System.out.println("customException() 메소드 호출");
        errorPopup(msg);
        return;
    }
    
    public void completePopup() {
    	Stage dg = new Stage(StageStyle.UTILITY);
    	dg.initModality(Modality.WINDOW_MODAL);
    	dg.initOwner(primaryStage);
    	
    	try {
    		Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/java/javafx/fxml/completePopup.fxml"));
    		parent.setStyle("-fx-background-color: ANTIQUEWHITE");
    		Button sebt = (Button) parent.lookup("#completeBt1");
    		sebt.setOnAction(e -> dg.close());
    		
    		// Scene 객체 생성
    		Scene scenePop = new Scene(parent);
    		
    		// 다이얼로그에 Scene 올리기
    		dg.setScene(scenePop);
    		dg.setResizable(false);
    		dg.show();
    		
    		Point2D point = parent.localToScene(100, 100);
    		dg.setX(primaryStage.getX() + point.getX());
    		dg.setY(primaryStage.getY() + point.getY());
    		
    	} catch(Exception e) {
    		
    	}
    	
    	
    }
    
    public void errorPopup(String msg) {
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/java/javafx/fxml/verError.fxml"));
            parent.setStyle("-fx-background-color: ANTIQUEWHITE"); 
            Button sebt = (Button) parent.lookup("#errBt");
            sebt.setOnAction(ev -> dg.close());
            Label selb = (Label) parent.lookup("#errLb1");
            selb.setText(msg);
            
            // Scene 객체 생성
            Scene scenePop = new Scene(parent);
            dg.setScene(scenePop);
            dg.setResizable(false);
            dg.show();
            
            Point2D point = parent.localToScene(100.0, 100.0);
            dg.setX(primaryStage.getX() + point.getX());
            dg.setY(primaryStage.getY() + point.getY());

        } catch (Exception e1) {
            e1.printStackTrace();
        }
    }
    
    public void activateControl() {
        tf1.setDisable(false);
        tf2.setDisable(false);
        
        bt1.setDisable(false);
        
    }
    
    public void initialTempDelete() {
        File projectDir = new File("");
        File tempF = new File(projectDir.getAbsoluteFile() + File.separator + "temp");

        if(Files.exists(tempF.toPath())) {
            obj.recursDel(tempF.toPath());
        }
    }

}
