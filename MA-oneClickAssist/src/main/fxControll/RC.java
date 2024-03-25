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
 	FileChooser fc = new FileChooser();
 	DirectoryChooser dc = new DirectoryChooser();
    public static File jarPath = new File("").getAbsoluteFile();
    
    
	@Override
	public void initialize(URL location, ResourceBundle resources) {
		tags.setOnAction(e -> excelTxml());
		newContents.setOnAction(e -> createNewContents());
		search.setDisable(true);
		startHere.setDisable(true);
	}
	
	public void createNewContents() {
	    File selectedDir = dc.showDialog(primaryStage);
	    Path srcDir = Paths.get(selectedDir.toString());
	    
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
		
		File selectF = fc.showOpenDialog(primaryStage);
		selectedFile = selectF.getPath();
		Path searchDir = Paths.get(selectedFile);
		
		try {	      
	        xsltExecute(searchDir);
	        
		} catch(Exception e1) {
            String msg = "예외가 발생되었습니다. 작업이 중지 됩니다.";
            selectedPopup(msg);
            return;
		}

		// 종료 팝업
		finishedPop();
	}
	
	public void excelTxml() {
		fc.getExtensionFilters().addAll(
			new ExtensionFilter("Excel", "*.xlsx")
		);
		
		File selectF = fc.showOpenDialog(primaryStage);
		selectedFile = selectF.getPath();
        srcDir = Paths.get(selectedFile).getParent();
        
        createTemp(srcDir);
        
		excelTxml et = new excelTxml(selectedFile);
		try {
		    List<String> getsheet = Arrays.asList("Cross", "tagsValue");
		    et.runexcel(getsheet);
			xsltExecute(excelTxml.crossF);

			// 작업 끝났으면 temp 폴더 삭제
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
		executeOrder eo = new executeOrder(tarDir, jarPath, srcDir);		
		eo.setList();
	}
	
	public void finishedPop() {
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        dg.setTitle("작업이 완료 되었습니다.");
        
        try {
            Parent parent = FXMLLoader.load(getClass().getResource("/main/fxml/finishPopup.fxml"));
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
	            deleteTemp(tempPath); 
	            Files.createDirectories(tempPath);
	            
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
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        try {
            Parent parent = FXMLLoader.load(getClass().getResource("/main/fxml/selectedException.fxml"));
            parent.setStyle("-fx-background-color: ANTIQUEWHITE");
            Button sebt = (Button) parent.lookup("#sebt");
            sebt.setOnAction(ev -> dg.close());
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
