package main.java.satisfy.fxml;


import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Point2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.TabPane;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.Pane;
import javafx.scene.shape.Rectangle;
import javafx.stage.DirectoryChooser;
import javafx.stage.FileChooser;
import javafx.stage.FileChooser.ExtensionFilter;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import main.java.satisfy.Common.implementOBJ;
import main.java.satisfy.modules.Company;
import main.java.satisfy.modules.ExcelOutput;
import main.java.satisfy.modules.FilltableColumn;
import main.java.satisfy.modules.excelTxml;
import main.java.satisfy.modules.readDBXML;
import main.java.satisfy.modules.readFinallyDB;
import main.java.satisfy.modules.resultDB;
import main.java.satisfy.modules.transformXSLT;
import net.sf.saxon.lib.NamespaceConstant;


public class RC implements Initializable {
    implementOBJ obj = new implementOBJ();
    //------------------------------------------------
    @FXML private TableView<Company> tv1;
    @FXML private TableView<Company> tv2;
    @FXML private TableView<Company> tv3;
    @FXML private TableView<Company> tv4;
    @FXML private TableView<Company> tv5;
    @FXML private TableView<Company> tv6;
    
    //------------------------------------------------
    @FXML private TableColumn<Company, String> t1cell1;
    @FXML private TableColumn<Company, String> t1cell2;
    @FXML private TableColumn<Company, String> t1cell3;
    @FXML private TableColumn<Company, String> t1cell4;
    //------------------------------------------------
    @FXML private TableColumn<Company, String> t2cell1;
    @FXML private TableColumn<Company, String> t2cell2;
    @FXML private TableColumn<Company, String> t2cell3;
    @FXML private TableColumn<Company, String> t2cell4;
    @FXML private TableColumn<Company, String> t2cell5;
    //------------------------------------------------
    @FXML private TableColumn<Company, String> t3cell1;
    @FXML private TableColumn<Company, String> t3cell2;
    @FXML private TableColumn<Company, String> t3cell3;
    @FXML private TableColumn<Company, String> t3cell4;
    //------------------------------------------------
    @FXML private TableColumn<Company, String> t4cell1;
    @FXML private TableColumn<Company, String> t4cell2;
    @FXML private TableColumn<Company, String> t4cell3;
    @FXML private TableColumn<Company, String> t4cell4;
    @FXML private TableColumn<Company, String> t4cell5;
    //------------------------------------------------
    @FXML private TableColumn<Company, String> t5cell1;
    @FXML private TableColumn<Company, String> t5cell2;
    @FXML private TableColumn<Company, String> t5cell3;
    @FXML private TableColumn<Company, String> t5cell4;
    @FXML private TableColumn<Company, String> t5cell5;
    //------------------------------------------------
    @FXML private TableColumn<Company, String> t6cell1;
    @FXML private TableColumn<Company, String> t6cell2;
    @FXML private TableColumn<Company, String> t6cell3;
    @FXML private TableColumn<Company, String> t6cell4;
    @FXML private TableColumn<Company, String> t6cell5;
    @FXML private TableColumn<Company, String> t6cell6;
    //------------------------------------------------
    @FXML private TableColumn<Company, String> t8cell1;
    @FXML private TableColumn<Company, String> t8cell2;
    @FXML private TableColumn<Company, String> t8cell3;
    
    
    @FXML private TabPane tabpane;

    @FXML private ComboBox<String> cb;
    ObservableList<String> comboL = FXCollections.observableArrayList();
    
    @FXML private Label tv1lb1;
    
    //------------------------------------------------
    @FXML private Button tab1bt1;
    @FXML private Button tab1bt3;
    @FXML private Button tab1bt4;
    
