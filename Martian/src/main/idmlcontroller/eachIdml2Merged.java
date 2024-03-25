package main.idmlcontroller;

import java.io.File;
import java.io.Reader;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import main.Common.implementOBJ;



public class eachIdml2Merged {
	implementOBJ obj = new implementOBJ();
    String msg = "";
	
	public eachIdml2Merged() {
		
	}
	
	public void runEachIdmlMerged() {
		try {
			String finalMergedS = obj.tempDir + File.separator + "finalmerged.xml";
			Path finalMergedP = Paths.get(finalMergedS);
			Document doc = obj.createDOM();
			Element rootEle = doc.createElement("root");
			doc.appendChild(rootEle);
			Path eachSrcP = Paths.get(obj.tempDir + File.separator + "eachSrc"); 
			DirectoryStream<Path> ds = Files.newDirectoryStream(eachSrcP);
			
			ds.forEach(a -> {
				try {
					Reader reader = Files.newBufferedReader(a, obj.charset);
					InputSource is = new InputSource(reader);
					is.setEncoding("UTF-8");
					DocumentBuilderFactory dbf2 = DocumentBuilderFactory.newInstance();
					DocumentBuilder db2 = dbf2.newDocumentBuilder();
					Document doc2 = db2.parse(is);
					
					// 각 파일의 루트 노드 얻기
					Element idmlRoot = doc2.getDocumentElement();
					// 각 파일로 부터 가져온 루트노드 이름을 변경하기
					doc2.renameNode(idmlRoot, null, "docs");
					Node importnode = doc.importNode(idmlRoot, true);
					rootEle.appendChild(importnode);
					
				} catch (Exception e) {
					msg = "zipDir/xml 폴더내 파일 읽기 실패";
		            throw new RuntimeException(msg);
				}
				
			});
			
			obj.xmlTransform(finalMergedS, doc);
			
		} catch(Exception e) {
			msg = "eachIdml2Merged -> runEachIdmlMerged() 에러";
            throw new RuntimeException(msg);

		}

	}
	
	
}
