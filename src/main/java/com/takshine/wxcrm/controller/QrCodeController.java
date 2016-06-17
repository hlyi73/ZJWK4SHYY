package com.takshine.wxcrm.controller;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

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
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.QRCodeUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.message.userinfo.UserInfo;
import com.takshine.wxcrm.service.DcCrmOperatorService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 二维码
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/qrcode")
public class QrCodeController {
		protected static Logger logger = Logger.getLogger(QrCodeController.class.getName());
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		/**
	     * 生成公众号的二维码
	     * @param request
	     * @param response
	     * @return
	     * @throws Exception
	     */
		@RequestMapping("/show")
	    public String show(HttpServletRequest request, HttpServletResponse response) throws Exception{
	    	return "qrcode/show";
		}
		
		/**
		 * 生成个人名片的二维码
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception 
		 */
		public String make(HttpServletRequest request,HttpServletResponse response) throws Exception{
			ZJWKUtil.getRequestURL(request);
			return "qrcode/msg";
		}
		
}
