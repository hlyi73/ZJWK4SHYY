package com.takshine.wxcrm.controller;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.util.FTPUtil;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.OSSUtil;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.domain.MessagesExt;

/**
 * 资料 页面控制器
 * 
 * 
 */
@Controller
@RequestMapping("/files")
public class FilesController
{
	// 日志
	protected static Logger logger = Logger.getLogger(FilesController.class
			.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 从策信服务器下载文件
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/down4wx")
	@ResponseBody
	public String down4wx(HttpServletRequest request,
			HttpServletResponse response) throws Exception 
	{
		logger.info("FilesController-->in down4wx");
		String serverids = request.getParameter("serverids");
		String filetype = request.getParameter("filetype");
		String relaid = request.getParameter("relaid");
		String relatype = request.getParameter("relatype");
		logger.info("FilesController-->serverids == " + serverids);
		logger.info("FilesController-->filetype == " + filetype);
		logger.info("FilesController-->relaid == " + relaid);
		logger.info("FilesController-->relatype == " + relatype);
		//如果上传是图片信息
		if("img".equals(filetype)){
			//下载图片信息
			if(StringUtils.isNotNullOrEmptyStr(serverids)){
				String[] serids = serverids.split(",");
				for (String serid : serids) {
					String filename = downloadWXImgToOss(serid);
					logger.info("-------------filename-------"+filename);
					MessagesExt me = new MessagesExt();
					me.setFilename(filename);
					me.setSource_filename(filename);
					me.setRelaid(relaid);
					me.setFiletype(filetype);
					me.setRelatype(relatype);
					
					cRMService.getDbService().getMessagesExtService().addObj(me);
				}
			}else{
				return "nodata";
			}
		}else{
			return "unknown";
		}
		logger.info("FilesController-->out down4wx");
		return "success";
	}
	
	
	@RequestMapping("/down4wxToOss")
	@ResponseBody
	public String down4wxToOss(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("FilesController-->in down4wxToOss");
		String serverids = request.getParameter("serverids");
		String filetype = request.getParameter("filetype");
		String relaid = request.getParameter("relaid");
		String relatype = request.getParameter("relatype");
		logger.info("FilesController-->serverids == " + serverids);
		logger.info("FilesController-->filetype == " + filetype);
		logger.info("FilesController-->relaid == " + relaid);
		logger.info("FilesController-->relatype == " + relatype);
		//如果上传是图片信息
		String filename="";
		if("img".equals(filetype)){
			//下载图片信息
			if(StringUtils.isNotNullOrEmptyStr(serverids)){
				serverids =serverids.replaceAll("'", "");
				String[] serids = serverids.split(",");
				for (String serid : serids) {
					filename += downloadWXImgToOss(serid)+",";
					logger.info("-------------filename-------"+filename);
				}
			}else{
				return "unknown";
			}
		}else{
			return "unknown";
		}
		logger.info("FilesController-->out down4wx");
		return filename;
	}
	
	
	/**
	 * 从策信服务器下载文件
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/calendarDown4wx")
	@ResponseBody
	public String calendarDown4wx(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("FilesController-->in down4wx");
		String serverids = request.getParameter("serverids");
		String filetype = request.getParameter("filetype");
		String relaid = request.getParameter("relaid");
		String relatype = request.getParameter("relatype");
		logger.info("FilesController-->serverids == " + serverids);
		logger.info("FilesController-->filetype == " + filetype);
		logger.info("FilesController-->relaid == " + relaid);
		logger.info("FilesController-->relatype == " + relatype);
		//如果上传是图片信息
		if("img".equals(filetype)){
			//下载图片信息
			if(StringUtils.isNotNullOrEmptyStr(serverids)){
				String[] serids = serverids.split(",");
				String filename=null;
				int i=0;
				for (String serid : serids) {
					if(StringUtils.isNotNullOrEmptyStr(serid)){
						if(serid.indexOf("source")==-1){
							filename = downloadWXImgToOss(serid);
						}else{
							filename =serid;
						}
					}
					
					logger.info("-------------filename-------"+filename);
					MessagesExt me = new MessagesExt();
					me.setFilename(filename);
					me.setSource_filename(filename);
					me.setRelaid(relaid);
					me.setFiletype(filetype);
					me.setRelatype(relatype);
					if(i==0){
						cRMService.getDbService().getMessagesExtService().delMessagesExt(me);
					}
					i++;
					cRMService.getDbService().getMessagesExtService().addObj(me);
				}
			}else{
				return "nodata";
			}
		}else{
			return "unknown";
		}
		logger.info("FilesController-->out down4wx");
		return "success";
	}
	
	/**
	 * 从微信上下载图片
	 * @param serverId
	 * @return
	 */
	private String downloadWXImg (String serverId) throws Exception{
		byte[] data = WxUtil.downloadMedia(serverId);
		ByteArrayInputStream is = new ByteArrayInputStream(data);  
		String pre_filename = PropertiesUtil.getAppContext("app.publicId")+"_"+Get32Primarykey.getRandom32PK();
		//上传到FTP服务器
		String fileName = "source_"+pre_filename+"_wx.jpeg";
		FTPUtil fu = new FTPUtil();  
    	FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd"));  
    	if(fu.uploadFile(ftp, PropertiesUtil.getAppContext("file.service.userpath"), fileName, is)){
    		fu.closeFTP(ftp);
    		Image src = javax.imageio.ImageIO.read(new ByteArrayInputStream(data)); //构造Image对象
    		/*
    		//按比例压缩图片
    		 int width = src.getWidth(null);
    	     int height = src.getHeight(null);
    	     if (96 >= width) 
    	     {
    	         if (96 < height) 
    	         {
    	        	 width = (int) (width * 96 / height);
    	        	 height = 96;
    	         }
    	     }
    	     else
    	     {
    	         if (96 >= height)
    	         {
    	        	 height = (int) (height * 96 / width);
    	        	 width = 96;
    	         } 
    	         else
    	         {
    	        	 if (height > width) 
    	        	 {
    	        		 width = (int) (width * 96 / height);
    	        		 height = 96;
    	        	 }
    	        	 else
    	        	 {
    	        		 height = (int) (height * 96 / width);
    	        		 width = 96;
    	        	 }
    	         }
    	      }
    		//end
*/    		
        	BufferedImage tag = new BufferedImage(96,96,BufferedImage.TYPE_INT_RGB);
        	tag.getGraphics().drawImage(src,0,0,96,96,null);       //绘制缩小后的图
        	//将生成的缩略成转换成流
        	ByteArrayOutputStream bs =new ByteArrayOutputStream();
        	ImageOutputStream imOut =ImageIO.createImageOutputStream(bs);
        	ImageIO.write(tag,"jpeg",imOut); 
        	InputStream iss =new ByteArrayInputStream(bs.toByteArray());
    		fileName = pre_filename+"_wx.jpeg";
    		
    		ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd"));  
    		fu.uploadFile(ftp, PropertiesUtil.getAppContext("file.service.userpath"), fileName, iss);
    		
    		fu.closeFTP(ftp);
    		
    		return fileName;
    	}else{
    		fu.closeFTP(ftp);
    		logger.info("ContactController upload method -1 上传失败！");
    		return null;
    	}
	} 
	
	private String downloadWXImgToOss (String serverId) throws Exception{
		byte[] data = WxUtil.downloadMedia(serverId);
		InputStream is = new ByteArrayInputStream(data);
		String pre_filename = PropertiesUtil.getAppContext("app.publicId")+"_"+Get32Primarykey.getRandom32PK();
		String fileName = "source_"+pre_filename+"_wx.jpeg";
		String key = OSSUtil.uploadFile(OSSUtil.BUCKET_PIC,fileName,is);
		if (StringUtils.isNotNullOrEmptyStr(key)){
			logger.info("downloadWXImgToOss 上传成功 : 文件名--> "+fileName);
			return  key;
		}else {
			logger.info("downloadWXImgToOss 上传失败！ -1 ");
			return null;
		}
	}
	
}
