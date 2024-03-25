package TEST01;


import java.io.File;
import java.net.URL;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.concurrent.Task;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Point2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.ProgressIndicator;
import javafx.scene.control.RadioButton;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.ToggleGroup;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.DragEvent;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.TransferMode;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;

public class RC implements Initializable  {
    @FXML private TableView<createTableColumn> tab1TV1;
    @FXML private TableView<createTableColumn> tab1TV2;
    @FXML private Button btz1;
    @FXML private Button btz2;
    @FXML private ProgressIndicator pb;
    

    private Stage primaryStage;
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }
    
    private ObservableList<createTableColumn> fileList = FXCollections.observableArrayList(); 
    private List<File> passList = new ArrayList<>();
    File mergedFile;
    String version;
    String lang;
    String modelStr;
    boolean stop = false;
    static File finalFile;
    String srcPath;
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        tab1TV1.setOnDragOver(e -> dragOver(e));
        tab1TV2.setOnDragOver(e -> dragOver(e));
        tab1TV1.setOnDragDropped(e -> dragDrop(e));
        tab1TV2.setOnDragDropped(e -> dragDrop(e));
        btz1.setOnAction(e -> selecPop());
        btz2.setOnAction(e -> startZ2());
        
        // Delete 키 입력시 목록 삭제
        tab1TV1.setOnKeyPressed(e -> delList(e));
    }
    
    // 파일을 드레그 오버한 경우
    private void dragOver(DragEvent e) {
        if(e.getGestureSource() != tab1TV1 && e.getDragboard().hasFiles() || e.getGestureSource() != tab1TV2 && e.getDragboard().hasFiles()) {
            tab1TV1.setStyle(
                "-fx-border-color: red;" +  
                "-fx-background-color: ANTIQUEWHITE;"
            );
            
            tab1TV2.setStyle(
                "-fx-border-color: green;" +  
                "-fx-background-color: ANTIQUEWHITE;"
            );
            
            e.acceptTransferModes(TransferMode.COPY_OR_MOVE);
        }
        e.consume();
    }
    
    
    // 파일을 드래그 드롭한 경우
    private void dragDrop(DragEvent e) {
        if (e.getGestureSource() != tab1TV1 && e.getDragboard().hasFiles() || e.getGestureSource() != tab1TV2 && e.getDragboard().hasFiles()) {
            List<File> list = e.getDragboard().getFiles();
            
            for(int i=list.size()-1; i>=0; i--) {
                if(list.get(i).isDirectory()) {
                    list.remove(i);
                }
            }
            
            

            createTableList ctl = new createTableList(list);
            fileList = ctl.runCTL();
            
            // 드래그 앤 드랍으로 놓은 위치가 tab1TV1 인 경우,
            if(e.getGestureTarget() == tab1TV1) {
                fillTableColumn(fileList, tab1TV1);
                
            } else if(e.getGestureTarget() == tab1TV2) {
                if(fileList.size() == 1) {
                    srcPath = fileList.get(0).getAbfile().getParent().toString(); 
                    
                }
                
                fillTableColumn(fileList, tab1TV2);
            }
        }
    }
    
    private void fillTableColumn(ObservableList<createTableColumn> fileList, TableView<createTableColumn> tv) {
        TableColumn tc = tv.getColumns().get(0);
        tc.setCellValueFactory(new PropertyValueFactory("filename"));
        tc.setStyle("-fx-alignment: CENTER;");
        
        tc = tv.getColumns().get(1);
        tc.setCellValueFactory(new PropertyValueFactory("size"));
        tc.setStyle("-fx-alignment: CENTER;");
        
        tv.setItems(fileList);
        
        tv.getSelectionModel().setSelectionMode(SelectionMode.MULTIPLE);
    }
    
    private void startZ11() throws Exception {
        System.out.println("startZ11() 시작");
        // start 버튼 클릭시 cell 항목 선택 해제
        tab1TV1.getSelectionModel().clearSelection();
        
        // 항목 추출
        ObservableList<createTableColumn> tableItems = tab1TV1.getItems();
        List<createTableColumn> tableList = new ArrayList<createTableColumn>(tableItems);
        Iterator<createTableColumn> it = tableList.iterator();
       
        File mcbook = null;
        while(it.hasNext()) {
            // 하나씩 추출
            createTableColumn file = it.next();
            
            File abFilePath = file.getAbfile();
            
            if(file.getFilename().endsWith(".mcbook")) {
                mcbook = abFilePath;
            } 
            passList.add(abFilePath);
        }
        
        BomtoNormal bn = new BomtoNormal(passList);
        
        try {
            bn.bomCheck();
        } catch (Exception e2) {
            
            String msg = e2.getMessage();
            selectedPopup(msg);
        }
       
        List<File> sortFiles = null;
        if(mcbook != null) {
            sortFiles = mcAttr(mcbook);            
        } else {
            sortFiles = passList;
        }
        
        // temp 폴더 만들기
        deleteFolder df = new deleteFolder();
        df.runFindFolder();
        
        // 원본 소스 html 파일의 경로 찾기
        srcPath = passList.get(0).getParent();
        createMerged cm = new createMerged(sortFiles);
        try {
            mergedFile = cm.runMerged();
        } catch (Exception e2) {
            
            String msg = e2.getMessage();
            selectedPopup(msg);
        }
        
        String switch1 = "getfinal";

        if (version.equals("2022")) {
            // input, output, xslt 경로 지정하기
            IOXPath ioxpath = new IOXPath(mergedFile);
            List<IOXclasses> setList = ioxpath.setList();
            xslTransform xtf = new xslTransform(setList, srcPath, switch1);
            xtf.runXslt();
            
        } else if(version.equals("2019")) {
            IOXPath2019 ioxpath2019 = new IOXPath2019(mergedFile);
            List<IOXclasses> setList = ioxpath2019.setList();
            
            xslTransform xtf = new xslTransform(setList, srcPath, switch1);
            xtf.runXslt();
             
        } 
    }
    
    
    private List<File> mcAttr(File mcbook) {
        attrMcLink amk = new attrMcLink(mcbook, passList);
        List<File> sortFiles = null;
        
        try {
            sortFiles = amk.runXpath();         
        } catch(Exception e5) {
            String msg = e5.getMessage();
            String result = "mcAttr() : {0} 예외 발생";
            String result1 = MessageFormat.format(result, msg);
        }
        return sortFiles;
    }
    
    private void finishPop(String msg) {
        Stage dg = new Stage(StageStyle.UNDECORATED);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        URL popUR = RC.class.getClassLoader().getResource("TEST01/fxml/finishPop.fxml");
        FXMLLoader loader = new FXMLLoader(popUR);
        
        try {
            Parent finishPop = loader.load();
            Label popLb = (Label) finishPop.lookup("#finishLv");
            popLb.setText(msg);
            popLb.setOnMouseClicked(event -> dg.close());
            
            // Scene 객체 생성
            Scene scenePop = new Scene(finishPop);
            dg.setScene(scenePop);
            dg.setResizable(false);
            dg.show();
            
            Point2D point = finishPop.localToScene(70.0, 100.0);
            dg.setX(primaryStage.getX() + point.getX());
            dg.setY(primaryStage.getY() + point.getY());

        } catch(Exception e6) {
            String msg1 = e6.getMessage();
            String result = "finishPop() : {0} 예외 발생";
            String result1 = MessageFormat.format(result, msg1);
        }
    }
    
    private void selecPop() { 
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        URL popUR = RC.class.getClassLoader().getResource("TEST01/fxml/selecVer.fxml");
        FXMLLoader loader = new FXMLLoader(popUR);

            try {
                Parent selecPop = loader.load();
                Map<String, Object> fxmlNamespace = loader.getNamespace();
                ToggleGroup toggleVer = (ToggleGroup) fxmlNamespace.get("ver");
                ToggleGroup toggleLang = (ToggleGroup) fxmlNamespace.get("lang");
                
                Button verBt1 = (Button) selecPop.lookup("#verBt1");
                Button verBt2 = (Button) selecPop.lookup("#verBt2");
                TextField txtf = (TextField) selecPop.lookup("#txtField");
                verBt1.setOnAction(e -> toggleList(dg, toggleVer, toggleLang, txtf));

                Scene scenePop = new Scene(selecPop);
                dg.setScene(scenePop);
                dg.setResizable(false);
                dg.show();
                
            } catch (Exception e7) {
                String msg1 = e7.getMessage();
                String result = "selecPop() : {0} 예외 발생";
                String result1 = MessageFormat.format(result, msg1);
            } 
            
    }
    
    
    private void toggleList(Stage e, ToggleGroup toggleVer, ToggleGroup toggleLang, TextField txtf) {
        String strVer = toggleVer.getSelectedToggle().toString();
        String strLang = toggleLang.getSelectedToggle().toString();
        RadioButton selectedVer = (RadioButton) toggleVer.getSelectedToggle();
        version = selectedVer.getText();
        RadioButton selectedLang = (RadioButton) toggleLang.getSelectedToggle();
        lang = selectedLang.getText();
        modelStr = txtf.getText();
        
        try {
            createConfigF cf = new createConfigF(modelStr, version, lang);
            cf.runProps();
            
        } catch (Exception e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        
        e.close();

        Task<Void> task = new Task<Void>() {
            String msg = "";
            @Override
            protected Void call() {
                while(!stop) {
                    try {
                        Thread.sleep(10);
                    } catch(InterruptedException ee) {
                        msg = ee.getMessage();
                    }
                }
                updateProgress(0, 0);

                return null;
            }
            
            @Override
            protected void succeeded() {
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
        
        Task<Void> task1 = new Task<Void>() {
            String msg ="";
            @Override
            protected Void call() {
                try {
                    startZ11();
                } catch (Exception e) {
                    msg = e.getMessage();
                    failed();
                }
               
                return null;
            }
            
            @Override
            protected void succeeded() {
                String msg = "finalize.html 파일을 생성 하였습니다. 작업을 계속 하려면 해당 창을 클릭하여 닫아 주세요.";
                finishPop(msg);
                stop = true;
            }
            
            @Override
            protected void failed() {
                selectedPopup(msg);
                return;
            }
        };
        
        Thread thread2 = new Thread(task1);
        thread2.setDaemon(true);
        thread2.start();
    }
    
    private void startZ2() {
        stop = false;
        tab1TV2.getSelectionModel().clearSelection();
        
        // 항목 추출
        ObservableList<createTableColumn> tableItems = tab1TV2.getItems();
        List<createTableColumn> tableList = new ArrayList<createTableColumn>(tableItems);
        Iterator<createTableColumn> it = tableList.iterator();
        
        // properties 파일 로드
        createConfigF cf = new createConfigF();
        List<String> propsList = cf.readProps();

        for(int y =0; y<propsList.size(); y++) {
            if(y == 0) {
                modelStr = propsList.get(y);
                
            } else if(y == 1) {
                version = propsList.get(y);
                
            } else if(y == 2) {
                lang = propsList.get(y);
                
            }
            
        }

        while(it.hasNext()) {
            // 하나씩 추출
            createTableColumn file = it.next();
            
            File abFilePath = file.getAbfile();
            finalFile = abFilePath;
        }
             
        Task<Void> task = new Task<Void>() {
            String msg ="";
            
            @Override
            protected Void call() {
                while(!stop) {
                    try {
                        Thread.sleep(10);
                    } catch(InterruptedException ee) {
                    }
                }
                updateProgress(0, 0);

                return null;
            }
            
            @Override
            protected void succeeded() {
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
        
        Task<Void> task1 = new Task<Void>() {
            String msg = "";
            String switch1 = "html";
            
            @Override
            protected Void call() {
                if (version.equals("2022")) {
                    IOXPath ioxpath = new IOXPath(finalFile); 
                    List<IOXclasses> setList = ioxpath.setList02();
                    xslTransform xtf = new xslTransform(setList, modelStr, lang, srcPath, switch1);
                    
                    try {
                        xtf.runXslt();
                        xtf.copyTemplates(null);
                        
                    } catch (Exception e) {
                        msg = e.getMessage();
                        failed();
                    }
                    
                } else if(version.equals("2019")) {
                    IOXPath2019 ioxpath2019 = new IOXPath2019(finalFile); 
                    List<IOXclasses> setList = ioxpath2019.setList02();
                    xslTransform xtf = new xslTransform(setList, modelStr, lang, srcPath, switch1);

                    try {
                        xtf.runXslt();
                        xtf.copyTemplates(null);
                        
                    } catch (Exception e) {
                        msg = e.getMessage();
                    }
                }
                return null;
            }
            
            @Override
            protected void succeeded() {
                // 완료 팝업창
                String msg = "html 변환이 완료 되었습니다. 작업을 계속 하려면 해당 창을 클릭하여 닫아 주세요.";
                finishPop(msg);
                stop = true;
            }
            
            @Override
            protected void failed() {
                selectedPopup(msg);
                return;
            }
        };
        
        Thread thread2 = new Thread(task1);
        thread2.setDaemon(true);
        thread2.start();
        
    }
    
    private void delList(KeyEvent keyevent) {
        createTableColumn selectedItem = tab1TV1.getSelectionModel().getSelectedItem();
        
        if(selectedItem != null) {
            if(keyevent.getCode().equals(KeyCode.DELETE)) {
                tab1TV1.getItems().remove(selectedItem);
            }
        }
    }
    
    private void selectedPopup(String msg) {
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        try {
            // FXMLLoader.load() 메소드로 팝업 로드
            URL popUR = RC.class.getClassLoader().getResource("TEST01/fxml/selectedException.fxml");
            FXMLLoader loader = new FXMLLoader(popUR);
            Parent parent = loader.load(); 
            Button sebt = (Button) parent.lookup("#sebt");
            sebt.setOnAction(ev -> dg.close());
            Label selb = (Label) parent.lookup("#seLabel");
            selb.setText(msg);
            
            // Scene 객체 생성
            Scene scenePop = new Scene(parent);
            dg.setScene(scenePop);
            dg.setResizable(false);
            dg.show();
            
            Point2D point = parent.localToScene(100.0, 100.0);
            dg.setX(primaryStage.getX() + point.getX());
            dg.setY(primaryStage.getY() + point.getY());
            
        } catch (Exception e8) {
            String msg1 = e8.getMessage();
            String result = "selectedPopup() : {0} 예외 발생";
            String result1 = MessageFormat.format(result, msg1);
        }
    }

}
