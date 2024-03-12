package main.java.satisfy.modules;

import java.io.File;
import java.util.ArrayList;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import main.java.satisfy.Common.implementOBJ;
import net.sf.saxon.lib.NamespaceConstant;

public class transformXSLT {
    implementOBJ obj = new implementOBJ();
    
    String msg = "";
    String xmlF = "";
    String fileName= "";
    public ArrayList<InOutPathClas> list = new ArrayList<>();
    
    public transformXSLT(String xmlF) {
        this.xmlF = xmlF;
        System.out.println("xmlF: " + xmlF);
        
        fileName = new File(xmlF).getName().toString();
        
    }
 
    public void setList() {
        System.out.println("setList() 시작");
        
        list.add(new InOutPathClas(obj.teplsDir + "/db.xml", obj.tempDir + "/01-merged.xml", obj.projectDir + "/jre/resources/xsls/01-merged.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/01-merged.xml", obj.tempDir + "/02-changeTagName.xml", obj.projectDir + "/jre/resources/xsls/02-changeTagName.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/02-changeTagName.xml", obj.tempDir + "/03-cleanTag.xml", obj.projectDir + "/jre/resources/xsls/03-cleanTag.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/03-cleanTag.xml", obj.tempDir + "/04-grouping.xml", obj.projectDir + "/jre/resources/xsls/04-grouping.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/04-grouping.xml", obj.tempDir + "/05-fillAttr.xml", obj.projectDir + "/jre/resources/xsls/05-fillAttr.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/05-fillAttr.xml", obj.tempDir + "/06-grouping.xml", obj.projectDir + "/jre/resources/xsls/06-grouping.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/06-grouping.xml", obj.tempDir + "/07-score-count.xml", obj.projectDir + "/jre/resources/xsls/07-score-count.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/07-score-count.xml", obj.tempDir + "/db/" + fileName, obj.projectDir + "/jre/resources/xsls/08-final-database.xsl"));
        
        obj.finalDBF.add(obj.tempDir + "/db/" + fileName);
        
        // xslt 실행
        executeXslt();
    }
    
    public void setList2() {
        System.out.println("setList2() 시작");
        
        list.add(new InOutPathClas(obj.projectDir + "/jre/resources/xsls/dummy.xml", obj.tempDir + "/08-DBmerged.xml", obj.projectDir + "/jre/resources/xsls/compare/08-DBmerged.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/08-DBmerged.xml", obj.tempDir + "/09-score-count.xml", obj.projectDir + "/jre/resources/xsls/compare/09-score-count.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/09-score-count.xml", obj.tempDir + "/10-satis-count.xml", obj.projectDir + "/jre/resources/xsls/compare/10-satis-count.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/10-satis-count.xml", obj.tempDir + "/12-grouping.xml", obj.projectDir + "/jre/resources/xsls/compare/12-grouping.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/12-grouping.xml", obj.tempDir + "/13-cleanTag.xml", obj.projectDir + "/jre/resources/xsls/compare/13-cleanTag.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/13-cleanTag.xml", obj.tempDir + "/14-grouping.xml", obj.projectDir + "/jre/resources/xsls/compare/14-grouping.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/14-grouping.xml", obj.tempDir + "/15-calculate.xml", obj.projectDir + "/jre/resources/xsls/compare/15-calculate.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/15-calculate.xml", obj.tempDir + "/16-percent.xml", obj.projectDir + "/jre/resources/xsls/compare/16-percent.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/16-percent.xml", obj.tempDir + "/17-totalsum.xml", obj.projectDir + "/jre/resources/xsls/compare/17-totalsum.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/08-DBmerged.xml", obj.tempDir + "/18-meged-tarF.xml", obj.projectDir + "/jre/resources/xsls/compare/18-meged-tarF.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/18-meged-tarF.xml", obj.tempDir + "/19-same-keys.xml", obj.projectDir + "/jre/resources/xsls/compare/19-same-keys.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/19-same-keys.xml", obj.tempDir + "/dummy.xml", obj.projectDir + "/jre/resources/xsls/compare/20-split-doc.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/17-totalsum.xml", obj.tempDir + "/21-safety-define.xml", obj.projectDir + "/jre/resources/xsls/compare/21-safety-define.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/21-safety-define.xml", obj.tempDir + "/22-safety-grouping.xml", obj.projectDir + "/jre/resources/xsls/compare/22-safety-grouping.xsl"));
        
        // xslt 실행
        executeXslt();
    }
    
