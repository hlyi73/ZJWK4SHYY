package com.takshine.wxcrm.base.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;

import org.apache.log4j.Logger;


/**
 * 字符串处理类
 * @author dengbo
 *
 */
public class StringUtils {
	
	private static Logger log = Logger.getLogger(StringUtils.class.getName());
	
	/***
	 * 随机产生32位16进制字符串
	 * @return
	 */
	public static String getRandom32PK(){
		return UUID.randomUUID().toString().replaceAll("-", "");
	} 
	
	/**
	 * 替换字符串中的逗号
	 * @param str
	 * @return
	 */
	public static String replaceStr(String str){
		if(str==null||"".equals(str)){
			str="0";
		}
		if(str.contains(",")){
			str = str.replace(",", "");
		}
		return str;
	}
	
	/**
	 * 判断字符串是否为空或者空字符串
	 * @param str
	 * @return
	 */
	public static boolean isNotNullOrEmptyStr(String str){
		if(str == null || "".equals(str)){
			return false;
		}else if("null".equals(str)){
			return false;
		}else{
			return true;
		}
	}
	
	/**
	 * 判断str是否为null或空字符串，若是，则返回空字符串，否则返回str.trim()。
	 * @param str
	 * @return
	 */
	public static String objToStr(String str){
		if(str == null || "".equals(str)){
			return "";
		}else{
			return str.trim();
		}
	}
	
	/**
	 * 替换用科学计算法显示的数据
	 * @param str
	 * @return
	 */
	public static String repStr(String str){
		BigDecimal bigDecimal = new BigDecimal(str);
		DecimalFormat df = new DecimalFormat("0.00");
		return df.format(bigDecimal);
	}
	
	/**
	 * 字符串转换成金额的一般表示方法
	 * @param str
	 * @return
	 */
	public static String repAmount(String str){
		BigDecimal bigDecimal1 = new BigDecimal(str);
		BigDecimal bigDecimal2 = new BigDecimal(10000);
//		DecimalFormat df = new DecimalFormat("###,###,###0.00");
		bigDecimal1=bigDecimal1.divide(bigDecimal2);
//		return df.format(bigDecimal1);
		return bigDecimal1.toString();
	}
	
	/**
	 * 金额相加
	 * @param str1
	 * @param str2
	 * @return
	 */
	public static String addAmount(String str1,String str2){
		if(isNotNullOrEmptyStr(str1)&&str1.contains(",")){
			str1 = str1.replaceAll(",", "");
		}
		if(isNotNullOrEmptyStr(str2)&&str2.contains(",")){
			str2 = str2.replaceAll(",", "");
		}
		BigDecimal bigDecimal1 = new BigDecimal(str1);
		BigDecimal bigDecimal2 = new BigDecimal(str2);
		bigDecimal1=bigDecimal1.add(bigDecimal2);
		return bigDecimal1.toString();
	}
	
	
	/**
	 * 金额相除并转换成百分比形式
	 * @param str1
	 * @param str2
	 * @param scale
	 * @return
	 */
	public static String divAmount(String str1,String str2,int scale){
		BigDecimal bigDecimal1 = new BigDecimal(str1);
		BigDecimal bigDecimal2 = new BigDecimal(str2);
		double d = (bigDecimal1.divide(bigDecimal2,scale,BigDecimal.ROUND_HALF_UP).doubleValue());
//		NumberFormat nFromat = NumberFormat.getPercentInstance();
//		String rates = nFromat.format(d);
		DecimalFormat df = new DecimalFormat("0.00%");
		String r="";
		if(isNotNullOrEmptyStr(d+"")){
			r = df.format(d);
		}
		return isNotNullOrEmptyStr(r)?r:"0.00%";
	}
	
	/**
	 * 金额的差额
	 * @param str
	 * @return
	 */
	public static String getMargin(String str1,String str2){
		if(isNotNullOrEmptyStr(str1)&&str1.contains(",")){
			str1 = str1.replaceAll(",", "");
		}
		if(isNotNullOrEmptyStr(str2)&&str2.contains(",")){
			str2 = str2.replaceAll(",", "");
		}
		BigDecimal bigDecimal1 = new BigDecimal(str1);
		BigDecimal bigDecimal2 = new BigDecimal(str2);
//		DecimalFormat df = new DecimalFormat("###,###,###0.00");
		bigDecimal1=bigDecimal1.subtract(bigDecimal2);
//		return df.format(bigDecimal1);
		return bigDecimal1.toString();
	}
	
	/**
	 * 把金额用千分位显示
	 * @param str
	 * @return
	 */
	public static String showAmount(String str){
		BigDecimal bigDecimal1 = new BigDecimal(str);
		DecimalFormat df = new DecimalFormat("###,###,###,###.00");
		return df.format(bigDecimal1);
	}
	
