package main.java.zipController;

import java.io.File;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import main.java.zipController.Common.implementOBJ;
import net.sf.saxon.lib.NamespaceConstant;

public class transformXSLT {
    String msg = "";
    String iniDir = "";
    String idmlDir = "";
    
    implementOBJ obj = new implementOBJ();
    String packageDir = obj.packageDir;
    
    public ArrayList<InOutPathClas> list = new ArrayList<>();
    
    
    
    public transformXSLT(String newtarPath) {
        this.iniDir = newtarPath;
    }
    
    public void runIDML2xml() {
        System.out.println("runTransform() 시작");
        Path path = Paths.get(iniDir);
        System.out.println("packageDir:   " + packageDir);
        if(Files.exists(path)) {
            try {
                DirectoryStream<Path> ds =Files.newDirectoryStream(path);
                
                ds.forEach(a -> {
                    if (Files.isDirectory(a)) {
                        String folderName = a.getFileName().toString();
                        String fullPath = a.toAbsolutePath().toString();

                        list.add(new InOutPathClas(packageDir + "/jre/lib/xslt/dummy.xml", obj.srcDir + "/temp/dummy.xml", packageDir + "/jre/lib/xslt/idmlmergedxsls/01-designmap_name.xsl", fullPath));
                        list.add(new InOutPathClas(packageDir + "/jre/lib/xslt/dummy.xml", obj.srcDir + "/temp/dummy.xml", packageDir + "/jre/lib/xslt/idmlmergedxsls/02-story_merged.xsl", fullPath));
                        list.add(new InOutPathClas(packageDir + "/jre/lib/xslt/dummy.xml", obj.srcDir + "/temp/dummy.xml", packageDir + "/jre/lib/xslt/idmlmergedxsls/03-specExtract.xsl", obj.srcDir));
                        list.add(new InOutPathClas(packageDir + "/jre/lib/xslt/dummy.xml", obj.srcDir + "/temp/dummy.xml", packageDir + "/jre/lib/xslt/idmlmergedxsls/04-resource_merged.xsl", folderName));
                        list.add(new InOutPathClas(obj.srcDir + "/temp/04-resource_merged.xml", obj.srcDir + "/temp/05-table-structure.xml", packageDir + "/jre/lib/xslt/idmlmergedxsls/05-table-structure.xsl", obj.srcDir));
                        list.add(new InOutPathClas(obj.srcDir + "/temp/05-table-structure.xml", obj.srcDir + "/temp/idmlMergedXML.xml", packageDir + "/jre/lib/xslt/idmlmergedxsls/06-grouping-doc.xsl", obj.srcDir));                    
                    }
                });
                
                // Transform 객체로 xslt 실행
                executeXslt("idml2xml");
                
            } catch(Exception e1) {
                e1.printStackTrace();
                
            }
        }
    }
    
    

    
    public void runSpec2xml() {
        System.out.println("runSpec2xml() 시작");
        
        System.out.println("packageDir:" + packageDir);
        System.out.println("obj.srcDir:" + obj.srcDir);
        
        
        list.add(new InOutPathClas(packageDir + "/jre/lib/xslt/dummy.xml", obj.srcDir + "/temp/01-spec2xmlMerged.xml", packageDir + "/jre/lib/xslt/spec2xsls/01-spec2xmlMerged.xsl", obj.srcDir + "/temp/spec2xmlData"));
        list.add(new InOutPathClas(obj.srcDir + "/temp/01-spec2xmlMerged.xml", obj.srcDir + "/temp/02-groupingLangs.xml", packageDir + "/jre/lib/xslt/spec2xsls/02-groupingLangs.xsl", obj.srcDir + "/temp/spec2xmlData"));
        list.add(new InOutPathClas(obj.srcDir + "/temp/02-groupingLangs.xml", obj.srcDir + "/temp/03-bandmode.xml", packageDir + "/jre/lib/xslt/spec2xsls/03-bandmode.xsl", obj.srcDir + "/temp/spec2xmlData"));
        list.add(new InOutPathClas(obj.srcDir + "/temp/03-bandmode.xml", obj.srcDir + "/temp/04-etc.xml", packageDir + "/jre/lib/xslt/spec2xsls/04-etc.xsl", obj.srcDir + "/temp/spec2xmlData"));
        list.add(new InOutPathClas(obj.srcDir + "/temp/04-etc.xml", obj.srcDir + "/temp/05-all-other-sheet.xml", packageDir + "/jre/lib/xslt/spec2xsls/05-all-other-sheet.xsl", obj.srcDir + "/temp/spec2xmlData"));
        list.add(new InOutPathClas(obj.srcDir + "/temp/05-all-other-sheet.xml", obj.srcDir + "/temp/06-packages.xml", packageDir + "/jre/lib/xslt/spec2xsls/06-packages.xsl", obj.srcDir + "/temp/spec2xmlData"));
        list.add(new InOutPathClas(obj.srcDir + "/temp/06-packages.xml", obj.srcDir + "/temp/07-sars.xml", packageDir + "/jre/lib/xslt/spec2xsls/07-sars.xsl", obj.srcDir + "/temp/spec2xmlData"));
        list.add(new InOutPathClas(obj.srcDir + "/temp/07-sars.xml", obj.srcDir + "/temp/tmp-languages.xml", packageDir + "/jre/lib/xslt/spec2xsls/08-distance.xsl", obj.srcDir + "/temp/spec2xmlData"));
        
        try {
//            obj.languagesF = obj.srcDir + "/temp/languages.xml";
            obj.languagesF = obj.srcDir + "/temp/tmp-languages.xml";
            
            executeXslt("Spec2xml");
            
        } catch(Exception e1) {
            System.out.println("runSpec2xml xslt 변환 실패");
            e1.printStackTrace();
        }
        
    }
    
