package fxControl;

import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

import copyFiles.Main.copyFile;
import copyFiles.Main.getLanguageCode;
import javafx.application.Platform;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Insets;
import javafx.scene.Parent;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.input.DragEvent;
import javafx.scene.input.TransferMode;
import javafx.scene.layout.Background;
import javafx.scene.layout.BackgroundFill;
import javafx.scene.layout.CornerRadii;
import javafx.scene.layout.TilePane;
import javafx.scene.paint.Color;
import javafx.stage.Popup;
import javafx.stage.Stage;

public class RC implements Initializable {
	@FXML private TilePane tilepane;
	@FXML private Button bt1;
	@FXML private TextField tf;
	
	private Stage primaryStage;
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }
    
    List<String> lgnsList = new ArrayList<String>();
    List<File> getFiles = new ArrayList<>();
    List<String> selectedCheckBox = new ArrayList<>(); 
    
    
	@Override
	public void initialize(URL location, ResourceBundle resources) {
		// languages.xml 파일 읽기
		InputStream fis = getClass().getClassLoader().getResourceAsStream("fxControl/languages.xml");
		getLanguageCode lc = new getLanguageCode(fis);
		lgnsList = lc.getISOCode();
		
		// 선택한 체크박스 목록을 list 컬렉션으로 얻기
		createCheckBox();
		
		// 드래그 오버
		tf.setOnDragOver(e -> dragOver(e));
		tf.setOnDragDropped(e -> dragDrop(e));
		tf.setOnDragExited(e -> dragExit(e));
		bt1.setOnAction(e -> clicked());
		
	}
	
	private void dragOver(DragEvent e) {
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
    public void dragDrop(DragEvent e) {
        boolean success = false;
        
        if(e.getGestureSource() != tf && e.getDragboard().hasFiles()) {
        	getFiles = e.getDragboard().getFiles();
        	if(getFiles.get(0).isFile()) {
        		System.out.println("파일은 안되!");
        		bt1.setDisable(true);
        		String txt = "폴더만 입력해주세요.";
        		exitPopup(txt);
        		return;
        		
        	} else {
        		String getParentPath = getFiles.get(0).getParent().toString();
            	
        		getFiles.forEach(a -> {
        			System.out.println("www: " + a.getAbsolutePath());
        		});
        		
            	// TextField에 부모 디렉토리 입력
            	tf.setText(getParentPath);
            	
                success = true;
                
                e.setDropCompleted(success);
                e.consume();
        	}

        }

    }
    
    // 드래그를 끝마친 경우 경우
    public void dragExit(DragEvent e) {
        tf.setStyle("-fx-background-color: #ffc0cb;");
    } 
	
	
	public void createCheckBox() {
		tilepane.setBackground(new Background(new BackgroundFill(Color.BEIGE, CornerRadii.EMPTY, Insets.EMPTY)));
		tilepane.setPadding(new Insets(10, 10, 10, 10));
	
		CheckBox cb = new CheckBox(); 
		for(int j=0; j<lgnsList.size(); j++) {
			String item = lgnsList.get(j);
			cb = new CheckBox(item);
			
			cb.setPadding(new Insets(5, 5, 5, 5));
			
			
			tilepane.getChildren().add(cb);
			
			cb.selectedProperty().addListener(new ChangeListener<Boolean>() {
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
	
	public void exitPopup(String txt) {
		System.out.println("exitPopup() 시작");
		// Popup 객체 생성
		 
		try {
			Popup pop = new Popup();
			// FXMLLoader.load() 메소드로 pop.fxml 로드
//			Parent parent = FXMLLoader.load(getClass().getResource("exitPopup.fxml"));
			Parent parent = FXMLLoader.load(RC.class.getClassLoader().getResource("fxml/exitPopup.fxml"));
			
			Button bt = (Button) parent.lookup("#exit");
			bt.setOnAction(e -> Platform.exit());
			
			Label label = (Label) parent.lookup("#popLabel"); 
			label.setText(txt);
			
			pop.getContent().add(parent);
			pop.show(primaryStage);
			
		} catch(Exception e1) {
			e1.printStackTrace();
		}

	}
	
	public void completePop() {
		System.out.println("completePop() 시작");
		// Popup 객체 생성
		 
		try {
			Popup pop = new Popup();
			// FXMLLoader.load() 메소드로 pop.fxml 로드
//			Parent parent = FXMLLoader.load(getClass().getResource("exitPopup.fxml"));
			Parent parent = FXMLLoader.load(RC.class.getClassLoader().getResource("fxml/complete.fxml"));
			
			Button bt = (Button) parent.lookup("#complete");
			bt.setOnAction(e -> Platform.exit());
			
			
			pop.getContent().add(parent);
			pop.show(primaryStage);
			
		} catch(Exception e1) {
			e1.printStackTrace();
		}

	}
	
	public void clicked() {
		System.out.println("clicked() 시작");
		
		if(getFiles.isEmpty()) {
			System.out.println("aaa");
			if(tf.getText() == "") {
				System.out.println("bbb");
				System.out.println("tf 비어 있음");
				
				String txt = "복제될 경로를 입력해주세요.";
				exitPopup(txt);
				return;
			} else {
				System.out.println("ccc");
				File file = new File(tf.getText());
				getFiles.add(file);
				
			}
		}
		
		selectedCheckBox.forEach(a -> {
			System.out.println(a);
		});
		
		copyFile cf = new copyFile(getFiles, selectedCheckBox);
		
		try {
			cf.runCopyF();
			completePop();
			
		} catch(Exception e1) {
			e1.printStackTrace();
		}

		
	}
	
}
