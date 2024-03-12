package SONTEST.TEST03.fxClass;

import javafx.concurrent.Task;

public class pbTask extends Task<Void> {
    
    
    
    @Override
    protected Void call() throws Exception {
        for(int i=0; i<=100; i++) {
            if(isCancelled()) {
                break;
            }
            updateProgress(i, 100);
            
            try {
                Thread.sleep(10);
            } catch(InterruptedException e1) {
                
            }
        }
        
        return null;
    }
    
    
}
