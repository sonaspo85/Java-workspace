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
        System.out.println("runGetImgList() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(newImagePathP);
            
            ds.forEach(a -> {
                if(Files.isRegularFile(a)) {
                    String fileName = a.getFileName().toString();
                    
                    if(fileName.endsWith(".png")) {
                        // Sanselan API를 사용하여 이미지 정보 추출
                        getImgInfo(a);
                        
                        
                    } else if(fileName.endsWith(".ai")) {
                        getAiInfo(a);
                        
                        
                    }

                } 
                
            });
            
            
        } catch(Exception e) {
            
            
        }
        /*
        imgMap.forEach((k, v) -> {
            String fileName = k;
            List<String> list = v;
           
            System.out.println("fileName: " + fileName);
            list.forEach(a -> {
               System.out.println("aa: " + a); 
            });
        });
        */
        
    }
    
    public void getAiInfo(Path a) {
//        System.out.println("getAiInfo() 시작");
        String fileName = a.getFileName().toString();
        try {
            FileInputStream fis = new FileInputStream(a.toString());
            Reader reader = new InputStreamReader(fis, "UTF-8");
            
            // BufferedReader 문자 입력 스트림을 사용하여 한라인씩 읽기
            BufferedReader br = new BufferedReader(reader);
            
            
            int readCharNo;  // read() 메소드가 반환 하는 총 바이트 수 저장
            char[] cbuf = new char[100];  // 읽은 데이터를 저장할 배열
            
            String s = "";
            String width = "";
            String height = "";
            String unit = "";
            // while 반복문을 이용하여 -1을 반환할때까지 데이터 읽기
            while((s = br.readLine()) != null) {
                if(s.contains("<stDim:w>")) {
                    width = s;
                    
                } else if(s.contains("<stDim:h>")) {
                    height = s;
                } else if(s.contains("<stDim:unit>")) {
                    unit = s;
                }
                
//                System.out.println(data);
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
            
            
//          System.out.println("a.getFileName(): " + a.getFileName());
//          System.out.println("width: " + width);
//          System.out.println("height: " + height);
//          System.out.println("unit: " + unit);
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
//        System.out.println("getImgInfo() 시작");
        List<String> list = new ArrayList<>();
        try {
            File file = a.toFile();
            ImageInfo imageInfo = Sanselan.getImageInfo(file);
            String imgWidth = String.valueOf(imageInfo.getWidth());
            String imgHeight = String.valueOf(imageInfo.getHeight());
            
            String imgdpi = String.valueOf(imageInfo.getPhysicalWidthDpi());
            
            
//            System.out.println("imgWidth: " + imgWidth + ", " + "imgHeight: "  + imgHeight + ", " + "imgdpi2: " + imgdpi);
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
