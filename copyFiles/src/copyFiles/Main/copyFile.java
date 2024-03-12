package copyFiles.Main;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class copyFile {
	List<File> getFiles = new ArrayList<>();
	List<String> selectedCheckBox = new ArrayList<>(); 
	String attrLangCode = "";
	
	public copyFile(List<File> getFiles , List<String> selectedCheckBox) {
		this.getFiles = getFiles; 
		this.selectedCheckBox = selectedCheckBox;
		
	}
	
	public void runCopyF() throws Exception {
		System.out.println("runCopyF() 시작");
		Path path = Paths.get(getFiles.get(0).toString());
		DirectoryStream<Path> ds = Files.newDirectoryStream(path);
		
		
		ds.forEach(q -> {
			if(Files.isDirectory(q)) {
				try {
					recursDel(path);
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {

				System.out.println("path: " + q.toAbsolutePath());
				try {
					// xml 문서 읽기
					Document doc = readXMLF(q);
					
					// 문서의 최상위 요소 접근
					Element root = doc.getDocumentElement();
					attrLangCode = root.getAttribute("xml:lang");
					
					// 원본 root요소 하위의 노드를 수집
					// 이렇게 수집된 노드들은 복사될 xml 문서의 노드로 추가 될 것임
					NodeList nl = root.getChildNodes();
					
					selectedCheckBox.forEach(a -> {
						try {
							// 저장 경로/파일명 생성
							String outPathF = createNewF(q, a);
							Path outPath = Paths.get(outPathF);
							
							DocumentBuilderFactory dbf1 = DocumentBuilderFactory.newInstance();
							DocumentBuilder db1 = dbf1.newDocumentBuilder();
							Document newDoc = db1.newDocument();
							
							// 최상위 Root 요소 생성
							Element ele = newDoc.createElement("Root");
							// Root 요소의 속성 생성
							ele.setAttribute("xml:lang", a);
							
							for(int i=0; i<nl.getLength(); i++) {
								Node node = nl.item(i);
	
								// adoptNode(): 외부 문서로 부터 노드를 가져 온다.
					            // cloneNode(): 노드의 복제본을 반환 한다., 즉 외부 문서의 복제본을 반환 
								ele.appendChild(newDoc.adoptNode(node.cloneNode(true)));
							}            
							
							// Doc 객체에 생성한 요소 추가
							newDoc.appendChild(ele);
							
							// TransformerFactory 객체 생성
							TransformerFactory factory = TransformerFactory.newInstance();
							Transformer transformer = factory.newTransformer();
							
					        // 3. 출력 포멧 설정 - setOutputProperty() 메소드
					        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
					        transformer.setOutputProperty(OutputKeys.INDENT, "no");
					        transformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
							
							DOMSource source = new DOMSource(newDoc);
							StreamResult result = new StreamResult(outPath.toUri().toString());
							
							transformer.transform(source, result);
							result.getOutputStream().close();
							
							
							
						} catch(Exception e1) {
							throw new RuntimeException(e1.getMessage());
						}
					});
					
					System.out.println("파일 복사 완료!!");
					
				} catch(Exception e1) {
					e1.printStackTrace();
				}
			}
		});
		

	}
	
	public String createNewF(Path path, String a) {
		// 디렉토리 삭제
		
		
		File file = new File(path.toString());
		// 파일이름 생성
		String newName = file.getName().replace(attrLangCode, a);
		String outPathF = file.getParent() + File.separator + newName;
		return outPathF;
	}
	
	public Document readXMLF(Path path) throws Exception {
		System.out.println("readXMLF() 시작");
		
		FileInputStream fis = new FileInputStream(path.toFile());
		
		// InputStreamReader() 보조 메소드를 사용하여, Reader 객체로 변환
		// 이유는 Reader 문자 기반 입력 스트림을 사용항여, 문자셋을 UTF-8로 읽기 위해
		Reader reader = new InputStreamReader(fis, "UTF-8");
		
		// xml 문서를 UTF-8로 읽기 위해 org.xml.sax 패키지의 
		// InputSource 클래스 객체를 생성하여 문자셋 지정
		InputSource is = new InputSource(reader);
		is.setEncoding("UTF-8");
		
		// xml 문서를 DOM 객체 구조로 읽기 위해 DocumentBuilderFactory 객체 생성
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		
		Document doc = db.parse(is);
		
		return doc;
	}
	
	public void recursDel(Path toPath) {
	    try {
	        DirectoryStream<Path> ds = Files.newDirectoryStream(toPath);

	        ds.forEach(a -> {
	            if (Files.isDirectory(a)) {
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
