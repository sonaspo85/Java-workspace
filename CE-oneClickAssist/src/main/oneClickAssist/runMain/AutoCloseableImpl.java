package main.oneClickAssist.runMain;

public class AutoCloseableImpl implements AutoCloseable {
    private String file;

    public AutoCloseableImpl(String file) {
        this.file = file;
    }

    public void read() {
    }

    @Override
    public void close() throws Exception {
    }
}
