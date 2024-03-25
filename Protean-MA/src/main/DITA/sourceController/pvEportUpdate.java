package main.DITA.sourceController;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
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
import main.DITA.processBuilder.xsltreadPath;

public class pvEportUpdate {
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
    
    Path sMapDir = null;
    String outMapDir = "";
    String strlb1 = "";
    String strcb1 = "";
    String strcb2 = "";
    String strcb3 = "";
    String strcb4 = "";
    
	public pvEportUpdate(File selectedDir, String pvPath, String newPvPath) {
		this.selectedDir = selectedDir;
		this.pvPath = pvPath;
		this.newPvPath = newPvPath;
		
		Path newPvPathP = Paths.get(newPvPath);
		
		newPvTemP = newPvPathP.getParent() + File.separator + "temp";

	}
	
	public pvEportUpdate(Path sMapDir, String outMapDir, String pvPath, String strlb1, String strcb1, String strcb2, String strcb3, String strcb4) {
		this.sMapDir = sMapDir;
		this.outMapDir = outMapDir;
	    this.pvPath = pvPath;
	    this.strlb1 = strlb1;
	    this.strcb1 = strcb1;
	    this.strcb2 = strcb2;
	    this.strcb3 = strcb3;
	    this.strcb4 = strcb4;
	}
	
	
	public void runPvUpdate() {
		try {
			String inF = obj.libDir + File.separator + "z5-xslt-pvUpdate.xml";
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
            
            String ditaMa = obj.ditaotS + File.separator + "plugins/com.ast.protean.ma.um_en_2020pdf/cfg/common/vars" + File.separator + strlb1 + ".xml";
            String langsF = obj.languagesF;
            
            for(int i=0; i<nl.getLength(); i++) {
                Node node = nl.item(i);

                if(node.getNodeType() == Node.ELEMENT_NODE) {
                    Element ele = (Element) node;
                    
                    if(ele.getNodeName().equals("path")) {
                        in = outMapDir + File.separator + ele.getAttribute("in") + " ";
                        out = newPvTemP + File.separator + ele.getAttribute("out") + " ";
                        xslt = obj.ditaxsls + File.separator + ele.getAttribute("xslt") + " ";
                        catalog = obj.catalogDir + " ";
                        
                        if(xslt.contains("pv-update00.xsl")) {
                        	in = obj.ditaxsls + File.separator + "dummy.xml";
                        	text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} trPath={5}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, selectedDir);
                            runList.add(result);
                            
                        } else if(xslt.contains("pv-update01.xsl"))  {
                        	in = newPvTemP + File.separator + "pv-update00.xml";
                        	text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
                            runList.add(result);
                            
                        } else if(xslt.contains("pv-update02.xsl"))  {
                            in = newPvTemP + File.separator + "pv-update01.xml";
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
                            runList.add(result);
                            
                        } else if(xslt.contains("pv-update03.xsl"))  {
                            in = pvPath + " ";
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}  newPvTemP={5}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, newPvTemP);
                            runList.add(result);
                            
                        } else if(xslt.contains("depth-indent.xsl"))  {
                            in = newPvTemP + File.separator + "pv-update03.xml";
                            out = newPvPath;
                            
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
                            runList.add(result);
                            
                        } else if(xslt.contains("multi-export.xsl")) {
                            in = outMapDir + File.separator + strlb1 + ".dita";
                            out = outMapDir + File.separator + "4_TR" + File.separator + strlb1 + File.separator + "TR2-" + strlb1 + ".xml" + " ";
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} pvPath={5} ditaMa={6} langsF={7}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, pvPath, ditaMa, langsF);
                            runList.add(result);
                            
                        } else if(xslt.contains("tr-export.xsl")) {
                            in = outMapDir + File.separator + strlb1 + ".dita";
                            out = outMapDir + File.separator + "4_TR" + File.separator + strlb1 + File.separator + "TR1-" + strlb1 + ".xml" + " ";
                            
                            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} pvPath={5} lang={6} sMapDir={7}  ditaMa={8} langsF={9}";
                            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, pvPath, strlb1, sMapDir, ditaMa, langsF);
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
	
	
	public void runExportxsl() {
        System.out.println("runExportxsl() 시작");
        
        String inF = obj.libDir + File.separator + "z2-2-xslt-exportTR.xml";
        
        String switch1 = "xslt";

        try {
        	runReadPath(inF, switch1);
            
            processBuilder pb = new processBuilder(runList, switch1);
            pb.runProcessBuilder();
            
        } catch (Exception e1) {
            msg = e1.getMessage();
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
//          e1.printStackTrace();
        }
    }
	
	
	
	
	
}
