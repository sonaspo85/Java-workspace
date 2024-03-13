package DITA.fxcontroller;

import java.io.File;
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

import org.w3c.dom.Element;

import DITA.Common.implementOBJ;
import DITA.excelcontroller.excelMain;
import DITA.excelcontroller.getLangs;
import DITA.ftp.ftpRemoveDir;
import DITA.ftp.ftpUpLoad;
import DITA.idmlcontroller.accessDesignmap;
import DITA.idmlcontroller.changeExtIdmltZip;
import DITA.idmlcontroller.createEachIdmlFiles;
import DITA.idmlcontroller.storyesMerged;
import DITA.othercontroller.copyFTPTempls;
import DITA.othercontroller.docInfo;
import DITA.othercontroller.readlangxml;
import DITA.othercontroller.readtypexml;
import DITA.othercontroller.srcRunRepeat;
import DITA.zipcontroller.unZip;
import javafx.beans.binding.Bindings;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.concurrent.Task;
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
import javafx.scene.control.RadioButton;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.TextField;
import javafx.scene.control.ToggleGroup;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.text.Text;
import javafx.stage.DirectoryChooser;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;


public class RC implements Initializable {
    @FXML private Button bt1;
    @FXML private Button bt2;
    @FXML private Button bt3;
    @FXML private Button bt4;
    @FXML private ComboBox<String> cb1;
    @FXML private TextField tf1;
    @FXML private TextField tf2;

    @FXML private ToggleGroup videoGroup;
    @FXML private RadioButton rb1;
    @FXML private RadioButton rb2;
    @FXML private ProgressBar pbar1;
    @FXML private Text pbart1;
    String userName = System.getProperty("user.name");  // SMC
    
    
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
    List<String> langL3 = new ArrayList<>();
    List<String> typeL = new ArrayList<>();
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
        
