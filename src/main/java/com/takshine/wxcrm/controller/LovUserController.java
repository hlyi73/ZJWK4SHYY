package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.message.userget.UserGet;
import com.takshine.wxcrm.message.userinfo.UserInfo;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 用户和手机关联关系 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/lovuser")
public class LovUserController {
	// 日志
	protected static Logger logger = Logger.getLogger(LovUserController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 查询所有的任务列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/userlist")
	@ResponseBody
	public String userlist(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("LovUserController list method begin=>");
		
		String crmId = "";//request.getParameter("crmId");
		String openId = UserUtil.getCurrUser(request).getOpenId();
//		String publicId = request.getParameter("publicId");
//		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
//			crmId = cRMService.getSugarService().getLovUser2SugarService().getCrmId(openId, publicId);
//		}
		String orgId = request.getParameter("orgId");
		if(StringUtils.isNotNullOrEmptyStr(orgId)){
			crmId = getNewCrmId(request);
		}else{
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
			   currpage = (null == currpage ? "0" : currpage);
			   pagecount = (null == pagecount ? "8" : pagecount);
		String viewtype = request.getParameter("viewtype");
		       viewtype = (viewtype == null ) ? "myview" : viewtype ; 
		String firstchar = request.getParameter("firstchar");
		       firstchar = (firstchar == null ) ? "" : firstchar ;
	    String flag = request.getParameter("flag");
		String parentid = request.getParameter("parentid");
		String parenttype = request.getParameter("parenttype");
		logger.info("LovUserController list method crmId =>" + crmId);
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		//获取绑定的账户 在sugar系统的id
		if(null != crmId && !"".equals(crmId)){
			UserReq uReq  = new UserReq();
			uReq.setCrmaccount(crmId);
			uReq.setCurrpage(currpage);
			uReq.setPagecount(pagecount);
			uReq.setViewtype(viewtype);
			uReq.setFlag(flag);
			uReq.setFirstchar(firstchar);
			uReq.setParentid(parentid);
			uReq.setParenttype(parenttype);
			uReq.setOpenId(openId);
			uReq.setOrgId(orgId);
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			String errorCode = uResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<UserAdd> ulist = uResp.getUsers();
				if(null == ulist || ulist.size() == 0){
					return "";
				}else{
					
					//如果系统用户列表不为空，则需要判断是否已绑定到指尖微客
					if (!Constants.DEFAULT_ORGANIZATION.equals(orgId))
					{
						OperatorMobile op = new OperatorMobile();
						op.setOrgId(orgId);
						List<OperatorMobile> bindList =  cRMService.getDbService().getOperatorMobileService().getOperMobileListByPara(op);
						for (UserAdd user : ulist)
						{
							for (OperatorMobile oper : bindList)
							{
								if (oper.getCrmId().equals(user.getUserid()))
								{
									user.setBindFlag("true");
									break;
								}
							}
						}
					}
					
					return JSONArray.fromObject(ulist).toString();
				}
			}else{
			    crmErr.setErrorCode(uResp.getErrcode());
			    crmErr.setErrorMsg(uResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}

	
	/**
	 * 查询关注者列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/attenuserlist")
	@ResponseBody
	public String attenuserlist(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("LovUserController attenuserlist method begin=>");
		String relaId = request.getParameter("relaId");
		//String openId = UserUtil.getCurrUser(request).getOpenId();
		//WxuserInfo wxu = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId); //UserUtil.getCurrUser(request);
		String partyRowId = UserUtil.getCurrUser(request).getParty_row_id();//wxu.getParty_row_id();
		logger.info("partyRowId = >" + partyRowId);
		//UserGet ug =  cRMService.getSugarService().getLovUser2SugarService().getAttenUserList(PropertiesUtil.getAppContext("app.publicId"), partyRowId, relaId);
		//List<String> openidlist = ug.getOpenidlist();
		//List<UserInfo> uinfolist = ug.getUinfolist();
		List<UserRela> userRelaList = cRMService.getSugarService().getLovUser2SugarService().getFriendList(partyRowId);
		TeamPeason search = new TeamPeason();
		search.setRelaId(relaId);
		search.setCurrpages(Constants.ZERO);
		search.setPagecounts(Constants.ALL_PAGECOUNT);
		//查询列表是否存在
		List<UserRela> userlist = new ArrayList<UserRela>();
		List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
		List<String> strlist = new ArrayList<String>();
		for(TeamPeason teamPeason:list){
		   String userid = teamPeason.getOpenId();
		   strlist.add(userid);
		}
		for(UserRela userRela : userRelaList){
	        String id = userRela.getOpenId();
			if(null!=strlist&&strlist.size()>0&&!strlist.contains(id)){
				userlist.add(userRela);
			}
		}
		//用户列表集合
		if(null!=userlist&&userlist.size()>0){
			return JSONArray.fromObject(userlist).toString();
		}else{
			if(null!=list&&null!=userRelaList&&list.size()==userRelaList.size()){
				return JSONArray.fromObject(new ArrayList<UserRela>()).toString();
			}else{
				return JSONArray.fromObject(userRelaList).toString();
			}
		}
	}
	
	/**
	 * 查询关注者列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/initlovcache")
	@ResponseBody
	public String initlovcache(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("LovUserController initlovcache=>");
		String orgId = request.getParameter("orgId");
		String crmId = request.getParameter("crmId");
		logger.info("orgId = >" + orgId);
		logger.info("crmId = >" + crmId);
		Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
		cRMService.getSugarService().getLovUser2SugarService().cacheLovData(orgId, mp);
		return "success";
	}
	
	/**
	 * 查询新的crmid
	 * @param request
	 * @return
	 */
	private String getNewCrmId(HttpServletRequest request){
		String crmId = request.getParameter("crmId");// crmIdID
		String orgId = request.getParameter("orgId");
		try {
			if(StringUtils.isNotNullOrEmptyStr(orgId)){
				String openId = UserUtil.getCurrUser(request).getOpenId();
				logger.info("openId = >" + openId);
				String newCrmId = cRMService.getSugarService().getLovUser2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
				if(StringUtils.isNotNullOrEmptyStr(newCrmId)){
					return newCrmId;
				}
			}
		} catch (Exception e) {
			logger.info("error mesg = >" + e.getMessage());
		}
		return crmId;
	}
}
