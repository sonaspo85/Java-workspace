package main.fxControll;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.ResourceBundle;

import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Point2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.stage.DirectoryChooser;
import javafx.stage.FileChooser;
import javafx.stage.FileChooser.ExtensionFilter;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import main.oneClickAssist.runMain.excelTxml;
import main.oneClickAssist.runMain.executeOrder;


public class RC implements Initializable {
	@FXML private Button tags;
	@FXML private Button search;
	@FXML private Button startHere;
	@FXML private Button newContents;
	
	// 컨트롤러에서 다이얼로그 얻기
    private Stage primaryStage;
    
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }
    
    String selectedFile = "";
    Path srcDir = null;
    String getsheet = "";
    // FileChooser 객체 생성
 	FileChooser fc = new FileChooser();
 	DirectoryChooser dc = new DirectoryChooser();
    public static File jarPath = new File("").getAbsoluteFile();
    
    
	@Override
	public void initialize(URL location, ResourceBundle resources) {
		tags.setOnAction(e -> excelTxml());
//		search.setOnAction(e -> createSearch());
//		startHere.setOnAction(e -> createStartHere());
		newContents.setOnAction(e -> createNewContents());
		search.setDisable(true);
		startHere.setDisable(true);
	}
	
	public void createNewContents() {
	    System.out.println("createNewContens 시작");
	    
	    File selectedDir = dc.showDialog(primaryStage);
	    Path srcDir = Paths.get(selectedDir.toString());
	    System.out.println("srcDir: " + srcDir);
	    try {          
	        Path conPath = Paths.get("contents");
	        
	        executeOrder eo = new executeOrder(conPath, jarPath, srcDir);       
	        eo.setList();
	        
	        // 종료 팝업
            finishedPop();
        } catch(Exception e1) {
            String msg = "예외가 발생되었습니다. 작업이 중지 됩니다.";
            System.out.println(msg);
            e1.printStackTrace();
            selectedPopup(msg);
            return;
        }
	}
	
	public void createStartHere() {
		fc.getExtensionFilters().addAll(
			new ExtensionFilter("Excel", "*.html")
		);
			
			// 다이얼로그 띄우기
			File selectF = fc.showOpenDialog(primaryStage);
			
			selectedFile = selectF.getPath();
			
			Path searchDir = Paths.get(selectedFile);

			try {          
			    // xslt 실행하여 tags.xml 추출 하기
			    xsltExecute(searchDir);
	            
	        } catch(Exception e1) {
	            String msg = "예외가 발생되었습니다. 작업이 중지 됩니다.";
	            System.out.println(msg);
	            e1.printStackTrace();
	            selectedPopup(msg);
	            return;
	        }
			
			
			// 종료 팝업
			finishedPop();
	}
	
	public void createSearch() {
		fc.getExtensionFilters().addAll(
			new ExtensionFilter("Excel", "*.html")
		);
		
		// 다이얼로그 띄우기
		File selectF = fc.showOpenDialog(primaryStage);
		
		selectedFile = selectF.getPath();
		
		Path searchDir = Paths.get(selectedFile);
		
		try {	      
		    // xslt 실행하여 tags.xml 추출 하기
	        xsltExecute(searchDir);
	        
		} catch(Exception e1) {
            String msg = "예외가 발생되었습니다. 작업이 중지 됩니다.";
            System.out.println(msg);
            selectedPopup(msg);
            return;
		}

		// 종료 팝업
		finishedPop();
	}
	
	public void excelTxml() {
		// FileChooser 객체 생성
		
		// 파일 확장명으로 필터링 정보 추가
		fc.getExtensionFilters().addAll(
			new ExtensionFilter("Excel", "*.xlsx")
		);
		
		// 다이얼로그 띄우기
		File selectF = fc.showOpenDialog(primaryStage);
		
		selectedFile = selectF.getPath();
        srcDir = Paths.get(selectedFile).getParent();
        
        createTemp(srcDir);
        
		excelTxml et = new excelTxml(selectedFile);
		try {
//		    getsheet = "cross";
		    
		    List<String> getsheet = Arrays.asList("Cross", "tagsValue");
//			Path tarDir = et.runexcel(getsheet);
		    et.runexcel(getsheet);
//			System.out.println("hhh: " + excelTxml.crossF);
			// xslt 실행하여 tags.xml 추출 하기
			xsltExecute(excelTxml.crossF);

			// 작업 끝났으면 temp 폴더 삭제
//	`		System.out.println("fff: " + excelTxml.crossF.getParent());
			deleteTemp(excelTxml.crossF.getParent());
	        
		} catch (Exception e) {
		    String msg = "예외가 발생되었습니다. 작업이 중지 됩니다.";
		    System.out.println(msg);
		    selectedPopup(msg);
		    return;
		}
		
		// 종료 팝업
		finishedPop();
	}
	
	public void xsltExecute(Path tarDir) throws Exception {
	    System.out.println("xsltExecute 시작");
		System.out.println("tarDir: " + tarDir);
		System.out.println("jarPath: " + jarPath);
		executeOrder eo = new executeOrder(tarDir, jarPath, srcDir);		
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
            
        } catch(Exception e1) {
            
        }
    }
	
	// Temp 폴더 삭제/생성
	public static void createTemp(Path srcDir) {
	    Path tempPath = Paths.get(srcDir + File.separator + "temp");
	    
	    if(Files.exists(tempPath)) {
	        try {
	            deleteTemp(tempPath);  // 삭제 
	            Files.createDirectories(tempPath);  // 생성
	            
	        } catch(Exception e1) {
	            e1.getMessage();
	            e1.printStackTrace();
	        }
	    }
	}
	
	// temp 폴더내 재귀적 삭제
	public static void deleteTemp(Path toPath) throws Exception {
        DirectoryStream<Path> ds = Files.newDirectoryStream(toPath);

        ds.forEach(a -> {
            try {
                if (Files.isDirectory(a)) {
                    deleteTemp(a);

                } else {
                    Files.delete(a);
                }

            } catch (Exception e1) {
                e1.printStackTrace();
            }
            
        });
        Files.delete(toPath);
    }
	
	public void selectedPopup(String msg) {
        System.out.println("selectedPopup() 메소드 호출");
        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        // FXMLLoader.load() 메소드로 팝업 로드
        try {
            Parent parent = FXMLLoader.load(getClass().getResource("/main/fxml/selectedException.fxml"));
            parent.setStyle("-fx-background-color: ANTIQUEWHITE");
            //버튼 찾기 
            Button sebt = (Button) parent.lookup("#sebt");
            sebt.setOnAction(ev -> dg.close());
            
            // 라벨 컨트롤 찾기
            Label selb = (Label) parent.lookup("#seLabel");
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

}