    public void runSpecsample() {
        System.out.println("runSpecsample() 시작");
        
        list.add(new InOutPathClas(packageDir + "/jre/lib/xslt/dummy.xml", obj.srcDir + "/temp/dummy.xml", packageDir + "/jre/lib/xslt/specSample/01-specSampleMerged.xsl", iniDir));
        list.add(new InOutPathClas(obj.srcDir + "/temp/01-specSampleMerged.xml", obj.srcDir + "/temp/Validation.xml", packageDir + "/jre/lib/xslt/specSample/02-validation.xsl", iniDir));
  
        try {
            obj.validationF = obj.srcDir + "/temp/Validation.xml";
            
            executeXslt("Specsample");
            
        } catch(Exception e1) {
            System.out.println("runSpec2xml xslt 변환 실패");
            e1.printStackTrace();
        }
         
    }

    public void runMobilebatch() throws Exception {
        System.out.println("runMobilebatch() 시작");
        
        try {
            list.add(new InOutPathClas(iniDir + "/temp/idmlMergedXML.xml", iniDir + "/temp/compare/01-filterDoc.xml", packageDir + "/jre/lib/xslt/compare/common/filterDoc.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/02-model-name.xml", packageDir + "/jre/lib/xslt/compare/common/model-name.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/03-packages-compare.xml", packageDir + "/jre/lib/xslt/compare/common/packages-compare.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/04-green-compare.xml", packageDir + "/jre/lib/xslt/compare/common/green-compare.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/05-fingerprint.xml", packageDir + "/jre/lib/xslt/compare/mobileNtable-compare-xsls/05-fingerprint.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/06-sar.xml", packageDir + "/jre/lib/xslt/compare/common/sar.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/07-distance.xml", packageDir + "/jre/lib/xslt/compare/mobileNtable-compare-xsls/07-distance.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/08-limbsar.xml", packageDir + "/jre/lib/xslt/compare/mobileNtable-compare-xsls/08-limbsar.xsl", iniDir));
            
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/09-bandmode.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/09-bandmode.xml", iniDir + "/temp/compare/09-bandmode2.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode2.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/09-bandmode3.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode3.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/09-bandmode2.xml", iniDir + "/temp/compare/09-bandmode4.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode4.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/09-bandmode4.xml", iniDir + "/temp/compare/10-bandmode-bool.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode-bool.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/10-bandmode-bool.xml", iniDir + "/temp/compare/10-bandmode-bool2.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode-bool2.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/11-edoc.xml", packageDir + "/jre/lib/xslt/compare/common/edoc.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/11-edoc2.xml", packageDir + "/jre/lib/xslt/compare/common/edoc2.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/12-Looseleaf.xml", packageDir + "/jre/lib/xslt/compare/common/Looseleaf.xsl", iniDir));
            
            // AST 에서는 주석 풀기, 타사에서는 주석 하기(타사는 검증 안함)
//            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/13-productspec.xml", packageDir + "/jre/lib/xslt/compare/common/productspec.xsl", iniDir));
            
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/14-turgaranty.xml", packageDir + "/jre/lib/xslt/compare/common/turgaranty.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/15-registration.xml", packageDir + "/jre/lib/xslt/compare/mobileNtable-compare-xsls/15-registration.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/16-modelname-coverid.xml", packageDir + "/jre/lib/xslt/compare/common/modelname-coverid.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/17-indiabis.xml", packageDir + "/jre/lib/xslt/compare/common/indiabis.xsl", iniDir));
            
            // 신규 기능 시작!!
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/18-usbcablesupport.xml", packageDir + "/jre/lib/xslt/compare/common/usbcablesupport.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/19-powerclass.xml", packageDir + "/jre/lib/xslt/compare/common/powerclass.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/20-pobox.xml", packageDir + "/jre/lib/xslt/compare/common/pobox.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/21-maxichargesupport.xml", packageDir + "/jre/lib/xslt/compare/common/maxichargesupport.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/22-safetyinfo.xml", packageDir + "/jre/lib/xslt/compare/common/safetyinfo.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/23-wifi-frequency.xml", packageDir + "/jre/lib/xslt/compare/common/wifi-frequency.xsl", iniDir));
            // 신규 기능 끝!!
            
            list.add(new InOutPathClas(packageDir + "/jre/lib/xslt/dummy.xml", iniDir + "/temp/final-merged01.xml", packageDir + "/jre/lib/xslt/compare/common/final-merged01.xsl", iniDir));
            list.add(new InOutPathClas(iniDir + "/temp/final-merged01.xml", iniDir + "/temp/resultDoc.xml", packageDir + "/jre/lib/xslt/compare/common/final-merged02.xsl", iniDir));
              
            executeXslt("Mobilebatch");
            
        } catch(Exception e1) {
            msg = "runSpec2xml xslt 변환 실패";
            throw new RuntimeException(msg);  
        }
        
        obj.resultDoc = iniDir + "/temp/resultDoc.xml";
        
    }
    
