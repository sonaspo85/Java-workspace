package main.java.kohyoungTech.Main;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.io.FileUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import net.sf.saxon.lib.NamespaceConstant;


public class copyIndex {
    implementOBJ obj = new implementOBJ();
    String indexF = "";
    String msg = "";
    String codesF = "";
    Map<String, String> opMap = new HashMap<>();
    
    public copyIndex() {
        indexF = obj.xslDir + File.separator + "multiSearch" + File.separator + "index.html";
        System.out.println("indexF: " + indexF);
        
    }
    
    public void runCopyIndex() throws Exception {
        System.out.println("runCopyIndex() 시작");

        File indexHtmlF = new File(indexF);
        
        getCodesOption getcodeOP = new getCodesOption();
        getcodeOP.getISOCode();
        
        
        // org.jsoup.nodes.Document 클래스로 import 하기
        Document doc = Jsoup.parse(indexHtmlF, "UTF-8");
        
        // @class="languages" 인 태그에 접근하기
        Elements languageTag = doc.select("select[id=languages]");

        obj.multiFolderLang.forEach(f -> {
        	
        	// 태그 추가
        	Element optionT = new Element("option");
        	
        	// 속성 추가
        	optionT.attr("value", f);
        	
        	// 태그의 값으로 택스트 추가
        	optionT.text(obj.opMap.get(f));
        	
        	// select id="languages" 태그의 자식으로 option을 넣기 위해 문자열로 변경하기
        	String childOption = optionT.toString();
        	System.out.println(optionT);
        	
        	// select id="languages" 태그의 자식으로 option 태그 추가 하기
        	languageTag.append(childOption);
        	
        	
        });
        

        // 새로운 html로 출력 하기
        String newIndex = obj.multiSearchSrcDir + File.separator + "index.html"; 
        final File outHTMLF = new File(newIndex);
        FileUtils.writeStringToFile(outHTMLF, doc.outerHtml(), StandardCharsets.UTF_8);
        
    }
    
    
    
    
    
}

