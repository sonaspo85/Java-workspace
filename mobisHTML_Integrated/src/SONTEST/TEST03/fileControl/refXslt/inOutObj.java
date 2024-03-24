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
        list.add(new InOutPathClas(tempFolder.toString() + "\\01-simplified.xml", tempFolder.toString() + "\\02_0-RTLLgsArrowDirection.xml", up2Path.toString() + "\\xsls\\02_0-RTLLgsArrowDirection.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\02_0-RTLLgsArrowDirection.xml", tempFolder.toString() + "\\02_1-tagsClear.xml", up2Path.toString() + "\\xsls\\02_1-tagsClear.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\02_1-tagsClear.xml", tempFolder.toString() + "\\02_2-videoWithInNode.xml", up2Path.toString() + "\\xsls\\02_2-videoWithInNode.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\02_2-videoWithInNode.xml", tempFolder.toString() + "\\02_3-CharRangeParaRange.xml", up2Path.toString() + "\\xsls\\02_3-CharRangeParaRange.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\02_3-CharRangeParaRange.xml", tempFolder.toString() + "\\03_0-imgOrtagsClear.xml", up2Path.toString() + "\\xsls\\03_0-imgOrtagsClear.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\03_0-imgOrtagsClear.xml", tempFolder.toString() + "\\03_1-tableDefine.xml", up2Path.toString() + "\\xsls\\03_1-tableDefine.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\03_1-tableDefine.xml", tempFolder.toString() + "\\03_2-pDefine.xml", up2Path.toString() + "\\xsls\\03_2-pDefine.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\03_2-pDefine.xml", tempFolder.toString() + "\\04_0-tableWidth.xml", up2Path.toString() + "\\xsls\\04_0-tableWidth.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\04_0-tableWidth.xml", tempFolder.toString() + "\\04_1-hyperlinkPDHD.xml", up2Path.toString() + "\\xsls\\04_1-hyperlinkPDHD.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\04_1-hyperlinkPDHD.xml", tempFolder.toString() + "\\04_2-tagsClear.xml", up2Path.toString() + "\\xsls\\04_2-tagsClear.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\04_2-tagsClear.xml", tempFolder.toString() + "\\05-wrapTagHttp.xml", up2Path.toString() + "\\xsls\\05-wrapTagHttp.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\05-wrapTagHttp.xml", up2Dirs + "\\resource\\ch-images.xml", up2Path.toString() + "\\xsls\\06_0-chapterImgFilePath.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\05-wrapTagHttp.xml", tempFolder.toString() + "\\06_1-convert_PtoH.xml", up2Path.toString() + "\\xsls\\06_1-convert_PtoH.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\06_1-convert_PtoH.xml", tempFolder.toString() + "\\06_2-tagsClear.xml", up2Path.toString() + "\\xsls\\06_2-tagsClear.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\06_2-tagsClear.xml", tempFolder.toString() + "\\07-createPlacing_Video.xml", up2Path.toString() + "\\xsls\\07-createPlacing_Video.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\07-createPlacing_Video.xml", tempFolder.toString() + "\\08-split_BRWithin_ulol.xml", up2Path.toString() + "\\xsls\\08-split_BRWithin_ulol.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\08-split_BRWithin_ulol.xml", tempFolder.toString() + "\\09_0-insert_UL4toUL.xml", up2Path.toString() + "\\xsls\\09_0-insert_UL4toUL.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\09_0-insert_UL4toUL.xml", tempFolder.toString() + "\\09_1-wrap_headingInTopic.xml", up2Path.toString() + "\\xsls\\09_1-wrap_headingInTopic.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\09_1-wrap_headingInTopic.xml", tempFolder.toString() + "\\10-topic_hierarchy.xml", up2Path.toString() + "\\xsls\\10-topic_hierarchy.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\10-topic_hierarchy.xml", tempFolder.toString() + "\\11-insert_excelID.xml", up2Path.toString() + "\\xsls\\11-insert_excelID.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\11-insert_excelID.xml", tempFolder.toString() + "\\12-replace_hrefAttrToSCID.xml", up2Path.toString() + "\\xsls\\12-replace_hrefAttrToSCID.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\12-replace_hrefAttrToSCID.xml", tempFolder.toString() + "\\13-nest_ULnote_child.xml", up2Path.toString() + "\\xsls\\13-nest_ULnote_child.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\13-nest_ULnote_child.xml", tempFolder.toString() + "\\14-adjustGrouping_ul.xml", up2Path.toString() + "\\xsls\\14-adjustGrouping_ul.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\14-adjustGrouping_ul.xml", tempFolder.toString() + "\\15-nest_ULnote.xml", up2Path.toString() + "\\xsls\\15-nest_ULnote.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\15-nest_ULnote.xml", tempFolder.toString() + "\\16-adjustGrouping_ul1.xml", up2Path.toString() + "\\xsls\\16-adjustGrouping_ul1.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\16-adjustGrouping_ul1.xml", tempFolder.toString() + "\\17-tableVR_rowspanCNT.xml", up2Path.toString() + "\\xsls\\17-tableVR_rowspanCNT.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\17-tableVR_rowspanCNT.xml", tempFolder.toString() + "\\18-nest_groupTag.xml", up2Path.toString() + "\\xsls\\18-nest_groupTag.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\18-nest_groupTag.xml", tempFolder.toString() + "\\19-tagsClear.xml", up2Path.toString() + "\\xsls\\19-tagsClear.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\19-tagsClear.xml", tempFolder.toString() + "\\20-nest_by_ul.xml", up2Path.toString() + "\\xsls\\20-nest_by_ul.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\20-nest_by_ul.xml", tempFolder.toString() + "\\21-adjustGrouping_ul1-2.xml", up2Path.toString() + "\\xsls\\21-adjustGrouping_ul1-2.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\21-adjustGrouping_ul1-2.xml", tempFolder.toString() + "\\22-nest-ul1to3.xml", up2Path.toString() + "\\xsls\\22-nest-ul1to3.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\22-nest-ul1to3.xml", tempFolder.toString() + "\\23-nest_betweenColors.xml", up2Path.toString() + "\\xsls\\23-nest_betweenColors.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\23-nest_betweenColors.xml", tempFolder.toString() + "\\24-adjustGrouping_color.xml", up2Path.toString() + "\\xsls\\24-adjustGrouping_color.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\24-adjustGrouping_color.xml", tempFolder.toString() + "\\25-convert_GroupTagsToOL.xml", up2Path.toString() + "\\xsls\\25-convert_GroupTagsToOL.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\25-convert_GroupTagsToOL.xml", tempFolder.toString() + "\\26-nest_ul2CautionWarning.xml", up2Path.toString() + "\\xsls\\26-nest_ul2CautionWarning.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\26-nest_ul2CautionWarning.xml", tempFolder.toString() + "\\27-startGrouping_cmdOL.xml", up2Path.toString() + "\\xsls\\27-startGrouping_cmdOL.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\27-startGrouping_cmdOL.xml", tempFolder.toString() + "\\28-adjustGrouping_cmdOL.xml", up2Path.toString() + "\\xsls\\28-adjustGrouping_cmdOL.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\28-adjustGrouping_cmdOL.xml", tempFolder.toString() + "\\29-imgTagsClear.xml", up2Path.toString() + "\\xsls\\29-imgTagsClear.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\29-imgTagsClear.xml", tempFolder.toString() + "\\30-unWrap_nestingLastImg.xml", up2Path.toString() + "\\xsls\\30-unWrap_nestingLastImg.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\30-unWrap_nestingLastImg.xml", tempFolder.toString() + "\\31-tagsClear.xml", up2Path.toString() + "\\xsls\\31-tagsClear.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\31-tagsClear.xml", tempFolder.toString() + "\\32-define_titleLvNfileAttr.xml", up2Path.toString() + "\\xsls\\32-define_titleLvNfileAttr.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\32-define_titleLvNfileAttr.xml", tempFolder.toString() + "\\33-wrap_h1h2inDiv.xml", up2Path.toString() + "\\xsls\\33-wrap_h1h2inDiv.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\33-wrap_h1h2inDiv.xml", tempFolder.toString() + "\\34-startGrouping_linemit.xml", up2Path.toString() + "\\xsls\\34-startGrouping_linemit.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\34-startGrouping_linemit.xml", tempFolder.toString() + "\\35-nest_warningGroupAttr.xml", up2Path.toString() + "\\xsls\\35-nest_warningGroupAttr.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\35-nest_warningGroupAttr.xml", tempFolder.toString() + "\\36-adjustGrouping_h2Continue.xml", up2Path.toString() + "\\xsls\\36-adjustGrouping_h2Continue.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\36-adjustGrouping_h2Continue.xml", tempFolder.toString() + "\\37-make_videoTags.xml", up2Path.toString() + "\\xsls\\37-make_videoTags.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\37-make_videoTags.xml", tempFolder.toString() + "\\38-define_featureChap_FileAttr.xml", up2Path.toString() + "\\xsls\\38-define_featureChap_FileAttr.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\38-define_featureChap_FileAttr.xml", tempFolder.toString() + "\\39-define_Atag_HrefAttr.xml", up2Path.toString() + "\\xsls\\39-define_Atag_HrefAttr.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\39-define_Atag_HrefAttr.xml", tempFolder.toString() + "\\40-setExportFileName.xml", up2Path.toString() + "\\xsls\\40-setExportFileName.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\40-setExportFileName.xml", tempFolder.toString() + "\\41-tagsClear.xml", up2Path.toString() + "\\xsls\\41-tagsClear.xsl"));
        list.add(new InOutPathClas(tempFolder.toString() + "\\41-tagsClear.xml", up2Dirs + "\\resource\\htmlBase.xml", up2Path.toString() + "\\xsls\\42-defineApplink.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\UITxt.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\43-makeUITextJson.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\tocBase.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\44-makeToc.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\tocBase.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\45-makeToc.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\tocBase.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\46-makeMiniToc.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\tocBase.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\47-makeIndex.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\htmlBase.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\48-convertToHtml.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\htmlBase.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\49-make_id_db.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\htmlBase.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\50-makeSearchJson.xsl"));
        list.add(new InOutPathClas(up2Dirs + "\\resource\\tocBase.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\51-makeSearchHtml.xsl"));
        list.add(new InOutPathClas(up2Path.toString() + "\\xsls\\dummy.xml", tempFolder.toString() + "\\dummy.xml", up2Path.toString() + "\\xsls\\52-makeEOupdate.xsl"));
        executeXslt();
    }
    
    public void executeXslt() throws Exception {
        System.out.println("executeXslt 시작");
        XsltTransform xtf = new XsltTransform(list, uiTxt);
        
        xtf.runXslTranform();        
    }
    
    private void createTempOutFolder(Path path) throws Exception {
        System.out.println("createTempOutFolder() 시작");
        tempFolder = Paths.get(path + "\\temp");
        outFolder = Paths.get(path + "\\output");
        
        if(Files.exists(outFolder)) {
            System.out.println("output폴더 존재함");
            coj.delteFolder(outFolder);
            Files.createDirectories(outFolder);
            
        } 
        
        else if(Files.exists(tempFolder)) {
            coj.delteFolder(tempFolder);
            Files.createDirectories(tempFolder);
            
        } 
        
        else {
            Files.createDirectories(outFolder);
            Files.createDirectories(tempFolder);
        }
   
    }
 
}
