package main.java.imgControl.Main;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.imageio.ImageIO;

import org.apache.pdfbox.cos.COSName;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDResources;
import org.apache.pdfbox.pdmodel.graphics.PDXObject;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;

public class PdfImageReaderExample {

    public static void main(String args[]) {

        try {
            // load Document object with existing pdf.
            PDDocument pdDocument = PDDocument.load(
                    new FileInputStream("K:\\Kscodes\\pdf\\imageSample.pdf"));

            PDPage pdPage = pdDocument.getPage(0);
            PDResources pdResources = pdPage.getResources();

            int imageCounter = 1;
            for (COSName name : pdResources.getXObjectNames()) {
                PDXObject o = pdResources.getXObject(name);
                if (o instanceof PDImageXObject) {
                    PDImageXObject image = (PDImageXObject) o;
                    String filename = "K:\\Kscodes\\pdf\\images\\image_"
                            + imageCounter + ".png";
                    ImageIO.write(image.getImage(), "png", new File(filename));
                    imageCounter++;
                }
            }

            pdDocument.close();

        } catch (IOException ioe) {
            System.out.println("Error while reading pdf" + ioe.getMessage());
        }

    }

}