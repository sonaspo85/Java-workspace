package com.Kohyoung.app;

import java.awt.Cursor;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.dnd.DnDConstants;
import java.awt.dnd.DropTarget;
import java.awt.dnd.DropTargetDragEvent;
import java.awt.dnd.DropTargetDropEvent;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JProgressBar;
import javax.swing.JTextPane;
import javax.swing.SwingWorker;
import javax.swing.UIManager;
import javax.swing.WindowConstants;
import javax.swing.filechooser.FileSystemView;
import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;

@SuppressWarnings("serial")
public class Main extends JFrame{	
	private ArrayList<String> languageList2 = Varietyfunction.getArrTextList2();
	private ArrayList<String> chkArray = new ArrayList<String>();
	private String getLang = "";			
	private String folderExplorer = "";	
	private static String templateExplorer = "";
	//private String winValue = "";
	private String outputFolderName;
//	public Logger _logger = Logger.getLogger(Main.class.getName());
	private ArrayList<String> temp;
	private ArrayList<String> extensionRemoveVar;
	private ArrayList<String> arrFileNameListVar;
	private ArrayList<String> arrFileLanguageNameVar; 	

	private boolean cancelWhether  = true;
	
	public static String packageDir = "";
	Path packageTempDir = null;
	public static File codesF = null;
	String srcDir = "";
	int i = 0;

