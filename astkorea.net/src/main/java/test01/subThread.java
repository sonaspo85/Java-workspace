package test01;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.MessageFormat;

import javax.mail.MessagingException;

import com.aspose.words.cloud.ApiClient;
import com.aspose.words.cloud.ApiException;
import com.aspose.words.cloud.api.WordsApi;
import com.aspose.words.cloud.model.HtmlSaveOptionsData;
import com.aspose.words.cloud.model.HtmlSaveOptionsData.TableWidthOutputModeEnum;
import com.aspose.words.cloud.model.SaveResponse;
import com.aspose.words.cloud.model.TiffSaveOptionsData;
import com.aspose.words.cloud.model.requests.DownloadFileRequest;
import com.aspose.words.cloud.model.requests.GetDocumentDrawingObjectImageDataOnlineRequest;
import com.aspose.words.cloud.model.requests.GetDocumentDrawingObjectImageDataRequest;
import com.aspose.words.cloud.model.requests.SaveAsRequest;
import com.aspose.words.cloud.model.requests.SaveAsTiffRequest;
import com.aspose.words.cloud.model.requests.UploadFileRequest;

public class subThread extends Thread {
    String localFolder = "";
    String destName = "";
    String fileName = "";
    String clientId = "";
    String clientSecret = "";
    WordsApi wordsApi = null;
    // f
    public subThread(WordsApi wordsApi, String localFolder, String destName, String fileName, String clientId, String clientSecret) {
        this.wordsApi = wordsApi;
        this.localFolder = localFolder;
        this.destName = destName;
        this.fileName = fileName;
        this.clientId = clientId;
        this.clientSecret = clientSecret;
    }
    
    @Override
    public void run() {
        // Upload original document to Cloud Storage
//        WordsApi wordsApi = new WordsApi(clientId, clientSecret, null);
        try {
            wordsApi.uploadFile(new UploadFileRequest(Files.readAllBytes(Paths.get(localFolder+"/"+fileName).toAbsolutePath()), fileName, null));
            // Convert DOCX to HTML
            HtmlSaveOptionsData requestSaveOptionsData = new HtmlSaveOptionsData();
            requestSaveOptionsData.setZipOutput(true);
            
            // 이미지 관련
            requestSaveOptionsData.exportImagesAsBase64(false);
//            requestSaveOptionsData.imageResolution(200);
            requestSaveOptionsData.setScaleImageToShapeSize(true);
            
            // 테이블 셀 너비 및 높이 관련
            requestSaveOptionsData.tableWidthOutputMode(TableWidthOutputModeEnum.ALL);
            
            // 폰트 관련
//            requestSaveOptionsData.allowEmbeddingPostScriptFonts(true);
//            requestSaveOptionsData.setExportFontResources(true);
            requestSaveOptionsData.setFileName(destName);
            
            SaveAsRequest request = new SaveAsRequest(fileName, requestSaveOptionsData,null,null,null,null,null,null);
            
            SaveResponse result = wordsApi.saveAs(request);
            
        } catch (ApiException | MessagingException | IOException e) {
            System.out.println("subThread 에서 예외 발생!!");
            e.printStackTrace();
        }

    }
    
}
