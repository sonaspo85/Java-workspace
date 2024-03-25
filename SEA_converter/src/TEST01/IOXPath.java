package TEST01;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

public class IOXPath {
    // �ʱ� html ����
    private File mergedFile;
    private List<IOXclasses> list = new ArrayList<>();  
    
    
    public IOXPath(File mergedFile) {
        this.mergedFile = mergedFile;
    }
    
    public List<IOXclasses> setList() {
        File file = new File("");        
        String tempDir = file.getAbsolutePath() + "\\temp\\"; 
        String xsltDir = file.getAbsolutePath() + "\\xsl_2022\\xsls2\\Flare-xsls";

        list.add(new IOXclasses(mergedFile.toString(), tempDir + "\\00-make-one-html.html", xsltDir + "\\00-make-one-html.xsl"));
        list.add(new IOXclasses(tempDir + "\\00-make-one-html.html", tempDir + "01-make-html.html", xsltDir + "\\01-make-html.xsl"));
        list.add(new IOXclasses(tempDir + "01-make-html.html", tempDir + "02-href_define.html", xsltDir + "\\02-href_define.xsl"));
        list.add(new IOXclasses(tempDir + "02-href_define.html", tempDir + "03-review.html", xsltDir + "\\03-make-review-html.xsl"));
        list.add(new IOXclasses(tempDir + "03-review.html", tempDir + "04-nested1.html", xsltDir + "\\04-nest-bullet-1.xsl"));
        list.add(new IOXclasses(tempDir + "04-nested1.html", tempDir + "05-nested2.html", xsltDir + "\\05-nest-bullet-body.xsl"));
        list.add(new IOXclasses(tempDir + "05-nested2.html", tempDir + "06-grouped1.html", xsltDir + "\\06-group-bullet-1.xsl"));
        list.add(new IOXclasses(tempDir + "06-grouped1.html", tempDir + "07-img_wrap.html", xsltDir + "\\07-img_wrap.xsl"));
        list.add(new IOXclasses(tempDir + "07-img_wrap.html", tempDir + "08-nested3.html", xsltDir + "\\08-nest-bullet-2.xsl"));
        list.add(new IOXclasses(tempDir + "08-nested3.html", tempDir + "09-nested4.html", xsltDir + "\\09-nest-graphic.xsl"));
        list.add(new IOXclasses(tempDir + "09-nested4.html", tempDir + "10-nested5.html", xsltDir + "\\10-nest-between-ols.xsl"));
        list.add(new IOXclasses(tempDir + "10-nested5.html", tempDir + "11-grouped3.html", xsltDir + "\\11-group-ol.xsl"));
        list.add(new IOXclasses(tempDir + "11-grouped3.html", tempDir + "finalize.html", xsltDir + "\\12-temporary_check.xsl"));
        
        return list;
    }

    public List<IOXclasses> setList02() {
        File file = new File("");
        String tempDir = file.getAbsolutePath() + "\\temp\\"; 
        String xsltDir = file.getAbsolutePath() + "\\xsl_2022\\xsls2";
        copyFinalize(mergedFile.toString(), tempDir + "finalize.html");
        
        list.add(new IOXclasses(tempDir + "finalize.html", tempDir + "13-find-and-replace.xml", xsltDir + "\\13-find-and-replace.xsl"));
        list.add(new IOXclasses(tempDir + "13-find-and-replace.xml", tempDir + "14-olul-grouping.xml", xsltDir + "\\14-olul-grouping.xsl"));
        list.add(new IOXclasses(tempDir + "14-olul-grouping.xml", tempDir + "15-chapterize.xml", xsltDir + "\\15-chapterize.xsl"));
        list.add(new IOXclasses(tempDir + "15-chapterize.xml", tempDir + "16-toc_chap_group.xml", xsltDir + "\\16-toc_chap_group.xsl"));
        list.add(new IOXclasses(tempDir + "16-toc_chap_group.xml", tempDir + "17-class_blue_group.xml", xsltDir + "\\17-class_blue_group.xsl"));
        list.add(new IOXclasses(tempDir + "17-class_blue_group.xml", tempDir + "18-sectionize.xml", xsltDir + "\\18-sectionize.xsl"));
        list.add(new IOXclasses(tempDir + "18-sectionize.xml", tempDir + "19-grouping-topic.xml", xsltDir + "\\19-grouping-topic.xsl"));
        list.add(new IOXclasses(tempDir + "19-grouping-topic.xml", tempDir + "20-define-Header_href_table.xml", xsltDir + "\\20-define-Header_href_table.xsl"));
        list.add(new IOXclasses(tempDir + "20-define-Header_href_table.xml", tempDir + "dummy.xml", xsltDir + "\\21-minitoc.xsl"));
        list.add(new IOXclasses(tempDir + "20-define-Header_href_table.xml", tempDir + "dummy.xml", xsltDir + "\\22-splitting.xsl"));
        list.add(new IOXclasses(tempDir + "20-define-Header_href_table.xml", tempDir + "dummy.xml", xsltDir + "\\23-making-toc.xsl"));
        list.add(new IOXclasses(tempDir + "20-define-Header_href_table.xml", tempDir + "dummy.xml", xsltDir + "\\24-making-start-here.xsl"));
        list.add(new IOXclasses(tempDir + "19-grouping-topic.xml", tempDir + "dummy.xml", xsltDir + "\\25-making-search-html.xsl"));
        list.add(new IOXclasses(tempDir + "19-grouping-topic.xml", tempDir + "dummy.xml", xsltDir + "\\26-making-json.xsl"));
        
        return list;
    }
    
    public void copyFinalize(String src, String tar) {
        Path srcPath = Paths.get(src);
        Path tarPath = Paths.get(tar);
        
        try {
            Files.copy(srcPath, tarPath, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
        } catch (IOException e) {
        }
    }
    
}
