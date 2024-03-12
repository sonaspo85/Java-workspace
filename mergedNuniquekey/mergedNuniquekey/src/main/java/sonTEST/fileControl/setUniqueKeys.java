package main.java.sonTEST.fileControl;

import java.io.File;
import java.io.FileReader;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.stream.Stream;

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

import de.mkammerer.snowflakeid.SnowflakeIdGenerator;
import de.mkammerer.snowflakeid.options.Options;
import de.mkammerer.snowflakeid.structure.Structure;
import de.mkammerer.snowflakeid.time.MonotonicTimeSource;
import de.mkammerer.snowflakeid.time.TimeSource;
import main.java.commonObj.commonImpleObj;
import net.sf.saxon.om.NamespaceConstant;

public class setUniqueKeys {
	commonImpleObj coj = new commonImpleObj();
	String mergedXMLFiles = coj.outXMLPath + File.separator + "merged.xml";
	String tarMergedXMLFiles = coj.outXMLPath + File.separator + "newMerged.xml";
	
	public void setGenerateUkeys() {
		try {
			// merged.xml 파일을 DOM 구조로 읽기
			FileReader reader = new FileReader(mergedXMLFiles, coj.charset);
			InputSource is = new InputSource(reader);
			is.setEncoding("UTF-8");
			
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document doc = db.parse(is);
			
			Element eleRoot = doc.getDocumentElement();
//			System.out.println("eleRoot: " + eleRoot.getNodeName());

			
			eleRoot.setAttribute("class", "yesKeys");
			// regex 2.0을 사용하기 위해  saxon클래스의 xpath 객체로 스위칭 
			System.setProperty("javax.xml.xpath.XPathFactory:"+NamespaceConstant.OBJECT_MODEL_SAXON, "net.sf.saxon.xpath.XPathFactoryImpl");
			XPathFactory xfactory = XPathFactory.newInstance(NamespaceConstant.OBJECT_MODEL_SAXON);
			XPath xpath = xfactory.newXPath();
			
			String express = "Root/descendant::*[name()='ParagraphStyleRange']";
			NodeList nl = (NodeList) xpath.compile(express).evaluate(doc, XPathConstants.NODESET);

			// 유니크키 생성하기
			SnowflakeIdGenerator sg = setUniqueKeys();
			
			Stream.iterate(0, i->i<nl.getLength(), i->i+1).forEach(i -> {
				Node node = nl.item(i);
				Element eleNode = (Element) node;

				// 유니크키 생성
				long uKeys = sg.next();
//				System.out.println(uKeys);
				if(!eleNode.hasAttribute("AST-Key")) {
					eleNode.setAttribute("AST-Key", String.valueOf(uKeys));
				}
				
			});
			
			coj.xmlTransform(tarMergedXMLFiles, doc);
				
			
			
		} catch(Exception e1) {
			e1.printStackTrace();
		}
		
	}
	
	public SnowflakeIdGenerator setUniqueKeys() {
		// 현재 날짜 생성하기
		LocalDateTime ld = LocalDateTime.now(); 
		
	    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault());
	    String dateStr = ld.format(dtf);
	    LocalDateTime date = LocalDateTime.parse(dateStr, dtf);
	    date = date.minusDays(2);

	    String dateZ = date + "Z";
//	    System.out.println(Instant.parse(dateZ));
	    
		// Use a custom epoch
		TimeSource timeSource = new MonotonicTimeSource(Instant.parse(dateZ));
		// 타임스탬프에 45비트, 생성기에 2비트, 시퀀스에 16비트 사용
		Structure structure = new Structure(45, 2, 16);
		// 시퀀스 번호가 오버플로되면 예외를 throw 한다.
		Options options = new Options(Options.SequenceOverflowStrategy.THROW_EXCEPTION);

		// generatorId는 모든 인스턴스에서 고유해야 한다
		long generatorId = 1;
		SnowflakeIdGenerator generator = SnowflakeIdGenerator.createCustom(generatorId, timeSource, structure, options);
		
		return generator;
	}
	
	
}