    @FXML private Button exportH;
    @FXML private Button exportE;
    //------------------------------------------------
    @FXML private Pane tv8pane;
    @FXML private TableView<resultDB> tv8;
    @FXML private Rectangle tv8rec;
    @FXML private Label tv8lb;
    Boolean compareFlag = false;
    
    
    String msg = "";
    String projectDir = "";
    String tempDir = "";
    String dbDir = "";
    String teplsDir = ""; 
    String excelXDir = "";
    String htmlTemplsDir = "";
    //------------------------------------------------
    public ObservableList<Company> totalList1 = FXCollections.observableArrayList();
    public ObservableList<Company> totalList2 = FXCollections.observableArrayList();
    public ObservableList<Company> totalList3 = FXCollections.observableArrayList();
    public ObservableList<Company> totalList4 = FXCollections.observableArrayList();
    public ObservableList<Company> totalList5 = FXCollections.observableArrayList();
    public ObservableList<Company> totalList6 = FXCollections.observableArrayList();
    //------------------------------------------------

    FilltableColumn ftc = null;
    
    List<File> selectedFile = new ArrayList<>();
    
    private Stage primaryStage;
    public void setPrimaryStage(Stage primaryStage) {
        this.primaryStage = primaryStage;
    }
    
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
        
        // 초기 디렉토리 설정
        setDirectoryPath();
        
        //----------------------------------------
        // 정형화 형식 엑셀 시트 xml 변환
        tab1bt1.setOnAction(e -> openDialog());
        
        // 만족도 조사 엑셀 시트 xml 변환
        tab1bt4.setOnAction(e -> openSatisfyDialog());
        
        //------------------------------------------------
        // combobox 선택된 목록에 따라 db 파일 읽기
        readComboListF();
        
        // 업체 비교
        tab1bt3.setOnAction(e2 -> compareXslt());
        
