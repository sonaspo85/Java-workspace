package SONTEST.TEST03.fileControl;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import SONTEST.TEST03.subWorkClass.commonObj;
import net.sf.saxon.lib.NamespaceConstant;

public class docInfo {
    String mergedPath;
    Path verExract = null;
    Path styleApplier = null;
    commonObj coj = new commonObj();
    String result = "";
    List<String> srcList = new ArrayList<>();
    
    public docInfo(String mergedPath) {
        this.mergedPath = mergedPath;
        
    }
    
    public void runVarExtract() throws Exception {
        Path path = Paths.get(mergedPath);
        styleApplier = Paths.get(path.getParent() + File.separator + "dataTemplate" + File.separator + "StyleApplier.xml");
        File file = styleApplier.toFile();
        readDocInfo(file);

    }
    
    public void readDocInfo(File file) throws Exception {
        FileInputStream fis = new FileInputStream(file);
        Reader reader = new InputStreamReader(fis, "UTF-8");
        Document doc = coj.createDomObj(reader); 
        Element rootEle = doc.getDocumentElement();
        
        // root 요소의 자식요소에 접근
        NodeList childNode = rootEle.getChildNodes();
        
        if(file.getName().equals("StyleApplier.xml")) {
            getHtmlTemplate(rootEle, doc);
            getCssUpdate(rootEle, doc);
        }

    }
    
    public void getCssUpdate(Element rootEle, Document doc) throws Exception {
        System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
        XPathFactory factory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
        XPath xpath = factory.newXPath();
        String comp = "'"+ commonObj.company + "'";
        String version = "'" + commonObj.version + "'";
        String lang = "'"+ commonObj.lang + "'";
        String express = "";
        
        express = "root/div[matches(@class, " + version + ")]/div[matches(@class, 'cssUpdate')]/var[matches(@carType, '" + coj.carName + "')]/var";
        NodeList getCarTypeVar = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
        
        if(getCarTypeVar.getLength() > 1) {
            isCarTyperVar(xpath, getCarTypeVar);
            return;
            
        } else if(commonObj.lang.equals("Arabic") || commonObj.lang.equals("Hebrew")) {
            express = "root/div[matches(@class, " + version + ")]/div[matches(@class, 'cssUpdate')]/var[matches(@except, " + lang + ")]";
            
        } 
        else if(commonObj.lang.equals("TraditionalChinese")) {
            express = "root/div[matches(@class, " + version + ")]/div[matches(@class, 'cssUpdate')]/var[not(@except)] | root/div[matches(@class, " + version + ")]/div[matches(@class, 'cssUpdate')]/var[matches(@except, 'Chinese')]";
        }
        else {
            express = "root/div[matches(@class, " + version + ")]/div[matches(@class, 'cssUpdate')]/var[not(@except)] | root/div[matches(@class, " + version + ")]/div[matches(@class, 'cssUpdate')]/var[matches(@except, " + lang + ")]";
        } 
        
        NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
        Element engEle = null; 
        
        for(int j=0; j< nl.getLength(); j++) {
            Node node2 = nl.item(j);
            engEle = (Element) node2;
            
            if(engEle.getAttribute("company").equals("Common")) {
                srcList.add(engEle.getAttribute("srcDir"));
                
            } else if(engEle.getAttribute("company").equals(commonObj.company)) {
                srcList.add(engEle.getAttribute("srcDir"));
                
            } else if(engEle.getAttribute("company").equals(commonObj.company) && 
                      engEle.getAttribute("except").equals(commonObj.lang)) {
                srcList.add(engEle.getAttribute("srcDir"));
                
            } 
        }

    }
    
    public void isCarTyperVar(XPath xpath, NodeList getCarTypeVar) {
        Element engEle = null; 
        for(int j=0; j< getCarTypeVar.getLength(); j++) {
            Node node2 = getCarTypeVar.item(j);
            engEle = (Element) node2;
            
            if(engEle.getAttribute("company").equals("Common")) {
                srcList.add(engEle.getAttribute("srcDir"));
                
            } else if(engEle.getAttribute("company").equals(commonObj.company)) {
                srcList.add(engEle.getAttribute("srcDir"));
                
            }
            
        }
        
    }        
    
