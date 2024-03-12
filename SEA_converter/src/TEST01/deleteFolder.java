package TEST01;

import java.io.File;

public class deleteFolder {
    
    public void runFindFolder() {
        File file = new File("");
        File tempFolder = new File(file.getAbsoluteFile() + "\\temp");

        if(tempFolder.exists()) {
            deleteFolder(tempFolder);
        } 
        tempFolder.mkdirs();
    }
    
    private void deleteFolder(File tempFolder) {
        File[] contents = tempFolder.listFiles();
        
        for(File file : contents) {
            if(file.isDirectory()) {
                deleteFolder(file);
            } else {
                file.delete();
            }
        }
        tempFolder.delete();
        
    }
    
    
}
