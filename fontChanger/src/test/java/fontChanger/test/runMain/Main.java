package fontChanger.test.runMain;

public class Main {

    public static void main(String[] args) {
        // TODO Auto-generated method stub
        String manualPDFPathStr = "H:/DITA/Mobile/Bat/mobile-source/out/1_PDF/final-zh-TW-8.pdf";
        try {
            System.out.println("Main 시작");
            fontChange fc = new fontChange(manualPDFPathStr);
        
            fc.runChange();
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

}
