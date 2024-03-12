package main.java.zipController;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import main.java.zipController.Common.implementOBJ;

public class readMergedF {
    implementOBJ obj = new implementOBJ();
    
    public void runReadMergedF() {
        System.out.println("runReadMergedF() 시작");
        System.out.println("obj.srcDir: " + obj.srcDir);

        try {
            String path = obj.srcDir + File.separator + "temp" +  File.separator + "idmlMergedXML.xml";
            File file = new File(path);
            FileInputStream fis = new FileInputStream(file);
            
            Reader reader = new InputStreamReader(fis, "UTF-8");
            InputSource is = new InputSource(reader);
            is.setEncoding("UTF-8");
            
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

            // 4.1 xml을 파싱할때 namespace 지원여부 설정하기
            // xslt를 사용하기 위해서는 필수 옵션이다.
            dbf.setNamespaceAware(true);

            // 5. DocumentBuilderFactory 객체의 newDocumentBuilder() 메소드를 호출하여,
            // 파싱 기능을 통해 DOM 트리 객체에 접근
            DocumentBuilder db = dbf.newDocumentBuilder();

            // 6. Document 클래스의 parse() 메소드를 호출하여,
            // DOM트리 객체내 root 요소및 하위 데이터에 접근할수 있도록 파싱
            Document doc = db.parse(is);

            // 7. 문서내 최상위 root 요소에 접근 하기
            Element rootEle = doc.getDocumentElement();
            
            // 최상위 요소 이름 및 속성 추출
            System.out.println("최상위 요소 이름: " + rootEle.getNodeName());
            System.out.println("최상위 요소의 @region 속성값: " + rootEle.getAttribute("region"));
            
            String region = rootEle.getAttribute("region");
            obj.fileRegion = region;
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
    }
    
    
}
