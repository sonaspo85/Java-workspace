package main.idmlcontroller;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import main.Common.implementOBJ;



public class createEachIdmlFiles {
	implementOBJ obj = new implementOBJ();
    String msg = "";
    Map<String, Element> eachIdmlCollect = null;
    
    
    
	public createEachIdmlFiles(Map<String, Element> eachIdmlCollect) {
		this.eachIdmlCollect = eachIdmlCollect;
	
	}
	
	public void runEachIdmlFiles() {
		try {
			createXMLDirs();
			
			// idml 별로 모든 doc 노드를 파일로 출력
			eachIdmlCollect.forEach((k,v) -> {
				try {
					String keys = k;
					Element vals = v;
					Document doc = obj.createDOM();
					
					// 키 객체인 idml 이름으로 풀 경로 생성
					String idmlS = obj.tempDir + File.separator + "eachSrc" + File.separator + k + ".xml";
					Node importnode = doc.importNode(vals, true);
					doc.appendChild(importnode);
					obj.xmlTransform(idmlS, doc);
					
				} catch (Exception e) {
				    msg = "idml별 xml 파일 생성 실패";
		            throw new RuntimeException(msg);
				}

			});
			
		} catch(Exception e) {
			msg = "idml별 xml 파일 생성 실패";
            throw new RuntimeException(msg);
			
		}

	}
	
	public void createXMLDirs() {
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
