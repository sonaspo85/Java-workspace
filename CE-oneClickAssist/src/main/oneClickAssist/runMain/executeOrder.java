package main.oneClickAssist.runMain;

import java.io.File;
import java.io.InputStream;
import java.net.URI;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.om.NamespaceConstant;

public class executeOrder {
    Path tarF = null;
    Path tarDir = null;
    Path xslPath = null;
    String srcPath = "";
    public ArrayList<InOutPathClas> list = new ArrayList<>();

    public executeOrder(Path tarF, File jarPath, String srcPath) {
        this.tarF = tarF;
        tarDir = tarF.getParent();
        this.xslPath = Paths.get(jarPath + File.separator + "xsls");
        this.srcPath = srcPath;
    }

    public void setList() {
        System.out.println("setList 시작");
        String tarStr = tarF.toString();

        ClassLoader cl = executeOrder.class.getClassLoader();
        list.add(new InOutPathClas(tarF.toAbsolutePath(), tarDir + "\\001.xml", cl.getResourceAsStream("main/xslt/001.xsl")));
        
        if (Files.exists(tarDir)) {
            try {
                recursDel(tarDir);

            } catch (Exception e2) {
                e2.printStackTrace();
            }

        }

        try {
            executeXslt();
            moveSrcPath(tarDir);
            list.clone();
            // temp 폴더 삭제
            deleteTemp(tarDir);
            
        } catch(Exception e2) {
            e2.printStackTrace();
        }
        
    }
    
    public void moveSrcPath(Path tarDir) throws Exception {
        DirectoryStream<Path> ds = Files.newDirectoryStream(tarDir);

        ds.forEach(a -> {
            try {
                if(Files.isRegularFile(a) && a.toString().endsWith("html")) {
                    
                    String newFile = srcPath + File.separator + a.getFileName();
                    Path newPath = Paths.get(newFile);
                    
                    Files.copy(a, newPath, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                    
                }
                

            } catch (Exception e1) {
                e1.printStackTrace();
            }

        });
        
        
    }

    public void recursDel(Path toPath) throws Exception {

        DirectoryStream<Path> ds = Files.newDirectoryStream(toPath);

        ds.forEach(a -> {
            try {
                if (Files.isDirectory(a)) {
                    recursDel(a);

                } else {
                    if (a.getFileName().toString().endsWith("html")) {
                        Files.delete(a);
                    }
                }

            } catch (Exception e1) {
                e1.printStackTrace();
            }

        });

    }
    
    public void deleteTemp(Path toPath) throws Exception {
        DirectoryStream<Path> ds = Files.newDirectoryStream(toPath);

        ds.forEach(a -> {
            try {
                if (Files.isDirectory(a)) {
                    deleteTemp(a);

                } else {
                    Files.delete(a);
                }

            } catch (Exception e1) {
                e1.printStackTrace();
            }
            
        });
        Files.delete(toPath);
    }

    public void executeXslt() {
        try {
            list.forEach(a -> {
                System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON,
                        "net.sf.saxon.xpath.XPathFactoryImpl");
                TransformerFactory factory = TransformerFactory.newInstance();

                File in = new File(a.getinFile().toString());
                File out = new File(a.getoutFile());
                InputStream xslt = a.getxslFile();
                
                // 1. xml 파일을 스트림으로 얻어 Source 객체로 생성
                Source inxml = new StreamSource(in);
                StreamResult outxml = new StreamResult(out);
                Source xsltF = new StreamSource(xslt);

                try {
                    Transformer tf = factory.newTransformer(xsltF);
                    File srcFile = new File(srcPath);
                    URI srcFile1 = srcFile.toURI();
                    
                    tf.setParameter("srcPath", srcFile1.toString());
                    tf.transform(inxml, outxml);
                    
                    xslt.close();
                } catch (Exception e1) {
                    e1.printStackTrace();
                }
            });

            list.clear();
            System.out.println("끝");

        } catch (Exception e1) {
            e1.printStackTrace();
        }

    }

}