    public void runAccbatch() throws Exception {
        System.out.println("runSpecsample() 시작");
        
        list.add(new InOutPathClas(iniDir + "/temp/idmlMergedXML.xml", iniDir + "/temp/compare/01-filterDoc.xml", packageDir + "/jre/lib/xslt/compare/common/filterDoc.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/02-model-name.xml", packageDir + "/jre/lib/xslt/compare/common/model-name.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/03-packages-compare.xml", packageDir + "/jre/lib/xslt/compare/common/packages-compare.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/04-green-compare.xml", packageDir + "/jre/lib/xslt/compare/common/green-compare.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/05-sar.xml", packageDir + "/jre/lib/xslt/compare/common/sar.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/06-buds-sars1.xml", packageDir + "/jre/lib/xslt/compare/watchNHearable-xsls/07-buds-sars1.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/07-buds-sars2.xml", packageDir + "/jre/lib/xslt/compare/watchNHearable-xsls/08-buds-sars2.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/08-face-of-sar.xml", packageDir + "/jre/lib/xslt/compare/watchNHearable-xsls/09-face-of-sar.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/09-w-distance.xml", packageDir + "/jre/lib/xslt/compare/watchNHearable-xsls/10-w-distance.xsl", iniDir));
        
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/10-bandmode.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/10-bandmode.xml", iniDir + "/temp/compare/10-bandmode2.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode2.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/10-bandmode3.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode3.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/10-bandmode2.xml", iniDir + "/temp/compare/10-bandmode4.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode4.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/10-bandmode4.xml", iniDir + "/temp/compare/11-bandmode-bool.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode-bool.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/11-bandmode-bool.xml", iniDir + "/temp/compare/11-bandmode-bool2.xml", packageDir + "/jre/lib/xslt/compare/common/bandmode-bool2.xsl", iniDir));
        
        // AST 에서는 주석 풀기, 타사에서는 주석 하기(타사는 검증 안함)
//        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/12-productspec.xml", packageDir + "/jre/lib/xslt/compare/common/productspec.xsl", iniDir));
        
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/13-edoc.xml", packageDir + "/jre/lib/xslt/compare/common/edoc.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/14-turgaranty.xml", packageDir + "/jre/lib/xslt/compare/common/turgaranty.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/15-indiabis.xml", packageDir + "/jre/lib/xslt/compare/common/indiabis.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/16-modelname-coverid.xml", packageDir + "/jre/lib/xslt/compare/common/modelname-coverid.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/17-Looseleaf.xml", packageDir + "/jre/lib/xslt/compare/common/Looseleaf.xsl", iniDir));
        
        // 신규 기능 시작!!
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/18-usbcablesupport.xml", packageDir + "/jre/lib/xslt/compare/common/usbcablesupport.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/19-powerclass.xml", packageDir + "/jre/lib/xslt/compare/common/powerclass.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/20-pobox.xml", packageDir + "/jre/lib/xslt/compare/common/pobox.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/21-maxichargesupport.xml", packageDir + "/jre/lib/xslt/compare/common/maxichargesupport.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/22-safetyinfo.xml", packageDir + "/jre/lib/xslt/compare/common/safetyinfo.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/compare/01-filterDoc.xml", iniDir + "/temp/compare/23-wifi-frequency.xml", packageDir + "/jre/lib/xslt/compare/common/wifi-frequency.xsl", iniDir));
        // 신규 기능 끝!!
        
        list.add(new InOutPathClas(packageDir + "/jre/lib/xslt/dummy.xml", iniDir + "/temp/final-merged01.xml", packageDir + "/jre/lib/xslt/compare/common/final-merged01.xsl", iniDir));
        list.add(new InOutPathClas(iniDir + "/temp/final-merged01.xml", iniDir + "/temp/resultDoc.xml", packageDir + "/jre/lib/xslt/compare/common/final-merged02.xsl", iniDir));
        
        try {
            executeXslt("Accbatch");
            
        } catch(Exception e1) {
            msg = "runSpec2xml xslt 변환 실패";
            e1.printStackTrace();
            throw new RuntimeException(msg);  
        }
        
        obj.resultDoc = iniDir + "/temp/resultDoc.xml";
    }

