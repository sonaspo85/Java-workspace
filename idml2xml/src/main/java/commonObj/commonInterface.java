package main.java.commonObj;

import java.nio.file.Path;

import org.w3c.dom.Document;

public interface commonInterface {
//	public static final List<Path> zipDir = null;
//	public abstract void xmlTransform();

	public abstract void xmlTransform(String mergedDir, Document doc);
	public abstract void recursDel(Path toPath);
}
