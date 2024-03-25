package com.Kohyoung.app;

import java.awt.Desktop;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URI;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JOptionPane;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class Varietyfunction {	
	private static ArrayList<String> arrTextList = new ArrayList<String>();
	private static ArrayList<String> arrTextList2 = new ArrayList<String>();
	private static ArrayList<String> extensionRemoveList = new ArrayList<String>();
	private static ArrayList<String> arrFileList = new ArrayList<String>();				
	private static ArrayList<String> arrFileNameList = new ArrayList<String>();
	private static ArrayList<String> arrFileLanguageName = new ArrayList<String>();
	private static ArrayList<String> arrOnlyFilepath = new ArrayList<String>();
	private static ArrayList<String> arrHTMFilepath = new ArrayList<String>();
	private static ArrayList<String> arrTempFilepath = new ArrayList<String>();
	private static ArrayList<String> test = new ArrayList<String>();
	private static ArrayList<String> arrLanguageFolderName = new ArrayList<String>();
	private static int arrLanguageFolderCount;
	
	public static String packageDir = "";
	public static File codesF = null;
	
	
	
	public static void domParser() throws ParserConfigurationException, SAXException, IOException {
	    File projectdir = new File("");
	    packageDir = projectdir.getAbsoluteFile().toString(); 
	    
//	    String newcodeF = packageDir + File.separator + "xsls/codes.xml";
	    codesF = new File(packageDir + File.separator + "xsls/codes.xml");
	    
		System.out.println("codesF: " + codesF);
		
		if(!codesF.exists()) {
			JOptionPane.showMessageDialog(null, "language file does not exist.", "Error", JOptionPane.ERROR_MESSAGE);  			
		}
		
		
		try {
		    // 파일 읽기
	        FileInputStream fis = new FileInputStream(codesF.toString());
	        
	        Reader reader = new InputStreamReader(fis, "UTF-8");
	        InputSource is = new InputSource(reader);
	        is.setEncoding("UTF-8");
	        
	        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	        DocumentBuilder db = dbf.newDocumentBuilder();
	        Document doc = db.parse(is);
	        Element rootTag = doc.getDocumentElement();
	        NodeList nList = doc.getElementsByTagName("option");
	        
	        for(int i = 0; i < nList.getLength(); i++) {
	            Node nNode = nList.item(i);         
	            getArrTextList().add(nNode.getTextContent());

	            if(nNode.getNodeType() == Node.ELEMENT_NODE) {              
	                Element eElement = (Element) nNode;                         
	                getArrTextList2().add(eElement.getAttribute("lang"));                               
	            }
	        }
	        
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public static void domParserWrite(String getLang) throws ParserConfigurationException, SAXException, IOException {
		try {
		    // 파일 읽기
	        FileInputStream fis = new FileInputStream(codesF.toString());
	        
	        Reader reader = new InputStreamReader(fis, "UTF-8");
	        InputSource is = new InputSource(reader);
	        is.setEncoding("UTF-8");
	        
	        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	        DocumentBuilder db = dbf.newDocumentBuilder();
	        Document doc = db.parse(is);
	        Element rootTag = doc.getDocumentElement();			
			Node codesNode = doc.getFirstChild();
			
			if(codesNode.getNodeType() == Node.ELEMENT_NODE) {
				Element cElement = (Element) codesNode;				
				cElement.setAttribute("TotalLang", getLang);
				
				System.out.println("TotalLang: " + getLang);
			}
			
			setTransformer(doc);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public static void setTransformer(Document doc) {
        try {
            codesF.delete();
            
            // 출력 파일 지정
            String newCodeF = packageDir + File.separator + "language/codes.xml";
            File outF = new File(newCodeF);
            URI out2 = outF.toURI();
            
            // 3. TransformerFactory 객체 생성
            TransformerFactory tff = TransformerFactory.newInstance();
            
            // 4. Transformer 객체 생성        
            Transformer trans = tff.newTransformer();
            trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            trans.setOutputProperty(OutputKeys.INDENT, "no");
            trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");
            DOMSource source = new DOMSource(doc);
            Result result = new StreamResult(out2.toString());
            
            trans.transform(source, result);
            System.out.println("끝");
            
        } catch (Exception e) {
            String msg = "Transformer 진행 실패";
            throw new RuntimeException(msg);
        }

    }
	
	public static void transform(String sourcePath, String xsltPath, String resultDir, String param, String param2) {
		try {
			TransformerFactory factory = TransformerFactory.newInstance();
			Transformer transformer = factory.newTransformer(new StreamSource(new File(xsltPath)));					
			transformer.setParameter("filename", param);
			if(param2 == null || param2.equals("")) {
				transformer.setParameter("outfoldername", "Output");
			}else {
				transformer.setParameter("outfoldername", param2);	
			}			
			transformer.setOutputProperty(OutputKeys.ENCODING,"UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "no");
			transformer.setOutputProperty(OutputKeys.METHOD, "xml");					
			transformer.transform(new StreamSource(new File(sourcePath)), new StreamResult(new File(resultDir)));
		} catch (TransformerException e) {
			e.printStackTrace();
		}
	}
	
	public static void transformOutput(String sourcePath, String xsltPath, String resultDir, String param) {
		try {
			TransformerFactory factory = TransformerFactory.newInstance();
			Transformer transformer = factory.newTransformer(new StreamSource(new File(xsltPath)));				
			transformer.setParameter("outputPath", param);
			transformer.setOutputProperty(OutputKeys.ENCODING,"UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "no");
			transformer.setOutputProperty(OutputKeys.METHOD, "xml");					
			transformer.transform(new StreamSource(new File(sourcePath)), new StreamResult(new File(resultDir)));
		} catch (TransformerException e) {
			e.printStackTrace();
		}
	}
	
	public static void transformNoneParam(String sourcePath, String xsltPath, String resultDir) {
		try {
			TransformerFactory factory = TransformerFactory.newInstance();
			Transformer transformer = factory.newTransformer(new StreamSource(new File(xsltPath)));								
			transformer.setOutputProperty(OutputKeys.ENCODING,"utf-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "no");
			transformer.setOutputProperty(OutputKeys.METHOD, "xml");					
			transformer.transform(new StreamSource(new File(sourcePath)), new StreamResult(new File(resultDir)));
		} catch (TransformerException e) {
			e.printStackTrace();
		}
	}
	
	public static void batchEx(File batchFilePath) throws Exception{ 

		int result;
        InputStreamReader isr = null;
        BufferedReader br = null;
		try {
	        String command = batchFilePath.getAbsolutePath();	       
	        Process p =  Runtime.getRuntime().exec(command);        
	        isr = new InputStreamReader(p.getInputStream());
	        br = new BufferedReader(isr);
	        String line = null;     
	        while((line = br.readLine()) !=null){
	        	System.out.println("line : " + line);
	        } 
	        isr.close();
	        br.close();
	        int waitFor = p.waitFor();
	        result = p.exitValue();	      
		} catch (Exception e) {
			e.printStackTrace();
		}

    }
	
	public static void showFilesInDIr(String srcDir) {
	    System.out.println("showFilesInDIr() 시작");
	    System.out.println("srcDir: " + srcDir);
	    
		getArrFileList().removeAll(arrFileList);
		
        File directory = new File(srcDir);  //검색할 폴더
        
        /** 지정한 디렉토리 하위 파일의 갯수 **/
        File[] childs = directory.listFiles(new FileFilter() {
            @Override
			public boolean accept(File pathname) {             	
            	return pathname.isFile(); 
            	}
        });        
        
        
        
        Path srcDirP = Paths.get(srcDir);
        try {
            DirectoryStream <Path> ds = Files.newDirectoryStream(srcDirP);
            
            ds.forEach(a -> {
                String childName = a.toAbsolutePath().toString();
//                System.out.println("childName1: " + childName);
                
                if(Files.isRegularFile(a)) {
                    getArrFileLanguageName().add(childName.substring(childName.lastIndexOf("_")+1, childName.lastIndexOf(".")));
                    
                    
                    int idx = childName.lastIndexOf(".");
                    String fileExtensionRemove = childName.substring(0,idx);    
                    // 하위폴더와 필요없는 파일들을 제외하고 필요한 파일들만 출력한다.
                    if((childName.endsWith(".docx"))) {
                       getExtensionRemoveList().add(fileExtensionRemove);
                       getArrFileList().add(childName);    
                       getarrFileNameList().add(childName);
                    }
                    
                } else if(Files.isDirectory(a)) {
                    try {
                        DirectoryStream <Path> ds2 = Files.newDirectoryStream(a);
                        
                        ds2.forEach(c -> {
                            String childName2 = c.toAbsolutePath().toString();

                            if(Files.isRegularFile(c)) {
                                getArrFileLanguageName().add(childName2.substring(childName2.lastIndexOf("_")+1, childName2.lastIndexOf(".")));
                                int idx = childName2.lastIndexOf(".");
                                String fileExtensionRemove2 = childName2.substring(0,idx);
                                
                                if((childName2.toLowerCase().endsWith(".docx"))) {
                                    getExtensionRemoveList().add(fileExtensionRemove2);                      
                                    getArrFileList().add(childName2);    
                                    getarrFileNameList().add(childName2);        
                                }
                                
                            }

                        });
                     
                    } catch (IOException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                    
                }
                
                
            });
            
            
             
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

	}
	
	public static void showFilesInDIr2(String dirPath) {			
		File dir = new File(dirPath);	
		File files[] = dir.listFiles(new FilenameFilter() {		
			@Override
			public boolean accept(File dir, String name) {
				// TODO Auto-generated method stub				
				return name.toLowerCase().endsWith(".files");
			}
		});

		for(int i = 0; i <files.length; i++) {			
			File file = files[i];				
			String fileName = file.getAbsolutePath();						
											
			if(file.isDirectory()) {							
				showFilesInDIr2(file.getPath());
			}else{				
				getArrHTMFilepath().add(fileName);
						
			}			
		}		
				
	}
	
	
	 public static String showFilesInDIr3(String dirPath) {
		    File dir = new File(dirPath);		    
		    File files[] = dir.listFiles();
        	
		    for (int i = 0; i < files.length; i++) {
		        File file = files[i];		        
		        if (file.isDirectory()) {
		            showFilesInDIr3(file.getPath());		            
		            getArrTempFilepath().add(file.getPath());
		            break;    		                   			        	
		        } else {
		        }
		    }
			return dirPath;
		
	}	

	
	public static void folderCopy(String dirFolderPath, String desFolderPath) {	
		String dirpath = dirFolderPath;
		String despath = desFolderPath;
		 
		File dir = new File(dirpath);
		 
		if (dir.isDirectory()) {
		    File[] files = dir.listFiles(
		            new FileFilter() {
		                @Override
		                public boolean accept(File pathname) {
		                    return pathname.isFile();
		                }
		            }
		            );
		    for (File file : files) {		    	
		            File des = new File(despath + file.getName());		            
		            if (des.exists()) {
		                System.out.println("des is already exists!");
		                des.delete();
		            }
		            try {		            	
		               Files.copy(file.toPath(), des.toPath());		               
		            } catch (Exception e) {
		                e.printStackTrace();
		            }
		    }
		}
	}
	
	public static void templateCopy(File sourceF, File targetF){
		File[] ff = sourceF.listFiles(new FileFilter() {
			
			@Override
			public boolean accept(File pathname) {				
				return !pathname.getAbsolutePath().contains("fonts");
			}
		});

		for (File file : ff) {
			File temp = new File(targetF.getAbsolutePath() + File.separator + file.getName());			
			if(file.isDirectory()){
				temp.mkdir();
				templateCopy(file, temp);
			} else {
				FileInputStream fis = null;
				FileOutputStream fos = null;
				try {
					fis = new FileInputStream(file);
					fos = new FileOutputStream(temp) ;
					byte[] b = new byte[4096];
					int cnt = 0;
					while((cnt=fis.read(b)) != -1){
						fos.write(b, 0, cnt);
					}
				} catch (Exception e) {
					e.printStackTrace();
				} finally{
					try {
						fis.close();
						fos.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				}

			}
		}
	
	}
	
	public static void templateFontCopy(File sourceF, File targetF){
		File[] ff = sourceF.listFiles();

		for (File file : ff) {			
			File newFonts = new File(targetF.getAbsolutePath()+"\\css\\fonts");
			if(!newFonts.exists()) {
				newFonts.mkdir();
			}
			File temp = new File(targetF.getAbsolutePath()+"\\css\\fonts"+File.separator + file.getName());
			if(targetF.getAbsolutePath().endsWith("KOR")) {
				if(temp.getName().equalsIgnoreCase("NotoSansKR-Regular-Alphabetic.eot")) {
					if(file.isDirectory()){
						temp.mkdir();						
						templateCopy(file, temp);
					} else {						
						FileInputStream fis = null;
						FileOutputStream fos = null;											
						try {   
							fis = new FileInputStream(file);
							fos = new FileOutputStream(temp);
							byte[] b = new byte[4096];
							int cnt = 0;
							while((cnt=fis.read(b)) != -1){
								fos.write(b, 0, cnt);
							}
						} catch (Exception e) {
							e.printStackTrace();
						} finally{
							try {
								fis.close();
								fos.close();
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							
						}

					}
				}
			

			}
			if(targetF.getAbsolutePath().endsWith("ENG")) {
				if(temp.getName().equalsIgnoreCase("MyriadPro-Regular.eot")
						|| temp.getName().equalsIgnoreCase("MyriadPro-Regular.otf")) {
					if(file.isDirectory()){
						temp.mkdir();
						templateCopy(file, temp);
					} else {
						FileInputStream fis = null;
						FileOutputStream fos = null;						
						try {
							fis = new FileInputStream(file);
							fos = new FileOutputStream(temp) ;
							byte[] b = new byte[4096];
							int cnt = 0;
							while((cnt=fis.read(b)) != -1){
								fos.write(b, 0, cnt);
							}
						} catch (Exception e) {
							e.printStackTrace();
						} finally{
							try {
								fis.close();
								fos.close();
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							
						}

					}
				}
			}
			if(targetF.getAbsolutePath().endsWith("JPN")) {
				if(temp.getName().equalsIgnoreCase("meiryo.ttc")) {
					if(file.isDirectory()){
						temp.mkdir();
						templateCopy(file, temp);
					} else {
						FileInputStream fis = null;
						FileOutputStream fos = null;
						try {
							fis = new FileInputStream(file);
							fos = new FileOutputStream(temp) ;
							byte[] b = new byte[4096];
							int cnt = 0;
							while((cnt=fis.read(b)) != -1){
								fos.write(b, 0, cnt);
							}
						} catch (Exception e) {
							e.printStackTrace();
						} finally{
							try {
								fis.close();
								fos.close();
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							
						}

					}
				}
			}
			
			if(targetF.getAbsolutePath().endsWith("CHN")) {
				if(temp.getName().equalsIgnoreCase("simsun.ttc")) {
					if(file.isDirectory()){
						temp.mkdir();						
						templateCopy(file, temp);
					} else {
						FileInputStream fis = null;
						FileOutputStream fos = null;
						try {
							fis = new FileInputStream(file);
							fos = new FileOutputStream(temp) ;
							byte[] b = new byte[4096];
							int cnt = 0;
							while((cnt=fis.read(b)) != -1){
								fos.write(b, 0, cnt);
							}
						} catch (Exception e) {
							e.printStackTrace();
						} finally{
							try {
								fis.close();
								fos.close();
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							
						}

					}
				}
			}
			
		}
	
	}

	
	public static void languageFolderSearch(String dirPath) {
		    File dir = new File(dirPath);		    
		    File files[] = dir.listFiles();
		    arrLanguageFolderName.clear();
		    arrLanguageFolderCount = 0;
     	    
		    for (int i = 0; i < files.length; i++) {
		        File file = files[i];		        
		        if (file.isDirectory()) {		        	
		        	arrLanguageFolderName.add(file.getPath());
		        	arrLanguageFolderCount = arrLanguageFolderName.size();		                       			       
		        } else {		        	
		            System.out.println("file: " + file);
		        }
		    }
			return;		
	}	

	public static List<File> getDirs(File parent, int level){
	    List<File> dirs = new ArrayList<File>();
	    File[] files = parent.listFiles();
	    if (files == null) 
	    	return dirs; // empty dir
	    for (File f : files){
	        if (f.isDirectory()) {
	             if (level == 0) {	            	 
	            	 dirs.add(f);	            	 
	             }else if (level > 0) { 	            	 
	            	 dirs.addAll(getDirs(f,level-1));	            	 
	             }
	        }
	    }
	    return dirs;
	}

	
	public static File getResourceAsFile(String resourcePath) {
		try {
			InputStream in = ClassLoader.getSystemClassLoader().getResourceAsStream(resourcePath);			
			if (in == null) {
				return null;
			}
			File tempFile = File.createTempFile(String.valueOf(in.hashCode()), ".tmp");
			tempFile.deleteOnExit();

			try (FileOutputStream out = new FileOutputStream(tempFile)) {
				byte[] buffer = new byte[1024];
				int bytesRead;
				while ((bytesRead = in.read(buffer)) != -1) {
					out.write(buffer, 0, bytesRead);
				}
			}
			return tempFile;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static void fileCopy(String sourcePath, String targetPath) {
		File f = new File("");
        Path source = Paths.get(sourcePath);
        Path target = Paths.get(targetPath);

        try {
            if (!Files.exists(target.getParent())) {
                Files.createDirectories(target.getParent());
            }

            Files.copy(source, target, StandardCopyOption.REPLACE_EXISTING);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	
	public static void deleteAllFiles(String path) {
		File file = new File(path);
		File[] tempFile = file.listFiles();

		if (tempFile.length > 0) {
			for (int i = 0; i < tempFile.length; i++) {
				if (tempFile[i].isFile()) {
					tempFile[i].delete();
				} else {
					deleteAllFiles(tempFile[i].getPath());
				}
				tempFile[i].delete();

			}
			file.delete();

		}
	}
	
	public static void deleteFile(String path) {	
		File file = new File(path);  
		if( file.exists() ){
			if(file.delete()){
				System.out.println("파일삭제 성공");
			}else{
				System.out.println("파일삭제 실패");
			}
		}else{
			System.out.println("파일이 존재하지 않습니다.");
		}
  	
}

	public static void createNewDir(Path newPath) throws Exception {
        if(Files.notExists(newPath)) {
            Files.createDirectories(newPath);
            System.out.println("폴더 생성 완료!");
            
        } else {
            recursDel(newPath);
            Files.createDirectories(newPath);
        }
    }
	
	public static void recursDel(Path path) {
        try {
            DirectoryStream<Path> ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                if(Files.isDirectory(a)) {
                    recursDel(a);
                    
                } else {
                    try {
                        Files.delete(a);
                        
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                
            });
            
            Files.delete(path);
            
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
    }
	
	
	public static void CreateTempF(String folderPath){
	     String path = folderPath;
	     File file = new File(path);
	     
	     if(!file.exists()){
	         //디렉토리 생성 메서드
	         file.mkdirs();
	         System.out.println("created directory successfully!");
	     }
     
	}

	public static void openFolder(File dirToOpen){
	    Desktop desktop = Desktop.getDesktop();	    
	    try {	        
	        try {
				desktop.open(dirToOpen);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    } catch (IllegalArgumentException iae) {
	    	System.out.println(iae.getMessage());
	        System.out.println("File Not Found");
	    }	
	}

	public static ArrayList<String> getArrTextList() {
		return arrTextList;
	}

	public static void setArrTextList(ArrayList<String> arrTextList) {
		Varietyfunction.arrTextList = arrTextList;
	}

	public static ArrayList<String> getArrTextList2() {
		return arrTextList2;
	}

	public static void setArrTextList2(ArrayList<String> arrTextList2) {
		Varietyfunction.arrTextList2 = arrTextList2;
	}

	public static ArrayList<String> getArrFileList() {
		return arrFileList;
	}

	public static void setArrFileList(ArrayList<String> arrFileList) {
		Varietyfunction.arrFileList = arrFileList;
	}

	public static ArrayList<String> getExtensionRemoveList() {
		return extensionRemoveList;
	}

	public static void setExtensionRemoveList(ArrayList<String> extensionRemoveList) {
		Varietyfunction.extensionRemoveList = extensionRemoveList;
	}
	
	public static ArrayList<String> getarrFileNameList() {
		return arrFileNameList;
	}

	public static void setarrFileNameList(ArrayList<String> arrFileNameList) {
		Varietyfunction.arrFileNameList = arrFileNameList;
	}

	public static ArrayList<String> getArrFileLanguageName() {
		return arrFileLanguageName;
	}

	public static void setArrFileLanguageName(ArrayList<String> arrFileLanguageName) {
		Varietyfunction.arrFileLanguageName = arrFileLanguageName;
	}
	
	public static ArrayList<String> getArrOnlyFilepath() {
		return arrOnlyFilepath;
	}

	public static void setArrOnlyFilepath(ArrayList<String> arrOnlyFilepath) {
		Varietyfunction.arrOnlyFilepath = arrOnlyFilepath;
	}

	public static ArrayList<String> getArrHTMFilepath() {
		return arrHTMFilepath;
	}

	public static void setArrHTMFilepath(ArrayList<String> arrHTMFilepath) {
		Varietyfunction.arrHTMFilepath = arrHTMFilepath;
	}

	public static ArrayList<String> getArrTempFilepath() {
		return arrTempFilepath;
	}

	public static void setArrTempFilepath(ArrayList<String> arrTempFilepath) {
		Varietyfunction.arrTempFilepath = arrTempFilepath;
	}
	
	public static ArrayList<String> getTest() {
		return test;
	}

	public static void setTest(ArrayList<String> test) {
		Varietyfunction.test = test;
	}
	
}
