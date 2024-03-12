package main.DITA.sourceController;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.Reader;
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
import main.DITA.processBuilder.xsltreadPath;

public class integratePV {
	String selectedDir = null;
	String pvPath = "";
	String newPvPath = "";
	implementOBJ obj = new implementOBJ();
    public List<String> runList = new ArrayList<>();
    String msg = "";
    
    String transform = "java net.sf.saxon.Transform";
    String text = "";
    String in = "";
    String out = ""; 
    String xslt = ""; 
    String catalog = "";
    String tempDir = "";
    xsltreadPath xsltreadPath = null;
    
    String sMapDir = null;
    String outMapDir = "";
    String strlb1 = "";
    String strcb1 = "";
    String strcb2 = "";
    String strcb3 = "";
    String strcb4 = "";
    String keyword = "";
    
    
	public integratePV(File selectedDir, String pvPath, String newPvPath) {
		this.selectedDir = selectedDir.toString();
		this.pvPath = pvPath;
		this.newPvPath = newPvPath;
		
		tempDir = selectedDir.toString();
	}
	
	
	public void runPvUpdate() {
		System.out.println("runPvUpdate() 시작");
		try {
			String inF = obj.libDir + File.separator + "z14-xslt-integrate-pv.xml";
			System.out.println("inF: " + inF);
	        String switch1 = "xslt";
	        
	        runReadPath(inF, switch1);
			
	        processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
		} catch (Exception e) {
		    msg = "mmiExportUpdate -> z14-xslt-integrate-pv.xml 예외 발생";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        }

	}

	public void runReadPath(String inF, String switch1) throws Exception {
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
                        
                        
                        if(xslt.contains("01-mergedFiles.xsl")) {
                        	in = obj.ditaxsls + File.separator + "dummy.xml";
                        	text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} selectedDir={5}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, selectedDir);

                            System.out.println("result: " + result);
                            
                            runList.add(result);
                            
                        } else if(xslt.contains("04-indent.xsl")) {
                            out = newPvPath;
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
            msg = "mmiExportUpdate -> runReadPath() 메소드 예외 발생";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
        }
	    
	}
	
	
	
	
}
