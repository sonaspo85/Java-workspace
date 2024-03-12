package TEST01;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.ByteBuffer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.text.MessageFormat;
import java.util.List;

import org.apache.commons.io.ByteOrderMark;
import org.apache.commons.io.input.BOMInputStream;

public class BomtoNormal {
    List<File> list;
    
    
    public BomtoNormal(List<File> list) {
        this.list = list;
        System.out.println("bom 생성자 호출" + list.size());
    }
    
    public void bomCheck() throws Exception {
        System.out.println("bomCheck 시작");
        for(File eachF : list) {
            // 1. 파일을 읽어 bom 파일인지 확인 하기
            try {
                FileInputStream fis = new FileInputStream(eachF);
                
                // common.io 패키지의 BomInputStream 클래스를 사용하여 BOM 매개값으로 제공된 타입일 경우 스트림으로 래핑하여 읽는다.
                // 즉 bom 파일을 감지 하고 읽고 수정할수 있게 해준다.
                BOMInputStream bomIn = new BOMInputStream(fis, ByteOrderMark.UTF_8, ByteOrderMark.UTF_16BE,
                        ByteOrderMark.UTF_16LE, ByteOrderMark.UTF_32BE, ByteOrderMark.UTF_32LE); 
                Reader reader = new InputStreamReader(bomIn, "UTF-8");
                // BOM 입력스트림 읽기
                int fristNonBOMByte = reader.read();
                
                if(bomIn.hasBOM()) {
//                    System.out.println("BOM 타입입니다.");
                    removeBom(eachF, bomIn);
                } else {
//                    System.out.println("BOM 타입이 아닙니다." + eachF.getName());
                    continue;
                }

            } catch (FileNotFoundException e) {
                throw new Exception("BomtoNormal.java: FileNotFoundException 예외 발생!");
            } catch(IOException e1) {
                throw new Exception("BomtoNormal.java: IOException 예외 발생!");
            } catch(Exception e2) {
                String msg = e2.getMessage();
                String result = "BomtoNormal.java: {0} 예외 발생";
                String result1 = MessageFormat.format(result, msg);
                throw new Exception(result1);
            }
            
        }
    }
    
    private void removeBom(File eachF, BOMInputStream bomIn) throws Exception {
     // 파일내 모든 데이터를 읽어 바이트 배열로 리턴
        Path path = eachF.toPath();
        byte[] bytes = Files.readAllBytes(path);
        
        // ByteBuffer 객체 생성
        // wrap(): 이미 생성되어 있는 배열을 래핑하여 ByteBuffer 객체 생성
        ByteBuffer bb = ByteBuffer.wrap(bytes);
        byte[] bom = null;
        try {
            if(bomIn.hasBOM(ByteOrderMark.UTF_8)) {
                // EF BB BF 3byte가 문서 앞쪽에 포함되어 있다.
                // 3바이트 크기만큼 바이트 배열을 생성 
                bom = new byte[3];
            } else if(bomIn.hasBOM(ByteOrderMark.UTF_16BE) || bomIn.hasBOM(ByteOrderMark.UTF_16LE)) {
                // FE FF, FF FE
                bom = new byte[2];
            } else if (bomIn.hasBOM(ByteOrderMark.UTF_32BE) || bomIn.hasBOM(ByteOrderMark.UTF_32LE)) {
                // FE FF, FF FE
                bom = new byte[4];
            }
            else {
//                System.out.println("bom 파일이 아닙니다.");
            }
            
            // ByteBuffer 에서 3바이트 만큼 읽고 현재 position 위치를 4번째 위치하도록 이동
            bb.get(bom, 0, bom.length);
            
            // 새로운 바이트 배열을 생성하고, 4번째 인덱스 부터 끝까지 바이트 코드로 저장
            byte[] removeBomArr = new byte[bytes.length - bom.length];
            
            // 데이터를 읽고 새롭게 생성한 바이트 배열에 저장
            bb.get(removeBomArr, 0, removeBomArr.length);
            
            // 동일 파일에 덮어쓰기
            Files.write(path, removeBomArr);
            
        } catch (IOException e) {
            System.out.println("BOM 타입 체크 실패 !!");
        }
    }
}
