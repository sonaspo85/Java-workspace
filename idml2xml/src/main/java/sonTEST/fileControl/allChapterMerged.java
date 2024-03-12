package main.java.sonTEST.fileControl;

import java.io.File;
import java.io.Reader;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import main.java.commonObj.commonImpleObj;

public class allChapterMerged {
	commonImpleObj coj = new commonImpleObj();
	String outXMLPath = "";
	
	
	public allChapterMerged(String outXMLPath) {
		this.outXMLPath = outXMLPath;
	}
	
	// 각 챕터들을 수집하여  merged.xml 생성 하기
	public void runMerged() {
		System.out.println("runMerged 시작");
		try {
			String mergedDir = outXMLPath + File.separator + "merged.xml";
			System.out.println("mergedDir: " + mergedDir);
			Path outXMLDir = Paths.get(outXMLPath);
			
			// 각 챕터파일이 있는 디렉토리의 모든 파일들을 스트림으로 추출
			DirectoryStream<Path> ds = Files.newDirectoryStream(outXMLDir);
			
			// 빈 Doc 객체 생성하기
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document doc = db.newDocument();
			
			Element rootEle = doc.createElement("Root");
//			if(!rootEle.hasAttribute("class")) {
//				rootEle.setAttribute("class", "noKeys");
//				
//			}
			
			
			doc.appendChild(rootEle);
			
			ds.forEach(a -> {
				try {
					Charset charset = Charset.forName("UTF-8");
					Reader reader = Files.newBufferedReader(a, charset);
					InputSource is = new InputSource(reader);
					is.setEncoding("UTF-8");
					
					DocumentBuilderFactory dbf2 = DocumentBuilderFactory.newInstance();
					DocumentBuilder db2 = dbf2.newDocumentBuilder();
					Document doc2 = db2.parse(is);
					
					Element eleRoot = doc2.getDocumentElement();
					NodeList nl = eleRoot.getChildNodes();
					
					Stream.iterate(0, q -> q<nl.getLength(), q->q+1).forEach(q -> {
						Node node3 = nl.item(q);
						
						rootEle.appendChild(doc.adoptNode(node3.cloneNode(true)));
					});

				} catch (Exception e2) {
					e2.printStackTrace();
				}
				
			});
			coj.xmlTransform(mergedDir, doc);
			System.out.println("merged.xml 생성 완료");
			
		} catch(Exception e1) {
			e1.printStackTrace();
		}
		
		
	}
	
	
}
