package main.java.sonTEST.runMain;

import java.nio.file.Path;
import java.util.Map;

import org.w3c.dom.Element;

import main.java.commonObj.commonImpleObj;
import main.java.sonTEST.fileControl.ZipDirectories;
import main.java.sonTEST.fileControl.accessDesignmap;
import main.java.sonTEST.fileControl.allChapterMerged;
import main.java.sonTEST.fileControl.createEachChapterFiles;
import main.java.sonTEST.fileControl.getuniqueMerged;
import main.java.sonTEST.fileControl.idmlControl;
import main.java.sonTEST.fileControl.setUniqueKeys;
import main.java.sonTEST.fileControl.storyesMerged;
import main.java.sonTEST.fileControl.unZip;

public class Main {
	public static commonImpleObj coj = new commonImpleObj();
	
	public static void main(String[] args) throws Exception {
		String manualPath = "C:/Users/SMC/Desktop/IMAGE/aaa/SM-X71X_X81X_X91X_UM_MEA_TT_Ara_Rev.1.0_230726_INDD/idml";
		
		idmlControl fc = new idmlControl(manualPath);
		fc.defaultSet();
		
		// idml 파일을 새로운 폴더로 복사 넣기 위해 폴더 생성
		Path newDir = fc.createNewDir();
		
		// idml 디렉토리가 존재 한다면, 루프를 돌아, idml 파일을 zip 확장자로 변경
		fc.loopFiles();
		
		// unzip 시작
		unZip nuzip = new unZip(newDir);
		nuzip.runUnZip();
		
		// unzip한 각 폴더에 접속
		accessDesignmap designMap = new accessDesignmap();
		designMap.eachDirs();
		
		// 챕터별로 모든 story.xml 수집한 Map 컬렉션 
		Map<String, Element> eachChapMap = storyesMerged.getChapMapCollect();
		
		// 모든 챕터별로 story.xml를 merged 한 map 컬렉션을 챕터별.xml 파일로 출력
		createEachChapterFiles ecf = new createEachChapterFiles(eachChapMap);
		ecf.getEachChapterFiles();
		
		// 각 챕터들을 수집하여 merged.xml 생성 하기
		allChapterMerged acm = new allChapterMerged(coj.outXMLPath);
		acm.runMerged();
		
		// 유니크키 생성하기
		setUniqueKeys suk = new setUniqueKeys();
		suk.setGenerateUkeys();
		
		// newMerged.xml 을 읽어 doc 별로 for 루프를 돌아, 
		// zipDir/챕터폴더/Stories/story.xml 파일로 다시 출력하기(덮어씌우기)
		getuniqueMerged gqm = new getuniqueMerged();
		gqm.runUniqueMerged();
		
		
		// idml 폴더를 zip 확장자로 압축 하기
		ZipDirectories zd = new ZipDirectories();
		zd.zipDirectory();
		
		// zip 확장자 idml로 변경/챕터 폴더 삭제
		System.out.println("idml에 유니크 삽입 / merged.xml 파일생성 완료");
		
//		--------------------------------------------
	}


	
}