	/**
	 * 正则表达式获取连个值之间的值
	 * @param b
	 * @param e
	 * @param c
	 * @return
	 */
	public static String getRankVal(String b, String e, String c){
		log.info("getRankVal b :=>" + b);
		log.info("getRankVal e :=>" + e);
		log.info("getRankVal c :=>" + c);
		
		Pattern psrjc = Pattern.compile("(?<=" + b + "=)[\\w|-]+(?=" + e + ")");
	    Matcher msrjc = psrjc.matcher(c);
	    if(msrjc.find()){
	    	log.info("getRankVal msrjc.find() true ");
	    	String srjc =  msrjc.group(0);
	    	log.info("getRankVal srjc :=> " + srjc);
	        return srjc.trim();
	    }
	    return "";
	}
	
	/**
	 * 把得到的输入流写到指定目录中保存
	 * @param is
	 * @param path
	 * @throws Exception
	 */
	public static String writePic(InputStream is,String path,String type) throws Exception{
		String filename = Get32Primarykey.getRandom32BeginTimePK()+type;
		File file = new File(path+filename);
		File fileParent = new File(file.getParent());
		if(!fileParent.exists()){
			fileParent.mkdirs();
		}
		FileOutputStream fos = new FileOutputStream(file);
		byte[] b = new byte[is.available()];
		int len = 0;
		while((len=is.read(b))!=-1){
			fos.write(b, 0, len);
		}
		fos.close();
		return filename;
	}
	
	/**
	 * 匹配中文
	 * @param str
	 * @return
	 */
	public static boolean regZh(String str){
		String reg = "[\u4E00-\u9FA5]+";
		Pattern p = Pattern.compile(reg); 
		Matcher m = p.matcher(str);
		if(m.find()){
			return true;
		}
		return false;	
	}
	/**
	 * 字符串数组 转 字符串 
	 * @param arr
	 * @return
	 */
	public static String arrToStr(String [] arr){
		StringBuffer sb = new StringBuffer();
		for(int i = 0; i < arr.length; i++){
		 sb. append(arr[i]);
		}
		return sb.toString();
	}
	
	/**
	 * 获取首字母
	 * @param chinese
	 * @return
	 */
	public static String getFirstSpell(String chinese) {
		StringBuffer pybf = new StringBuffer();
		char[] arr = chinese.toCharArray();
		HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();
		defaultFormat.setCaseType(HanyuPinyinCaseType.LOWERCASE);
		defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
		for (int i = 0; i < arr.length; i++) {
			if (arr[i] > 128) {
				try {
					String[] temp = PinyinHelper.toHanyuPinyinStringArray(
							arr[i], defaultFormat);
					if (temp != null) {
						pybf.append(temp[0].charAt(0));
					}
				} catch (BadHanyuPinyinOutputFormatCombination e) {
					e.printStackTrace();
				}
			} else {
				pybf.append(arr[i]);
			}
			break;
		}
		return pybf.toString().replaceAll("\\W", "").trim().toUpperCase();
	}
	
	public static void main(String[] args) {
		List<String> list = new ArrayList<String>();
		list.add("a");
		list.add("b");
		list.add("a");
		list.add("c");
		list.add("d");
		list.add("a");
		list.add("1");
		list.add("2");
		list.add("1");
		List<String> sortedList = new ArrayList<String>(new LinkedHashSet<String>(list));
		for(String str : sortedList){
			System.out.println(str);
		}
	}
	
	public static final String inputStream2String(InputStream is) throws IOException{
		StringBuffer sb = new StringBuffer();
		InputStreamReader reader = new InputStreamReader(
				is, "utf-8");
		char[] buff = new char[1024];
		int length = 0;
		while ((length = reader.read(buff)) != -1) {
			sb.append(new String(buff, 0, length));
		}
		return sb.toString();
	}
	
	
	private static boolean isChinese(char c) {  
        Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);  
        if (ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS  
                || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS  
                || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A  
                || ub == Character.UnicodeBlock.GENERAL_PUNCTUATION  
                || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION  
                || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS) {  
            return true;  
        }  
        return false;  
    } 
	
	
	public static boolean isMessyCode(String strName) {  
        Pattern p = Pattern.compile("\\s*|\t*|\r*|\n*");  
        Matcher m = p.matcher(strName);  
        String after = m.replaceAll("");  
        String temp = after.replaceAll("\\p{P}", "");  
        char[] ch = temp.trim().toCharArray();  
        float chLength = 0 ;  
        float count = 0;  
        for (int i = 0; i < ch.length; i++) {  
            char c = ch[i];  
            if (!Character.isLetterOrDigit(c)) {  
                if (!isChinese(c)) {  
                    count = count + 1;  
                }  
                chLength++;   
            }  
        }  
        float result = count / chLength ;  
        if (result > 0.4) {  
            return true;  
        } else {  
            return false;  
        }  
    }  
      
    
}
