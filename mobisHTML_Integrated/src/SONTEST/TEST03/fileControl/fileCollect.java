package SONTEST.TEST03.fileControl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collector;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import SONTEST.TEST03.fxClass.groupByext;
import SONTEST.TEST03.fxClass.tableFiles;
import SONTEST.TEST03.subWorkClass.commonObj;
import net.sf.saxon.lib.NamespaceConstant;

public class fileCollect<T> {
    public static Map<String, String> map = new HashMap<>();
    public static String uiTxt;
    static commonObj coj = new commonObj();
    List<groupByext> listGroup = new ArrayList<>();
    public static Map<groupByext.Ext, List<groupByext>> mapT = null;

    public void setMap(List<T> viewList) {
        Stream<T> stream = viewList.stream();
        
        if (viewList.get(0) instanceof tableFiles) {       
            fileCollection(stream, "tableFiles");
            fileGroupExtT(listGroup, "tableFiles");
            
        } 
        else if(viewList.get(0) instanceof String) {
            if(listGroup.size() > 0) {
                listGroup.clear();
            }
            fileCollection(stream, "String");
            fileGroupExtT(listGroup, "String");
            
        }
    }
    
    
    
    public static void exportIdmlName() {
        ArrayList<String> list = new ArrayList<>();
        
        if(!mapT.isEmpty()) {
            mapT.get(groupByext.Ext.idml).forEach(a -> {
                String getPath = a.getName();
            });
        }
    }
    
    public static void exportExcelName() {
        if(!mapT.isEmpty()) {
            mapT.get(groupByext.Ext.xlsx).forEach(a -> {
                String fileName = a.getName();
                
                Optional<String> op = Optional.ofNullable(fileName);
                
                op.ifPresent(b -> {
                    if(b.indexOf("_ID_") != -1) {
                        File file = new File(b);
                        String originalName = b;
                        
                        try {
                            exportLang(originalName);
                            
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        
                    } else if(b.indexOf("_UI_") != -1) {
                        uiTxt = b.replace(".xlsx", "");
                        int pos = uiTxt.lastIndexOf("_");
                        String getInches = uiTxt.substring(pos + 1);
                        
                        map.put("inch", getInches);
                    } 
    
                });
            });
            
        } else {            
        }
    }
    
    private static void exportLang(String originalName) throws Exception {
        originalName = originalName.replace(".xlsx", "");

        int pos = originalName.indexOf("th_");
        String excelver = originalName.substring(pos-1, pos);
        
        String regionLgs = originalName.substring(pos + 3);
        int lastPos = regionLgs.lastIndexOf("_") + 1;
        String isoLang = "'" + regionLgs.substring(lastPos) + "'";
        int companyPos = originalName.indexOf("_");
        String excelCompany = originalName.substring(0, companyPos);

        map.put("company", excelCompany);
        map.put("ver", excelver);
       
        exportComboList exportComboList = new exportComboList();
        Document doc = exportComboList.accessFile();
        System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
        XPathFactory factory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
        XPath xpath = factory.newXPath();
        String express = "codes/langs/code[matches(@ISO," + isoLang + ")]";
        
        NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
        String excelLang = "";
        
        for(int i=0; i< nl.getLength(); i++) {
            Node node = nl.item(i);
            Element ele = (Element) node;
            
            excelLang = ele.getAttribute("Fullname");
        }
        map.put("lang", excelLang);
        
    }
    
    public void fileCollection(Stream<T> stream, String type) {
        if(type.equals("tableFiles")) {
            stream.forEach(a -> {
                String getfileName = ((tableFiles) a).getFiles();
                File file = new File(getfileName);
                String fileName = file.getName();
                
                if(fileName.contains("xlsx")) {
                    listGroup.add(new groupByext(fileName, groupByext.Ext.xlsx, new File(getfileName)));
                    
                } else if(fileName.contains("idml")) {
                    listGroup.add(new groupByext(fileName, groupByext.Ext.idml, new File(getfileName)));
                 
                }
            });
            
        } else if(type.equals("String")) {
            stream.forEach(b -> {
                String getfileName = b.toString();
                File file = new File(getfileName);
                String fileName = file.getName();
                
                if(fileName.contains("xlsx")) {
                    listGroup.add(new groupByext(fileName, groupByext.Ext.xlsx, file));
                    
                } else if(fileName.contains("idml")) {
                    listGroup.add(new groupByext(fileName, groupByext.Ext.idml, file));
                 
                }
            });
        }

    }
    
    public void fileGroupExtT(List<groupByext> listGroup, String type) {
        Stream<groupByext> stream = listGroup.stream();
        Function<groupByext, groupByext.Ext> mapp = groupByext::getExt;
        Collector<groupByext, ?, Map<groupByext.Ext, List<groupByext>>> collector = Collectors.groupingBy(mapp);
        Map<groupByext.Ext, List<groupByext>> map = stream.collect(collector);
        
        mapT = map;
        
    }
    
    public Map<String, String> getList() {
        return map;
    }
    
    
}
