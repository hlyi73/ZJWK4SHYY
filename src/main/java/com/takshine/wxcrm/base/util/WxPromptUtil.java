package com.takshine.wxcrm.base.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

public class WxPromptUtil {
	private static Logger logger = Logger.getLogger(WxPromptUtil.class.getName());
	
	/**
	 * 处理正则表达式
	 * @param regEx
	 * @param s
	 * @return
	 */
	public static boolean regExgCompile(String regEx, String s){
		logger.info("regExgCompile regEx ==> " + regEx);
		logger.info("regExgCompile s ==> " + s);
		Pattern pat = Pattern.compile(regEx);  
		Matcher mat = pat.matcher(s);  
		boolean rs = mat.find();
		logger.info("regExgCompile rs ==> " + rs);
		return rs;
	}
	
}
