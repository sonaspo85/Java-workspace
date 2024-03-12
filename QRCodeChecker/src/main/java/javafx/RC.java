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
    
    // primaryStage 전달 받기 위해 setPrimaryStage() 메소드 생성
    private Stage primaryStage;
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }
    
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        // config.properties 파일 생성 및 텍스트 호출
        recallPropertyInfo();
        
        // 파일을 드래그 오버 방식
        batchWork(tf1);
        batchWork(tf2);
        
        // 프로세스 실행
        bt1.setOnAction(e -> workStart(e));
        
    }
    
    public void workStart(ActionEvent e) {
        System.out.println("workStart() 시작");
        
        // 버튼 비활성화
        DisabledControl();
        
        // temp 폴더가 존재 한다면 삭제
        initialTempDelete();
        
        
        
        // Task 클래스를 사용하여, 작업스레드와 javafx 간의 스레드 동시성을 구현
        Task<Void> task = new Task<Void>() {
            // 에러 메시지를 전역 변수로 설정
            String msg = "";
            
            
            @Override
            protected Void call() {
                // 1. config.properties 파일을 호출하여, 새로운 값(경로)를 재할당 하기
                try {
                    cf.setkeyNvals(tf1.getText(), tf2.getText());
                    
                    
                } catch(Exception e) {
                    msg = "config.properties 파일로 path 전달 실패";
                    customException(msg);
                    e.printStackTrace();
                }
                
                updateProgress(5, 100);
                updateMessage(String.valueOf(5));
                
                // 소스 및 타겟 경로 설정 -----------------------
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
                
                
                // 소스 및 타겟 경로 설정 끝 -----------------------
                
                map.put(langSrc, idmlSrcZipPath);
                
                if(!idmlTarZipPath.equals("")) {
                	map.put(langTar, idmlTarZipPath);                	
                }
                 
                map.forEach((k, v) -> {
                    String lang = k;
                    String srcPathStr = v;
                    
                    
                    // 1. 압축 해제할 경로 설정
                    unzipMain unzipmain = new unzipMain();
                    unzipmain.setPath(srcPathStr, lang);
                    
                    try {
                    	// 2. 처음 묶음된 zip 파일 경로의 압축 풀기 
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
                    
                    
                    // 2. 처음 묶음된 zip IDML 폴더 제어하기
                    idmlMain idmain = new idmlMain();
                    
                    // 2-1. idml 파일들만 새로운 zipDir 경로에 zip 확장자로 변경하여 복사 시키기
                    Path newZipDir = idmain.getIdml2Zip();
                    
                    try {
                        // 4. zipDir 폴더내 idml 확장자를 zip확장자로 변경한 파일들을 unzip 하기 위해서
                        // 자바 내장 ZipInputStream 을 사용하여 unzip 함
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
                    
//                    String newZipDirS = "H:/JAVA/java-workspace/QRCodeChecker/temp/SM-X916B_QSG_ASIA_Eng_D01_230502_INDD_Eng/zipDir";
//                    Path newZipDir = Paths.get(newZipDirS);
                    // 6. 각 폴더내 접근하여, designmap.xml 얻기
                    try {
                        System.out.println("newZipDir: " + newZipDir);
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
                    	// 7. <idml 이름, idml폴더내 모든 Story.xml를 묶은 root> 형태의 map 컬렉션 반환 받음
                        eachChapMap = mergedStoryF.getChapMapCollect();

                    } catch(Exception e) {
                    	msg = e.getMessage();
                    	customException(msg);
                    	e.printStackTrace();
                    }
                    
                    i += 5;
                    updateProgress(i, 100);
                    updateMessage(String.valueOf(i));
                    
                    // 8. idml 폴더별 모든 Story.xml를 묶은 root를 각각의 idml.xml 파일로 출력
                    try {
                    	createEachChapterFiles ecf = new createEachChapterFiles(eachChapMap);
                    	ecf.runEachChapterFiles();
                    } catch(Exception e) {
                    	msg = e.getMessage();
                    	customException(msg);
                    	e.printStackTrace();
                    }
                    
                    // 각각의 idml 별로 map 컬렉션으로 모은 story.xml를 초기화 
                    // 초기화 시켜주지 않는다면 반복문으로 인해 중첩 되게 된다.
                    eachChapMap.clear();
                    
                    i += 5;
                    updateProgress(i, 100);
                    updateMessage(String.valueOf(i));
                    
                    // 9. 각 idml.xml 파일들을 merged.xml 파일로 병합 하기
                    try {
                        allImdmlMerged createMerged = new allImdmlMerged(); 
                        createMerged.runAllImdml();
                        createMerged.outMergedF(lang);
                        
                        // 10. srcDir 폴더내에서 temp 폴더만 남기고 삭제 하기
//                        createMerged.delFoldder();
                        
                    } catch(Exception e) {
                        System.out.println("merged.xml 생성 에러");
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
                
                // 11. merged.xml 파일로부터 데이터 추출하기
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
                
                // 12. 빈 Doc.xml 문서 생성하여 merged_new.xml 파일로 추출하기 
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
                
                // 13. 추출된 데이터 비교
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
                
                // 14. DB 파일을 Excel로 추출하기
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
                
                // 15. temp 폴더 삭제
                try {
                	Path tempDirPath = Paths.get(obj.tempDir);
                	obj.recursDel(tempDirPath);
                	System.out.println("temp 폴더 삭제 완료!!");
                	
                } catch(Exception e) {
                	msg = e.getMessage();
                    customException(msg);
                    e.printStackTrace();
                }
                
                
                System.out.println("끝~!");
                
                
                return null;
                
            }
            
            @Override
            protected void succeeded() {
            	System.out.println("succeeded(): 최종 완료");
                i = 0;
               
                // 작업 완료 팝업창
                completePopup();
                
                // 버튼 다시 활성화
                activateControl();
            }
            
            @Override
            protected void failed() {
                System.out.println("failed(): " + msg);
                customException(msg);
                i = 0;
                // 버튼을 다시 활성화 하기
                activateControl();
                
                // Progressbar 초기 상태로 변경
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
        System.out.println("recallPropertyInfo() 시작");
        
        try {
            
            // 1. createConfigF 객체를 호출하여, properties 파일 생성 또는 값 추출 하기
            cf.runProps();
            
            // 2. 추출된 값이 존재 하고 있는 경우, TextField 에 삽입
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
            
            // acceptTransferModes(): 드래그앤 드롭에 대한 전송 모드를 지정한다.
            e.acceptTransferModes(TransferMode.COPY_OR_MOVE);
        }
        // consume(): 드래그 이벤트를 소비된것(완료된 것)으로 표시하고, 추가적인 전파를 중지 시킨다.
        e.consume();

    }
    
    // 드래그 드랍한 경우
    public void dragDrop(DragEvent e, TextArea tf) {
        boolean success = false;
        
        if(e.getGestureSource() != tf && e.getDragboard().hasFiles()) {
            getFiles = e.getDragboard().getFiles();
            
            // 디렉토리는 삭제
            getFiles.removeIf(a -> a.isDirectory());
            
            // 파일의 절대 경로 추출
            String getParentPath = getFiles.get(0).getAbsolutePath();
            
            /*if(tf.getId().equals("tf1")) {
                idmlSrcZipPath = getParentPath;
                tf.setText(idmlSrcZipPath);
                
            } else if(tf.getId().equals("tf2")) {
                idmlTarZipPath = getParentPath;
                tf.setText(idmlTarZipPath);
                
            } */
            
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
    	System.out.println("completePopup() 시작");
    	
    	// 1. 커스텀 다이얼로그 생성
    	// 윈도우 기본장식을 가진 팝업 다이얼로그를 생성하기 위해서 Stage객체를 통해 popup 객체를 생성 한다.
    	Stage dg = new Stage(StageStyle.UTILITY);
    	dg.initModality(Modality.WINDOW_MODAL);
    	dg.initOwner(primaryStage);
    	
    	try {
        	// 2. FXMLLoader.load() 메소드로 팝업 로드
    		Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/java/javafx/fxml/completePopup.fxml"));
    		parent.setStyle("-fx-background-color: ANTIQUEWHITE");
    		
    		// 3. 버튼 찾기
    		Button sebt = (Button) parent.lookup("#completeBt1");
    		
    		// 3-1 버튼 클릭시 popup창 닫기
    		sebt.setOnAction(e -> dg.close());
    		
    		// 4. Scene 객체 생성
    		// 모달 다이얼로그 객체를 실행하기 위해서는 getContent() 메소드가 아니라,
    		// Scene() 생성자의 매개값으로 popup 객체를 할당 해야 한다.
    		Scene scenePop = new Scene(parent);
    		
    		// 5. 다이얼로그에 Scene 올리기
    		dg.setScene(scenePop);
    		
    		// 6. 윈도우창을 수정할 수 없도록 하기
    		dg.setResizable(false);
    		
    		// 7. popup 객체 실행
    		dg.show();
    		
    		// 8. popup 객체의 출력될 위치 조정
    		Point2D point = parent.localToScene(100, 100);
    		dg.setX(primaryStage.getX() + point.getX());
    		dg.setY(primaryStage.getY() + point.getY());
    		
    	} catch(Exception e) {
    		System.out.println("completePopup() 메소드 에러");
    		
    	}
    	
    	
    }
    
    public void errorPopup(String msg) {
        System.out.println("selectedPopup() 메소드 호출");
        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        try {
        	// 1. FXMLLoader.load() 메소드로 팝업 로드
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/java/javafx/fxml/verError.fxml"));
            parent.setStyle("-fx-background-color: ANTIQUEWHITE");
            // 2. 버튼 찾기 
            Button sebt = (Button) parent.lookup("#errBt");
            sebt.setOnAction(ev -> dg.close());
            
            // 3. 라벨 컨트롤 찾기
            Label selb = (Label) parent.lookup("#errLb1");
            selb.setText(msg);
            
            // 4. Scene 객체 생성
            Scene scenePop = new Scene(parent);
            
            // 5. 다이얼로그에 Scene 올리기
            dg.setScene(scenePop);
            dg.setResizable(false);
            dg.show();
            
            // 6. popup 객체의 출력될 위치 조정
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
        System.out.println("initialTempDelete() 시작");
        File projectDir = new File("");
        File tempF = new File(projectDir.getAbsoluteFile() + File.separator + "temp");
        
//        Path pathTempf = Paths.get(tempF);
        
        if(Files.exists(tempF.toPath())) {
            obj.recursDel(tempF.toPath());
        }
    }

}