    public void runInsertDecimal() {
        System.out.println("runInsertDecimal() 시작");
        
        list.add(new InOutPathClas(obj.languagesF, obj.srcDir + "/temp/languages.xml", packageDir + "/jre/lib/xslt/spec2xsls/09-languages.xsl", obj.validationF));
                
        try {
            obj.languagesF = obj.srcDir + "/temp/languages.xml";
            
            executeXslt("InsertDecimal");
            
        } catch(Exception e1) {
            System.out.println("runSpec2xml xslt 변환 실패");
            e1.printStackTrace();
        }
        
    }
    
    public void executeXslt(String flagStr) {
        System.out.println("executeXslt() 시작");
        list.stream().forEach(a -> {
            System.setProperty("javax.xml.xpath.XPathFactory:" + NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
            
            InOutPathClas iopc = a;
            
            File inFile = new File(iopc.getinFile());
            File outFile = new File(iopc.getoutFile());
            File xslFile = new File(iopc.getxslFile());
            File paraPath = new File(iopc.getpara());
            String paraStrPath = paraPath.toString();
//            System.out.println("para000: " + paraStrPath);
 
//          System.out.println("inFile: " + inFile);
//          System.out.println("outFile: " + outFile);
          System.out.println("xslFile: " + xslFile);
//          System.out.println("para0: " + paraStrPath);
            
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
                
                if(flagStr.equals("idml2xml")) {
                    System.out.println("idml2xml 시작");
                    
                    if(xslFile.toString().contains("resource_merged")) {
                        tf.setParameter("srcDirs", obj.srcDir);
                        tf.setParameter("folderName", obj.srcFileName);
                        
                    } else {
                        tf.setParameter("midName", paraStrPath);
                    }
                    
                } else if(flagStr.equals("Spec2xml")) {
                    System.out.println("Spec2xml 시작");
                    
                    if(xslFile.toString().contains("spec2xmlMerged")) {
                        System.out.println("paraStrPath: " + paraStrPath);
                        System.out.println("region: " + obj.fileRegion);
                        tf.setParameter("srcDirs", paraStrPath);
                        tf.setParameter("region", obj.fileRegion);
                    }
                    
                } else if(flagStr.equals("Specsample")) {
                    System.out.println("Specsample 시작");
                    System.out.println("paraStrPath: " + paraStrPath);
                    System.out.println("region: " + obj.fileRegion);
                    tf.setParameter("specSampleDirs", paraStrPath);
                    tf.setParameter("region", obj.fileRegion);
                    
                } else if(flagStr.equals("Accbatch")) {
                    System.out.println("Accbatch 시작");
                    
                    if(xslFile.toString().contains("final-merged01")) {
                        tf.setParameter("srcDirs", obj.srcDir);
                        
                    } else if(xslFile.toString().contains("bandmode4")) {
                        tf.setParameter("srcDirs", obj.srcDir);

                    }
                    
                    tf.setParameter("specXMLF", paraStrPath + "/temp/Validation.xml");
                    tf.setParameter("langXMLF", paraStrPath + "/temp/languages.xml");
                    
                } else if(flagStr.equals("Mobilebatch")) {
                    System.out.println("Mobilebatch 시작");
                    
                    if(xslFile.toString().contains("final-merged01")) {
                        tf.setParameter("srcDirs", obj.srcDir);
//                        System.out.println("qqq: " + obj.srcDir);
                        
                    } else if(xslFile.toString().contains("bandmode4")) {
                        tf.setParameter("srcDirs", obj.srcDir);

                    }
                    
                    
                    tf.setParameter("specXMLF", paraStrPath + "/temp/Validation.xml");
                    tf.setParameter("langXMLF", paraStrPath + "/temp/languages.xml");
                    
                } else if(flagStr.equals("InsertDecimal")) {
                    System.out.println("InsertDecimal 시작");
                    
                    if(xslFile.toString().contains("-languages")) {
                        tf.setParameter("specXMLF", paraStrPath);
                    }
                    
                }
                
                tf.transform(inxml, outxml);
                
            } catch(Exception tf) {
                System.out.println("xslt 변환 실패");
                msg = tf.getMessage();
                throw new RuntimeException(msg);
            }

        });
        
        System.out.println("변환 완료!!");
    }

    
    
}