        // 결과물을 html로 출력
        exportH.setOnAction(e -> exportHtml());
        exportE.setOnAction(e -> exportExcel());

    }
    
    public void exportHtml() {
        System.out.println("exportHtml() 시작");
                
        // XSLT 실행 
        transformXSLT tf = new transformXSLT(obj.tempDir);
        tf.setList3();
        
        try {
            String fromDirs = tempDir + "/finally.html";
            
            // finally.html 파일 및 templete 파일 복사하여 저장하기
            saveDirs(fromDirs);
            
            // 완료시 팝업창 출력
            String finalmsg = "html 출력이 완료 되었습니다.";
            exportFinally(finalmsg);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
    public void exportExcel() {
        System.out.println("exportExcel() 시작");

        try {
            // 엑셀 파일
            String formDirs = obj.tempDir + "/22-safety-grouping.xml";
            
            DirectoryChooser dc = new DirectoryChooser();
            dc.setTitle("저장 폴더를 선택 하세요.");
            File selectedDir = dc.showDialog(primaryStage);
            
            if (selectedDir == null) {
                msg = "저장 폴더가 지정되지 않았습니다.";
                throw new RuntimeException(msg);
                
            }
            
            // 저장 경로 지정
            String toDirs = selectedDir.getAbsolutePath() + File.separator + "vendor_evaluation_tool.xlsx";
            
            ExcelOutput pc = new ExcelOutput();
            HashMap<String, List<HashMap<String, Object>>> companyResults = pc.parsingXML(formDirs);
            
            pc.createExcelFile(companyResults, toDirs);
          
            // 완료시 팝업창 출력
            String finalmsg = "Excel 출력이 완료 되었습니다.";
            exportFinally(finalmsg);
          
        } catch (Exception e) {
            msg = e.getMessage();
            System.out.println("catch블록 msg: " + msg);
            
            errorPopup(msg);
            
        }
        
    }
    
    public String saveDirs(String fromDirs) throws Exception {
        System.out.println("saveDirs() 메소드 시작");
        
        DirectoryChooser dc = new DirectoryChooser();
        dc.setTitle("저장 폴더를 선택 하세요.");
        File selectedDir = dc.showDialog(primaryStage);
        
        if (selectedDir == null) {
            msg = "저장 폴더가 지정되지 않았습니다.";
            return msg;
        }
        
        File formF = new File(fromDirs);
        String filename = formF.getName();
        String toDirs = selectedDir.getAbsolutePath() + File.separator + filename;
        
        System.out.println("fromDirs: " + fromDirs);
        System.out.println("toDirs: " + toDirs);

        Path from = Paths.get(fromDirs);
        Path to = Paths.get(toDirs);
        
        try {
            Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 탬플릿 파일 저장하기
        Path htdfrom = Paths.get(htmlTemplsDir);
        Path htdto = Paths.get(selectedDir.toString());
        
        obj.dirCopy(htdto, htdfrom);
        
        return null;
    }
    
    public void readResultDoc() {
        System.out.println("readResultDoc() 시작");
        tv8pane.setVisible(true);
        String curName = cb.getSelectionModel().getSelectedItem();
        String tempDir = dbDir;
        Path tempP = Paths.get(tempDir);
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(tempP);
            
            ds.forEach(a -> {
                String getName = a.getFileName().toString().replace(".xml", "");
                String abpath = a.toAbsolutePath().toString();
                
                if(curName.equals(getName)) {
                    readFinallyDB rfd = new readFinallyDB();
                    rfd.runDBxml(abpath);

                    Map<Integer, Map<String, List<String>>> map = rfd.getFinalMap();                    
                    createResultTable(map);
                    
                }
                
            });
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        

    }
    
    public void createResultTable(Map<Integer, Map<String, List<String>>> finalDBmap) {
        System.out.println("createResultTable() 시작");
        ObservableList<resultDB> lll = FXCollections.observableArrayList();
        
        finalDBmap.forEach((k,v) -> {
            Map<String, List<String>> map = v;
            
            map.forEach((j,l) -> {
                String key3 = j;
                
                List<String> list = l;
                String cell2 = "";
                String cell3 = "";
                for(int p=0; p<list.size(); p++) {
                    cell2 = list.get(0);
                    cell3 = list.get(1);

                }
                
                resultDB resultdb = new resultDB(key3, cell2, cell3);
                lll.add(resultdb);
//                System.out.println("key3: " + key3);

            });

        });
        
        tv8pane.setVisible(true);
        
        TableColumn tc = tv8.getColumns().get(0);
        tc.setCellValueFactory(new PropertyValueFactory("type"));
        tc.setStyle("-fx-alignment:CENTER-LEFT; -fx-text-fill: blue; -fx-border-color: red; -fx-border-width: 0.2; -fx-font-size: 10pt;");
        
        tc = tv8.getColumns().get(1);
        tc.setCellValueFactory(new PropertyValueFactory("score"));
        tc.setStyle("-fx-alignment:CENTER; -fx-text-fill: blue; -fx-border-color: red; -fx-border-width: 0.2; -fx-font-size: 10pt;");
        
        tc = tv8.getColumns().get(2);
        tc.setCellValueFactory(new PropertyValueFactory("ranking"));
        tc.setStyle("-fx-alignment:CENTER; -fx-text-fill: blue; -fx-border-color: red; -fx-border-width: 0.2; -fx-font-size: 10pt;");
        
        tv8.setItems(lll);
    }
    
    public void compareXslt() {
        System.out.println("compareXslt() 시작");
        
        try {
            compareFlag = true; 
            
            // XSLT 실행 
            transformXSLT tf = new transformXSLT(obj.tempDir);
            tf.setList2();
            
            // combobox 선택된 목록에 따라 db 파일 읽기
            cb.getSelectionModel().select(1);
            cb.getSelectionModel().select(0);
            
            // 결과 파일 읽기
            readResultDoc();
            
            // 이상없이 완료시 버튼 색 변경
            setButtonStyle(tab1bt3);
            
            // 완료시 팝업창 출력
            String finalmsg = "업체 비교가 완료 되었습니다.";
            exportFinally(finalmsg);
            
        } catch(Exception e) {
            msg = e.getMessage();
            System.out.println("catch블록 msg: " + msg);
//                        throw new RuntimeException();

            errorPopup(msg);
        }
        
    }
    
    public void readComboListF() {
        System.out.println("readComboListF() 시작");

        cb.getSelectionModel().selectedItemProperty().addListener(new ChangeListener<String>() {
            @Override
            public void changed(ObservableValue<? extends String> observable, String oldValue, String newValue) {
                if(newValue != null) {
                    System.out.println("Selected value : " + newValue);
        
                    totalList1 = FXCollections.observableArrayList();
                    totalList2 = FXCollections.observableArrayList();
                    totalList3 = FXCollections.observableArrayList();
                    totalList4 = FXCollections.observableArrayList();
                    totalList5 = FXCollections.observableArrayList();
                    totalList6 = FXCollections.observableArrayList();
                    
                    System.out.println("selectedFile 개수 : " + selectedFile.size());
                    for(int r=0; r<obj.finalDBF.size(); r++) {
                        String name = selectedFile.get(r).getName().replace(".xlsx", "");
                        System.out.println("name: " + name);
                        
                        if(newValue.equals(name)) {
                            String dbFStr = obj.finalDBF.get(r).toString();
//                            System.out.println("dbFStr0000: " + dbFStr);
                            
                            settablecolumn(dbFStr);
                            fillPercent(dbFStr);
                            
                            if(compareFlag == true) {
//                                System.out.println("compareFlag true 임");
//                                System.out.println("dbFStr0000: " + dbFStr);
                                tv8pane.setVisible(true);
                                readFinallyDB rfd = new readFinallyDB();
                                rfd.runDBxml(dbFStr);
                                
                                Map<Integer, Map<String, List<String>>> map = rfd.getFinalMap();
//                                System.out.println("map222 개수: " + map.size());
                                createResultTable(map);
                                
                            }
                            
                        }
                        
                    }

                }
                
            }
        });
        
    }
    
    public void settablecolumn(String dbFStr) {
        System.out.println("settablecolumn() 시작");
        
        // final-database.xml 읽기
        readDBXML(dbFStr);
        
        ftc = new FilltableColumn(t1cell1, t1cell2, t1cell3, t1cell4, t2cell1, t2cell2, t2cell3, t2cell4, t2cell5, 
              t3cell1, t3cell2, t3cell3, t3cell4, t4cell1, t4cell2, t4cell3, t4cell4, t4cell5, 
              t5cell1, t5cell2, t5cell3, t5cell4, t5cell5, t6cell1, t6cell2, t6cell3, 
              t6cell4, t6cell5, t6cell6);
        
        ftc.setDBpath(dbFStr);
        
        //---------------------------------------------
        // 1. 가격 경쟁력 만들기
        ftc.setSatisTcolumn("tab1Field");
        totalList1.addAll(ftc.getTotalList1());
        obj.totalList1 = totalList1;

        tv1.setItems(totalList1);
        tv1.setEditable(true);
        
        // 2. 자동화
        ftc.setSatisTcolumn("tab2Field");
        totalList2.addAll(ftc.getTotalList2());
        obj.totalList2 = totalList2;
        
        tv2.setItems(totalList2);
        tv2.setEditable(true);
        
        // 3. 보안
        ftc.setSatisTcolumn("tab3Field");
        totalList3.addAll(ftc.getTotalList3());
        obj.totalList3 = totalList3;
        
        tv3.setItems(totalList3);
        tv3.setEditable(true);
        
        // 4. 결과물 품질
        ftc.setSatisTcolumn("tab4Field");
        totalList4.addAll(ftc.getTotalList4());
        obj.totalList4 = totalList4;
        
        tv4.setItems(totalList4);
        tv4.setEditable(true);
        
        // 4. 납기 지연율
        ftc.setSatisTcolumn("tab5Field");
        totalList5.addAll(ftc.getTotalList5());
        obj.totalList5 = totalList5;
        
        tv5.setItems(totalList5);
        tv5.setEditable(true);
        
    }
    
    public void readDBXML(String dbFStr) {
        System.out.println("readDBXML() 시작");
        System.out.println("dbFStr: " + dbFStr);
        
        readDBXML rdbx = new readDBXML();
        rdbx.runDBxml(dbFStr);
        
    }
    
    public void openDialog() {
        System.out.println("openDialog() 시작");
        
        try {
            FileChooser fc = new FileChooser();
            fc.getExtensionFilters().addAll(new ExtensionFilter("EXCEL files","*.xlsx"));
            
            selectedFile = fc.showOpenMultipleDialog(null);
            
            // 파일명 규칙 맞지 않을때 에러 발생
            selectedFile.forEach(a -> {
                String filename = a.getName();
                
                if(!filename.contains("정형화 형식")) {
                    throw new RuntimeException("파일명 규칙이 맞지 않습니다. 올바른 엑셀 파일을 넣어주세요.");

                }
                
            });
            
            // 선택한 엑셀 개수 만큼 combobox 요소 생성 
            cb.setItems(comboL);
            
            for(int r=0; r<selectedFile.size(); r++) {
                String name = selectedFile.get(r).getName().replace(".xlsx", "");
                System.out.println("name: " + name);
                cb.getItems().add(name);
                
                if(r == 0) {
                    cb.getSelectionModel().selectFirst();
                }
                
                String fullpath = selectedFile.get(r).toString();
                exceltxml(fullpath, "othertype");
                
                String xmlName = obj.excelDBF.get(r);
                
                // XSLT 실행 
                transformXSLT tf = new transformXSLT(xmlName);
                tf.setList();
            }
            
            String dbFStr = obj.finalDBF.get(0);
            
            settablecolumn(dbFStr);
            fillPercent(dbFStr);
            
            // 이상없이 완료시 버튼 색 변경
            setButtonStyle(tab1bt1);
            
        } catch(Exception e) {
            msg = e.getMessage();
            System.out.println("catch블록 msg: " + msg);
//            throw new RuntimeException();
            
            errorPopup(msg);

        }
        
        
        
    }
    
    public void errorPopup(String msg) {
        System.out.println("selectedPopup() 메소드 호출");
        
        // 컨트롤 초기화
//        setInitControl();
        
        // 커스텀 다이얼로그 생성
        Stage dg = new Stage(StageStyle.UTILITY);
        dg.initModality(Modality.WINDOW_MODAL);
        dg.initOwner(primaryStage);
        
        // FXMLLoader.load() 메소드로 팝업 로드
        try {
            Parent parent = FXMLLoader.load(getClass().getResource("/main/java/satisfy/fxml/verError.fxml"));
//            parent.setStyle("-fx-background-color: ANTIQUEWHITE");
            
            //버튼 찾기 
            Button sebt = (Button) parent.lookup("#errBt");
            sebt.setOnAction(ev -> dg.close());

            // 라벨 컨트롤 찾기
            Label selb = (Label) parent.lookup("#errLb1");
            selb.setWrapText(true);
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
    
    public void setInitControl() {
        System.out.println("setInitControl() 시작");
        
        // 버튼 초기화
//      tab1bt1.setStyle("-fx-background-color:transparent;-fx-border-color:black;");
//      tab1bt3;
//      tab1bt4;
    }
    
    public void openSatisfyDialog() {
        System.out.println("openSatisfyDialog() 시작");
        
        try {
            FileChooser fc = new FileChooser();
            fc.getExtensionFilters().addAll(new ExtensionFilter("EXCEL files","*.xlsx"));
            
            List<File> selectedDir = fc.showOpenMultipleDialog(null);
            
            // 파일명 규칙 맞지 않을때 에러 발생
            selectedDir.forEach(a -> {
                String filename = a.getName();
                
                if(!filename.contains("만족도")) {
                    throw new RuntimeException("파일명 규칙이 맞지 않습니다. 만족도 엑셀 파일을 넣어주세요.");

                }
            });
            
            for(int r=0; r<selectedDir.size(); r++) {
                String name = selectedDir.get(r).getName().replace(".xlsx", "");
                System.out.println("name: " + name);
                
                String fullpath = selectedDir.get(r).toString();
                
                exceltxml(fullpath, "satisfy");
                
            }
            
            // XSLT 실행
            
            transformXSLT tf = new transformXSLT("satisfy");
            tf.setList4();
            
            // 이상없이 완료시 버튼 색 변경
            setButtonStyle(tab1bt4);
            
        } catch(Exception e) {
            msg = e.getMessage();
            System.out.println("catch블록 msg: " + msg);
//            throw new RuntimeException();
            
            errorPopup(msg);
            
        }
        
        

    }
    
    public void fillPercent(String dbFStr) {
        System.out.println("fillPercent() 시작");
        
        try {
            readDBXML rdbx = new readDBXML();
            List<String> perList = rdbx.percentage(dbFStr);

        } catch(Exception e) {
            e.printStackTrace();
        }
        
    }

    public void exceltxml(String excelPathS, String exceltype) {
        System.out.println("exceltxml() 시작");
        
        excelTxml ee = new excelTxml(excelPathS, exceltype);
        try {
            ee.runexcel();
            
        } catch (Exception e1) {
            e1.printStackTrace();
        }

    }
    
    public void exportFinally(String message) {
        System.out.println("exportFinally() 시작");
        
        try {
            // 1. FXMLLoader.load() 메소드 호출하여 fxml 파일 로드
            Parent parent = FXMLLoader.load(getClass().getResource("/main/java/satisfy/fxml/exportComplete.fxml"));
            Stage dg = new Stage(StageStyle.UTILITY);
            dg.initModality(Modality.WINDOW_MODAL);
            dg.initOwner(primaryStage);
            
            dg.setTitle("작업이 완료 되었습니다.");
            
            // 버튼 속성을 가진 객체를 찾아 메소드로 닫기
            Button exok = (Button) parent.lookup("#exportok");
            exok.setOnAction(event -> dg.close());
            
            // Label 객체를 찾아 텍스트 출력
            Label lb = (Label) parent.lookup("#compleTxt");
            lb.setText(message);
            
            // Scene 생성
            Scene scenePop = new Scene(parent);  // 장면에 pop.fxml 레이아웃 올림

            // 다이얼로그에 장면(Scene) 올리기
            dg.setScene(scenePop);        
            dg.setResizable(false);  // 크기를 변경하지 못하도록 설정
            dg.show();
            
        } catch (IOException e1) {
            e1.printStackTrace();
            System.out.println("fxml 파일 로드 실패!");
        }
        
    }
    
    public void setButtonStyle(Button bt) {
        System.out.println("setButtonStyle() 시작");
        
        bt.setStyle("-fx-background-color:#e8cc95;-fx-border-color:black;");
        
    }
    
    public void setDirectoryPath() {
        System.out.println("setDirectoryPath() 시작");
        System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
        File file = new File("");
        
        // 패키지 경로
        projectDir = file.getAbsolutePath();
        obj.projectDir = projectDir;
        System.out.println("projectDir: " + projectDir);
        
        teplsDir = projectDir + File.separator + "jre/resources/template";
        System.out.println("teplsDir: " + teplsDir);
        obj.teplsDir = teplsDir; 
        
        // temp 경로
        tempDir = projectDir + File.separator + "jre/resources/temp";
        obj.tempDir = tempDir;
        
        // db 경로
        dbDir = projectDir + File.separator + "jre/resources/temp/db";
        System.out.println("dbDir: " + dbDir);
        obj.dbDir = dbDir;
        
        // excelF 경로
        excelXDir = projectDir + File.separator + "jre/resources/temp/excel";
        System.out.println("excelXDir: " + excelXDir);
        obj.excelXDir = excelXDir;
        
        // html 탬플릿 경로
        htmlTemplsDir = teplsDir + "/html-templates";
        
        // 초기 디렉토리 생성
        initDir();
    }
    
    public void initDir() {
        System.out.println("initDir() 시작");

        try {
            // db 폴더 생성
            Path path = Paths.get(dbDir);
            obj.createNewDir(path);
            
            // excelX 폴더 생성
            Path excelpath = Paths.get(excelXDir);
            obj.createNewDir(excelpath);
            
            Path satisfyEpath = Paths.get(excelXDir + "/satisfy");
            Files.createDirectories(satisfyEpath);
            
//            Path srcP = Paths.get(teplsDir + File.separator + "db.xml");
//            Path tarP = Paths.get(dbDir + File.separator + "db.xml");
            
            //----------------------------------------------
            
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    }
    
}
