package com.takshine.wxcrm.controller;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.takshine.wxcrm.base.util.FTPUtil;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;

/**
 * 消息发送中文件共享 页面控制器
 * 
 * @author [liulin Date:2014-09-19]
 * 
 */
@Controller
@RequestMapping("/sharefiles")
public class ShareFilesController {
	// 日志
	protected static Logger logger = Logger.getLogger(ShareFilesController.class.getName());

	private static List<String> ftFilesList = new ArrayList<String>();

	static {
		ftFilesList.add(".gif");
		ftFilesList.add(".x-png");
		ftFilesList.add(".x-ms-bmp");
		ftFilesList.add(".bmp");
		ftFilesList.add(".jpeg");
		ftFilesList.add(".png");
		ftFilesList.add(".jpg");
	}

	/*
	@RequestMapping(value = "/upload2", method = RequestMethod.POST) 
	@ResponseBody 
	public String upLoad2(HttpServletRequest request,HttpServletResponse response) throws IOException,InterruptedException, FileUploadException { 
		request.setCharacterEncoding("utf-8"); // String fileName = request.getParameter("fileName"); 
		String fileName = request.getHeader("fileName"); 
		String fname = null; 
		System.out.println(request.getHeader("User-Agent")); 
		if (request.getHeader("User-Agent").toLowerCase().indexOf("firefox") > 0) { 
			fname = new String(fileName.getBytes("ISO8859-1"), "UTF-8"); // firefox浏览器 } 
		}else if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) { 
			fname = URLEncoder.encode(fileName, "UTF-8");// IE浏览器 } 
		}else if (request.getHeader("User-Agent").toUpperCase().indexOf("CHROME") > 0) { 
			fname = new String(fileName.getBytes("iso-8859-1"), "utf-8");// 谷歌 
		}else{
			fname = new String(fileName.getBytes("ISO8859-1"), "UTF-8");
		}

		logger.info("ShareFilesController upload2 fileName=" + fname);
		ServletInputStream inputStream = request.getInputStream(); 
		
		// ftp上传
		FTPUtil fu = new FTPUtil();
		// 配置数据
		String ip = PropertiesUtil.getAppContext("file.service");
		Integer port = Integer.parseInt(PropertiesUtil.getAppContext("file.service.port"));
		String uid = PropertiesUtil.getAppContext("file.service.uid");
		String pwd = PropertiesUtil.getAppContext("file.service.pwd");
		
		String spath = PropertiesUtil.getAppContext("file.service.path");
		logger.info("ShareFilesController upload2 path=" + spath);
		// ftp客户端
		FTPClient ftp = fu.getConnectionFTP(ip, port, uid, pwd);
		if (fu.uploadFile(ftp, spath, fname, inputStream)) {
			logger.info("ShareFilesController upload2 上传成功");
			return "ok";
		}
		logger.info("ShareFilesController upload2 上传失败");
		return null; 
	}
	*/
	
	/**
	 * 异步上传图片
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/upload2", method = RequestMethod.POST)
	@ResponseBody
	public String upload2(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 获得文件：
		String fileName = request.getHeader("fileName"); 
		if (fileName!=null) {
			//fileName = new String(fileName.getBytes("ISO8859-1"), "UTF-8");
			fileName = URLEncoder.encode(fileName, "UTF-8");
			logger.info("ContactController upload method fileName=" + fileName);
			String fileFst = fileName.substring(0, fileName.lastIndexOf("."));
			String fileType = fileName.substring(fileName.lastIndexOf("."));
			String fileDir = "";
			String fileBigType = "";
			ServletInputStream srcInputStream = request.getInputStream(); 
			try {
				logger.info("ContactController upload method 图片压缩=" + fileName);
				InputStream is = null;
				InputStream inputStream = null;
				inputStream = uploadImgagFile(null, srcInputStream);
				is = uploadImgFile(null, inputStream);
				
				// 重新命名
				fileName = PropertiesUtil.getAppContext("app.publicId") + "_" + Get32Primarykey.getRandom32BeginTimePK() + ".jpeg";
				logger.info("ContactController upload method new filename=" + fileName);
				fileBigType = "img";
				fileFst = fileName;
				/*
				if (ftFilesList.contains(fileType)) {
					inputStream = uploadImgagFile(null, srcInputStream);
					is = uploadImgFile(null, inputStream);
					
					// 重新命名
					fileName = PropertiesUtil.getAppContext("app.publicId") + "_" + Get32Primarykey.getRandom32BeginTimePK() + ".jpeg";
					fileBigType = "img";
				} else {
					return null;
				}
				*/

