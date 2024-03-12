package main.java.satisfy.modules;

import javafx.scene.control.TableColumn;

public class ColumnCommitHandler {
    saveDBF dbf = new saveDBF();
    int stop = 0;
    String dbFStr = "";
    
    public void setDBpath(String dbFStr) {
        System.out.println("setDBpath() 시작");
        
        this.dbFStr = dbFStr;
        
        dbf.setDBpath(dbFStr);
    }
    
    public void handleClickEdit(TableColumn.CellEditEvent<Company, String> cellEditEvent, String tabpos) {
        System.out.println("handleClickEdit() 시작");
        
        // 칼럼 이름 추출
        String columnName = cellEditEvent.getTableColumn().getText();
        
        // TableColumn 의 ID값 추출
        String tcid = cellEditEvent.getTableColumn().getId();

        // TableColumn 현재값
        String oldValue = cellEditEvent.getOldValue();
        
        // TableColumn 에 새롭게 입력한 값
        String newValue = cellEditEvent.getNewValue();

        // 현재 TableColumn의 위치 
        int index = cellEditEvent.getTablePosition().getRow();
//        System.out.println("index가 다르게 찍히나 확인: " + index);

        Company company = cellEditEvent.getTableView().getItems().get(index);
        
        String curCellStr = "";
        if(tabpos.equals("tab1Field")) {
            stop = 5;
            curCellStr = "t1cell";
            
        } else if(tabpos.equals("tab2Field")) {
            stop = 6;
            curCellStr = "t2cell";
            
        } else if(tabpos.equals("tab3Field")) {
            stop = 5;
            curCellStr = "t3cell";
            
        } else if(tabpos.equals("tab4Field")) {
            stop = 6;
            curCellStr = "t4cell";
            
        } else if(tabpos.equals("tab5Field")) {
            stop = 6;
            curCellStr = "t5cell";
            
        } else if(tabpos.equals("tab6Field")) {
            stop = 7;
            curCellStr = "t6cell";
        }
        
        for(int i=1; i<stop; i++) {
            String curCellpos = curCellStr + i;
            
            if (tcid.equals(curCellpos)) {
              // 셀에 새로운 입력값으로 할당
              getCellVal(company, i, newValue, curCellStr);
              
//               파일로 저장하기
              dbf.updateXMLFile(company, oldValue, newValue, tcid, index, stop, tabpos);
            }
        }

        cellEditEvent.getTableView().refresh();
    }
    
    public void getCellVal(Company company, int i, String newValue, String curCellStr) {
        String curCellpos = curCellStr + i;
        
        switch(curCellpos) {
            case "t1cell1":
                company.setT1cell1(newValue);
                break;
                
            case "t1cell2":
                company.setT1cell2(newValue);
                break;
                
            case "t1cell3":
                company.setT1cell3(newValue);
                break;
                
            case "t1cell4":
                company.setT1cell4(newValue);
                break;
        
            case "t2cell1":
                company.setT2cell1(newValue);
                break;
                
            case "t2cell2":
                company.setT2cell2(newValue);
                break;
                
            case "t2cell3":
                company.setT2cell3(newValue);
                break;
            
            case "t2cell4":
                company.setT2cell4(newValue);
                break;
                
            case "t2cell5":
                company.setT2cell5(newValue);
                break;
                
            case "t3cell1":
                company.setT3cell1(newValue);
                break;
                
            case "t3cell2":
                company.setT3cell2(newValue);
                break;
                
            case "t3cell3":
                company.setT3cell3(newValue);
                break;
                
            case "t3cell4":
                company.setT3cell4(newValue);
                break;
                
            case "t4cell1":
                company.setT4cell1(newValue);
                break;
                
            case "t4cell2":
                company.setT4cell2(newValue);
                break;
                
            case "t4cell3":
                company.setT4cell3(newValue);
                break;
                
            case "t4cell4":
                company.setT4cell4(newValue);
                break;
                
            case "t4cell5":
                company.setT4cell5(newValue);
                break;
                
            case "t5cell1":
                company.setT5cell1(newValue);
                break;
                
            case "t5cell2":
                company.setT5cell2(newValue);
                break;
                
            case "t5cell3":
                company.setT5cell3(newValue);
                break;
                
            case "t5cell4":
                company.setT5cell4(newValue);
                break;
                
            case "t5cell5":
                company.setT5cell5(newValue);
                break;
                
            case "t6cell1":
                company.setT6cell1(newValue);
                break;
                
            case "t6cell2":
                company.setT6cell2(newValue);
                break;
                
            case "t6cell3":
                company.setT6cell3(newValue);
                break;
                
            case "t6cell4":
                company.setT6cell4(newValue);
                break;
                
            case "t6cell5":
                company.setT6cell5(newValue);
                break;
                
            case "t6cell6":
                company.setT6cell6(newValue);
                break;
        }
        
    }

}
