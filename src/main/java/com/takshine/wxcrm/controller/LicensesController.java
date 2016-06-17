package com.takshine.wxcrm.controller;

import java.io.File;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
@RequestMapping("/lic")
public class LicensesController {
	    
	protected static Logger logger = Logger.getLogger(LicensesController.class.getName());
	
	@RequestMapping(value = "/get")
	public String get(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		return "/pc/license/export";
	}
	
	@RequestMapping( value="/exportzip")
	@ResponseBody
	public String exportzip(HttpServletRequest request, HttpServletResponse response) throws Exception{
        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;     
        //获得文件
        MultipartFile file = multipartRequest.getFile("uploadFile");   
        if(file!=null&&file.getSize()>0){
        	logger.info("LicController upload method fileName=" + file.getOriginalFilename());
        	String fileName = file.getOriginalFilename(); 
	        try{
	        	File tmpFile = new File(fileName);
	        	file.transferTo(tmpFile);
	            //解压
	            //new EncryptInvokeObj().uzip(tmpFile, "takwxcrm_v1.0");
	        	return "succ";
		        
	        }catch(Exception ex){
	        	logger.info("LicController upload method -3 上传失败！" + ex.toString());
	        	return null;
	        }
	        
        }else{
        	logger.info("LicController upload method -4 上传失败！");
        	return null;
        }
	}
}
