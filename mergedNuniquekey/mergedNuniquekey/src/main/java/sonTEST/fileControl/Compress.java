package main.java.sonTEST.fileControl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;


public class Compress {
	
	static final String ZIP_NM = "테스트.zip";
	static final String ZIP_PATH = "C:\\Users\\sonas\\Desktop\\Image\\ddd\\zipDir\\001_Cover";
	
	public static void main0(String[]args) throws IOException{
        File dir = new File(ZIP_PATH);
        File file = null;
        String files[] = null;
 
        //파일이 디렉토리 일경우 리스트를 읽어오고
        //파일이 디렉토리가 아니면 첫번째 배열에 파일이름을 넣는다.
        if(dir.isDirectory()) {
            files = dir.list();
            
        } else {
            files = new String[1];
            files[0] = dir.getName();
        }

        ZipArchiveOutputStream zos = null;
         
        try {
            // Zip 파일생성
            zos = new ZipArchiveOutputStream(new BufferedOutputStream(new FileOutputStream(ZIP_PATH+"/"+ZIP_NM)));
             
            for( int i=0; i < files.length; i++ ){
            	file = new File(ZIP_PATH+"/"+files[i]);
            	zip("",file,zos);
  
            }
            zos.close();
 
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            
        } finally {
            if(zos != null) {
                zos.close();
            }
        }

	} 
	
	//압축파일에 파일작성
	public static void zip(String parent, File file, ZipArchiveOutputStream zos) throws IOException {
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		
        //buffer size
        int size = 1024;
        byte[] buf = new byte[size];
        
        if(!file.exists()){
        	System.out.println(file.getName()+" : 파일없음");
        }
		
		//해당 폴더안에 다른 폴더가 재귀호출 
        if(file.isDirectory()) {
            String dirName = file.getPath().replace(ZIP_PATH, "");
            String parentName = dirName.substring(1)+"\\";
            dirName = dirName.substring(1,dirName.length() - file.getName().length());
            ZipArchiveEntry entry = new ZipArchiveEntry(dirName+file.getName()+"\\");
            zos.putArchiveEntry(entry);
            String[] files = file.list();
            
            for( int i=0; i<files.length; i++ ){
            	zip(parentName,new File(file.getPath()+"\\"+files[i]),zos);
            } 
    
        }else{
        	//encoding 설정
            zos.setEncoding("UTF-8");
             
            //buffer에 해당파일의 stream을 입력한다.
            //System.out.println(file.getPath());
            fis = new FileInputStream(file);
            bis = new BufferedInputStream(fis,size);
             
            //zip에 넣을 다음 entry 를 가져온다.
            ZipArchiveEntry entry = new ZipArchiveEntry(parent+file.getName());
            zos.putArchiveEntry(entry);
             
            //준비된 버퍼에서 집출력스트림으로 write 한다.
            int len;
            while((len = bis.read(buf,0,size)) != -1){
                zos.write(buf,0,len);
            }
             
            bis.close();
            fis.close();
            zos.closeArchiveEntry();
        }
	}
}