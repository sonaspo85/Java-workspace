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

public class mmiExportUpdate {
	File selectedDir = null;
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
    String newPvTemP = "";
    xsltreadPath xsltreadPath = null;
    
    String sMapDir = null;
    String outMapDir = "";
    String strlb1 = "";
    String strcb1 = "";
    String strcb2 = "";
    String strcb3 = "";
    String strcb4 = "";
    String keyword = "";
    
    
	public mmiExportUpdate(File selectedDir, String pvPath, String newPvPath) {
		this.selectedDir = selectedDir;
		this.pvPath = pvPath;
		this.newPvPath = newPvPath;
		
		Path newPvPathP = Paths.get(newPvPath);
		newPvTemP = newPvPathP.getParent() + File.separator + "temp";
	}
	
	public mmiExportUpdate(Path sMapDir, String outMapDir, String pvPath, String strlb1, String strcb1, String strcb2, String strcb3, String strcb4, String keyword) {
		this.sMapDir = sMapDir.toString();
		this.outMapDir = outMapDir;
	    this.pvPath = pvPath;
	    this.strlb1 = strlb1;
	    this.strcb1 = strcb1;
	    this.strcb2 = strcb2;
	    this.strcb3 = strcb3;
	    this.strcb4 = strcb4;
	    this.keyword = keyword; 
	}
	
	
	public void runmmiUpdate() {
		try {
			String inF = obj.libDir + File.separator + "z9-xslt-mmiUpdate.xml";
	        String switch1 = "xslt";
	        runReadPath(inF, switch1);
			
	        processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
		} catch (Exception e) {
		    msg = "mmiExportUpdate -> z9-mmiUpdate.xml 예외 발생";
            throw new RuntimeException(msg);
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
                        
                        if(xslt.contains("01-only-mmiSeg.xsl")) {
                        	in = obj.ditaxsls + File.separator + "dummy.xml";
                        	text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} sMapDir={5} keyword={6} lang={7}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, sMapDir, keyword, strlb1);
                            runList.add(result);
                            
                        } else if(xslt.contains("02-unique-only-mmiSeg.xsl"))  {
                        	text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} sMapDir={5}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, sMapDir);
                            runList.add(result);
                            
                        } else if(xslt.contains("03-groupingHash.xsl"))  {
                            in = obj.ditaxsls + File.separator + "dummy.xml";
                            out = newPvTemP + File.separator + ele.getAttribute("out") + " "; 
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} selectedDir={5}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, selectedDir);
                            runList.add(result);
                            
                        } else if(xslt.contains("04-export-uniqueSeg.xsl"))  {
                            in = newPvTemP + File.separator + ele.getAttribute("in") + " ";
                            out = newPvTemP + File.separator + ele.getAttribute("out") + " "; 
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
                            runList.add(result);
                            
                        } else if(xslt.contains("05-pv-mmi-update.xsl"))  {
                            in = pvPath + " ";
                            out = newPvPath; 
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} newPvTemP={5}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, newPvTemP);
                            runList.add(result);
                            
                        } 

                    }

                }

            }
        } catch (FileNotFoundException e) {
            msg = "mmiExportUpdate -> runReadPath() 메소드 예외 발생";
            throw new RuntimeException(msg);
        }
	    
	}
	
	
	public void runmmiExportxsl() {
        String inF = obj.libDir + File.separator + "z6-xslt-mmi-Export.xml";
        String switch1 = "xslt";

        try {
        	runReadPath(inF, switch1);
            
            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
        } catch (Exception e1) {
            msg = "mmiExportUpdate -> runmmiExportxsl() 메소드 예외 발생";
            throw new RuntimeException(msg);
        }
    }
	
	
	
	
	
}
