package main.DITA.sourceController;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import main.DITA.Common.implementOBJ;

public class ZipDirectories {
    List<Path> zipDir = new ArrayList<>();
    implementOBJ obj = new implementOBJ();
    
    public List<Path> collectDirs(String idmlout) {
        System.out.println("collectDirs() 시작");
        
        
        Path path = Paths.get(idmlout);
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                zipDir.add(a);
                
            });
            
        } catch(Exception e) {
            
        }
        
        return zipDir;
        
    }
    
	public void zipDirectory(List<Path> zipDir) throws Exception {
		zipDir.forEach(a -> {
			try {
				Path eachDir = a.toAbsolutePath();
				String chapName = a.getFileName().toString();
				String outZipPath = a + ".zip"; 
				FileOutputStream fos = new FileOutputStream(outZipPath);
		        ZipOutputStream zos = new ZipOutputStream(fos);
		        zipSubDirectory("", eachDir, zos);
		        zos.close();
		        fos.close();
		        
		        
			} catch(Exception e1) {
				throw new RuntimeException(e1.getMessage());
				
			}

		});

    }
	
	private static void zipSubDirectory(String basePath, Path dir, ZipOutputStream zos) throws IOException {
        byte[] buffer = new byte[4096];
        
        DirectoryStream<Path> ds = Files.newDirectoryStream(dir);
        
        ds.forEach(b -> {
        	try {
        		// 디렉토리인 경우
            	if(Files.isDirectory(b)) {
            		String path = basePath + b.getFileName() + "/";
                    ZipEntry ze = new ZipEntry(path);
                    zos.putNextEntry(ze);
                    zipSubDirectory(path, b, zos);
                    zos.closeEntry();
                    
            	} else {
                    String is = b.toString(); 
                    FileInputStream fis = new FileInputStream(is); 
                    ZipEntry ze1 = new ZipEntry(basePath + b.getFileName());
                    zos.putNextEntry(ze1);
                    
                    int length;
                    
                    while ((length = fis.read(buffer)) != -1) {
                        zos.write(buffer, 0, length);
                    }
                    zos.closeEntry();
                    fis.close();
                    
            	}
            	
        	} catch(Exception e2) {
        		throw new RuntimeException(e2.getMessage());
        	}

        });
   
    }
	
	public void changeNdel(String idmlout) {
	    System.out.println("changeNdel() 시작");
	    System.out.println("idmlout: " + idmlout);
	    Path path = Paths.get(idmlout);
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                if(Files.isRegularFile(a) & a.getFileName().toString().endsWith(".zip")) {
                    Path form = a;
                    String getDir = a.getParent().toString();
                    String getFileName = a.getFileName().toString().replace(".zip", ".idml");
                    String tarPath = getDir + File.separator + getFileName;
                    System.out.println("tarPath: " + tarPath);
                    
                    
                    Path to = Paths.get(tarPath);

                    try {
                        Files.copy(form, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
                        Files.delete(a);
                        
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                   
                }                 
            });

            delDirs(idmlout);
            
        } catch(Exception e) {
            
        }

	}
	
	public void delDirs(String idmlout) {
	    Path path = Paths.get(idmlout);
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                
                if(Files.isDirectory(a)) {
                    
                    try {
                        obj.recursDel(a);
                        
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                   
                }                 
            });
            
            
            
        } catch(Exception e) {
            
        }
	    
	    
	}
	
}