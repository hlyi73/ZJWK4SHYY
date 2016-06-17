package com.takshine.wxcrm.controller;

import java.util.ArrayList;
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
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.UserFunc;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.UserFuncService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 用户和手机关联关系 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/userFunc")
public class UserFuncController {
	// 日志
	protected static Logger logger = Logger.getLogger(UserFuncController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询 用户和手机关联关系 信息列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	@ResponseBody
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// search param
		String funParentId = request.getParameter("funParentId");// funParentId 
		String crmId = request.getParameter("crmId");// crmId 5da1ce9f-74b5-d233-c286-51c64d153d5a
		String funIdx = request.getParameter("funIdx");// funIdx
		
		// todo ceshi 
		logger.debug("gaoxingang test");
		//获取用户的权限资源数据
		List<UserFunc> uFList = cRMService.getDbService().getUserFuncService().getUserFuncListByPara(crmId, funIdx, funParentId);
		
		StringBuffer buffer = new StringBuffer();  
	    buffer.append("您好, 很高兴为您服务！请选择相关业务类型: ").append("\n\n");
	    for (int i = 0; i < uFList.size(); i++) {
	    	UserFunc uf = (UserFunc)uFList.get(i);
	    	
	    	buffer.append("【").append(uf.getFunIdx()).append("】 ").append(uf.getFunName()).append("\n");
		}
	    System.out.println(buffer.toString());
	    return buffer.toString(); 
	}

	
	/**
	 * 角色列表
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/rolelist")
	public String rolelist(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		
		OperatorMobile opMobile = cRMService.getWxService().getWxUserinfoService().checkBinding(openId, publicId);
		
		
		if(null != opMobile.getCrmId() && !"".equals(opMobile.getCrmId())){
			//获取角色列表
			List<UserFunc> roleList = cRMService.getDbService().getUserFuncService().getRolesList(opMobile.getOrgId());
			request.setAttribute("roleList", roleList);
			request.setAttribute("orgId", opMobile.getOrgId());
		}
		return "auth/rolelist";
	}
	
	/**
	 * 配置用户状态
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/user")
	public String userList(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		OperatorMobile opMobile = cRMService.getWxService().getWxUserinfoService().checkBinding(openId, publicId);
		logger.info("UserFuncController userList openId ==>"+openId);
		logger.info("UserFuncController userList publicId ==>"+publicId);
		logger.info("UserFuncController userList crmId ==>"+opMobile.getCrmId());
		if(null != opMobile.getCrmId() && !"".equals(opMobile.getCrmId())){
			//获取用户对象
			UserReq uReq = new UserReq();
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			uReq.setCrmaccount(opMobile.getCrmId());
			uReq.setFlag("more");
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			List<UserAdd> list = uResp.getUsers();
			if(list!=null&&list.size()>0){
				request.setAttribute("userlist", list);
			}else{
				request.setAttribute("userlist",new ArrayList<UserAdd>());
			}
			request.setAttribute("orgId", opMobile.getOrgId());
			request.setAttribute("crmId", opMobile.getCrmId());
		}

		return "auth/userlist";
	}
	
	
	/**
	 * 修改用户状态
	 * @param req
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveUserStatus")
	@ResponseBody
	public String saveUserStatus(UserReq req,HttpServletRequest request,HttpServletResponse response)throws Exception{
		CrmError crmErr = new CrmError();
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String crmId = cRMService.getDbService().getUserFuncService().getCrmId(openId, publicId);
		logger.info("UserFuncController saveUserStatus openId ==>"+openId);
		logger.info("UserFuncController saveUserStatus publicId ==>"+publicId);
		logger.info("UserFuncController saveUserStatus crmId ==>"+crmId);
		logger.info("UserFuncController saveUserStatus userstatus ==>"+req.getUserstatus());
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			req.setCrmaccount(crmId);
			crmErr = cRMService.getSugarService().getLovUser2SugarService().updateUser(req);
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * role
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/role")
	public String role(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String orgId = request.getParameter("orgId");
		String roleId = request.getParameter("roleId");
		
		String crmId = cRMService.getDbService().getUserFuncService().getCrmId(openId, publicId);
		
		if(null != crmId && !"".equals(crmId)){
			//获取角色下的权限
			UserFunc func = new UserFunc();
			func.setOrgId(orgId);
			func.setRoleId(roleId);
			List<UserFunc> funcList = cRMService.getDbService().getUserFuncService().getUserFuncListByFilter(func);
			
			Map<String,String> roleMap = new HashMap<String,String>();
			
			for(int i=0;i<funcList.size();i++){
				func = funcList.get(i);
				roleMap.put(func.getFunId(), func.getFunId());
			}
			request.setAttribute("roleMap", roleMap);
			
			//获取所有权限
			List<UserFunc> allFuncList = cRMService.getDbService().getUserFuncService().getAllFuncList(func);
			List<UserFunc> menuList = new ArrayList<UserFunc>();
			for(int i=0;i<allFuncList.size();i++){
				func = allFuncList.get(i);
				//菜单
				if(func.getFunModel().equals("menu")){
					menuList.add(func);
				}
			}
			request.setAttribute("menuList", menuList);
			request.setAttribute("allFuncList", allFuncList);
			
			
			//获取角色下的用户
			func = new UserFunc();
			func.setCrmId(crmId);
			func.setOrgId(orgId);
			func.setRoleId(roleId);
			List<DcCrmOperator> roleUserList = cRMService.getDbService().getUserFuncService().getRoleUsersList(func);
			Map<String,String> roleUserMap = new HashMap<String,String>();
			DcCrmOperator oper = null;
			for(int i=0;i<roleUserList.size();i++){
				oper = roleUserList.get(i);
				roleUserMap.put(oper.getOpId(), oper.getCrmId());
			}
			request.setAttribute("roleUserMap", roleUserMap);
			
			//获取角色下的用户
			List<DcCrmOperator> userList = cRMService.getDbService().getUserFuncService().getUsersList(func);
			request.setAttribute("userList", userList);
			request.setAttribute("crmId", crmId);
		}

		request.setAttribute("orgId", orgId);
		request.setAttribute("roleId", roleId);
		
		return "auth/role";
	}
	
	
	/**
	 * 保存角色用户
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/saveroleuser")
	@ResponseBody
	public String saveroleuser(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String orgId = request.getParameter("orgId");
		String roleId = request.getParameter("roleId");
		String params = request.getParameter("params");
		
		if(null == orgId || "".equals(orgId) || null == roleId || "".equals(roleId)){
			return "";
		}
		
		String crmId = cRMService.getDbService().getUserFuncService().getCrmId(openId, publicId);
		
		if(null != crmId && !"".equals(crmId)){
			UserFunc func = new UserFunc();
			func.setOrgId(orgId);
			func.setRoleId(roleId);
			//删除角色下的用户列表
			boolean flag = cRMService.getDbService().getUserFuncService().deleteRoleUsers(func);
			if(!flag){
				return "";
			}
			//添加角色下的用户
			if(null != params && !"".equals(params)){
				String[] users = params.split(",");
				List<UserFunc> userList = new ArrayList<UserFunc>();
				for(int i=0;i<users.length;i++){
					if(!"".equals(users[i])){
						func = new UserFunc();
						func.setOrgId(orgId);
						func.setRoleId(roleId);
						func.setId(Get32Primarykey.getRandom32PK());
						func.setOpId(users[i]);
						userList.add(func);
					}
				}
				
				flag = cRMService.getDbService().getUserFuncService().saveRoleUsers(userList);
				if(!flag){
					return "";
				}
			}
			return "1";
		}else{
			return "";
		}
		
	}
	
	
	/**
	 * 保存角色功能集
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/saverolefunc")
	@ResponseBody
	public String saverolefunc(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String orgId = request.getParameter("orgId");
		String roleId = request.getParameter("roleId");
		String params = request.getParameter("params1");
		
		if(null == orgId || "".equals(orgId) || null == roleId || "".equals(roleId)){
			return "";
		}
		
		String crmId = cRMService.getDbService().getUserFuncService().getCrmId(openId, publicId);
		
		if(null != crmId && !"".equals(crmId)){
			UserFunc func = new UserFunc();
			func.setOrgId(orgId);
			func.setRoleId(roleId);
			//删除角色下的功能列表
			boolean flag = cRMService.getDbService().getUserFuncService().deleteRoleFuncs(func);
			if(!flag){
				return "";
			}
			//添加角色下的功能
			if(null != params && !"".equals(params)){
				String[] funcs = params.split(",");
				List<UserFunc> funcList = new ArrayList<UserFunc>();
				for(int i=0;i<funcs.length;i++){
					if(!"".equals(funcs[i])){
						func = new UserFunc();
						func.setRoleId(roleId);
						func.setId(Get32Primarykey.getRandom32PK());
						func.setFunId(funcs[i]);
						funcList.add(func);
					}
				}
				
				flag = cRMService.getDbService().getUserFuncService().saveRoleFuncs(funcList);
				if(!flag){
					return "";
				}
			}
			return "1";
		}else{
			return "";
		}
	}
}
