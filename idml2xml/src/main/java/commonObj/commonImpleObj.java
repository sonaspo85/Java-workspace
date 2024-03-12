package main.java.commonObj;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;

public class commonImpleObj implements commonInterface {
	public static String srcPath = "";
	public static List<Path> zipDir = null;
	public static String outXMLPath = "";
//	public static String outXMLPath = "C:/Users/sonas/Desktop/Image/ddd/xml";
	public Charset charset = Charset.forName("UTF-8");
	
	@Override
	public void xmlTransform(String mergedDir, Document doc) {
		try {
			// 1. Transformer 객체 생성
			TransformerFactory tff = TransformerFactory.newInstance();
			// 2. Transformer 객체 생성
			Transformer trans = tff.newTransformer();
			trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			trans.setOutputProperty(OutputKeys.INDENT, "no");
			trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
			
			// 3. DOMSource 객체 생성
			DOMSource source = new DOMSource(doc);
			
			File outFile = new File(mergedDir);
			Result result = new StreamResult(outFile);
			
			// 4. transform() 메소드 호출
			trans.transform(source, result);
			((StreamResult) result).getOutputStream().close();
			
		} catch(Exception e1) {
			e1.printStackTrace();
		}
	}
	
	// 재귀적 폴더/파일 삭제
	@Override
	public void recursDel(Path toPath) {
		try {
			DirectoryStream<Path> ds = Files.newDirectoryStream(toPath);
			
			ds.forEach(a -> {
				if(Files.isDirectory(a)) {
					recursDel(a);
					
				} else {
					try {
						Files.delete(a);
						
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
				
			});
			
			Files.delete(toPath);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
}
