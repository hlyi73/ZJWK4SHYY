package com.takshine.marketing.controller;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.List;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.takshine.wxcrm.base.util.FTPUtil;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.Attachment;
import com.takshine.marketing.service.AttachmentService;
import com.takshine.marketing.service.LovService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 附件处理类
 *
 */
@Controller
@RequestMapping("/mkattachment")
public class MkAttachmentController {
	protected static Logger logger = Logger.getLogger(MkAttachmentController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询附件列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("AttachmentController acclist method begin=>");
		String id=request.getParameter("id");
		logger.info("AttachmentController list method currpage =>" + id);
		Activity act = new Activity();
		act.setId(id);
		//List<Attachment> list = attachmentService.getActivityAttachmentList(id);
		List<Attachment> list = cRMService.getDbService().getAttachmentService().getActivityAttachmentListByActId(id);
		request.setAttribute("attachmentList", list);
		request.setAttribute("pczjwk_url", PropertiesUtil.getAppContext("pczjwk.url"));
		return "attachment/list";
	}	

	/**
	 * 异步上传图片
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/upload")
	@ResponseBody
	public String upload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		// 获得文件：
		MultipartFile file = multipartRequest.getFile("uploadFile");
		if (file != null && file.getSize() > 0) {
			logger.info("AttachmentController upload method fileName=" + file.getOriginalFilename());
			String fileName = file.getOriginalFilename();
			try {
				fileName = PropertiesUtil.getAppContext("app.publicId") + "_" + Get32Primarykey.getRandom32BeginTimePK() + ".jpeg";
				// ftp上传
				FTPUtil fu = new FTPUtil();
				FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"), Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")),
						PropertiesUtil.getAppContext("file.marketing.service.uid"), PropertiesUtil.getAppContext("file.marketing.service.pwd"));
				//上传缩略图
				InputStream inputStream = file.getInputStream();
				//上传缩略图
				BufferedImage src = javax.imageio.ImageIO.read(inputStream); //构造Image对象
	        	int width =src.getWidth();
	        	int height = src.getHeight();
	        	if(width>580){
	        		Double d = (new BigDecimal("580").divide(new BigDecimal(width+""),2,BigDecimal.ROUND_DOWN)).doubleValue();
	        		if(d.compareTo(new Double(0))==0){
	        			d = d+1;
	        		}
	        		height =(int)(d*height);
	        		width = 580;
	        	}else if(width>0 && width<580){//2015-04-13修改，图片尺寸暂时取这大小
	        		Double d = (new BigDecimal("320").divide(new BigDecimal(width+""),2,BigDecimal.ROUND_DOWN)).doubleValue();
	        		if(d.compareTo(new Double(0))==0){
	        			d = d+1;
	        		}
	        		height =(int)(d*height);
	        		width = 320;
	        	}
	        	BufferedImage tag = new BufferedImage(width,height,BufferedImage.TYPE_INT_RGB);
	        	tag.getGraphics().drawImage(src,0,0,width,height,null);       //绘制缩小后的图
	        	//将生成的缩略成转换成流
	        	ByteArrayOutputStream bs =new ByteArrayOutputStream();
	        	ImageOutputStream imOut =ImageIO.createImageOutputStream(bs);
	        	ImageIO.write(tag,"jpeg",imOut); //scaledImage1为BufferedImage
	        	InputStream is =new ByteArrayInputStream(bs.toByteArray());
				
				if (fu.uploadFile(ftp, PropertiesUtil.getAppContext("file.marketing.service.userpath"), fileName, is)) {
					fu.closeFTP(ftp);
					logger.info("AttachmentController upload method 上传后文件名！" + fileName);
					return "0" + fileName;
				} else {
					fu.closeFTP(ftp);
					logger.info("AttachmentController upload method -1 上传失败！");
					return null;
				}
			} catch (Exception ex) {
				logger.info("AttachmentController upload method -3 上传失败！" + ex.toString());
				return null;
			}
		} else {
			logger.info("AttachmentController upload method -4 上传失败！");
			return null;
		}
	}
	
	
	/**
	 * 异步上传图片
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/uploadfile")
	@ResponseBody
	public String uploadfile(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		// 获得文件：
		MultipartFile file = multipartRequest.getFile("uploadResource");
		if (file != null && file.getSize() > 0) {
			logger.info("AttachmentController upload method fileName=" + file.getOriginalFilename());
			String relaFileName = file.getOriginalFilename();
			try {
				String fileName = PropertiesUtil.getAppContext("app.publicId") + "_" + Get32Primarykey.getRandom32BeginTimePK() + relaFileName.substring(relaFileName.lastIndexOf("."));
				// ftp上传
				FTPUtil fu = new FTPUtil();
				FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"), Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")),
						PropertiesUtil.getAppContext("file.marketing.service.uid"), PropertiesUtil.getAppContext("file.marketing.service.pwd"));
				//上传
				InputStream inputStream = file.getInputStream();
				
				if (fu.uploadFile(ftp, PropertiesUtil.getAppContext("file.marketing.service.userpath"), fileName, inputStream)) {
					fu.closeFTP(ftp);
					//保存文件
					Attachment att = new Attachment();
					att.setFile_rela_name(fileName);
					att.setFile_name(relaFileName);
					att.setFile_size(file.getBytes().length +"");
					att.setFile_type(relaFileName.substring(relaFileName.lastIndexOf(".")+1));
					att.setRela_id(Get32Primarykey.getRandom32PK());
					att.setId(Get32Primarykey.getRandom32PK());
					att.setActivity_id(id);
					att.setCreateBy(UserUtil.getCurrUser(request).getParty_row_id());
					boolean flag = cRMService.getDbService().getAttachmentService().addAttachment(att);
					
					if(flag){
						logger.info("AttachmentController upload method 上传后文件名！" + fileName);
						return JSONObject.fromObject(att).toString();
					}else{
						return "";
					}
				}
			} catch (Exception ex) {
				logger.info("AttachmentController upload method -3 上传失败！" + ex.toString());
				return "";
			}
		} else {
			logger.info("AttachmentController upload method -4 上传失败！");
			return "";
		}
		return "";
	}
	

	/**
	 * 异步下载图片
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/download")
	@ResponseBody
	public void download(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			String fileName = request.getParameter("fileName");
			String flag = request.getParameter("flag");
			String contentType = "image/jpeg;charset=GBK";
			OutputStream outputStream = response.getOutputStream();
			FTPUtil fu = new FTPUtil();
			FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"), Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")),
					PropertiesUtil.getAppContext("file.marketing.service.uid"), PropertiesUtil.getAppContext("file.marketing.service.pwd"));
			if ("headImage".equals(flag)) {
				fu.downloadFile(ftp, PropertiesUtil.getAppContext("file.marketing.service.userpath"), fileName, outputStream);
			} else if("file".equals(flag)){
				fu.downloadFile(ftp, PropertiesUtil.getAppContext("file.marketing.service.filepath"), fileName, outputStream);
			}else{
				fu.downloadFile(ftp, PropertiesUtil.getAppContext("file.marketing.service.path"), fileName, outputStream);
			}
			response.setContentType(contentType);
			outputStream.flush();
			outputStream.close();
			fu.closeFTP(ftp);
		} catch (Exception ex) {
			logger.info("AttachmentController download method 下载图片失败！" + ex.toString());
		}
	}

	/**
	 * 异步下载图片
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/downloadfile")
	@ResponseBody
	public void downloadfile(HttpServletRequest request, HttpServletResponse response) throws Exception {
			String fileName = request.getParameter("fileName");
			String flag = request.getParameter("flag");
			String type = request.getParameter("type");

			logger.info("type=>" + type);
			try {
				String contentType = type + ";charset=GBK";
			ServletOutputStream outputStream = response.getOutputStream();
			FTPUtil fu = new FTPUtil();
			FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"), Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")),
					PropertiesUtil.getAppContext("file.marketing.service.uid"), PropertiesUtil.getAppContext("file.marketing.service.pwd"));
			if ("headImage".equals(flag)) {
				fu.downloadFile(ftp, PropertiesUtil.getAppContext("file.marketing.service.userpath"), fileName, outputStream);
			} else if("file".equals(flag)){
				fu.downloadFile(ftp, PropertiesUtil.getAppContext("file.marketing.service.filepath"), fileName, outputStream);
			}else{
				fu.downloadFile(ftp, PropertiesUtil.getAppContext("file.marketing.service.path"), fileName, outputStream);
			}
			response.setContentType(contentType);
			response.setCharacterEncoding("utf-8");  
			response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
			response.setContentType(contentType);
			outputStream.flush();
			outputStream.close();
			fu.closeFTP(ftp);
		} catch (Exception ex) {
			logger.info("AttachmentController download method 下载文件失败！" + ex.toString());
		}
		}

		// 获取链接地址文件的byte数据
		private void getUrlFileData(String fileUrl,OutputStream out) throws Exception {
			URL url = new URL(fileUrl);
			HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
			httpConn.connect();
			InputStream cin = httpConn.getInputStream();
			byte[] buffer = new byte[1024];
			int len = 0;
			while ((len = cin.read(buffer)) != -1) {
				out.write(buffer, 0, len);
			}
			cin.close();
		}
}
