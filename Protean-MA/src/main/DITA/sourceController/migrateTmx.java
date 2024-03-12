package main.DITA.sourceController;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.DITA.Common.implementOBJ;
import main.DITA.processBuilder.ditareadPath;
import main.DITA.processBuilder.processBuilder;

public class migrateTmx {
    File selectedDir = null;
    implementOBJ obj = new implementOBJ();
    public List<String> runList = new ArrayList<>();
    
    String transform = "java net.sf.saxon.Transform";
    String text = "";
    String in = "";
    String out = ""; 
    String xslt = ""; 
    String catalog = "";
    String tempDir = "";
    String msg = "";
    
    public migrateTmx(File selectedDir) {
        this.selectedDir = selectedDir;
        
        tempDir = selectedDir + File.separator + "temp";
        File tempDirF = new File(tempDir);
        
        if(!tempDirF.exists()) {
            tempDirF.mkdirs();
        }
        
    }
    
    public void runMigrateTmx() {
        System.out.println("runMigrateTmx() 시작");
        String inF = obj.libDir + File.separator + "z13-xslt-migrate-tmx.xml";
        String switch1 = "xslt";
        
        try {
            Path tmxP = Paths.get(selectedDir.toString());
            
            DirectoryStream<Path> ds = Files.newDirectoryStream(tmxP);
            
            ds.forEach(a -> {
                String fullPath = a.toAbsolutePath().toString();
                String fileName = a.getFileName().toString();
                
                if(fileName.contains(".tmx")) {
                    try {
                        runReadPath(fullPath, inF, switch1);
                        
                        
                        processBuilder pb = new processBuilder(runList, switch1);
                        pb.runProcessBuilder();
                        
                    } catch (Exception e) {
                        msg = "migrateTmx -> runMigrateTmx() 예외 발생";
                        System.out.println("msg: " + msg);
                        throw new RuntimeException(msg);
                    }
                    
                }

            });
            
        } catch(Exception e) {
            msg = "migrateTmx -> runMigrateTmx() 예외 발생";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        }

    }
    
    public void runReadPath(String fullPath, String inF, String switch1) throws Exception {
        System.out.println("runReadPath() 시작");
        runList.clear();
        
        
        try {
            FileInputStream fis = new FileInputStream(inF);
            Reader reader = new InputStreamReader(fis, "UTF-8");
            InputSource is = new InputSource(reader);
            is.setEncoding("UTF-8");
            
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            dbf.setNamespaceAware(true);
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(is);
            
            Element rootEle = doc.getDocumentElement();
            
            NodeList nl =  rootEle.getChildNodes();
            
            for(int i=0; i<nl.getLength(); i++) {
                Node node = nl.item(i);
                
                if(node.getNodeType() == Node.ELEMENT_NODE) {
                    Element ele = (Element) node;
                                        
                    if(ele.getNodeName().equals("path")) {
                        in = tempDir + File.separator + ele.getAttribute("in") + " ";
                        out = tempDir + File.separator + ele.getAttribute("out") + " ";
                        xslt = obj.ditaxsls + File.separator + ele.getAttribute("xslt") + " ";
                        catalog = obj.catalogDir + " ";
                        
                        if(xslt.contains("01-tm-migrate.xsl")) {
                            in = fullPath;
                            
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);

                            System.out.println("result: " + result);
                            
                            runList.add(result);
                            
                        } else {
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);

                            System.out.println("result: " + result);
                            
                            runList.add(result);
                            
                        }
                        
                        
                    }

                }

            }
            
        } catch (FileNotFoundException e) {
            msg = e.getMessage();
            System.out.println("msg: " + msg);
            throw new RuntimeException(e);
        }
    }
    
    
}
