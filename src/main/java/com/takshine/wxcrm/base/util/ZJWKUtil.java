package com.takshine.wxcrm.base.util;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.BusinessCard;

public class ZJWKUtil {
	private static Logger log = Logger.getLogger(ZJWKUtil.class.getName());
	
	/**
	 * 获取url
	 * @param request
	 */
	public static void getRequestURL(HttpServletRequest request){
		String shareurl = request.getRequestURL().toString();
		if(StringUtils.isNotBlank(request.getQueryString())){
			shareurl = shareurl + "?" + request.getQueryString();
		}
		log.info("detail out url = >" + shareurl);
		request.setAttribute("shareurl", shareurl);
	}
	
	/**
	 * 根据传入的参数对图片进行处理
	 * @param request
	 * @param map
	 * @return 返回上传后的文件名
	 */
	public static HashMap<String, Object> compressImger(HttpServletRequest request, HashMap<String, Object> map) throws Exception
	{
		//返回map
		HashMap<String, Object> retMap = new HashMap<String, Object>();
		//上传后的文件名
		String fileName = "";
		//输入流，用于ftp上传
		InputStream in = null;
		//图片对象
		Image image = null;
		//是否需要上传，map对象中传入needFtpFlag
		Boolean needFtp = false;
		//是否需要压缩，map对象中传入needCompressFlag
		Boolean needCompress = false;
		//传入的压缩图片自定义大小
		Integer customWidth = Constants.DEFAULT_WIDTH;
		Integer customHeight = Constants.DEFAULT_HEIGHT;
		
		try
		{
			//如果map不为空则针对map中传入的信息分别进行处理
			if (null != map)
			{
				if (null != map.get(Constants.KEY_INPUT_OBJECT_FILE))
				{
					//处理文件
					InputStream is = new FileInputStream((File)map.get(Constants.KEY_INPUT_OBJECT_FILE));
					BufferedImage bi = ImageIO.read(is);
					image = (Image)bi;
				}
				else if (null != map.get(Constants.KEY_INPUT_OBJECT_IMAGE))
				{
					//处理图片
					image = (Image)map.get(Constants.KEY_INPUT_OBJECT_IMAGE);
				}
				else if (null != map.get(Constants.KEY_INPUT_OBJECT_URL))
				{
					//处理url
					//new一个URL对象  
					URL url = new URL((String)map.get(Constants.KEY_INPUT_OBJECT_URL));  
					//打开链接  
					HttpURLConnection conn = (HttpURLConnection)url.openConnection();  
					//设置请求方式为"GET"  
					conn.setRequestMethod("GET");  
					//超时响应时间为5秒  
					conn.setConnectTimeout(5 * 1000);  
					//通过输入流获取图片数据  
					InputStream inStream = conn.getInputStream();  
					
					image = javax.imageio.ImageIO.read(inStream); //构造Image对象
				}
				else
				{
					//处理request里的流
					MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
					// 获得文件：
					MultipartFile file = multipartRequest.getFile("uploadFile");
					
					BufferedImage bi = ImageIO.read(file.getInputStream());
					
					image = (Image)bi;
				}
				
				//获取map中的其他参数
				if (null != map.get(Constants.KEY_NEED_FTP_FLAG))
				{
					needFtp = (Boolean)map.get(Constants.KEY_NEED_FTP_FLAG);
				}
				if (null != map.get(Constants.KEY_NEED_COMPRESS_FLAG))
				{
					needCompress = (Boolean)map.get(Constants.KEY_NEED_COMPRESS_FLAG);
				}
				if (null != map.get(Constants.KEY_IMAGE_WIDTH))
				{
					customWidth = (Integer)map.get(Constants.KEY_IMAGE_WIDTH);
				}
				if (null != map.get(Constants.KEY_IMAGE_HEIGHT))
				{
					customHeight = (Integer)map.get(Constants.KEY_IMAGE_HEIGHT);
				}
			}
			else
			{
				log.error("ZJWKUtil compressImger params check >>>>> map is null.");
				throw new Exception("param check is fault, please check it");
			}

			//压缩
			if (needCompress.booleanValue())
			{
				//获取图片原始大小
				int width = image.getWidth(null);
				int height = image.getHeight(null);
				
				if (width > customWidth) 
				{
					width = customWidth;
				}
				if (height > customHeight) 
				{
					height = customHeight;
				}
				
				Image imageTemp = image.getScaledInstance(width, height,Image.SCALE_SMOOTH);
				image = imageTemp;
			}
			
			//上传
			if (needFtp.booleanValue())
			{
				//将生成的缩略成转换成流
	        	BufferedImage tag = new BufferedImage(customWidth,customHeight,BufferedImage.TYPE_INT_RGB);
	        	tag.getGraphics().drawImage(image,0,0,customWidth,customHeight,null);
	        	ByteArrayOutputStream bs =new ByteArrayOutputStream();
	        	ImageOutputStream imOut =ImageIO.createImageOutputStream(bs);
	        	ImageIO.write(tag,"jpeg",imOut); 
	        	in = new ByteArrayInputStream(bs.toByteArray());
	        	
	        	//将流ftp到服务器
	        	fileName = PropertiesUtil.getAppContext("app.publicId")+"_"+Get32Primarykey.getRandom32BeginTimePK()+".jpeg";
				
	        	//ftp上传
	        	FTPUtil fu = new FTPUtil();  
	        	FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd"));  
	        	if(fu.uploadFile(ftp, PropertiesUtil.getAppContext("file.service.userpath"), fileName, in))
	        	{
	        		fu.closeFTP(ftp);
	        		log.info("ZJWKUtil compressImger 上传后文件名: "+fileName);
	        	}
	        	else
	        	{
	        		fu.closeFTP(ftp);
	        		log.info("ZJWKUtil compressImger 上传失败.");
	        		fileName = "";
	        	}
			}
			
			//设置返回
			retMap.put(Constants.KEY_RETURN_OBJECT_IMAGE, image);
			retMap.put(Constants.KEY_RETURN_OBJECT_FILENAME, fileName);
		}
		catch(Exception ex)
		{
			log.error(ex);
		}
		
		return retMap;
	}
	
	
	/**
	 * 长链接生成短链接
	 * @param url
	 * @return
	 */
	public static String shortUrl(String url) {
	       // 可以自定义生成 MD5 加密字符传前的混合 KEY
	       String key = Constants.SHORT_URL_PREFIX ;
	       // 要使用生成 URL 的字符
	       String[] chars = new String[] { "a" , "b" , "c" , "d" , "e" , "f" , "g" , "h" ,
	              "i" , "j" , "k" , "l" , "m" , "n" , "o" , "p" , "q" , "r" , "s" , "t" ,
	              "u" , "v" , "w" , "x" , "y" , "z" , "0" , "1" , "2" , "3" , "4" , "5" ,
	              "6" , "7" , "8" , "9" , "A" , "B" , "C" , "D" , "E" , "F" , "G" , "H" ,
	              "I" , "J" , "K" , "L" , "M" , "N" , "O" , "P" , "Q" , "R" , "S" , "T" ,
	              "U" , "V" , "W" , "X" , "Y" , "Z"
	 
	       };
	       // 对传入网址进行 MD5 加密
	       String sMD5EncryptResult = MD5Util.digest(key + url);
	       //String sMD5EncryptResult = (new CMyEncrypt()).getMD5OfStr(key + url);
	       String hex = sMD5EncryptResult;
	 
	       String[] resUrl = new String[4];
	       for ( int i = 0; i < 4; i++) {
	 
	           // 把加密字符按照 8 位一组 16 进制与 0x3FFFFFFF 进行位与运算
	           String sTempSubString = hex.substring(i * 8, i * 8 + 8);
	 
	           // 这里需要使用 long 型来转换，因为 Inteper .parseInt() 只能处理 31 位 , 首位为符号位 , 如果不用 long ，则会越界
	           long lHexLong = 0x3FFFFFFF & Long.parseLong (sTempSubString, 16);
	           String outChars = "" ;
	           for ( int j = 0; j < 6; j++) {
	              // 把得到的值与 0x0000003D 进行位与运算，取得字符数组 chars 索引
	              long index = 0x0000003D & lHexLong;
	              // 把取得的字符相加
	              outChars += chars[( int ) index];
	              // 每次循环按位右移 5 位
	              lHexLong = lHexLong >> 5;
	           }
	           // 把字符串存入对应索引的输出数组
	           resUrl[i] = outChars;
	       }
	       //随机取一个
	       int random = (int)(Math.random()*(resUrl.length-1));
	       String shortUrl = resUrl[random];
	       //保存到缓存中
	       RedisCacheUtil.putStringToMap(Constants.SHORT_CACHE_KEY, shortUrl, url);
	       return shortUrl;
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
		for (char element : arr) {
			if (element > 128) {
				try {
					String[] temp = PinyinHelper.toHanyuPinyinStringArray(
							element, defaultFormat);
					if (temp != null) {
						pybf.append(temp[0].charAt(0));
					}
				} catch (BadHanyuPinyinOutputFormatCombination e) {
					e.printStackTrace();
				}
			} else {
				pybf.append(element);
			}
			break;
		}
		return pybf.toString().replaceAll("\\W", "").trim().toUpperCase();
	}
	
