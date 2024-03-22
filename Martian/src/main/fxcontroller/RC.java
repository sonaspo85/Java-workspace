package main.fxcontroller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Set;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.w3c.dom.Element;

import javafx.beans.binding.Bindings;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.concurrent.Task;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Point2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.ContextMenu;
import javafx.scene.control.Label;
import javafx.scene.control.ListCell;
import javafx.scene.control.ListView;
import javafx.scene.control.MenuItem;
import javafx.scene.control.ProgressBar;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.TextField;
import javafx.scene.control.ToggleButton;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.text.Text;
import javafx.stage.DirectoryChooser;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import main.Common.implementOBJ;
import main.excelcontroller.excelMain;
import main.excelcontroller.getLangs;
import main.ftpcontroller.ftpRemoveDir;
import main.ftpcontroller.ftpUpLoad;
import main.idmlcontroller.accessDesignmap;
import main.idmlcontroller.changeExtIdmltZip;
import main.idmlcontroller.createEachIdmlFiles;
import main.idmlcontroller.storyesMerged;
import main.othercontroller.copyFTPTempls;
import main.othercontroller.docInfo;
import main.othercontroller.readlangxml;
import main.othercontroller.readtlxml;
import main.othercontroller.readtypexml;
import main.othercontroller.readverxml;
import main.othercontroller.srcRunRepeat;
import main.zipcontroller.unZip;


public class RC implements Initializable {
    @FXML private Button bt1;
    @FXML private Button bt2;
    @FXML private Button bt3;
    @FXML private Button bt4;
    @FXML private ComboBox<String> cb1;
    @FXML private ComboBox<String> cb2;
    @FXML private TextField tf1;
    @FXML private TextField tf2;
    @FXML private TextField tf3;
//    @FXML private Label lb1;
    
    @FXML private ProgressBar pbar1;
    @FXML private Text pbart1;
    String userName = System.getProperty("user.name");
    
    @FXML private ContextMenu cm1;
    @FXML private MenuItem mi1;
    @FXML private MenuItem mi2;
    @FXML private ToggleButton tobt1;
    @FXML private ToggleButton tobt2;
    
    
    
    private boolean stop = false;
    implementOBJ obj = new implementOBJ();
    public String msg = "";
    Path srcPathP = null;
    Path zipDirP = null;
    String projectDir = "";
    List<String> langList = new ArrayList<>();
    
    int typeNum = 0;
    String LangCodeNum = "";
    List<String> langL = new ArrayList<>();
    List<String> langL2 = new ArrayList<>();
    List<String> typeL = new ArrayList<>();
    List<String> verL = new ArrayList<>();
    Map<String, List<String>> typelangMap = new HashMap<>();
    Map<String, String> langMap = new HashMap<>();
    Path srcP = null;
    List<String> srcFullPath = new ArrayList<>();
    List<Path> srcDirFullpath = new ArrayList<>();
    Map<String, String> isocurpath = new HashMap<>();
    String labelTxt = "";
    
    
    
    
    private Stage primaryStage;
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        System.out.println("RC 시작");

        setDirectoryPath();
        
        // 언어 목록 엑셀을 xml로 변환
        loadLangs();
        
        cb1.setItems(FXCollections.observableArrayList(typeL));
        
        // 언어 선택 팝업창 출력
        bt2.setOnAction(e -> langPop());
        
        // 폴더 선택 다이얼로그
        bt3.setOnAction(e -> openDialog());
        
        // html 변환 시작 버튼
        bt1.setOnAction(e -> stWork());
     
        cb1.getSelectionModel().selectFirst();
        cb2.setDisable(true);
//        cb2.getSelectionModel().select(2);
//        cb2.setStyle("-fx-font-family: consolas");
        
        tf1.setText("H:/Workspace/Java-workspace/Martian/srcDir");
        tf2.setText("111");
        
        bt4.setOnAction(e -> exedExcel());
        
        
        String template1F = obj.resourceDir + "/excel-template/template1.xlsx";
        String language1F = obj.resourceDir + "/excel-template/language.xlsx";
        
        
        bt4.addEventHandler(MouseEvent.MOUSE_CLICKED, new EventHandler<MouseEvent>() {
            @Override
            public void handle(MouseEvent e) {
                if (e.getButton() == MouseButton.PRIMARY) {
                    System.out.println("왼쪽 버튼 클릭");
                    exedExcel();
                    
                } else {
                    System.out.println("오른쪽 버튼 클릭");
                    cm1.show(bt4, e.getScreenX(), e.getScreenY());
                    mi1.setOnAction(e2 -> workStartMi1(template1F));
                    mi2.setOnAction(e2 -> workStartMi1(language1F));
                }
                
            }
        });
        
