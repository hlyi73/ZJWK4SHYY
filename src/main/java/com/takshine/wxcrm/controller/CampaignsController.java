package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

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
import com.takshine.wxcrm.domain.Campaigns;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CampaignsAdd;
import com.takshine.wxcrm.message.sugar.CampaignsResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;

/**
 * 项目 页面控制器
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/campaigns")
public class CampaignsController {
	
	//日志服务
	Logger logger = Logger.getLogger(CampaignsController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 异步 查询市场列表
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/asyList")
	@ResponseBody
	public String asyList(HttpServletRequest request,HttpServletResponse response)throws Exception{
		logger.info("CampaignsController acclist method begin=>");
		String crmId = request.getParameter("crmId");
		String openId = request.getParameter("openId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String firstchar = request.getParameter("firstchar");
	    currpage = (null == currpage ? "1" : currpage);
	    currpage = (Integer.parseInt(currpage)-1)+"";
	    pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("CampaignsController list method currpage =>" + currpage);
		logger.info("CampaignsController list method pagecount =>" + pagecount);
		logger.info("CampaignsController list method firstchar =>" + firstchar);
		logger.info("CampaignsController list method openId =>" + openId);
		//绑定对象
		logger.info("crmId:-> is =" + crmId);
		String str = "";
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			Campaigns campaigns = new Campaigns();
			campaigns.setCrmId(crmId);
			campaigns.setPagecount(pagecount);
			campaigns.setCurrpage(currpage);
			campaigns.setFirstchar(firstchar);
			campaigns.setOpenId(openId);
			CampaignsResp gResp = cRMService.getSugarService().getCampaigns2CrmService().getCampaignsList(campaigns,"WEB");
			if(gResp!=null&&gResp.getCams()!=null&&gResp.getCams().size()>0){
				List<CampaignsAdd> list = gResp.getCams();
				//JSON字符串输出
				str = JSONArray.fromObject(list).toString();
			}else{
				CrmError crmError = new CrmError();
				crmError.setErrorCode(ErrCode.ERR_CODE_1001004);
				crmError.setErrorMsg(ErrCode.ERR_MSG_SEARCHEMPTY);
				str = JSONArray.fromObject(crmError).toString();
			}
		}
		logger.info("CampaignsController asyList str is ->" + str);
		return str;
	}
	
	/**
	 * 查询市场活动列表
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request,HttpServletResponse response)throws Exception{
		logger.info("CampaignsController list method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
	    currpage = (null == currpage ? "1" : currpage);
	    pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("CampaignsController list method currpage =>" + currpage);
		logger.info("CampaignsController list method pagecount =>" + pagecount);
		logger.info("CampaignsController list method openId =>" + openId);
		logger.info("CampaignsController list method publicId =>" + publicId);
		String crmId = cRMService.getSugarService().getCampaigns2CrmService().getCrmId(openId, publicId);
		//绑定对象
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			Campaigns campaigns = new Campaigns();
			campaigns.setCrmId(crmId);
			campaigns.setPagecount(pagecount);
			campaigns.setCurrpage(currpage);
			CampaignsResp gResp = cRMService.getSugarService().getCampaigns2CrmService().getCampaignsList(campaigns,"WEB");
			String errorCode = gResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<CampaignsAdd> list = gResp.getCams();
				request.setAttribute("camList", list);
			}else{
				if(!ErrCode.ERR_CODE_1001004.equals(errorCode)){
					throw new Exception("错误编码：" + gResp.getErrcode() + "，错误描述：" + gResp.getErrmsg());
				}
			}
			request.setAttribute("crmId", crmId);
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		return "campaigns/list";
	}
	
	/**
	 * 市场活动 详情信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("CampaignsController detail method begin=>");
		String rowId = request.getParameter("rowId");// rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("CampaignsController detail method rowId =>" + rowId);
		logger.info("CampaignsController detail method openId =>" + openId);
		logger.info("CampaignsController detail method publicId =>" + publicId);
		logger.info("CampaignsController detail method currpage =>" + currpage);
		logger.info("CampaignsController detail method pagecount =>" + pagecount);
		// 绑定对象
		String crmId = cRMService.getSugarService().getCampaigns2CrmService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			CampaignsResp sResp = cRMService.getSugarService().getCampaigns2CrmService().getCampaignsSingle(rowId,crmId);
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<CampaignsAdd> list = sResp.getCams();
				// 放到页面上
				if (null != list && list.size() > 0) {
					request.setAttribute("camName", list.get(0).getName());
					request.setAttribute("sd", list.get(0));
					request.setAttribute("auditList", list.get(0).getAudits());//业务机会跟进数据
					// 获取当前操作用户
					UserReq currReq = new UserReq();
					currReq.setCrmaccount(crmId);
					currReq.setFlag("single");
					currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候
					currReq.setCurrpage("1");
					currReq.setPagecount("1000");
					UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
					currResp.getUsers();
					if (null != currResp.getUsers()&& null != currResp.getUsers().get(0).getUsername()) {
						request.setAttribute("assigner", currResp.getUsers().get(0).getUsername());
					}
					
					//责任人对象
					UserReq uReq = new UserReq();
					uReq.setCurrpage("1");
					uReq.setPagecount("1000");
					uReq.setCrmaccount(crmId);
					uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
					UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
					request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
					
					//查询当前任务下关联的共享用户
					Share share = new Share();
					share.setParentid(rowId);
					share.setParenttype("Campaigns");
					share.setCrmId(crmId);
					ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
					List<ShareAdd> shareAdds = sresp.getShares();
					request.setAttribute("shareusers", shareAdds);
				}else{
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
				throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}

		// requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		
		return "campaigns/detail";
	}
	
	/**
	 * 市场活动详细页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/modify")
	public String modify(HttpServletRequest request,HttpServletResponse response) throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String rowId = request.getParameter("rowId");
		logger.info("OpptyController modify method openId =>"+openId);
		logger.info("OpptyController modify method publicId =>"+publicId);
		logger.info("OpptyController modify method rowId =>"+rowId);
		//绑定对象
		String crmId = cRMService.getSugarService().getCampaigns2CrmService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			CampaignsResp sResp = cRMService.getSugarService().getCampaigns2CrmService().getCampaignsSingle(rowId,crmId);
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<CampaignsAdd> list = sResp.getCams();
				// 放到页面上
				if (null != list && list.size() > 0) {
					request.setAttribute("camName", list.get(0).getName());
					request.setAttribute("sd", list.get(0));
					//获取下拉列表信息和 责任人的用户列表信息 
					Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
					request.setAttribute("typedom", mp.get("campaign_type_dom"));
					request.setAttribute("statusdom", mp.get("campaign_status_dom"));
				}else{
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
				throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		// 分享控制按钮
		request.setAttribute("shareBtnContol",
				request.getParameter("shareBtnContol"));
		// requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		return "campaigns/modify";
	}
	
	@RequestMapping("/get")
	public String get(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String crmId = cRMService.getSugarService().getCampaigns2CrmService().getCrmId(openId, publicId);
		logger.info("CampaignsController Method get openId is " +openId);
		logger.info("CampaignsController Method get publicId is " +publicId);
		logger.info("CampaignsController Method get crmId is " +crmId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			// 获取当前操作用户
			UserReq currReq = new UserReq();
			currReq.setCrmaccount(crmId);
			currReq.setFlag("single");
			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);// 新建任务时候
			currReq.setCurrpage("1");
			currReq.setPagecount("1000");
			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
			currResp.getUsers();
			if (null != currResp.getUsers()&& null != currResp.getUsers().get(0).getUsername()) {
				request.setAttribute("assigner", currResp.getUsers().get(0).getUsername());
				request.setAttribute("assignerid", currResp.getUsers().get(0).getUserid());
			}
			
			//责任人对象
			UserReq uReq = new UserReq();
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			uReq.setCrmaccount(crmId);
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			request.setAttribute("userList", uResp.getUsers() == null ? new ArrayList<UserAdd>() : uResp.getUsers());
			
			//获取下拉列表信息和 责任人的用户列表信息 
			Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
			request.setAttribute("typedom", mp.get("campaign_type_dom"));
			request.setAttribute("statusdom", mp.get("campaign_status_dom"));
			//获取用户头像数据
			Object obj1 = cRMService.getWxService().getWxUserinfoService().findObjById(openId);
			if(null != obj1){
				WxuserInfo wxuinfo = (WxuserInfo)obj1;
				request.setAttribute("headimgurl", wxuinfo.getHeadimgurl());
			}else{
				request.setAttribute("headimgurl", PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		return "campaigns/add";
	}
	
	@RequestMapping("/save")
	public String save(CampaignsAdd campaignsAdd,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String crmId = cRMService.getSugarService().getCampaigns2CrmService().getCrmId(openId, publicId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			campaignsAdd.setCrmaccount(crmId);
			CrmError crmError = cRMService.getSugarService().getCampaigns2CrmService().saveCampaigns(campaignsAdd);
			if(!StringUtils.isNotNullOrEmptyStr(crmError.getRowId())){
				throw new Exception("错误编码：" + crmError.getErrorCode() + "，错误描述：" + crmError.getErrorMsg());
			}
			//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
			if(null != campaignsAdd.getAssignerid() && !crmId.equals(campaignsAdd.getAssignerid())){
				cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(campaignsAdd.getAssignerid(),request.getSession().getAttribute("assigner")+" 分配了一个市场活动【"+campaignsAdd.getName()+"】给您", "campaigns/detail?rowId="+crmError.getRowId());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		return "redirect:/campaigns/list?openId="+openId+"&publicId="+publicId;
	}
	
	@RequestMapping("/update")
	public String update(CampaignsAdd campaignsAdd,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String crmId = cRMService.getSugarService().getCampaigns2CrmService().getCrmId(openId, publicId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			campaignsAdd.setCrmaccount(crmId);
			CrmError crmError = cRMService.getSugarService().getCampaigns2CrmService().updateCampaigns(campaignsAdd);
			String errorCode = crmError.getErrorCode();
			if(!ErrCode.ERR_CODE_0.equals(errorCode)){
				throw new Exception("错误编码：" + crmError.getErrorCode() + "，错误描述：" + crmError.getErrorMsg());
			}
			//判断创建人与责任人是不是同一个人，如果不是，则微信消息通知责任人
			if(null != campaignsAdd.getAssignerid() && !crmId.equals(campaignsAdd.getAssignerid())){
				cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(campaignsAdd.getAssignerid(),request.getSession().getAttribute("assigner")+" 分配了一个市场活动【"+campaignsAdd.getName()+"】给您", "campaigns/detail?rowId="+campaignsAdd.getRowid());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		return "redirect:/campaigns/modify?rowId="+campaignsAdd.getRowid()+"&openId="+openId+"&publicId="+publicId;
	}
	
}
