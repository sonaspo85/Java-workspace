package main.DITA.imgController;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.sanselan.ImageInfo;
import org.apache.sanselan.ImageReadException;
import org.apache.sanselan.Sanselan;



public class getImgList {
    Path newImagePathP = null;
    Map<String, List<String>> imgMap = new HashMap<>(); 
    
    
    public getImgList(Path newImagePathP) {
        this.newImagePathP = newImagePathP;
        
    }
    
    
    public void runGetImgList() {
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(newImagePathP);
            
            ds.forEach(a -> {
                if(Files.isRegularFile(a)) {
                    String fileName = a.getFileName().toString();
                    
                    if(fileName.endsWith(".png")) {
                        getImgInfo(a);
                        
                        
                    } else if(fileName.endsWith(".ai")) {
                        getAiInfo(a);
                    }

                } 
                
            });
            
            
        } catch(Exception e) {
            
            
        }
        
    }
    
    public void getAiInfo(Path a) {
        String fileName = a.getFileName().toString();
        try {
            FileInputStream fis = new FileInputStream(a.toString());
            Reader reader = new InputStreamReader(fis, "UTF-8");
            BufferedReader br = new BufferedReader(reader);
            
            int readCharNo;
            char[] cbuf = new char[100];
            
            String s = "";
            String width = "";
            String height = "";
            String unit = "";
            while((s = br.readLine()) != null) {
                if(s.contains("<stDim:w>")) {
                    width = s;
                    
                } else if(s.contains("<stDim:h>")) {
                    height = s;
                } else if(s.contains("<stDim:unit>")) {
                    unit = s;
                }
            }
            
            reader.close();
            
            List<String> list = new ArrayList<>();
            String[] resultsW =  StringUtils.substringsBetween(width,"<stDim:w>","</stDim:w>");
            String[] resultsH =  StringUtils.substringsBetween(height,"<stDim:h>","</stDim:h>");
            String[] resultsU =  StringUtils.substringsBetween(unit,"<stDim:unit>","</stDim:unit>");
            width = String.join("", resultsW);
            
            height = String.join("", resultsH);
            unit = String.join("", resultsU);
          
            if(fileName.contains("M-notice") | fileName.contains("M-caution")) {
                width = "6";
                height = "6";
                
            } else if(fileName.contains("M-warning")) {
                width = "6";
                height = "5.434";
                
            } else if(fileName.contains("M-service")) {
                width = "16.411";
                height = "15.114";
                
            } else if(fileName.contains("M-recycle")) {
                width = "15.399";
                height = "14.731";
            }
            
          String unit2 = "";
          if(unit.contains("Millimeters")) {
              unit2 = "mm";
              
          } else if(unit.contains("Pixels")) {
              unit2 = "px";
              
          } else if(unit.contains("Centimeters")) {
              unit2 = "cm";
              
          } else if(unit.contains("Points")) {
              unit2 = "pt";
              
          } else if(unit.contains("Inches")) {
              unit2 = "in";
              
          } else if(unit.contains("Hectares")) {
              unit2 = "H";
          }
          
          list.add(width);
          list.add(height);
          list.add("none");
          list.add(unit2);
          
          imgMap.put(fileName, list);

            
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        
    }
    
    
    public void getImgInfo(Path a) {
        List<String> list = new ArrayList<>();
        try {
            File file = a.toFile();
            ImageInfo imageInfo = Sanselan.getImageInfo(file);
            String imgWidth = String.valueOf(imageInfo.getWidth());
            String imgHeight = String.valueOf(imageInfo.getHeight());
            String imgdpi = String.valueOf(imageInfo.getPhysicalWidthDpi());
            
            list.add(imgWidth);
            list.add(imgHeight);
            list.add(imgdpi);
            list.add("px");
            imgMap.put(file.getName(), list);
            
        } catch (ImageReadException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        } catch (IOException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        
        
    }
    
    public Map<String, List<String>> getMapCollection() {
        return imgMap;
    }

}
