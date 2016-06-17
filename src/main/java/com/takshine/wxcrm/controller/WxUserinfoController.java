package com.takshine.wxcrm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 消息  页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/wxuser")
public class WxUserinfoController {
	    // 日志
		protected static Logger logger = Logger.getLogger(WxUserinfoController.class.getName());
		
		private WxHttpConUtil util = new WxHttpConUtil();
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		/**
		 * 异步获取 用户信息数据
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping("/getImgHeader")
		@ResponseBody
		public String getImgHeader(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String crmId = request.getParameter("crmId");
			if(null == crmId || "".equals(crmId)){
				return "";
			}
			OperatorMobile opm = new OperatorMobile();
			opm.setCrmId(crmId);
			List<OperatorMobile> opList =  (List<OperatorMobile>)cRMService.getDbService().getOperatorMobileService().findObjListByFilter(opm);
			
			if(opList.size() == 0){
				WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(crmId);
				//return wu.getHeadimgstr();
				return wu.getHeadimgurl();
			}
			
			if(opList.size() > 0 ){
				OperatorMobile o = opList.get(0);
				WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(o.getOpenId());
				//return wu.getHeadimgstr();
				return wu.getHeadimgurl();
			}
			return "";
		}
		
		
		@SuppressWarnings("unchecked")
		@RequestMapping("/getImger")
		@ResponseBody
		public String getImger(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String crmId = request.getParameter("crmId");
			if(null == crmId || "".equals(crmId)){
				return "";
			}
			OperatorMobile opm = new OperatorMobile();
			opm.setCrmId(crmId);
			List<OperatorMobile> opList =  (List<OperatorMobile>)cRMService.getDbService().getOperatorMobileService().findObjListByFilter(opm);
			
			if(opList.size() == 0){
				WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(crmId);
				return wu.getHeadimgstr();
				//return wu.getHeadimgurl();
			}
			
			if(opList.size() > 0 ){
				OperatorMobile o = opList.get(0);
				WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(o.getOpenId());
				return wu.getHeadimgstr();
				//return wu.getHeadimgurl();
			}
			return "";
		}
		
		
		@RequestMapping("/getHeader")
		@ResponseBody
		public String getHeader(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String partyId = request.getParameter("partyId");
			if(null == partyId || "".equals(partyId)){
				return "";
			}
			
			WxuserInfo wu = new WxuserInfo();
			wu.setParty_row_id(partyId);
			wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wu);
			return wu.getHeadimgurl();
			
		}
		
		/**
		 * 同步用户信息数据
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/synchroUser")
		@ResponseBody
		public String synchroUser(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String openId = UserUtil.getCurrUser(request).getOpenId();
			if(null != openId && !"".equals(openId)){
				//注释掉同步 修改为 修改或新增 微信用户数据
				//cRMService.getWxService().getWxUserinfoService().synchroUserData(openId);
				String unionid = cRMService.getWxService().getWxUserinfoService().synchroSingleUserData(openId);
				logger.info("unionid = >" + unionid);
				String url = PropertiesUtil.getAppContext("zjsso.url")+"/out/sso/account_create/" + unionid;
				logger.info("url = >" + url);
				//单次调用sugar接口
				Map<String, String> paramaps = new HashMap<String, String>();
				//调用
				String invokrst = util.postKeyValueData(url, paramaps);
				logger.info(" invokrst => " + invokrst);
				
			}
			return "{\"errorcode\":\"0\":\"errormsg\":\"success\"}";
		}
		
		/**
		 * 删除用户信息数据
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/delUser")
		@ResponseBody
		public String delUser(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String openId = UserUtil.getCurrUser(request).getOpenId();
			if(null != openId && !"".equals(openId)){
				cRMService.getWxService().getWxUserinfoService().deleteObjById(openId);
			}
			return "{\"errorcode\":\"0\":\"errormsg\":\"success\"}";
		}
		
		/**
		 * 获取用户信息数据
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/getUser")
		@ResponseBody
		public String getUserInfo(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String openId = UserUtil.getCurrUser(request).getOpenId();
			if(null != openId && !"".equals(openId)){
				WxuserInfo wInfo = new WxuserInfo();
				wInfo.setParty_row_id(openId);
				WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wInfo);
				return JSONArray.fromObject(wu).toString();
			}
			return "";
		}
		
		/**
		 * 获取用户信息数据
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/getUserByUniodId")
		@ResponseBody
		public String getUserByUniodId(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String uniodId = request.getParameter("uniodId");
			if(null != uniodId && !"".equals(uniodId)){
				WxuserInfo wInfo = new WxuserInfo();
				wInfo.setUnionid(uniodId);
				WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wInfo);
				return JSONArray.fromObject(wu).toString();
			}
			return "";
		}
		
		/**
		 * 获取用户信息数据
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/getUserByOpenId")
		@ResponseBody
		public String getUserByOpenId(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String openId = UserUtil.getCurrUser(request).getOpenId();
			if(null != openId && !"".equals(openId)){
				WxuserInfo wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId);
				return JSONArray.fromObject(wu).toString();
			}
			return "";
		}
		
		
		/**
		 * 是否关注
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/isatten")
		@ResponseBody
		public String isatten(HttpServletRequest request,
				HttpServletResponse response) throws Exception { 
			String unionid = request.getParameter("unionid");
			if(null != unionid && !"".equals(unionid)){
				WxuserInfo wu = new WxuserInfo();
				//wu.setUnionid(unionid);
				wu.setParty_row_id(unionid);
				wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wu);
				if(StringUtils.isNotNullOrEmptyStr(wu.getOpenId())){
					return "1";
				}
			}
			return "";
		}
		
		
		/**
		 * 是否关注(活动端过来的)
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/isAtten")
		@ResponseBody
		public String isAtten(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String unionid = request.getParameter("unionid");
			if(null != unionid && !"".equals(unionid)){
				WxuserInfo wu = new WxuserInfo();
				wu.setParty_row_id(unionid);
				wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wu);
				if(StringUtils.isNotNullOrEmptyStr(wu.getOpenId())){
					return wu.getOpenId();
				}
			}
			return "";
		}
		
		/**
		 * 是否关注(进入detail页面的时候。需要根据openId验证)
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/isAttenByOpenId")
		@ResponseBody
		public String isAttenByOpenId(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String openId = request.getParameter("openId");
			if(null != openId && !"".equals(openId)){
				WxuserInfo wu = new WxuserInfo();
				wu.setOpenId(openId);
				wu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wu);
				if(StringUtils.isNotNullOrEmptyStr(wu.getOpenId())){
					return wu.getOpenId();
				}
			}
			return "";
		}
		
}
