package main.java.qrcodecontroller;

import java.awt.image.BufferedImage;
import java.io.FileInputStream;
import java.nio.charset.Charset;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.xml.transform.stream.StreamResult;

import com.google.zxing.BinaryBitmap;
import com.google.zxing.LuminanceSource;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.Result;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.datamatrix.DataMatrixReader;

public class QRcode {
    
    public String readQR(String path, Map hashMap) throws Exception {
        Charset charset = Charset.forName("UTF-8");
        
        FileInputStream fis = new FileInputStream(path);
        BufferedImage bufferedImage = ImageIO.read(fis);
        LuminanceSource source = new BufferedImageLuminanceSource(bufferedImage);
        BinaryBitmap binaryBitmap = new BinaryBitmap(new HybridBinarizer(source));
        
        Result result = new MultiFormatReader().decode(binaryBitmap);

        fis.close();
        return result.getText();
        
    }
    
    public String readDataMatrix(String path, Map hashMap) throws Exception {
        Charset charset = Charset.forName("UTF-8");
        
        FileInputStream fis = new FileInputStream(path);
        BufferedImage bufferedImage = ImageIO.read(fis);
        LuminanceSource source = new BufferedImageLuminanceSource(bufferedImage);
        HybridBinarizer hybridbinary = new HybridBinarizer(source);
        BinaryBitmap binaryBitmap = new BinaryBitmap(hybridbinary);
        
        Result codeResult = new DataMatrixReader().decode(binaryBitmap, hashMap);
        
        fis.close();
        return codeResult.getText();
     }
    
}