        // 초기 디렉토리 설정
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
        rb2.setSelected(true);
        tf1.setText("G:/MS-Drive/OneDrive - UOU/WORK/Workspace/WORK/JAVA/java-workspace/CE-Air_Html_Converter/srcDir");
        
        
        bt4.setOnAction(e -> exedExcel());
        

    }
    
    // 예외 발생시 호출될 메소드
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
        
        // FXMLLoader.load() 메소드로 팝업 로드
        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("DITA/fxcontroller/selectedException.fxml"));
            
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
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("DITA/fxcontroller/complePop.fxml"));
            
            // 버튼 속성을 가진 객체를 찾기 - lookup() 메소드
            Button bt = (Button) parent.lookup("#bt1");
            bt.setOnAction(event -> dg.close());
            
            // Label 컨트롤 찾기
            Label lb22 = (Label) parent.lookup("#txtTitle");
            lb22.setText("작업이 완료 되었습니다.");
            
            
            
            // 이미지 교체
            InputStream imgStream = RC.class.getClassLoader().getResourceAsStream("DITA/fxcontroller/complete.png");
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
    
    public void stWork() {
        System.out.println("stWork() 시작");

        String tfTxt = tf1.getText();
        System.out.println("tfTxt: " + tfTxt);
        if(tfTxt == "") {
            // textfield 값 추출
            tfTxt = tf1.getText();

        }
        
        obj.srcPathP = Paths.get(tfTxt);
        obj.modelNumber = tf2.getText();
        
        
        /*
        // type 목록 추출
        String type = cb1.getValue().toString();
        obj.type = type;
        // Radio 선택 목록 추출
        RadioButton selectedRadio = (RadioButton) videoGroup.getSelectedToggle();
        String radioTxt = selectedRadio.getText(); 
//        obj.ridioTxt = radioTxt;
          */      
        
        RadioButton selectedRadio = (RadioButton) videoGroup.getSelectedToggle();
        if(tf1.getText() == "" || cb1.getValue() == null || selectedRadio == null) {
            System.out.println("tf1.getText(): " + tf1.getText());
            System.out.println("cb1.getValue(): " + cb1.getValue().toString());
            System.out.println("selectedRadio: " + selectedRadio);
            
            
            
            msg = "type / 경로 / video on/off를 모두 선택해 주세요.";                    
            bt1.setDisable(false);
            customException(msg);
        } 
        
        else if(tf1.getText() != "" && cb1.getValue() != null && selectedRadio != null) {
            // type 목록 추출
            String type = cb1.getValue().toString();
            obj.type = type;
            
            // Radio 선택 목록 추출
            String radioTxt = selectedRadio.getText(); 
            obj.ridioTxt = radioTxt;
            
            Task<Void> task2 = new Task<Void>() {
                @Override
                protected Void call() {
                    // 1. 인터페이스에서 선택한 언어 목록의 ISO 코드를 절대 경로로 변환 후 실제 디렉토리가 있는 경로만 반복 진행
                    getISO();
                    
                    // temp 경로 설정
                    String tempDir = obj.srcPathP.toAbsolutePath() + File.separator + "temp";
                    obj.tempDir = Paths.get(tempDir);
//                    System.out.println("tempDir111: " + tempDir);
                    
                    // zipDir 경로 설정
                    String zipDirPathS = tempDir + File.separator + "zipDir"; 
                    obj.zipDirP = Paths.get(zipDirPathS);
//                    System.out.println("obj.zipDirP: " + obj.zipDirP);
                    
                    // output폴더 삭제 하기
                    try {
                        String outputpath = obj.srcPathP + "/output";
                        Path outputP = Paths.get(outputpath);
                        
                        if (Files.isDirectory(outputP)) {
                            System.out.println("outputP 폴더 삭제");
                            obj.recursDel(outputP);
                            
                        } 
                        if (Files.isDirectory(obj.tempDir)) {
                            System.out.println("tempDir 폴더 삭제");
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
                        
                        updateProgress(95, 100);
                        updateMessage(String.valueOf(95));
                        
                    } catch (Exception e) {
//                        msg = "xslt를 다운받지 못했습니다.";
//                        System.out.println("msg: " + msg);
                        e.printStackTrace();
                        
                    }
                    
                    
                    
                    
                    System.out.println("작업 끝");
                    
                    return null;
                }
                
                @Override
                protected void succeeded() {
                    System.out.println("succeeded(): 최종 완료");
                    // 작업 완료 팝업창
//                    finishedPop();
//                    activateControl();

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
                    System.out.println("failed(): " + msg);
                    customException(msg);
                    
                    // 버튼을 다시 활성화 하기
//                    activateControl();
                    
                    // Progressbar 초기 상태로 변경
//                    updateProgress(0, 100);
                    
                    System.out.println("task2 failed 예외 발생");
                    selectedPopup(msg);

                    if(!userName.matches("SMC") && Files.isDirectory(obj.xslsDir)) {
                        delXSLT(); 
                    }
                    stop = true;
                    
                    
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
                
                // 1. 각 소스 경로 생성
                Path fullpathP = Paths.get(obj.srcPathP + File.separator + isocode);
//                System.out.println("fullpathP: " + fullpathP);
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
        System.out.println("외부 엑셀 파일 실행 하기");
        
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
        

        System.out.println("끝!!!");
        
    }
    
    
    public void getISO() {
        System.out.println("getISO() 시작");
        
        langL2.forEach(a -> {
            String lang = a;
//            System.out.println("lang: " + lang);
            
            langMap.forEach((k,v) -> {
                if(k.equals(lang)) {
                    obj.matchlangMap.put(lang, v);
                    
//                    System.out.println("lang:" + lang);
                }
            });
        });
        
        System.out.println(obj.langL2.toString());

        
    }
    
    public void openDialog() {
        System.out.println("openDialog() 시작");
        
        // 디렉토리를 선택 하는 다이얼로그 띄우기
        DirectoryChooser dc = new DirectoryChooser();
        
        // 다이얼로그 띄우기 - showDialog(primaryStage) 메소드
        File selectedDir = dc.showDialog(primaryStage);
        
        String selectedDirPath = selectedDir.getPath();
//        System.out.println(selectedDirPath);
        
        if (selectedDirPath != null) {
            // textField에 경로 삽입하기
            tf1.setText(selectedDirPath);
            srcP = Paths.get(selectedDirPath);
            obj.srcPathP = srcP; 
        }
        
        
    }
    
    public void langPop() {
        System.out.println("langPop 시작");
        
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        dg.setTitle("언어 선택 팝업창");
        
        
        try {
            Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("DITA/fxcontroller/langpop.fxml"));
            
            
            // 3. 버튼 찾기
            Button pbt1 = (Button) parent.lookup("#pbt1");
            Button pbt2 = (Button) parent.lookup("#pbt2");
            ListView<String> plv1 = (ListView) parent.lookup("#plv1");
            ListView<String> plv2 = (ListView) parent.lookup("#plv2");
            
            
            Set<String> keyset = langMap.keySet();
            
            List<String> langL = new ArrayList<>(keyset);

            
            langL.sort(Comparator.naturalOrder());
            
            langL.remove("English");
            langL.remove("Korean");

            langL.add(0, "English");
            langL.add(1, "Korean");
            
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
                        
                        // 현재 목록을 앞으로 이동
                        plv2.getItems().set(itemidx-1, curitem);
                      
                        // 앞쪽 목록을 현재 목록 위치로 이동
                        plv2.getItems().set(itemidx, previtem);
                        
                    } else {
                        System.out.println("0번째 인덱스");
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
                        System.out.println("itemidx: " + itemidx + ", item:" + curitem);
                        System.out.println("nextitem: " + nextitem);
                        
                        // 현재 목록을 뒤로 이동
                        plv2.getItems().set(itemidx+1, curitem);
                      
                        // 뒤쪽 목록을 현재 목록 위치로 이동
                        plv2.getItems().set(itemidx, nextitem);
                        
                    } else  {
                        System.out.println("마지막 인덱스");
                    }

                });
                
                // contextMenu 컨트롤에 MenuItem 목록 추가 하기
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
            
            // 8. popup 객체의 위치 조정
            Point2D point = parent.localToScene(100, 100);
            dg.setX(primaryStage.getX() + point.getX());
            dg.setY(primaryStage.getY() + point.getY());
            
            
            dg.setOnCloseRequest(event -> {
                langL2.clear();
              langL2.addAll(plv2.getItems());
              obj.langL2.addAll(langL2);
              
//              System.out.println("langL2: " + langL2.toString());
                
            });
            
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    }
    
    public void removeList(Stage e, List<String> langL2, ListView<String> plv1, ListView<String> plv2) {
        System.out.println("removeList() 시작");
        
        // plv2 의 선택한 목록들을 langL2 목록에서 삭제 
        langL2.removeAll(plv2.getSelectionModel().getSelectedItems());
        // plv2 의 listview 항목들 다시 세팅
        plv2.setItems(FXCollections.observableArrayList(langL2));
            
    }
    
    public void addList(Stage e, List<String> langL2, ListView<String> plv1, ListView<String> plv2) {
        System.out.println("addList() 시작");

        if (langL2.size() > 1) {
            List<String> list3 = new ArrayList<>();
            
            list3.addAll(plv1.getSelectionModel().getSelectedItems());
            
            // ArrayList 원소 빈도수 출력        
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
                    System.out.println("한개도 없음, 중복 없음");
                    System.out.println(str + " : " + Collections.frequency(langL2, str));
                    langL2.add(str);
                }
               
            }
            
            
        } else {
            // plv1 listview 에서 선택한 목록들을 langL2 List 컬렉션으로 수집 
            langL2.addAll(plv1.getSelectionModel().getSelectedItems());
            
        }

        // plv2 listview 의 항목으로 추가하기
        plv2.setItems(FXCollections.observableArrayList(langL2)); 
        
        
        
        
