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
//	CheckMenuItem cc = new CheckMenuItem();
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
	
	// **** start 버튼 클릭시 UI로 부터 값 얻기 시작 ****
	String strcb1 = "";
	String strcb2 = "";
	String strcb3 = "";
	String strcb4 = "";
	String strlb1 = "";
	// **** start 버튼 클릭시 UI로 부터 값 얻기 끝 ****
	
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
		// TODO Auto-generated method stub
		
		// 초기 디렉토리 설정
		setDirectoryPath();
		
		// 파일 읽어 데이터 가져오기, 데이터 삽입 하기
		readNsetdata();
		
		// checkbox 감시 하기
//		getCheckbox();
		
		// 로그 파일 생성
		createlogF();
		
		// 컨트롤 버튼 스타일 지정
		setStyleControl();
		
		// dita-ot integrator_plugins 실행
		runIntegrator();
		
		// 다이얼로그로 파일 선택 
        bt1.setOnAction(e -> openDialog(tf1));
        bt2.setOnAction(e -> openDialog(tf2));
		
        // 파일을 드래그 오버 방식
        batchWork(tf1);
        batchWork(tf2);
        
        
        // z 드라이브 연결하기
        String ahfF = "z:\\AHFormatter.exe";
        if(netIsAvailable(ahfF) == false) {
            connectAHF();
            System.out.println("connectAHF() 완료");
        }
        
        
        // PDF 출력 프로세스 실행
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
                    mi1.setOnAction(e2 -> workStartMi1());  // Mi1, ExcelDB / 이미지 생성
                    mi2.setOnAction(e2 -> workStartMi2());  // 전체 html 변환
                    mi3.setOnAction(e2 -> workStartMi3());  // 이미지만 변환

                } else {
                    System.out.println("오른쪽 버튼 클릭 금지");
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
                    System.out.println("오른쪽 버튼 클릭 금지");
                }
                
            }
        });

        
        // 언어설정 텍스트 필드 클릭시 초기화 하기
        inift.setOnMouseClicked(e -> programInitial());
	}
	
	public void workStartMi1() {
        System.out.println("Mi1, ExcelDB / 이미지 생성");
        int cnt = 0;
        // 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();
        
        // ditamap 파일이 비어 있다면 예외창 출력
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            cnt = 1;
        } else {
            // 버튼 비활성화
            DisabledControl(); 
            
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            
            // out 삭제 및 생성
            delOutDir(cp);
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        // 언어 출력
                        strcb1 = k;
                        System.out.println("strcb1: " + strcb1);
                        
                        // 언어 코드 출력
                        strlb1 = v;
                        System.out.println("strlb1: " + strlb1);
                        
                        // z01-dita-merge.bat 돌리기
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            try {
                                // BASIC/image 폴더내 ai, png 파일 지우기
                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                
                                // BASIC 폴더내 image 폴더로 부터 언어별 이미지 추출하기
                                // 새로 저장될 경로 설정
                                newImagePathS = outMapDir + File.separator + "tempImgDir" + File.separator + strlb1;
                                Path newImageP = Paths.get(newImagePathS); 
                                
                                // 폴더가 없다면 생성
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
                                
                                // newImagePathS 이미지 폴더 반복하여 ai 파일들을 png로 변환
                                convertImgTpng cip = new convertImgTpng(sMapDir, outMapDir, pvPath, strlb1, strcb1, newImagePathS);
                                cip.runImgTpng();
                                
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("png 이미지 배경색 채우기"));
                                
                                // png로 모은 디렉토리newImagePathS
                                String collectPngS = newImagePathS + File.separator + "out1";
                                
                                // png 의 투명한 배경색을 흰색으로 변경하기
                                
//                                String collectPngS = "C:/Users/SMC/Desktop/IMAGE/HTML/LTN/out/tempImgDir/en-AR/out1";
                                ConvertPngBackground cpb = new ConvertPngBackground(collectPngS, outMapDir, strlb1);
                                cpb.forEachImg();

                                // BASIC/image 폴더내 ai, png 파일 지우기
                                updateProgress(35, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(40, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                // BASIC 폴더내 image 폴더로 부터 언어별 이미지 추출하기
                                
                                // 새로 저장될 경로 설정
                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                System.out.println("newImagePathS: " + newImagePathS);
                                newImagePathP = Paths.get(newImagePathS);
                                imgdelcopy.getImageinBasic(newImagePathP);
                                
                                updateProgress(45, 100);
                                updateMessage(String.valueOf("z1-dita-merged 퍼플리싱 진행"));
                                
                                // 1. PROJECT.xml 생성
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
//                                htmlPublishing htmlp = new htmlPublishing(sMapDir, outMapDir, pvPath, strlb1);
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
                        
                        System.out.println("완료!!");
                        
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
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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


    }


	
	public void workStartMi2() {
        System.out.println("mi2()시작, html 변환");
        
        // 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();
        
        // ditamap 파일이 비어 있다면 예외창 출력
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            
        } else {
            // 버튼 비활성화
            DisabledControl(); 
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        // 언어 출력
                        strcb1 = k;
                        System.out.println("strcb1: " + strcb1);
                        
                        // 언어 코드 출력
                        strlb1 = v;
                        System.out.println("strlb1: " + strlb1);
                        
                        // z01-dita-merge.bat 돌리기
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            try {
                                // 3_HTML 폴더 생성
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
                                
                                // BASIC/image 폴더내 ai, png 파일 지우기
                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(10, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                
                                // BASIC 폴더내 image 폴더로 부터 언어별 이미지 추출하기
                                // 새로 저장될 경로 설정
                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                System.out.println("newImagePathS: " + newImagePathS);
                                Path newImagePathP = Paths.get(newImagePathS);
                                imgdelcopy.getImageinBasic(newImagePathP);
                                
                                htmlPublishing htmlp = new htmlPublishing(sMapDir, outMapDir, pvPath, strlb1, strcb4);
                                // 이미지 및 탬플릿 파일 복사
                                htmlp.copyHtmlTempls();
                                
                                commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
                                // 2. master.dita 생성
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
                                
                                
//                                htmlPublishing htmlp = new htmlPublishing(sMapDir, outMapDir, pvPath, strlb1);
                                // 4. html 파일 출력 프로세스
                                updateProgress(70, 100);
                                updateMessage(String.valueOf("html 출력"));
                                htmlp.runHtmlConvert();
                                

                                // tags.xml 생성하기
//                                htmlPublishing htmlp = new htmlPublishing(sMapDir, outMapDir, pvPath, strlb1);
                                updateProgress(70, 100);
                                updateMessage(String.valueOf("tags.xml 생성"));
                                htmlp.runTagsxml();
                                
                                
                                // ui-text 생성하기
                                updateProgress(70, 100);
                                updateMessage(String.valueOf("ui-text 생성"));
                                htmlp.runUiText();

                                // 이미지 이동
                                String fromS = outMapDir + File.separator + strlb1 + "/contents/images";
                                Path from = Paths.get(fromS);
                                
                                String toS = outMapDir + File.separator + "3_HTML" + File.separator + strlb1 + "/contents/images";
                                Path to = Paths.get(toS);

                                obj.moveFiles(from, to);
                                

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
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 마무리 폴더 삭제
                    Path path = Paths.get(outMapDir);
//                    path = Paths.get("H:/DITA/Mobile/Bat/mobile-source/out");
//                    DelFinalTempDir(path, strlb1);
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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
        
    }
	
	
	
	public void workStartMi3() {
	    System.out.println("Mi3, 임시 html 변환");

	    // 버튼 비활성화
	    DisabledControl(); 
	    
	    // 시작 선택시 선택된 목록 고정값으로 사용하기
	    startGetValues();

        // 저장할 경로 열기
	    File selectedExcelF = selectDialog("엑셀 파일을 선택 하세요.");
//        String selectedExcelF = "aaa";
        if(!(selectedExcelF == null)) {
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    updateProgress(40, 100);
                    updateMessage(String.valueOf("엑셀 -> xml로 데이터 추출"));
                    
                    // 엑셀 파일 읽어, xml로 데이터 추출
                    tempHtml temphtml = new tempHtml(selectedExcelF);
                    String tempP = temphtml.runtemphtml();
                  
//                    String tempP = "C:/Users/SMC/Desktop/IMAGE/tempHTML/temp-html";
                    try {
                        transformXSLT tf = new transformXSLT(tempP);
                        tf.setList();
              
                    } catch (Exception e3) {
                        msg = e3.getMessage();
                        customException(msg);
                    }
                    
                    // 각 폴더별 zip 파일 만들기
                    updateProgress(80, 100);
                    updateMessage(String.valueOf("zip 폴더로 변환"));
                    
                    
//                    String tempP = "C:/Users/SMC/Desktop/IMAGE/testdita/excel";
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
//                        e.printStackTrace();
                    }
                    
                    
                    
                    updateProgress(100, 100);
                    updateMessage(String.valueOf("zip 폴더 변환 완료"));
                    return null;
                }
                
                @Override
                protected void succeeded() {
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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
	    
	    

	}
	
	
	public void workStartMi6() {
		System.out.println("mi6()시작, 모든 MMI 추출");
		
		// 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();

        // ditamap 파일이 비어 있다면 예외창 출력
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            
        } else {
            // 버튼 비활성화
            DisabledControl(); 
            
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            
            // out 삭제 및 생성
            delOutDir(cp);
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        // 언어 출력
                        strcb1 = k;
                        
                        // 언어 코드 출력
                        strlb1 = v;
                        
                        // z01-dita-merge.bat 돌리기
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            try {
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));
                                
                                // BASIC/image 폴더내 ai, png 파일 지우기
                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(40, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                // BASIC 폴더내 image 폴더로 부터 언어별 이미지 추출하기
                                
                                // 새로 저장될 경로 설정
                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                System.out.println("newImagePathS: " + newImagePathS);
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
                                updateMessage(String.valueOf("z2-2-xslt-exportTR 퍼플리싱 진행 중"));
                                
                                // 3. mmi export
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
                        
                        System.out.println("완료!!");
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("z03-pdf 퍼플리싱 완료"));
                        
                    });
                    
                    return null;
                }
                
                
                @Override
                protected void succeeded() {
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 마무리 폴더 삭제
                    Path path = Paths.get(outMapDir);
//                    DelFinalTempDir(path);
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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

	}
	

	public void workStartMi7() {
		System.out.println("mi7()시작, 차분 MMI 추출");
		
		// 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();

        // ditamap 파일이 비어 있다면 예외창 출력
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            
        } else {
            // 버튼 비활성화
            DisabledControl(); 
            
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            
            // out 삭제 및 생성
            delOutDir(cp);
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        // 언어 출력
                        strcb1 = k;
                        
                        // 언어 코드 출력
                        strlb1 = v;
                        
                        // z01-dita-merge.bat 돌리기
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            try {
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));

                                // BASIC/image 폴더내 ai, png 파일 지우기
                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(40, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                // 새로 저장될 경로 설정, BASIC 폴더내 image 폴더로 부터 언어별 이미지 추출하기
                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                System.out.println("newImagePathS: " + newImagePathS);
                                Path newImagePathP = Paths.get(newImagePathS);
                                imgdelcopy.getImageinBasic(newImagePathP);
                                
                                updateProgress(50, 100);
                                updateMessage(String.valueOf("z1-dita-merged 퍼플리싱 진행"));
                                
                                // 1. PROJECT.xml 생성
                                cp.runMerged(strcb1, strlb1);
                                
                                updateProgress(60, 100);
                                updateMessage(String.valueOf("z2-0-xslt-final-master 퍼플리싱 진행"));
                                
                                // 2. master.dita 생성
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
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 마무리 폴더 삭제
                    Path path = Paths.get(outMapDir);
//                    DelFinalTempDir(path);
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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

	}

	
	public void createlogF() {
	    System.out.println("createlogF() 시작");
	    
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
		System.out.println("bt3, pdf 변환 시작");

        // 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();

        // ditamap 파일이 비어 있다면 예외창 출력
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            
        } else {
            // 버튼 비활성화
            DisabledControl(); 
            
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
         
            // out 삭제 및 생성
            delOutDir(cp);
             
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        // 언어 출력
                        strcb1 = k;
                        
                        // 언어 코드 출력
                        strlb1 = v;
                        
                        // z01-dita-merge.bat 돌리기
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            try {
                            	System.out.println("strcb1: " + strcb1);
                                System.out.println("strlb1: " + strlb1);                                
                                
                                updateProgress(10, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));
    
                                // BASIC/image 폴더내 ai, png 파일 지우기
                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(20, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                
                                // 새로 저장될 경로 설정, BASIC 폴더내 image 폴더로 부터 언어별 이미지 추출하기
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
                                	System.out.println("영문 PDF 생성!!!");
                                	
                                	updateProgress(80, 100);
                                    updateMessage(String.valueOf("z3-dita-outPDF 퍼플리싱 진행"));
                                    
                                	// 3. eng PDF 퍼블리싱
                                	pdfPublishing engPDF = new pdfPublishing(); 
                                	engPDF.runCreateEngPDF(outMapDir, strlb1);
                                    
                                } else if(!strlb1.equals("en-GB")| 
                                           strlb1.equals("en-CN")|
                                           strlb1.equals("en-TW")) {
                                	System.out.println("다국어 PDF 생성!!!");

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
                                
                                // 1_PDF 폴더 생성 및 이동
                                cp.finishMovePDF(pdfPath);
                                
                            } catch(Exception e) {
                            	msg = e.getMessage();
                            	System.out.println("RC master 에러: " + msg);
                            	throw new RuntimeException(msg);
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
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 마무리 폴더 삭제
                    Path path = Paths.get(outMapDir);
//                    DelFinalTempDir(path);
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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
	}
	
	public void workStartbt4(ActionEvent e) {
        System.out.println("bt4, IDML 출력 시작");
        
        // 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();
        
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            
        } else {
            // 버튼 비활성화
            DisabledControl(); 
            
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            
            // out 삭제 및 생성
            delOutDir(cp);
            
            ahfF = "z:\\AHFormatter.exe";
            switch1 = "dita";
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        // 언어 출력
                        strcb1 = k;
                        
                        // 언어 코드 출력
                        strlb1 = v;
                        
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            
                            updateProgress(10, 100);
                            updateMessage(String.valueOf("out 경로 생성 완료"));
                            
                            // idml 파일 저장 경로 설정
                            // out 폴더내 2_IDML 폴더 생성
                            idmlDirS =  outMapDir + File.separator + "2_IDML" + File.separator + strlb1;
                            Path idmlDirP = Paths.get(idmlDirS); 
                            try {
                                // idml 저장 경로 생성
                                obj.createNewDir(idmlDirP);
    
                            } catch (Exception e1) {
                                e1.printStackTrace();
                            }
                            
                            updateProgress(10, 100);
                            updateMessage(String.valueOf("탬플릿 폴더 복사"));
    
                            // 템플릿 폴더 복사 및 삭제
                            imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                            imgdelcopy.copyidmlTemplates();
                            
                            updateProgress(20, 100);
                            updateMessage(String.valueOf("이미지 파일 복사"));
                            
                            // 이미지 파일을 2_IDML 폴더내로 복사
                            Path newImagePathP = imgdelcopy.copyImgTidml();
                            
                            // 이미지 파일 복사
                            imgdelcopy.getImageinBasic(newImagePathP);
                            
                            // chapter 이미지 복사
                            imgdelcopy.copyChapterImg();
                            
                            updateProgress(30, 100);
                            updateMessage(String.valueOf("image_size.xml 생성"));
                            
                            // image_size.xml 파일 만들기
                            // 이미지 폴더내 모든 이미지를추출
                            newImagePathS = outMapDir + File.separator + "2_IDML" + File.separator + strlb1 + File.separator + "images";
                            newImagePathP = Paths.get(newImagePathS);
                            getImgList gil = new getImgList(newImagePathP);
                            gil.runGetImgList();
                            
                            // 이미지 정보를 map 컬렉션으로 모음
                            Map<String, List<String>> imgMap = gil.getMapCollection();
                            
                            // image_size.xml 파일로 추출
                            imgDBTxml imgdbTxml = new imgDBTxml(imgMap, outMapDir);
                            imgdbTxml.runimgDBTxml();
                            

                            // BASIC/image 폴더내 ai, png 파일 지우기
                            imgdelcopy.delImageinBasic();
                            updateProgress(35, 100);
                            updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));

                            // 새로 저장될 경로 설정, BASIC 폴더내 image 폴더로 부터 언어별 이미지 추출하기
                            newImagePathS = sMapDir + File.separator + "BASIC/images";
                            System.out.println("newImagePathS: " + newImagePathS);
                            newImagePathP = Paths.get(newImagePathS);
                            imgdelcopy.getImageinBasic(newImagePathP);

                            updateProgress(40, 100);
                            updateMessage(String.valueOf("z1-dita-merged 퍼플리싱 진행"));

                            // PROJECT.xml 생성
                            cp.runMerged(strcb1, strlb1);
                            
                            updateProgress(50, 100);
                            updateMessage(String.valueOf("z2-0-xslt-final-master 퍼플리싱 진행"));
                            
                            // master.dita 생성
                            cp.runMaster();
                            
                            // lang.dita 생성
                            updateProgress(60, 100);
                            updateMessage(String.valueOf("z2-1-xslt-target 퍼플리싱 진행 중"));
                            cp.runTargetxsl();
                            
                            // 4. final-lang 생성
                            updateProgress(70, 100);
                            updateMessage(String.valueOf("z10-xslt-final-lang 퍼플리싱 진행 중"));
                            cp.runFinalLangxsl();
                            
                            
                            // 5. idmlpublishing 진행 
                            updateProgress(80, 100);
                            updateMessage(String.valueOf("z4-xslt-idml-publishing 퍼플리싱 진행 중"));
                            idmlPublishing idmlp = new idmlPublishing(outMapDir, strlb1);
                            idmlp.runIdmlPublishing();
                            
                            updateProgress(90, 100);
                            updateMessage(String.valueOf("idml 폴더를 zip 확장자로 압축"));
                            

                            // idml 폴더를 zip 확장자로 압축 하기
                            String idmlout = outMapDir + File.separator + "idmlTemp/idmlout";
                            ZipDirectories zd = new ZipDirectories();
                            try {
                                List<Path> zipDir = zd.collectDirs(idmlout);
                                
                                // idml 폴더를 모아 zip으로 압축 하기
                                zd.zipDirectory(zipDir);
                                
                                // zip 확장자를 idml로 변경 하기
                                zd.changeNdel(idmlout);
                                
                                // 변환된 idml 파일을 2_IDML 폴더로 복사
//                                idmlPublishing idmlp = new idmlPublishing(outMapDir);
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
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 마무리 폴더 삭제
                    Path path = Paths.get(outMapDir);
//                    DelFinalTempDir(path);
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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

    }
	
	public void workStartbt6(ActionEvent e) {
		System.out.println("bt6, TR-export 시작");
		
		// 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();

        // ditamap 파일이 비어 있다면 예외창 출력
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            
        } else {
            // 버튼 비활성화
            DisabledControl();
            
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            
            // out 삭제 및 생성
            delOutDir(cp);
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        // 언어 출력
                        strcb1 = k;
                        
                        // 언어 코드 출력
                        strlb1 = v;
                        
                        // z01-dita-merge.bat 돌리기
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            try {
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));

                                // BASIC/image 폴더내 ai, png 파일 지우기
                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(40, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                
                                // 새로 저장될 경로 설정, BASIC 폴더내 image 폴더로 부터 언어별 이미지 추출하기
                                newImagePathS = sMapDir + File.separator + "BASIC/images";
                                System.out.println("newImagePathS: " + newImagePathS);
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
                                System.out.println("RC master 에러: " + msg);
                                throw new RuntimeException();
                            }
                            
                      
                        } else {
                            msg = "Z:\\DITA-OT-MA 폴더에 연결되어 있지 않습니다."; 
                            customException(msg);
                        }
                        
                        System.out.println("완료!!");
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("번역 추출 완료"));
                        
                    });
                    
                    return null;
                }
                
                
                @Override
                protected void succeeded() {
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 마무리 폴더 삭제
                    Path path = Paths.get(outMapDir);
//                    DelFinalTempDir(path);
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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

	}
	
	
	public void workStartbt7(ActionEvent e) {
		System.out.println("bt7, pv업데이트 시작");

		// 버튼 비활성화
        DisabledControl(); 
        
        // 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();

    	// 저장할 경로 열기
        File selectedDir = pvUpdateDialog("업데이트 할 pv파일이 있는 폴더를 선택 하세요.");
        
        if(!(selectedDir == null)) {
        	Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    System.out.println("pvPath: " + pvPath);
                	
                    if(pvPath.toLowerCase().startsWith("z:")) {
                    	System.out.println("pv 파일이 지정되지 않았습니다. 신규 TR 파일(pv.xml)을 생성합니다.");
                    	
                    } else {
                    	System.out.println("지정된 pv 파일에 번역을 업데이트 합니다.");
                    	
                    }
                    updateProgress(50, 100);
                    updateMessage(String.valueOf("z5-xslt-pvUpdate 퍼플리싱 진행 중"));
                    
                    // 새롭게 저장될 pv 파일 지정
                    String getDate = obj.getDateTime();
                    String newPvPath = selectedDir + File.separator + "pv_" + getDate + ".xml";
//                    System.out.println("newPvPath: " + newPvPath);
                                
                    
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
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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

	}

	public void workStartbt9(ActionEvent e) {
        System.out.println("bt9() 시작, mmi 업데이트");

        // 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();
        System.out.println("pvPath: " + pvPath);
        
        if(pvPath.contains("z:")) {
            msg = "pv 경로를 입력 해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            
        } else {
            // 버튼 비활성화
            DisabledControl(); 
            
            // 저장할 경로 열기
            File selectedDir = pvUpdateDialog("업데이트 할 mmi 파일이 있는 폴더를 선택하세요.");
            
            if(!(selectedDir == null)) {
                Task<Void> task2 = new Task<Void>() {
                    @Override
                    protected Void call() {
                        System.out.println("pvPath: " + pvPath);
                        
                        updateProgress(50, 100);
                        updateMessage(String.valueOf("mmi 업데이트 시작"));
                        
                        // 새롭게 저장될 pv 파일 지정
                        String getDate = obj.getDateTime();
                        String newPvPath = selectedDir + File.separator + "pv_" + getDate + ".xml";
//                        System.out.println("newPvPath: " + newPvPath);
                                       
                        mmiExportUpdate mmiupdate = new mmiExportUpdate(selectedDir, pvPath, newPvPath);
                        mmiupdate.runmmiUpdate();
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("mmi 업데이트 완료"));
                        return null;
                    }
                    
                    @Override
                    protected void succeeded() {
                        System.out.println("succeeded(): 최종 완료");
                        
                        // 마무리 폴더 삭제
                        Path path = Paths.get(outMapDir);
//                        DelFinalTempDir(path);
                        
                        // 작업 완료 팝업창
                        completePopup();
                        activateControl();
                        
                        // Progressbar 초기 상태로 변경
                        updateProgress(0, 100);
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
            
        }

    }
	

	public void workStartbt10(ActionEvent e) {
        System.out.println("bt10, 검토용 tmx 추출 시작");
        
        // 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();

        // ditamap 파일이 비어 있다면 예외창 출력
        if(sMapDir == null | selectItems.size() == 0) {
            msg = "ditamap 경로를 입력해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            
        } else {
            // 버튼 비활성화
            DisabledControl(); 
            
            commonPublishing cp = new commonPublishing(sMapDir, outMapDir, pvPath, strcb2, strcb3, strcb4);
            
            // out 삭제 및 생성
            delOutDir(cp);
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    selectItems.forEach((k, v) -> {
                        // 언어 출력
                        strcb1 = k;
                        
                        // 언어 코드 출력
                        strlb1 = v;
                        
                        // z01-dita-merge.bat 돌리기
                        // Z:\DITA-OT-MA 폴더가 있는지 확인
                        ahfF = "z:\\AHFormatter.exe";
                        switch1 = "dita";
                        if(netIsAvailable(ahfF) == true) {
                            System.out.println("Z:\\DITA-OT-MA 폴더 존재");
                            try {
                                updateProgress(20, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 삭제"));

                                // BASIC/image 폴더내 ai, png 파일 지우기
                                imageDelNCopy imgdelcopy = new imageDelNCopy(sMapDir, outMapDir, pvPath, strlb1, strcb1, strcb2, strcb3, strcb4);
                                imgdelcopy.delImageinBasic();
                                
                                updateProgress(30, 100);
                                updateMessage(String.valueOf("BASIC/images 이미지 파일 복사"));
                                // BASIC 폴더내 image 폴더로 부터 언어별 이미지 추출하기
                                
                                // 새로 저장될 경로 설정
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
                                System.out.println("RC master 에러: " + msg);
                                throw new RuntimeException();
                            }
                            
                      
                        } else {
                            msg = "Z:\\DITA-OT-MA 폴더에 연결되어 있지 않습니다."; 
                            customException(msg);
                        }
                        
                        System.out.println("완료!!");
                        
                        updateProgress(100, 100);
                        updateMessage(String.valueOf("번역 추출 완료"));
                        
                    });
                    
                    return null;
                }
                
                
                @Override
                protected void succeeded() {
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 마무리 폴더 삭제
                    Path path = Paths.get(outMapDir);
//                    DelFinalTempDir(path);
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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

    }

	
	public void workStartbt11(ActionEvent e) {
        System.out.println("bt11, sar & tar 추출 시작");
        selectItems.remove("언어선택");
        
        // 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();
        
        System.out.println("pvPath: " + pvPath);
        
//        Path sMapDir = Paths.get("H:/DITA/Mobile/Bat/mobile-source/PROJECT.ditamap");
        if(sMapDir == null) {
            msg = "pv 및 ditamap 경로를 입력 해주세요.";
            System.out.println("msg: " + msg);
            customException(msg);
            
        } else {
            // 버튼 비활성화
            DisabledControl();
            
            // 저장할 경로 열기
            File selectedtmxF = selectDialog("업데이트 할 tmx파일을 선택 하세요.");
            
            if(!(selectedtmxF == null)) {
                Task<Void> task2 = new Task<Void>() {
                    @Override
                    protected Void call() {
                        System.out.println("pvPath: " + pvPath);
                     
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
                        System.out.println("succeeded(): 최종 완료");
                        
                        // 마무리 폴더 삭제
                        Path path = Paths.get(outMapDir);
//                        DelFinalTempDir(path);
                        
                        // 작업 완료 팝업창
                        completePopup();
                        activateControl();
                        
                        // Progressbar 초기 상태로 변경
                        updateProgress(0, 100);
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
            
        }
        
    }
	
	
	
	public void workStartbt12() {
	    System.out.println("bt12, idml to dita 변환 프로그램 열기");
	    List<String> runList = new ArrayList<>();
	    
	    Task<Void> task2 = new Task<Void>() {
	        @Override
	        protected Void call() {
	            DefaultExecutor exec = new DefaultExecutor();
	            exec.setExitValue(2);
	            
	            String exeDir = libDir + File.separator + "idml2dita";
//	                String exeDir = "H:\\JAVA\\java-workspace\\Protean-MA\\lib\\idml2dita\\";
	            File exeDirF = new File(exeDir);
	            
	            // exe 프로그램 실행 하기 위해 현재 위치를 exe 파일이 있는 위치로 이동
	            // 현재 위치를 이동 시키지 않을 경우, exe 프로그램 실행은 되나, 동작이 되지 않음
	            // 그렇기 때문에, 실행위치를 변경해 주었음
	            exec.setWorkingDirectory(exeDirF);
	           
	            String runListS = libDir + File.separator + "idml2dita/idml2dita.exe";
	            File ff = new File(runListS);
	            
	            try {
	                // 환경 변수 설정
	                Map<String, String> env = EnvironmentUtils.getProcEnvironment();
	 
	                runList.add(runListS);
	                
	                System.out.println("console command: " + runList);
	                CommandLine cmd = new CommandLine("cmd.exe");                
	                cmd.addArgument("/c");

	                String command = ff.getAbsolutePath();
	                cmd.addArgument(command);
	                cmd.addArgument("");
	                

	                try {
	                    // execute() 메소드를 호출하여, 명령어및 환경 변수를 매개변수로 할당
	                    int exitValue = exec.execute(cmd, env);
	                    System.out.println("exitValue : " + exitValue);
	                    
	                } catch(Exception e3) {
	                    e3.printStackTrace();
	                    
	                }
	                
	            } catch (Exception e2) {
	                msg = "idml to dita 변환 프로그램 열기 실행 실패";
	                System.out.println(msg);
//	                    throw new RuntimeException(msg);
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
        System.out.println("bt13, tmx 마이그래이션 시작");

        // 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();

        // 저장할 경로 열기
        File selectedDir = pvUpdateDialog("마이그래이션 할 tmx 파일이 위치한 폴더를 선택 하세요.");
        
        
        if(!(selectedDir == null)) {
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    // 버튼 비활성화
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
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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

    }


	
	public void workStartbt14(ActionEvent e) {
        System.out.println("bt14() 시작, pv 통합하기");

        // 시작 선택시 선택된 목록 고정값으로 사용하기
        startGetValues();

        // 저장할 경로 열기
        File selectedDir = pvUpdateDialog("통합할 pv 파일이 있는 폴더를 선택하세요.");
        
        
        if(!(selectedDir == null)) {
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    // 버튼 비활성화
                    DisabledControl(); 
                    
                    updateProgress(100, 100);
                    updateMessage(String.valueOf("pv 통합 진행"));

                    // 새롭게 저장될 pv 파일 지정
                    String getDate = obj.getDateTime();
                    String newPvPath = selectedDir + File.separator + "pv_" + getDate + ".xml";
//                    System.out.println("newPvPath: " + newPvPath);
                                   
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
                    System.out.println("succeeded(): 최종 완료");
                    
                    // 작업 완료 팝업창
                    completePopup();
                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);
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

    }

	
	public void connectAHF() {
		System.out.println("connectAHF() 시작");
		
		String command = "c:\\windows\\system32\\net.exe use Z: \\\\10.10.10.222\\Antenna-House\\AHFormatterV71 /user:facc ast141#";
		try {
			Process p = Runtime.getRuntime().exec(command);
			
		} catch (IOException e) {
			System.out.println("연결 실패" + e.getMessage());
			e.printStackTrace();
		}
		System.out.println("연결 완료 끝!");
		
	}
	
	public boolean netIsAvailable(String path) {
	    File file = new File(path);
        
	    
	    boolean result = false;
        
	    if(file.exists()) {
	        System.out.println("연결 되어 있음");
	        result = true;
	        
	    } else {
	        System.out.println("연결 되어 있지 않음");
	        result = false;
	    }
        
	    return result;
	}
	
	
	
	
	public void startGetValues() {
		System.out.println("startGetValues() 시작");
		
		// map 경로 얻기
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
    
    
    // 드래그를 끝마친 경우 경우
    public void dragExit(DragEvent e, TextField tf) {
        tf.setStyle("-fx-background-color: #ffc0cb;");
    } 
    
    // 예외 발생시 호출될 메소드
    public void customException(String msg) {
        System.out.println("customException() 메소드 호출");
        
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
		System.out.println("setDirectoryPath() 시작");
		
		File file = new File("");
		
		// 패키지 경로
		projectDir = file.getAbsolutePath();
		obj.projectDir = projectDir;
		System.out.println("projectDir: " + projectDir);
		
		// 라이브러리 경로
		libDir = projectDir + File.separator + "lib";
		obj.libDir = libDir; 
		System.out.println("libDir: " + libDir);
				
		// fxOptionList 파일 경로
		optionListF = libDir + File.separator + "fxOptionList.xml";
		obj.optionListF = optionListF; 
		 
		// DITA-OT lib
        zDirlib = "z:\\lib\\MA";
        obj.zDirlib = zDirlib;
        
        // DITA-OT-MA
      ditaotS = libDir + File.separator + "DITA-OT-MA";
//        ditaotS = zDirlib + File.separator + "DITA-OT-MA";
        obj.ditaotS = ditaotS; 
        
		// DITA-OT filter 
		filterS = ditaotS + File.separator + "_filter"; 
		obj.filterS = filterS;
		
		// DITA-OT lib/xsls
		ditaxsls = zDirlib + File.separator + "xsls";
		obj.ditaxsls = ditaxsls;
		
	    // language.xml 파일 경로
		languagesF = ditaotS + File.separator + "plugins/com.ast.protean.ma.um_en_2020pdf/cfg/common" + File.separator + "languages.xml";
        obj.languagesF = languagesF; 
        System.out.println("languagesF: " + languagesF);
		
		// DITA-OT catalog
        catalogDir = ditaotS + File.separator + "catalog-dita.xml";
        obj.catalogDir = catalogDir;
        
        // z: idml templates 폴더 
        zDiridmlTempls = zDirlib + File.separator + "idml-templates/templates";
        obj.zDiridmlTempls = zDiridmlTempls; 
        
        // local template 폴더
        DiridmlTempls = libDir + File.separator + "idml-template/template";
        obj.DiridmlTempls = DiridmlTempls;
        
        // pdf-setting 폴더
        pdfSetting = ditaotS + File.separator + "pdf-settings";
        obj.pdfSetting = pdfSetting; 
        
        // openjdk
//        jdkDir = libDir + File.separator + "openjdk-18.0.1";
        jdkDir = projectDir + File.separator + "jre";
        obj.jdkDir = jdkDir; 
        
        // saxon
//        saxonDir = libDir + File.separator + "saxon";
        saxonDir = zDirlib + File.separator + "saxon";
        obj.saxonDir = saxonDir;
        
        // ghostscript
        gsDir = libDir + File.separator + "gs9.56.1/bin/gswin64c.exe";
        obj.gsDir = gsDir;
        
        // templateExcel
        templateExcel = ditaxsls + File.separator + "htmlExcelDB/skeleton.xlsx";
        obj.templateExcel = templateExcel; 
        
        // z: idml templates 폴더 
        zDirhtmlTempls = zDirlib + File.separator + "html-templates";
        obj.zDirhtmlTempls = zDirhtmlTempls; 
        
	}
	
	public void readNsetdata() {
		System.out.println("readNsetdata() 시작");
		
		// option 파일 읽기
		readOptionF rof = new readOptionF();
		rof.runReadOptionF();
		
		// language 언어 목록 읽기
		readLanguagesF rlf = new readLanguagesF();
		rlf.runReadLanguagesF();
		
		setListItems();
	}
	
	@SuppressWarnings("unchecked")
	public void setListItems() {
		System.out.println("setListItems() 시작");
		
		// template 목록 채우기
		cb2.setItems(FXCollections.observableArrayList(obj.templateList));
		cb2.getSelectionModel().selectFirst(); 

		// html 목록 채우기
		cb3.setItems(FXCollections.observableArrayList(obj.htmlList));
		cb3.getSelectionModel().selectFirst();
		
		// prodtype 목록 채우기
		cb4.setItems(FXCollections.observableArrayList(obj.prodList));
		cb4.getSelectionModel().selectFirst(); 
		
		
		int pos = 0;
		// language.xml 파일로부터 추출한 언어 및 언어코드를 수집한 langMap 반복 하여 목록 채우기
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
		
		// English로 시작하는 언어가 아닌 언어들은 알파벳순으로 정렬한 후, totallang 컬렉션으로 수집 
		multilang.sort(Comparator.naturalOrder());
		totallang.addAll(multilang);

		cb1.setItems(FXCollections.observableArrayList(totallang));

		// 선택된 목록을 속성 감시하여, isocode 출력 하기
		cb1.getSelectionModel().selectedItemProperty().addListener(new ChangeListener<String>() {
			@Override
			public void changed(ObservableValue<? extends String> observable, String oldValue, String newValue) {
				iso.setText(obj.langMap.get(newValue));
				
				// Label 버튼 클릭시 텍스트 클립 보드 복사하기
		        Clipboard clipboard = Clipboard.getSystemClipboard();
		        ClipboardContent content = new ClipboardContent();
		        content.putString(iso.getText());
		        clipboard.setContent(content);
		        
			    // 선택한 목록을 allSelectedList 로 모아, TextArea 에 출력 
                allSelectedList.add(newValue);
                // 선택한 언어, 언어코드를 map 컬렉션으로 수집하여 workstart() 메소드 호출시 반복하여 진행
                selectItems.put(newValue, obj.langMap.get(newValue));
                
                // allSelectedList 3개가 채워졌을 때 비활성화
                if(allSelectedList.size() == 5) {
                    cb1.setDisable(true);
//	                  tta1.setDisable(true);
                    
                }
                selectItems.remove("언어선택");
                allSelectedList.remove("언어선택");
                // allSelectedList 리스트 컬렉션을 배열로 변경하여 저장
                String[] strarr = allSelectedList.toArray(new String[0]);
                
                
                
                // textArea 영역에 출력
                
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

		// 선택된 파일 경로 얻기 - File.getPath() 메소드
		if(selectedFile != null) {
			if(tf.getId().equals("tf1")) {
				mapPath = selectedFile.getPath();
				tf1.setText(mapPath);
				
			} else if(tf.getId().equals("tf2")) {
				// pv의 체크 박스가 활성화 상태일 경우에만 tf에 값 채우기
				if(!tf.isDisable()) {
					pvPath = selectedFile.getPath();
					tf2.setText(pvPath);
				}
				
			}
		}
		
	}
	/*
	public void getCheckbox() {
		System.out.println("getCheckbox() 시작");
		
		cb5.selectedProperty().addListener(new ChangeListener<Boolean>() {

			@Override
			public void changed(ObservableValue<? extends Boolean> observable, Boolean oldValue, Boolean newValue) {
				if(newValue) {
					System.out.println("체크됨");
					tf2.setDisable(true);
					
				} else {
					System.out.println("체크 안됨");
					tf2.setDisable(false);
				}
				
			}
			
		});
		
	}
	*/
	
	public File pvUpdateDialog(String titleTxt) {
		System.out.println("pvUpdateDialog() 시작");
		
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
        System.out.println("tmxUpdateDialog() 시작");
        
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
	    System.out.println("DelFinalTempDir() 시작");

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
        System.out.println("selectedPopup() 메소드 호출");
        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        // FXMLLoader.load() 메소드로 팝업 로드
        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/DITA/fxcontroller/fxml/verError.fxml"));
//            parent.setStyle("-fx-background-color: ANTIQUEWHITE");
            
            //버튼 찾기 
            Button sebt = (Button) parent.lookup("#errBt");
            sebt.setOnAction(ev -> dg.close());

            // 라벨 컨트롤 찾기
            Label selb = (Label) parent.lookup("#errLb1");
            selb.setWrapText(true);
            selb.setText(msg);

            Hyperlink hy = (Hyperlink) parent.lookup("#hylink");
            Label loglb = (Label) parent.lookup("#loglb");
            if(msg.contains("errorTxt")) {
                String outF = obj.projectDir + File.separator + "error-log.xml";
                String outF2 = outF.replace("\\", "/");
//                System.out.println(outF2);
                
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
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/DITA/fxcontroller/fxml/completePopup.fxml"));
//            parent.setStyle("-fx-background-color: ANTIQUEWHITE");
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
	
	public void setStyleControl() {
	    System.out.println("setStyleControl() 시작");
	    
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
        System.out.println("runIntegrator() 시작");
        
        List<String> runList = new ArrayList<>();
        
//        String integrateF = "call H:/JAVA/java-workspace/Protean-MA/lib/DITA-OT-MA/bin/ant -f H:/JAVA/java-workspace/Protean-MA/lib/DITA-OT-MA/integrator.xml";
        String integrateF = "call " + obj.ditaotS + "/bin/ant " +  " -f " + obj.ditaotS + "/integrator.xml";
        
        
        runList.add(integrateF);
        String switch1 = "Integra";
        processBuilder2 exeExcute = new processBuilder2(runList, switch1);
        exeExcute.runProcessBuilder();

    }
	
	
	public void delOutDir(commonPublishing cp) {
	    System.out.println("delOutDir() 시작");
	    
	    try {
	        // 저장될 경로 지정
//	        cp.setOutdir();
	        
	        // out 폴더가 없다면 out 경로 생성
	        Path outmapdir = Paths.get(outMapDir);
	        
	        if(Files.notExists(outmapdir)) {
	            System.out.println("폴더 없음, 폴더 생성!!");
	            try {
	                Files.createDirectories(outmapdir);
	                
	            } catch (IOException e) {
	                msg = "out 폴더 삭제 실패, 다른 프로그램이 out 폴더를 사용하고 있습니다.";
	                System.out.println("msg: " + msg);
	                throw new RuntimeException(msg);
	            }
	        }
	        
	    } catch (Exception e1) {
	        msg = "out 폴더 삭제 실패, 다른 프로그램이 out 폴더를 사용하고 있습니다.";
	        System.out.println("msg: " + msg);
	        throw new RuntimeException(msg);
	        
	    }
	    
	}
	
	public void programInitial() {
	    System.out.println("programInitial() 시작");
	    
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
