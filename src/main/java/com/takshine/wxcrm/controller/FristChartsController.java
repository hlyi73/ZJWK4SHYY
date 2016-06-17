package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.List;

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
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.FrstChartsReq;
import com.takshine.wxcrm.message.sugar.FrstChartsResp;

/**
 * 首字母列表  查询 页面控制器
 * 
 * @author [liulin Date:2014-05-29]
 * 
 */
@Controller
@RequestMapping("/fchart")
public class FristChartsController {
	// 日志
	protected static Logger logger = Logger.getLogger(FristChartsController.class.getName());

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
		//error 对象
		CrmError crmErr = new CrmError();
		// search param
		String crmId = request.getParameter("crmId");// crmId 5da1ce9f-74b5-d233-c286-51c64d153d5a
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String orgId = request.getParameter("orgId");
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			crmId = UserUtil.getCurrUser(request).getCrmId();//cRMService.getSugarService().getLovUser2SugarService().getCrmId(openId, publicId);
		}
		String type = request.getParameter("type");// type
		String parenttype = request.getParameter("parenttype");
		String parentid = request.getParameter("parentid");
		type = (type == null) ? "" : type ;
		String flag = request.getParameter("flag");//查询用户首字母的标志位
		logger.info("FristChartsController method list");
		logger.info("FristChartsController method crmId  is =>" + crmId);
		logger.info("FristChartsController method type  is =>" + type);
		logger.info("FristChartsController method flag  is =>" + flag);
		String backSeaType = "";//后台查询类型
		if(type.equals("accntList")){//客户
			backSeaType = Constants.MODEL_TYPE_ACCNT;
		}else if(type.equals("opptyList")){//业务机会
			backSeaType = Constants.MODEL_TYPE_OPPTY;
		}else if(type.equals("projectList")){//项目
			backSeaType = Constants.MODEL_TYPE_PROJ;
		}else if(type.equals("userList")){//用户
			backSeaType = Constants.MODEL_TYPE_USER;
		}else if(type.equals("contractList")){//合同
			backSeaType = Constants.MODEL_TYPE_CONTRACT;
		}else if(type.equals("contactList")){//联系人
			backSeaType = Constants.MODEL_TYPE_CONTACT;
		}else if(type.equals("campaignsList")){//市场活动
			backSeaType = Constants.MODEL_TYPE_CAMP;
		}else if(type.equals("productList")){//市场活动
			backSeaType = Constants.MODEI_TYPE_PRODUCT;
		}
		logger.info("FristChartsController method backSeaType  is =>" + backSeaType);
		FrstChartsReq req = new FrstChartsReq();
		req.setCrmaccount(getNewCrmId(request));
		req.setType(backSeaType);
		req.setParentid(parentid);
		req.setParenttype(parenttype);
		req.setFlag(flag);
		if(StringUtils.isNotNullOrEmptyStr(orgId)){
			req.setOrgId(orgId);
		}
		req.setOpenId(openId);
		//获取用户的权限资源数据
		FrstChartsResp resp = null;
		if(!type.equals("campaignsList")){
			resp = cRMService.getSugarService().getLovUser2SugarService().getFirstCharList(req);
		}else{
			resp = cRMService.getSugarService().getLovUser2SugarService().getCampaignsFirstCharList(openId);
		}
		String errorCode = resp.getErrcode();
		if(ErrCode.ERR_CODE_0.equals(errorCode)){
			List<String> clist = resp.getCommons();
			if(null != clist && clist.size() > 0){
				String rstStr = "[";
				for (int i = 0; i < clist.size(); i++) {
					String c = clist.get(i);
					rstStr += "\"" + c + "\"";
					if(i != clist.size() -1){
						rstStr += ",";
					}
				}
				rstStr += "]";
				logger.info("FristChartsController method clist size is =>" + clist.size());
				logger.info("FristChartsController method rstStr is =>" + rstStr);
				return rstStr;
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001003);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_ARRISEMPTY);
			}
		}else{
			crmErr.setErrorCode(resp.getErrcode());
			crmErr.setErrorMsg(resp.getErrmsg());
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	@RequestMapping("/flist")
	@ResponseBody
	public String flist(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String relaId =  request.getParameter("relaId");
		String rstStr = "";
//		String userId = UserUtil.getCurrUserId(request);
		//List<String> flist = cRMService.getDbService().getUserRelaService().queryFirstCharById(userId);
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		List<UserRela> userRelaList = cRMService.getSugarService().getLovUser2SugarService().getFriendList(partyId);
		TeamPeason search = new TeamPeason();
		search.setRelaId(relaId);
		search.setCurrpages(Constants.ZERO);
		search.setPagecounts(Constants.ALL_PAGECOUNT);
		List<TeamPeason> list = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
		List<String> strlist = new ArrayList<String>();
		List<String> flist = new ArrayList<String>();
		for(TeamPeason teamPeason:list){
		   String userid = teamPeason.getOpenId();
		   strlist.add(userid);
		}
		List<UserRela> userlist = new ArrayList<UserRela>();
		for(UserRela userRela : userRelaList){
	        String id = userRela.getOpenId();
			if(null!=strlist&&strlist.size()>0&&!strlist.contains(id)){
				userlist.add(userRela);
			}
			String str = ZJWKUtil.getFirstSpell(userRela.getRela_user_name());
			if(StringUtils.isNotNullOrEmptyStr(str)&&!flist.contains(str)){
				flist.add(str);
			}
		}
		if(null!=userlist&&userlist.size()>0){
			flist = new ArrayList<String>();
			for(UserRela userRela : userlist){
				String str = ZJWKUtil.getFirstSpell(userRela.getRela_user_name());
				if(StringUtils.isNotNullOrEmptyStr(str)&&!flist.contains(str)){
					flist.add(str);
				}
			}
		}
		if(null != flist && flist.size() > 0)
		{
			if(null!=strlist&&strlist.size()==flist.size()){
				rstStr = "";
				flist = new ArrayList<String>();
			}
			rstStr = "[";
			for (int i = 0; i < flist.size(); i++) {
				String c = flist.get(i);
				rstStr += "\"" + c + "\"";
				if(i != flist.size() -1){
					rstStr += ",";
				}
			}
			rstStr += "]";
			logger.info("FristChartsController method flist size is =>" + flist.size());
			logger.info("FristChartsController method rstStr is =>" + rstStr);
		}
		return rstStr;
	}
	
	@RequestMapping("/userlist")
	@ResponseBody
	public String userlist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		//error 对象
		CrmError crmErr = new CrmError();
		// search param
		String crmId = request.getParameter("crmId");// 
		String type = request.getParameter("type");// type
		       type = (type == null) ? "" : type ;
		logger.info("FristChartsController method list");
		logger.info("FristChartsController method crmId  is =>" + crmId);
		logger.info("FristChartsController method type  is =>" + type);
		
		String backSeaType = "";//后台查询类型
		if(type.equals("accntList")){//客户
			backSeaType = Constants.MODEL_TYPE_ACCNT;
		}else if(type.equals("opptyList")){//业务机会
			backSeaType = Constants.MODEL_TYPE_OPPTY;
		}else if(type.equals("users")){
			backSeaType = Constants.MODEL_TYPE_USER;
		}
		logger.info("FristChartsController method backSeaType  is =>" + backSeaType);
		
		FrstChartsReq req = new FrstChartsReq();
		req.setCrmaccount(getNewCrmId(request));
		req.setType(backSeaType);
		//获取用户的权限资源数据
		FrstChartsResp resp = cRMService.getSugarService().getLovUser2SugarService().getFirstCharList(req);
		String errorCode = resp.getErrcode();
		if(ErrCode.ERR_CODE_0.equals(errorCode)){
			List<String> clist = resp.getCommons();
			if(null != clist && clist.size() > 0){
				String rstStr = "[";
				for (int i = 0; i < clist.size(); i++) {
					String c = clist.get(i);
					rstStr += "\"" + c + "\"";
					if(i != clist.size() -1){
						rstStr += ",";
					}
				}
				rstStr += "]";
				logger.info("FristChartsController method clist size is =>" + clist.size());
				logger.info("FristChartsController method rstStr is =>" + rstStr);
				return rstStr;
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001003);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_ARRISEMPTY);
			}
		}else{
			crmErr.setErrorCode(resp.getErrcode());
			crmErr.setErrorMsg(resp.getErrmsg());
		}
		return JSONObject.fromObject(crmErr).toString();
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
