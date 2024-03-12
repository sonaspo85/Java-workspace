package main.oneClickAssist.runMain;

public class AutoCloseableImpl implements AutoCloseable {
    private String file;

    public AutoCloseableImpl(String file) {
        this.file = file;
    }

    public void read() {
        System.out.println(this.file + "를 읽습니다.");
    }

    @Override
    public void close() throws Exception {
        System.out.println("리소스를 닫습니다.");
    }
}
