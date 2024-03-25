package SONTEST.TEST03.fileControl.refXslt;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;

import SONTEST.TEST03.subWorkClass.commonObj;
import SONTEST.TEST03.subWorkClass.customUserException;

public class inOutObj {
    public ArrayList<InOutPathClas> list = new ArrayList<>();
    String mergedPath;
    String uiTxt;
    File outDirs;
    commonObj coj = new commonObj();
    
    Path tempFolder = null;
    Path outFolder = null;
    
    public inOutObj(String mergedPath, String uiTxt) {
        this.mergedPath = mergedPath;
        this.uiTxt = uiTxt;
    }
    
    
    public void setList() throws Exception {
        System.out.println("setList 시작");
        String up2Dirs = mergedPath + "../../../";
        Path path = Paths.get(up2Dirs);
        Path up2Path = path.normalize();
        createTempOutFolder(up2Path);
        
        list.add(new InOutPathClas(mergedPath, tempFolder.toString() + "\\01-simplified.xml", up2Path.toString() + "\\xsls\\01-simplify.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\01-simplified.xml", tempFolder.toString() + "\\02-simplify.xml", up2Path.toString() + "\\xsls\\02-simplify.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\02-simplify.xml", tempFolder.toString() + "\\03-simplify.xml", up2Path.toString() + "\\xsls\\03-simplify.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\03-simplify.xml", tempFolder.toString() + "\\04-identified.xml", up2Path.toString() + "\\xsls\\04-identity.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\04-identified.xml", tempFolder.toString() + "\\05-url-detected.xml", up2Path.toString() + "\\xsls\\05-detect-url.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\05-url-detected.xml", tempFolder.toString() + "\\06-assigned-headings.xml", up2Path.toString() + "\\xsls\\06-headings.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\06-assigned-headings.xml", tempFolder.toString() + "\\07-assigned-sections.xml", up2Path.toString() + "\\xsls\\07-sections.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\07-assigned-sections.xml", tempFolder.toString() + "\\08-splited-br.xml", up2Path.toString() + "\\xsls\\08-split-br.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\08-splited-br.xml", tempFolder.toString() + "\\09-topicalized.xml", up2Path.toString() + "\\xsls\\09-topicalize.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\09-topicalized.xml", tempFolder.toString() + "\\10-tree-structured.xml", up2Path.toString() + "\\xsls\\10-tree-structure.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\10-tree-structured.xml", tempFolder.toString() + "\\11-inserted-id-float.xml", up2Path.toString() + "\\xsls\\11-insert-id-float.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\11-inserted-id-float.xml", tempFolder.toString() + "\\12-replaced-link-id.xml", up2Path.toString() + "\\xsls\\12-replace-link-id.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\12-replaced-link-id.xml", tempFolder.toString() + "\\13-nested-note-child.xml", up2Path.toString() + "\\xsls\\13-nest-note-child.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\13-nested-note-child.xml", tempFolder.toString() + "\\14-merged-ul2-note.xml", up2Path.toString() + "\\xsls\\14-merge-ul2-note.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\14-merged-ul2-note.xml", tempFolder.toString() + "\\15-nested-ul2-note.xml", up2Path.toString() + "\\xsls\\15-nest-ul2-note.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\15-nested-ul2-note.xml", tempFolder.toString() + "\\16-nested-img-table-between-ul1-notes.xml", up2Path.toString() + "\\xsls\\16-nest-img-table-between-ul1-notes.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\16-nested-img-table-between-ul1-notes.xml", tempFolder.toString() + "\\17-merged-ul1-note.xml", up2Path.toString() + "\\xsls\\17-merge-ul1-note.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\17-merged-ul1-note.xml", tempFolder.toString() + "\\18-grouped-nested-img-table.xml", up2Path.toString() + "\\xsls\\18-group-nested-img-table.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\18-grouped-nested-img-table.xml", tempFolder.toString() + "\\19-nested-group-img-table.xml", up2Path.toString() + "\\xsls\\19-nest-group-img-table.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\19-nested-group-img-table.xml", tempFolder.toString() + "\\20-nested-description-2-3-4.xml", up2Path.toString() + "\\xsls\\20-nest-description-2-3-4.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\20-nested-description-2-3-4.xml", tempFolder.toString() + "\\21-nested-step-description-note.xml", up2Path.toString() + "\\xsls\\21-nest-step-description-note.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\21-nested-step-description-note.xml", tempFolder.toString() + "\\22-nested-step-ul2-note.xml", up2Path.toString() + "\\xsls\\22-nest-step-ul2-note.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\22-nested-step-ul2-note.xml", tempFolder.toString() + "\\23-nested-step-ul1-note.xml", up2Path.toString() + "\\xsls\\23-nest-step-ul1-note.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\23-nested-step-ul1-note.xml", tempFolder.toString() + "\\24-nest-Step-UL1_2.xml", up2Path.toString() + "\\xsls\\24-nest-Step-UL1_2.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\24-nest-Step-UL1_2.xml", tempFolder.toString() + "\\24-merged-step-ul1-2.xml", up2Path.toString() + "\\xsls\\24-merge-step-ul1-2.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\24-merged-step-ul1-2.xml", tempFolder.toString() + "\\25-nested-ul1-2-3.xml", up2Path.toString() + "\\xsls\\25-nest-ul1-2-3.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\25-nested-ul1-2-3.xml", tempFolder.toString() + "\\26-nested-between-colors.xml", up2Path.toString() + "\\xsls\\26-nest-between-colors.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\26-nested-between-colors.xml", tempFolder.toString() + "\\27-grouped-nested-ol-color.xml", up2Path.toString() + "\\xsls\\27-group-nested-ol-color.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\27-grouped-nested-ol-color.xml", tempFolder.toString() + "\\28-nested-group-ol-colors.xml", up2Path.toString() + "\\xsls\\28-nest-group-ol-colors.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\28-nested-group-ol-colors.xml", tempFolder.toString() + "\\29-nested-ul2-caution-warning.xml", up2Path.toString() + "\\xsls\\29-nest-ul2-caution-warning.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\29-nested-ul2-caution-warning.xml", tempFolder.toString() + "\\30-merged-ul1-caution-warning.xml", up2Path.toString() + "\\xsls\\30-merge-ul1-caution-warning.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\30-merged-ul1-caution-warning.xml", tempFolder.toString() + "\\31-nested-between-cmd-ols.xml", up2Path.toString() + "\\xsls\\31-nest-between-cmd-ols.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\31-nested-between-cmd-ols.xml", tempFolder.toString() + "\\32-grouped-step-cmd-ols.xml", up2Path.toString() + "\\xsls\\32-group-step-cmd-ols.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\32-grouped-step-cmd-ols.xml", tempFolder.toString() + "\\33-nested-between-ol-whites.xml", up2Path.toString() + "\\xsls\\33-nest-between-ol-whites.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\33-nested-between-ol-whites.xml", tempFolder.toString() + "\\34-grouped-ol-whites.xml", up2Path.toString() + "\\xsls\\34-group-ol-whites.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\34-grouped-ol-whites.xml", tempFolder.toString() + "\\35-unwrapped-maginifer.xml", up2Path.toString() + "\\xsls\\35-unwrap-magnifier.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\35-unwrapped-maginifer.xml", tempFolder.toString() + "\\36-reverted-headings.xml", up2Path.toString() + "\\xsls\\36-revert-headings.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\36-reverted-headings.xml", tempFolder.toString() + "\\37-wrapped-div-h1-h2-faq.xml", up2Path.toString() + "\\xsls\\37-wrap-div-h1-h2-faq.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\37-wrapped-div-h1-h2-faq.xml", tempFolder.toString() + "\\37_1-warning-group.xml", up2Path.toString() + "\\xsls\\37_1-warning-group.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\37_1-warning-group.xml", tempFolder.toString() + "\\37_2-warning-group-nest.xml", up2Path.toString() + "\\xsls\\37_2-warning-group-nest.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\37_2-warning-group-nest.xml", tempFolder.toString() + "\\38-created-topic-map.xml", up2Path.toString() + "\\xsls\\38-create-topic-map.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\38-created-topic-map.xml", up2Dirs + "\\resource\\toc-base.xml", up2Path.toString() + "\\xsls\\39-make-toc-base.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\37_2-warning-group-nest.xml", up2Path + "\\resource\\html-base.xml", up2Path.toString() + "\\xsls\\40-make-html-base.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\html-base.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\42-split-into-html.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\toc-base.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\43-make-toc.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\toc-base.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\44-make-index.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\html-base.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\45-make-search-json.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\html-base.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\46-make-id-db-json.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\toc-base.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\47-make-mini-toc.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\toc-base.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\48-make-search-html.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\ui_text.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\49-make-ui_text-json.xsl"));

        executeXslt();
    }
    
    public void executeXslt() throws Exception {
        System.out.println("executeXslt 시작");
        XsltTransform xtf = new XsltTransform(list, uiTxt);
        
        xtf.runXslTranform();        
    }
    
    private void createTempOutFolder(Path path) throws Exception {
        tempFolder = Paths.get(path + "\\temp");
        outFolder = Paths.get(path + "\\output");
        
        try {
            if(Files.isDirectory(outFolder)) {
                coj.delteFolder(outFolder);
                Files.createDirectories(outFolder);
                
            } else if(Files.isDirectory(tempFolder)) {
                coj.delteFolder(tempFolder);
                Files.createDirectories(tempFolder);
                
            } else {
                Files.createDirectories(outFolder);
                Files.createDirectories(tempFolder);
            }

        } catch(Exception e1) {
            throw new customUserException("tempFolder 폴더가 지정되지 않았습니다.");
        }
                
    }
 
}
