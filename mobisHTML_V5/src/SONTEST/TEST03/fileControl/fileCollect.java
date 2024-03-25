package SONTEST.TEST03.fileControl;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collector;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.apache.poi.ss.util.SSCellRange;

import SONTEST.TEST03.fxClass.groupByext;
import SONTEST.TEST03.fxClass.tableFiles;

public class fileCollect<T> {
    public static String excelLang;
    public static String uiTxt;
    
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
                
                op.ifPresentOrElse(b -> {
                    if(b.indexOf("ID,Float") != -1) {
                        excelLang = b;
                        int pos = excelLang.lastIndexOf("_");
                        excelLang = excelLang.substring(pos+1, pos+4).toLowerCase();
                        
                    } else if(b.indexOf("ui_text") != -1) {
                        uiTxt = b;
                    } 
    
                }, () -> System.out.println("aaaaaaaaaaaaaaaaaa")); 
    
            });
            
        } else {
        }
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
    
}
