package com.takshine.wxcrm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.error.BaseError;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.base.util.cache.EhcacheUtil;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.UserPerferences;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.sugar.SysApplyAdd;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.OrganizationService;
import com.takshine.wxcrm.service.RegisterService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 账户管理
 * @author dengbo
 */
@Controller
@RequestMapping("/sys")
public class SystemManagerController {

	// 日志
	protected static Logger logger = Logger.getLogger(SystemManagerController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 获取我已经绑定的系统
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		OperatorMobile om = new OperatorMobile();
		om.setOpenId(openId);
		List<OperatorMobile> orgList = cRMService.getDbService().getOperatorMobileService().getBindingOrgList(om);
		
		request.setAttribute("orgList", orgList);
		
		//是否有正在申请的企业
		SysApplyAdd sysApplyAdd = new SysApplyAdd();
		sysApplyAdd.setOpen_id(openId);
		List<SysApplyAdd> sysList = cRMService.getDbService().getRegisterService().searchApplyOrgs(sysApplyAdd);
		if (null != sysList && sysList.size() > 0) {
			// 如果已申请过了，则不允许再次申请
			request.setAttribute("applyflag", "NO");
			request.setAttribute("auditOrgList", sysList);
		}
		request.setAttribute("DefaultOrg", RedisCacheUtil.getString(Constants.ZJWK_USER_DEFAULT_ORGANIZATION+"_"+UserUtil.getCurrUser(request).getParty_row_id()));
		return "sys/list";
	}
	
	
	/**
	 * 取消绑定
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/cancel")
	public String cancel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String orgId = request.getParameter("orgId");
		//获取crmId
		//OperatorMobile opMobile = cRMService.getWxService().getWxUserinfoService().checkBinding(openId, publicId);
		
		// 调用指尖结算 取消绑定
		//invoke_ZjbillCannelBindData(openId,orgId);
		
		cRMService.getWxService().getWxUserinfoService().cancelBinding(openId, publicId,orgId);
		
		//修改session默认的org列表
		UserUtil.setBindOrgList(request, cRMService.getDbService().getBusinessCardService(), openId);
		
		//清除缓存
		EhcacheUtil.remove("ZJWK_FEEDS_"+openId);
		return "redirect:/sys/list";
	}
	
	
	/**
	 * 调用指尖结算 取消绑定
	 * @param userid
	 * @param username
	 * @param orgid
	 * @param orgname
	 * @return
	 */
	private String invoke_ZjbillCannelBindData(String userid,String orgId){
		BaseError em = new BaseError();
		
		logger.info("userid = >" + userid);
		if(orgId != null){
			
			
			String username = "";
			WxuserInfo wx = new WxuserInfo();
			wx.setOpenId(userid);
			Object rstwx = cRMService.getWxService().getWxUserinfoService().findObj(wx);
			if(rstwx != null){
				wx = (WxuserInfo)rstwx;
				username = wx.getNickname();
			}
			logger.info("username = >" + username);
			
			String orgname = "";
			Organization org = new Organization();
			org.setId(orgId);
			Object rstorg = cRMService.getDbService().getOrganizationService().findObj(org);
			if(rstorg != null){
				org = (Organization)rstorg;
				orgname = org.getName();
			}
			logger.info("orgname = >" + orgname);
			
			
			//调用联系人同步
			String url = PropertiesUtil.getAppContext("zjbill.url")+"/billUserEnteruser/unbind";
			logger.info("url = >" + url);
			//单次调用sugar接口
			Map<String, String> paramaps = new HashMap<String, String>();
			paramaps.put("userid", userid);
			paramaps.put("username", username);
			paramaps.put("orgid", orgId);
			paramaps.put("orgname", orgname);
			paramaps.put("source", "WK");
			//调用
			String invokrst = "";
			try {
				invokrst = cRMService.getWxService().getWxHttpConUtil().postKeyValueData(url, paramaps);
			} catch (Exception e) {
				invokrst = "";
			}
			logger.info(" invokrst => " + invokrst);
			//做空判断
			if(null == invokrst || "".equals(invokrst)){
				em.setErrorCode(ErrCode.ERR_CODE_1001006);
				em.setErrorMsg(ErrCode.ERR_CODE_1001006_MSG);
				logger.info(JSONObject.fromObject(em).toString());
				return JSONObject.fromObject(em).toString();
			} 
			//解析JSON数据
			JSONObject jsonObject = JSONObject.fromObject(invokrst);
			logger.info(jsonObject.getString("errorCode"));
			logger.info(jsonObject.getString("errorMsg"));
			return JSONObject.fromObject(em).toString();
		
		}
		em.setErrorCode(ErrCode.ERR_CODE_0);
		em.setErrorMsg(ErrCode.ERR_MSG_SUCC);
		logger.info(JSONObject.fromObject(em).toString());
		return JSONObject.fromObject(em).toString();
	}
	
	
	@RequestMapping("/updpwd")
	public String updpwd(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		request.setAttribute("orgId", request.getParameter("orgId"));
		return "sys/updpwd";
	}
	
