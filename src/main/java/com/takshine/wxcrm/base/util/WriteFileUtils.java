package com.takshine.wxcrm.base.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.Map;

public class WriteFileUtils {
	public static final String TEST_FILE = "c:\\log.txt";
	protected static final Map<String,FileOutputStream> mapcache = new java.util.concurrent.ConcurrentHashMap<String,FileOutputStream>();
	
	public static final FileOutputStream getFileOutputStream(String file) throws FileNotFoundException{
		if (mapcache.containsKey(file)) return mapcache.get(file);
		FileOutputStream os = getFileOutputStreamRaw(file);
		mapcache.put(file, os);
		return os;
	}
	private static final FileOutputStream getFileOutputStreamRaw(String file) throws FileNotFoundException{
		return new FileOutputStream(new File(file));
	}
	public static final void writeFile(String file,String content){
		try {
			getFileOutputStream(file).write(content.getBytes());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public static final void writeFileLn(String file,String content){
		writeFile(file,content + "\r\n");
	}
	public static final void writeFile(String content){
		WriteFileUtils.writeFile(TEST_FILE, content);
	}
	public static final void writeFileLn(String content){
		WriteFileUtils.writeFileLn(TEST_FILE, content);
	}
	
	public static void main(String[] args) throws Exception {
		writeFileLn("Test中文");
	}

}
