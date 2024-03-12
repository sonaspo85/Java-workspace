package main.othercontroller;

import java.io.File;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;

import main.Common.implementOBJ;



public class srcRunRepeat {
    implementOBJ obj = new implementOBJ();
    public String msg = "";
    Path eachSrcP = null;
    
    
    public srcRunRepeat(Path eachSrcP) {
        this.eachSrcP = eachSrcP;
        
    }
    
    public void runEachSrc() {
        System.out.println("runEachSrc() 시작");
        
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(eachSrcP);
            
            ds.forEach(a -> {
                String absSrcpath = a.toAbsolutePath().toString();
//                System.out.println("absSrcpath: " + absSrcpath);
                String filename = a.getFileName().toString();
                
                transformXSLT tf = new transformXSLT();
                try {
                    tf.runConvertHTMLBat(absSrcpath);
                    
                } catch (Exception e) {
                    msg = "XSLT 실행 실패";
                    System.out.println("msg: " + msg);
//                    e.printStackTrace();
                    throw new RuntimeException(msg);
                }  
                
            });
            
            File oldF = new File(obj.resourceDir + "/docInfo.xml");
            oldF.delete();
            
            File newF = new File(obj.resourceDir + "/docInfo2.xml");

            newF.renameTo(oldF);
            
        } catch(Exception e) {
            msg = "eachSrc 폴더내 xml 접근 실패";
            System.out.println("msg: " + msg);
//            e.printStackTrace();
            throw new RuntimeException(msg);
        }
        
        
    }
}