				// ftp上传
				FTPUtil fu = new FTPUtil();
				// 配置数据
				String ip = PropertiesUtil.getAppContext("file.service");
				Integer port = Integer.parseInt(PropertiesUtil.getAppContext("file.service.port"));
				String uid = PropertiesUtil.getAppContext("file.service.uid");
				String pwd = PropertiesUtil.getAppContext("file.service.pwd");
				String path = PropertiesUtil.getAppContext("file.service.path");
				if (!"".equals(fileDir)) {
					path += fileDir + "/";
				}

				// ftp客户端
				FTPClient ftp = fu.getConnectionFTP(ip, port, uid, pwd);
				if (fu.uploadFile(ftp, path, fileName, is)) {
					fu.closeFTP(ftp);
					if ("img".equals(fileBigType)) {
						ftp = fu.getConnectionFTP(ip, port, uid, pwd);
						if (fu.uploadFile(ftp, path, "source_" + fileName, inputStream)) {
							logger.info("ContactController upload method 上传后文件名！" + fileName + "_souce");
						}
						fu.closeFTP(ftp);
					}
					logger.info("ContactController upload method 上传后文件名！" + fileName);
					return URLEncoder.encode("0" + fileName + "@@@" + fileFst + fileType + "@@@" + fileBigType, "UTF-8");

				} else {
					fu.closeFTP(ftp);
					logger.info("ContactController upload method -1 上传失败！");
					return null;

				}

			} catch (Exception ex) {
				logger.info("ContactController upload method -3 上传失败！" + ex.toString());
				return null;
			}

		} else {
			logger.info("ContactController upload method -4 上传失败！");
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
	@RequestMapping(value = "/upload")
	@ResponseBody
	public String upload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		// 获得文件：
		MultipartFile file = multipartRequest.getFile("uploadFile");
		if (file != null && file.getSize() > 0) {
			logger.info("ContactController upload method fileName=" + file.getOriginalFilename());
			String fileName = file.getOriginalFilename();
			String fileFst = fileName.substring(0, fileName.lastIndexOf("."));
			String fileType = fileName.substring(fileName.lastIndexOf("."));
			String fileDir = "";
			String fileBigType = "";
			try {
				InputStream is = null;
				InputStream inputStream = null;
				if (ftFilesList.contains(fileType)) {
					is = uploadImgFile(file,null);// 上传图片文件
					inputStream = uploadImgagFile(file,null);
					// 重新命名
					fileName = PropertiesUtil.getAppContext("app.publicId") + "_" + Get32Primarykey.getRandom32BeginTimePK() + ".jpeg";
					fileBigType = "img";
				} else {
					is = file.getInputStream();
					fileDir = "files";
					// 重新命名
					fileName = PropertiesUtil.getAppContext("app.publicId") + "_" + Get32Primarykey.getRandom32BeginTimePK() + fileType;
					fileBigType = "doc";
				}

				// ftp上传
				FTPUtil fu = new FTPUtil();
				// 配置数据
				String ip = PropertiesUtil.getAppContext("file.service");
				Integer port = Integer.parseInt(PropertiesUtil.getAppContext("file.service.port"));
				String uid = PropertiesUtil.getAppContext("file.service.uid");
				String pwd = PropertiesUtil.getAppContext("file.service.pwd");
				String path = PropertiesUtil.getAppContext("file.service.path");
				if (!"".equals(fileDir)) {
					path += fileDir + "/";
				}

				// ftp客户端
				FTPClient ftp = fu.getConnectionFTP(ip, port, uid, pwd);
				if (fu.uploadFile(ftp, path, fileName, is)) {
					fu.closeFTP(ftp);
					if ("img".equals(fileBigType)) {
						ftp = fu.getConnectionFTP(ip, port, uid, pwd);
						if (fu.uploadFile(ftp, path, "source_" + fileName, inputStream)) {
							logger.info("ContactController upload method 上传后文件名！" + fileName + "_souce");
						}
						fu.closeFTP(ftp);
					}
					logger.info("ContactController upload method 上传后文件名！" + fileName);
					return URLEncoder.encode("0" + fileName + "@@@" + fileFst + fileType + "@@@" + fileBigType, "UTF-8");

				} else {
					fu.closeFTP(ftp);
					logger.info("ContactController upload method -1 上传失败！");
					return null;

				}

			} catch (Exception ex) {
				logger.info("ContactController upload method -3 上传失败！" + ex.toString());
				return null;
			}

		} else {
			logger.info("ContactController upload method -4 上传失败！");
			return null;
		}
	}

	/**
	 * 上传缩略图片文件流对象
	 * 
	 * @return
	 */
	private InputStream uploadImgFile(MultipartFile file,InputStream inputStream) throws Exception {
		BufferedImage src = null;
		if(null == inputStream){
			src = javax.imageio.ImageIO.read(file.getInputStream()); // 构造Image对象
		}else{
			src = javax.imageio.ImageIO.read(inputStream); // 构造Image对象
		}
		int width = src.getWidth();
		int height = src.getHeight();
		if (width > 80) {
			width = (int) (((new BigDecimal(80).divide(new BigDecimal(height), 2, BigDecimal.ROUND_HALF_UP)).doubleValue()) * width);
		}
		BufferedImage tag = new BufferedImage(width, 80, BufferedImage.TYPE_INT_RGB);
		tag.getGraphics().drawImage(src, 0, 0, width, 80, null); // 绘制缩小后的图
		ByteArrayOutputStream bs = new ByteArrayOutputStream();
		ImageOutputStream imOut = ImageIO.createImageOutputStream(bs);
		ImageIO.write(tag, "jpeg", imOut); // scaledImage1为BufferedImage
		InputStream is = new ByteArrayInputStream(bs.toByteArray());
		return is;
	}

	/**
	 * 上传原始图片文件流对象
	 * 
	 * @return
	 */
	private InputStream uploadImgagFile(MultipartFile file,ServletInputStream inputStream) throws Exception {
		BufferedImage src = null;
		if(null == inputStream){
			src = javax.imageio.ImageIO.read(file.getInputStream()); // 构造Image对象
		}else{
			src = javax.imageio.ImageIO.read(inputStream); // 构造Image对象
		}
		int width = src.getWidth();
		int height = src.getHeight();
		if (width > 640) {
			// height = height*(640/src.getWidth());
			height = (int) (((new BigDecimal(640).divide(new BigDecimal(width), 2, BigDecimal.ROUND_HALF_UP)).doubleValue()) * height);
			width = 640;
		}
		BufferedImage tag = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		tag.getGraphics().drawImage(src, 0, 0, width, height, null); // 绘制缩小后的图
		ByteArrayOutputStream bs = new ByteArrayOutputStream();
		ImageOutputStream imOut = ImageIO.createImageOutputStream(bs);
		ImageIO.write(tag, "jpeg", imOut); // scaledImage1为BufferedImage
		InputStream is = new ByteArrayInputStream(bs.toByteArray());
		return is;
	}

	/**
	 * 下载
	 * 
	 * @author liulin
	 * @date 2012-5-5 下午12:25:39
	 * @param request
	 * @param response
	 * @param storeName
	 * @param contentType
	 * @param realName
	 * @throws Exception
	 */
	@RequestMapping(value = "/download")
	public void download(HttpServletRequest request, HttpServletResponse response) throws Exception {

		FTPUtil fu = new FTPUtil();
		String ip = PropertiesUtil.getAppContext("file.service");
		Integer port = Integer.parseInt(PropertiesUtil.getAppContext("file.service.port"));
		String uid = PropertiesUtil.getAppContext("file.service.uid");
		String pwd = PropertiesUtil.getAppContext("file.service.pwd");
		String path = PropertiesUtil.getAppContext("file.service.path");
		String upath = PropertiesUtil.getAppContext("file.service.userpath");
		String flag = request.getParameter("flag");

		String fileName = request.getParameter("fileName");
		String fileNameSub = request.getParameter("subfilename");
		String fileType = fileName.substring(fileName.lastIndexOf("."));
		String contentType = "";
		if (ftFilesList.contains(fileType)) {
			contentType = "image/jpeg;charset=GBK";
		} else {
			contentType = "application/octet-stream";
		}

		response.setContentType(contentType);
		response.setHeader("Content-disposition", "attachment; filename=" + new String((fileNameSub).getBytes("utf-8"), "ISO8859-1"));

		OutputStream out = response.getOutputStream();
		FTPClient ftp = fu.getConnectionFTP(ip, port, uid, pwd);

		if ("dccrm".equals(flag)) {
			fu.downloadFile(ftp, upath, fileName, out);
		} else {
			fu.downloadFile(ftp, path, fileName, out);
		}
		response.setContentType(contentType);
		out.flush();
		out.close();
		fu.closeFTP(ftp);
	}
	
	
	@RequestMapping(value = "/vers")
	public void downver(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try{
			String fileName = request.getParameter("fileName");
			String contentType = "image/jpeg;charset=GBK";
			OutputStream outputStream = response.getOutputStream();
			FTPUtil fu = new FTPUtil();  
			FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd"));  
			fu.downloadFile(ftp, PropertiesUtil.getAppContext("file.service.versionpath"), fileName, outputStream);
	    	response.setContentType(contentType);  
	    	outputStream.flush();  
	        outputStream.close(); 
	        fu.closeFTP(ftp);
		}catch(Exception ex){
			logger.info("ContactController download method 下载图片失败！" + ex.toString());
		}
	}

	/**
	 * 下载 文档
	 * 
	 * @author liulin
	 * @date 2012-5-5 下午12:25:39
	 * @param request
	 * @param response
	 * @param storeName
	 * @param contentType
	 * @param realName
	 * @throws Exception
	 */
	@RequestMapping(value = "/downdoc")
	public void downdoc(HttpServletRequest request, HttpServletResponse response) throws Exception {

		FTPUtil fu = new FTPUtil();
		String ip = PropertiesUtil.getAppContext("file.service");
		Integer port = Integer.parseInt(PropertiesUtil.getAppContext("file.service.port"));
		String uid = PropertiesUtil.getAppContext("file.service.uid");
		String pwd = PropertiesUtil.getAppContext("file.service.pwd");
		String path = PropertiesUtil.getAppContext("file.service.path");
		String upath = PropertiesUtil.getAppContext("file.service.userpath");
		String flag = request.getParameter("flag");

		String fileName = request.getParameter("fileName");
		String fileNameSub = request.getParameter("subfilename");
		String fileType = fileName.substring(fileName.lastIndexOf("."));
		String contentType = "";
		String fileDir = "";
		if (ftFilesList.contains(fileType)) {
			contentType = "image/jpeg;charset=GBK";
		} else {
			contentType = "application/octet-stream";
			fileDir = "files";
		}

		response.setContentType(contentType);
		response.setHeader("Content-disposition", "attachment; filename=" + new String((fileNameSub).getBytes("utf-8"), "ISO8859-1"));

		OutputStream out = response.getOutputStream();
		FTPClient ftp = fu.getConnectionFTP(ip, port, uid, pwd);

		if ("dccrm".equals(flag)) {
			fu.downloadFile(ftp, upath, fileName, out);
		} else {
			String temppath = request.getSession().getServletContext().getRealPath("cache/");
			File fdir = new File(temppath);
			if (!fdir.isDirectory()) {
				fdir.mkdir();
			}
			if (!"".equals(fileDir)) {
				path += fileDir + "/";
			}
			// fu.downFile(ftp, path, fileName, temppath);
			fu.downloadFile(ftp, path, fileName, out);
		}
		response.setContentType(contentType);
		out.flush();
		out.close();
		fu.closeFTP(ftp);
	}
}