    public void setList3() {
        System.out.println("setList3() 시작");
        
        list.add(new InOutPathClas(obj.tempDir + "/17-totalsum.xml", obj.tempDir + "/23-convert-html01.xml", obj.projectDir + "/jre/resources/xsls/compare/23-convert-html01.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/23-convert-html01.xml", obj.tempDir + "/24-convert-html02.xml", obj.projectDir + "/jre/resources/xsls/compare/24-convert-html02.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/24-convert-html02.xml", obj.tempDir + "/finally.html", obj.projectDir + "/jre/resources/xsls/compare/25-convert-html03.xsl"));

        // xslt 실행
        executeXslt();
    }
    
    public void setList4() {
        System.out.println("setList4() 시작");
        
        list.add(new InOutPathClas(obj.projectDir + "/jre/resources/xsls/dummy.xml", obj.tempDir + "/01-sati-merged.xml", obj.projectDir + "/jre/resources/xsls/satisfy/01-sati-merged.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/01-sati-merged.xml", obj.tempDir + "/02-sati-chTagName.xml", obj.projectDir + "/jre/resources/xsls/satisfy/02-sati-chTagName.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/02-sati-chTagName.xml", obj.tempDir + "/03-sati-grouping-filename.xml", obj.projectDir + "/jre/resources/xsls/satisfy/03-sati-grouping-filename.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/03-sati-grouping-filename.xml", obj.tempDir + "/04-sati-cleanTag.xml", obj.projectDir + "/jre/resources/xsls/satisfy/04-sati-cleanTag.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/04-sati-cleanTag.xml", obj.tempDir + "/05-sati-grouping-itemValue.xml", obj.projectDir + "/jre/resources/xsls/satisfy/05-sati-grouping-itemValue.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/05-sati-grouping-itemValue.xml", obj.tempDir + "/06-sati-calculate.xml", obj.projectDir + "/jre/resources/xsls/satisfy/06-sati-calculate.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/06-sati-calculate.xml", obj.tempDir + "/07-sati-total-avg.xml", obj.projectDir + "/jre/resources/xsls/satisfy/07-sati-total-avg.xsl"));
        list.add(new InOutPathClas(obj.tempDir + "/07-sati-total-avg.xml", obj.tempDir + "/final-satisfy.xml", obj.projectDir + "/jre/resources/xsls/satisfy/08-sati-delete-duplicate.xsl"));
        

        // xslt 실행
        executeXslt();
    }
    
    
    public void executeXslt() {
        System.out.println("executeXslt() 시작");

        list.stream().forEach(a -> {
            InOutPathClas iopc = a;

            File inFile = new File(iopc.getinFile());
            File outFile = new File(iopc.getoutFile());
            File xslFile = new File(iopc.getxslFile());


            System.out.println("inFile: " + inFile);
            System.out.println("outFile: " + outFile);
            System.out.println("xslFile: " + xslFile);
            

            // 1. xml 문서를 구현하는 StreamSource 객체를 Source 구현 객체로 할당
            // StreamSource: xml 문서를 입력 스트림으로 사용하기 위한 객체
            Source inxml = new StreamSource(inFile);

            // 출력 스트림을 통해 생성될 파일 지정
            // transform한 결과 문서를 저장하는데 필요한 정보를 포함하고 있다.
            // StreamResult: xml, txt, html 로 변환되는 결과물을 저장할 객체로 사용
            Result outxml = new StreamResult(outFile);

            // xslt 지정
            Source xsltF = new StreamSource(xslFile);

            

            TransformerFactory factory = TransformerFactory.newInstance();
            try {
                Transformer tf = factory.newTransformer(xsltF);

                if (xslFile.toString().contains("01-merged")) {
                    tf.setParameter("excelF", xmlF);
                    tf.setParameter("scoreF", obj.teplsDir + "/scoreSection.xml");

                } else if(xslFile.toString().contains("08-DBmerged")) {
                    tf.setParameter("tempDir", obj.tempDir);
                    tf.setParameter("scoreF", obj.teplsDir + "/scoreSection.xml");
                    tf.setParameter("satisF", obj.tempDir + "/final-satisfy.xml");
                    
                } else if(xslFile.toString().contains("18-meged-tarF")) {
                    tf.setParameter("tarF", obj.tempDir + "/17-totalsum.xml");

                } else if(xslFile.toString().contains("20-split-doc")) {
                    tf.setParameter("tempDir", obj.tempDir);

                } else if(xslFile.toString().contains("01-sati-merged")) {
                    tf.setParameter("excelDirs", obj.tempDir + "/excel/satisfy");
                    tf.setParameter("scoreF", obj.teplsDir + "/scoreSection.xml");

                }

                tf.transform(inxml, outxml);

            } catch (Exception tf) {
                System.out.println("xslt 변환 실패");
                throw new RuntimeException();
            }

        });

        System.out.println("변환 완료!!");
    }
    
}
