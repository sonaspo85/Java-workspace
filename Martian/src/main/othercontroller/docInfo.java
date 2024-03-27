package main.othercontroller;

import java.io.File;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import main.Common.implementOBJ;



public class docInfo {
    implementOBJ obj = new implementOBJ();
    Map<String, List<String>> workinglngMap = new HashMap<>();


    public void runExtractXML() throws Exception {
        String docInfoS = obj.resourceDir + File.separator + "docInfo.xml";
        Path path = Paths.get(docInfoS);
        Files.deleteIfExists(path);

        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.newDocument();

        // 루트 요소 만들기
        Element ele = doc.createElement("root");
        ele.setAttribute("type", obj.type);
        ele.setAttribute("videoSwitch", obj.ridioTxt);
        ele.setAttribute("modelNumber", obj.modelNumber);
        ele.setAttribute("remoteswitch", obj.remoteswitch);
        ele.setAttribute("remoconURL", obj.remoconTxt);
        ele.setAttribute("manualType", obj.manualType);

        Element item = doc.createElement("item");
        item.setAttribute("id", "projectDir");
        item.setAttribute("path", obj.projectDir);
        ele.appendChild(item);

        Element item2 = doc.createElement("item");
        item2.setAttribute("id", "srcDir");
        item2.setAttribute("path", obj.srcPathP.toString());
        ele.appendChild(item2);

        Element item3 = doc.createElement("item");
        item3.setAttribute("id", "resourceDir");
        item3.setAttribute("path", obj.resourceDir.toString());
        ele.appendChild(item3);

        Element item4 = doc.createElement("item");
        item4.setAttribute("id", "tempDir");
        item4.setAttribute("path", obj.tempDir.toString());
        ele.appendChild(item4);

        Element item5 = doc.createElement("item");
        item5.setAttribute("id", "xslsDir");
        item5.setAttribute("path", obj.xslsDir.toString());
        ele.appendChild(item5);

        Element item6 = doc.createElement("item");
        item6.setAttribute("id", "excelTemplsDir");
        item6.setAttribute("path", obj.excelTemplsPathP.toString());
        ele.appendChild(item6);

        Element item8 = doc.createElement("item");
        
        String item8data = getItem8();
        
        item8.setAttribute("id", "langsMap");
        item8.setAttribute("sequence", item8data);
        ele.appendChild(item8);

        doc.appendChild(ele);
        obj.xmlTransform(docInfoS, doc);

    }
    
    public void workinglngs() {
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(obj.srcPathP);
            
            ds.forEach(a -> {
                String isocode = a.getFileName().toString();
                Path abspath = a.toAbsolutePath();
                
                if(Files.isDirectory(a) && !isocode.contains("temp")) {
                    List<String> list = new ArrayList<>();
                    
                    try {
                        DirectoryStream<Path> ds2 = Files.newDirectoryStream(a);
                        
                        ds2.forEach(b -> {
                            String getName2 = b.getFileName().toString();
                            String filename = "";
                            String srcimgpath = "";
                            String abspath2 = b.toAbsolutePath().toString();
                            
                            
                            if(Files.isDirectory(b) && getName2.contains("images")) {
                                srcimgpath = abspath2;
                                
                            } else if(Files.isRegularFile(b) && getName2.contains(".idml")) {
                                filename = getName2.replace(".idml", "");
                            }

                            list.add(filename);
                            list.add(srcimgpath);
                            
                            workinglngMap.put(isocode, list);
                        });
                        
                    } catch(Exception e2) {
                        e2.printStackTrace();
                    }
                    
                }
                
            });
            
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
    }
    
    public String getItem8() {
        String item8data = "";
        
        for(int y=0; y< obj.langL2.size(); y++) {
            String lang2Item = obj.langL2.get(y);
            
            Set<String> keySet = obj.matchlangMap.keySet();
            Iterator <String> iterator = keySet.iterator();
            
            while (iterator.hasNext()) {
                String key = iterator.next();
                String isocode = obj.matchlangMap.get(key);
                
                if(lang2Item.equals(key)) {
                    item8data += lang2Item + "=" + isocode;
                }
                
            }
            
            if (y != obj.langL2.size()-1) {
                item8data += ", ";
                
            }
            
        }
        
        return item8data;
    }
    
}