	/**
	 * 进入相关选择页面（针对不同的org）
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/chooselist")
	public String chooselist(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String orgId = request.getParameter("orgId");
		WxuserInfo wxuserInfo = UserUtil.getCurrUser(request);
		String crmId = cRMService.getSugarService().getLovUser2SugarService().getCrmIdByOrgId(wxuserInfo.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
		//查询当前登录人的信后台息
		UserReq uReq  = new UserReq();
		uReq.setOpenId(wxuserInfo.getOpenId());
		uReq.setOrgId(orgId);
		uReq.setCurrpage("1");
		uReq.setPagecount("1");
		uReq.setFlag("single");
		UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
		UserAdd userAdd = new UserAdd();
		if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
		   userAdd =  uResp.getUsers().get(0);
		   String adminFlag = userAdd.getAdminflag();
		   request.setAttribute("adminFlag", adminFlag);
		   request.setAttribute("orgId", orgId);
		   String flag = "";
		   String type="";
		   String str = RedisCacheUtil.getString(Constants.ZJWK_WORKPLAN_GLOBAL_FLAG_TYPE+orgId);
		   if(!StringUtils.isNotNullOrEmptyStr(str)){
			   UserPerferences userPerferences = new UserPerferences();
			   userPerferences.setUser_id(orgId);
			   userPerferences.setCategory("WorkPlanGlobalFlag");
			   List<UserPerferences> list = (List<UserPerferences>)cRMService.getDbService().getUserPerferencesService().findObjListByFilter(userPerferences);
			   if(null!=list&&list.size()>0){
				   str = list.get(0).getContents();
			   }
		   }
		   if(!StringUtils.isNotNullOrEmptyStr(str)){
			   request.setAttribute("flag", flag);
			   request.setAttribute("type", type);
			   if("1".equals(adminFlag)){
				  return "sys/chooselist";
			   }else{
				  return "redirect:/sys/detail?orgId="+orgId;
			   } 
		   }else{
			   flag = str.split("\\|")[0];
			   if("N".equals(flag)){
				   type="";
			   }else{
				   type=str.split("\\|")[1];
			   }
			   request.setAttribute("flag", flag);
			   request.setAttribute("type", type);
			   if("N".equals(flag)){//全局关闭状态
				   if("1".equals(adminFlag)){
					  return "sys/chooselist";
				   }else{
					  return "redirect:/sys/detail?orgId="+orgId;
				   }  
			   }else if("Y".equals(flag)){//全局开启状态
				   String perstr = RedisCacheUtil.getString(Constants.ZJWK_WORKPLAN_PERSONAL_FLAG_TYPE+orgId+"_"+crmId);
				   String perflag = "";
				   String pertype = "";
				   if(!StringUtils.isNotNullOrEmptyStr(perstr)){
					   UserPerferences userPerferences = new UserPerferences();
					   userPerferences.setUser_id(crmId);
					   userPerferences.setCategory("WorkReport");
					   List<UserPerferences> list = (List<UserPerferences>)cRMService.getDbService().getUserPerferencesService().findObjListByFilter(userPerferences);
					   if(null!=list&&list.size()>0){
						   userPerferences = list.get(0);
						   String contents = userPerferences.getContents();
						   if(StringUtils.isNotNullOrEmptyStr(contents)){
							   String[] strarray = contents.split("\\|");
							   perflag  = strarray[0];
							   if("N".equals(perflag)){
								   pertype="";
							   }else{
								   pertype = strarray[1];
							   }
						   }
					   }
				   }else{
					   perflag = perstr.split("\\|")[0]; 
					   if("N".equals(perflag)){
						   pertype="";
					   }else{
						   pertype = perstr.split("\\|")[1]; 
					   }
				   }
				   request.setAttribute("perflag", perflag);
				   request.setAttribute("pertype", pertype);
				   return "sys/chooselist"; 
			   }
		   }
		}else{
		   throw new Exception("没有找到数据，请联系管理员！");
		}
		return "";
	}
	
	/**
	 * 保存工作计划的设置
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savewpconfig")
	public String savewpconfig(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String wpglobalflag = request.getParameter("wpglobalflag");
		String wpglobaltype = request.getParameter("wpglobaltype");
		String wppersonalflag = request.getParameter("wppersonalflag");
		String wppersonaltype = request.getParameter("wppersonaltype");
		String orgId = request.getParameter("orgid");
		WxuserInfo wxuserInfo = UserUtil.getCurrUser(request);
		String crmId = cRMService.getSugarService().getLovUser2SugarService().getCrmIdByOrgId(wxuserInfo.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
		// 用户对象
		UserReq uReq = new UserReq();
		uReq.setCurrpage("1");
		uReq.setPagecount("1000");
		uReq.setCrmaccount(crmId);
		uReq.setFlag("single");
		uReq.setOpenId(UserUtil.getCurrOpenId(request));
		uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
		UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
		UserAdd userAdd = new UserAdd();
		if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
			userAdd = uResp.getUsers().get(0);
		}
		String name = userAdd.getUsername();
		String adminFlag = userAdd.getAdminflag();
		UserPerferences userPerferences = new UserPerferences();
		if("1".equals(adminFlag)){
			userPerferences.setUser_id(orgId);
			userPerferences.setCategory("WorkPlanGlobalFlag");
			List<UserPerferences> list = (List<UserPerferences>)cRMService.getDbService().getUserPerferencesService().findObjListByFilter(userPerferences);
			userPerferences.setContents(wpglobalflag+"|"+wpglobaltype+"|"+name+"|"+orgId);
			if(null!=list&&list.size()>0){
				userPerferences.setId(list.get(0).getId());
				cRMService.getDbService().getUserPerferencesService().updateObj(userPerferences);
			}else{
				cRMService.getDbService().getUserPerferencesService().addObj(userPerferences);
			}
			RedisCacheUtil.setString(Constants.ZJWK_WORKPLAN_GLOBAL_FLAG_TYPE+orgId,wpglobalflag+"|"+wpglobaltype);
		}
		//若全局是开启状态，但没有设置个人的，则默认使用全局的
		if("Y".equals(wpglobalflag)){
			if(!StringUtils.isNotNullOrEmptyStr(wppersonalflag)){
				wppersonalflag = wpglobalflag;
			}
			if(!StringUtils.isNotNullOrEmptyStr(wppersonaltype)){
				wppersonaltype = wpglobaltype;
			}
		}
		userPerferences = new UserPerferences();
		userPerferences.setUser_id(crmId);
		userPerferences.setCategory("WorkReport");
		List<UserPerferences> list = (List<UserPerferences>)cRMService.getDbService().getUserPerferencesService().findObjListByFilter(userPerferences);
		userPerferences.setContents(wppersonalflag+"|"+wppersonaltype+"|"+name+"|"+orgId);
		if(null!=list&&list.size()>0){
			userPerferences.setId(list.get(0).getId());
			if("N".equals(wpglobalflag)){
				cRMService.getDbService().getUserPerferencesService().deleteObjById(list.get(0).getId());
			}else{
				cRMService.getDbService().getUserPerferencesService().updateObj(userPerferences);
			}
		}else{
			if("Y".equals(wpglobalflag)){
				cRMService.getDbService().getUserPerferencesService().addObj(userPerferences);
			}
		}
		RedisCacheUtil.setString(Constants.ZJWK_WORKPLAN_PERSONAL_FLAG_TYPE+orgId+"_"+crmId,wppersonalflag+"|"+wppersonaltype);
		return "redirect:/sys/chooselist?orgId="+orgId;
	}
	
	/**
	 * 进入org详情
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String orgId = request.getParameter("orgId");
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String newCrmId = cRMService.getDbService().getRegisterService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		logger.info("RegisterController detail  orgId== >"+orgId);
		logger.info("RegisterController detail  openId== >"+openId);
		logger.info("RegisterController detail  newCrmId== >"+newCrmId);
		Organization organization = new Organization();
		organization.setId(orgId);
		List<?> obj = cRMService.getDbService().getOrganizationService().findObjListByFilter(organization);
		if(null!=obj && obj.size()>0){
			Organization org = (Organization)obj.get(0);
			//获取当前账户信息
			UserReq uReq  = new UserReq();
			uReq.setOpenId(openId);
			uReq.setOrgId(orgId);
			uReq.setCurrpage("1");
			uReq.setPagecount("1");
			uReq.setFlag("single");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
				request.setAttribute("user", uResp.getUsers().get(0));
			}
			request.setAttribute("org", org);
		}else{
			throw new Exception("没有找到数据，请联系管理员！");
		}
		request.setAttribute("orgId", orgId);
		request.setAttribute("crmId", newCrmId);
		request.setAttribute("partyId", UserUtil.getCurrUser(request).getParty_row_id());
		request.setAttribute("DefaultOrg", RedisCacheUtil.getString(Constants.ZJWK_USER_DEFAULT_ORGANIZATION+"_"+UserUtil.getCurrUser(request).getParty_row_id()));
		return "sys/detail";
	}
	
	/**
	 * 修改用户手机和邮箱
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/upduser")
	@ResponseBody
	public String upduser(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String orgId = request.getParameter("orgId");
		String mobile = request.getParameter("mobile");
		String crmId = request.getParameter("crmId");
		
		UserAdd ua = new UserAdd();
		ua.setCrmaccount(crmId);
		ua.setCrmAccount(crmId);
		ua.setMobile(mobile);
		ua.setOrgId(orgId);
		
		boolean flag = cRMService.getSugarService().getLovUser2SugarService().updateUserInfo(ua);
		if(flag){
			return "success";
		}else{
			return "fail";
		}
	}
}
