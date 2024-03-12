package main.java.imgControl.Main;

import org.apache.pdfbox.contentstream.PDFStreamEngine;
import org.apache.pdfbox.contentstream.operator.Operator;
import org.apache.pdfbox.cos.COSBase;
import org.apache.pdfbox.cos.COSName;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.graphics.PDXObject;
import org.apache.pdfbox.pdmodel.graphics.form.PDFormXObject;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

public class ExtractImagesUseCase extends PDFStreamEngine{
    private final String filePath;
    private final String outputDir;

    // Constructor
    public ExtractImagesUseCase(String filePath,
                                String outputDir){
        this.filePath = filePath;
        this.outputDir = outputDir;
    }

    // Execute
    public void execute(){
        System.out.println("execute 시작");
        try{
            File file = new File(filePath);
            PDDocument document = PDDocument.load(file);

            for(PDPage page : document.getPages()){
                processPage(page);
            }

        }catch(IOException e){
            e.printStackTrace();
        }
    }

    @Override
    protected void processOperator(Operator operator, List<COSBase> operands) throws IOException{
        System.out.println("processOperator 시작");
        String operation = operator.getName();

        if("Do".equals(operation)){
            COSName objectName = (COSName) operands.get(0);
            PDXObject pdxObject = getResources().getXObject(objectName);

            if(pdxObject instanceof PDImageXObject){
                // Image
                PDImageXObject image = (PDImageXObject) pdxObject;
                BufferedImage bImage = image.getImage();

                // File
                String randomName = UUID.randomUUID().toString();
                File outputFile = new File(outputDir,randomName + ".png");

                // Write image to file
                ImageIO.write(bImage, "PNG", outputFile);

            }else if(pdxObject instanceof PDFormXObject){
                PDFormXObject form = (PDFormXObject) pdxObject;
                showForm(form);
            }
        }

        else super.processOperator(operator, operands);
    }
}
