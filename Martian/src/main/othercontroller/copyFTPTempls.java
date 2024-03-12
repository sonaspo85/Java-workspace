package main.othercontroller;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import main.Common.implementOBJ;
import main.ftpcontroller.ftpDownLoad;




public class copyFTPTempls {
    implementOBJ obj = new implementOBJ();
    String msg = "";
    
    
    public void runFTPTempls() throws Exception {
        System.out.println("runFTPTempls() 시작");
        
        String docInfoS = obj.resourceDir + File.separator + "docInfo.xml";
        
        Document doc = obj.readFile(docInfoS);
        Element root = doc.getDocumentElement();
        NodeList nl = root.getChildNodes();
        
        
        for(int j=0; j<nl.getLength(); j++) {
            Node node1 = nl.item(j);
            
            if(node1.getNodeType() == Node.ELEMENT_NODE) {
                Element child = (Element) node1;
                
                if(child.getAttribute("id").equals("workinglngs")) {
                    String srcimgpath = child.getAttribute("srcimgpath");
                    String outputpath = child.getAttribute("outputpath");
                    
                    System.out.println("srcimgpath: " + srcimgpath);
                    System.out.println("outputpath: " + outputpath);
                    
                    
                    try {
                        String ftpdir = "/tcs/confidential/Martian/Templates/html_templates";
                        
                        ftpDownLoad ftpD = new ftpDownLoad(ftpdir, outputpath, "htmlTempls");
                        ftpD.runFTP();

                    } catch (Exception e) {
                        msg = "html templates를 다운로드 실패!";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                    // 파일 복사
                    try {
                        copyImgFolder(srcimgpath, outputpath);
                        
                    } catch(Exception e) {
                        msg = "이미지 폴더 복사 실패!";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                        
                    }
                    
                    
                } 
                
                
            }

        }

    }
    
    public void copyImgFolder(String srcimgpath, String outputpath) {
        System.out.println("copyImgFolder() 시작");
        
        Path oldsrcimgP = Paths.get(srcimgpath);
        
        String newOutSrcpathS = outputpath + "/contents/images";
        Path newOutSrcpathP = Paths.get(newOutSrcpathS);
        
        if(Files.exists(oldsrcimgP)) {
            try {
                DirectoryStream<Path> ds = Files.newDirectoryStream(oldsrcimgP);
                
                ds.forEach(a -> {
                    if(Files.isDirectory(a)) {
                        String getName = a.getFileName().toString();
                        Path newDir = Paths.get(newOutSrcpathP + File.separator + getName);
                        System.out.println("newDir" + newDir);
                        
                        try {
                            Files.createDirectories(newDir);
                            
                            copyImgFolder("", "");
                            
                        } catch(Exception e) {
                            System.out.println("폴더 생성 실패");
                            
                            msg = "이미지 폴더 복사 실패!";
                            System.out.println("msg: " + msg);
                            throw new RuntimeException(msg);
                        }
                        
                    } else if(Files.isRegularFile(a)) {
                        String getName = a.getFileName().toString();
                        
                        
                        Path parDir = a.getParent();
                        String newDir =  newOutSrcpathP + File.separator + getName;
                        System.out.println("newDir: " + newDir);
                        
                        File qdir = new File(a.toString());
                        Path qto = Paths.get(newDir);
                        
                        
                        try {
                            Files.copy(a, qto, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                            
                        } catch (IOException e) {
                            
                            e.printStackTrace();
                        }
                        
                        
                    }
                    
                    
                });
                
                
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    
}