    public void getHtmlTemplate(Element rootEle, Document doc) throws Exception {
        System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
        
        XPathFactory factory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
        XPath xpath = factory.newXPath();
        String comp = "'"+ commonObj.company + "'";
        String version = "'" + commonObj.version + "'";
        System.out.println("version::"  + version);
        
        String express = "";
        express = "root/div[matches(@class, " + version + ")]/div[matches(@class, 'htmlTemplate')]/var[matches(@region, 'Common')][matches(@lang, 'English')][matches(@company, " + comp + ")]";
        
        NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
        
        Element engEle = null; 
        for(int j=0; j< nl.getLength(); j++) {
            Node node2 = nl.item(j);
            engEle = (Element) node2;
        }

        String region = "'"+ commonObj.region + "'";
        System.out.println("region: " + region);
        String inch = "'"+ commonObj.inch + "'";
        System.out.println("inch: " + inch);
        String express2 = "root/div[matches(@class, " + version + ")]/div[matches(@class, 'htmlTemplate')]/var[matches(@region, " + region + ")][matches(@inch, " + inch + ")]";
        NodeList nl2 = (NodeList) xpath.compile(express2).evaluate(doc, XPathConstants.NODESET);
        
        if(nl2.getLength() > 0) {
            System.out.println("존재함");
            
            for(int j=0; j< nl2.getLength(); j++) {
                Node node2 = nl2.item(j);
                Element ele2 = (Element) node2; 
                result = sameCompanyNLang(ele2, engEle);
                  
                if(result.length() > 1) { 
                    srcList.add(result); return; 
                }
                 
            } 
            
        } else {
            System.out.println("존재하지 않음");
            String express3 = "root/div[matches(@class, " + version + ")]/div[matches(@class, 'htmlTemplate')]/var[matches(@region, 'Common')][matches(@inch, " + inch + ")]";
            NodeList nl3 = (NodeList) xpath.compile(express3).evaluate(doc, XPathConstants.NODESET);
            System.out.println("nl3: " + nl3.getLength());
            for(int k=0; k< nl3.getLength(); k++) {
                Node node3 = nl3.item(k);
                Element ele3 = (Element) node3; 
                
                result = sameCompanyNLang(ele3, engEle);
                
                if(result.length() > 1) {
                    srcList.add(result);
                    return;
                }
            } 
                
        }
        
    }
    
    public String sameCompanyNLang(Element ele, Element engEle) {
        System.out.println("sameCompanyNLang 시작");
        String regExg = "(Arabic|Hebrew|English|Korean)"; 
        String srcDir = "";
        
        if(ele.getAttribute("company").equals(commonObj.company)) {
            System.out.println("일치 회사 존재");
            if(ele.getAttribute("lang").equals(commonObj.lang) && 
               ele.getAttribute("carType").equals(coj.carName)) {
                srcDir = ele.getAttribute("srcDir");
                
            } else if(ele.getAttribute("lang").equals(commonObj.lang) && 
                     !ele.hasAttribute("carType")) {
                srcDir = ele.getAttribute("srcDir");

            } else if(!Pattern.matches(regExg, commonObj.lang)) {
                if(commonObj.region.equals(ele.getAttribute("region"))) {
                    srcDir = ele.getAttribute("srcDir");
                    
                } else if(ele.getAttribute("carType").equals(coj.carName)) {
                    srcDir = ele.getAttribute("srcDir");
                    
                } else {
                    srcDir = engEle.getAttribute("srcDir");
                }

            } else if(Pattern.matches(regExg, commonObj.lang)) {
                if(!ele.getAttribute("lang").equals(commonObj.lang)) {
                } 
                
            }
            
        } 
        
        return srcDir;
    }
    
    public List<String> getsrcDir() {
        return this.srcList;
    }
    
}
