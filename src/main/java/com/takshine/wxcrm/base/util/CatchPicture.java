package com.takshine.wxcrm.base.util;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.domain.MessagesExt;
import com.takshine.wxcrm.domain.Resource;

public class CatchPicture {  
	
	protected static Logger logger = Logger.getLogger(CatchPicture.class.getName());
	
	// 地址  
    private static final String URL = "http://mp.weixin.qq.com/s?__biz=MzA5NTE3MzYxMA==&mid=10012184&idx=1&sn=36386ba2d7488b0eff76575fca3b6c04&scene=4#rd";  
    // 编码  
    private static final String ECODING = "UTF-8";  
    // 获取img标签正则  
    private static final String IMGURL_REG = "http:\"?(.*?)(\"|>|\\s+)";//"<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>"; //"<img.*src=(.*?)[^>]*?>";  
    // 获取src路径的正则  
    private static final String IMGSRC_REG = "http:\"?(.*?)(\"|>|\\s+)"; 
    
	public static void main(String[] args) throws Exception {
		// 获得html文本内容
		String HTML = getHTML(URL);
		// 获取图片标签
		List<String> imgUrl = getImageUrl(HTML);
		// 获取图片src地址
		List<String> imgSrc = getImageSrc(imgUrl);
		// 下载图片
		download(imgSrc);
	}
    
    
    public static void initResourceImg(CRMService cRMService) throws Exception {  
    	Resource res = new Resource();
    	res.setResourceType(WxMsgUtil.REQ_MESSAGE_TYPE_LINK);
    	List<Resource> resList = cRMService.getDbService().getResourceService().findResourceListByFilter(res);
    	for(int i=0;i<resList.size();i++){
    		res = resList.get(i);
    		if(!StringUtils.isNotNullOrEmptyStr(res.getResourceUrl())){
    			continue;
    		}
    		logger.info("CatchPicture initResourceImg method url ===" + res.getResourceUrl());
	        //获得html文本内容  
	        //String HTML = getHTML(URL);  
    		String HTML = getHTML(res.getResourceUrl());  
	        //获取图片标签  
	        List<String> imgUrl = getImageUrl(HTML);  
	        //获取图片src地址  
	        List<String> imgSrc = getImageSrc(imgUrl);  
	        //下载图片  
	        String fileName = download(imgSrc); 
	        
	        logger.info("----------ResourceServiceImpl --- addResource --- download img src===" + imgSrc);
			if(StringUtils.isNotNullOrEmptyStr(fileName)){
				MessagesExt me = new MessagesExt();
				me.setId(Get32Primarykey.getRandom32PK());
				me.setFilename(fileName);
				me.setSource_filename(res.getResourceUrl());
				me.setRelaid(res.getResourceId());
				me.setFiletype("img");
				me.setRelatype("Resource");
				cRMService.getDbService().getMessagesExtService().addObj(me);
				logger.info("----------ResourceServiceImpl --- addResource --- add link img ");
			}
    	}
    }
    
    /**
     * 获取外部链接中的图片，并上传到本地服务器，返回上传后的文件名
     * @param url
     * @return
     * @throws Exception
     */
    public static String getResourceImage(String url) throws Exception{
    	 //获得html文本内容  
        String HTML = getHTML(url);  
        //获取图片标签  
        List<String> imgUrl = getImageUrl(HTML);  
        //获取图片src地址  
        List<String> imgSrc = getImageSrc(imgUrl);  
        //下载图片  
        return download(imgSrc); 
    }
    
    /**
     * 根据内容获取图片
     * @param url
     * @return
     * @throws Exception
     */
    public static String getResourceImageByContent(String content) throws Exception{
   	 //获得html文本内容  
       String HTML = content;
       //获取图片标签  
       List<String> imgUrl = getImageUrl(HTML);  
       //获取图片src地址  
       List<String> imgSrc = getImageSrc(imgUrl);  
       //下载图片  
       return download(imgSrc); 
   }
      
    /*** 
     * 获取HTML内容 
     *  
     * @param url 
     * @return 
     * @throws Exception 
     */  
    private static String getHTML(String url) throws Exception {  
        URL uri = new URL(url);  
        URLConnection connection = uri.openConnection();  
        InputStream in = connection.getInputStream();  
        byte[] buf = new byte[1024];  
        int length = 0;  
        StringBuffer sb = new StringBuffer();  
        while ((length = in.read(buf, 0, buf.length)) > 0) {  
            sb.append(new String(buf, ECODING));  
        }  
        in.close();  
        return sb.toString();  
    }  
  
    /*** 
     * 获取ImageUrl地址 
     *  
     * @param HTML 
     * @return 
     */  
    private static List<String> getImageUrl(String HTML) {  
        Matcher matcher = Pattern.compile(IMGURL_REG).matcher(HTML);  
        List<String> listImgUrl = new ArrayList<String>();  
        while (matcher.find()) {  
            listImgUrl.add(matcher.group());  
        }  
        return listImgUrl;  
    }  
  
