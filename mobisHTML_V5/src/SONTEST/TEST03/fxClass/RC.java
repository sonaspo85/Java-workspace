package SONTEST.TEST03.fxClass;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.ResourceBundle;
import java.util.TreeSet;
import java.util.stream.Stream;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import SONTEST.TEST03.fileControl.exportComboList;
import SONTEST.TEST03.fileControl.extractStories;
import SONTEST.TEST03.fileControl.fileCollect;
import SONTEST.TEST03.fileControl.fileGroupCreateZip;
import SONTEST.TEST03.fileControl.unZip;
import SONTEST.TEST03.fileControl.refXslt.inOutObj;
import SONTEST.TEST03.ftp.ftpConnect;
import SONTEST.TEST03.subWorkClass.commonObj;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.concurrent.Task;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Point2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.MenuItem;
import javafx.scene.control.ProgressBar;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.DragEvent;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.TransferMode;
import javafx.stage.DirectoryChooser;
import javafx.stage.FileChooser;
import javafx.stage.FileChooser.ExtensionFilter;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;

public class RC implements Initializable {
    @FXML private MenuItem exit;
    @FXML private MenuItem menuOpen;
    @FXML private Button bt1;
//    @FXML private Label lb1;
    @FXML private Label lbTime;
    @FXML private ComboBox comboInch;
    @FXML private ComboBox comboCompany;
    @FXML private ComboBox comboLang; 
    @FXML private TableView<tableFiles> tableView;
    @FXML private ProgressBar pb;
    
    private Stage primaryStage;
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }
    
    private Logger logger = LogManager.getLogger(RC.class); 
    commonObj coj = new commonObj();
    
    List<File> selectedFiles;
    private ObservableList<tableFiles> fileList = FXCollections.observableArrayList();
    private ObservableList<tableFiles> flieSize = FXCollections.observableArrayList();

    List<String> list = new ArrayList<>();
    private boolean stop = false;
    String excelLang;
    String uiTxt;
    public static String msg;
    String getSrcPath = "";

    TreeSet<File> treeSet = new TreeSet<>();
    exportComboList exportComboList = new exportComboList();
    fileCollect fileCollect = new fileCollect();
    
    LocalTime ltStart = null;
    LocalTime ltEnd = null;
    
    String userName = System.getProperty("user.name");
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        String logPath = coj.exePath + File.separator + "log" + File.separator;
        System.out.println("logPath: " + logPath);
        System.setProperty("logFilename", logPath);
        
        exit.setOnAction(event -> Hexit(event));
        
        bt1.setOnAction(event -> parallelWorking(event));
