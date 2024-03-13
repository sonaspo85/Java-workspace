package SONTEST.TEST03.fileControl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import SONTEST.TEST03.subWorkClass.commonObj;

public class DmapAttr {
    private Path file;
    List<String> sListArr = new ArrayList<>();
    Map<Integer, String> map = new HashMap<>();
    
    commonObj coj = new commonObj();
    
    static int cnt = 0;
    
    // s
    public DmapAttr(Path file) {
        this.file = file;
    }
    
    
    public void extractAttrName() throws Exception {
//        System.out.println("extractAttrName 시작");
        Charset charset = Charset.forName("UTF-8");

        // 1. InputStream 으로 파일 읽기
        BufferedReader br = Files.newBufferedReader(file, charset);
        
        // DOM 트리 객체 생성 하기
        Document doc = coj.createDomObj(br);
        
        // 5. 문서의 root 요소에 접근하기
        Element root = doc.getDocumentElement();
        
        // 6. @StoryList 값 추출
        String sList = root.getAttribute("StoryList"); 
        
        // 7. sList를 공백으로 분리하여 배열에 저장
        sListArr = Arrays.asList(sList.split(" "));
        
        reactFiles();
    }
    
    
    // 
    public void reactFiles() {
        // designmap.xml 의 부모 디렉토리 추출
        String abPath = file.getParent().toString();
        
        sListArr.stream().forEach(a -> {
            String getEach = a;
            
            String storyFullPath = abPath + File.separator + "Stories" + File.separator + "Story_" + getEach + ".xml";
            Path getStoryPath = Paths.get(storyFullPath);
            
            // 파일이 있는 경우에 map 컬렉션에 저장
            if(Files.exists(getStoryPath)) {
                map.put(cnt, storyFullPath);
                cnt++;
            }
        });
        
//        map.forEach((k,v) -> System.out.println(k + " : " + v));
    }
    
    public Map<Integer, String> getMapList() {
        return map;
    }
}