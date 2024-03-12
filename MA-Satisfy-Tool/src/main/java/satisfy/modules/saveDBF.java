package main.java.satisfy.modules;

import java.io.File;
import java.net.URI;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import main.java.satisfy.Common.implementOBJ;
import net.sf.saxon.lib.NamespaceConstant;

public class saveDBF {
    implementOBJ obj = new implementOBJ();
    String express = "";
    String dbFStr = "";
    
    public void setDBpath(String dbFStr) {
        System.out.println("setDBpath() 시작");
        
        this.dbFStr = dbFStr;
        
    }
    
    public void updateXMLFile(Company company, String oldValue, String newValue, String tcid, int index, int stop, String tabpos) {
        System.out.println("updateXMLFile() 시작");
        
        try {
            // 1. xml 파일 읽기
            File file = new File(dbFStr);
            
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(file);
            Element rootEle = doc.getDocumentElement();
            
            XPathFactory factory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
            
            // 1. xapth 객체 생성
            XPath xpath = factory.newXPath();
            
            String curCellStr = "";
            
            if(tabpos.equals("tab1Field")) {
                express = "root//competitive_price/items//item";
                curCellStr = "t1cell";
                
            } else if(tabpos.equals("tab2Field")) {
                express = "root//automation/items//item";
                curCellStr = "t2cell";
                
            } else if(tabpos.equals("tab3Field")) {
                express = "root//safety/items//item";
                curCellStr = "t3cell";
                
            } else if(tabpos.equals("tab4Field")) {
                express = "root//quality/items//item";
                curCellStr = "t4cell";
                
            } else if(tabpos.equals("tab5Field")) {
                express = "root//delivery_compliance/items//item";
                curCellStr = "t5cell";
                
            } else if(tabpos.equals("tab6Field")) {
                express = "root//satisfy/items//item";
                curCellStr = "t6cell";
            }
            
            System.out.println("express: " + express);
            NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);

            System.out.println("tcid222: " + tcid);
            
            for (int i = 0; i < nl.getLength(); i++) {
                Node node = nl.item(i);
                Element ele = (Element) node;
                
                // 현재 TableColumn의 Row 위치의 요소만 수정하기 위해 index 사용
                // i == index 하지 않으면, 모든 태그가 수정되어 버림
                if(i == index) {
                    for(int j=1; j<stop; j++) {
                        String curCellpos = curCellStr + j;
//                        System.out.println("curCellpos: " + curCellpos);
                        // xml의 값과 newValue의 값이 다른 경우에만 파일에 저장
                        if (tcid.equals(curCellpos)) {
                          // 셀에 새로운 입력값으로 할당
                          setAttr(company, j, oldValue, newValue, ele, curCellpos);
                          
                        } 
                        /*
                        else {  // 현재 수정한 tcid가 아닌 다른 TableColumn인 경우에는 기존값을 넣어주기 위해 하기 코드 진행
                            for(int k=1; k<stop; k++) {
                                if(k != j) {
                                    String curCellpos2 = curCellStr + k;
                                    System.out.println("curCellpos2: " + curCellpos2);
                                    otherAttr(k, company, ele, curCellpos2);
                                    
                                }
                                
                            }
                            
                        }*/
                        
                    }

                } 
                
                else {
                    int stop2 = 0;
                    if(tabpos.equals("tab6Field")) {
                        stop2 = obj.totalList6.size();

                        for(int r=0; r<stop2; r++) {
                            String strR = String.valueOf(r);                            
                            
                            Company c = obj.totalList6.get(r);
                            
                            if(ele.getAttribute("id").equals(strR)) {
                                ele.setAttribute("t6cell1", c.getT6cell1());
                            }

                        }
                        
                    }  

                }
                
            }
            
            // 파일로 출력
            setTransformer(doc);
            
        } catch (Exception e) {
            e.printStackTrace();
            
        }
        
    }
    
    public void setAttr(Company company, int j, String oldValue, String newValue, Element ele, String curCellpos) { 
        if(newValue != null) {
            ele.setAttribute(curCellpos, newValue);

        } else if(newValue == null && (oldValue != null | !oldValue.equals(""))) {
            ele.setAttribute(curCellpos, oldValue);
            
        }
        else if(!oldValue.equals(newValue) && !oldValue.equals("")) {
            // xml의 값과 newValue의 값이 다른 경우에만 파일에 저장
            ele.setAttribute(curCellpos, newValue);

        } else {
            ele.setAttribute(curCellpos, "");

        }

    }
    
    public void setTransformer(Document doc) {
        System.out.println("setTransformer() 시작");
        
        try {
            // 출력 파일 지정
            File outF = new File(dbFStr);
            URI out2 = outF.toURI();
            
            // 1. TransformerFactory 객체 생성
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            // 2. Transformer 객체 생성 
            Transformer trans = transformerFactory.newTransformer();
            
            // 3. 출력 포맷 설정
            trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            trans.setOutputProperty(OutputKeys.INDENT, "no");
            trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
            
            // 4. DOMSource 객체 생성
            DOMSource source = new DOMSource(doc);
            
            // 5. 출력 결과를 스트림으로 생성
            Result result = new StreamResult(out2.toString());
            trans.transform(source, result);
              
            System.out.println("XML file updated successfully!");
        
        } catch(Exception e) {
            System.out.println("Transformer 진행 실패");
            e.printStackTrace();
            
        }
        
    }
    
    public void otherAttr(int k, Company company, Element ele, String curCellpos) {
//        System.out.println("otherAttr() 시작");
        
        String curCellpos2 = curCellpos;
        String val = "";
        switch(curCellpos2) {
            case "t1cell1":
                val = company.getT1cell1();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t1cell2":
                val = company.getT1cell2();
                ele.setAttribute(curCellpos2, val);
                break;
            case "t1cell3":
                val = company.getT1cell3();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t1cell4":
                val = company.getT1cell4();
                ele.setAttribute(curCellpos2, val);
                break;
            //--------------------------------------------------
            
            case "t2cell1":
                val = company.getT2cell1();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t2cell2":
                val = company.getT2cell2();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t2cell3":
                val = company.getT2cell3();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t2cell4":
                val = company.getT2cell4();
                ele.setAttribute(curCellpos2, val);
                break;
            
            case "t2cell5":
                val = company.getT2cell5();
                ele.setAttribute(curCellpos2, val);
                break;
            //--------------------------------------------------
                
            case "t3cell1":
                val = company.getT3cell1();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t3cell2":
                val = company.getT3cell2();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t3cell3":
                val = company.getT3cell3();
                ele.setAttribute(curCellpos2, val);
                break;
            
            case "t3cell4":
                val = company.getT3cell4();
                ele.setAttribute(curCellpos2, val);
                break;
            //--------------------------------------------------
                
            case "t4cell1":
                val = company.getT4cell1();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t4cell2":
                val = company.getT4cell2();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t4cell3":
                val = company.getT4cell3();
                ele.setAttribute(curCellpos2, val);
                break;
            
            case "t4cell4":
                val = company.getT4cell4();
                ele.setAttribute(curCellpos2, val);
                break;
            
            case "t4cell5":
                val = company.getT4cell5();
                ele.setAttribute(curCellpos2, val);
                break;
                
            //--------------------------------------------------
                
            case "t5cell1":
                val = company.getT5cell1();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t5cell2":
                val = company.getT5cell2();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t5cell3":
                val = company.getT5cell3();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t5cell4":
                val = company.getT5cell4();
                ele.setAttribute(curCellpos2, val);
                break;
            
            case "t5cell5":
                val = company.getT5cell5();
                ele.setAttribute(curCellpos2, val);
                break;
                
            //--------------------------------------------------
                
            case "t6cell1":
                val = company.getT6cell1();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t6cell2":
                val = company.getT6cell2();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t6cell3":
                val = company.getT6cell3();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t6cell4":
                val = company.getT6cell4();
                ele.setAttribute(curCellpos2, val);
                break;
            
            case "t6cell5":
                val = company.getT6cell5();
                ele.setAttribute(curCellpos2, val);
                break;
                
            case "t6cell6":
                val = company.getT6cell6();
                ele.setAttribute(curCellpos2, val);
                break;
        }
    }

}
