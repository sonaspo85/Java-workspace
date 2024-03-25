package main.java.satisfy.modules;

import java.util.ArrayList;
import java.util.List;

import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.TableCell;
import javafx.scene.control.TableColumn;
import javafx.scene.control.cell.TextFieldTableCell;
import javafx.util.Callback;
import javafx.util.StringConverter;
import main.java.satisfy.Common.implementOBJ;



public class FilltableColumn {
    implementOBJ obj = new implementOBJ();
    
    String dbFStr = "";
    
    Company company = null;
    public ObservableList<Company> totalList1 = FXCollections.observableArrayList();
    public ObservableList<Company> totalList2 = FXCollections.observableArrayList();
    public ObservableList<Company> totalList3 = FXCollections.observableArrayList();
    public ObservableList<Company> totalList4 = FXCollections.observableArrayList();
    public ObservableList<Company> totalList5 = FXCollections.observableArrayList();
    public ObservableList<Company> totalList6 = FXCollections.observableArrayList();

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
    
    
    List<String> tab1List = new ArrayList<String>();
    List<String> tab2List = new ArrayList<String>();
    List<String> tab3List = new ArrayList<String>();
    List<String> tab4List = new ArrayList<String>();
    List<String> tab5List = new ArrayList<String>();
    List<String> tab6List = new ArrayList<String>();
    //----------------------------------------------
    
    ColumnCommitHandler cch = new ColumnCommitHandler();
    

    public FilltableColumn(TableColumn<Company, String> t1cell1,TableColumn<Company, String> t1cell2, TableColumn<Company, String> t1cell3, TableColumn<Company, String> t1cell4, 
            TableColumn<Company, String> t2cell1, TableColumn<Company, String> t2cell2, TableColumn<Company, String> t2cell3, TableColumn<Company, String> t2cell4, TableColumn<Company, String> t2cell5,  
            TableColumn<Company, String> t3cell1, TableColumn<Company, String> t3cell2, TableColumn<Company, String> t3cell3, TableColumn<Company, String> t3cell4,  
            TableColumn<Company, String> t4cell1, TableColumn<Company, String> t4cell2, TableColumn<Company, String> t4cell3, TableColumn<Company, String> t4cell4, TableColumn<Company, String> t4cell5, 
            TableColumn<Company, String> t5cell1, TableColumn<Company, String> t5cell2, TableColumn<Company, String> t5cell3, TableColumn<Company, String> t5cell4, TableColumn<Company, String> t5cell5,
            TableColumn<Company, String> t6cell1, TableColumn<Company, String> t6cell2, TableColumn<Company, String> t6cell3, TableColumn<Company, String> t6cell4, TableColumn<Company, String> t6cell5, TableColumn<Company, String> t6cell6) {
        
        this.t1cell1 = t1cell1;
        this.t1cell2 = t1cell2;
        this.t1cell3 = t1cell3;
        this.t1cell4 = t1cell4;
        this.t2cell1 = t2cell1;
        this.t2cell2 = t2cell2;
        this.t2cell3 = t2cell3;
        this.t2cell4 = t2cell4;
        this.t2cell5 = t2cell5;
        this.t3cell1 = t3cell1;
        this.t3cell2 = t3cell2;
        this.t3cell3 = t3cell3;
        this.t3cell4 = t3cell4;
        this.t4cell1 = t4cell1;
        this.t4cell2 = t4cell2;
        this.t4cell3 = t4cell3;
        this.t4cell4 = t4cell4;
        this.t4cell5 = t4cell5;
        this.t5cell1 = t5cell1;
        this.t5cell2 = t5cell2;
        this.t5cell3 = t5cell3;
        this.t5cell4 = t5cell4;
        this.t5cell5 = t5cell5;
        this.t6cell1 = t6cell1;
        this.t6cell2 = t6cell2;
        this.t6cell3 = t6cell3;
        this.t6cell4 = t6cell4;
        this.t6cell5 = t6cell5;
        this.t6cell6 = t6cell6;
    }
    

    public void setSatisTcolumn(String tabpos) {
        if (tabpos.equals("tab1Field")) {
          tab1CellFactory("tab1Field");
          
        } else if (tabpos.equals("tab2Field")) {
            tab2CellFactory("tab2Field");
            
        } else if (tabpos.equals("tab3Field")) {
            tab3CellFactory("tab3Field");
            
        } else if (tabpos.equals("tab4Field")) {
            tab4CellFactory("tab4Field");
            
        } else if (tabpos.equals("tab5Field")) {
            tab5CellFactory("tab5Field");
            
        } else if (tabpos.equals("tab6Field")) {
            tab6CellFactory("tab6Field");
            
        } 
        
    }
    
