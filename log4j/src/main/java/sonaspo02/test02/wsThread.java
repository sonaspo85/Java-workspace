package sonaspo02.test02;

import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardWatchEventKinds;
import java.nio.file.WatchEvent;
import java.nio.file.WatchEvent.Kind;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;
import java.util.List;

import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.scene.control.TextArea;

public class wsThread extends Thread {
    @FXML private TextArea textArea;
    
    public wsThread(TextArea textArea) {
        this.textArea = textArea;
    }
    
    @Override
    public void run() {
        try {
            // 1. WatchService 객체 생성
            WatchService ws = FileSystems.getDefault().newWatchService();
            
            // 2. 디렉토리의 변화를 감시할 Path 객체 생성
            Path path = Paths.get("C:\\Users\\DESK-02 4756\\Desktop\\IMAGE");
            
            // 3. register() 메소드를 호출하여, 디렉토리 변화 정보를 가지고 있는 WatchKey 객체로 반환
            path.register(ws, StandardWatchEventKinds.ENTRY_CREATE, StandardWatchEventKinds.ENTRY_DELETE, StandardWatchEventKinds.ENTRY_MODIFY);
            
            // 4. while문으로 변화가 발생할때까지 WatchKey 객체 감시
            while(true) {
                // 5. 3번에서 발생되는 WatchKey 객체를 작업큐로 보내, 
                // 작업 처리가 이상없이 완료된 객체만 WatchKey 객체로 반환
                WatchKey wk = ws.take();
                
                // 6. WatchKey 객체로 부터 WatchEvent 얻기 - pollEvents() 메소드
                // pollEvents() 메소드의 반환 타입은 List<WatchEvent<?>> 타입이다.
                List<WatchEvent<?>> list = wk.pollEvents();
                
                // 7. for문을 사용하여, 하나씩 추출해보기
                for(WatchEvent w : list) {
                    // 7-1. 이벤트 정보 얻기 - kind() 메소드
                    Kind kind = w.kind();
                    
                    // 7-2. 감지된 Path 얻기
                    Path conTextPath = (Path) w.context();
                    
                    // 디렉토리내 생성정보가 발생된 경우
                    // 작업 스레드를 통해 UI 변경 하기 위해서 Paltform.runLater(Runnable) 메소드 사용 하였다.
                    if (kind == StandardWatchEventKinds.ENTRY_CREATE) {
                        // 디렉토리내 생성 작업이 일어났을 경우
                        Platform.runLater(() -> textArea.appendText("파일 생성됨 -> " + conTextPath.getFileName() + "\n------------\n"));
                    } else if(kind == StandardWatchEventKinds.ENTRY_DELETE) {  // 삭제 되었을 경우
                        Platform.runLater(() -> textArea.appendText("파일 삭제됨 -> " + conTextPath.getFileName() + "\n------------\n"));
                    } else if(kind == StandardWatchEventKinds.ENTRY_MODIFY) {  // 변경 되었을 경우
                        Platform.runLater(() -> textArea.appendText("파일 변경됨 -> " + conTextPath.getFileName() + "\n------------\n"));
                    } 
//                    else if(kind == StandardWatchEventKinds.OVERFLOW) {  // 삭제 되었을 경우
//                    }
                    
                    
                } // for문 닫기
                
                // 8. WatchKey 객체 초기화 - reset() 메소드
                // 초기화 해주지 않을 경우, 새로운 WatchEvent 발생되면, 작업큐로 다시 들어가기 때문이다. 
                boolean valid = wk.reset();
                
                // 9. WatchKey 초기화 후, while문 빠져 나오기
                if(valid == false) {
                    break;
                }
            }
            
        } catch(Exception e) {}
    }
}
