package main.DITA.sourceController;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import main.DITA.Common.implementOBJ;
import net.sf.saxon.lib.NamespaceConstant;



public class transformXSLT {
    String msg = "";
    String tempP = "";
    String idmlDir = "";
    
    implementOBJ obj = new implementOBJ();
    
    
    public ArrayList<InOutPathClas> list = new ArrayList<>();
    
    
    
    public transformXSLT(String tempP) {
        this.tempP = tempP;
    }
    
    public void setList() {
        System.out.println("setList() 시작");
        Path path = Paths.get(tempP);
        
        list.add(new InOutPathClas(obj.ditaxsls + "/dummy.xml", tempP + "/temp/01-merged.xml", obj.ditaxsls + "/temp-html/01-merged.xsl"));
        list.add(new InOutPathClas(tempP + "/temp/01-merged.xml", tempP + "/temp/02-getMatchesLangs.xml", obj.ditaxsls + "/temp-html/02-getMatchesLangs.xsl"));
        list.add(new InOutPathClas(tempP + "/temp/02-getMatchesLangs.xml", tempP + "/temp/dummy.xml", obj.ditaxsls + "/temp-html/03-exportHtml.xsl"));
        

        executeXslt();
    }


    public void executeXslt() {
        System.out.println("executeXslt() 시작");
        
        list.stream().forEach(a -> {
            InOutPathClas iopc = a;
            File inFile = new File(iopc.getinFile());
            File outFile = new File(iopc.getoutFile());
            File xslFile = new File(iopc.getxslFile());
            Source inxml = new StreamSource(inFile);
            Result outxml = new StreamResult(outFile);
            Source xsltF = new StreamSource(xslFile);
            
            System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
                        
            TransformerFactory factory = TransformerFactory.newInstance();
            try {
                Transformer tf = factory.newTransformer(xsltF);
                
                if(xslFile.toString().contains("01-merged")) {
                    tf.setParameter("sMapDir", tempP);

                } 
                
                tf.transform(inxml, outxml);
                
            } catch(Exception tf) {
                msg = tf.getMessage();
                System.out.println("msg: " + msg);
                throw new RuntimeException(msg);
            }

        });
        
        System.out.println("변환 완료!!");
    }

}