    public void tab1CellFactory(String tabpos) {
        System.out.println("tab1CellFactory() 시작");
        
        List<String> listtwo = new ArrayList<String>();
        List<String> listthree = new ArrayList<String>();
        List<String> listfour = new ArrayList<String>();
        
        obj.tv1Map.forEach((k,v) -> {
            int key = k;
            List<String> val = v;
            
            tab1List.add(val.get(0));
            listtwo.add(val.get(1));
            listthree.add(val.get(2));
            listfour.add(val.get(3));
            
        });

        t1cell1.setOnEditCommit(cellEditEvent -> {
            cch.handleClickEdit(cellEditEvent, tabpos);
            
        });
        
        t1cell1.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT1cell1()));
        
        for (int i=0; i<tab1List.size(); i++) {
            company = new Company(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
            company.setT1cell1(tab1List.get(i));
            company.setT1cell2(listtwo.get(i));
            company.setT1cell3(listthree.get(i));
            company.setT1cell4(listfour.get(i));
            SortByTablecolumn(i, tabpos);
            totalList1.add(company);

        }
        
    }
    
    public void tab2CellFactory(String tabpos) {
        System.out.println("tab1CellFactory() 시작");

        List<String> listtwo = new ArrayList<String>();
        List<String> listthree = new ArrayList<String>();
        List<String> listfour = new ArrayList<String>();
        List<String> listfive = new ArrayList<String>();
        
        obj.tv2Map.forEach((k,v) -> {
            int key = k;
            List<String> val = v;
            
            tab2List.add(val.get(0));
            listtwo.add(val.get(1));
            listthree.add(val.get(2));
            listfour.add(val.get(3));
            listfive.add(val.get(4));
        });
        
        // 항목 칼럼 만들기 **************************
        // Cell을 생성 하는데 TableColumn을 편집 가능한 Cell로 만들기 위한 Factory 객체 생성
        t2cell1.setOnEditCommit(cellEditEvent -> {
            cch.handleClickEdit(cellEditEvent, tabpos);
        });
        
        t2cell1.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT2cell1()));
        
        for (int i=0; i<tab2List.size(); i++) {
            company = new Company(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
            company.setT2cell1(tab2List.get(i));
            company.setT2cell2(listtwo.get(i));
            company.setT2cell3(listthree.get(i));
            company.setT2cell4(listfour.get(i));
            company.setT2cell5(listfive.get(i));
            
            SortByTablecolumn(i, tabpos);

            // company 객체로 모은 모든 객체를 ObservableList<Company> 컬렉션의 요소로 추가
            totalList2.add(company);

        }
        
        

    }

    public void tab3CellFactory(String tabpos) {
        List<String> listtwo = new ArrayList<String>();
        List<String> listthree = new ArrayList<String>();
        List<String> listfour = new ArrayList<String>();
        
        obj.tv3Map.forEach((k,v) -> {
            int key = k;
            List<String> val = v;
            
            tab3List.add(val.get(0));
            listtwo.add(val.get(1));
            listthree.add(val.get(2));
            listfour.add(val.get(3));
        });
        
        // **************************************
        // 항목 칼럼 만들기 **************************
        t3cell1.setOnEditCommit(cellEditEvent -> {
            cch.handleClickEdit(cellEditEvent, tabpos);

        });
        
        t3cell1.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT3cell1()));

        for (int i=0; i<tab3List.size(); i++) {
            company = new Company(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
            company.setT3cell1(tab3List.get(i));
            company.setT3cell2(listtwo.get(i));
            company.setT3cell3(listthree.get(i));
            company.setT3cell4(listfour.get(i));
            SortByTablecolumn(i, tabpos);
            totalList3.add(company);

        }
        
    }
    
    public void tab4CellFactory(String tabpos) {
        List<String> listtwo = new ArrayList<String>();
        List<String> listthree = new ArrayList<String>();
        List<String> listfour = new ArrayList<String>();
        List<String> listfive = new ArrayList<String>();
        
        obj.tv4Map.forEach((k,v) -> {
            int key = k;
            List<String> val = v;
            
            tab4List.add(val.get(0));
            listtwo.add(val.get(1));
            listthree.add(val.get(2));
            listfour.add(val.get(3));
            listfive.add(val.get(4));
        });
        
        
        // 항목 칼럼 만들기 **************************
        t4cell1.setOnEditCommit(cellEditEvent -> {
            cch.handleClickEdit(cellEditEvent, tabpos);

        });

        // Cell을 채우는 방법을 지정
        t4cell1.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT4cell1()));

        for (int i=0; i<tab4List.size(); i++) {
            company = new Company(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
            company.setT4cell1(tab4List.get(i));
            company.setT4cell2(listtwo.get(i));
            company.setT4cell3(listthree.get(i));
            company.setT4cell4(listfour.get(i));
            company.setT4cell5(listfive.get(i));
            SortByTablecolumn(i, tabpos);
            totalList4.add(company);

        }
        
    } 
    
    public void tab5CellFactory(String tabpos) {
        List<String> listtwo = new ArrayList<String>();
        List<String> listthree = new ArrayList<String>();
        List<String> listfour = new ArrayList<String>();
        List<String> listfive = new ArrayList<String>();
        
        obj.tv5Map.forEach((k,v) -> {
            int key = k;
            List<String> val = v;
            
            tab5List.add(val.get(0));
            listtwo.add(val.get(1));
            listthree.add(val.get(2));
            listfour.add(val.get(3));
            listfive.add(val.get(4));
        });

        // 항목 칼럼 만들기 **************************
        t5cell1.setOnEditCommit(cellEditEvent -> {
            cch.handleClickEdit(cellEditEvent, tabpos);

        });

        t5cell1.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT5cell1()));

        for (int i=0; i<tab5List.size(); i++) {
            company = new Company(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
            company.setT5cell1(tab5List.get(i));            
            company.setT5cell2(listtwo.get(i));
            company.setT5cell3(listthree.get(i));
            company.setT5cell4(listfour.get(i));
            company.setT5cell5(listfive.get(i));
            
            SortByTablecolumn(i, tabpos);
            totalList5.add(company);

        }
        
    }
    
    
    
    public void tab6CellFactory(String tabpos) {
        List<String> listtwo = new ArrayList<String>();
        List<String> listthree = new ArrayList<String>();
        List<String> listfour = new ArrayList<String>();
        List<String> listfive = new ArrayList<String>();
        List<String> listsix = new ArrayList<String>();
        
        obj.tv6Map.forEach((k,v) -> {
            int key = k;
            List<String> val = v;
            
            tab6List.add(val.get(0));
            listtwo.add(val.get(1));
            listthree.add(val.get(2));
            listfour.add(val.get(3));
            listfive.add(val.get(4));
            listsix.add(val.get(5));
            
        });
        
        // 항목 칼럼 만들기 **************************
        t6cell1.setOnEditCommit(cellEditEvent -> {
            cch.handleClickEdit(cellEditEvent, tabpos);

        });

        // Cell을 채우는 방법을 지정
        t6cell1.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT6cell1()));

        for (int i=0; i<tab6List.size(); i++) {
            company = new Company(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
            company.setT6cell1(tab6List.get(i));
            company.setT6cell2(listtwo.get(i));
            company.setT6cell3(listthree.get(i));
            company.setT6cell4(listfour.get(i));
            company.setT6cell5(listfive.get(i));
            company.setT6cell6(listsix.get(i));
            SortByTablecolumn(i, tabpos);
            totalList6.add(company);
            
        }
        
    }
    
    
    public void SortByTablecolumn(int i, String tabpos) {
        if(tabpos.equals("tab1Field")) {
            CreateTablecolumnArea(t1cell1, i, tabpos);
            CreateTablecolumnArea(t1cell2, i, tabpos);
            CreateTablecolumnArea(t1cell3, i, tabpos);
            CreateTablecolumnArea(t1cell4, i, tabpos);
            
        } else if (tabpos.equals("tab2Field")) {
            CreateTablecolumnArea(t2cell1, i, tabpos);
            CreateTablecolumnArea(t2cell2, i, tabpos);
            CreateTablecolumnArea(t2cell3, i, tabpos);
            CreateTablecolumnArea(t2cell4, i, tabpos);
            CreateTablecolumnArea(t2cell5, i, tabpos);
            
        } else if(tabpos.equals("tab3Field")) {
            CreateTablecolumnArea(t3cell1, i, tabpos);
            CreateTablecolumnArea(t3cell2, i, tabpos);
            CreateTablecolumnArea(t3cell3, i, tabpos);
            CreateTablecolumnArea(t3cell4, i, tabpos);
            
        } else if(tabpos.equals("tab4Field")) {
            CreateTablecolumnArea(t4cell1, i, tabpos);
            CreateTablecolumnArea(t4cell2, i, tabpos);
            CreateTablecolumnArea(t4cell3, i, tabpos);
            CreateTablecolumnArea(t4cell4, i, tabpos);
            CreateTablecolumnArea(t4cell5, i, tabpos);
            
        } else if(tabpos.equals("tab5Field")) {
            CreateTablecolumnArea(t5cell1, i, tabpos);
            CreateTablecolumnArea(t5cell2, i, tabpos);
            CreateTablecolumnArea(t5cell3, i, tabpos);
            CreateTablecolumnArea(t5cell4, i, tabpos);
            CreateTablecolumnArea(t5cell5, i, tabpos);
            
        } else if(tabpos.equals("tab6Field")) {
            CreateTablecolumnArea(t6cell1, i, tabpos);
            CreateTablecolumnArea(t6cell2, i, tabpos);
            CreateTablecolumnArea(t6cell3, i, tabpos);
            CreateTablecolumnArea(t6cell4, i, tabpos);
            CreateTablecolumnArea(t6cell5, i, tabpos);
            CreateTablecolumnArea(t6cell6, i, tabpos);
            
        }
        
        

    }

    public void CreateTablecolumnArea(TableColumn<Company, String> column, int i, String tabpos) {
        // 현재 tablecolumn 이름 추출
        String columnName = column.getText();
        String tcid = column.getId();
        
        column.setCellFactory(getTextFieldCellFactoryId(column));
        column.setOnEditCommit(cellEditEvent -> {
            cch.handleClickEdit(cellEditEvent, tabpos);
        });
        
        if (tabpos.equals("tab1Field")) {
            List<String> list = new ArrayList<String>();

            if (tcid.equals("t1cell2")) {
                // Cell을 채우는 방법을 지정
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT1cell2()));
                
            } else if (tcid.equals("t1cell3")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT1cell3()));
                
            } else if (tcid.equals("t1cell4")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT1cell4()));
                
            }
            
        }
        
        else if (tabpos.equals("tab2Field")) {
            List<String> list = new ArrayList<String>();

            if (tcid.equals("t2cell2")) {
                // Cell을 채우는 방법을 지정
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT2cell2()));
                
            } else if (tcid.equals("t2cell3")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT2cell3()));
                
            } else if (tcid.equals("t2cell4")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT2cell4()));
                
            } else if (tcid.equals("t2cell5")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT2cell5()));
                
            } 
            
        } else if(tabpos.equals("tab3Field")) {
            List<String> list = new ArrayList<String>();
            
            if (tcid.equals("t3cell2")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT3cell2()));
                
            } else if (tcid.equals("t3cell3")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT3cell3()));
                
            } else if (tcid.equals("t3cell4")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT3cell4()));
                
            }  
            
        }  
        
        else if(tabpos.equals("tab4Field")) {
            List<String> list = new ArrayList<String>();
            
            if (tcid.equals("t4cell2")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT4cell2()));
                
            } else if (tcid.equals("t4cell3")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT4cell3()));
                
            } else if (tcid.equals("t4cell4")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT4cell4()));
                
            } else if (tcid.equals("t4cell5")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT4cell5()));
                
            } 
            
        } else if(tabpos.equals("tab5Field")) {
            List<String> list = new ArrayList<String>();
            
            if (tcid.equals("t5cell2")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT5cell2()));
                
            } else if (tcid.equals("t5cell3")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT5cell3()));
                
            } else if (tcid.equals("t5cell4")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT5cell4()));
                
            } else if (tcid.equals("t5cell5")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT5cell5()));
                
            }  
            
        } else if(tabpos.equals("tab6Field")) {
            List<String> list = new ArrayList<String>();
            
            if (tcid.equals("t6cell2")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT6cell2()));
                
            } else if (tcid.equals("t6cell3")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT6cell3()));
                
            } else if (tcid.equals("t6cell4")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT6cell4()));
                
            } else if (tcid.equals("t6cell5")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT6cell5()));
                
            } else if (tcid.equals("t6cell6")) {
                column.setCellValueFactory(a -> new SimpleStringProperty(a.getValue().getT6cell6()));
                
            }  
            
        }
        
        column.setResizable(false);

    }
    
    // 입력 TableColumn 셀 border 및 텍스트 스타일 변경
    private Callback<TableColumn<Company, String>, TableCell<Company, String>> getTextFieldCellFactoryId(TableColumn<Company, String> column) {
        return CustomTextFieldTableCell.<Company, String>forTableColumn(
                new StringConverter<String>() {
                    @Override
                    public String toString(String str) {
                        return str == null ? "" : str.toString();
                    }

                    @Override
                    public String fromString(String s) {
                        try {
                            return s;
                        } catch (Exception e) {
                            return null;
                        }
                    }
                }, column);
    }
    
    public void setDBpath(String dbFStr) {
        this.dbFStr = dbFStr;
        cch.setDBpath(dbFStr);
    }
    
    public ObservableList<Company> getTotalList1() {
        return totalList1;
    }
    
    public ObservableList<Company> getTotalList2() {
        return totalList2;
    }
    
    public ObservableList<Company> getTotalList3() {
        return totalList3;
    }
    
    public ObservableList<Company> getTotalList4() {
        return totalList4;
    }
    
    public ObservableList<Company> getTotalList5() {
        return totalList5;
    }
    
    public ObservableList<Company> getTotalList6() {
        return totalList6;
    }
    
}
