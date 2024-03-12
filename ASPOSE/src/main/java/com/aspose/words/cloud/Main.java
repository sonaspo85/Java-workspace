package com.aspose.words.cloud;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;

import com.aspose.words.cloud.api.WordsApi;
import com.aspose.words.cloud.model.HtmlSaveOptionsData;
import com.aspose.words.cloud.model.SaveResponse;
import com.aspose.words.cloud.model.requests.ConvertDocumentRequest;
import com.aspose.words.cloud.model.requests.DownloadFileRequest;
import com.aspose.words.cloud.model.requests.SaveAsRequest;
import com.aspose.words.cloud.model.requests.UploadFileRequest;



public class Main {
//  WordsApi wordsApi = new WordsApi("df8fe06b-3812-49e2-8a69-9ee781b9eb33", "c3c344925850f22eb073ad992bc04880", "https://api.aspose.cloud");
//    WordsApi wordsApi = new WordsApi("819678703006-f30fto9fshcj2gst66p97nrj23cc4rj6.apps.googleusercontent.com", "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", null);
 
 
 public static void main(String[] args) throws IOException, ApiException, Exception {
     String fileName = "sample.docx";
     String localFolder = "C:/Temp";     
     String destName = "sample.html";

     // Upload original document to Cloud Storage
     WordsApi wordsApi = new WordsApi("df8fe06b-3812-49e2-8a69-9ee781b9eb33", "c3a36afe5e44816a4da57bf692f73446", null);
     wordsApi.uploadFile(new UploadFileRequest(Files.readAllBytes(Paths.get(localFolder+"/"+fileName).toAbsolutePath()), fileName, null));

     // Convert DOCX to HTML
     HtmlSaveOptionsData requestSaveOptionsData = new HtmlSaveOptionsData();
//     requestSaveOptionsData.setZipOutput(true);

     requestSaveOptionsData.setFileName(destName);
     
     SaveAsRequest request = new SaveAsRequest(fileName,requestSaveOptionsData,null,null,null,null,null,null);
     SaveResponse result = wordsApi.saveAs(request);
     
//     System.out.println(result);

 }

}
