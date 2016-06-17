package com.takshine.wxcrm.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.LovVal;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.PlatformStatistics;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.service.PlatformStatisticsService;

/**
 * 平台统计
 * 
 */
@Controller
@RequestMapping("/plat")
public class PlatformStatisticsController {
	// 日志
	protected static Logger logger = Logger.getLogger(PlatformStatisticsController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	
	/**
	 * 异步添加
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/add")
	@ResponseBody
	public String syncadd(PlatformStatistics ps,HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("PlatformStatisticsController ----------> in ");
		//分析链接
		String url = ps.getUrl();
		if(!StringUtils.isNotNullOrEmptyStr(url)){
			return "fail";
		}
		//判断是不是短链接
		String surl = url.substring(url.lastIndexOf("/")+1);
		logger.info("PlatformStatisticsController ----------> surl = > " + surl);
		Object shortUrl = RedisCacheUtil.getStringFromMap(Constants.SHORT_CACHE_KEY, surl);
		logger.info("PlatformStatisticsController ----------> shortUrl = > " + shortUrl);
		if(null != shortUrl){
			url = shortUrl.toString();
			ps.setUrl(url);
		}
		logger.info("PlatformStatisticsController ----------> url = > " + url);
		//通过URL取参数(rowId)
		String[] strs = url.split("parentId=");
		String rela_id = "";
		if(strs.length==2){
			rela_id = strs[1].split("&")[0];
		}
		if(StringUtils.isNotNullOrEmptyStr(rela_id)){
			strs = url.split("rowId=");
			if(strs.length==2){
				rela_id = strs[1].split("&")[0];
			}
		}
		ps.setRela_id(rela_id);
		logger.info("PlatformStatisticsController ----------> rela_id = > " + rela_id);
		//组织（暂时从url取值，应从缓存中取值）
		strs = url.split("orgId=");
		String orgId = "";
		if(strs.length==2){
			orgId = strs[1].split("&")[0];
		}
		ps.setOrgId(orgId);
		logger.info("PlatformStatisticsController ----------> orgId = > " + orgId);
		
		//相关模块
		String model = "";
		if(url.indexOf("customer") != -1){
			model = "Customer";
		}else if(url.indexOf("oppty") != -1){
			model = "Opportunities";
		}else if(url.indexOf("schedule") != -1){
			model = "Task";
		}else if(url.indexOf("contact") != -1){
			model = "Contact";
		}else if(url.indexOf("dcCrm") != -1){
			model = "Card";
		}else if(url.indexOf("businesscard") != -1){
			model = "Card";
		}else if(url.indexOf("resource") != -1){
			model = "Resource";
		}else if(url.indexOf("activity") != -1){
			model = "Activity";
		}
		ps.setModel(model);
		logger.info("PlatformStatisticsController ----------> model = > " + model);
		
		//用户信息
		if(UserUtil.hasCurrUser(request)){
			WxuserInfo wxuser = UserUtil.getCurrUser(request);
			ps.setOpenId(wxuser.getOpenId());
			ps.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
			ps.setParty_row_id(wxuser.getParty_row_id());
			ps.setUser_name(wxuser.getNickname());
		}
		ps.setR_type("out"); //微客记录往外发送
		boolean flag = cRMService.getDbService().getPlatformStatisticsService().saveStatistics(ps);
		if(flag){
			return "success";
		}

		return "fail";
	}
	
	
}
