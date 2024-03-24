package SONTEST.TEST03.fileControl;

import java.io.File;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.AsynchronousFileChannel;
import java.nio.channels.CompletionHandler;
import java.nio.channels.FileChannel;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.function.Function;
import java.util.stream.Collector;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import SONTEST.TEST03.fxClass.groupByext;
import SONTEST.TEST03.fxClass.groupByext.Ext;
import SONTEST.TEST03.subWorkClass.commonObj;

public class fileGroupCreateZip {
    private String exePath;
    public Map<groupByext.Ext, List<groupByext>> list;
    
    createExcelFile createExcel = new createExcelFile();
    commonObj coj = new commonObj();

    public fileGroupCreateZip(Map<groupByext.Ext, List<groupByext>> list, String exePath) {
        this.list = list;
        this.exePath = exePath;
    }
    
    public void runCreateZip() {
        recursiveFiles recurFiles = new recursiveFiles(); 
        recurFiles.setPath(exePath);
        recurFiles.deleteAndCreateFolder();
        list.forEach((k, v) -> {
            Ext keys = k; 
            List<groupByext> vals = v;
            
            if(keys == groupByext.Ext.xlsx || keys == groupByext.Ext.xls) {
                Stream<groupByext> stream = vals.stream();
                Stream<File> fNameStream = stream.map(a -> a.getFullPath());

                fNameStream.forEach(b -> {
                    try {
                        createExcel.createExcelFile(b);
                        
                    } catch(Exception e1) {
                        e1.printStackTrace();
                    }
                    
                });
                
            } 
            else if(keys == groupByext.Ext.idml) {
                Stream<groupByext> stream = vals.stream();
                Stream<File> fNameStream = stream.map(a -> a.getFullPath());

                fNameStream.forEach(b -> {
                    try {
                        createIdmlFile createIDML = new createIdmlFile(); 
                        createIDML.createIdmlFile(b);
                        
                    } catch(Exception e2) {
                        e2.printStackTrace();
                    }
                });
            }
            
        });
    }
    
}
