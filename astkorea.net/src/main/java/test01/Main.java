package test01;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.MessageFormat;

import javax.mail.MessagingException;

import com.aspose.words.cloud.ApiClient;
import com.aspose.words.cloud.ApiException;
import com.aspose.words.cloud.api.WordsApi;
import com.aspose.words.cloud.model.Document;
import com.aspose.words.cloud.model.HtmlSaveOptionsData;
import com.aspose.words.cloud.model.SaveResponse;
import com.aspose.words.cloud.model.TiffSaveOptionsData;
import com.aspose.words.cloud.model.requests.ConvertDocumentRequest;
import com.aspose.words.cloud.model.requests.DownloadFileRequest;
import com.aspose.words.cloud.model.requests.GetDocumentDrawingObjectImageDataOnlineRequest;
import com.aspose.words.cloud.model.requests.GetDocumentDrawingObjectImageDataRequest;
import com.aspose.words.cloud.model.requests.SaveAsRequest;
import com.aspose.words.cloud.model.requests.SaveAsTiffRequest;
import com.aspose.words.cloud.model.requests.UploadFileRequest;



public class Main {
//  WordsApi wordsApi = new WordsApi("df8fe06b-3812-49e2-8a69-9ee781b9eb33", "2507f7d3ee8d19f5276765fece1faf1d", "https://api.aspose.cloud");
//    WordsApi wordsApi = new WordsApi("819678703006-f30fto9fshcj2gst66p97nrj23cc4rj6.apps.googleusercontent.com", "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", null);
 public static String clientId = "ea5f4af5-7cdb-4368-b642-e2153da3c14d";
 public static String clientSecret = "f4fe5b77635994440c2811cf158afa3a";
 
 public static WordsApi wordsApi = new WordsApi(clientId, clientSecret, null);
 
 public static void main(String[] args) throws IOException, ApiException,  Exception {
     String lgns = "JPN";
     
     String cocatLgns = "KSMART2.3.0.0_UserManual_{0}.docx";
     String fileName = MessageFormat.format(cocatLgns, lgns);
     String localFolder = "C:\\Users\\DESK-02 4756\\Desktop\\IMAGE\\html\\ksmartsolutions_UserManual";     
     
     String cocatDest = "KSMART2.3.0.0_UserManual_{0}.html";
     String destName = MessageFormat.format(cocatDest, lgns);
     
     
     
     Thread work = new subThread(wordsApi, localFolder, destName, fileName, clientId, clientSecret);
     work.setDaemon(true);
     work.start();
     
     try {
         work.join();
     } catch(InterruptedException e) {
         System.out.println("메인 클래스에서 예외 발생");
     }
     System.out.println("작업이 완료 되었습니다.");
     
     
     
//     downLoad(wordsApi);


 }
 
 
// public static void downLoad(WordsApi wordsApi) {
//     String storePath = "KSMART2.3.0.0_UserManual_JPN.html.zip";
//     String storageName = "KSMART2.3.0.0_UserManual_JPN.html.zip";
//     
//     DownloadFileRequest downloadRequest = new DownloadFileRequest(storePath, "TEST01", null);
//     try {
//        wordsApi.downloadFile(downloadRequest);
//
//        
//    } catch (ApiException | MessagingException | IOException e) {
//        e.printStackTrace();
//    }
//       
// } 
    
}
