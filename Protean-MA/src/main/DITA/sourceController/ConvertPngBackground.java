package main.DITA.sourceController;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.awt.image.FilteredImageSource;
import java.awt.image.ImageFilter;
import java.awt.image.ImageProducer;
import java.awt.image.RGBImageFilter;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.imageio.ImageIO;

import main.DITA.Common.implementOBJ;
import net.coobird.thumbnailator.Thumbnails;

public class ConvertPngBackground {
    implementOBJ obj = new implementOBJ();
    String collectPngS = "";
    String out2S = "";
    
    String outMapDir = "";
    String strlb1 = "";
    
    public ConvertPngBackground(String collectPngS, String outMapDir, String strlb1) {
        this.collectPngS = collectPngS;
        
        this.outMapDir = outMapDir;
        this.strlb1 = strlb1;
    }
    
    public void forEachImg() {
        Path path = Paths.get(collectPngS);
        out2S = outMapDir + File.separator + strlb1 + File.separator + "contents/images";
        Path out2P = Paths.get(out2S);
        
        if(Files.notExists(out2P)) {
            try {
                Files.createDirectories(out2P);
                
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        DirectoryStream<Path> ds;
        try {
            ds = Files.newDirectoryStream(path);
            
            ds.forEach(a -> {
                String fileName = a.getFileName().toString();
                String fullPath = a.toAbsolutePath().toString();
                        
                if(fileName.endsWith(".png")) {
                    File oriF = new File(fullPath);
                    File newF = new File(out2S + File.separator + fileName);
                    
                    runChangeBackground(oriF, newF);
                }
                            
            });
            
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
            
    }
    
    public void runChangeBackground(File oriF, File newF) {
        try {
            BufferedImage image = ImageIO.read(oriF);
            BufferedImage result = new BufferedImage(image.getWidth(), image.getHeight(), BufferedImage.TYPE_INT_RGB);
            Graphics2D g2d = result.createGraphics();

            if(oriF.toString().contains("M-warning")|
               oriF.toString().contains("M-caution")|
               oriF.toString().contains("M-notice")) {
                String fileName = oriF.getName();
                int color = image.getRGB(0, 0);

                Image image2 = makeColorTransparent(image, new Color(color));
                BufferedImage bufferedImage = new BufferedImage(image.getWidth(), image.getHeight(), BufferedImage.TYPE_INT_ARGB);
                Graphics2D g2 = bufferedImage.createGraphics();
                g2.drawImage(image2, 0, 0, null);
                ImageIO.write(bufferedImage, "PNG", newF);
                
                Thumbnails.of(newF)
                            .outputFormat("png")
                            .size(27, 27)
                            .imageType(BufferedImage.TYPE_INT_ARGB)
                            .outputQuality(0.0)
                            .toFile(newF);
                
            } else {
                // 그리기
                g2d.drawImage(image, 0, 0, Color.WHITE, null);
                ImageIO.write(result, "png", newF);
            }
            
            // 자원 해제
            g2d.dispose();

        }  catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static Image makeColorTransparent(BufferedImage im, final Color color) {
        ImageFilter filter = new RGBImageFilter() {
            // the color we are looking for... Alpha bits are set to opaque
            public int markerRGB = color.getRGB() | 0xFF000000;

            public final int filterRGB(int x, int y, int rgb) {
                if ((rgb | 0xFF000000) == markerRGB) {
                    // Mark the alpha bits as zero - transparent
                    return 0x00FFFFFF & rgb;
                } else {
                    // nothing to do
                    return rgb;
                }
            }
        };

        ImageProducer ip = new FilteredImageSource(im.getSource(), filter);
        return Toolkit.getDefaultToolkit().createImage(ip);
    }
}
