package xmlTExcel.runMain;



public class Main {
    static String msg = "";
    
    public static void main(String[] args) {
        // TODO Auto-generated method stub
        String tempP = "C:/Users/SMC/Desktop/IMAGE/testdita/excel/temp-html";
        try {
            transformXSLT tf = new transformXSLT(tempP);
            tf.setList();
            
            
        } catch (Exception e3) {
            
            
            e3.printStackTrace();
        }
    }

}
