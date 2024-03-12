package main.java.kohyoungTech.Main;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.ResourceBundle;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.concurrent.Task;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Insets;
import javafx.geometry.Point2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.ProgressBar;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.DragEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.TransferMode;
import javafx.scene.layout.TilePane;
import javafx.stage.DirectoryChooser;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import net.sf.saxon.lib.NamespaceConstant;

public class RC implements Initializable {
	@FXML private TilePane tilepane;
	@FXML private TextField tf1;
	@FXML private TextField tf2;
	@FXML private Button bt1;
	@FXML private Button bt2;
	@FXML private Button bt3;
	@FXML private Button bt4;
	@FXML private ImageView settings;
	@FXML private ComboBox cb;
	@FXML private ProgressBar pb;
	@FXML private Label pbl;
	
	String srcFPath = "";
    String outFPath = "";
    String msg = "";
    File tempF = null;
    String srcDir = "";
    String tarDir = "";
    String outFolderName = "";
    String multiSearchS = "";
    
    Path srcpath = null;
    int cnt = 0;
    
	private Stage primaryStage;
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }
    
    implementOBJ obj = new implementOBJ();
    List<String> lgnsList = new ArrayList<String>();
    List<File> getFiles = new ArrayList<>();
    List<String> selectedCheckBox = new ArrayList<>(); 
    String projectDir = "";
    String xslDir = "";
    String codesF = "";
    
    ArrayList<InOutPathClas> xsltList = new ArrayList<>();
    List<String> templateList = new ArrayList<>();
    public ObservableList<String> oblist = FXCollections.observableArrayList();
    
	@Override
	public void initialize(URL location, ResourceBundle resources) {
	    // projectdir 경로 설정
	    File projectdir = new File("");
	    projectDir = projectdir.getAbsolutePath();
	    obj.projectDir = projectDir;
	    
	    xslDir = projectDir + File.separator + "xsls";
	    obj.xslDir = xslDir;
	    
	    codesF = xslDir + File.separator + "codes.xml";
//	    codesF = projectDir + File.separator + "bin" + File.separator + "codes.xml";
//	    obj.codesF = codesF;
	    
		// languages.xml 파일 읽기 
		getLanguageCode lc = new getLanguageCode(codesF);
		lgnsList = lc.getISOCode();
		obj.lgnsList.addAll(lgnsList);
		
		// 선택한 체크박스 목록을 list 컬렉션으로 얻기
		createCheckBox();
		
		// Template폴더내 포함되어 있는 폴더 이름 추출하기
		getTemplate();
		
		// combobox 의 목록 채워 넣기
		oblist.addAll(templateList); 
		
		cb.setItems(oblist);
		cb.getSelectionModel().selectFirst();
		
		
		// 이미지 경로를 String 으로 얻기
//		String imgpath = projectDir + File.separator + "bin/settings.jpg"; 
//		String imgpath = "C:/Users/sonas/Desktop/Image/230603/ko/bat/son-test/bin/settings.jpg";
//		FXMLLoader loader = new FXMLLoader(RC.class.getClassLoader().getResource("main/java/kohyoungTech/Main/settings.jpg"));
		InputStream imgpath = RC.class.getClassLoader().getResourceAsStream("main/java/kohyoungTech/Main/settings.jpg");
		
        // 이미지 객체 생성
        Image image = new Image(imgpath);
        
        
        // imageView 객체에 이미지 할당
        settings.setImage(image);
//        settings.setPickOnBounds(true);
        
        // 톱니바퀴 클릭하여 outFolderName 가져오기
        settings.setOnMouseClicked(e -> getOutFolderName(e));

		// 드래그 오버
		// 파일을 드래그 오버 방식
        batchWork(tf1);
        batchWork(tf2);
        
        // 다이얼로그로 파일 선택 
        bt1.setOnAction(e -> openDialog(tf1));
        bt2.setOnAction(e -> openDialog(tf2));
        
		
        // 다중검색
//        bt3.setOnAction(e -> openMultiDialog());
        bt3.setOnAction(e -> workSearch(e));
        
        // 프로세스 실행
        bt4.setOnAction(e -> workStart(e));
		
	}
	
	public void getOutFolderName(MouseEvent e) {
	    try {
            // FXMLLoader.load() 메소드로 pop.fxml 파일 로드
            Parent parent = FXMLLoader.load(getClass().getResource("settingPop.fxml"));

            // 커스텀 다이얼로그 만들기
            // Popup은 윈도우의 기본 장식(아이콘, 제목, 최소화, 복원, 닫기)을 가지고 있지 않지만,
            // Stage 객체를 통해 커스텀 다이얼로그를 생성하면, 윈도우 기본 장식을 가지게 할 수도 있다.
            Stage dg = new Stage(StageStyle.UTILITY);
            dg.initModality(Modality.WINDOW_MODAL);
            dg.initOwner(primaryStage);
            
            dg.setTitle("다이얼로그 제목");
            
            // 버튼 속성을 가진 객체를 찾아 메소드로 닫기
            Button bt = (Button) parent.lookup("#sbt1");

            bt.setOnAction(event -> {
                TextField stf = (TextField) parent.lookup("#stf1");
                outFolderName = stf.getText();
                System.out.println("outFolderName: " + stf.getText());
                dg.close();
            });
            
      
            
            // Scene 생성
            Scene scenePop = new Scene(parent);  // 장면에 pop.fxml 레이아웃 올림
            
            // 다이얼로그에 장면(Scene) 올리기
            dg.setScene(scenePop);        
            dg.setResizable(false);  // 크기를 변경하지 못하도록 설정
            dg.show();
            
            
        } catch (IOException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }

      
	}
	
	public void workStart(ActionEvent e) {
        System.out.println("workStart() 시작");
        
        srcDir = tf1.getText();
        tarDir = tf2.getText();
        obj.srcDir = srcDir;
        obj.tarDir = tarDir;
        
        System.out.println("srcDir: " + srcDir);
        System.out.println("tarDir: " + tarDir);
        
        if(srcDir.equals("") & tarDir.equals("")) {
            System.out.println("srcDir, TarDir 이 비었습니다.");
            msg = "소스 경로 및 출력 경로를 입력해 주세요.";
            customException(msg);
            
        }
        
        if(outFolderName.equals("") | outFolderName == null) {
            System.out.println("outFolderName 없음");
            obj.outFolderName = "Output";
            
        } else {
            obj.outFolderName = outFolderName;
        }
        
        System.out.println("obj.outFolderName11: " + obj.outFolderName);
        
        // combobox에 선택한 목록 추출 
        Object getTemplate = cb.getValue();
        obj.templateType = getTemplate.toString();
        
        System.out.println("getTemplate: " + getTemplate);
        String templateDir = obj.projectDir + File.separator + "template" + File.separator + getTemplate;
        obj.templateDir = templateDir;
        
        
        // 버튼 비활성화
        DisabledControl();
        
        // temp 폴더가 존재 한다면 삭제
        initialTempDelete();    
        
        Task<Void> task2 = new Task<Void>() {
            @Override
            protected Void call() {
                cnt += 5;
                updateProgress(cnt, 100);
                updateMessage(String.valueOf(cnt));
                // codes 파일 복사
                copycodes copycodeF = new copycodes(codesF, selectedCheckBox);
                try {
                    copycodeF.runCopyCodes();

                } catch (Exception e1) {
                    msg = e1.getMessage();
                    customException(msg);
                    e1.printStackTrace();
                }
                
                // 소스파일 하나씩 추출 하여 실행
                runSrcFiles rsf = new runSrcFiles();

                srcpath = Paths.get(obj.srcDir);
                String word2htmlDirS = obj.projectDir + File.separator + "xsls" + File.separator + "word2html.exe";
               
                File[] docxFiles = srcpath.toFile().listFiles();
                
                // word2html.exe 
                for(int w = 0; w < docxFiles.length; w++) {
                    File file = docxFiles[w];
                    
                    if(file.getName().contains(".docx")) {
                        try {
                            // docx 를 htm으로 변환
                            File word2htmlDirF = new File(word2htmlDirS + " " + file);
                            rsf.batchEx(word2htmlDirF);
                            
                            cnt += 5;
                            updateProgress(cnt, 100);
                            updateMessage(String.valueOf(cnt));
                            
                            DirectoryStream<Path> ds = Files.newDirectoryStream(srcpath);

                            // 추출된 htm 파일에 대해 반복
                            ds.forEach(a -> {
                                if(Files.isRegularFile(a)) {
                                    if(a.toAbsolutePath().toString().contains(".htm")) {
                                        try {
                                            String curFullPath = a.toAbsolutePath().toString();
                                            System.out.println();
                                            String curFileName = a.getFileName().toString();
                                            
                                            curFileName = curFileName.replace(".htm", "");
                                            
                                             // 파일의 마지막 언어코드 추출
                                             int lastDot = curFileName.lastIndexOf("_");
                                             String curLastLang = curFileName.substring(lastDot+1);
                                             obj.curLastLang = curLastLang;
//                                             System.out.println("curLastLang: " + curLastLang);
                                             
                                             transformXSLT transxslt = new transformXSLT(curFullPath);
                                             
                                             // xslt 작업을 위해 input, output, xslt 경로를 할당하여 list 컬렉션으로 수집
                                             xsltList = transxslt.setList();
                                             
                                             cnt += 5;
                                             updateProgress(cnt, 100);
                                             updateMessage(String.valueOf(cnt));
                                             
                                             // 수집한 list 를 반복하여 xslt 실행
                                             for(int j=0; j<xsltList.size(); j++) {
                                                 System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
                                                 InOutPathClas iopc = xsltList.get(j);
                                                 
                                                 // xslt 실행
                                                 transxslt.executeXslt(iopc);
                                                 
                                                 cnt += 1;
                                                 updateProgress(cnt, 100);
                                                 updateMessage(String.valueOf(cnt));
                                             }
                                             
                                             // xslt 실행을 하기 위해 모은 list 컬렉션 초기화
//                                             xsltList.clear();
                                             
                                        } catch (Exception e) {
//                                            xsltList.clear();
                                            msg = e.getMessage();
                                            customException(msg);
                                            e.printStackTrace();
                                        }
                                        
                                        try {
                                            Files.delete(a);
                                        } catch (IOException e) {
                                            // TODO Auto-generated catch block
                                            e.printStackTrace();
                                        }
                                    }
                                    
                                } else if(Files.isDirectory(a) & a.toAbsolutePath().toString().endsWith("files")) {  // 폴더인 경우
                                    String curFullPath = a.toAbsolutePath().toString();
                                    String curFileName = a.getFileName().toString();
                                    
                                    curFileName = curFileName.replace(".files", "");
                                    // 파일의 마지막 언어코드 추출
                                    int lastDot = curFileName.lastIndexOf("_");
                                    String curLastLang = curFileName.substring(lastDot+1);
                                    obj.curLastLang = curLastLang;
                                    
                                    // htm 파일 생성시 같이 생성되었던 폴더의 이미지 복사 하기
                                    File qdir = new File(curFullPath.replace(".docx", ".files"));
                                    File qto = new File(obj.tarDir + File.separator + obj.outFolderName + File.separator + curLastLang + File.separator + "/images");
//                                    System.out.println("qto: " + qto);
                                    
                                    if(!qto.exists()) {
                                        qto.mkdirs();
                                    }
                                    
                                    cnt += 1;
                                    updateProgress(cnt, 100);
                                    updateMessage(String.valueOf(cnt));
                                    
                                    obj.copyFolder(qdir, qto);
                                    
                                    // 폴더 및 파일 삭제
                                    obj.recursDel(qdir.toPath());
                                    
                                    cnt += 1;
                                    updateProgress(cnt, 100);
                                    updateMessage(String.valueOf(cnt));
                                    
                                    // template 복사
                                    String outHtmlS = obj.tarDir + File.separator + obj.outFolderName + File.separator + curLastLang;
                                    Path tempP = Paths.get(obj.templateDir);
                                    Path htmlP = Paths.get(outHtmlS);
                                    
                                    templateCopy tc = new templateCopy(outHtmlS);
                                    tc.templateFontCopy2(htmlP, tempP);
                                    
                                    cnt += 1;
                                    updateProgress(cnt, 100);
                                    updateMessage(String.valueOf(cnt));
                                }
                                
                                
                                
                                cnt += 1;
                                updateProgress(90, 100);
                                updateMessage(String.valueOf(90));
                            });
                            
                            
                            
//                        
                           
                        } catch (Exception e) {
                            msg = "word2html.exe 실행 실패"; 
                            throw new RuntimeException(msg);
                        }
                        
                    }
                    
                    // temp 폴더 삭제
                    Path tempP = Paths.get(obj.tempF);
                    xsltList.clear();
                    tempDel(tempP);
                    
                    
                    updateProgress(100, 100);
                    updateMessage(String.valueOf(100));
                    
                    try {
                        Thread.sleep(300);
                        
                        cnt = 0;
                        updateProgress(0, 100);
                        updateMessage(String.valueOf(0));
                        
                    } catch(Exception e) {
                        
                    }
                    
                }

                
                
                updateProgress(100, 100);
                updateMessage(String.valueOf(100));
                
                return null;
            }
            
            @Override
            protected void succeeded() {
                System.out.println("succeeded(): 최종 완료");
                
                obj.lgnsList.clear();
                
                // 작업 완료 팝업창
                completePopup();
                activateControl();
            }
            
            @Override
            protected void failed() {
                System.out.println("failed(): " + msg);
                customException(msg);
                
                obj.lgnsList.clear();
                
                // 버튼을 다시 활성화 하기
                activateControl();
                
                // temp 폴더 삭제
                Path tempP = Paths.get(obj.tempF);
                obj.recursDel(tempP);
                
                // Progressbar 초기 상태로 변경
                updateProgress(0, 100);
                
            }
        };
        
        pb.progressProperty().bind(task2.progressProperty());
        pbl.textProperty().bind(task2.messageProperty());
        
        Thread thread2 = new Thread(task2);
        thread2.setDaemon(true);
        thread2.start();
        

        
	}
	
	public void activateControl() {
        tf1.setDisable(false);
        tf2.setDisable(false);
        
        bt1.setDisable(false);
        bt2.setDisable(false);
        bt3.setDisable(false);
        bt4.setDisable(false);
        
        cb.setDisable(false);
        tilepane.setDisable(false);
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
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/java/kohyoungTech/Main/verError.fxml"));
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
	
	public void deleteTemp() {
	    System.out.println("deleteTemp() 시작");
	    
	    
	}
	
	public void DisabledControl() {
        tf1.setDisable(true);
        tf2.setDisable(true);
        
        bt1.setDisable(true);
        bt2.setDisable(true);
        bt3.setDisable(true);
        bt4.setDisable(true);
        
        cb.setDisable(true);
        tilepane.setDisable(true);
    }
	
	public void initialTempDelete() {
        System.out.println("initialTempDelete() 시작");
        
        tempF = new File(projectDir + File.separator + "temp");
        obj.tempF = tempF.toString();
        
        if(Files.exists(tempF.toPath())) {
            System.out.println("temp 폴더 삭제후 생성");
            obj.recursDel(tempF.toPath());
            tempF.mkdir();
            
        } else {
            System.out.println("temp 폴더 생성");
            tempF.mkdir();
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
            
            // 파일인 경우 삭제
            getFiles.removeIf(a -> a.isFile());
            
            // 폴더의 절대 경로 추출
            String getParentPath = getFiles.get(0).getAbsolutePath();
            
            if(tf.getId().equals("tf1")) {
                srcFPath = getParentPath;
                tf.setText(srcFPath);
                
            } else if(tf.getId().equals("tf2")) {
                outFPath = getParentPath;
                tf.setText(outFPath);
                
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
	
	
	public void createCheckBox() {
//		tilepane.setBackground(new Background(new BackgroundFill(Color.BEIGE, CornerRadii.EMPTY, Insets.EMPTY)));
		tilepane.setPadding(new Insets(10, 10, 10, 10));
	
		CheckBox checkbox = new CheckBox(); 
		for(int j=0; j<lgnsList.size(); j++) {
			String item = lgnsList.get(j);
			checkbox = new CheckBox(item);
			
			checkbox.setPadding(new Insets(10, 40, 14, 14));
			
			checkbox.setStyle("-fx-font-family:Arial Black;-fx-font-size:12px;");
			tilepane.autosize();
			tilepane.getChildren().add(checkbox);
			
			checkbox.selectedProperty().addListener(new ChangeListener<Boolean>() {
				@Override
		        public void changed(ObservableValue<? extends Boolean> observable, Boolean oldValue, Boolean newValue) {
		            if(newValue){
		                // your checkbox has been ticked. 
		                // write login-username to config file
		            	selectedCheckBox.add(item);
		            	
		            }else{
		                // your checkbox has been unticked. do stuff...
		                // clear the config file
		            	selectedCheckBox.remove(item);
		            }
		        }
			});
		}  // for문 닫기 
		
	}
	
	private void completePopup() {
        System.out.println("completePopup() 메소드 호출");
        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        // FXMLLoader.load() 메소드로 팝업 로드
        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/java/kohyoungTech/Main/completePopup.fxml"));
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
	
	public void openDialog(TextField tf) {
	    System.out.println("saveDirs() 메소드 시작 부분");
	    DirectoryChooser dc = new DirectoryChooser();
	    dc.setTitle("저장 폴더를 선택 하세요.");
	    File selectedDir = dc.showDialog(primaryStage);
	    
	    // 폴더의 절대 경로 추출
//        String getParentPath = getFiles.get(0).getAbsolutePath();
        
	    if (selectedDir == null) {
	        msg = "저장 폴더가 지정되지 않았습니다.";
//	        return msg;
	    }

        // 선택된 파일 경로 얻기 - File.getPath() 메소드
        if(selectedDir != null) {
            if(tf.getId().equals("tf1")) {
                srcFPath = selectedDir.getAbsolutePath();
                tf.setText(srcFPath);
                
            } else if(tf.getId().equals("tf2")) {
                outFPath = selectedDir.getAbsolutePath();
                tf.setText(outFPath);
                
            } 
        }
	    
	    
	}
	
	public void openMultiDialog() {
        System.out.println("openMultiDialog() 시작");
        DirectoryChooser dc = new DirectoryChooser();
        dc.setTitle("저장 폴더를 선택 하세요.");
        File selectedDir = dc.showDialog(primaryStage);
        
        // 폴더의 절대 경로 추출
//        String getParentPath = getFiles.get(0).getAbsolutePath();
        
        if (selectedDir == null) {
            msg = "저장 폴더가 지정되지 않았습니다.";
//          return msg;
        } else {
        	multiSearchS = selectedDir.getAbsolutePath();
        	obj.multiSearchSrcDir = multiSearchS;  
        	
        }

        System.out.println("multiSearch: " + obj.multiSearchSrcDir);
        
        
    }
	
	public void workSearch(ActionEvent e) {
		System.out.println("workSearch() 시작");
		obj.multiTemplateDir = obj.xslDir + File.separator + "multiSearch";
		
		openMultiDialog();
		
		if(obj.multiSearchSrcDir != null & !obj.multiSearchSrcDir.equals("")) {
			// _db 생성하기
			transformXSLT2 xslt2 = new transformXSLT2();
			xslt2.runDBF();
			
			multiSearchControl msc = new multiSearchControl();
			msc.runSearchControl();
			
			LinkedHashSet<String> noMatchLgn = msc.compareLang();
			
			// 사용하지 않는 언어가 있을 경우 예외 팝업창 출력
			if(noMatchLgn.size() >= 1) {
				msg = "사용하지 않는 언어가 있습니다. " + noMatchLgn.toString();
				System.out.println("msg: " + msg);
	            customException(msg);
			} 
			
			// index.html 을 읽고 쓰기
			copyIndex copyindex = new copyIndex();
			try {
				copyindex.runCopyIndex();
					
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
	
			// template 파일들 복사 하기
	//		obj.multiSearchSrcDir = "H:/WORK/kohyung/kohyoung-searchDB/resource";
			Path srcDirP = Paths.get(obj.multiSearchSrcDir);
			Path templateDir = Paths.get(obj.multiTemplateDir);
			
			copyMultiSearchDir cmsd = new copyMultiSearchDir();
			cmsd.templateSearchCopy(templateDir, srcDirP);
			
			
			
			// 완료 팝업창
			completePopup();
		} 
	}
    
	//--------------------------------------------------------------------------------------
	public void getTemplate() {
	    System.out.println("getTemplate() 시작");
	    
	    System.out.println("templateDir : " + obj.templateDir);
	    String templateDir = obj.projectDir + File.separator + "template";
	    
	    Path path = Paths.get(templateDir);
	    try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {
                    String folderName = a.getFileName().toString();
                    
                    System.out.println("folderName: " + folderName);
                    templateList.add(folderName);
                }
            });
            
            
        } catch (IOException e) {
            System.out.println("template 경로 추출 에러");
            e.printStackTrace();
        }

	}
	
	public void tempDel(Path tempF) {
	    System.out.println("tempDel() 시작");
	    System.out.println("obj.tempF: " + tempF);
	    
	    try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(tempF);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {
                    tempDel(a);
                    
                } else if(!a.getFileName().toString().contains("codes")) {
                    try {
                        Files.delete(a);
                        
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                
            });

        } catch(Exception e) {
            e.printStackTrace();
        }
        
	}
    
}
