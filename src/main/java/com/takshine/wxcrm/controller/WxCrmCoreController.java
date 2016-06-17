package com.takshine.wxcrm.controller;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.util.WxSignUtil;
import com.takshine.wxcrm.service.WxCoreService;

@Controller
public class WxCrmCoreController {
	
	private static Logger logger = Logger.getLogger(WxCrmCoreController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
     * get  方式的核心接收入口类
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/coreServlet", method = RequestMethod.GET)
    @ResponseBody
    public String coreGet(HttpServletRequest request, HttpServletResponse response) throws Exception{
    	request.setCharacterEncoding("UTF-8");
    	//search param
    	String signature = request.getParameter("signature");//微信加密签名，signature结合了开发者填写的token参数和请求中的timestamp参数、nonce参数。
    	String timestamp = request.getParameter("timestamp");//时间戳
    	String nonce = request.getParameter("nonce");//随机数
    	String echostr = request.getParameter("echostr");//随机字符串
    	
    	logger.info("coreGet begin:-> signature:=" + signature);
    	logger.info("coreGet begin:-> timestamp:=" + timestamp);
    	logger.info("coreGet begin:-> nonce:=" + nonce);
    	logger.info("coreGet begin:-> echostr:=" + echostr);
    	
    	// 通过检验signature对请求进行校验，若校验成功则原样返回echostr，表示接入成功，否则接入失败   
    	String rst = "";
    	if (WxSignUtil.checkSignature(signature, timestamp, nonce)) {  
    		rst = echostr;  
    	} 
        return rst;  
    }
    
    /**
     * post 方式的核心接收入口类
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/coreServlet", method = RequestMethod.POST)
    @ResponseBody
    public String corePost(HttpServletRequest request, HttpServletResponse response) throws Exception{
    	 // 将请求、响应的编码均设置为UTF-8（防止中文乱码）   
    	/*request.setCharacterEncoding("UTF-8"); */ 
    	response.setCharacterEncoding("GB2312");  
    	printRequestHeader(request);
    	logger.info("corePost begin:->===");
    	// 调用核心业务类接收消息、处理消息   
    	String respMessage = cRMService.getWxService().getWxCoreService().processRequest(request); 
    	logger.info("respMessage:->===" + respMessage);
    	logger.info("corePost end:->===");
    	return respMessage;  
    }
    
    /**
     * 微博 post 方式的核心接收入口类
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/wbCoreServlet", method = RequestMethod.POST)
    @ResponseBody
    public String wbCorePost(HttpServletRequest request, HttpServletResponse response) throws Exception{
    	printRequestHeader(request);
    	logger.info("wbCorePost begin:->===");
    	logger.info("wbCorePost end:->===");
    	String respMessage = "wbCorePost";
    	return respMessage;  
    }
    
    /**
     * 输出 request 的头信息
     * @param request
     */
    private void printRequestHeader(HttpServletRequest request){
    	 Enumeration<String> headerNames = request.getHeaderNames();
    	 while (headerNames.hasMoreElements()) {
             String key = (String) headerNames.nextElement();
             String value = request.getHeader(key);
             logger.info(" printRequest Header key :->===" + key + " =value is:->===" + value);
         }
    }

}