//        langL3.clear();
//        langL3.addAll(plv2.getItems());
//        
//        System.out.println("langL3: " + langL3.toString());
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
        Parent parent = FXMLLoader.load(getClass().getClassLoader().getResource("DITA/fxcontroller/saveDir.fxml"));

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
        saveBT.setDisable(true);
        
        // TextField 필드에 입력받은 텍스트가 2개 이상인 경우 Button 컨트롤 활성화
        saveLabel.textProperty().addListener(new ChangeListener<String>() {
            @Override
            public void changed(ObservableValue<? extends String> observalble, String oldValue, String newValue) {
                if(saveLabel.getText().length() > 3) {
                    saveBT.setDisable(false);
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
        
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        stop = true;
        bt1.setDisable(true);
        return null;
    }
    
    
    // ftp 서버 디렉토리 삭제
    public void saveBT(Stage stage, TextField saveLabel) {
        labelTxt =  saveLabel.getText();
        
        stage.close();
        
        ftpRemoveDir ftpTemp = new ftpRemoveDir(labelTxt);
        try {
            // ftp 폴더 삭제
            ftpTemp.ftpRemoveFolder();
            
            // ftp 서버에 파일 업로드
            ftpUpLoad();
        } catch (Exception e1) {
            e1.getMessage();
        }
        
        
        
        //------------------------------
        System.out.println("완료 팝업창");
        
          
        finishedPop();
        stop = true;
        bt1.setDisable(true);
     
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
    
    
    
}