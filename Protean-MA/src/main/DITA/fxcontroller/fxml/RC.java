package main.DITA.fxcontroller.fxml;

import java.awt.Color;
import java.awt.Desktop;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URL;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Set;

import javax.imageio.ImageIO;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.environment.EnvironmentUtils;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.concurrent.Task;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Point2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.ComboBox;
import javafx.scene.control.ContextMenu;
import javafx.scene.control.Hyperlink;
import javafx.scene.control.Label;
import javafx.scene.control.MenuButton;
import javafx.scene.control.MenuItem;
import javafx.scene.control.ProgressBar;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.Clipboard;
import javafx.scene.input.ClipboardContent;
import javafx.scene.input.DragEvent;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.TransferMode;
import javafx.stage.DirectoryChooser;
import javafx.stage.FileChooser;
import javafx.stage.FileChooser.ExtensionFilter;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import main.DITA.Common.implementOBJ;
import main.DITA.excelController.dbFiles;
import main.DITA.excelController.excelTxml;
import main.DITA.excelController.tempHtml;
import main.DITA.imgController.getImgList;
import main.DITA.imgController.imgDBTxml;
import main.DITA.processBuilder.processBuilder2;
import main.DITA.readDATA.readLanguagesF;
import main.DITA.readDATA.readOptionF;
import main.DITA.runPublishing.commonPublishing;
import main.DITA.runPublishing.htmlPublishing;
import main.DITA.runPublishing.idmlPublishing;
import main.DITA.runPublishing.pdfPublishing;
import main.DITA.sourceController.ConvertPngBackground;
import main.DITA.sourceController.ZipDirectories;
import main.DITA.sourceController.convertImgTpng;
import main.DITA.sourceController.hyperLinkControl;
import main.DITA.sourceController.imageDelNCopy;
import main.DITA.sourceController.integratePV;
import main.DITA.sourceController.migrateTmx;
import main.DITA.sourceController.mmiExportUpdate;
import main.DITA.sourceController.pvEportUpdate;
import main.DITA.sourceController.tmxExportUpdate;
import main.DITA.sourceController.transformXSLT;
import main.DITA.sourceController.zipNunZipController;
import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.filters.Canvas;
import net.coobird.thumbnailator.geometry.Positions;



public class RC implements Initializable {
    @FXML private MenuButton mb1;
    @FXML private ComboBox<String> cb1;
	@FXML private ChoiceBox<String> cb2;
	@FXML private ChoiceBox<String> cb3;
	@FXML private ChoiceBox<String> cb4;
	
	@FXML private Button bt1;
	@FXML private Button bt2;
	@FXML private Button bt3;
	@FXML private Button bt4;
	@FXML private Button bt5;
	@FXML private Button bt6;
	@FXML private Button bt7;
	@FXML private Button bt8;
	@FXML private Button bt9;
	@FXML private Button bt10;
	@FXML private Button bt11;
	@FXML private Button bt12;
	@FXML private Button bt13;
	@FXML private Button bt14;
	@FXML private TextField tf1;
	@FXML private TextField tf2;
	@FXML private ProgressBar pb;
	@FXML private ContextMenu cm1;
	@FXML private ContextMenu cm2;
	@FXML private MenuItem mi1;
	@FXML private MenuItem mi2;
	@FXML private MenuItem mi3;
	@FXML private MenuItem mi5;
	@FXML private MenuItem mi6;
	@FXML private MenuItem mi7;
	@FXML private TextArea tta1;
	@FXML private Label iso;
	@FXML private Label lb2;
	
	implementOBJ obj = new implementOBJ();
	
	@FXML private Label inift;
	String projectDir = "";
	String libDir = "";
	String languagesF = "";
	String optionListF = "";
	String ditaotS= "";
	String filterS = "";
	String ditaxsls = "";
	String catalogDir = "";
	String zDirlib = "";
	String zDiridmlTempls = "";
	String zDirhtmlTempls = "";
	String pdfSetting = "";
	String DiridmlTempls = "";
	String mapPath = "";
	String pvPath = "";
	Path sMapDir = null;
	String gsDir = "";
	String jdkDir = "";
	String saxonDir = "";
	String newImagePathS = "";
	String outMapDir = "";
	String templateExcel = "";
	List<File> getFiles = new ArrayList<>();
	List<String> runList = new ArrayList<>();
	Map<String, String> selectItems = new HashMap<>();
	List<String> allSelectedList = new ArrayList<>();
	
