package copyFiles.Main;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class getLanguageCode {
	InputStream is = null;
	List<String> lgnsList = new ArrayList<>(); 
	
	
	public getLanguageCode(InputStream fis) {
		this.is = fis;
	}
	
	public List<String> getISOCode() {
		try {
			// 문자 변환 스트림인 InputStreamReader() 메소드를 호출하여, Reader 문자 입력스트림으로 변환
			Reader reader = new InputStreamReader(is, "UTF-8");
			
			InputSource is = new InputSource(reader);
			is.setEncoding("UTF-8");
			
			// xml 문서를 DOM 트리 구조로 빌트하는 parser를 얻어, DocumentBuilder 객체 생성
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance(); 
            
            // namespace 지원 여부 설정하기
            factory.setNamespaceAware(true);
            
            // DOM 트리 객체로 파싱하기
            DocumentBuilder documentBuilder = factory.newDocumentBuilder();
            
            // 파싱한 DOM 객체를 문서로 반환 받기
            Document doc = documentBuilder.parse(is);

            // 최상위 노드 접근
			Element root = doc.getDocumentElement();
			
			// XPath 객체 생성
			XPath xpath = XPathFactory.newInstance().newXPath();
			
			// XPath로 xml의 요소 접근
			String express = "root/language/@code";
			NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);
			
			for(int i=0; i<nl.getLength(); i++) {
				Node node = nl.item(i);
				
				lgnsList.add(node.getTextContent());
			}
			
			
//			lgnsList.stream().distinct().forEach(a -> {
//				System.out.println("qqq: " + a);
//			});

			
		} catch(Exception e1) {
			e1.printStackTrace();
		}
		
		// list 컬렉션 반환
		lgnsList = lgnsList.stream().distinct().filter(a -> !a.equals("en-GB")).collect(Collectors.toList());
//		List<String> list = lgnsList.stream().distinct().collect(Collectors.toList());
//		return lgnsList;
		return lgnsList;
	}
}