	public Main() throws FileNotFoundException, IOException{
	    System.out.println("Main() 시작");
	    
	    
	    File projectdir = new File("");
        packageDir = projectdir.getAbsoluteFile().toString(); 
//        codesF = new File(packageDir + File.separator + "language/codes.xml");
        
	    setFont(new Font("Dialog", Font.BOLD, 12));
		
//		DOMConfigurator.configure(Varietyfunction.getResourceAsFile("log4j.xml").getPath());						
		
		initComponents();				
		
		textPane.setBounds(117, 10, 325, 21);
		if(textPane.getText() != null || !textPane.getText().isEmpty()) {
			textPane.setText(prop.getProperty("sourceFilePath"));	
		}else {
			textPane.setText("");	
		}
		textPane.setDropTarget(new DropTarget(){
			/**
			 * 
			 */
			
			private static final long serialVersionUID = 1L;

			@Override
            public synchronized void dragEnter(DropTargetDragEvent evt) {                					
				try {
					@SuppressWarnings("unchecked")
					List<File> droppedFiles = (List<File>) evt
					        .getTransferable().getTransferData(
					                DataFlavor.javaFileListFlavor);
					int s = droppedFiles.size();                    
                    if(s != 1){
                        evt.rejectDrag();
                    }/*else if(!droppedFiles.get(0).getName().endsWith(".pdf")){
                        evt.rejectDrag();
                	}*/
				} catch (UnsupportedFlavorException | IOException ex) {					
                    JOptionPane.showOptionDialog(dialog, "Error", "Error", JOptionPane.ERROR_MESSAGE, JOptionPane.ERROR_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.ERROR_MESSAGE);
				}			
            };

			@Override
            public synchronized void drop(DropTargetDropEvent evt) {
                try {
                    evt.acceptDrop(DnDConstants.ACTION_COPY);
                    @SuppressWarnings("unchecked")
					List<File> droppedFiles = (List<File>) evt
                            .getTransferable().getTransferData(
                                    DataFlavor.javaFileListFlavor);
                    if(!droppedFiles.iterator().next().isDirectory()) {
                    	JOptionPane.showOptionDialog(dialog, "It is not a folder.", "It is not a folder.", JOptionPane.ERROR_MESSAGE, JOptionPane.ERROR_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.ERROR_MESSAGE);
                    	return;
                    }else {
                    	for (File file : droppedFiles) {
                    		//Varietyfunction.getArrFileList().remove(textPane.getText());
                        	textPane.setText(file.getAbsolutePath());
                        	//Varietyfunction.showFilesInDIr((file.getAbsolutePath()));                    	
                        }	
                    }
                    
                }catch (UnsupportedFlavorException | IOException ex) {                	
                	JOptionPane.showOptionDialog(dialog, ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE, JOptionPane.ERROR_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.ERROR_MESSAGE);
                }
            }
		});
		
		panel.add(textPane);
		
		JLabel lblWords = new JLabel("Source File Path");
		lblWords.setFont(new Font("굴림", Font.BOLD, 12));
		lblWords.setBounds(4, 3, 109, 33);
		panel.add(lblWords);
		
		folderSelectBtn.setBounds(445, 9, 119, 23);
		folderSelectBtn.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				jButton_folderSelectBtnActionPerformed(e);				
			}
		});
		panel.add(folderSelectBtn);

		JPanel panel_1 = new JPanel();
		panel_1.setBounds(7, 108, 566, 156);
		getContentPane().add(panel_1);
		panel_1.setLayout(null);
		//panel_1.setBackground(Color.black);
		
		JLabel lblLanguage = new JLabel("Languages");
		lblLanguage.setFont(new Font("굴림", Font.BOLD, 12));
		lblLanguage.setBounds(38, 3, 75, 35);
		panel_1.add(lblLanguage);
		
		JPanel panel_2 = new JPanel();
		panel_2.setBounds(119, 9, 419, 136);
		panel_1.add(panel_2);
		panel_2.setLayout(new GridLayout(5, 2));
		
		for(String language : languageList2) {
		
			JCheckBox jCheckBox = new JCheckBox(language);
			
			if(jCheckBox.getText().equals("KOR")) {
				jCheckBox.setSelected(true);
				if(jCheckBox.isSelected()) {					
					if(! chkArray.contains(language)) {						
						chkArray.add(language);
					}else {
						chkArray.remove(language);
					}	
				}
			}
			jCheckBox.addItemListener(new ItemListener() {
			
				@Override
				public void itemStateChanged(ItemEvent e) {					
					if(jCheckBox.isSelected()) {
						if(! chkArray.contains(language)) {
							chkArray.add(language);							
						}
					}else {
						chkArray.remove(language);						
					}if(chkArray.isEmpty()) {
						JOptionPane.showOptionDialog(dialog, "At least one language must be checked.", "Check language selection list", JOptionPane.INFORMATION_MESSAGE, JOptionPane.INFORMATION_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.INFORMATION_MESSAGE);
						return;				
					}
				}
			});
			panel_2.add(jCheckBox);							
		}
		
		startButton = new JButton("Convert");
		startButton.setBounds(479, 276, 92, 23);
		startButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				try {
					jButton_startActionPerformed(e);
				} catch (IOException e1) {				
					e1.printStackTrace();
				}	
				
			}
		});
		
		getContentPane().add(startButton);
		
		panel_3 = new JPanel();
		panel_3.setLayout(null);
		panel_3.setBounds(7, 56, 566, 42);
		getContentPane().add(panel_3);
		
		textPane_1 = new JTextPane();
		textPane_1.setBounds(117, 10, 325, 21);
		if(textPane_1.getText() != null || !textPane_1.getText().isEmpty()) {
			textPane_1.setText(prop.getProperty("outputFilePath"));	
		}else {
			textPane_1.setText("");	
		}
		
		textPane_1.setDropTarget(new DropTarget() {
			@Override
            public synchronized void dragEnter(DropTargetDragEvent evt) {                					
				try {
					@SuppressWarnings("unchecked")
					List<File> droppedFiles = (List<File>) evt
					        .getTransferable().getTransferData(
					                DataFlavor.javaFileListFlavor);
					int s = droppedFiles.size();                    
                    if(s != 1){
                        evt.rejectDrag();
                    }/*else if(!droppedFiles.get(0).getName().endsWith(".pdf")){
                        evt.rejectDrag();
                	}*/
				} catch (UnsupportedFlavorException | IOException ex) {					
                    JOptionPane.showOptionDialog(dialog, ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE, JOptionPane.ERROR_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.ERROR_MESSAGE);
				}			
            };
       
			@Override
            public synchronized void drop(DropTargetDropEvent evt) {
                try {
                    evt.acceptDrop(DnDConstants.ACTION_COPY);
                    @SuppressWarnings("unchecked")
					List<File> droppedFiles = (List<File>) evt
                            .getTransferable().getTransferData(
                                    DataFlavor.javaFileListFlavor);
                    if(!droppedFiles.iterator().next().isDirectory()) {                    	
                    	JOptionPane.showOptionDialog(dialog, "It is not a folder.", "It is not a folder.", JOptionPane.ERROR_MESSAGE, JOptionPane.ERROR_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.ERROR_MESSAGE);
                    	return;
                    }else {
                    	for (File file : droppedFiles) {                    	
                        	textPane_1.setText(file.getAbsolutePath());
                        }	
                    }
                    
                }catch (UnsupportedFlavorException | IOException ex) {                	
                	JOptionPane.showOptionDialog(dialog, ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE, JOptionPane.ERROR_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.ERROR_MESSAGE);
                }
            }
		});
		panel_3.add(textPane_1);
		
		lblOutputFilePath = new JLabel("Output File Path");
		lblOutputFilePath.setFont(new Font("굴림", Font.BOLD, 12));
		lblOutputFilePath.setBounds(4, 3, 111, 33);
		panel_3.add(lblOutputFilePath);
		
		folderSelectBtn_1 = new JButton("Choose");
		folderSelectBtn_1.setBounds(445, 9, 119, 23);
		folderSelectBtn_1.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				jButton_templateActionPerformed(e);
			}
		});
		panel_3.add(folderSelectBtn_1);
		
		dialog.setAlwaysOnTop(true); 
		this.setVisible(true);
		setLocationRelativeTo(null);
	}
	
	private void initComponents() throws FileNotFoundException, IOException{
		//해당 구문은 word에 대한 레지스트리 값을 구별 해주기 위한 구문
//		try {
//			winValue = WinRegistry.valueForKey(WinRegistry.HKEY_CLASSES_ROOT, "Word.Application\\CurVer","");
//			System.out.println("winValue ====" + winValue);
//		} catch (IllegalArgumentException | IllegalAccessException | InvocationTargetException ie ) {
//			ie.printStackTrace();
//		} catch (IOException e) {
//			e.printStackTrace();
//		}			
				
		outputFolderNameSetFrame = new JFrame("Settings");
		outputFolderNameLabel = new JLabel("Output Folder Name");
		outputFolderNameJText = new JTextPane();
		outputFolderNameButton = new JButton("Apply");
		
		List<File> templateList = Varietyfunction.getDirs(new File("template"), 0);
	
		String[] temparray = new String[templateList.size()];

		for(int i = 0; i < templateList.size(); i++)
		{
			temparray[i] = templateList.get(i).getName();	
			comboBoxButton = new JComboBox<String>(temparray);		
			//System.out.println("comboBoxButton == =: " + comboBoxButton.getSelectedItem());
		}
		
		
		File iniFile = new File("Kohyoung-Word2HTML.ini");
		if(!iniFile.exists()) {
			JOptionPane.showOptionDialog(null, "Kohyoung-Word2HTML.ini file does not exist.", "Error", JOptionPane.ERROR_MESSAGE, JOptionPane.ERROR_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.ERROR_MESSAGE);
		}
		prop.load(new FileInputStream("Kohyoung-Word2HTML.ini"));
		
		panel = new JPanel();	
		panel.setLayout(null);
		panel.setBounds(7, 10, 566, 42);
		getContentPane().add(panel);
		
		textPane = new JTextPane();	
			
		comboBoxButton.setBounds(60, 270, 85, 25);
		comboBoxButton.setSelectedIndex(0);	
		comboBoxButton.setEditable(false);
		
		getContentPane().add(comboBoxButton);
		
		folderSelectBtn = new JButton("Choose \n Folder");		
        Image img = Toolkit.getDefaultToolkit().getImage(  
        		Varietyfunction.getResourceAsFile("settings.jpg").getPath()); 
        
		progressPanel = new JTextPane() {
			@Override
             public void paintComponent(Graphics g) { 
				super.paintComponent(g);

	            g.drawImage(img, 0, 0, this.getWidth(), this.getHeight(), this);  
             }  
		};
		progressPanel.setLayout(null);
		progressPanel.setBounds(20, 270, 25, 25);		
		//progressPanel.setBackground(Color.black);	
		getContentPane().add(progressPanel);
	
		progressPanel.addMouseListener(new MouseListener() {			
			@Override
			public void mouseReleased(MouseEvent e) {				
				progressPanel.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));				
			}			
			@Override
			public void mousePressed(MouseEvent e) {				
				progressPanel.setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
			}			
			@Override
			public void mouseExited(MouseEvent e) {						
				progressPanel.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
			}			
			@Override
			public void mouseEntered(MouseEvent e) {				
				progressPanel.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));		
			}			
			@Override
			public void mouseClicked(MouseEvent e) {
				outputFolderNameSetFrame.setSize(290, 150);
				outputFolderNameSetFrame.setLayout(null);
				outputFolderNameSetFrame.setAlwaysOnTop(true);
				outputFolderNameSetFrame.setResizable(false);				
				outputFolderNameSetFrame.setLocationRelativeTo(null);
				outputFolderNameSetFrame.setVisible(true);					
				outputFolderNameSetFrame.addWindowListener(new WindowAdapter() {
					@Override
					public void windowClosing(WindowEvent e) {						
						outputFolderNameSetFrame.dispose();													
												
					}						
				});	
				ImageIcon ImageIcon = new ImageIcon(Varietyfunction.getResourceAsFile("logo.jpg").getPath());
				Image Image = ImageIcon.getImage();
				
				try {
					outputFolderNameJText.setText(outputFolderName);
					prop.setProperty("sourceFilePath", textPane.getText());
					prop.store(new FileOutputStream("Kohyoung-Word2HTML.ini"), null);	
				} catch (Exception e2) {
					e2.printStackTrace();
				}

				
				outputFolderNameSetFrame.setIconImage(Image);
				
				outputFolderNameLabel.setBounds(20, 5, 120, 40);
				
				outputFolderNameJText.setBounds(20, 40, 230, 20);				
				outputFolderNameJText.addKeyListener(new KeyListener() {
					
					@Override
					public void keyTyped(KeyEvent e) {
						if(e.getKeyCode() == 10) {
							
						}
							
					}

					@Override
					public void keyPressed(KeyEvent e) {
						if(e.getKeyCode() == 10) {
							outputFolderName = outputFolderNameJText.getText();
							System.out.println("outputFolderName000:" + outputFolderName);
							try {
		    					prop.setProperty("outputFolderName", outputFolderName);
		    					prop.store(new FileOutputStream("Kohyoung-Word2HTML.ini"), null);
							} catch (Exception e2) {
								e2.printStackTrace();
							}
							outputFolderNameSetFrame.dispose();

						}
					}

					@Override
					public void keyReleased(KeyEvent e) {
//						if(e.getKeyCode() == 10) {
//							outputFolderName = outputFolderNameJText.getText();
//							try {
//		    					prop.setProperty("outputFolderName", outputFolderName);
//		    					prop.store(new FileOutputStream("Kohyoung-Word2HTML.ini"), null);
//							} catch (Exception e2) {
//								e2.printStackTrace();
//							}
//							System.out.println("keyReleased e getKeyCode=========== : "  + e.getKeyCode());
//						}
					}

				});
				
				outputFolderNameButton.setBounds(180, 75, 70, 25);
				outputFolderNameButton.addActionListener(new ActionListener() {
					
					@Override
					public void actionPerformed(ActionEvent e) {
						outputFolderName = outputFolderNameJText.getText();
						try {
	    					prop.setProperty("outputFolderName", outputFolderName);
	    					prop.store(new FileOutputStream("Kohyoung-Word2HTML.ini"), null);
						} catch (Exception e2) {
							e2.printStackTrace();
						}

						outputFolderNameSetFrame.dispose();
											
					}
				});
				
				outputFolderNameSetFrame.add(outputFolderNameButton);
				outputFolderNameSetFrame.add(outputFolderNameLabel);
				outputFolderNameSetFrame.add(outputFolderNameJText);
				
			}
		});
		
		
		ImageIcon ImageIcon = new ImageIcon(Varietyfunction.getResourceAsFile("logo.jpg").getPath());
		Image Image = ImageIcon.getImage();
		this.setIconImage(Image);
		
		getContentPane().setLayout(null);
		setTitle("KY HTML Converter");	
		
		setResizable(false);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(700, 300, 597, 350);
		
        addWindowListener(new java.awt.event.WindowAdapter() {
            @Override
			public void windowOpened(java.awt.event.WindowEvent evt) {
                formWindowOpened(evt);
            }
            @Override
            public void windowClosing(WindowEvent e) { 
            	try {
            		if(textPane.getText() != null || !textPane.getText().isEmpty()) {
            			System.out.println("SourceFilePath is not empty, \n SourceFilePath path is saved.");
        				prop.setProperty("sourceFilePath", textPane.getText());
        				prop.store(new FileOutputStream("Kohyoung-Word2HTML.ini"), null);
            		}
            		if(templateExplorer != null || !templateExplorer.isEmpty()) {
            			System.out.println("OutFilePath is not empty, \n OutFilePath path is saved.");
    					prop.setProperty("outputFilePath", textPane_1.getText());
    					prop.store(new FileOutputStream("Kohyoung-Word2HTML.ini"), null);
            		}

				} catch (Exception e2) {
					e2.printStackTrace();
				}

            	System.exit(0);
            }
        });

	}
	
	
	private void formWindowOpened(java.awt.event.WindowEvent evt) {
		
	}
	
	private void jButton_folderSelectBtnActionPerformed(ActionEvent e) {
		Object obj = e.getSource();
		if (obj == folderSelectBtn) {
			JFileChooser jc = new JFileChooser(FileSystemView.getFileSystemView());
			jc.setAcceptAllFileFilterUsed(false);
			jc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);				
			//jc.setCurrentDirectory(new File(System.getProperty("user.dir")));
			jc.setCurrentDirectory(new File(textPane.getText()));
			int returnVal = jc.showOpenDialog(this);
			if(returnVal == JFileChooser.APPROVE_OPTION){	
				folderExplorer = jc.getSelectedFile().getAbsolutePath();			
				textPane.setText(folderExplorer);

			}else if(returnVal == JFileChooser.CANCEL_OPTION){
				textPane.setText("");
	        }
		}
	}
	
	private void jButton_templateActionPerformed(ActionEvent e) {
		Object obj = e.getSource();
		templateExplorer = "";
		JFileChooser jc = new JFileChooser(FileSystemView.getFileSystemView());

		jc.setAcceptAllFileFilterUsed(false);
		jc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		jc.setCurrentDirectory(new File(textPane_1.getText()));
		int returnVal = jc.showSaveDialog(this);
		if(returnVal == JFileChooser.APPROVE_OPTION){	
			templateExplorer = jc.getSelectedFile().getAbsolutePath();	
			//System.out.println("templateExplorer ==== : " + templateExplorer);
			textPane_1.setText(templateExplorer);
			
			if(obj == folderSelectBtn_1) {
				if(textPane_1.getText().isEmpty() || textPane_1.getText().equals("") 
						|| textPane_1.getText() == null) {					
					JOptionPane.showMessageDialog(dialog, "The folder does not exist.", "Execution Fail", JOptionPane.ERROR_MESSAGE);
					return;				
				}				
				//templateExplorer = textPane_1.getText();
				Varietyfunction.showFilesInDIr3(templateExplorer);				
				if(!new File("template\\"+comboBoxButton.getSelectedItem().toString()).exists()) {					
					JOptionPane.showMessageDialog(dialog, "Template folder does not exist.", "Copy Fail", JOptionPane.ERROR_MESSAGE);
					return;
				}else if(Varietyfunction.getArrTempFilepath().size() == 0 || Varietyfunction.getArrTempFilepath().isEmpty()) {	
					Varietyfunction.templateCopy(new File((String)"template\\" + comboBoxButton.getSelectedItem()), new File(templateExplorer));
					Varietyfunction.templateFontCopy(new File((String)"template\\" + comboBoxButton.getSelectedItem()), new File(templateExplorer));
//					Varietyfunction.templateCopy(new File("template"), new File(templateExplorer));
//					Varietyfunction.templateFontCopy(new File("template"), new File(templateExplorer));

				}else{							
					for(int j = 0; j < Varietyfunction.getDirs(new File(templateExplorer), 0).size(); j++){
						Varietyfunction.templateCopy(new File((String)"template\\" + comboBoxButton.getSelectedItem()), Varietyfunction.getDirs(new File(templateExplorer), 0).get(j));						
						Varietyfunction.templateFontCopy(new File((String)"template\\" + comboBoxButton.getSelectedItem() + "\\css\\fonts"), Varietyfunction.getDirs(new File(templateExplorer), 0).get(j));
//						Varietyfunction.templateCopy(new File("template"), Varietyfunction.getDirs(new File(templateExplorer), 0).get(j));						
//						Varietyfunction.templateFontCopy(new File("template\\css\\fonts"), Varietyfunction.getDirs(new File(templateExplorer), 0).get(j));
					}					
				
				}
				
				try {
					prop.setProperty("outputFilePath", textPane_1.getText());
					prop.store(new FileOutputStream("Kohyoung-Word2HTML.ini"), null);
				
				} catch (Exception e2) {
					e2.printStackTrace();
				}		
				JOptionPane.showOptionDialog(dialog, "The template has been copied successfully.", "Copy Success", JOptionPane.INFORMATION_MESSAGE, JOptionPane.INFORMATION_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.INFORMATION_MESSAGE);
			}
			
		}else if(returnVal == JFileChooser.CANCEL_OPTION){
			textPane_1.setText("");
		}
		
	}
	
	private void jButton_startActionPerformed(ActionEvent evt) throws FileNotFoundException, IOException {	
	    System.out.println("jButton_startActionPerformed() 시작");
		if(textPane.getText().isEmpty() || textPane.getText().equals("") || textPane.getText() == null) {					
			JOptionPane.showMessageDialog(dialog, "The folder does not exist.", "Execution Fail", JOptionPane.ERROR_MESSAGE);
			return;	
			
		}else {						
			if(textPane != null) {
				//jf2 = new JFrame("Converting...");
				progressFrame = null;
				progressFrame = new JFrame("Conversion process");	
				
				prop.setProperty("sourceFilePath", textPane.getText());
				prop.store(new FileOutputStream("Kohyoung-Word2HTML.ini"), null);
				
//				_logger.info("Processing starts.");
				
				outputFolderName = prop.getProperty("outputFolderName");

				if(outputFolderName.isEmpty() || outputFolderName == null || outputFolderName.equals("")) {
					outputFolderName = "Output";
				}
				
				mySW mysw = new mySW();						
				mysw.execute();
									
				progressFrame.addWindowListener(new WindowAdapter() {
					@Override
					public void windowClosing(WindowEvent e) {
						progressFrame.dispose();							
						mysw.cancel(true);
												
					}						
				});	
				//break ;
							
//				while(!mysw.isCancelled()) {
//					mysw.execute();	
//				}				
				
				//worker.execute();								
				return;

			}else {				
				JOptionPane.showOptionDialog(dialog, "No folder selected.", "No folder selected.", JOptionPane.ERROR_MESSAGE, JOptionPane.ERROR_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.ERROR_MESSAGE);
			}

		}

		if(chkArray.size() <= 0) {
			JOptionPane.showOptionDialog(dialog, "There is no language selected.", "There is no language selected.", JOptionPane.ERROR_MESSAGE, JOptionPane.ERROR_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.ERROR_MESSAGE);

			return;	
		}
	}
	
	private class mySW extends SwingWorker<Void, Void>{
	    @Override
	    public void done() {	    	
	        if(isCancelled()) {
	        	cancelWhether = false;	        								
				//System.exit(0);
	        }
	    }
		@Override
		protected Void doInBackground() throws Exception {				
		    System.out.println("doInBackground() 시작");
		    
			try {
				setEnabled(false);
				progressFrame.setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
				progressFrame.setLayout(new FlowLayout());
				progressFrame.setSize(290,80);	
				
				//jf2.setLocation(325, 21);
				//progressFrame.setAlwaysOnTop(true);						
				//jf2.setBounds(300,100, 325, 21);
				//jf2.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);			
				progressFrame.setResizable(false);
								
				ImageIcon ImageIcon = new ImageIcon(Varietyfunction.getResourceAsFile("logo.jpg").getPath());
				Image Image = ImageIcon.getImage();
				progressFrame.setIconImage(Image);						

				jProgressBar1 = new JProgressBar();
				//jProgressBar1.setIndeterminate(true);
				label = new JLabel("");	
				
				progressFrame.add(label);
				progressFrame.add(jProgressBar1);

				progressFrame.setLocationRelativeTo(null);
				progressFrame.setVisible(true);
				
				try {
					// 2) 프로그래스바를 SwingWorker 를 사용해서 그리는 경우							
					temp = new ArrayList<String>();	
					extensionRemoveVar = new ArrayList<String>();
					arrFileNameListVar = new ArrayList<String>();
					arrFileLanguageNameVar = new ArrayList<String>(); 					

					getLang = chkArray.toString().replaceAll("\\[", "").replaceAll("\\]", "");
					System.out.println("convertArr: " + getLang);
					// ------------------------------------------
					Varietyfunction.domParserWrite(getLang);								
					
					codesF = new File(packageDir + File.separator + "language/codes.xml");
					// codes 파일 복사
					String newcodeF = packageDir + File.separator + "xsls/codes.xml";
					Path from = Paths.get(codesF.toString());
					Path to = Paths.get(newcodeF);
					Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
					
					// temp 폴더 삭제 및 생성
					packageTempDir = Paths.get(packageDir + File.separator + "temp");
					String newcodeF2 = packageDir + File.separator + "temp/codes.xml";
					to = Paths.get(newcodeF2);
					Varietyfunction.createNewDir(packageTempDir);
					Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
					
					srcDir = textPane.getText();
					System.out.println("srcDir: " + srcDir);
					Varietyfunction.showFilesInDIr(srcDir);	
					
					// 확장자를 제외한 파일 전체 경로
					// 11: C:\Users\sonas\Desktop\Image\230603\ko\test\AOI 2.8.0.0_Release Notes_Attachments_Internal_ENG
					extensionRemoveVar = Varietyfunction.getExtensionRemoveList();
					
					// 확장자 포함 전체 경로
					// 22: C:\Users\sonas\Desktop\Image\230603\ko\test\AOI 2.8.0.0_Release Notes_Attachments_Internal_ENG.docx
					arrFileNameListVar = Varietyfunction.getarrFileNameList();
					
					// 언어명
					arrFileLanguageNameVar = Varietyfunction.getArrFileLanguageName();				
					
//					int nPrint = 0;					
					
					// xsl 실행하기
					String outDir = outputFolderNameJText.getText();					
					String outDir2 = textPane_1.getText();
					
					System.out.println("outDir 톱니바퀴: " + outDir);
					System.out.println("outDir2 텍스트필드: " + outDir2);

					transformXSLT transxslt = new transformXSLT(packageDir, outDir, outDir2, outputFolderName, srcDir);

					
					String word2htmlDirS = packageDir + File.separator + "xsls" + File.separator + "word2html.exe";
					
					
					int nPrint = 0;
					Varietyfunction.getArrFileList().forEach(a -> System.out.println("rrr: " + a));
					
					for(int w = 0; w < Varietyfunction.getArrFileList().size(); w++) {
						String fullPath = Varietyfunction.getArrFileList().get(w);
						System.out.println("fullPath000: " + fullPath);
						File word2htmlF = new File(word2htmlDirS  + " " + Varietyfunction.getArrFileList().get(w));
						
						label.setText("word2HTML");
                        Varietyfunction.batchEx(word2htmlF);
					}
					
					
					
					for(int i = 0; i < Varietyfunction.getArrFileList().size(); i++) {
						nPrint++;
						String fullPath = Varietyfunction.getArrFileList().get(i);
						System.out.println("fullPath: " + fullPath);
						
						String lang = arrFileLanguageNameVar.get(i);
						
                        label.setText("word2HTML");
                        
                        if(cancelWhether == true){
                        	nPrint++;
                            
                            label.setText("Waiting ..");
                        	
                            // xslt 실행
    					    transxslt.runSpec2xml(i);
//    					    System.out.println("111: " + arrFileNameListVar.get(i).replaceAll(".docx", "_files"));
//    					    System.out.println("222: " + srcDir);
//    					    System.out.println("333: " + outputFolderName);
//    					    System.out.println("444: " + arrFileLanguageNameVar.get(i));
    					    
    					    // 폴더 및 파일 복제
    					    File qdir = new File(fullPath.replace(".docx", ".files"));
    					    File qto = new File(srcDir + File.separator + outputFolderName + File.separator + lang + File.separator + "/images");
    					    
//    					    System.out.println("111: " + qdir.toString());
//    					    System.out.println("222: " + qto.toString());
    					    
    					    if(!qto.exists()) {
    					    	qto.mkdirs();
    					    }
    					    
    					    copyFolder(qdir, qto);
    					    
    					    // 폴더 및 파일 삭제
    					    delteFolder(qdir);
    					    
    					    // htm 파일 삭제
    					    qdir = new File(fullPath.replace(".docx", ".htm"));
    					    qdir.delete();
    					    System.out.println("삭제한 파일: " + qdir.toString());

                            int nProgressCount = 0;
                            int nCount = 0;
                            nProgressCount = 100 / Varietyfunction.getArrFileList().size();
                            nCount = i+1;                                                               
                            jProgressBar1.setValue(nProgressCount * nCount);

                            try {
                                Thread.sleep(20);
                            } catch (InterruptedException ex) {
                                ex.printStackTrace();
                            } 
                            
                            
                        	
                        }
						
					}
				
					

					//reset Line
					arrFileLanguageNameVar.clear();
					temp.clear();
					extensionRemoveVar.clear();
					arrFileNameListVar.clear();	
									
					Varietyfunction.deleteAllFiles("temp");
					setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
					progressFrame.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
					//=======reset Line Done========

				}
				catch (Exception e2) {
					Logger.getLogger(Main.class.getName()).log(Level.INFO, null, e2);
					e2.printStackTrace();				
				} 
//				finally {
//					Varietyfunction.deleteAllFiles("temp");
//					setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
//					jf2.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
//				}	
				
				if(cancelWhether == true) {	
					questionTemplate(JOptionPane.showOptionDialog(null, "The conversion has been \ncompleted successfully.", "Conversion Success", JOptionPane.DEFAULT_OPTION, JOptionPane.INFORMATION_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.YES_OPTION));
					Varietyfunction.openFolder(new File(textPane.getText()));
					progressFrame.dispose();					
				}else {
					//Varietyfunction.deleteAllFiles(textPane.getText()+"\\output");	
//					_logger.info("The processing has been canceled." + textPane.getText());	
					JOptionPane.showOptionDialog(null, "This process has been stopped.\n Process interruption can affect conversion operations.", "It's been canceled", JOptionPane.DEFAULT_OPTION, JOptionPane.INFORMATION_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.INFORMATION_MESSAGE);									
				}
				setEnabled(true);
				cancelWhether = true;			
				//이쪽부분다시볼겄
//				jf2.removeAll();//or remove(JComponent)
//				jf2.revalidate();
//				jf2.repaint();
//				label.setText("");
//				jProgressBar1.setValue(0);	
				
				return null;
				 
				
			} catch (Exception e) {
				Logger.getLogger(Main.class.getName()).log(Level.INFO, null, e);
				e.printStackTrace();
			}
			
			progressFrame.removeAll();//or remove(JComponent)
			progressFrame.revalidate();
			progressFrame.repaint();
			
			return null;		
		}

	}
	
	public static boolean delteFolder(File outFolder) {
	    File[] contents = outFolder.listFiles();
	    
	    for(File file : contents) {
	        if(file.isDirectory()){
	            Path path = Paths.get(file.getAbsolutePath());
	            delteFolder(file);

	        } else {
	            file.delete();
	        }
	    }
	    return outFolder.delete();
	}
	
	public void copyFolder(File QDirs, File Qto) {
		System.out.println("copyFolder() 시작");
		
	    File[] Qfiles = QDirs.listFiles();
	    
	    for(File fileVal : Qfiles) {
	        File temp = new File(Qto.getAbsoluteFile() + File.separator + fileVal.getName());
	        
	        if(fileVal.isDirectory()) {
	            temp.mkdir();
	            copyFolder(fileVal, temp);
	        } else {
	            String fileName = fileVal.getName();
	            Path from = Paths.get(fileVal.toURI());
	            Path to = Paths.get(temp.toURI());
	            
	            try {
	                Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
	            } catch (IOException e) {
	                // TODO Auto-generated catch block
	                e.printStackTrace();
	            }
	            
	        }
	        
	    }
	    
	}
	
	public void questionTemplate(int res) {
		questionTemplateFrame = new JFrame();			
		
		//System.out.println("questionTemplate ==== : "+ (String) comboBoxButton.getSelectedItem().toString());
		//int res = JOptionPane.showOptionDialog(null, "The conversion has been \ncompleted successfully.", "Conversion Success", JOptionPane.DEFAULT_OPTION, JOptionPane.INFORMATION_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.YES_OPTION);		
		if(res == 0) {
		     int res2 = JOptionPane.showOptionDialog(new JFrame(), "Do you want to apply the template to \nthe output folder now?","Apply Template",
	         JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE, null,
	         new Object[] { "   OK   ", "   NO   "}, JOptionPane.YES_OPTION);		     
		     if(res2 == 0) {
	    	 	String templateOutfolderPath = textPane.getText() + "\\" + outputFolderName;
				Varietyfunction.showFilesInDIr3(templateOutfolderPath);
				
				if(!new File("template\\"+comboBoxButton.getSelectedItem().toString()).exists()) {
					JOptionPane.showOptionDialog(questionTemplateFrame, "Template folder does not exist.", "Copy Fail", JOptionPane.ERROR_MESSAGE, JOptionPane.ERROR_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.ERROR_MESSAGE);
					return;
				}else if(Varietyfunction.getArrTempFilepath().size() == 0 || Varietyfunction.getArrTempFilepath().isEmpty()) {						
					Varietyfunction.templateCopy(new File((String)"template\\" + comboBoxButton.getSelectedItem().toString()), new File(templateOutfolderPath));
					Varietyfunction.templateFontCopy(new File((String)"template\\" + comboBoxButton.getSelectedItem().toString()), new File(templateOutfolderPath));
//					Varietyfunction.templateCopy(new File("template"), new File(templateOutfolderPath));
//					Varietyfunction.templateFontCopy(new File("template"), new File(templateOutfolderPath));
				}else{							
					//for(int j = 0; j < Varietyfunction.getDirs(new File((String) comboBoxButton.getSelectedItem().toString()), 0).size(); j++){
					for(int j = 0; j < Varietyfunction.getDirs(new File(templateOutfolderPath), 0).size(); j++){
					    System.out.println("uuuuuuuuuuuuuuuuuuuuuuuuu");
						Varietyfunction.templateCopy(new File((String)"template\\" + comboBoxButton.getSelectedItem().toString()), Varietyfunction.getDirs(new File(templateOutfolderPath), 0).get(j));							
						Varietyfunction.templateFontCopy(new File((String)"template\\" + comboBoxButton.getSelectedItem().toString() + "\\css\\fonts"), Varietyfunction.getDirs(new File(templateOutfolderPath), 0).get(j));
//						Varietyfunction.templateCopy(new File("template"), Varietyfunction.getDirs(new File(templateOutfolderPath), 0).get(j));	
//						Varietyfunction.templateFontCopy(new File("template\\css\\fonts"), Varietyfunction.getDirs(new File(templateOutfolderPath), 0).get(j));
					}										
				}
//				_logger.info("The template has been copied successfully. \n File Path :" + templateExplorer);	
				JOptionPane.showOptionDialog(questionTemplateFrame, "The template has been copied successfully", "Copy Success", JOptionPane.INFORMATION_MESSAGE, JOptionPane.INFORMATION_MESSAGE, null, new Object[] { "   OK   "}, JOptionPane.INFORMATION_MESSAGE);
				//System.exit(0);
		     }
		}
		questionTemplateFrame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
	}
	
	public static void main(String[] args) throws ParserConfigurationException, SAXException, IOException {					
		//int res = JOptionPane.showConfirmDialog(null, "The conversion has been \ncompleted successfully.", "Conversion Success", JOptionPane.DEFAULT_OPTION, JOptionPane.INFORMATION_MESSAGE);
		
		try {
			UIManager.setLookAndFeel("com.sun.java.swing.plaf.windows.WindowsLookAndFeel");
			Varietyfunction.domParser();		
			new Main();
			//Varietyfunction.deleteAllFiles("F:\\Project\\kohyoung\\TEST파일");
		} catch (Exception e) {
			Logger.getLogger(Main.class.getName()).log(Level.INFO, null, e);
			e.printStackTrace();
		}
		//System.out.println("경로 == : " + Varietyfunction.getDirs(new File("F:\\Project\\Kohyoung\\template"), 0));		
		
//		Varietyfunction.languageFolderSearch("F:\\Project\\kohyoung\\최종테스트파일2\\Output\\KOR\\css\\fonts");
//		Varietyfunction.domParser();
//		new Main();	
		
		
	}
	
	private JTextPane textPane;
	private JButton folderSelectBtn;
	private JButton startButton;
	private JPanel panel;
	private JDialog dialog = new JDialog();
	private JPanel panel_3;
	private JTextPane progressPanel;
	private JTextPane textPane_1;
	private JLabel lblOutputFilePath;
	private JButton folderSelectBtn_1;
	private Properties prop = new Properties();
	private JFrame progressFrame;
	private JProgressBar jProgressBar1;
	//private JButton progressButton;
	private JLabel label;	
	private JFrame outputFolderNameSetFrame;
	private JLabel outputFolderNameLabel;
	private JTextPane outputFolderNameJText;
	private JButton outputFolderNameButton;
	private JFrame questionTemplateFrame;
	private JComboBox<String> comboBoxButton;
}
