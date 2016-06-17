package com.takshine.wxcrm.controller;

import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 项目 页面控制器
 *
 */
@Controller
@RequestMapping("/zjsurvey")
public class ZJSurveyController {
	
	//日志服务
	Logger logger = Logger.getLogger(ZJSurveyController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String openId = request.getParameter("openId");
		
		Object obj = cRMService.getWxService().getWxUserinfoService().findObjById(openId);	
		String nickname = "";
		String headimgurl = "";
		String partyRowId = "";
		if(obj!=null){
			WxuserInfo wxuserInfo = (WxuserInfo)obj;
			partyRowId = wxuserInfo.getParty_row_id();
			nickname = wxuserInfo.getNickname();
			headimgurl = wxuserInfo.getHeadimgurl();
		}		
		return "redirect:"+PropertiesUtil.getAppContext("zjsurvey.url")+"/survey/list?unionid="+partyRowId+"&nickname="+nickname+"&headimgurl="+headimgurl;
	}
	
	
}
