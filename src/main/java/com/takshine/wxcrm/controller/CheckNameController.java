/**
 * com.takshine.jf.controller.LoginController.java
 * COPYRIGHT © 2014 TAKSHINE.com Inc.,ALL RIGHTS RESERVED. 
 * 北京德成鸿业咨询服务有限公司版权所有.
 */
package com.takshine.wxcrm.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
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
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.ArticleInfo;
import com.takshine.wxcrm.domain.ArticleType;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.RepeatNameReq;
import com.takshine.wxcrm.message.sugar.RepeatNameResp;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.AccessLogsService;
import com.takshine.wxcrm.service.ArticleInfoService;
import com.takshine.wxcrm.service.ArticleTypeService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.RepeatNameService;

/**
 * 文章信息 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/checkName")
public class CheckNameController {
	// 日志
	protected static Logger logger = Logger.getLogger(CheckNameController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 检查是否有重名的情况
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/check")
	@ResponseBody
	public String check(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String orgId = request.getParameter("orgId");
		String crmId = cRMService.getSugarService().getRepeatNameService().getCrmIdByOrgId(openId, publicId, orgId);
		String name = request.getParameter("name");
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		String type = request.getParameter("type");
		String str = "";
		CrmError crmErr = new CrmError();
		logger.info("CheckNameController check method openId="+openId);
		logger.info("CheckNameController check method publicId="+publicId);
		logger.info("CheckNameController check method crmId="+crmId);
		logger.info("CheckNameController check method name="+name);
		logger.info("CheckNameController check method type="+type);
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			RepeatNameReq req = new RepeatNameReq();
			req.setName(name);
			req.setCrmaccount(crmId);
			req.setType(type);
			RepeatNameResp resp = cRMService.getSugarService().getRepeatNameService().checkName(req);
			crmErr.setErrorCode(resp.getErrcode());
			crmErr.setErrorMsg(resp.getErrmsg());
			str = JSONObject.fromObject(crmErr).toString();
			request.setAttribute("crmId", crmId);
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
		} else {
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			str = JSONObject.fromObject(crmErr).toString();
		}
		return str;
	}
}