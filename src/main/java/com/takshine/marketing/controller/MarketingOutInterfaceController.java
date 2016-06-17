package com.takshine.marketing.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.Userinfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.userinfo.UserInfo;

import common.Logger;


/**
 * 指尖活动统一调外部控制类
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/out1")
public class MarketingOutInterfaceController {
	
	Logger logger = Logger.getLogger(MarketingOutInterfaceController.class);
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 得到团队用户
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getUserList")
	@ResponseBody
	public String getUserList(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String crmId = request.getParameter("crmId");
		String firstchar=request.getParameter("firstchar"); 
		String flag = request.getParameter("flag");
		String parentid= request.getParameter("parentid");
		String parenttype= request.getParameter("parenttype");
		String currpage= request.getParameter("currpage");
		String pagecount= request.getParameter("pagecount");
		String orgId= request.getParameter("orgId");
		String openId= request.getParameter("openId");
		String url = PropertiesUtil.getAppContext("zjwk.url")+"/out/userlist";
		logger.info(" 得到团队用户 => " + url);
		//单次调用sugar接口
		Map<String, String> paramaps = new HashMap<String, String>();
		paramaps.put("crmId", crmId);
		paramaps.put("firstchar", firstchar);
		paramaps.put("flag", flag);
		paramaps.put("parentid", parentid);
		paramaps.put("parenttype", parenttype);
		paramaps.put("currpage", currpage);
		paramaps.put("pagecount", pagecount);
		paramaps.put("orgId", orgId);
		paramaps.put("openId", openId);
		//调用
		String invokrst = "";
		try {
			invokrst = cRMService.getWxService().getWxHttpConUtil().postKeyValueData(url, paramaps);
		} catch (Exception e1) {
			logger.info(" exception => " + e1.getMessage());
		}
		logger.info("getUserList invokrst => " + invokrst);
		List<UserAdd> list = new ArrayList<UserAdd>();
		if(StringUtils.isNotNullOrEmptyStr(invokrst)){
			if(!invokrst.contains("errorCode")){
				JSONArray invokObj = JSONArray.fromObject(invokrst);
				for(int i=0;i<invokObj.size();i++){
					JSONObject jsonObject = invokObj.getJSONObject(i);
					UserAdd useradd = new UserAdd();
					useradd.setUserid(jsonObject.getString("userid"));
					useradd.setUsername(jsonObject.getString("username"));
					useradd.setTitle(jsonObject.getString("title"));
					useradd.setDepartment(jsonObject.getString("department"));
					list.add(useradd);
				}
			}
		}
		if(list.size()>0){
			return JSONArray.fromObject(list).toString();
		}else{
			return "";
		}
	}
	
	/**
	 * 得到关注用户列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getAttenUserList")
	@ResponseBody
	public String getAttenUserList(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String relaId= request.getParameter("relaId");
		String openId= request.getParameter("openId");
		String url = PropertiesUtil.getAppContext("zjwk.url")+"/out/attenuserlist";
		logger.info(" 得到关注用户列表 => " + url);
		//单次调用sugar接口
		Map<String, String> paramaps = new HashMap<String, String>();
		paramaps.put("relaId", relaId);
		paramaps.put("openId", openId);
		//调用
		String invokrst = "";
		try {
			invokrst = cRMService.getWxService().getWxHttpConUtil().postKeyValueData(url, paramaps);
		} catch (Exception e1) {
			logger.info(" exception => " + e1.getMessage());
		}
		logger.info(" getAttenUserList invokrst => " + invokrst);
		List<UserInfo> list = new ArrayList<UserInfo>();
		if(StringUtils.isNotNullOrEmptyStr(invokrst)){
			if(!invokrst.contains("errorCode")){
			JSONArray invokObj = JSONArray.fromObject(invokrst);
				for(int i=0;i<invokObj.size();i++){
					JSONObject jsonObject = invokObj.getJSONObject(i);
					UserInfo useradd = new UserInfo();
					useradd.setOpenId(jsonObject.getString("openId"));
					useradd.setHeadImgurl(jsonObject.getString("headImgurl"));
					useradd.setNickname(jsonObject.getString("nickname"));
					useradd.setCountry(jsonObject.getString("country"));
					useradd.setCity(jsonObject.getString("city"));
					useradd.setProvince(jsonObject.getString("province"));
					list.add(useradd);
				}
			}
		}
		try {
			if(list.size()>0){
				String str = JSONArray.fromObject(list).toString();
				return str;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	/**
	 * 异步获取选中的用户列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asynclist")
	@ResponseBody
	public String asynclist(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String relaId= request.getParameter("relaId");
		String url = PropertiesUtil.getAppContext("zjwk.url")+"/out/asynclist";
		Map<String, String> paramaps = new HashMap<String, String>();
		paramaps.put("relaId", relaId);
		//调用
		String invokrst = "";
		try {
			invokrst = cRMService.getWxService().getWxHttpConUtil().postKeyValueData(url, paramaps);
		} catch (Exception e1) {
			logger.info(" exception => " + e1.getMessage());
		}
		logger.info("asynclist invokrst => " + invokrst);
		List<TeamPeason> list = new ArrayList<TeamPeason>();
		if(StringUtils.isNotNullOrEmptyStr(invokrst)){
			if(!invokrst.contains("errorCode")){
				JSONArray invokObj = JSONArray.fromObject(invokrst);
				for(int i=0;i<invokObj.size();i++){
					JSONObject jsonObject = invokObj.getJSONObject(i);
					TeamPeason teamPeason = new TeamPeason();
					teamPeason.setOpenId(jsonObject.getString("openId"));
					teamPeason.setNickName(jsonObject.getString("nickName"));
					list.add(teamPeason);
				}
			}
		}
		if(list.size()>0){
			return JSONArray.fromObject(list).toString();
		}else{
			return "";
		}
	}
	
	/**
	 * 保存指尖好友
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/save")
	@ResponseBody
	public String save(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String ownerOpenId = request.getParameter("ownerOpenId");
		String openIds = request.getParameter("openId");
		String nickNames = request.getParameter("nickName");
		String relaId = request.getParameter("relaId");
		String relaModel = request.getParameter("relaModel");
		String relaName = request.getParameter("relaName");
		String assigner = request.getParameter("assigner");
		String orgId = request.getParameter("orgId");
		String url = PropertiesUtil.getAppContext("zjwk.url")+"/out/save";
		logger.info("保存指尖好友 => " + url);
		//单次调用sugar接口
		Map<String, String> paramaps = new HashMap<String, String>();
		paramaps.put("ownerOpenId", ownerOpenId);
		paramaps.put("openIds", openIds);
		paramaps.put("nickNames", nickNames);
		paramaps.put("relaId", relaId);
		paramaps.put("relaModel", relaModel);
		paramaps.put("relaName", relaName);
		paramaps.put("assigner", assigner);
		paramaps.put("orgId", orgId);
		//调用
		String invokrst = "";
		try {
			invokrst = cRMService.getWxService().getWxHttpConUtil().postKeyValueData(url, paramaps);
		} catch (Exception e1) {
			logger.info(" exception => " + e1.getMessage());
		}
		logger.info("save invokrst => " + invokrst);
		JSONObject jsonObject = JSONObject.fromObject(invokrst);
		CrmError crmError = new CrmError();
		crmError.setErrorCode(jsonObject.getString("errorCode"));
		crmError.setErrorMsg(jsonObject.getString("errorMsg"));
		return JSONObject.fromObject(crmError).toString();
	}
	
	/**
	 * 删除指尖好友
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/del")
	@ResponseBody
	public String del(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String openId = request.getParameter("openId");
		String relaId = request.getParameter("relaId");
		String url = PropertiesUtil.getAppContext("zjwk.url")+"/out/del";
		logger.info("删除指尖好友 => " + url);
		//单次调用sugar接口
		Map<String, String> paramaps = new HashMap<String, String>();
		paramaps.put("relaId", relaId);
		paramaps.put("openId", openId);
		//调用
		String invokrst = "";
		try {
			invokrst = cRMService.getWxService().getWxHttpConUtil().postKeyValueData(url, paramaps);
		} catch (Exception e1) {
			logger.info(" exception => " + e1.getMessage());
		}
		logger.info("del invokrst => " + invokrst);
		JSONObject jsonObject = JSONObject.fromObject(invokrst);
		CrmError crmError = new CrmError();
		crmError.setErrorCode(jsonObject.getString("errorCode"));
		crmError.setErrorMsg(jsonObject.getString("errorMsg"));
		return JSONObject.fromObject(crmError).toString();
	}
	
	/**
	 * 增加或者删除共享用户
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/upd")
	@ResponseBody
	public String upd(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String id = request.getParameter("id");
		String parenttype = request.getParameter("parenttype");
		String parentid = request.getParameter("parentid");
		String openId = request.getParameter("openId");
		String shareuserid = request.getParameter("shareuserid");
		String shareusername = request.getParameter("shareusername");
		String type = request.getParameter("type");
		String crmname = request.getParameter("crmname");//当前登录人的名称
		String modelname = request.getParameter("projname");//当前model名称
		String url = PropertiesUtil.getAppContext("zjwk.url")+"/out/upd";
		logger.info("增加或者删除团队用户 => " + url);
		//单次调用sugar接口
		Map<String, String> paramaps = new HashMap<String, String>();
		paramaps.put("id", id);
		paramaps.put("parenttype", parenttype);
		paramaps.put("parentid", parentid);
		paramaps.put("openId", openId);
		paramaps.put("shareuserid", shareuserid);
		paramaps.put("shareusername", shareusername);
		paramaps.put("type", type);
		paramaps.put("crmname", crmname);
		paramaps.put("projname", modelname);
		//调用
		String invokrst = "";
		try {
			invokrst = cRMService.getWxService().getWxHttpConUtil().postKeyValueData(url, paramaps);
		} catch (Exception e1) {
			logger.info(" exception => " + e1.getMessage());
		}
		JSONObject jsonObject = JSONObject.fromObject(invokrst);
		CrmError crmError = new CrmError();
		crmError.setErrorCode(jsonObject.getString("errorCode"));
		crmError.setErrorMsg(jsonObject.getString("errorMsg"));
		return JSONObject.fromObject(crmError).toString();
	}
	
}
