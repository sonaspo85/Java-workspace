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

public class tmxExportUpdate {
	File selectedtmxF = null;
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
//    String newtmxTemP = "";
    xsltreadPath xsltreadPath = null;
    
    String sMapDir = null;
    String outMapDir = "";
    String strlb1 = "";
    String strcb1 = "";
    String strcb2 = "";
    String strcb3 = "";
    String strcb4 = "";
    
    
	public tmxExportUpdate(Path sMapDir, String outMapDir, String pvPath, String strlb1, String strcb1, File selectedtmxF) {
	    this.sMapDir = sMapDir.toString();
	    this.outMapDir = outMapDir;
	    this.pvPath = pvPath;
	    this.strlb1 = strlb1;
	    this.strcb1 = strcb1;
		this.selectedtmxF = selectedtmxF;

		
		
	}
	
	public tmxExportUpdate(Path sMapDir, String outMapDir, String pvPath, String strlb1, String strcb1, String strcb2, String strcb3, String strcb4) {
		this.sMapDir = sMapDir.toString();
		this.outMapDir = outMapDir;
	    this.pvPath = pvPath;
	    this.strlb1 = strlb1;
	    this.strcb1 = strcb1;
	    this.strcb2 = strcb2;
	    this.strcb3 = strcb3;
	    this.strcb4 = strcb4;
	}
	
	
	public void runtmxExport() {
		try {
			String inF = obj.libDir + File.separator + "z11-xslt-create-tmx.xml";
			System.out.println("inF: " + inF);
	        String switch1 = "xslt";
	        runReadPath(inF, switch1);
	        processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
		} catch (Exception e) {
		    msg = e.getMessage();
            throw new RuntimeException(e);
        }
		
	}
	
	public void runtmxUpdate() {
        try {
            String inF = obj.libDir + File.separator + "z12-xslt-split-tmx.xml";
            System.out.println("inF: " + inF);
            String switch1 = "xslt";
            
            runReadPath(inF, switch1);
            
            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
        } catch (Exception e) {
            msg = e.getMessage();
            throw new RuntimeException(e);
        }
        
        
    }
	

	public void runReadPath(String inF, String switch1) throws Exception {
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
                        in = outMapDir + File.separator + ele.getAttribute("in") + " ";
                        out = outMapDir + File.separator + ele.getAttribute("out") + " ";
                        xslt = obj.ditaxsls + File.separator + ele.getAttribute("xslt") + " ";
                        
                        catalog = obj.catalogDir + " ";

                        if(xslt.contains("01-extractSrcTar.xsl")) {
                            in = outMapDir + File.separator + strlb1 + ".dita";
                        	text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} manualPath={5}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, sMapDir);
                            runList.add(result);
                            
                        } else if(xslt.contains("08-splitLang.xsl")) {
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} manualPath={5}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, outMapDir);
                            runList.add(result);
                            
                        } else if(xslt.contains("05-changeTagsName.xsl")) {
                            out = outMapDir + File.separator + ele.getAttribute("out") + " ";
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
                            runList.add(result);
                            
                        } else {
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
                            runList.add(result);
                            
                            
                        }

                    }

                }

            }
        } catch (FileNotFoundException e) {
            msg = e.getMessage();
            throw new RuntimeException(e);
        }
	    
	}
	
	
	
	
	
	
	
	
}
