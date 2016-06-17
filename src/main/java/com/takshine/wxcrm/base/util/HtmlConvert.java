package com.takshine.wxcrm.base.util;

import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

import org.apache.poi.poifs.filesystem.DirectoryEntry;
import org.apache.poi.poifs.filesystem.DocumentEntry;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

public class HtmlConvert {
	public static boolean writeWordFile(String urlstr,String pathfile) throws Exception {
		boolean w = false;
		URL url = new URL(urlstr);
		URLConnection uc = url.openConnection();
		InputStream is = uc.getInputStream();
		try{
			// 检查目录是否存在
			POIFSFileSystem poifs = new POIFSFileSystem();
			DirectoryEntry directory = poifs.getRoot();
			DocumentEntry documentEntry = directory.createDocument("WordDocument", is);
			FileOutputStream ostream = new FileOutputStream(pathfile);
			try{
				poifs.writeFilesystem(ostream);
			}finally{
				ostream.close();
			}
		}finally{
			is.close();
		}
		return w;
	}

	public static void main(String arg[]) {
		try {
			writeWordFile("http://www.sina.com.cn","d:\\a.doc");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
