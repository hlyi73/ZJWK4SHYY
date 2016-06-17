package com.takshine.wxcrm.base.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PropertiesUtil {
	private static PropertiesUtil propertiesUtil = null;


	public static PropertiesUtil getInstance() {
		if (propertiesUtil == null) {
			propertiesUtil = new PropertiesUtil();
		}
		return propertiesUtil;
	}


	public Properties loadProp(String path) {
		Properties props = new Properties();
		InputStream in = PropertiesUtil.class.getResourceAsStream(path);
		try {
			props.load(in);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if(in!=null)
				{
					in.close();
					in = null;
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return props;
	}

	/**
	 * 获取 application 文件的内容
	 * @param key
	 * @return
	 */
	public static String getAppContext(String key){
		Properties prop = PropertiesUtil.getInstance().loadProp("/application.properties");
		String val =  prop.getProperty(key);
		return (val == null) ? "" : val ;
	}
	
	/**
	 * 获取 mailmodule 文件的内容
	 * @param key
	 * @return
	 */
	public static String getMailContext(String key){
		Properties prop = PropertiesUtil.getInstance().loadProp("/mailmodule.properties");
		String val =  prop.getProperty(key);
		return (val == null) ? "" : val ;
	}
	
	/**
	 * 获取 msgmodule 文件的内容
	 * @param key
	 * @return
	 */
	public static String getMsgContext(String key){
		Properties prop = PropertiesUtil.getInstance().loadProp("/sendmessages.properties");
		String val =  prop.getProperty(key);
		return (val == null) ? "" : val ;
	}
}
