package fontChanger.test.runMain;

import java.io.File;
import java.io.IOException;

import org.apache.pdfbox.cos.COSName;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageTree;
import org.apache.pdfbox.pdmodel.PDResources;
import org.apache.pdfbox.pdmodel.font.PDCIDFont;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.font.PDFontDescriptor;
import org.apache.pdfbox.pdmodel.font.PDType0Font;

public class fontChange {
    String masterPDFPath = "";
    PDDocument doc = null;
    
    public fontChange(String masterPDFPath) {
        this.masterPDFPath = masterPDFPath;
        File file = new File(masterPDFPath);
        
        try {
            doc = PDDocument.load(file);
            
        } catch (IOException e) {
            System.out.println("master.PDF 읽기 실패!");
            e.printStackTrace();
        }
    }
    
    
    
    
    public void runChange() throws Exception {
        PDPageTree pages = doc.getDocumentCatalog().getPages();
        
        for (PDPage page1 : pages) {
            PDResources res = page1.getResources();

            for (COSName fontName : res.getFontNames()) {
                PDFont font = res.getFont(fontName);
                String getFontName = font.getName();
                System.out.println("getFontName: " + getFontName);
                
                if (font instanceof PDType0Font && getFontName.contains("NHNCSR+MS-PGothic")) {                
                    System.out.println("dddd");
                    PDType0Font type0font = (PDType0Font) font;
//                    String newFontName = "HBDUQN+SamsungOne-600";
                    String newFontName = "SamsungOneTCN 450";
                    type0font.getCOSObject().setString(COSName.BASE_FONT, newFontName);
                    System.out.println("---------------------");
                    System.out.println(COSName.BASE_FONT + " -> " + newFontName + "로 변경");
                    PDCIDFont descendantFont = type0font.getDescendantFont();
                    descendantFont.getCOSObject().setString(COSName.BASE_FONT, newFontName);
                    PDFontDescriptor fontDescriptor = descendantFont.getFontDescriptor();
                    fontDescriptor.setFontName(newFontName);
                    
                }
                    
                

                System.out.println("font: " + font.getName());
            }
            
            
            System.out.println("끝");
        }
        doc.save(new File("H:/DITA/Mobile/Bat/mobile-source/out/1_PDF/", "aaa.pdf"));
        doc.close();
    }
    

}

