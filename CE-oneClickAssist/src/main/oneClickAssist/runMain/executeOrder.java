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
//        Path rrr = Paths.get("H:/Batch/CE/Aircon/Bat/insertQRcode/resources/temp/QRcodes1.xml");
//        list.add(new InOutPathClas(rrr.toString(), tarDir + "\\001.xml", cl.getResourceAsStream("main/xslt/001.xsl")));
        list.add(new InOutPathClas(tarF.toAbsolutePath(), tarDir + "\\001.xml", cl.getResourceAsStream("main/xslt/001.xsl")));
//        System.out.println("qqqqqq: " + tarF.toAbsolutePath());
        if (Files.exists(tarDir)) {
            try {
                recursDel(tarDir);

            } catch (Exception e2) {
                System.out.println("temp 폴더 삭제 실패");
                e2.printStackTrace();
            }

        }

        try {
            // xslt 실행
            executeXslt();
            
            // 오리지날 파일에 다시 덮어쓰기
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
//                    Files.move(a, newPath, StandardCopyOption.REPLACE_EXISTING);
                    
                }
                

            } catch (Exception e1) {
                e1.printStackTrace();
            }

        });
        
        
    }

    // temp 폴더내 재귀적 삭제
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
        System.out.println("executeXslt 시작");

        try {
            list.forEach(a -> {
                System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON,
                        "net.sf.saxon.xpath.XPathFactoryImpl");
                TransformerFactory factory = TransformerFactory.newInstance();

                File in = new File(a.getinFile().toString());
                File out = new File(a.getoutFile());
                InputStream xslt = a.getxslFile();
                
                /*
                URI in1 = in.toURI();
                URI out1 = out.toURI();
                System.out.println("aaa: " + in1.getPath());
                System.out.println("bbb: " + out1.getPath());
                */
                // 1. xml 파일을 스트림으로 얻어 Source 객체로 생성
                Source inxml = new StreamSource(in);
                
                // 출력 스트림을 통해 생성될 파일 지정
                StreamResult outxml = new StreamResult(out);

                // xslt 지정
                Source xsltF = new StreamSource(xslt);

                try {
                    // Transformer 객체를 생성하는데 매개 변수로 xslt 파일을 입력스트림으로 사용하고 있는 변수 할당
                    Transformer tf = factory.newTransformer(xsltF);
                    File srcFile = new File(srcPath);
                    URI srcFile1 = srcFile.toURI();
                    
                    // srcFile1: file:/H:/Batch/CE/Aircon/Bat/insertQRcode/dddr%20esources/
                    System.out.println("srcFile1: " + srcFile1);
                    tf.setParameter("srcPath", srcFile1.toString());
                    tf.transform(inxml, outxml);
                    
                    xslt.close();
//                    outxml.getOutputStream().close();
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
