/**
 * com.takshine.jf.controller.LoginController.java
 * COPYRIGHT © 2014 TAKSHINE.com Inc.,ALL RIGHTS RESERVED. 
 * 北京德成鸿业咨询服务有限公司版权所有.
 */
package com.takshine.wxcrm.controller;

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
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.MD5Util;
import com.takshine.wxcrm.base.util.MailUtils;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.SenderInfor;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.SysApplyAdd;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.DcCrmOperatorService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.OrganizationService;
import com.takshine.wxcrm.service.RegisterService;
import com.takshine.wxcrm.service.WxUserinfoService;


/**
 * 个人申请注册（申请系统/添加用户）
 * @author dengbo
 *
 */

@Controller
@RequestMapping("/register")
public class RegisterController {
	// 日志
	protected static Logger logger = Logger.getLogger(RegisterController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 进入注册信息填写页面
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/get")
	public String get(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		return "register/add";
	}
	
	//判断org表中是否已经存在此组织
	@RequestMapping("/checkName")
	@ResponseBody
	public String checkName(HttpServletRequest request, HttpServletResponse response)throws Exception{
		//重名检查
		String accntName = request.getParameter("name");
		if(StringUtils.isNotNullOrEmptyStr(accntName)&&!StringUtils.regZh(accntName)){
			accntName = new String(accntName.getBytes("ISO-8859-1"),"UTF-8");
		}
		logger.info("RegisterController checkName accntName===>"+accntName);
		CrmError crmErr = new CrmError();
		Organization organization = new Organization();
		organization.setName(accntName);
		//organization.setEnabled_flag(Constants.ZJWK_ORGANIZATION_FLAG_ENABLED);
		List<?> obj = cRMService.getDbService().getOrganizationService().findObjListByFilter(organization);
		if(null!=obj && obj.size()>0){
			crmErr.setErrorCode("777");
			crmErr.setErrorMsg("您申请的企业已被注册！");
		}else{
			crmErr.setErrorCode("0");
		}
		return JSONObject.fromObject(crmErr).toString();
	}

	/**
	 * 保存注册信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save")
	public String save(SysApplyAdd sysApplyAdd, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		//从org表中查找没有被占用的org_id
		Organization organization = new Organization();
		organization.setEnabled_flag(Constants.ZJWK_ORGANIZATION_FLAG_DISABLED);
		List<?> obj = cRMService.getDbService().getOrganizationService().findObjListByFilter(organization);
		String orgId = "";
		String status_flag = PropertiesUtil.getAppContext("zjwk.org");
		if(null!=obj && obj.size()>0){
			logger.info("RegisterController save organization status ===> disabled start");
			List<Organization> list = (List<Organization>)obj;
			Organization organization1 = list.get(0);
			orgId = organization1.getId();
			organization1.setName(sysApplyAdd.getOrg_name());
			organization1.setIndustry(sysApplyAdd.getIndustry());
			organization1.setAddress(sysApplyAdd.getAddress());
			//开关标识，是否需要人工审核
			if(!"open".equals(status_flag)){
				organization1.setEnabled_flag(Constants.ZJWK_ORGANIZATION_FLAG_ENABLED);
			}else{
				organization1.setEnabled_flag(Constants.ZJWK_ORGANIZATION_FLAG_APPLY);
			}
			cRMService.getDbService().getOrganizationService().updateObj(organization1);
			logger.info("RegisterController save organization status ===> disabled end");
			
			//调用sugar后台
			sysApplyAdd.setFlag("admin");
			sysApplyAdd.setCrmaccount(UserUtil.getCurrUser(request).getCrmId());
			sysApplyAdd.setOrgUrl(organization1.getCrmurl());
			sysApplyAdd.setCrmPass(MD5Util.digest(sysApplyAdd.getCrmPass()));
			String crmId = cRMService.getDbService().getRegisterService().createAdmin(sysApplyAdd);
			//创建用户
			logger.info("RegisterController save 创建DC用户 start");
			DcCrmOperator oper = new DcCrmOperator();
			String opid = Get32Primarykey.getRandom32PK();
			oper.setOpId(opid);
			oper.setOrgId(orgId);
			oper.setCrmId(crmId);
			String dcRowid = cRMService.getDbService().getDcCrmOperatorService().addObj(oper);
			logger.info("RegisterController save 创建DC用户 end");
			if(StringUtils.isNotNullOrEmptyStr(dcRowid)){
				//绑定关系
				logger.info("RegisterController save 创建绑定关系 start");
				OperatorMobile om = new OperatorMobile();
				om.setOpId(opid);
				om.setOpenId(openId);
				om.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
				om.setOrgId(orgId);
				om.setId(Get32Primarykey.getRandom32PK());
				om.setCrmId(crmId);
				cRMService.getDbService().getOperatorMobileService().addObj(om);
				logger.info("RegisterController save 创建绑定用户 end");
			}
			
		}else{
			//如果表中没有记录，则新建一条，待审批状态
			logger.info("RegisterController save organization status ===> apply start");
			Organization org = new Organization();
			org.setName(sysApplyAdd.getOrg_name());
			org.setIndustry(sysApplyAdd.getIndustry());
			org.setAddress(sysApplyAdd.getAddress());
			org.setEnabled_flag(Constants.ZJWK_ORGANIZATION_FLAG_APPLY);
			org.setParentid("-1");
			orgId = cRMService.getDbService().getOrganizationService().addObj(org);
			logger.info("RegisterController save organization status ===> apply end");
		}
		
		//往申请表中添加记录
		logger.info("RegisterController save 创建申请记录 start");
		String username = UserUtil.getCurrUser(request).getNickname();
		sysApplyAdd.setName(username);
		sysApplyAdd.setId(Get32Primarykey.getRandom32PK());
		sysApplyAdd.setOpen_id(openId);
		sysApplyAdd.setOrg_id(orgId);
		cRMService.getDbService().getRegisterService().addApply(sysApplyAdd);
		logger.info("RegisterController save 创建申请记录 end");
		// 发送邮件
		String flag = PropertiesUtil.getMailContext("mail.reg.valve");
		if ("open".equals(flag)) {
			logger.info("register send Email begin == >");
			SenderInfor senderInfor = new SenderInfor();
	   	 	String toEmails = "pengmd@fingercrm.com";  
	        String subject = "指尖微客申请注册";  
	        StringBuilder builder = new StringBuilder();  
	        builder.append("<div>彭总, 又有企业注册咱们的指尖微客系统了: </br></br>");  
	        builder.append("申请人名称: ").append(username).append("<br/>");  
	        builder.append("企业名称: ").append(sysApplyAdd.getOrg_name()).append("<br/>");  
	        builder.append("企业所属行业: ").append(sysApplyAdd.getIndustry()).append("<br/>"); 
	        builder.append("企业所处地址: ").append(sysApplyAdd.getAddress()).append("<br/><br/>");  
	        String content = builder.toString();  
	        senderInfor.setToEmails(toEmails);  
	        senderInfor.setSubject(subject);  
	        senderInfor.setContent(content);
	        MailUtils.sendEmail(senderInfor);
			logger.info("register send Email end == >");
		}
		return "redirect:/sys/list";
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
			//获取当前系统下所有的用户
			UserReq uReq  = new UserReq();
			uReq.setOpenId(openId);
			uReq.setOrgId(orgId);
			uReq.setFlag("all");
			uReq.setCurrpage("1");
			uReq.setPagecount("999");
			UsersResp uResp = new UsersResp();
			uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			String errorCode = uResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<UserAdd> ulist = uResp.getUsers();
				request.setAttribute("userList", ulist);
				request.setAttribute("size", ulist.size());
			}
			uReq.setFlag("single");
			uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
				request.setAttribute("curruser", uResp.getUsers().get(0));
			}
			request.setAttribute("org", org);
		}else{
			throw new Exception("没有找到数据，请联系管理员！");
		}
		request.setAttribute("orgId", orgId);
		request.setAttribute("crmId", newCrmId);
		return "register/detail";
	}
	
	/**
	 * 初始化部门
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/initDep")
	public String initDep(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String orgId = request.getParameter("orgId");
		String crmId = request.getParameter("crmId");
		Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
		request.setAttribute("departs", mp.get("expense_depart_list"));
		logger.info("RegisterController initDep orgId== >"+orgId);
		logger.info("RegisterController initDep crmId== >"+crmId);
		request.setAttribute("orgId", orgId);
		request.setAttribute("crmId", crmId);
		return "register/initDep";
	}
	
	/**
	 * 保存部门
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savedeps")
	public String savedeps(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String orgId = request.getParameter("orgId");
		String crmId = request.getParameter("crmId");
		String dataColl = request.getParameter("dataColl");
		logger.info("RegisterController savedeps orgId== >"+orgId);
		logger.info("RegisterController savedeps crmId== >"+crmId);
		CrmError crmError = cRMService.getDbService().getRegisterService().saveDepts(crmId, dataColl,"expense_depart_list");
		String errorCode = crmError.getErrorCode();
		if(ErrCode.ERR_CODE_0.equals(errorCode)){
			request.setAttribute("orgId", orgId);
			request.setAttribute("crmId", crmId);
			return "redirect:/register/detail?orgId="+orgId;
		}else{
			throw new Exception("操作失败！错误描述："+crmError.getErrorMsg());
		}
	}
	
	/**
	 * 增加用户
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addUser")
	public String addUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String orgId = request.getParameter("orgId");
		String crmId = request.getParameter("crmId");
		logger.info("RegisterController addUser openId== >"+openId);
		logger.info("RegisterController addUser publicId== >"+publicId);
		logger.info("RegisterController addUser orgId== >"+orgId);
		logger.info("RegisterController addUser crmId== >"+crmId);
		
		//获取当前系统下所有的用户
		UserReq uReq  = new UserReq();
		uReq.setOpenId(openId);
		uReq.setOrgId(orgId);
		uReq.setFlag("all");
		uReq.setCurrpage("1");
		uReq.setPagecount("999");
		UsersResp uResp = new UsersResp();
		uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
		String errorCode = uResp.getErrcode();
		if(ErrCode.ERR_CODE_0.equals(errorCode)){
			List<UserAdd> ulist = uResp.getUsers();
			request.setAttribute("userList", ulist);
		}
		
		Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
		request.setAttribute("departs", mp.get("expense_depart_list"));
		request.setAttribute("orgId", orgId);
		request.setAttribute("crmId", crmId);
		return "register/addUser";
	}
	
	/**
	 * 保存用户
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveuser")
	public String saveuser(UserAdd userAdd,HttpServletRequest request, HttpServletResponse response) throws Exception {
		String orgId = request.getParameter("orgId");
		String crmId = request.getParameter("crmId");
		logger.info("RegisterController saveuser orgId== >"+orgId);
		logger.info("RegisterController saveuser crmId== >"+crmId);
		userAdd.setCrmaccount(crmId);
		CrmError crmError = cRMService.getDbService().getRegisterService().saveUser(userAdd);
		String errorCode = crmError.getErrorCode();
		if(ErrCode.ERR_CODE_0.equals(errorCode)){
			request.setAttribute("orgId", orgId);
			request.setAttribute("crmId", crmId);
			try{
				SenderInfor senderInfor = new SenderInfor();
		   	 	String toEmails = userAdd.getEmail();  
		        String subject = "指尖微客注册信息";  
		        StringBuilder builder = new StringBuilder();  
		        builder.append("<div>").append(userAdd.getUsername()).append("，您好！欢迎您使用指尖微客。</br></br>");  
		        builder.append("您的登录用户名: ").append(userAdd.getCrmAccount()).append("<br/>");  
		        builder.append("您的登录密码: ").append(userAdd.getCrmPass()).append("<br/><br/>");  
		        builder.append("在使用过程中，若遇到任何问题，请及时联系管理员。");
		        String signature = PropertiesUtil.getMailContext("signature");
		        builder.append(signature);
		        String content = builder.toString();  
		        senderInfor.setToEmails(toEmails);  
		        senderInfor.setSubject(subject);  
		        senderInfor.setContent(content);
		        MailUtils.sendEmail(senderInfor);
			}catch(Exception e){
				logger.error("添加用户发送邮件失败 "+e.toString());
			}
			return "redirect:/register/detail?orgId="+orgId;
		}else{
			throw new Exception("操作失败！错误描述："+crmError.getErrorMsg());
		}
	}
	
	/**
	 * 删除用户
	 * @param req
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delUser")
	@ResponseBody
	public String delUser(UserReq req,HttpServletRequest request,HttpServletResponse response)throws Exception{
		CrmError crmErr = new CrmError();
		String crmId = request.getParameter("crmId");
		String orgId = request.getParameter("orgId");
		String currCrmId = request.getParameter("currCrmId");
		logger.info("RegisterController delUser crmId ==>"+crmId);
		req.setCrmaccount(currCrmId);
		req.setCrmid(crmId);
		req.setOrgId(orgId);
		req.setOptype("del");
		req.setUserstatus(Constants.CRM_USER_STATUS_INACTIVE);
		crmErr = cRMService.getSugarService().getLovUser2SugarService().updateUser(req);
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 验证用户
	 * @param req
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/validuser")
	@ResponseBody
	public String validuser(UserReq req,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String pwd = request.getParameter("userpwd");
		String orgId = request.getParameter("orgId");
		String crmId = cRMService.getSugarService().getLovUser2SugarService().getCrmIdByOrgId(UserUtil.getCurrUser(request).getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			throw new Exception("操作失败！错误描述："+ErrCode.ERR_MSG_UNBIND);
		}
		UserAdd ua = new UserAdd();
		ua.setCrmaccount(crmId);
		ua.setCrmAccount(crmId);
		ua.setCrmPass(MD5Util.digest(pwd));
		boolean flag = cRMService.getSugarService().getLovUser2SugarService().validateUserPassword(ua);
		if(flag){
			return "success";
		}else{
			return "fail";
		}
		
	}
	
	/**
	 * 修改密码
	 * @param req
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updpassword")
	@ResponseBody
	public String updpassword(UserReq req,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String pwd = request.getParameter("userpwd");
		String orgId = request.getParameter("orgId");
		String crmId = cRMService.getSugarService().getLovUser2SugarService().getCrmIdByOrgId(UserUtil.getCurrUser(request).getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			throw new Exception("操作失败！错误描述："+ErrCode.ERR_MSG_UNBIND);
		}
		UserAdd ua = new UserAdd();
		ua.setCrmaccount(crmId);
		ua.setCrmAccount(crmId);
		ua.setCrmPass(MD5Util.digest(pwd));
		boolean flag = cRMService.getSugarService().getLovUser2SugarService().updateUserPassword(ua);
		if(flag){
			return "success";
		}else{
			return "fail";
		}
	}
}
