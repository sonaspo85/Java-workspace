package TEST01;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class IOXPath2019 {
    // �ʱ� html ����
    private File mergedFile;
    private List<IOXclasses> list = new ArrayList<>();  
    
    
    public IOXPath2019(File mergedFile) {
        this.mergedFile = mergedFile;
    }
    
    public List<IOXclasses> setList() {
        // temp ��� ����****
        File file = new File("");
        
        String tempDir = file.getAbsolutePath() + "\\temp\\"; 
        String xsltDir = file.getAbsolutePath() + "\\xsl_2019\\xsls2\\Flare-xsls";
        
        list.add(new IOXclasses(mergedFile.toString(), tempDir + "\\01-make-html.html", xsltDir + "\\01-make-html.xsl"));
        list.add(new IOXclasses(tempDir + "01-make-html.html", tempDir + "02-href_define.html", xsltDir + "\\02-href_define.xsl"));
        list.add(new IOXclasses(tempDir + "02-href_define.html", tempDir + "03-make-review-html.html", xsltDir + "\\03-make-review-html.xsl"));
        list.add(new IOXclasses(tempDir + "03-make-review-html.html", tempDir + "04-nest-bullet-1.html", xsltDir + "\\04-nest-bullet-1.xsl"));
        list.add(new IOXclasses(tempDir + "04-nest-bullet-1.html", tempDir + "05-nest-bullet-body.html", xsltDir + "\\05-nest-bullet-body.xsl"));
        list.add(new IOXclasses(tempDir + "05-nest-bullet-body.html", tempDir + "06-group-bullet-1.html", xsltDir + "\\06-group-bullet-1.xsl"));
        list.add(new IOXclasses(tempDir + "06-group-bullet-1.html", tempDir + "07-group-bullet-2.html", xsltDir + "\\07-group-bullet-2.xsl"));
        list.add(new IOXclasses(tempDir + "07-group-bullet-2.html", tempDir + "08-nest-bullet-2.html", xsltDir + "\\08-nest-bullet-2.xsl"));
        list.add(new IOXclasses(tempDir + "08-nest-bullet-2.html", tempDir + "09-nest-graphic.html", xsltDir + "\\09-nest-graphic.xsl"));
        list.add(new IOXclasses(tempDir + "09-nest-graphic.html", tempDir + "10-nest-between-ols.html", xsltDir + "\\10-nest-between-ols.xsl"));
        list.add(new IOXclasses(tempDir + "10-nest-between-ols.html", tempDir + "11-group-ol.html", xsltDir + "\\11-group-ol.xsl"));
        list.add(new IOXclasses(tempDir + "11-group-ol.html", tempDir + "finalize.html", xsltDir + "\\12-indent-yes.xsl"));
        
        
        return list;
    }

    public List<IOXclasses> setList02() {
        File file = new File("");
        
        String tempDir = file.getAbsolutePath() + "\\temp\\"; 
        String xsltDir = file.getAbsolutePath() + "\\xsl_2019\\xsls2";
        
        list.add(new IOXclasses(tempDir + "finalize.html", tempDir + "13-find-and-replace.xml", xsltDir + "\\13-find-and-replace.xsl"));
        list.add(new IOXclasses(tempDir + "13-find-and-replace.xml", tempDir + "14-olul-grouping.xml", xsltDir + "\\14-olul-grouping.xsl"));
        list.add(new IOXclasses(tempDir + "14-olul-grouping.xml", tempDir + "15-chapterize.xml", xsltDir + "\\15-chapterize.xsl"));
        list.add(new IOXclasses(tempDir + "15-chapterize.xml", tempDir + "16-define-headerName.xml", xsltDir + "\\16-define-headerName.xsl"));
        list.add(new IOXclasses(tempDir + "16-define-headerName.xml", tempDir + "17-grouping-topic.xml", xsltDir + "\\17-grouping-topic.xsl"));
        list.add(new IOXclasses(tempDir + "17-grouping-topic.xml", tempDir + "dummy.xml", xsltDir + "\\18-splitting.xsl"));
        list.add(new IOXclasses(tempDir + "17-grouping-topic.xml", tempDir + "dummy.xml", xsltDir + "\\19-making-toc.xsl"));
        list.add(new IOXclasses(tempDir + "17-grouping-topic.xml", tempDir + "dummy.xml", xsltDir + "\\20-making-start-here.xsl"));
        list.add(new IOXclasses(tempDir + "17-grouping-topic.xml", tempDir + "dummy.xml", xsltDir + "\\21-making-search-html.xsl"));
        list.add(new IOXclasses(tempDir + "17-grouping-topic.xml", tempDir + "dummy.xml", xsltDir + "\\22-making-json.xsl"));
        list.add(new IOXclasses(tempDir + "17-grouping-topic.xml", tempDir + "dummy.xml", xsltDir + "\\23-making-app.xsl"));


        return list;
    }
    
}
