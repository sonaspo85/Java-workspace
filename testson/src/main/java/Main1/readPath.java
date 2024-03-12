package main.java.Main1;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class readPath {
	String inoutPath = "";
	public List<String> list = new ArrayList<>();
	String packageDirS = "";
	String srcDir = "";
	String catalogDir = "";
	String xsltDir = "";
	
	
	public readPath() {
		File packageDirF = new File(""); 
		packageDirS = packageDirF.getAbsolutePath();
		inoutPath = packageDirS + "/lib/inoutpath.xml";
		srcDir = "H:/DITA/Mobile/Bat/mobile-source/out/";
		catalogDir = "C:/Protean-MA/dita-ot/";
		xsltDir = "H:/DITA/Mobile/Bat/mobile-source/xsls/";
	}
	
	public void runReadPath() throws Exception {
		System.out.println("runReadPath() 시작");
		
		
//		File file = new File(inoutPath);
		try {
			FileInputStream fis = new FileInputStream(inoutPath);
			Reader reader = new InputStreamReader(fis, "UTF-8");
			InputSource is = new InputSource(reader);
			is.setEncoding("UTF-8");
			
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			dbf.setNamespaceAware(true);
			DocumentBuilder db = dbf.newDocumentBuilder();
	        Document doc = db.parse(is);
	        
			Element rootEle = doc.getDocumentElement();
			
			NodeList nl =  rootEle.getChildNodes();
			
			String transform = "java net.sf.saxon.Transform";
			String in = "";
			String out = "";
			String xslt = "";
			String catalog = "";
			
			
			String text = "";
			String textPane = "";
			
			for(int i=0; i<nl.getLength(); i++) {
				Node node = nl.item(i);
				
				if(node.getNodeType() == Node.ELEMENT_NODE) {
					Element ele = (Element) node;
					
					if(ele.getNodeName().equals("path")) {
						in = srcDir + ele.getAttribute("in").replaceAll(" ", "%20") + " ";
						out = srcDir + ele.getAttribute("out").replaceAll(" ", "%20") + " ";
						xslt = xsltDir + ele.getAttribute("xslt").replaceAll(" ", "%20") + " ";
						catalog = catalogDir + ele.getAttribute("catalog").replaceAll(" ", "%20") + " ";
						
						
						if(xslt.contains("insert-idx")) {
							text = "{0}  -s:{1} -o:{2} -xsl:{3} -catalog:{4}";
//							text = "java net.sf.saxon.Transform  -s:{0} -o:{1} -xsl:{2} -catalog:{3}";
							String result = MessageFormat.format(text, transform, in, out, xslt, catalog);
							System.out.println("result: " + result);
							
							list.add(result);
							
						} 
						
						else {
							text = "{0} -s:{1} -o:{2} -xsl:{3}";
							String result = MessageFormat.format(text, transform, in, out, xslt);
							list.add(result);
						}

					}

				}

			}
			
	        
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
	public List<String> getPath() {
		return list;
	}

}