	/**
	 * 根据城市获取天气情况
	 * 调用百度接口
	 * @param city
	 * @return
	 */
	public static String getWeatherByCity(String city){
		try{
			city = URLEncoder.encode(city,"UTF-8");
			String requestUrl = "http://api.map.baidu.com/telematics/v3/weather?location="+city+"&output=json&ak=134eca242394acd37ffbae329150e589";
			String retStr = WxUtil.httpRequest(requestUrl);
			//JSONObject resJson = WxUtil.httpsRequest(requestUrl,"GET");
			JSONObject resJson = JSONObject.fromObject(retStr);
			if(null == resJson || !"0".equals(resJson.getString("error"))){
				return "";
			}
			String weather = "";
			JSONObject jo = resJson.getJSONArray("results").getJSONObject(0);
			JSONArray ja1 = jo.getJSONArray("weather_data");
			
			JSONObject obj = (JSONObject)ja1.get(0);
			weather = obj.getString("weather") + "，温度"+obj.getString("temperature")+"，" + obj.getString("wind") +"，";
			obj = (JSONObject)ja1.get(1);
			weather += "预计明天"+ obj.getString("weather") + "，温度"+obj.getString("temperature")+"，" + obj.getString("wind") +"，";
			return weather;
		}catch(Exception e){
			log.error("get Weather error =====" + e.toString());
		}
		return "";
	}
	
	
	/**
	 * 是否在48小时内
	 * @param partyId
	 * @return
	 */
	public static boolean is48HourInner(String partyId){
		Map<String, String> map = RedisCacheUtil.getStringMapAll(Constants.LOGINTIME_KEY + "_"+ partyId);
		String loginTime = (String) map.get("loginTime");
		String differtime = 172800000 + "";// 48小时
		if (com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(loginTime)&& DateTime.comDate(loginTime, differtime,DateTime.DateTimeFormat1)) {
			return false;
		}
		return true;
	}
	
	/**
	 * 判断是否是手机端访问
	 * @param request
	 * @return
	 */
	public static boolean isMobileAccess(HttpServletRequest request){
		String userAgent = request.getHeader("User-Agent");
		log.info("userAgent =>" + userAgent);
		if(userAgent.contains("MicroMessenger")){
			log.info("userAgent contains MicroMessenger=> ");
			return true;
		}else{
			return false;
		}
	}
}
