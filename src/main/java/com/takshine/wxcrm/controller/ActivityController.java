package com.takshine.wxcrm.controller;

import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;
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

/**
 * 活动 控制器
 * @author lilei
 *
 */
@Controller
@RequestMapping("/activity")
public class ActivityController {
	protected static Logger logger = Logger.getLogger(ActivityController.class.getName());
	
	/**
     * 活动选择
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/get")
    public String get(HttpServletRequest request, HttpServletResponse response) throws Exception{
		/*//openId publicId
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		       openId = (openId == null) ? "" : openId ;
		       publicId = (publicId == null) ? "" : publicId ;*/

        String crmId = UserUtil.getCurrUser(request).getCrmId();
   		//判断是否已经绑定 crm 账户
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			request.setAttribute("bindSucc", "fail");
			return "activity/msg";
			
		}else{
			//设置 openId publicId crmId
			request.setAttribute("crmId", crmId);
			/*request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);*/
			
			return "activity/choose";
		}
	}
	
	
	/**
     * 活动创建
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping("/add")
    public String add(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String type=request.getParameter("type");       

		String crmId = UserUtil.getCurrUser(request).getCrmId();
   		//判断是否已经绑定 crm 账户
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			request.setAttribute("bindSucc", "fail");
			return "activity/msg";
			
		}else{
			//设置 openId publicId crmId
			request.setAttribute("crmId", crmId);
			request.setAttribute("type", type);
			return "activity/add";
		}
	}
	
	
	/**
	 * 异步上传图片
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping( value="/upload")
	@ResponseBody
	public String upload(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;     
        //获得文件：     
        MultipartFile file = multipartRequest.getFile("uploadFile");   
        if(file!=null&&file.getSize()>0){
        	logger.info("ContactController upload method fileName=" + file.getOriginalFilename());
        	String fileName = file.getOriginalFilename(); 
	        try{
	        	//获取上传文件类型的扩展名,先得到.的位置，再截取从.的下一个位置到文件的最后，最后得到扩展名 
		        //if(fileName.contains(".")){
		        	//将源始图片生成缩略图
//		        	File tmpFile = new File(fileName);
/*//		        	file.transferTo(tmpFile);
		        	Image src = javax.imageio.ImageIO.read(file.getInputStream()); //构造Image对象
		        	BufferedImage tag = new BufferedImage(80,80,BufferedImage.TYPE_INT_RGB);
		        	tag.getGraphics().drawImage(src,0,0,80,80,null);       //绘制缩小后的图
		        	//将生成的缩略成转换成流
		        	ByteArrayOutputStream bs =new ByteArrayOutputStream();
		        	ImageOutputStream imOut =ImageIO.createImageOutputStream(bs);
		        	//String type = fileName.substring(fileName.lastIndexOf("."),fileName.length());
		        	ImageIO.write(tag,"jpeg",imOut); //scaledImage1为BufferedImage
		        	InputStream is =new ByteArrayInputStream(bs.toByteArray());*/
		        	
		        	//String type = fileName.substring(fileName.lastIndexOf("."),fileName.length());
		        	//重新命名
		        	fileName = PropertiesUtil.getAppContext("app.publicId")+"_"+Get32Primarykey.getRandom32BeginTimePK()+".jpeg";
		        	//ftp上传
		        	FTPUtil fu = new FTPUtil();  
		        	FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd"));  
		        	if(fu.uploadFile(ftp, PropertiesUtil.getAppContext("file.service.path"), fileName,file.getInputStream())){
		        		fu.closeFTP(ftp);
		        		logger.info("ContactController upload method 上传后文件名！"+fileName);
		        		return "0"+fileName;
		        	}else{
		        		fu.closeFTP(ftp);
		        		logger.info("ContactController upload method -1 上传失败！");
		        		return null;
		        	}
		        //}else{
		        //	logger.info("ContactController upload method -2 上传失败！");
		        //	return null;
		        //}
	        }catch(Exception ex){
	        	logger.info("ContactController upload method -3 上传失败！" + ex.toString());
	        	return null;
	        }
        }else{
        	logger.info("ContactController upload method -4 上传失败！");
        	return null;
        }
	}
	
	
	/**
	 * 异步传图片
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping( value="/download")
	@ResponseBody
	public void download(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		try{
			String fileName = request.getParameter("fileName");
			String flag = request.getParameter("flag");
			String contentType = "image/jpeg;charset=GBK";
			OutputStream outputStream = response.getOutputStream();
			FTPUtil fu = new FTPUtil();  
			FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd"));  
			if("dccrm".equals(flag)){
				fu.downloadFile(ftp, PropertiesUtil.getAppContext("file.service.userpath"), fileName, outputStream);
			}else{
				fu.downloadFile(ftp, PropertiesUtil.getAppContext("file.service.path"), fileName, outputStream);
			}
	    	response.setContentType(contentType);  
	    	outputStream.flush();  
	        outputStream.close(); 
	        fu.closeFTP(ftp);
		}catch(Exception ex){
			logger.info("ContactController download method 下载图片失败！" + ex.toString());
		}
	}
	
}
