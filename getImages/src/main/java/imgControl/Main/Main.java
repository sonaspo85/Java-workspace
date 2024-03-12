package main.java.imgControl.Main;

import java.io.File;
import java.io.IOException;

import org.apache.pdfbox.pdmodel.PDDocument;

public class Main {
    public static String pdfPathS = "C:/Users/SMC/Desktop/IMAGE/getImages/aaa.pdf";
    public static String outDir = "C:/Users/SMC/Desktop/IMAGE/getImages";
    public static File pdfPathP = null;
    
    public static PDDocument setPath() {
        pdfPathP = new File(pdfPathS);
        PDDocument doc = null;
        try {
            doc = PDDocument.load(pdfPathP);
            
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        return doc;
    }
    
    public static void main(String[] args) {
        ExtractImagesUseCase useCase = new ExtractImagesUseCase(pdfPathS, outDir);
        useCase.execute();
    }
    
    
    
}