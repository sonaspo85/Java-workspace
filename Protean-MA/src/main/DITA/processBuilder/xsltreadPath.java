package main.DITA.processBuilder;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
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

public class xsltreadPath {
    implementOBJ obj = new implementOBJ();
    public List<String> list = new ArrayList<>();
    
    String sMapDir = "";
    String outMapDir = "";
    String pvPath = "";
    String lb1 = "";
    String cb1 = "";
    String cb2 = "";
    String cb3 = "";
    String cb4 = "";
    String switch1 = "";
    String inF = "";

    
    String transform = "java net.sf.saxon.Transform";
    String in = "";
    String out = "";
    String xslt = "";
    String catalog = "";
    String text = "";
    String msg = "";
    String ditaMa = "";
    String langsF = "";
    
    public xsltreadPath(String sMapDir, String outMapDir, String pvPath, String lb1, String cb1, String cb2, String cb3, String cb4) {
        this.sMapDir = sMapDir.replaceAll(" ", "%20");
        this.outMapDir = outMapDir.replaceAll(" ", "%20");
        this.pvPath = pvPath;
        this.lb1 = lb1;
        this.cb1 = cb1;
        this.cb2 = cb2;
        this.cb3 = cb3;
        this.cb4 = cb4;
    }
    
    
    public xsltreadPath(String sMapDir, String outMapDir, String pvPath, String lb1, String inF, String switch1) {
        this.sMapDir = sMapDir.replaceAll(" ", "%20");
        this.outMapDir = outMapDir.replaceAll(" ", "%20");
        this.pvPath = pvPath;
        this.lb1 = lb1;
        this.inF = inF;
        this.switch1 = switch1;
    }
    
    public xsltreadPath(String outMapDir, String lb1) {
        this.outMapDir = outMapDir.replaceAll(" ", "%20");
        this.lb1 = lb1;
    }
    
    
    public void runReadPath(String inF, String switch1) throws Exception {
        list.clear();
        
        this.inF = inF;
        this.switch1 = switch1;
        ditaMa = obj.ditaotS + File.separator + "plugins/com.ast.protean.ma.um_en_2020pdf/cfg/common/vars" + File.separator + lb1 + ".xml";
        langsF = obj.languagesF;
        
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
                        
                        if(switch1.equals("xslt")) {
                            formattingXslt();
                                                        
                        } else if(switch1.equals("idml")) {
                            formattingIdml();
                            
                        } else if(switch1.equals("html")) {
                            formattingHtml();
                            
                        }

                    }

                }

            }
            
            
        } catch (FileNotFoundException e) {
            msg = e.getMessage();
            throw new RuntimeException(e);
        }
    }
    
    public void formattingXslt() {
        String ditaMa = obj.ditaotS + File.separator + "plugins/com.ast.protean.ma.um_en_2020pdf/cfg/common/vars" + File.separator + lb1 + ".xml";
        String langsF = obj.languagesF;
        
        if(xslt.contains("master.xsl")) {
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} pvPath={5} lang={6} name={7} template={8} prodtype={9} htmlVer={10} ditaMa={11} langsF={12}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, pvPath, lb1, cb1, cb2, cb4, cb3, ditaMa, langsF);
            list.add(result);
            
        } else if(xslt.contains("target.xsl")) {
            out = outMapDir + File.separator + lb1 + ".dita" + " ";
            
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} pvPath={5} ditaMa={6} langsF={7}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, pvPath, ditaMa, langsF);
            list.add(result);
            
        } else if(xslt.contains("final.xsl")) {
            in = outMapDir + File.separator + lb1 + ".dita";
            out = outMapDir + File.separator + "final-" + lb1 + ".dita" + " ";
            
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} pvPath={5} lang={6}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, pvPath, lb1);
            
            System.out.println("result: " + result);
            list.add(result);
            
        } else if(xslt.contains("04-ExcelDB.xsl")) {
            out = outMapDir + File.separator + "ExcelDB" + File.separator + lb1 + File.separator + "exceldb.xml";
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} outMapDir={5}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, outMapDir);
            list.add(result);
            
        } else if(xslt.contains("extractSrcTar.xsl")) {
            in = outMapDir + File.separator + "final-" + lb1 + ".dita" + " ";
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} outMapDir={5}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, outMapDir);
            list.add(result);
            
        } else if(xslt.contains("insert-number.xsl")) {
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} outMapDir={5}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, outMapDir);
            list.add(result);
            
        } else {
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
            list.add(result);
        }
        
        
    }
    
    public void formattingIdml() {
        if(xslt.contains("02-block.xsl") | 
           xslt.contains("03-setImgWidthHeight.xsl") | 
           xslt.contains("04-groupingChapter.xsl") | 
           xslt.contains("05-dfinedInline.xsl") | 
           xslt.contains("06-pagebuilder.xsl")) {
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
            
            System.out.println("result: " + result);
            list.add(result);
            
        } else if(xslt.contains("01-preview.xsl")) {
            String idmlTemplsDir = obj.DiridmlTempls;
            in = outMapDir + File.separator + "final-" + lb1 + ".dita" + " ";
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} outMapDir={5} idmlTemplsDir={6}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, outMapDir, idmlTemplsDir);
            
            System.out.println("result: " + result);
            list.add(result);
            
        } else if(xslt.contains("07-package.xsl")) {
            String idmlTemplsDir = obj.DiridmlTempls;
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} outMapDir={5} idmlTemplsDir={6}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, outMapDir, idmlTemplsDir);
            list.add(result);
            
        } 
        
        else {
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
            list.add(result);
        }
        
    }
    
    public void formattingHtml() {
        String htmlDirS = outMapDir + File.separator + "3_HTML" + File.separator + lb1;
        
        if(xslt.contains("preview.xsl")) {
            in = outMapDir + File.separator + "final-" + lb1 + ".dita";
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
            list.add(result);
            
        } else if(xslt.contains("make-skeleton.xsl")) {
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} pvPath={5} ditaMa={6} langsF={7}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, pvPath, ditaMa, langsF);
            list.add(result);
            
        } else if(xslt.contains("heading-grouping.xsl")) {
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} htmlDirS={5}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, htmlDirS);
            list.add(result);
            
        } 
        
        else if(xslt.contains("groupingHeading1.xsl")) {
            in = outMapDir + File.separator + "ExcelDB" + File.separator + lb1 + File.separator + "recommend.xml";
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} outMapDir={5} lang={6}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, outMapDir, lb1);
            list.add(result);
            
            
        } else if(xslt.contains("messageF-escape.xsl")) {
            in = outMapDir + File.separator + "ExcelDB" + File.separator + lb1 + File.separator + "Message.xml";
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4} outMapDir={5} lang={6}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog, outMapDir, lb1);
            list.add(result);
            
        }  else {
            text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
            String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
            list.add(result);
            
        }
        
        
    }
    
    public List<String> getPath() {
        return list;
        
    }
    
    
    
    
}