        tobt1.selectedProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue == true) {
                tobt1.setStyle("-fx-border-color: #c8c9cc;" + 
                                "-fx-background-color: #f0eece;");
                
            } else {
                tobt1.setStyle("-fx-border-color: #c1c3c9;");
                
            }  
        });
        
        tobt2.selectedProperty().addListener(((observable, oldValue, newValue) -> {
            System.out.println(tobt2.getText() + " changed from " + oldValue + " to " + newValue);

            if (newValue == true) {
                tobt2.setStyle("-fx-border-color: #c8c9cc;" + 
                                "-fx-background-color: #f0eece;");
                
                tf3.setDisable(false);
                tf3.setStyle("-fx-border-color: #c1c3c9;" + 
                        "-fx-background-color: #f0eece;");
                
                tobt2.addEventHandler(MouseEvent.MOUSE_CLICKED, new EventHandler<MouseEvent>() {
                    @Override
                    public void handle(MouseEvent e) {
                        if (e.getButton() == MouseButton.SECONDARY) {
                            if(e.getClickCount() == 2){
                                String tobt2Txt = tobt2.getText(); 
                                
                                if (tobt2Txt.contains("제품")) {
                                    tobt2.setText("리모컨 매뉴얼");
                                    
                                } else if(tobt2Txt.contains("리모컨")) {
                                    tobt2.setText("제품 매뉴얼");
                                }
                                 
                            }
                        }
                        
                    }
                });

            } else {
                tobt2.setStyle("-fx-border-color: #c1c3c9;");
                tf3.setDisable(true);
                tf3.clear();
                tf3.setStyle("-fx-border-color: #c1c3c9;" + 
                            "-fx-background-color: inherit;");
            }
            
        }));

    }
    
    public void customException(String msg) {
        System.out.println("customException() 메소드 호출");
        selectedPopup(msg);
        return;
    }
    
    private void selectedPopup(String msg) {
        System.out.println("selectedPopup() 메소드 호출");
        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/fxcontroller/selectedException.fxml"));
            
            Button sebt = (Button) parent.lookup("#sebt");
            sebt.setOnAction(ev -> dg.close());
            Label selb = (Label) parent.lookup("#seLabel");
            selb.setText(msg);
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
    
    // 최종 작업 처리 후, 팝업창으로 경과 초를 출력
    public void finishedPop() {
        System.out.println("finishedPop() 시작");

        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        dg.setTitle("작업이 완료 되었습니다.");
        
        try {
            // FXMLLoader.load() 메소드로 popup.fxml 파일 로드
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/fxcontroller/complePop.fxml"));
            
            // 버튼 속성을 가진 객체를 찾기 - lookup() 메소드
            Button bt = (Button) parent.lookup("#bt1");
            bt.setOnAction(event -> dg.close());
            
            // Label 컨트롤 찾기
            Label lb22 = (Label) parent.lookup("#txtTitle");
            lb22.setText("작업이 완료 되었습니다.");
            
            InputStream imgStream = RC.class.getClassLoader().getResourceAsStream("main/fxcontroller/complete.png");
            Image image = new Image(imgStream);
            
            ImageView iv = (ImageView) parent.lookup("#imm");
            iv.setImage(image);
            
            Scene scenePop = new Scene(parent);
            dg.setScene(scenePop);
            dg.setResizable(false);
            dg.show();
            
            Point2D point = parent.localToScene(100.0, 100.0);
            dg.setX(primaryStage.getX() + point.getX());
            dg.setY(primaryStage.getY() + point.getY());
            
        } catch(Exception e1) {
            
        }
    }
    
    public void stWork() {
        System.out.println("stWork() 시작");

        String tfTxt = tf1.getText();
        if(tfTxt == "") {
            tfTxt = tf1.getText();
        }
        
        obj.srcPathP = Paths.get(tfTxt);
        obj.modelNumber = tf2.getText();
        
        String videoonOff = "off";
        if(tobt1.isSelected()) {
            videoonOff = "on";
        }
        

        if(tf1.getText() == "" || cb1.getValue() == null | obj.langL2.size() < 1 ) {
            msg = "type / 경로 / video on/off를 모두 선택해 주세요.";
            bt1.setDisable(false);
            customException(msg);
        } 
        
        else if(tf1.getText() != "" && cb1.getValue() != null) {
            DisabledControl();
            
            // type 목록 추출
            String type = cb1.getValue().toString();
            obj.type = type;
            // ver 추출            
//            String ver = cb2.getValue().toString();
            String ver = "Ver003";
            obj.ver = ver;
            
            // Radio 선택 목록 추출
            String radioTxt = videoonOff; 
            obj.ridioTxt = radioTxt;
            
            String remoteswitch = "off";
            String remoconTxt = "";
            String manualType = tobt2.getText();
            obj.manualType = manualType;
            
            if(tobt2.isSelected()) {
                remoteswitch = "on";
                obj.remoteswitch = remoteswitch; 
                // 리모컨 텍스트 추출
                remoconTxt = tf3.getText();
                obj.remoconTxt = remoconTxt;

            }
            

            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    getISO();
                    
                    // temp 경로 설정
                    String tempDir = obj.srcPathP.toAbsolutePath() + File.separator + "temp";
                    obj.tempDir = Paths.get(tempDir);
                    
                    // zipDir 경로 설정
                    String zipDirPathS = tempDir + File.separator + "zipDir"; 
                    obj.zipDirP = Paths.get(zipDirPathS);
                    
                    // output폴더 삭제 하기
                    try {
                        String outputpath = obj.srcPathP + "/output";
                        Path outputP = Paths.get(outputpath);
                        
                        if (Files.isDirectory(outputP)) {
                            obj.recursDel(outputP);
                            
                        } 
                        if (Files.isDirectory(obj.tempDir)) {
                            obj.recursDel(obj.tempDir);
                            
                        } 
                        
                    } catch(Exception e) {
                        msg = "";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                    updateProgress(10, 100);
                    updateMessage(String.valueOf(10));

                    // 2. 인터페이스 상의 선택한 언어 목록만으로 srcDir 경로 생성
                    try {
                        SelectedLangFullPath();
                        
                    } catch(Exception e) {
                        msg = e.getMessage();
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                        
                    }
                    
                    updateProgress(20, 100);
                    updateMessage(String.valueOf(20));
                    
                    // 문서 정보를 파일로 추출
                    try {
                        docInfo docinfo = new docInfo();
                        docinfo.runExtractXML();
                        
                    } catch (Exception e) {
                        msg = e.getMessage();
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                    updateProgress(30, 100);
                    updateMessage(String.valueOf(30));
                    
                    try {
                        // 3. 새롭게 저장될 zipDir 폴더 생성
                        obj.createNewDir(obj.zipDirP);
                        
                        // 4. idml 폴더를 루프하여, idml 파일을 zip 확장자로 변경, zipDir 폴더로 복사하기 
                        changeExtIdmltZip ceiz = new changeExtIdmltZip();
                        ceiz.loopIdml();
                        
                        // iso와 파일이름을 map 컬렉션으로 추출
                        isocurpath = ceiz.isocurpath;
                        
                    } catch (Exception e) {
                        msg = "";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                    updateProgress(40, 100);
                    updateMessage(String.valueOf(40));
                    
                    try {
                        // 4. zipDir 폴더내 zip 파일을 unzip 하기
                        unZip unzip = new unZip(); 
                        unzip.runUnzip();
                        
                        // 5. zipDir 폴더내 zip 파일 삭제
                        deleteZipF();
                        
                    } catch(Exception e) {
                        msg = "";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                    updateProgress(50, 100);
                    updateMessage(String.valueOf(50));
                    
                    try {
                        // 6. unzip한 idml 폴더내의 designmap.xml 파일에 접근
                        accessDesignmap ad = new accessDesignmap();
                        ad.eachDirs(isocurpath);
                        
                    } catch(Exception e) {
                        msg = "";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                    updateProgress(60, 100);
                    updateMessage(String.valueOf(60));
                    
                    try {
                        // 7. map 컬렉션으로 'idml 이름 : doc0 객체' 형태로 모은 eachIdmlCollect 컬렉션을 가져와 Map 컬렉션으로 모음
                        Map<String, Element> eachIdmlCollect = storyesMerged.getIdmlCollect();
                        
                        // 8. 7번에서 모은 Map 컬렉션을 idml별로 파일로 추출
                        createEachIdmlFiles eif = new createEachIdmlFiles(eachIdmlCollect); 
                        eif.runEachIdmlFiles();
                        
                        eachIdmlCollect.clear();
                    } catch(Exception e) {
                        msg = "";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                    updateProgress(70, 100);
                    updateMessage(String.valueOf(70));
                    
                    try {
                        // 2. Excel 데이터 추출
                        excelMain excelmain = new excelMain();
                        excelmain.runExcelMain();
                        
                    } catch(Exception e) {
                        msg = "";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                    updateProgress(80, 100);
                    updateMessage(String.valueOf(80));

                    try {            
                        // 3. 각 소스 반복 하여 XSLT 돌리기
                        String eachSrcS = obj.tempDir + File.separator + "eachSrc";
                        Path eachSrcP = Paths.get(eachSrcS);
                        
                        srcRunRepeat srr = new srcRunRepeat(eachSrcP);
                        srr.runEachSrc();
                        
                    } catch(Exception e) {
                        msg = "";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                    updateProgress(90, 100);
                    updateMessage(String.valueOf(90));
                    
                    // 탬플릿 폴더 복사
                    try {
                        copyFTPTempls cft = new copyFTPTempls();
                        cft.runFTPTempls();
                         
                    } catch (Exception e) {
                        msg = "ftp templates 복사 실패";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                        
                    }

                    System.out.println("작업 끝");
                    
                    
                    return null;
                }
                
                @Override
                protected void succeeded() {
                    System.out.println("succeeded(): 최종 완료");
                    
                    updateProgress(95, 100);
                    updateMessage(String.valueOf(95));
                    
                    try {
                        String str = saveDirs();
                        
                        if(str != null) {
                            msg = "저장 폴더가 지정되지 않았습니다.";
                            failed();
                        }
                        
                    } catch (Exception e) {
                        msg = "ftp 저장 실패";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                    updateProgress(0, 100);
                    updateMessage(String.valueOf(0));
                    
                    return;
                }
                
                @Override
                protected void failed() {
                    System.out.println("failed(): " + msg);
                    customException(msg);
                                        
                    // Progressbar 초기 상태로 변경
                    updateProgress(0, 100);

                    if(!userName.matches("SMC") && Files.isDirectory(obj.xslsDir)) {
                        delXSLT();

                    }
                    
                    activateControl();
                    
                    return;
                    
                }
                
            };
            
            Thread thread2 = new Thread(task2);
            thread2.setDaemon(true);
            thread2.start();
            
            pbar1.progressProperty().bind(task2.progressProperty());
            pbart1.textProperty().bind(task2.messageProperty());
           
        }

    }
    
    
    public void deleteZipF() {
        System.out.println("deleteZipF() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(obj.zipDirP);
            
            ds.forEach(a -> {
                if(a.getFileName().toString().endsWith(".zip")) {
                    try {
                        Files.delete(a);
                    } catch (IOException e) {
                        msg = "zipDir 폴더내 zip 파일 삭제 실패";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                }
                
            });
            
        } catch(Exception e) {
            msg = "zipDir 폴더내 zip 파일 삭제 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        }
        
        
    }

    public void SelectedLangFullPath() throws Exception {
        System.out.println("SelectedLangFullPath 시작");
        
        try {
            obj.matchlangMap.forEach((k,v) -> {
                String lang = k;
                String isocode = v;
                
                Path fullpathP = Paths.get(obj.srcPathP + File.separator + isocode);
                srcDirFullpath.add(fullpathP);
                
            });
            obj.srcDirFullpath.addAll(srcDirFullpath);
            
            
        } catch(Exception e) {
            msg = "언어목록 추출 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        }
        
        
    }
    
    
    public void exedExcel() {
        String command = obj.resourceDir + "/excel-template/template1.xlsx";        
        ProcessBuilder builder = new ProcessBuilder();
        
        Process process = null;
        builder.redirectErrorStream(false);
        builder.command("cmd.exe", "/c", command);
        try {
            process = builder.start();

            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    }
    
    
    public void getISO() {
        System.out.println("getISO() 시작");
        
        langL2.forEach(a -> {
            String lang = a;
            
            langMap.forEach((k,v) -> {
                if(k.equals(lang)) {
                    obj.matchlangMap.put(lang, v);
                }
            });
        });
        
    }
    
    public void openDialog() {
        System.out.println("openDialog() 시작");
        
        DirectoryChooser dc = new DirectoryChooser();
        File selectedDir = dc.showDialog(primaryStage);
        
        try {
            String selectedDirPath = selectedDir.getPath();
            
            if (selectedDirPath != null) {
                tf1.setText(selectedDirPath);
                srcP = Paths.get(selectedDirPath);
                obj.srcPathP = srcP;
                
            }
            
        } catch(Exception e) {

        }
        
        
    }
    
    public void langPop() {
        System.out.println("langPop 시작");
        
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        dg.setTitle("언어 선택 팝업창");
        
        
        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/fxcontroller/langpop.fxml"));
            
            Button pbt1 = (Button) parent.lookup("#pbt1");
            Button pbt2 = (Button) parent.lookup("#pbt2");
            ComboBox<String> pcb1 = (ComboBox) parent.lookup("#pcb1");
            
            List<String> pcbL = new ArrayList<String>();
            typelangMap.forEach((k,v) -> {
                String type = k;
                List<String> langL = v;
                
                pcbL.add(type);
            });            
            
            pcb1.setItems(FXCollections.observableArrayList(pcbL));
 
            
            ListView<String> plv1 = (ListView) parent.lookup("#plv1");
            ListView<String> plv2 = (ListView) parent.lookup("#plv2");

            Set<String> keyset = langMap.keySet();
            List<String> langL = new ArrayList<>(keyset);

            
            langL.sort(Comparator.naturalOrder());
            
            langL.remove("English");
            langL.remove("Korean");

            langL.add(0, "English");
            langL.add(1, "Korean");
            
            
            pcb1.getSelectionModel().selectedItemProperty().addListener(new ChangeListener<String>() {
                @Override
                public void changed(ObservableValue<? extends String> observable, String oldValue, String newValue) {
                    System.out.println("Selected value : " + newValue);
                    
                    if(typelangMap.containsKey(newValue)) {
                        plv2.setItems(FXCollections.observableArrayList(typelangMap.get(newValue)));
                        
                    }
                    
                }
            });
            langL2.clear();
            plv1.setItems(FXCollections.observableArrayList(langL));
            plv1.getSelectionModel().setSelectionMode(SelectionMode.MULTIPLE);
            plv2.getSelectionModel().setSelectionMode(SelectionMode.MULTIPLE);
            pbt1.setOnAction(e -> addList(dg, langL2, plv1, plv2));
            pbt2.setOnAction(e -> removeList(dg, langL2, plv1, plv2));
            
            
            plv2.setCellFactory(lv -> {
                ListCell<String> cell = new ListCell<>();
                ContextMenu contextMenu = new ContextMenu();

                MenuItem prevItem = new MenuItem();
                prevItem.textProperty().bind(Bindings.format("앞으로 이동", cell.itemProperty()));
                
                prevItem.setOnAction(event -> {
                    String curitem = cell.getItem();
                    int itemidx = cell.getIndex(); 
                    
                    if (itemidx != 0) {
                        String previtem = plv2.getItems().get(itemidx-1);
                        System.out.println("itemidx: " + itemidx + ", item:" + curitem);
                        System.out.println("previtem: " + previtem);
                        
                        plv2.getItems().set(itemidx-1, curitem);
                        plv2.getItems().set(itemidx, previtem);
                        
                    }

                });
                
                MenuItem nextItem = new MenuItem();
                nextItem.textProperty().bind(Bindings.format("뒤로 이동", cell.itemProperty()));

                nextItem.setOnAction(event -> {
                    String curitem = cell.getItem();
                    int itemidx = cell.getIndex(); 
                    int lastidx = plv2.getItems().size();

                    if (itemidx+1 != lastidx) {
                        String nextitem = plv2.getItems().get(itemidx+1);
                        plv2.getItems().set(itemidx+1, curitem);
                        plv2.getItems().set(itemidx, nextitem);

                    } 

                });
                
                contextMenu.getItems().addAll(prevItem, nextItem);
                
                cell.textProperty().bind(cell.itemProperty());
                cell.emptyProperty().addListener((obs, wasEmpty, isNowEmpty) -> {
                    if (isNowEmpty) {
                        cell.setContextMenu(null);
                    } else {
                        cell.setContextMenu(contextMenu);
                    }
                });                
                
                return cell;
            });

            Scene scenePop = new Scene(parent);
            dg.setScene(scenePop);
            dg.setResizable(false);
            dg.show();
            Point2D point = parent.localToScene(100, 100);
            dg.setX(primaryStage.getX() + point.getX());
            dg.setY(primaryStage.getY() + point.getY());
            
            dg.setOnCloseRequest(event -> {
                langL.clear();
                langL2.addAll(plv2.getItems());
                obj.langL2.addAll(langL2);
                bt2.setStyle(
                    "-fx-border-color: #c1c3c9;" +  
                    "-fx-background-color: #f0eece;"
                );
                pcbL.clear();
                
            });
            
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    }
    
    public void removeList(Stage e, List<String> langL2, ListView<String> plv1, ListView<String> plv2) {
        System.out.println("removeList() 시작");
        
        langL2.removeAll(plv2.getSelectionModel().getSelectedItems());
        plv2.setItems(FXCollections.observableArrayList(langL2));
            
    }
    
    public void addList(Stage e, List<String> langL2, ListView<String> plv1, ListView<String> plv2) {
        System.out.println("addList() 시작");

        if (langL2.size() > 1) {
            System.out.println("언어가 하나 이상 입니다.");
            List<String> list3 = new ArrayList<>();
            
            list3.addAll(plv1.getSelectionModel().getSelectedItems());
            Set<String> set = new HashSet<String>(list3);        
            for (String str : set) {            
                int cnt = Collections.frequency(langL2, str);
                
                if(cnt == 1) {
                    for(int u=0;u<plv2.getItems().size(); u++) {
                        String item = plv2.getItems().get(u);
                        
                        if(str.equals(item)) {
                            langL2.remove(str);
                            langL2.add(u, str);
                            
                        }
                    }
                        
                } else if(cnt < 1) {
                    System.out.println(str + " : " + Collections.frequency(langL2, str));
                    langL2.add(str);
                }
               
            }
            
            list3.clear();
            
        } else { 
            System.out.println("언어가 하나 입니다.");
            langL2.addAll(plv1.getSelectionModel().getSelectedItems());
            
        }

        plv2.setItems(FXCollections.observableArrayList(langL2)); 
        
    }
    
    
    public void loadLangs() {
        System.out.println("loadLangs() 시작");

        // 1. 언어 목록 엑셀을 xml로 변환
        getLangs gl = new getLangs();
        gl.runLangs();
        
        
        try {
            // 2. language.xml 파일 읽기
            readlangxml rl = new readlangxml();
            rl.runReadF();

            langMap.putAll(rl.langMap);

        } catch (Exception e) {
            String msg = "loadLangs 언어 목록 호출 실패";
//            customException(msg);
            e.printStackTrace();
        }
        

        try {
            // 3. type.xml 파일 읽기
            readtypexml rt = new readtypexml();
            typeL = rt.runtypeReadF();
            
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        try {
            // 3. version.xml 파일 읽기
            readverxml rt = new readverxml();
            verL = rt.runverReadF();
            
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        try {
            // 3. type-lang.xml 파일 읽기
            readtlxml rt = new readtlxml();
            typelangMap = rt.runtlReadF();
            
            /*
            typelangMap.forEach((k,v) -> {
                System.out.println("k: " + k + ", v: " + v);
                
            });*/
            
            
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        
    }
    
    public void setDirectoryPath() {
        System.out.println("setDirectoryPath() 시작");
        
        File file = new File("");
        
        try {
            // 패키지 경로
            projectDir = file.getAbsolutePath();
            obj.projectDir = projectDir;
//            System.out.println("projectDir: " + projectDir);
             
            
            // resource 경로
//            String resourceDir = projectDir + File.separator + "resource";
            String resourceDir = projectDir + File.separator + "jre/lib/resource";
            obj.resourceDir = Paths.get(resourceDir);
//            System.out.println("resourceDir: " + resourceDir);
            
            
            // xsls 경로
            String xslsDir = projectDir + File.separator + "jre/lib/xsls";
            obj.xslsDir = Paths.get(xslsDir);
            System.out.println("xslsDir: " + xslsDir);
            
            // Excel 템플릿 경로
            String excelTemplsPathS = resourceDir + File.separator + "excel-template"; 
            obj.excelTemplsPathP = Paths.get(excelTemplsPathS);
            
            
        } catch(Exception e) {
            msg = e.getMessage();
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
            
        }

    }
    
    public String saveDirs() {
        System.out.println("saveDirs() 메소드 시작");

        try {
            // 1. FXMLLoader.load() 메소드로 fxml 파일 로드
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/fxcontroller/saveDir.fxml"));
    
            // 커스텀 다이얼로그 생성하기
            // 2. Stage 객체 생성
            Stage stage = new Stage(StageStyle.UTILITY);
            stage.initModality(Modality.WINDOW_MODAL);
            stage.initOwner(primaryStage);
            stage.setTitle("FTP 서버에 저장될 경로를 입력 하세요.");
    
            // Label 컨트롤 찾기
            TextField saveLabel = (TextField) parent.lookup("#saveTF");
            
            // Button 컨트롤 찾기
            Button saveBT = (Button) parent.lookup("#saveBt");
//            saveBT.setDisable(true);
            
            // TextField 필드에 입력받은 텍스트가 2개 이상인 경우 Button 컨트롤 활성화
            saveLabel.textProperty().addListener(new ChangeListener<String>() {
                @Override
                public void changed(ObservableValue<? extends String> observalble, String oldValue, String newValue) {

                    String vals = newValue;
                    if(vals.length() > 3 && vals.startsWith("/")) {
                        System.out.println("vals: " + vals);
                        
                        saveBT.setDisable(false);
                        
                    } else {
                        saveBT.setDisable(true);
                    }
                    
                  
                }
    
            });
            
            saveBT.setOnAction(e -> saveBT(stage, saveLabel));
            
            // 4. Scene 객체 생성
            Scene scene = new Scene(parent);
            
            // 5. 다이얼로그에 Scene 객체 올리기
            stage.setScene(scene);
            stage.setResizable(false);
            stage.show();
            
            stage.setOnCloseRequest(event -> {
                if(Files.exists(obj.tempDir)) {
                    removeTemp();
                }
                
                activateControl();
                
                //------------------------------
                System.out.println("완료 팝업창");
                finishedPop();
                
            });
            
        } catch(Exception e) {
            e.printStackTrace();
        }
            
        
        
        return null;
    }
    
    
    // ftp 서버 디렉토리 삭제
    public void saveBT(Stage stage, TextField saveLabel) {
        labelTxt =  saveLabel.getText();
        
        stage.close();
        
        ftpRemoveDir ftpTemp = new ftpRemoveDir(labelTxt);
        
        ftpTemp.accessFTP();
        
        boolean stop = ftpTemp.checkingExists();
        System.out.println("stop: " + stop);
        
        
        if(stop == true) {
            checkingPopup(ftpTemp);
            
        } else {
            try {
                ftpTemp.ftpRemoveFolder();
                ftpUpLoad();
                
                if(Files.exists(obj.tempDir)) {
                    removeTemp();
                    
                    activateControl();
                    finishedPop();
                }

                //------------------------------
                System.out.println("완료 팝업창");

            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        
    }
    
    public void ftpUpLoad() throws Exception {
        System.out.println("ftpUpLoad() 시작");
        ftpUpLoad ftpU = new ftpUpLoad(labelTxt);
        
        ftpU.runFTP();
        
        
    }
    
    public void delXSLT() {
        System.out.println("delXSLT() 시작");

        if(!userName.matches("SMC")) {
            try {
                obj.recursDel(obj.xslsDir);
                
            } catch (Exception e) {
                msg = "xsls 삭제 예외가 발생되었습니다.";
                System.out.println(msg);
                customException(msg);
                return;
            }
        }

    }
    
    public void DisabledControl() {
        cb1.setDisable(true);
        tf1.setDisable(true);
        tf2.setDisable(true);
        
        bt1.setDisable(true);
        bt2.setDisable(true);
        bt3.setDisable(true);
        bt4.setDisable(true);
        tf2.setDisable(true);
        tf3.setDisable(true);
        tobt1.setDisable(true);
        tobt2.setDisable(true);
        
    }
    
    public void activateControl() {
        cb1.setDisable(false);
        tf1.setDisable(false);
        tf2.setDisable(false);
        
        bt1.setDisable(false);
        bt2.setDisable(false);
        bt3.setDisable(false);
        bt4.setDisable(false);
        tf2.setDisable(false);
        tf3.setDisable(false);
        tobt1.setDisable(false);
        tobt1.setSelected(false);
        tobt2.setDisable(false);
        tobt2.setSelected(false);
        tf3.setDisable(true);
        
        langL.clear();
        langL2.clear();
        typeL.clear();
        verL.clear();
        srcFullPath.clear();
        srcDirFullpath.clear();
        isocurpath.clear();
        
        obj.srcPathP = null;
        obj.tempDir = null;
        obj.zipDirP = null;
        obj.eachSrcP = null;
        obj.srcDirFullpath.clear();
        obj.workISO.clear();
        obj.matchlangMap.clear();
        
        
        obj.type = "";
        obj.ridioTxt = "";
        obj.modelNumber = "";
        obj.ver = "";
        obj.remoteswitch = "";
        obj.remoconTxt = "";
        obj.manualType = "";
        obj.langL2.clear();
        
        tobt1.setStyle("-fx-border-color: #c1c3c9;");
        
        tobt2.setStyle("-fx-border-color: #c1c3c9;");
        tf3.setStyle("-fx-border-color: #c1c3c9;");
        bt2.setStyle("-fx-border-color: #c1c3c9;");
    }
    
    public void workStartMi1(String excelfile) {
        System.out.println("Mi1, Excel 업로드");

        Task<Void> task2 = new Task<Void>() {
            @Override
            protected Void call() {
                try {
                    uploadExcel(excelfile);

                } catch (Exception e1) {
                    e1.getMessage();
                }
                
                return null;
            }
            
            @Override
            protected void succeeded() {
                System.out.println("succeeded(): 최종 완료");
                
                finishedPop();
            }
            
            @Override
            protected void failed() {
                System.out.println("failed(): " + msg);
                customException(msg);
                
                
                
            }
        };
                
        Thread thread2 = new Thread(task2);
        thread2.setDaemon(true);
        thread2.start();

    }
    
        
    public void uploadExcel(String excelfile) {
        System.out.println("uploadExcel() 시작");
        
        // FTP 접속을 위한 FTPClient 객체 선언 
        FTPClient client = new FTPClient();
        
        try {
            // connection 환경에서 인코딩 타입 설정
            client.setControlEncoding("EUC-KR");
            
            // ftp 접속 주소 설정
            client.connect("10.10.10.2", 21);
            int resultCode = client.getReplyCode();
            if(!FTPReply.isPositiveCompletion(resultCode)) {
                System.out.println("FTP server refused connection!!");
                return;
                
            } else {
                client.setSoTimeout(1000);
                
                // 로그인 하기
                String id = "sonminchan";
                String pw = "astkorea1234";
                
                if(!client.login(id, pw)) {
                    System.out.println("접속 실패");
                    msg = "로그인 정보(ID, PW)가 잘못 되었습니다.";
                    return;
                } else {
                    System.out.println("로그인 완료");
                }
                
                String exceltemplsF = excelfile;
                Path path = Paths.get(excelfile);
                String filename = path.getFileName().toString();
                String ftppath = "/tcs/confidential/Martian/resource/excel-template/" + filename;
                
                // 파일 InputStream을 가져온다.
                FileInputStream fis = new FileInputStream(exceltemplsF);
                client.setFileType(client.BINARY_FILE_TYPE);
                client.storeFile(ftppath, fis);
                System.out.println("Upload - " + exceltemplsF);
                client.logout();
                System.out.println("ftpDownload 끝");

            }
            
        } catch (Exception e1) { 
            e1.printStackTrace();
//            throw new Exception("서버에 접속할 수 없습니다.");
            
        } finally {
            try {
                if (client.isConnected()) {
                    System.out.println("서버 연결 해제 성공");
                    client.disconnect();
                }
                
            } catch (Exception e2) { 
            }
        }
        
        
    }
    

    public void checkingPopup(ftpRemoveDir ftpTemp) {
        System.out.println("checkingPop() 시작");

        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        dg.setTitle("작업이 완료 되었습니다.");
        
        try {
            // FXMLLoader.load() 메소드로 popup.fxml 파일 로드
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("main/fxcontroller/checkingftp.fxml"));
            
            // 버튼 속성을 가진 객체를 찾기 - lookup() 메소드
            Button continueBt = (Button) parent.lookup("#continueBt");
            Button stopBt = (Button) parent.lookup("#stopBt");
            
            continueBt.setOnAction(e -> {
                try {
                    dg.close();
                    
                    ftpTemp.ftpRemoveFolder();
                    ftpUpLoad();
                    
                    if(Files.exists(obj.tempDir)) {
                        removeTemp();
                        
                    }
                    
                    activateControl();
                    
                    //------------------------------
                    System.out.println("완료 팝업창");
                    finishedPop();
                    
                    
                } catch (Exception e2) {
                    e2.printStackTrace();
                }
            });
            
            stopBt.setOnAction(e -> {
//                activateControl();
//                dg.close();
                System.out.println("stopBt 클릭!!!");
                
                if(Files.exists(obj.tempDir)) {
                    removeTemp();
                    
                }
                
                activateControl();
                
                //------------------------------
                System.out.println("완료 팝업창");
                finishedPop();
            });
            
           
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
            e1.printStackTrace();
        }
    }
    
    public void removeTemp() {
        System.out.println("removeTemp() 시작");
        /*
        try {
            obj.recursDel(obj.tempDir);
               
        } catch (Exception e3) {
            msg = "temp 폴더 삭제 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
            
        }*/

    }
    
    
    
}
