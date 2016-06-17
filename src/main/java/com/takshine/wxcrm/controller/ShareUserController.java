package com.takshine.wxcrm.controller;

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
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.WxRespMsgService;

/**
 * 客户 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/shareUser")
public class ShareUserController {
	// 日志
	protected static Logger logger = Logger.getLogger(ShareUserController.class
			.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 增加或者删除共享用户
	 * @param obj
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/upd")
	@ResponseBody
	public String updshare(Share obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("ShareUserController save method id =>" + obj.getId());
		obj.setOpenId(UserUtil.getCurrUser(request).getOpenId());
		String modelname = request.getParameter("projname");//当前model名称
		String crmId = "";
		if("Activity".equals(obj.getParenttype())){
			String orgId = (String)RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+obj.getParentid());
			crmId = cRMService.getSugarService().getShare2SugarService().getCrmIdByOrgId(obj.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
		}else if("WorkReport".equals(obj.getParenttype())){
			String orgId = RedisCacheUtil.getString(Constants.ZJWK_WORKPLAN_ROWID_RELA_ORGID+obj.getParentid());
			crmId = cRMService.getSugarService().getShare2SugarService().getCrmIdByOrgId(obj.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
		}
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		String name = obj.getShareusername();
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
			obj.setShareusername(name);
		}
		
		if(StringUtils.isNotNullOrEmptyStr(modelname)&&!StringUtils.regZh(modelname)){
			modelname = new String(modelname.getBytes("ISO-8859-1"),"UTF-8");
		}
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			obj.setCrmId(crmId);
			String parenttype = obj.getParenttype();
			crmErr = cRMService.getSugarService().getShare2SugarService().updShareUser(obj);
			String param = "";
			if("0".equals(crmErr.getErrorCode())&&"share".equals(obj.getType()) && !crmId.equals(obj.getShareuserid())){
				String model = "";
				StringBuffer sBuffer = new StringBuffer();
				sBuffer.append(UserUtil.getCurrUser(request).getNickname()+"共享了");
				if("Accounts".equals(parenttype)){
					model = "/customer";
					sBuffer.append("客户"); 
				}else if("Opportunities".equals(parenttype)){
					model = "/oppty";
					sBuffer.append("业务机会"); 
				}else if("Quote".equals(parenttype)){
					model = "/quote";
					sBuffer.append("报价"); 
				}else if("Contacts".equals(parenttype)){
					model = "/contact";
					sBuffer.append("联系人");  
				}else if("Tasks".equals(parenttype)){
					param = "&schetype="+request.getParameter("schetype");
					model = "/schedule";
					sBuffer.append("任务"); 
				}else if("Contract".equals(parenttype)){
					model = "/contract";
					sBuffer.append("合同");  
				}else if("Project".equals(parenttype)){
					model = "/project";
					sBuffer.append("项目"); 
				}else if("Campaigns".equals(parenttype)){
					model = "/campaigns";
					sBuffer.append("市场活动"); 
				}else if("Activity".equals(parenttype)){
					model = "/zjwkactivity";
					param += "&id="+obj.getParentid()+"&source=wkshare&ownerOpenId="+obj.getOpenId();
				}else if("WeekReport".equals(parenttype)){
					model = "/weekreport";
					sBuffer.append("周报"); 
				}else if("Cases".equals(parenttype)){
					model = "/complaint";
					sBuffer.append("服务"); 
				}else if("Project".equals(parenttype)){
					param = "&schetype=plan";
					model = "/schedule";
					sBuffer.append("任务"); 
				}else if("Quote".equals(parenttype)){
					model = "/quote";
					sBuffer.append("报价");
				}else if("WorkReport".equals(parenttype)){
					model = "/workplan";
					sBuffer.append("工作计划");
				}
				sBuffer.append("【"+modelname+"】"+"给您"); 
				String shareid = obj.getShareuserid();
				if(shareid.contains(",")){
					String[] ids = shareid.split(",");
					for(String assgnerid : ids){
						cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(assgnerid,sBuffer.toString(), model+"/detail?rowId="+obj.getParentid()+param);
					}
				}else{
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(shareid,sBuffer.toString(), model+"/detail?rowId="+obj.getParentid()+param);
				}
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 查询共享用户的列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/shareUsersList")
	@ResponseBody
	public String shareUsersList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("getShareUsersList begin=>");
		String rowId = request.getParameter("rowId");
		String parenttype = request.getParameter("parenttype");
		//String assignerId = request.getParameter("assignerId");
		logger.info("CustomerController detail method rowId =>" + rowId);
		logger.info("CustomerController detail method parenttype =>" + parenttype);
		//绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			//查询当前业务机会下关联的共享用户
			Share share = new Share();
			share.setParentid(rowId);
			share.setParenttype(parenttype);
			share.setCrmId(crmId);
			ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
			List<ShareAdd> shareAdds = sresp.getShares();
			return JSONArray.fromObject(shareAdds).toString();
		}
		return "[]";
	}
	
}
