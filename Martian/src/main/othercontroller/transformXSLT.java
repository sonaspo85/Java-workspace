package main.othercontroller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import main.Common.implementOBJ;
import net.sf.saxon.lib.NamespaceConstant;

public class transformXSLT {
    String msg = "";
    String iniDir = "";
    String idmlDir = "";
    
    implementOBJ obj = new implementOBJ();
    
    String packageDir = obj.projectDir;
    
    public ArrayList<InOutPathClas> list = new ArrayList<>();
    
    
    
    public transformXSLT() {
        
    }
    
    

    public void runConvertHTMLBat(String absSrcpath) throws Exception {
        System.out.println("runMobilebatch() 시작");
        
        String srcDir = absSrcpath;
        
        try {
            list.add(new InOutPathClas(srcDir, obj.tempDir + "/00-messageF-groupLang.xml", obj.xslsDir + "/01-messageF-groupLang.xsl"));
            list.add(new InOutPathClas(obj.xslsDir + "/dummy.xml", obj.tempDir + "/00-videolinkF-group.xml", obj.xslsDir + "/01-videolinkF-group.xsl"));
            list.add(new InOutPathClas(obj.xslsDir + "/dummy.xml", obj.tempDir + "/00-remoteurlF-group.xml", obj.xslsDir + "/01-remoteurlF-group.xsl"));
            list.add(new InOutPathClas(srcDir, obj.tempDir + "/01-simplify.xml", obj.xslsDir + "/01-simplify.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/01-simplify.xml", obj.tempDir + "/02-simplify.xml", obj.xslsDir + "/02-simplify.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/02-simplify.xml", obj.tempDir + "/03-define-BrType.xml", obj.xslsDir + "/03-define-BrType.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/03-define-BrType.xml", obj.tempDir + "/04-cleanAttrs.xml", obj.xslsDir + "/04-cleanAttrs.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/04-cleanAttrs.xml", obj.tempDir + "/05-grouping-br.xml", obj.xslsDir + "/05-grouping-br.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/05-grouping-br.xml", obj.tempDir + "/06-groupingTR.xml", obj.xslsDir + "/06-groupingTR.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/06-groupingTR.xml", obj.tempDir + "/07-split-BR.xml", obj.xslsDir + "/07-split-BR.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/07-split-BR.xml", obj.tempDir + "/08-grouping-indent.xml", obj.xslsDir + "/08-grouping-indent.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/08-grouping-indent.xml", obj.tempDir + "/09-nested-indent.xml", obj.xslsDir + "/09-nested-indent.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/09-nested-indent.xml", obj.tempDir + "/10-grouping-list.xml", obj.xslsDir + "/10-grouping-list.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/10-grouping-list.xml", obj.tempDir + "/11-grouping-note.xml", obj.xslsDir + "/11-grouping-note.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/11-grouping-note.xml", obj.tempDir + "/12-nested-tags.xml", obj.xslsDir + "/12-nested-tags.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/12-nested-tags.xml", obj.tempDir + "/13-simplify.xml", obj.xslsDir + "/13-simplify.xsl"));
            
            list.add(new InOutPathClas(obj.tempDir + "/13-simplify.xml", obj.tempDir + "/14-connect-link.xml", obj.xslsDir + "/14-connect-link.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/14-connect-link.xml", obj.tempDir + "/15-simplify.xml", obj.xslsDir + "/15-simplify.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/15-simplify.xml", obj.tempDir + "/16-grouping-heading.xml", obj.xslsDir + "/16-grouping-heading.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/16-grouping-heading.xml", obj.tempDir + "/17-1-insert-videolink.xml", obj.xslsDir + "/17-1-insert-videolink.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/17-1-insert-videolink.xml", obj.tempDir + "/17-2-data-preORnext.xml", obj.xslsDir + "/17-2-data-preORnext.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/17-2-data-preORnext.xml", obj.tempDir + "/17-3-connect-href.xml", obj.xslsDir + "/17-3-connect-href.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/17-3-connect-href.xml", obj.tempDir + "/17-4-strip-img.xml", obj.xslsDir + "/17-4-strip-img.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/17-4-strip-img.xml", obj.tempDir + "/18-simplify.xml", obj.xslsDir + "/18-simplify.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/18-simplify.xml", obj.tempDir + "/19-create-body-header.xml", obj.xslsDir + "/19-create-body-header.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/18-simplify.xml", obj.tempDir + "/dummy.xml", obj.xslsDir + "/20-split-html.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/18-simplify.xml", obj.tempDir + "/dummy.xml", obj.xslsDir + "/21-search-db.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/00-messageF-groupLang.xml", obj.tempDir + "/dummy.xml", obj.xslsDir + "/22-ui_text.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/18-simplify.xml", obj.tempDir + "/dummy.xml", obj.xslsDir + "/23-search-html.xsl"));
            list.add(new InOutPathClas(obj.tempDir + "/18-simplify.xml", obj.tempDir + "/dummy.xml", obj.xslsDir + "/24-start-here.xsl"));
            list.add(new InOutPathClas(obj.resourceDir + "/docInfo.xml", obj.resourceDir + "/docInfo2.xml", obj.xslsDir + "/25-set-docinfo.xsl"));
            
            
    
            
        } catch(Exception e1) {
            msg = "runSpec2xml xslt 변환 실패";
            throw new RuntimeException(msg);  
        }
        
        executeXslt("htmlconvert");
        
    }
    
    
    
    
    public void executeXslt(String flagStr) {
        System.out.println("executeXslt() 시작");
        
        
        list.stream().forEach(a -> {
            System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
            
            InOutPathClas iopc = a;
            
            File inFile = new File(iopc.getinFile());
            File outFile = new File(iopc.getoutFile());
            File xslFile = new File(iopc.getxslFile());
            

//          System.out.println("inFile: " + inFile);
//          System.out.println("outFile: " + outFile);
            System.out.println("xslFile: " + xslFile);
//          System.out.println("para0: " + paraStrPath);
            
            Source inxml = new StreamSource(inFile.toURI().toString());
            
            // 출력 스트림을 통해 생성될 파일 지정
            StreamResult result = new StreamResult(outFile.toURI().toString());

            // xslt 지정
            Source xsltF = new StreamSource(xslFile.toURI().toString());
            
            TransformerFactory factory = TransformerFactory.newInstance();
            try {
                Transformer tf = factory.newTransformer(xsltF);

                tf.transform(inxml, result);
                
            } catch(Exception tf) {
                System.out.println("xslt 변환 실패");
                msg = tf.getMessage();
                tf.printStackTrace();
//                throw new RuntimeException(msg);
            }
            
            
        });
        
        System.out.println("변환 완료!!");
    }

    
    
}