    /*** 
     * 获取ImageSrc地址 
     *  
     * @param listImageUrl 
     * @return 
     */  
    private static List<String> getImageSrc(List<String> listImageUrl) {  
        List<String> listImgSrc = new ArrayList<String>();  
        for (String image : listImageUrl) {  
            Matcher matcher = Pattern.compile(IMGSRC_REG).matcher(image);  
            while (matcher.find()) {  
            	String url = matcher.group().substring(0, matcher.group().length() - 1);
            	if(url.indexOf(".js") != -1 || url.indexOf(".css") != -1 || url.indexOf(".swf") != -1 || url.indexOf(".html") != -1
            	 ||url.indexOf(".jsp") != -1 || url.indexOf(".xls") != -1 || url.indexOf(".xlsx") != -1 || url.indexOf(".doc") != -1
            	 ||url.indexOf(".docx") != -1 || url.indexOf(".ppt") != -1 || url.indexOf(".pptx") != -1 || url.indexOf(".ico") != -1){
            		continue;
            	}
                listImgSrc.add(url);  
            }  
        }  
        return listImgSrc;  
    }  
  
    /*** 
     * 下载图片 
     *  
     * @param listImgSrc 
     */  
    private static String download(List<String> listImgSrc) {  
    	InputStream in = null;
        try {  
        	String fileName = null;
        	boolean isLocal = false;
        	byte[] data = new byte[1024];
            for (String url : listImgSrc) { 
            	if(url.indexOf("/ZJWK/mkattachment/download?") != -1){
            		isLocal = true;
            		url = "http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.marketing.service.userpath").replace("/usr", "").replace("/zjftp","")+"/" +url.substring(url.indexOf("fileName=")+9,url.lastIndexOf("&"));
            	}
            	
            	logger.info("CatchPicture download method url ===" + url);
            	data = WxUtil.httpsRequestImage(url);
            	if(null == data){
            		continue;
            	}
            	if(url.indexOf(".png") == -1 && url.indexOf(".jpg") == -1 && url.indexOf(".gif") == -1
            		&& url.indexOf(".PNG") == -1 && url.indexOf(".JPG") == -1 && url.indexOf(".GIF") == -1  && url.indexOf(".jpeg") == -1){
            		BufferedImage src = javax.imageio.ImageIO.read(new ByteArrayInputStream(data));
            		if(src == null){
            			 logger.info("CatchPicture download method url === 此文件不为图片文件");
            			 System.out.println("此文件不为图片文件");
            			 continue;
            		}
            	}
            	
            	if((data.length < (150*150) || data.length > (1000 * 1000)) && !isLocal){
            		continue;
            	}
            	logger.info("CatchPicture download method url 符合要求的 ===" + url);
            	
                //ByteArrayInputStream is = new ByteArrayInputStream(data);  
                
                Image src = javax.imageio.ImageIO.read(new ByteArrayInputStream(data)); //构造Image对象
              //按比例压缩图片
				int width = src.getWidth(null);
				int height = src.getHeight(null);
				if (96 >= width) {
					if (96 < height) {
						width = (int) (width * 96 / height);
						height = 96;
					}
				} else {
					if (96 >= height) {
						height = (int) (height * 96 / width);
						width = 96;
					} else {
						if (height > width) {
							width = (int) (width * 96 / height);
							height = 96;
						} else {
							height = (int) (height * 96 / width);
							width = 96;
						}
					}
				}
       		
                BufferedImage tag = new BufferedImage(96,96,BufferedImage.TYPE_INT_RGB);
            	tag.getGraphics().drawImage(src,0,0,96,96,null);       //绘制缩小后的图
            	//将生成的缩略成转换成流
            	ByteArrayOutputStream bs =new ByteArrayOutputStream();
            	ImageOutputStream imOut =ImageIO.createImageOutputStream(bs);
            	ImageIO.write(tag,"jpeg",imOut); 
            	InputStream iss =new ByteArrayInputStream(bs.toByteArray());
                
                fileName = "resource_"+PropertiesUtil.getAppContext("app.publicId")+"_"+Get32Primarykey.getRandom32PK()+"_"+".jpeg";
                
                FTPUtil fu = new FTPUtil();  
            	FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd"));  
            	
            	if(fu.uploadFile(ftp, PropertiesUtil.getAppContext("file.service.userpath"), fileName, iss)){
            		fu.closeFTP(ftp);
            	}else{
            		fu.closeFTP(ftp);
            		logger.info("CatchPicture download method -1 上传图片失败！");
            		fileName = null;
            	}
                break;
            } 
            return fileName;
        } catch (Exception e) {  
        	logger.error("CatchPicture download  下载资源图片失败！");
        } finally{
        	try {
        		if(null != in)	in.close();  
			} catch (IOException e) {
				logger.error("CatchPicture download  下载资源图片关闭流失败！");
			} 
        }
        
        return null;
    }  
}  