//        bt1.setOnAction(event -> btStart(event));
        
        menuOpen.setOnAction(event -> menuOpen(event));
        tableView.setOnDragOver(event -> dragOver(event));
        tableView.setOnDragDropped(event -> dragDrop(event));
        tableView.setOnDragExited(event -> dragExit(event));
        tableView.setOnKeyPressed(event -> keyCodeDelete(event));
        
        // 콤보 목록 채우기
        exportComboList();
     
        // tableView 의 Row에 들어갈 목록 생성하기
        CreateTableColumn();
        
        // 키보드의 키를 눌렀을때, 키코드와 일치하는 목록으로 커서 옮기기
        comboInch.setOnKeyPressed(new selectionKeyCode(comboInch));
        comboCompany.setOnKeyPressed(new selectionKeyCode(comboCompany));
        comboLang.setOnKeyPressed(new selectionKeyCode(comboLang));
    }
    
    // 회사, 언어, 인치 콤보 목록 채우기
    public void exportComboList() {
        try {
            exportComboList.getCodes();
            
            List<String> langList = new ArrayList<>();
            String[] str1 = (String[]) exportComboList.listLang.toArray(new String[0]);
            Arrays.sort(str1);
            langList.addAll(Arrays.asList(str1));
            
            //----------------------
            comboLang.setItems(FXCollections.observableArrayList(langList.toArray()));
            setStyle(comboLang);
            
            List<String> companyList = new ArrayList<>();
            companyList.addAll(exportComboList.listCompany);
            
            // company Combo 밖스의 목록 첫 문자 대문자로 변경
            Stream<String> companyList01 = companyList.stream().map(a -> {
                String firstStr = a.substring(0, 1).toUpperCase();
                String remainStr = a.substring(1).toLowerCase();
                String result = firstStr + remainStr;
                return result;
            });
            comboCompany.setItems(FXCollections.observableArrayList(companyList01.toArray()));
            setStyle(comboCompany);
            
            //----------------------
            List<String> inchList = new ArrayList<>();
            inchList.addAll(exportComboList.listInch);
            comboInch.setItems(FXCollections.observableArrayList(inchList.toArray()));
            setStyle(comboInch);
            
        } catch(Exception e) {
            msg = "회사, 언어, 인치 콤보를 채우기 예외 발생";
            customException(msg);
            return;
        }
    }
    
    private void setStyle(Object combo) {
        if(combo instanceof ComboBox) {
            ComboBox combobox = (ComboBox) combo;
            combobox.setStyle("-fx-alignment: CENTER; "
                    + "-fx-font-family: Arial;"
                    + "-fx-font-size: 12.5;");
            
        } else if(combo instanceof TableColumn) {
            TableColumn tc = (TableColumn) combo;
            
            tc.setStyle("-fx-alignment: CENTER; "
                    + "-fx-font-family: Arial;"
                    + "-fx-font-size: 12.5;");
        }
        
    }
    
    
    public void CreateTableColumn() {
        // 첫번째 칼럼의 인덱스
        TableColumn tc = tableView.getColumns().get(0);
        tc.setCellValueFactory(new PropertyValueFactory("files"));
        setStyle(tc);
        
        tc = tableView.getColumns().get(1);
        tc.setCellValueFactory(new PropertyValueFactory("filesize"));
        setStyle(tc);
        
        tc = tableView.getColumns().get(2);
        tc.setCellValueFactory(new PropertyValueFactory("filedate"));
        setStyle(tc);
        
        tableView.setItems(fileList);
        
        // tableView 목록 멀티 선택
        tableView.getSelectionModel().setSelectionMode(SelectionMode.MULTIPLE);
    }
    
    // 드래그 중인 경우
    public void dragOver(DragEvent e) {
        if(e.getGestureSource() != tableView && e.getDragboard().hasFiles()) {
            tableView.setStyle(
                "-fx-border-color:red;" + 
                "-fx-background-color: ANTIQUEWHITE;"
            );
            e.acceptTransferModes(TransferMode.COPY_OR_MOVE);
        }
        e.consume();
    } 
    
    // 드래그 드랍한 경우
    public void dragDrop(DragEvent e) {
        boolean success = false;
        
        if(e.getGestureSource() != tableView && e.getDragboard().hasFiles()) {
            List<File> list = e.getDragboard().getFiles();
            
            list.removeIf(a -> a.isDirectory());
            
            dragDrop dragDrop = new dragDrop(list);
            dragDrop.runDragDrop();
            
            // dragDrop 객체에서 tableView 의 각 목록을 생성 한 것을 호출
            fileList.addAll(dragDrop.getFileList());
            success = true;
        }
        
        e.setDropCompleted(success);
        e.consume();
    } 
    
    // 드래그를 끝마친 경우 경우
    public void dragExit(DragEvent e) {
        tableView.setStyle("-fx-background-color: #ffc0cb;");
    } 
    
    public void menuOpen(ActionEvent e) {
        FileChooser fc = new FileChooser();  
        
        // 파일 확장자 필터 설정 - getExtensionFilters()
        fc.getExtensionFilters().addAll(
            new ExtensionFilter("all Files", "*.xlsx", "*.idml")
        );
        fc.setTitle("파일을 선택해 주세요.");

        selectedFiles = fc.showOpenMultipleDialog(primaryStage);
        
        menuTableRowCreate mtrc = new menuTableRowCreate(selectedFiles);
        mtrc.runMenuTableRowCreate();
        
        // dragDrop 객체에서 tableView 의 각 목록을 생성 한 것을 호출
        fileList.addAll(mtrc.getFileList());
    }
    
    public void Hexit(ActionEvent e) {
        System.out.println("종료");
        Platform.exit();
    }
    
    public void btStart() throws Exception {
        stop = false;
        System.out.println("btStart 시작");
        ltStart = LocalTime.now();
        
        Object getInch = comboInch.getValue();
        Object getCompany = comboCompany.getValue();
        Object getLang = comboLang.getValue();

        coj.inch = (String) getInch;
        coj.company = (String) getCompany;
        coj.lang = (String) getLang;
        // 선택된 항목 선택 해제
        tableView.getSelectionModel().clearSelection();

        // tableView 컨트롤의 항목 추출하기
        ObservableList<tableFiles> tableList = tableView.getItems();
        List<tableFiles> viewList = new ArrayList<tableFiles>(tableList);
        Optional<List<tableFiles>> opList = Optional.ofNullable(viewList);
        
        if(tableList.isEmpty()) {
            msg = "입력된 문서가 0개 입니다.";
//            logger.error(msg);
        }
        
        // tableView 의 모든 파일 목록을 map 컬렉션으로 생성
        opList.ifPresent(d -> fileCollect.setMap(d));

        // Excel 파일 이름 추출
        fileCollect.exportExcelName();
        excelLang = fileCollect.excelLang;
        uiTxt = fileCollect.uiTxt;
        System.out.println("uiTxt: " + uiTxt);
        if(getInch == null || getCompany == null || getLang == null) {
            msg = "인치 / 회사 / 언어를 모두 선택해 주세요.";                    
            customException(msg);
            return;
            
        } else if (getLang.toString().toLowerCase().indexOf(excelLang) == -1) {
            msg = "언어가 다릅니다.";
            customException(msg);
            return;
        }
        
        // idml 파일들만 추출하여, List<String> 컬렉션에 삽입
        tableList.stream().forEach(a -> {
            File filePath = new File(a.getAbfile());
            list.add(a.getAbfile());
            treeSet.add(filePath);
        });
        
        getSrcPath = treeSet.first().getParent();
        
        fileCollect.mapT.clear();
        
        // 파일 열기
        readFiles();
    } 
    
    // 예외 발생시 호출될 메소드
    public void customException(String msg) {
        System.out.println("customException() 메소드 호출");
        selectedPopup(msg);
        return;
    }
    
    // 최종 작업 처리 후, 팝업창으로 경과 초를 출력
    public void finishedPop(long durationTime) {
        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        dg.setTitle("작업이 완료 되었습니다.");
        
        try {
            // FXMLLoader.load() 메소드로 popup.fxml 파일 로드
            Parent parent = FXMLLoader.load(getClass().getResource("/SONTEST/TEST03/fxml/complePop.fxml"));
            
            // 버튼 속성을 가진 객체를 찾기 - lookup() 메소드
            Button bt = (Button) parent.lookup("#bt1");
            bt.setOnAction(event -> dg.close());
            
            // Label 컨트롤 찾기
            Label lb22 = (Label) parent.lookup("#txtTitle");
            lb22.setText("작업이 완료 되었습니다.");
            
            // durationTime 시간 삽입
            Label duTime = (Label) parent.lookup("#durationTime");
            duTime.setText(String.valueOf(durationTime) + " 초");
            
            // 이미지 교체
            InputStream imgStream = RC.class.getClassLoader().getResourceAsStream("SONTEST/TEST03/fxml/complete.png");
            Image image = new Image(imgStream);
            
            ImageView iv = (ImageView) parent.lookup("#imm");
            iv.setImage(image);
            
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

    private void selectedPopup(String msg) {
        System.out.println("selectedPopup() 메소드 호출");
        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        // FXMLLoader.load() 메소드로 팝업 로드
        try {
            Parent parent = FXMLLoader.load(getClass().getResource("/SONTEST/TEST03/fxml/selectedException.fxml"));
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
    
    public void readFiles() {
        System.out.println("readFiles 시작");
        // 작업 스레드를 통해 파일 읽기
        
        fileCollect.setMap(list);
        Map<groupByext.Ext, List<groupByext>> map = fileCollect.mapT;
        
        // idml 파일들을 zip 확장자로 변경
        fileGroupCreateZip fr = new fileGroupCreateZip(map, coj.exePath); 
        fr.runCreateZip();
        
        // zip 파일 언집 후, 새로운 폴더에 파일들 복사
        createUnzipFolder();
    }
    
    private void createUnzipFolder() {
        // for문을 돌면서 zip 파일 압축 풀기        
        String zipPath = coj.exePath + "\\resource\\temp\\idmlZip";
        
        unZip unzip = new unZip();
        try {
            unzip.runUnzip();
        } catch (Exception e) {
            msg = "unzip 예외 발생";
            e.printStackTrace();
            customException(msg);
            return;
        }
        
     // Stories 를 map 컬렉션 형식으로 추출
        extractStories(zipPath);
    }
    
    private void extractStories(String zipPath) {
        System.out.println("extractStories 시작");
        
        extractStories extractStories = new extractStories(zipPath);
        extractStories.runExctractStory();

        copyXslt();
    }
    
    public void copyXslt() {
        if(!userName.equals("SMC")) {
            ftpConnect ftpC = new ftpConnect();
            ftpC.runFTP();
            System.out.println("copyXslt 끝");
        } else {
            System.out.println("SMC 사용자 입니다.");
        }
        
        XsltTransform();
    }
    
    public void XsltTransform() {
        System.out.println("XsltTransform 시작");
        
        inOutObj ioo = new inOutObj(coj.mergedPath, uiTxt);
        try {
            ioo.setList();
            
            // 임시로 생성된 output 폴더를 원하는 디렉토리로 복사
//            saveDirs();
        } catch(Exception e1) {
//            msg = "xslt 작업을 위한 소스/타겟/xslt 파일 경로가 존재 하지 않거나, \n파일 예외가 발생되었습니다.";
            msg = e1.getMessage();
            System.out.println(msg);
            customException(msg);
            return;
        }
        
        delXSLT();
    }
    
    public void delXSLT() {
        String xslPath = coj.exePath + File.separator + "xsls";
        Path xsltPath = Paths.get(xslPath);
        if(!userName.equals("SMC")) {
            try {
                coj.delteFolder(xsltPath);
            } catch (Exception e) {
                msg = "xsls 삭제 예외가 발생되었습니다.";
                System.out.println(msg);
                customException(msg);
                return;
            }
        }
        // 종료 시간
        ltEnd = LocalTime.now();
    }
    
    public void parallelWorking(ActionEvent e) {
        Task<Void> task = new Task<Void>() {
            String msg = "";
            @Override
            protected Void call() {
                while(!stop) {
                    try {
                        Thread.sleep(10);
                    } catch(InterruptedException e1) {
                        msg = "Progressbar 를 호출하는 Task 객체 예외 발생";
                    }
                }
                updateProgress(0, 0);

                return null;
            }
            
            @Override
            protected void succeeded() {
                System.out.println("pb 종료 하기");
                pb.setOpacity(0.0);
            }
            
            @Override
            protected void failed() {
                selectedPopup(msg);
                return;
            }
        };
         
        pb.progressProperty().bind(task.progressProperty());
        pb.setOpacity(1.0);
        
        Thread thread = new Thread(task);
        thread.setDaemon(true);
        thread.start();
        
       
        Task<Void> task2 = new Task<Void>() {
            String msg ="";
            @Override
            protected Void call() {
                try {
                    btStart();
                    
                } catch (Exception e3) {
                    msg = RC.msg;
                    failed();
                }
               
                return null;
            }
            
            @Override
            protected void succeeded() {
                // 완료 팝업창
                try {
                    String str = saveDirs();
                    if(str != null) {
                        msg = "저장 폴더가 지정되지 않았습니다.";
                        failed();
                    }
                } catch (Exception e) {
                    
                }
                return;
            }
            
            @Override
            protected void failed() {
                selectedPopup(msg);
                stop = true;
                logger.error(msg);
                return;
            }
        };
        
        Thread thread2 = new Thread(task2);
        thread2.setDaemon(true);
        thread2.start();
    }
    
    public String saveDirs() throws Exception {
        System.out.println("saveDirs() 메소드 시작 부분");
        DirectoryChooser dc = new DirectoryChooser();
        dc.setTitle("저장 폴더를 선택 하세요.");
        File selectedDir = dc.showDialog(primaryStage);
        
        if (selectedDir == null) {
            msg = "저장 폴더가 지정되지 않았습니다.";
            return msg;
        }
        
        File file = new File("");
        
        String fromDirs = file.getAbsolutePath() + "\\output";
        String toDirs = selectedDir.getAbsolutePath();
        
        System.out.println("fromDirs: " + fromDirs);
        System.out.println("toDirs: " + toDirs);

        File from = new File(fromDirs);
        File to = new File(toDirs);
        
        coj.copyFolder(from, to);
        
        //------------------------------
        System.out.println("완료 팝업창");
        long durationTime = ltStart.until(ltEnd, ChronoUnit.SECONDS);
          
        finishedPop(durationTime);
        stop = true;
        
        return null;
    }

    // 키보드의 키코드로 tableView의 목록 삭제하기
    public void keyCodeDelete(KeyEvent keyevent) {
//        tableFiles selectedItem = tableView.getSelectionModel().getSelectedItem();
        ObservableList<tableFiles> selectedFiles = tableView.getSelectionModel().getSelectedItems();
        
        if (selectedFiles != null) {
            if(keyevent.getCode().equals(KeyCode.DELETE)) {
//                tableView.getItems().remove(selectedItem);
                ArrayList<tableFiles> rows = new ArrayList<tableFiles>(selectedFiles);
                rows.forEach(row -> tableView.getItems().remove(row));
            }
        }
    }
    
    // Button 컨트롤 클릭시, 선택된 멀티 파일 삭제하기
    public void deleteFiles(ActionEvent e) {
      ObservableList<tableFiles> selectedFiles = tableView.getSelectionModel().getSelectedItems();
      ArrayList<tableFiles> rows = new ArrayList<tableFiles>(selectedFiles); 
      rows.forEach(row -> tableView.getItems().remove(row));
    }
    
    
}