package main.DITA.processBuilder;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
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

public class ditareadPath {
    implementOBJ obj = new implementOBJ();
    String inoutPath = "";
    public List<String> list = new ArrayList<>();
    String srcDir = "";
    String outDir = "";
    String ditaotDirS = "";
    String catalogDir = "";
    String transtype = "";
    String strlb1 = "";
    String switch1 ="";
    String msg = "";
    
    String calldita = "";
    String in = "";
    String out = "";
    
    String filter = "";
    String text = "";
    String result = "";
    
    public ditareadPath(String srcDir, String outF, String transtype, String strlb1) {
        
        this.srcDir = srcDir.replaceAll(" ", "%20");
        this.outDir = outF.replaceAll(" ", "%20");
        ditaotDirS = obj.ditaotS;
        catalogDir = obj.ditaotS + File.separator + "catalog-dita.xml";
        this.transtype = transtype; 
        this.strlb1 = strlb1;
        
        
        calldita = ditaotDirS + File.separator + "bin/dita.bat";
    }
    
    public void runReadPath(String inoutPath, String switch1) throws Exception {
        System.out.println("runReadPath() 시작");
        
        this.inoutPath = inoutPath;
        this.switch1 = switch1;
        
        try {
            FileInputStream fis = new FileInputStream(inoutPath);
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
                        in = srcDir + File.separator + ele.getAttribute("in") + " ";
                        out = outDir + File.separator + ele.getAttribute("out") + " ";
                        
                        if(switch1.equals("dita")) {
                            formattingDita();

                        } 

                    }
                }
            
            }

        } catch (Exception e) {
            msg = "inoutpath.xml 읽기 실패";
            throw new RuntimeException(msg);
//            e.printStackTrace();
        }
    }
    
    public void formattingDita() {
        System.out.println("formattingDita() 시작");
        String ANT_OPTS = "-Xmx2048M";
        if(in.contains("PROJECT.ditamap")) {
            filter = obj.filterS + File.separator + strlb1 + ".ditaval";
            text = "{0}  --input={1} --output={2} --transtype={3} --args.filter={4} -Denv.ANT_OPTS={5}";
            
            result = MessageFormat.format(text, calldita, in, out, transtype, filter, ANT_OPTS);
            list.add(result);
            
        } else if(in.contains("master-final.dita")) {
            String AXF_OPT = obj.pdfSetting + File.separator + "pdf-settings.xml";
            String font_config = obj.pdfSetting + File.separator + "font-config.xml";
            
            text = "{0}  --input={1} --output={2} --transtype={3} -Dlgs={4} -Denv.AXF_OPT={5} -Denv.AHF71_32_FONT_CONFIGFILE={6} -Denv.ANT_OPTS={7} --generate-debug-attributes=false";
            result = MessageFormat.format(text, calldita, in, out, transtype, strlb1, AXF_OPT, font_config, ANT_OPTS);
            System.out.println("result: " + result);
            
            list.add(result);
            
        } else if(in.contains("preview.dita")) {
            String tempDir = outDir + File.separator + "temp";
            String outext = "html"; 
            text = "{0}  --input={1} --output={2} --transtype={3} --dita.temp.dir={4} args.outext={5} lang={6}";
            result = MessageFormat.format(text, calldita, in, out, transtype, tempDir, outext, strlb1);
            System.out.println("result: " + result);
            
            list.add(result);
            
        } else if(in.contains("final-lang.dita")) {
            String AXF_OPT = obj.pdfSetting + File.separator + "pdf-settings.xml";
            String font_config = obj.pdfSetting + File.separator + "font-config.xml";
            
        	in = outDir + File.separator + "final-" + strlb1 + ".dita";
        	text = "{0}  --input={1} --output={2} --transtype={3} -Dlgs={4} -Denv.AXF_OPT={5} -Denv.AHF71_32_FONT_CONFIGFILE={6} -Denv.ANT_OPTS={7} --generate-debug-attributes=false";
        	result = MessageFormat.format(text, calldita, in, out, transtype, strlb1, AXF_OPT, font_config, ANT_OPTS);
        	System.out.println("result: " + result);
          
        	list.add(result);
            
        }
        
    }
    
    public List<String> getPath() {
        return list;
    }
    
    
}
