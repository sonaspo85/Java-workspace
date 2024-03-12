package DITA.idmlcontroller;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import DITA.Common.implementOBJ;

public class createEachIdmlFiles {
	implementOBJ obj = new implementOBJ();
    String msg = "";
    Map<String, Element> eachIdmlCollect = null;
    
    
    
	public createEachIdmlFiles(Map<String, Element> eachIdmlCollect) {
		this.eachIdmlCollect = eachIdmlCollect;
	
	}
	
	public void runEachIdmlFiles() {
		System.out.println("runEachIdmlFiles() 시작");
		
		try {
			// 각 idml.xml 파일이 저장될 폴더 생성
			createXMLDirs();
			
			// idml 별로 모든 doc 노드를 파일로 출력 - Transformer 클래스
			eachIdmlCollect.forEach((k,v) -> {
				try {
					String keys = k;
					Element vals = v;
					
					
					
					// 새로운 Document 객체 생성하기
					Document doc = obj.createDOM();
					
					// root 노드 생성
//					Element rootEle = doc.createElement("root");
//					doc.appendChild(rootEle);
					
					// 키 객체인 idml 이름으로 풀 경로 생성
					String idmlS = obj.tempDir + File.separator + "eachSrc" + File.separator + k + ".xml";
//					System.out.println("idmlS: " + idmlS);
					
					// iomportNode() 메소드 - root 노드의 자식으로 eachIdmlCollect의 값 객체인 Element를 복사
					// true : 자식 노드 포함
					Node importnode = doc.importNode(vals, true);
					doc.appendChild(importnode);
					
					// 챕터별 xml 추출
					obj.xmlTransform(idmlS, doc);
					
				} catch (Exception e) {
//					e.printStackTrace();
				    msg = "idml별 xml 파일 생성 실패";
		            System.out.println("msg: " + msg);
		            throw new RuntimeException(msg);
				}

			});
			
		} catch(Exception e) {
			msg = "idml별 xml 파일 생성 실패";
            System.out.println("msg: " + msg);
            throw new RuntimeException(msg);
			
		}

	}
	
	public void createXMLDirs() {
		System.out.println("createXMLDirs() 시작");
		
		// xml 파일이 저장될 폴더 생성
		String eachSrcS = obj.tempDir + File.separator + "eachSrc";
		Path eachSrcP = Paths.get(eachSrcS);
		obj.eachSrcP = eachSrcP; 
		
		try {
			obj.createNewDir(eachSrcP);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
}