	String strcb1 = "";
	String strcb2 = "";
	String strcb3 = "";
	String strcb4 = "";
	String strlb1 = "";
	String inF = "";
	String outF = "";
	String transtype = "";
	String ahfF = "";
	String switch1 = "";
	String msg = "";
	String idmlDirS = "";
	

	
	private Stage primaryStage;
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }


	@Override
	public void initialize(URL location, ResourceBundle resources) {		
		setDirectoryPath();
		readNsetdata();
		
		// checkbox 감시 하기
		// 로그 파일 생성
		createlogF();
		setStyleControl();
		
		// dita-ot integrator_plugins 실행
		runIntegrator();
		 
        bt1.setOnAction(e -> openDialog(tf1));
        bt2.setOnAction(e -> openDialog(tf2));
		
        batchWork(tf1);
        batchWork(tf2);
        
        
        // z 드라이브 연결하기
        String ahfF = "z:\\AHFormatter.exe";
        if(netIsAvailable(ahfF) == false) {
            connectAHF();
            System.out.println("connectAHF() 완료");
        }
        
        bt3.setOnAction(e -> workStartbt3(e));
        bt4.setOnAction(e -> workStartbt4(e));
        bt6.setOnAction(e -> workStartbt6(e));
        bt7.setOnAction(e -> workStartbt7(e));
        bt9.setOnAction(e -> workStartbt9(e));
        bt10.setOnAction(e -> workStartbt10(e));
        bt11.setOnAction(e -> workStartbt11(e));
        bt12.setOnAction(e -> workStartbt12());
        bt13.setOnAction(e -> workStartbt13(e));
        bt14.setOnAction(e -> workStartbt14(e));
        
        bt5.addEventHandler(MouseEvent.MOUSE_CLICKED, new EventHandler<MouseEvent>() {
            @Override
            public void handle(MouseEvent e) {
                if (e.getButton() == MouseButton.PRIMARY) {
                    cm1.show(bt5, e.getScreenX(), e.getScreenY());
                    mi1.setOnAction(e2 -> workStartMi1());
                    mi2.setOnAction(e2 -> workStartMi2());
                    mi3.setOnAction(e2 -> workStartMi3());

                } else {
                }
                
            }
        });
        
        bt8.addEventHandler(MouseEvent.MOUSE_CLICKED, new EventHandler<MouseEvent>() {
            @Override
            public void handle(MouseEvent e) {
                if (e.getButton() == MouseButton.PRIMARY) {
                    cm2.show(bt8, e.getScreenX(), e.getScreenY());
                    
                    mi6.setOnAction(e2 -> workStartMi6());
                    mi7.setOnAction(e2 -> workStartMi7());
                    
                } else {
                }
                
            }
        });

        inift.setOnMouseClicked(e -> programInitial());
	}
	
	public void workStartMi1() {
        int cnt = 0;
        startGetValues();
        
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            cnt = 1;
        } else {
            DisabledControl(); 
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            delOutDir(cp);
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        strcb1 = k;
                        strlb1 = v;
                        System.out.println("strlb1: " + strlb1);
                        
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            try {
                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                
                                // 새로 저장될 경로 설정
                                newImagePathS = outMapDir + File.separator + "tempImgDir" + File.separator + strlb1;
                                Path newImageP = Paths.get(newImagePathS); 
                                
                                if(Files.notExists(newImageP)) {
                                    Files.createDirectories(newImageP);
                                }

                                updateProgress(10, 100);
                                updateMessage(String.valueOf("newImagePathS 폴더 생성 후, 이미지 복사"));
                                
                                System.out.println("newImagePathS: " + newImagePathS);
                                Path newImagePathP = Paths.get(newImagePathS);
                                imgdelcopy.getImageinBasic(newImagePathP);
                                
                                updateProgress(20, 100);
                                updateMessage(String.valueOf("ai 파일 -> png로 변환"));
                                
                                convertImgTpng cip = new convertImgTpng(sMapDir, outMapDir, pvPath, strlb1, strcb1, newImagePathS);
                                cip.runImgTpng();
                                
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("png 이미지 배경색 채우기"));
                                String collectPngS = newImagePathS + File.separator + "out1";
                                ConvertPngBackground cpb = new ConvertPngBackground(collectPngS, outMapDir, strlb1);
                                cpb.forEachImg();
                                updateProgress(35, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(40, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                
                                // 새로 저장될 경로 설정
                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                System.out.println("newImagePathS: " + newImagePathS);
                                newImagePathP = Paths.get(newImagePathS);
                                imgdelcopy.getImageinBasic(newImagePathP);
                                
                                updateProgress(45, 100);
                                updateMessage(String.valueOf("z1-dita-merged 퍼플리싱 진행"));
                                
                                cp.runMerged(strcb1, strlb1);
                                
                                updateProgress(50, 100);
                                updateMessage(String.valueOf("z2-0-xslt-final-master 퍼플리싱 진행"));
                                
                                // 2. master.dita 생성
                                cp.runMaster();
                                
                                updateProgress(55, 100);
                                updateMessage(String.valueOf("z2-1-xslt-target 퍼플리싱 진행 중"));
                                
                                // 3. lang.dita 생성
                                cp.runTargetxsl();
                                
                                updateProgress(60, 100);
                                updateMessage(String.valueOf("z10-xslt-final-lang 퍼플리싱 진행 중"));
                                
                                // 4. final-lang 생성
                                cp.runFinalLangxsl();
                                
                                htmlPublishing htmlp = new htmlPublishing(sMapDir, outMapDir, pvPath, strlb1, strcb4);
                                // 1. z15-xslt-skeleton 생성
                                updateProgress(68, 100);
                                updateMessage(String.valueOf("z15-xslt-skeleton 퍼플리싱 진행 중"));
                                htmlp.runHtmlPublishing();
                                
                                
                                // 7. ExcelDB.xml 생성
                                updateProgress(75, 100);
                                updateMessage(String.valueOf("z17-xslt-exceldb 퍼플리싱 진행"));
                                htmlp.runExcelDB();
                                
                                // 8. ExcelDB.xml -> Excel 로 출력
                                updateProgress(80, 100);
                                updateMessage(String.valueOf("ExcelDB.xml -> Excel 로 출력"));
                                dbFiles db = new dbFiles(sMapDir, outMapDir, pvPath, strlb1);
                                db.runDbFiles();
                                
                            } catch(Exception e) {
                                msg = e.getMessage();
                                System.out.println("RC master 에러: " + msg);
                                throw new RuntimeException();
                            }
                            
                      
                        } else {
                            msg = "Z:\\DITA-OT-MA 폴더에 연결되어 있지 않습니다."; 
                            customException(msg);
                        }
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("ExcelDB / 이미지 생성 완료"));
                        
                    });
                    
                    return null;
                }
                
                
                @Override
                protected void succeeded() {
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    updateProgress(0, 100);
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


    }


	
	public void workStartMi2() {
        startGetValues();
        
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            customException(msg);
            
        } else {
            // 버튼 비활성화
            DisabledControl(); 
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        strcb1 = k;
                        strlb1 = v;
                        System.out.println("strlb1: " + strlb1);
                        
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            try {
                                String htmlDirS = outMapDir + File.separator + "3_HTML" + File.separator + strlb1;
                                String htmlPathS = htmlDirS;
                                System.out.println("htmlPathS: " + htmlPathS);
                                Path htmlPathP = Paths.get(htmlPathS); 
                                
                                // 폴더가 없다면 생성
                                if(Files.notExists(htmlPathP)) {
                                    try {
                                        Files.createDirectories(htmlPathP);
                                        
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }
                                }
                                
                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(10, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                System.out.println("newImagePathS: " + newImagePathS);
                                Path newImagePathP = Paths.get(newImagePathS);
                                imgdelcopy.getImageinBasic(newImagePathP);
                                
                                htmlPublishing htmlp = new htmlPublishing(sMapDir, outMapDir, pvPath, strlb1, strcb4);
                                htmlp.copyHtmlTempls();
                                
                                commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
                                cp.strcb1 = strcb1;
                                cp.strlb1 = strlb1;
                                cp.runMaster();
                             
                                // 1. z15-xslt-skeleton 생성
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("z15-xslt-skeleton 퍼플리싱 진행 중"));
                                htmlp.runHtmlPublishing();
                                
                                // 2. maHTML5 퍼블리싱
                                updateProgress(50, 100);
                                updateMessage(String.valueOf("z16-dita-html-publishing 퍼플리싱 진행 중"));
                                htmlp.runCreateHTML();
                                
                                // 3. excelTxml 생성
                                updateProgress(60, 100);
                                updateMessage(String.valueOf("excel to xml 변환"));
                                excelTxml exceltxml = new excelTxml(sMapDir, outMapDir, pvPath, strlb1);
                                
                                try {
                                    exceltxml.runexcel();
                                    
                                } catch (Exception e) {
                                    System.out.println("excelTxml 객체 호출 실패");
                                    e.printStackTrace();
                                }
                                
                                // 4. html 파일 출력 프로세스
                                updateProgress(70, 100);
                                updateMessage(String.valueOf("html 출력"));
                                htmlp.runHtmlConvert();
                                
                                updateProgress(70, 100);
                                updateMessage(String.valueOf("tags.xml 생성"));
                                htmlp.runTagsxml();
                                
                                updateProgress(70, 100);
                                updateMessage(String.valueOf("ui-text 생성"));
                                htmlp.runUiText();

                                String fromS = outMapDir + File.separator + strlb1 + "/contents/images";
                                Path from = Paths.get(fromS);
                                
                                String toS = outMapDir + File.separator + "3_HTML" + File.separator + strlb1 + "/contents/images";
                                Path to = Paths.get(toS);

                                obj.moveFiles(from, to);
                                

                            } catch(Exception e) {
                                msg = e.getMessage();
                                throw new RuntimeException();
                            }
                            
                      
                        } else {
                            msg = "Z:\\DITA-OT-MA 폴더에 연결되어 있지 않습니다."; 
                            customException(msg);
                        }
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("z03-pdf 퍼플리싱 완료"));
                        
                    });
                    
                    return null;
                }
                
                @Override
                protected void succeeded() {
                    Path path = Paths.get(outMapDir);
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    updateProgress(0, 100);
                }
                
                @Override
                protected void failed() {
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
        
    }
	
	
	
	public void workStartMi3() {
	    System.out.println("Mi3, 임시 html 변환");

	    // 버튼 비활성화
	    DisabledControl(); 
	    startGetValues();

        // 저장할 경로 열기
	    File selectedExcelF = selectDialog("엑셀 파일을 선택 하세요.");
	    
        if(!(selectedExcelF == null)) {
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    updateProgress(40, 100);
                    updateMessage(String.valueOf("엑셀 -> xml로 데이터 추출"));

                    tempHtml temphtml = new tempHtml(selectedExcelF);
                    String tempP = temphtml.runtemphtml();
                  
                    try {
                        transformXSLT tf = new transformXSLT(tempP);
                        tf.setList();
              
                    } catch (Exception e3) {
                        msg = e3.getMessage();
                        customException(msg);
                    }
                    
                    updateProgress(80, 100);
                    updateMessage(String.valueOf("zip 폴더로 변환"));
                    
                    zipNunZipController zip = new zipNunZipController(selectedExcelF);
                    String zipDirS = selectedExcelF.getParent() + File.separator + "D00_Html";
                    Path zipDirP = Paths.get(zipDirS);
                    zip.runZip(zipDirP);
                    
                    updateProgress(90, 100);
                    updateMessage(String.valueOf("temp 폴더 삭제"));
                    Path tempHtmlP = Paths.get(tempP);
                    
                    try {
                        obj.recursDel(tempHtmlP);
                    } catch (Exception e) {
                        msg = e.getMessage();
                        customException(msg);
                    }
                    
                    
                    
                    updateProgress(100, 100);
                    updateMessage(String.valueOf("zip 폴더 변환 완료"));
                    return null;
                }
                
                @Override
                protected void succeeded() {
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    updateProgress(0, 100);
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
	    
	    

	}
	
	
	public void workStartMi6() {
        startGetValues();

        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            
        } else {
            DisabledControl(); 
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            delOutDir(cp);
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        strcb1 = k;
                        strlb1 = v;
                        
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            try {
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));
                                
                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(40, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                System.out.println("newImagePathS: " + newImagePathS);
                                Path newImagePathP = Paths.get(newImagePathS);
                                imgdelcopy.getImageinBasic(newImagePathP);
                                
                                updateProgress(50, 100);
                                updateMessage(String.valueOf("z1-dita-merged 퍼플리싱 진행"));
                                cp.runMerged(strcb1, strlb1);
                                
                                updateProgress(70, 100);
                                updateMessage(String.valueOf("z2-0-xslt-final-master 퍼플리싱 진행"));
                                cp.runMaster();
                                
                                updateProgress(80, 100);
                                updateMessage(String.valueOf("z2-2-xslt-exportTR 퍼플리싱 진행 중"));
                                String keyword = "master";
                                mmiExportUpdate mmiexport = new mmiExportUpdate(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4, keyword);
                                mmiexport.runmmiExportxsl();
                                
                            } catch(Exception e) {
                                msg = e.getMessage();
                                System.out.println("RC master 에러: " + msg);
                                throw new RuntimeException();
                            }
                            
                      
                        } else {
                            msg = "Z:\\DITA-OT-MA 폴더에 연결되어 있지 않습니다."; 
                            customException(msg);
                        }
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("z03-pdf 퍼플리싱 완료"));
                        
                    });
                    
                    return null;
                }
                
                
                @Override
                protected void succeeded() {
                    Path path = Paths.get(outMapDir);
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    updateProgress(0, 100);
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

	}
	

	public void workStartMi7() {
        startGetValues();

        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            customException(msg);
            
        } else {
            DisabledControl(); 
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            delOutDir(cp);
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        strcb1 = k;
                        strlb1 = v;
                        
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            try {
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));

                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(40, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));

                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                System.out.println("newImagePathS: " + newImagePathS);
                                Path newImagePathP = Paths.get(newImagePathS);
                                imgdelcopy.getImageinBasic(newImagePathP);
                                
                                updateProgress(50, 100);
                                updateMessage(String.valueOf("z1-dita-merged 퍼플리싱 진행"));
                                
                                cp.runMerged(strcb1, strlb1);
                                
                                updateProgress(60, 100);
                                updateMessage(String.valueOf("z2-0-xslt-final-master 퍼플리싱 진행"));
                                
                                cp.runMaster();
                                
                                // 3. lang.dita 생성
                                updateProgress(70, 100);
                                updateMessage(String.valueOf("z2-1-xslt-target 퍼플리싱 진행 중"));
                                cp.runTargetxsl();
                                
                                // 4. TR-export 생성                            
                                updateProgress(80, 100);
                                updateMessage(String.valueOf("z2-2-xslt-exportTR 퍼플리싱 진행 중"));
                                pvEportUpdate pvexport = new pvEportUpdate(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                pvexport.runExportxsl();
                                                               
                                // 5. 차분 mmi export
                                String keyword = "TR";
                                mmiExportUpdate mmiexport = new mmiExportUpdate(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4, keyword);
                                mmiexport.runmmiExportxsl();

                            } catch(Exception e) {
                                msg = e.getMessage();
                                System.out.println("RC master 에러: " + msg);
                                throw new RuntimeException();
                            }
                            
                      
                        } else {
                            msg = "Z:\\DITA-OT-MA 폴더에 연결되어 있지 않습니다."; 
                            customException(msg);
                        }
                        
                        System.out.println("완료!!");
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("z03-pdf 퍼플리싱 완료"));
                        
                    });
                    
                    return null;
                }
                
                
                @Override
                protected void succeeded() {
                    Path path = Paths.get(outMapDir);

                    completePopup();
                    activateControl();
                    updateProgress(0, 100);
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

	}

	
	public void createlogF() {
	    String logF = obj.projectDir + File.separator + "error-log.xml";
	    System.out.println("logF: " + logF);
	    Path logP = Paths.get(logF);
	    
	    if(!Files.exists(logP)) {
	        try {
                Files.createFile(logP);
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
	        
	    } else {
	        try {
	            Files.delete(logP);
	            Files.createFile(logP);
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
	        
	    }
	    
	}
	
	public void workStartbt3(ActionEvent e) {
        startGetValues();

        // ditamap 파일이 비어 있다면 예외창 출력
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            customException(msg);
            
        } else {
            DisabledControl(); 
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            delOutDir(cp);
             
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        strcb1 = k;
                        strlb1 = v;
                        
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            try {
                                updateProgress(10, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));
                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(20, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                
                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                System.out.println("newImagePathS: " + newImagePathS);
                                Path newImagePathP = Paths.get(newImagePathS);
                                imgdelcopy.getImageinBasic(newImagePathP);
                                
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("z1-dita-merged 퍼플리싱 진행"));
                            	
                            	// 1. PROJECT.xml 생성
                                cp.runMerged(strcb1, strlb1);
                                
                                updateProgress(50, 100);
                                updateMessage(String.valueOf("z2-0-xslt-final-master 퍼플리싱 진행"));
                            	
                            	// 2. master.dita 생성
                                cp.runMaster();

                                if(strlb1.equals("en-GB")| 
                                   strlb1.equals("en-CN")|
                                   strlb1.equals("en-TW")) {
                                	
                                	updateProgress(80, 100);
                                    updateMessage(String.valueOf("z3-dita-outPDF 퍼플리싱 진행"));
                                    
                                	pdfPublishing engPDF = new pdfPublishing(); 
                                	engPDF.runCreateEngPDF(outMapDir, strlb1);
                                    
                                } else if(!strlb1.equals("en-GB")| 
                                           strlb1.equals("en-CN")|
                                           strlb1.equals("en-TW")) {

                                	updateProgress(60, 100);
                                    updateMessage(String.valueOf("z2-1-xslt-target 퍼플리싱 진행 중"));
                                    
                                    // 3. lang.dita 생성
                                    cp.runTargetxsl();
                                    
                                    updateProgress(70, 100);
                                    updateMessage(String.valueOf("z10-xslt-final-lang 퍼플리싱 진행 중"));
                                    
                                    // 4. final-lang 생성
                                    cp.runFinalLangxsl();
                                    
                                    updateProgress(80, 100);
                                    updateMessage(String.valueOf("z10-xslt-final-lang 퍼플리싱 진행 중"));
                                    
                                    // 5. eng PDF 퍼블리싱
                                    pdfPublishing multiPDF = new pdfPublishing(); 
                                    multiPDF.runCreateMultiPDF(outMapDir, strlb1);
                                    
                                }
                                
                                String pdfPath = "";
                                
                                if(strlb1.equals("en-GB")| 
                                   strlb1.equals("en-CN")|
                                   strlb1.equals("en-TW")) {
                                	pdfPath = outMapDir + File.separator + "master-final.pdf";
                                	
                                } else {
                                	pdfPath = outMapDir + File.separator + "final-" + strlb1 + ".pdf";
                                }
                                	
                                updateProgress(90, 100);
                                updateMessage(String.valueOf("링크 반전 제거"));
                                
                                hyperLinkControl hyperLink = new hyperLinkControl(pdfPath); 
                        		hyperLink.accessLink();
                                
                                updateProgress(95, 100);
                                updateMessage(String.valueOf("1_PDF 폴더로 이동"));
                                
                                cp.finishMovePDF(pdfPath);
                                
                            } catch(Exception e) {
                            	msg = e.getMessage();
                            	throw new RuntimeException(msg);
                            }
                            
                      
                        } else {
                            msg = "Z:\\DITA-OT-MA 폴더에 연결되어 있지 않습니다."; 
                            customException(msg);
                        }
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("z03-pdf 퍼플리싱 완료"));
                        
                    });
                    
                    return null;
                }
                
                @Override
                protected void succeeded() {
                    Path path = Paths.get(outMapDir);
                    completePopup();
                    activateControl();
                    updateProgress(0, 100);
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
	}
	
	public void workStartbt4(ActionEvent e) {
        startGetValues();
        
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            
        } else {
            DisabledControl(); 
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            delOutDir(cp);
            
            ahfF = "z:\\AHFormatter.exe";
            switch1 = "dita";
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        strcb1 = k;
                        strlb1 = v;
                        
                        if(netIsAvailable(ahfF) == true) {
                            updateProgress(10, 100);
                            updateMessage(String.valueOf("out 경로 생성 완료"));

                            idmlDirS =  outMapDir + File.separator + "2_IDML" + File.separator + strlb1;
                            Path idmlDirP = Paths.get(idmlDirS); 
                            try {
                                obj.createNewDir(idmlDirP);
    
                            } catch (Exception e1) {
                                e1.printStackTrace();
                            }
                            
                            updateProgress(10, 100);
                            updateMessage(String.valueOf("탬플릿 폴더 복사"));
    
                            imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                            imgdelcopy.copyidmlTemplates();
                            
                            updateProgress(20, 100);
                            updateMessage(String.valueOf("이미지 파일 복사"));
                            
                            Path newImagePathP = imgdelcopy.copyImgTidml();
                            imgdelcopy.getImageinBasic(newImagePathP);
                            imgdelcopy.copyChapterImg();
                            
                            updateProgress(30, 100);
                            updateMessage(String.valueOf("image_size.xml 생성"));
                            
                            newImagePathS = outMapDir + File.separator + "2_IDML" + File.separator + strlb1 + File.separator + "images";
                            newImagePathP = Paths.get(newImagePathS);
                            getImgList gil = new getImgList(newImagePathP);
                            gil.runGetImgList();
                            Map<String, List<String>> imgMap = gil.getMapCollection();
                            imgDBTxml imgdbTxml = new imgDBTxml(imgMap, outMapDir);
                            imgdbTxml.runimgDBTxml();

                            imgdelcopy.delImageinBasic();
                            updateProgress(35, 100);
                            updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));

                            newImagePathS = sMapDir + File.separator + "BASIC/images";
                            System.out.println("newImagePathS: " + newImagePathS);
                            newImagePathP = Paths.get(newImagePathS);
                            imgdelcopy.getImageinBasic(newImagePathP);

                            updateProgress(40, 100);
                            updateMessage(String.valueOf("z1-dita-merged 퍼플리싱 진행"));

                            cp.runMerged(strcb1, strlb1);
                            
                            updateProgress(50, 100);
                            updateMessage(String.valueOf("z2-0-xslt-final-master 퍼플리싱 진행"));
                            
                            cp.runMaster();
                            updateProgress(60, 100);
                            updateMessage(String.valueOf("z2-1-xslt-target 퍼플리싱 진행 중"));
                            cp.runTargetxsl();

                            updateProgress(70, 100);
                            updateMessage(String.valueOf("z10-xslt-final-lang 퍼플리싱 진행 중"));
                            cp.runFinalLangxsl();
                            
                            updateProgress(80, 100);
                            updateMessage(String.valueOf("z4-xslt-idml-publishing 퍼플리싱 진행 중"));
                            idmlPublishing idmlp = new idmlPublishing(outMapDir, strlb1);
                            idmlp.runIdmlPublishing();
                            
                            updateProgress(90, 100);
                            updateMessage(String.valueOf("idml 폴더를 zip 확장자로 압축"));

                            String idmlout = outMapDir + File.separator + "idmlTemp/idmlout";
                            ZipDirectories zd = new ZipDirectories();
                            try {
                                List<Path> zipDir = zd.collectDirs(idmlout);
                                zd.zipDirectory(zipDir);
                                zd.changeNdel(idmlout);
                                
                                // 변환된 idml 파일을 2_IDML 폴더로 복사
                                String newIdmlS = outMapDir + File.separator + "2_IDML" + File.separator + strlb1;
                                idmlp.copyIdml(idmlout, newIdmlS);

                            } catch (Exception e) {
                                msg = "idml 폴더를 zip을 압축 실패";
                                System.out.println(msg);
                                customException(msg);
                            }
                          

                        }
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("idml 변환 완료"));
                        
                        
                    });
                    

                    return null;
                }
                
                @Override
                protected void succeeded() {
                    Path path = Paths.get(outMapDir);
                    completePopup();
                    activateControl();
                    updateProgress(0, 100);
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

    }
	
	public void workStartbt6(ActionEvent e) {
        startGetValues();

        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            customException(msg);
            
        } else {
            DisabledControl();
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            delOutDir(cp);
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        strcb1 = k;
                        strlb1 = v;
                        
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            try {
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));

                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(40, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                
                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                Path newImagePathP = Paths.get(newImagePathS);
                                imgdelcopy.getImageinBasic(newImagePathP);
                                
                                updateProgress(50, 100);
                                updateMessage(String.valueOf("z1-dita-merged 퍼플리싱 진행"));
                                
                                // 1. PROJECT.xml 생성
                                cp.runMerged(strcb1, strlb1);
                                
                                updateProgress(70, 100);
                                updateMessage(String.valueOf("z2-0-xslt-final-master 퍼플리싱 진행"));
                                
                                // 2. master.dita 생성
                                cp.runMaster();
                                
                                updateProgress(80, 100);
                                updateMessage(String.valueOf("z2-1-xslt-target 퍼플리싱 진행 중"));
                                
                                // 3. lang.dita 생성
                                cp.runTargetxsl();
                                
                                updateProgress(90, 100);
                                updateMessage(String.valueOf("z2-2-xslt-exportTR 퍼플리싱 진행 중"));
                                
                                // 4. TR-export 생성
                                pvEportUpdate pvexport = new pvEportUpdate(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                pvexport.runExportxsl();
                                
                            } catch(Exception e) {
                                msg = e.getMessage();
                                throw new RuntimeException();
                            }
                            
                      
                        } else {
                            msg = "Z:\\DITA-OT-MA 폴더에 연결되어 있지 않습니다."; 
                            customException(msg);
                        }
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("번역 추출 완료"));
                        
                    });
                    
                    return null;
                }
                
                
                @Override
                protected void succeeded() {
                    Path path = Paths.get(outMapDir);
                    completePopup();
                    activateControl();
                    updateProgress(0, 100);
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

	}
	
	
	public void workStartbt7(ActionEvent e) {
        DisabledControl(); 
        startGetValues();
        File selectedDir = pvUpdateDialog("업데이트 할 pv파일이 있는 폴더를 선택 하세요.");
        
        if(!(selectedDir == null)) {
        	Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    updateProgress(50, 100);
                    updateMessage(String.valueOf("z5-xslt-pvUpdate 퍼플리싱 진행 중"));
                    
                    String getDate = obj.getDateTime();
                    String newPvPath = selectedDir + File.separator + "pv_" + getDate + ".xml";
                    String newPvTemp = selectedDir + File.separator + "temp";
                    Path newPvTemP = Paths.get(newPvTemp);
                    
                    if(Files.notExists(newPvTemP)) {
                        try {
                            Files.createDirectories(newPvTemP);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                    
                    pvEportUpdate pvupdate = new pvEportUpdate(selectedDir, pvPath, newPvPath);
                    pvupdate.runPvUpdate();

                    try {
                        obj.recursDel(newPvTemP);
                    } catch (Exception e) {
                        msg = e.getMessage();
                        customException(msg);
                    }
                    
                    updateProgress(100, 100);
                    updateMessage(String.valueOf("pv 업데이트 완료"));
                    
                    return null;
                }
                
                @Override
                protected void succeeded() {
                    completePopup();
                    activateControl();
                    updateProgress(0, 100);
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

	}

	public void workStartbt9(ActionEvent e) {
        startGetValues();
        
        if(pvPath.contains("z:")) {
            msg = "pv 경로를 입력 해주세요.";
            customException(msg);
            
        } else {
            DisabledControl(); 
            File selectedDir = pvUpdateDialog("업데이트 할 mmi 파일이 있는 폴더를 선택하세요.");
            
            if(!(selectedDir == null)) {
                Task<Void> task2 = new Task<Void>() {
                    @Override
                    protected Void call() {
                        updateProgress(50, 100);
                        updateMessage(String.valueOf("mmi 업데이트 시작"));
                        
                        String getDate = obj.getDateTime();
                        String newPvPath = selectedDir + File.separator + "pv_" + getDate + ".xml";
                                       
                        mmiExportUpdate mmiupdate = new mmiExportUpdate(selectedDir, pvPath, newPvPath);
                        mmiupdate.runmmiUpdate();
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("mmi 업데이트 완료"));
                        return null;
                    }
                    
                    @Override
                    protected void succeeded() {
                        Path path = Paths.get(outMapDir);
                        completePopup();
                        activateControl();
                        updateProgress(0, 100);
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
            
        }

    }
	

	public void workStartbt10(ActionEvent e) {
        startGetValues();
        
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            customException(msg);
            
        } else {
            DisabledControl(); 
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            delOutDir(cp);
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        strcb1 = k;
                        strlb1 = v;
                        
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            try {
                                updateProgress(20, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));

                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                
                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                System.out.println("newImagePathS: " + newImagePathS);
                                Path newImagePathP = Paths.get(newImagePathS);
                                imgdelcopy.getImageinBasic(newImagePathP);
                                
                                updateProgress(40, 100);
                                updateMessage(String.valueOf("z1-dita-merged 퍼플리싱 진행"));
                                
                                // 1. PROJECT.xml 생성
                                cp.runMerged(strcb1, strlb1);
                                
                                updateProgress(50, 100);
                                updateMessage(String.valueOf("z2-0-xslt-final-master 퍼플리싱 진행"));
                                
                                // 2. master.dita 생성
                                cp.runMaster();
                                
                                updateProgress(60, 100);
                                updateMessage(String.valueOf("z2-1-xslt-target 퍼플리싱 진행 중"));
                                
                                // 3. lang.dita 생성
                                cp.runTargetxsl();
                                
                                updateProgress(70, 100);
                                updateMessage(String.valueOf("z10-xslt-final-lang 퍼플리싱 진행 중"));
                                
                                // 4. final-lang 생성
                                cp.runFinalLangxsl();
                                
                                updateProgress(80, 100);
                                updateMessage(String.valueOf("z11-xslt-create-tmx 퍼플리싱 진행 중"));
                                
                                // 5. txm export 생성
                                tmxExportUpdate tmxexport = new tmxExportUpdate(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                tmxexport.runtmxExport();
                                

                            } catch(Exception e) {
                                msg = e.getMessage();
                                throw new RuntimeException();
                            }
                            
                      
                        } else {
                            msg = "Z:\\DITA-OT-MA 폴더에 연결되어 있지 않습니다."; 
                            customException(msg);
                        }
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("번역 추출 완료"));
                        
                    });
                    
                    return null;
                }
                
                
                @Override
                protected void succeeded() {
                    Path path = Paths.get(outMapDir);
                    completePopup();
                    activateControl();
                    updateProgress(0, 100);
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

    }

	
	public void workStartbt11(ActionEvent e) {
        selectItems.remove("언어선택");
        startGetValues();
        
        System.out.println("pvPath: " + pvPath);
        
        if(sMapDir == null) {
            msg = "pv 및 ditamap 경로를 입력 해주세요.";
            customException(msg);
            
        } else {
            DisabledControl();
            File selectedtmxF = selectDialog("업데이트 할 tmx파일을 선택 하세요.");
            
            if(!(selectedtmxF == null)) {
                Task<Void> task2 = new Task<Void>() {
                    @Override
                    protected Void call() {
                        updateProgress(50, 100);
                        updateMessage(String.valueOf("reviewed 추출 중"));
                        
                        tmxExportUpdate tmxupdate = new tmxExportUpdate(sMapDir, outMapDir, pvPath, strlb1, strcb1, selectedtmxF);
                        tmxupdate.runtmxUpdate();
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("reviewed 추출 완료"));
                        
                        return null;
                    }
                    
                    
                    @Override
                    protected void succeeded() {
                        Path path = Paths.get(outMapDir);
                        completePopup();
                        activateControl();
                        updateProgress(0, 100);
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
            
        }
        
    }
	
	
	
	public void workStartbt12() {
	    List<String> runList = new ArrayList<>();
	    
	    Task<Void> task2 = new Task<Void>() {
	        @Override
	        protected Void call() {
	            DefaultExecutor exec = new DefaultExecutor();
	            exec.setExitValue(2);
	            
	            String exeDir = libDir + File.separator + "idml2dita";
	            File exeDirF = new File(exeDir);

	            exec.setWorkingDirectory(exeDirF);
	           
	            String runListS = libDir + File.separator + "idml2dita/idml2dita.exe";
	            File ff = new File(runListS);
	            
	            try {
	                Map<String, String> env = EnvironmentUtils.getProcEnvironment();
	 
	                runList.add(runListS);
	                
	                CommandLine cmd = new CommandLine("cmd.exe");                
	                cmd.addArgument("/c");

	                String command = ff.getAbsolutePath();
	                cmd.addArgument(command);
	                cmd.addArgument("");
	                

	                try {
	                    int exitValue = exec.execute(cmd, env);
	                    
	                } catch(Exception e3) {
	                    e3.printStackTrace();
	                    
	                }
	                
	            } catch (Exception e2) {
	                msg = "idml to dita 변환 프로그램 열기 실행 실패";
	                customException(msg);
	            }
	                           
	            return null;
	        
	        }

	    };
	    
	    Thread thread2 = new Thread(task2);
	    thread2.setDaemon(true);
	    thread2.start();
	    
	}
	

	
	public void workStartbt13(ActionEvent e) {
        startGetValues();
        File selectedDir = pvUpdateDialog("마이그래이션 할 tmx 파일이 위치한 폴더를 선택 하세요.");
        
        
        if(!(selectedDir == null)) {
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    DisabledControl(); 
                    
                    updateProgress(50, 100);
                    updateMessage(String.valueOf("마이그래이션 진행중"));
                    
                    migrateTmx migratetmx = new migrateTmx(selectedDir);                     
                    migratetmx.runMigrateTmx();
                    
                    updateProgress(100, 100);
                    updateMessage(String.valueOf("마이그래이션 완료"));
                    
                    return null;
                }
                
                
                @Override
                protected void succeeded() {
                    completePopup();
                    activateControl();
                    updateProgress(0, 100);
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

    }


	
	public void workStartbt14(ActionEvent e) {
        startGetValues();
        File selectedDir = pvUpdateDialog("통합할 pv 파일이 있는 폴더를 선택하세요.");
        
        
        if(!(selectedDir == null)) {
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    DisabledControl(); 
                    
                    updateProgress(100, 100);
                    updateMessage(String.valueOf("pv 통합 진행"));
                    String getDate = obj.getDateTime();
                    String newPvPath = selectedDir + File.separator + "pv_" + getDate + ".xml";
                    integratePV integratepv = new integratePV(selectedDir, pvPath, newPvPath);
                    integratepv.runPvUpdate();
                    
                    String tempDirS = selectedDir + File.separator + "interateTemp";
                    Path tempDirP = Paths.get(tempDirS);
                    
                    try {
                        obj.recursDel(tempDirP);
                    } catch (Exception e) {
                        msg = e.getMessage();
                        customException(msg);
                    }
                    
                    updateProgress(100, 100);
                    updateMessage(String.valueOf("pv 통합 완료"));
                    
                    return null;
                }
                
                
                @Override
                protected void succeeded() {
                    completePopup();
                    activateControl();
                    updateProgress(0, 100);
                }
                
                @Override
                protected void failed() {
                    System.out.println("failed(): " + msg);
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

    }

	
	public void connectAHF() {
		String command = "c:\\windows\\system32\\net.exe use Z: \\\\10.10.10.222\\Antenna-House\\AHFormatterV71 /user:facc ast141#";
		try {
			Process p = Runtime.getRuntime().exec(command);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	public boolean netIsAvailable(String path) {
	    File file = new File(path);
        
	    
	    boolean result = false;
        
	    if(file.exists()) {
	        result = true;
	        
	    } else {
	        result = false;
	    }
        
	    return result;
	}
	
	
	
	
	public void startGetValues() {
		mapPath = tf1.getText();
        System.out.println("mapPath: " + mapPath);
        // 소스 경로 추출
        Path srcDirP = Paths.get(mapPath); 
        sMapDir = srcDirP.getParent();
        
        // out 경로 생성
        outMapDir = sMapDir + File.separator + "out";
         
        // pv 경로 얻기
        pvPath = tf2.getText();
        if(pvPath.equals("") | pvPath == null) {
            pvPath = obj.ditaxsls + File.separator + "pv.xml";
            
        } 
        
        // 목록으로 부터 값 얻기
        strcb2 = cb2.getSelectionModel().getSelectedItem();
        strcb3 = cb3.getSelectionModel().getSelectedItem();
        strcb4 = cb4.getSelectionModel().getSelectedItem();

	}
	
	public void DisabledControl() {
	    cb1.setDisable(true);
        cb2.setDisable(true);
        cb3.setDisable(true);
        cb4.setDisable(true);
//        cb5.setDisable(true);
        bt1.setDisable(true);
        bt2.setDisable(true);
        bt3.setDisable(true);
        bt4.setDisable(true);
        bt5.setDisable(true);
        bt6.setDisable(true);
        bt7.setDisable(true);
        bt8.setDisable(true);
        bt9.setDisable(true);
        bt10.setDisable(true);
        bt11.setDisable(true);
        bt12.setDisable(true);
        bt13.setDisable(true);
        bt14.setDisable(true);
        tf1.setDisable(true);
        tf2.setDisable(true);
        tta1.setDisable(true);
        iso.setDisable(true);
        
    }
	
	public void activateControl() {
	    cb1.setDisable(false);
        cb2.setDisable(false);
        cb3.setDisable(false);
        cb4.setDisable(false);
//        cb5.setDisable(false);
        bt1.setDisable(false);
        bt2.setDisable(false);
        bt3.setDisable(false);
        bt4.setDisable(false);
        bt5.setDisable(false);
        bt6.setDisable(false);
        bt7.setDisable(false);
        bt8.setDisable(false);
        bt9.setDisable(false);
        bt10.setDisable(false);
        bt11.setDisable(false);
        bt12.setDisable(false);
        bt13.setDisable(false);
        bt14.setDisable(false);
        tf1.setDisable(false);
        tf2.setDisable(false);
        tta1.setDisable(false);
        iso.setDisable(false);
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
    
    public void dragDrop(DragEvent e, TextField tf) {
        boolean success = false;
        
        if(e.getGestureSource() != tf && e.getDragboard().hasFiles()) {
            getFiles = e.getDragboard().getFiles();
            
            // 디렉토리는 삭제
            getFiles.removeIf(a -> a.isDirectory());
            
            // 파일의 절대 경로 추출
            String getParentPath = getFiles.get(0).getAbsolutePath();
            
            if(tf.getId().equals("tf1")) {
            	mapPath = getParentPath;
                tf.setText(mapPath);
                
            } else if(tf.getId().equals("tf2")) {
                pvPath = getParentPath;
                tf.setText(pvPath);
                
            }
            
            success = true;
        }
        
        e.setDropCompleted(success);
        e.consume();
    }
    
    
    public void dragExit(DragEvent e, TextField tf) {
        tf.setStyle("-fx-background-color: #ffc0cb;");
    } 
    
    public void customException(String msg) {
        tf1.setText("");
        tf2.setText("");
        
        selectItems.clear();
        allSelectedList.clear();
        cb1.getSelectionModel().select("언어선택");
        
        sMapDir = null;
        outMapDir = "";
        pvPath = "";
        strlb1 = ""; 
        strcb1 = ""; 
        strcb2 = "";
        strcb3 = ""; 
        strcb4 = "";

        tta1.clear();
        errorPopup(msg);
        
    }
	
	
	public void setDirectoryPath() {
		File file = new File("");
		projectDir = file.getAbsolutePath();
		obj.projectDir = projectDir;
		libDir = projectDir + File.separator + "lib";
		obj.libDir = libDir; 
		
		optionListF = libDir + File.separator + "fxOptionList.xml";
		obj.optionListF = optionListF; 
        zDirlib = "z:\\lib\\MA";
        obj.zDirlib = zDirlib;
        ditaotS = libDir + File.separator + "DITA-OT-MA";
        obj.ditaotS = ditaotS; 
		filterS = ditaotS + File.separator + "_filter"; 
		obj.filterS = filterS;
		ditaxsls = zDirlib + File.separator + "xsls";
		obj.ditaxsls = ditaxsls;
		languagesF = ditaotS + File.separator + "plugins/com.ast.protean.ma.um_en_2020pdf/cfg/common" + File.separator + "languages.xml";
        obj.languagesF = languagesF; 
        catalogDir = ditaotS + File.separator + "catalog-dita.xml";
        obj.catalogDir = catalogDir;
        zDiridmlTempls = zDirlib + File.separator + "idml-templates/templates";
        obj.zDiridmlTempls = zDiridmlTempls; 
        DiridmlTempls = libDir + File.separator + "idml-template/template";
        obj.DiridmlTempls = DiridmlTempls;
        pdfSetting = ditaotS + File.separator + "pdf-settings";
        obj.pdfSetting = pdfSetting; 
        jdkDir = projectDir + File.separator + "jre";
        obj.jdkDir = jdkDir; 
        saxonDir = zDirlib + File.separator + "saxon";
        obj.saxonDir = saxonDir;
        gsDir = libDir + File.separator + "gs9.56.1/bin/gswin64c.exe";
        obj.gsDir = gsDir;
        templateExcel = ditaxsls + File.separator + "htmlExcelDB/skeleton.xlsx";
        obj.templateExcel = templateExcel; 
        zDirhtmlTempls = zDirlib + File.separator + "html-templates";
        obj.zDirhtmlTempls = zDirhtmlTempls; 
        
	}
	
	public void readNsetdata() {
		System.out.println("readNsetdata() 시작");
		
		// option 파일 읽기
		readOptionF rof = new readOptionF();
		rof.runReadOptionF();
		
		readLanguagesF rlf = new readLanguagesF();
		rlf.runReadLanguagesF();
		
		setListItems();
	}
	
	@SuppressWarnings("unchecked")
	public void setListItems() {
		cb2.setItems(FXCollections.observableArrayList(obj.templateList));
		cb2.getSelectionModel().selectFirst(); 

		cb3.setItems(FXCollections.observableArrayList(obj.htmlList));
		cb3.getSelectionModel().selectFirst();
		
		// prodtype 목록 채우기
		cb4.setItems(FXCollections.observableArrayList(obj.prodList));
		cb4.getSelectionModel().selectFirst(); 
		
		
		int pos = 0;
		Set<Map.Entry<String, String>> entryset = obj.langMap.entrySet();
		Iterator <Map.Entry<String, String>> it = entryset.iterator();
		
		List<String> englang = new ArrayList<>();
		List<String> multilang = new ArrayList<>();
		List<String> totallang = new ArrayList<>();
		
		while (it.hasNext()) {
		    Map.Entry<String, String> entry = it.next();
		    String keys = entry.getKey();
		    String vals = entry.getValue();

		    if(keys.contains("English-EU")) {
		        englang.add(0, "언어선택");
		    	englang.add(1, keys);
		    	pos++;
		    } 
		    
		    else if(keys.contains("English")) {
		    	englang.add(pos, keys);
		    	pos++;
		    } 
		    
		    else if(!keys.contains("English")) {
		    	multilang.add(keys);
		    }
		    
		}
		
		totallang.addAll(englang); 
		multilang.sort(Comparator.naturalOrder());
		totallang.addAll(multilang);

		cb1.setItems(FXCollections.observableArrayList(totallang));
		cb1.getSelectionModel().selectedItemProperty().addListener(new ChangeListener<String>() {
			@Override
			public void changed(ObservableValue<? extends String> observable, String oldValue, String newValue) {
				iso.setText(obj.langMap.get(newValue));
		        Clipboard clipboard = Clipboard.getSystemClipboard();
		        ClipboardContent content = new ClipboardContent();
		        content.putString(iso.getText());
		        clipboard.setContent(content); 
                allSelectedList.add(newValue);
                selectItems.put(newValue, obj.langMap.get(newValue));
                
                if(allSelectedList.size() == 5) {
                    cb1.setDisable(true);
                }
                selectItems.remove("언어선택");
                allSelectedList.remove("언어선택");
                String[] strarr = allSelectedList.toArray(new String[0]);
                
                tta1.setText(String.join("\n", strarr));
				    
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

		if(selectedFile != null) {
			if(tf.getId().equals("tf1")) {
				mapPath = selectedFile.getPath();
				tf1.setText(mapPath);
				
			} else if(tf.getId().equals("tf2")) {
				if(!tf.isDisable()) {
					pvPath = selectedFile.getPath();
					tf2.setText(pvPath);
				}
				
			}
		}
		
	}
	
	public File pvUpdateDialog(String titleTxt) {
		DirectoryChooser dc = new DirectoryChooser();
	    dc.setTitle(titleTxt);
	    File selectedDir = null;
		try {
			selectedDir = dc.showDialog(primaryStage);
			
			System.out.println("selectedDir: " + selectedDir);
		    
		    if (selectedDir == null) {
		        msg = "저장 폴더가 지정되지 않았습니다.";
            	System.out.println(msg);
            	customException(msg);
            	
		    }
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return selectedDir;
		
	}
	
	public File selectDialog(String titleTxt) {
        FileChooser fc = new FileChooser();
        
        fc.setTitle(titleTxt);
        
        fc.getExtensionFilters().addAll(
            new ExtensionFilter("all Files", "*.tmx;*.xlsx")
        );
        
        File selectedFile = null;
        try {
            selectedFile = fc.showOpenDialog(primaryStage);
            
            System.out.println("selectedFile: " + selectedFile);
            
            if (selectedFile == null) {
                msg = "파일이 선택되지 않았습니다.";
                System.out.println(msg);
                customException(msg);
                
            }
            
        } catch(Exception e) {
            msg = "파일이 선택되지 않았습니다.";
            System.out.println(msg);
            customException(msg);
        }
        
        
        return selectedFile;
        
    }
	
	
	
	
	public void DelFinalTempDir(Path path, String strlb1) {
	    try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                String getName = a.getFileName().toString();
                
                if(Files.isDirectory(a)) {
                    if(!getName.matches("(1_PDF|2_IDML|3_HTML|4_TR|5_MMI|convertTMX|ExcelDB|html-temp)")) {
                        DelFinalTempDir(a, strlb1);
                        
                        try {
                            Files.delete(a);
                        } catch (IOException e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                        }
                    }
                    
                    
                } else {
                    if(!getName.matches("(04-reviewed-TMX.tmx|templateInfo.xml)")) {
                        try {
                            Files.delete(a);
                            
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                    
                }
                
            });

        } catch(Exception e) {
            e.printStackTrace();
        }
	    
	    
	}
	
	public void errorPopup(String msg) {
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);

        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/DITA/fxcontroller/fxml/verError.fxml"));
            Button sebt = (Button) parent.lookup("#errBt");
            sebt.setOnAction(ev -> dg.close());
            Label selb = (Label) parent.lookup("#errLb1");
            selb.setWrapText(true);
            selb.setText(msg);

            Hyperlink hy = (Hyperlink) parent.lookup("#hylink");
            Label loglb = (Label) parent.lookup("#loglb");
            if(msg.contains("errorTxt")) {
                String outF = obj.projectDir + File.separator + "error-log.xml";
                String outF2 = outF.replace("\\", "/");
                
                try {
                    hy.setText(outF);
                    loglb.setText("로그 열기: ");
                    hy.setOnAction(a -> {
                        try {
                            Desktop.getDesktop().browse(new URI(outF2));
                        } catch (Exception e) {
                            e.printStackTrace();

                        } 
                    });
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            
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
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/DITA/fxcontroller/fxml/completePopup.fxml"));
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
	
	public void setStyleControl() {
	    lb2.setStyle("-fx-font-family: Arial Rounded MT Bold;");
	    lb2.setStyle("-fx-font-size: 11");
	    
	    tta1.setStyle("-fx-font-family: Arial Rounded MT Bold;");
	    tta1.setStyle("-fx-font-size: 10");
	    
	    cb1.setStyle("-fx-font-family: Arial Rounded MT Bold;");
	    cb1.setStyle("-fx-font-size: 12.5");
	    cb2.setStyle("-fx-font-family: Arial Rounded MT Bold;");
	    cb2.setStyle("-fx-font-size: 12.5");
	    cb3.setStyle("-fx-font-family: Arial Rounded MT Bold;");
	    cb3.setStyle("-fx-font-size: 12.5");
	    cb4.setStyle("-fx-font-family: Arial Rounded MT Bold;");
	    cb4.setStyle("-fx-font-size: 12.5");
	}
	
	public void runIntegrator() {
        List<String> runList = new ArrayList<>();
        String integrateF = "call " + obj.ditaotS + "/bin/ant " +  " -f " + obj.ditaotS + "/integrator.xml";

        runList.add(integrateF);
        String switch1 = "Integra";
        processBuilder2 exeExcute = new processBuilder2(runList, switch1);
        exeExcute.runProcessBuilder();

    }
	
	
	public void delOutDir(commonPublishing cp) {
	    try {
	        Path outmapdir = Paths.get(outMapDir);
	        
	        if(Files.notExists(outmapdir)) {
	            try {
	                Files.createDirectories(outmapdir);
	                
	            } catch (IOException e) {
	                msg = "out 폴더 삭제 실패, 다른 프로그램이 out 폴더를 사용하고 있습니다.";
	                throw new RuntimeException(msg);
	            }
	        }
	        
	    } catch (Exception e1) {
	        msg = "out 폴더 삭제 실패, 다른 프로그램이 out 폴더를 사용하고 있습니다.";
	        throw new RuntimeException(msg);
	        
	    }
	    
	}
	
	public void programInitial() {
	    tf1.setText("");
        tf2.setText("");
        
        selectItems.clear();
        allSelectedList.clear();
        cb1.getSelectionModel().select("언어선택");
        
        sMapDir = null;
        outMapDir = "";
        pvPath = "";
        strlb1 = ""; 
        strcb1 = ""; 
        strcb2 = "";
        strcb3 = ""; 
        strcb4 = "";

        tta1.clear();
        activateControl();
	}
	
	
}
