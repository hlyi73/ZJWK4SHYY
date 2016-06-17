package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.HashMap;
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
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.base.util.cache.EhcacheUtil;
import com.takshine.wxcrm.domain.Feeds;
import com.takshine.wxcrm.domain.Message;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.Subscribe;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.FeedsAdd;
import com.takshine.wxcrm.message.sugar.FeedsResp;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.FeedsService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.MessageService;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.SubscribeService;
import com.takshine.wxcrm.service.TeamPeasonService;
import com.takshine.wxcrm.service.WxRespMsgService;

/**
 * 活动流 页面控制器
 * 
 * @author [ Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/feed")
public class FeedsController {
	// 日志
	protected static Logger logger = Logger.getLogger(FeedsController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 *
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String feedsController(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("feedsController acclist method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		//查询条件
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignId = request.getParameter("assignerId");
		String salesStage = request.getParameter("salesstage");

		logger.info("FeedsController list method openId =>" + openId);
		logger.info("FeedsController list method publicId =>" + publicId);
		logger.info("FeedsController list method currpage =>" + currpage);
		logger.info("FeedsController list method pagecount =>" + pagecount);
		logger.info("FeedsController list method startDate =>" + startDate);
		logger.info("FeedsController list method endDate =>" + endDate);
		logger.info("FeedsController list method salesStage =>" + salesStage);
		logger.info("FeedsController list method assignId =>" + assignId);

		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		// 绑定对象
		String crmId = cRMService.getSugarService().getFeedsService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
		
//			//
//			Feeds feed = new Feeds();
//			feed.setCrmId(crmId);
//			feed.setPagecount(pagecount);
//			feed.setCurrpage(currpage);
//			feed.setParam2(assignId);
//			feed.setParam3(startDate);
//			feed.setParam4(endDate);
//			feed.setParam5(salesStage);
//			//feed.setLasttime(DateTime.date2Str(lastDate, "yyyy-MM-dd HH:mm:ss"));
//			//
//			request.setAttribute("lasttime", feed.getLasttime());
//			
//			FeedsResp fResp = feedsService.getFeedList(feed);
//			String errorCode = fResp.getErrcode();
//			if(ErrCode.ERR_CODE_0.equals(errorCode)){
//				List<FeedsAdd> list = fResp.getFeedList();
//				// 放到页面上
//				if (null != list && list.size() > 0) {
//					request.setAttribute("feedList", list);
//				} else {
//					request.setAttribute("feedList", new ArrayList<FeedsAdd>());
//				}
//			}else{
//			    throw new Exception("错误编码：" + fResp.getErrcode() + "，错误描述：" + fResp.getErrmsg());
//			}
			
			//获取当前操作用户
			UserReq currReq = new UserReq();
			currReq.setCrmaccount(crmId);
			currReq.setFlag("single");
			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
			currReq.setCurrpage("1");
			currReq.setPagecount("1000");
			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
			currResp.getUsers();
			if(null != currResp.getUsers()){
				if(null != currResp.getUsers().get(0).getUsername()){
					request.setAttribute("assigner", currResp.getUsers().get(0).getUsername());
				}
				request.setAttribute("assignerid",currResp.getUsers().get(0).getUserid());
			}
			
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}

		// requestinfo
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("currpage", currpage);
		
		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.setAttribute("assignId", assignId);
		request.setAttribute("salesStage", salesStage);

		return "feed/list";
	}

	@RequestMapping("/feedlist")
	@ResponseBody
	public String syncFeedsController(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("CustomerController acclist method begin=>");
		String crmId = request.getParameter("crmId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String param1 = request.getParameter("param1");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String assignId = request.getParameter("assignerId");
		String salesStage = request.getParameter("salesstage");
		
		logger.info("syncFeedsController list method crmId =>" + crmId);
		logger.info("syncFeedsController list method currpage =>" + currpage);
		logger.info("syncFeedsController list method pagecount =>" + pagecount);

		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		// 绑定对象
		logger.info("crmId:-> is =" + crmId);
		String str = "";
		//error 对象
		CrmError crmErr = new CrmError();
		
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Feeds feed = new Feeds();
			feed.setCrmId(crmId);
			feed.setPagecount(pagecount);
			feed.setCurrpage(currpage);
			feed.setParam2(assignId);
			feed.setParam3(startDate);
			feed.setParam4(endDate);
			feed.setParam5(salesStage);
			if(StringUtils.isNotNullOrEmptyStr(param1)){
				Subscribe subscribe = new Subscribe();
				subscribe.setCrmId(crmId);
				subscribe.setCurrpages(0);
				subscribe.setPagecounts(999999999);
				List<String> feedids = (List<String>)cRMService.getDbService().getSubscribeService().findObjListByFilter(subscribe);
				if(feedids!=null&&feedids.size()>0&&null!=feedids.get(0)){
					feed.setParam1(feedids.get(0));
				}else{
					feed.setParam1(param1);
				}
			}
			FeedsResp fResp = cRMService.getSugarService().getFeedsService().getFeedList(feed);
			String errorCode = fResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<FeedsAdd> list = fResp.getFeedList();
				// 放到页面上
				if (null != list && list.size() > 0) {
					return str = JSONArray.fromObject(list).toString();
				} else {
					str += "[]";
				}
				str = "{\"list1\":" + str  + "}";
				logger.info("str:-> is =" + str);
			}else{
				crmErr.setErrorCode(fResp.getErrcode());
				crmErr.setErrorMsg(fResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	
	@RequestMapping("/allfeedlist")
	@ResponseBody
	public String syncFeedsList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("CustomerController acclist method begin=>");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String openId = request.getParameter("openId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		// 绑定对象
		logger.info("crmId:-> is =" + crmId);
		CrmError crmErr = new CrmError();
		if(!StringUtils.isNotNullOrEmptyStr(pagecount)){
			pagecount="25";
		}
		if(!StringUtils.isNotNullOrEmptyStr(currpage)){
			currpage="0";
		}
		int startCount =Integer.parseInt(currpage)*Integer.parseInt(pagecount);
		int endCount =startCount+Integer.parseInt(pagecount);
		if(startCount<0){
			startCount=0;
		}
		int totalcount=0;
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			//判断缓存中是否存在
			//if(null != WxCrmCacheUtil.get("ZJWK_FEEDS_"+openId)){
				//如果存在，直接返回
			//	return JSONArray.fromObject(WxCrmCacheUtil.get("ZJWK_FEEDS_"+openId)).toString();
			//}
			Feeds feed = new Feeds();
			feed.setCrmId(crmId);
			feed.setViewtype(Constants.SEARCH_VIEW_TYPE_MYALLVIEW);
			feed.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			FeedsResp fResp = cRMService.getSugarService().getFeedsService().getAllFeedList(feed);
			List<FeedsAdd> list = fResp.getFeedList();
			
			StringBuffer rowids = new StringBuffer();
			if(null != list && list.size()>0){
				//-------------------------------------------------------
				//组装ID
				for(int i=0;i<list.size();i++){
					if(i!=0){
						rowids.append(",");
					}
					rowids.append("'").append(list.get(i).getRowid()).append("'");
				}
			}
			
			TeamPeason search = new TeamPeason(); 
			search.setOpenId(openId);
			search.setCurrpages(0);
			search.setPagecounts(999999);
			List<?> teamList = cRMService.getDbService().getTeamPeasonService().findObjListByFilter(search);
			if(null != teamList && teamList.size()>0){
				for(int i=0;i<teamList.size();i++){
					search = (TeamPeason)teamList.get(i);
					if(!StringUtils.isNotNullOrEmptyStr(search.getOrgId())){
						continue;
					}
					if(StringUtils.isNotNullOrEmptyStr(rowids.toString())){
						rowids.append(",");
					}
					rowids.append("'").append(search.getRelaId()).append("'");
				}
			}
			
			if(!StringUtils.isNotNullOrEmptyStr(rowids.toString())){
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001004);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_SEARCHEMPTY);
			}	
			// 查询消息
			Messages msg = new Messages();
			msg.setRelaId(rowids.toString());
			List<Messages> msgList = cRMService.getDbService().getMessagesService()
					.searchMessagesByRelaIds(msg);

			List<FeedsAdd> msgFeedList = new ArrayList<FeedsAdd>();
			FeedsAdd fa = null;
			if (msgList != null) {
				totalcount = msgList.size();
				if (endCount >= msgList.size()) {
					endCount = msgList.size();
				}
			}
			if (startCount > endCount) {
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001004);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_SEARCHEMPTY);
				return JSONObject.fromObject(crmErr).toString();
			}
			for (int i = startCount; i < endCount; i++) {
				msg = msgList.get(i);
				for (int j = 0; j < list.size(); j++) {
					fa = list.get(j);
					if (fa.getRowid().equals(msg.getRelaId())) {
						fa.setMsg(msg);
						msgFeedList.add(fa);
						break;
					}
				}
				
				for(int j=0;j<teamList.size();j++){
					search = (TeamPeason)teamList.get(j);
					if (search.getRelaId().equals(msg.getRelaId()) && StringUtils.isNotNullOrEmptyStr(search.getOrgId())) {
						fa = new FeedsAdd();
						fa.setRowid(search.getRelaId());
						fa.setOperid(UserUtil.getCurrUser(request).getCrmId());
						fa.setOpername(search.getNickName());
						fa.setName(search.getRelaName());
						fa.setModule(search.getRelaModel());
						fa.setOpertype("0"); 
						fa.setOrgId(search.getOrgId());
						fa.setMsg(msg);
						msgFeedList.add(fa);
						break;
					}
				}
			}
			Map map = new HashMap();

			map.put("totalcount", totalcount);
			map.put("totalpage", totalcount / Integer.parseInt(pagecount));
			map.put("msgFeedList", msgFeedList);
			return JSONArray.fromObject(map).toString();
			
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	
	@RequestMapping("/feedmsg")
	@ResponseBody
	public String feedmsgController(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("feedsController acclist method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String module = request.getParameter("module");
		String rowid = request.getParameter("rowid");

		logger.info("ExpenseController list method openId =>" + openId);
		logger.info("ExpenseController list method publicId =>" + publicId);
		logger.info("ExpenseController list method module =>" + module);
		logger.info("ExpenseController list method rowid =>" + rowid);

		// 绑定对象
		String crmId = cRMService.getSugarService().getFeedsService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		//error 对象
		CrmError crmErr = new CrmError();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Feeds feed = new Feeds();
			feed.setCrmId(crmId);
			feed.setRowid(rowid);
			feed.setModule(module);
			FeedsResp fResp = cRMService.getSugarService().getFeedsService().getFeedById(feed);
			String errorCode = fResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<FeedsAdd> list = fResp.getFeedList();
				// 放到页面上
				if (null != list && list.size() > 0) {
					return JSONArray.fromObject(list).toString();
				}
			}else{
				crmErr.setErrorCode(fResp.getErrcode());
				crmErr.setErrorMsg(fResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	

	/**
	 *
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/detail")
	public String detailController(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("feedsController acclist method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String module = request.getParameter("module");
		String rowid = request.getParameter("rowid");
		String objid = request.getParameter("objid");
		String objname = request.getParameter("objname");

		if (null != objname && !"".equals(objname)) {
			objname = new String(objname.getBytes("ISO-8859-1"), "UTF-8");
		}

		logger.info("ExpenseController list method openId =>" + openId);
		logger.info("ExpenseController list method publicId =>" + publicId);
		logger.info("ExpenseController list method module =>" + module);
		logger.info("ExpenseController list method rowid =>" + rowid);
		logger.info("ExpenseController list method objid =>" + objid);
		logger.info("ExpenseController list method objname =>" + objname);

		// 绑定对象
		String crmId = cRMService.getSugarService().getFeedsService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Feeds feed = new Feeds();
			feed.setCrmId(crmId);
			feed.setRowid(rowid);
			feed.setModule(module);
			//根据ID查询feeds
			FeedsResp fResp = cRMService.getSugarService().getFeedsService().getFeedById(feed);
			String errorCode = fResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<FeedsAdd> list = fResp.getFeedList();
				// 放到页面上
				if (null != list && list.size() > 0) {
					request.setAttribute("feedList", list);
				} else {
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
			    throw new Exception("错误编码：" + fResp.getErrcode() + "，错误描述：" + fResp.getErrmsg());
			}
			
			//获取当前操作用户
			UserReq currReq = new UserReq();
			currReq.setCrmaccount(crmId);
			currReq.setFlag("single");
			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
			currReq.setCurrpage("1");
			currReq.setPagecount("1000");
			//查询用户列表
			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
			if(null != currResp.getUsers() && null != currResp.getUsers().get(0).getUsername()){
				request.setAttribute("assigner", currResp.getUsers().get(0).getUsername());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}

		// requestinfo
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		request.setAttribute("rowid", rowid);
		request.setAttribute("module", module);
		request.setAttribute("objid", objid);
		request.setAttribute("objname", objname);

		return "feed/detail";
	}

	private String name;
	private String rowid;
	private String username;
	
	@RequestMapping("/reply")
	@ResponseBody
	public String syncFeedMsgController(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("CustomerController acclist method begin=>");
		
		String crmId = request.getParameter("crmId");
		String module = request.getParameter("module");
		String msg = request.getParameter("msg");

		rowid = request.getParameter("rowid");
		name = request.getParameter("name");
		username = request.getParameter("username");
		if (null != name && !"".equals(name)) {
			name = new String(name.getBytes("ISO-8859-1"), "UTF-8");
		}
		if (null != username && !"".equals(username)) {
			username = new String(username.getBytes("ISO-8859-1"), "UTF-8");
		}else{
			username = "有人";
		}
		
		logger.info("syncFeedsController list method crmId =>" + crmId);
		logger.info("syncFeedsController list method module =>" + module);
		logger.info("syncFeedsController list method rowid =>" + rowid);
		logger.info("syncFeedsController list method msg =>" + msg);
		logger.info("crmId:-> is =" + crmId);
		
		//错误对象
		CrmError crmErr = new CrmError();
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			Feeds feed = new Feeds();
			feed.setCrmId(crmId);
			feed.setRowid(rowid);
			feed.setModule(module);
			feed.setReply(msg);
			FeedsResp fResp = cRMService.getSugarService().getFeedsService().replyFeed(feed);
			// 放到页面上
			crmErr.setErrorCode(fResp.getErrcode());
			crmErr.setErrorMsg(fResp.getErrmsg());
			return JSONObject.fromObject(crmErr).toString();
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			return JSONObject.fromObject(crmErr).toString();
		}
	}
	
	/**
	 *
	 * 新消息列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/msglist")
	public String msgListController(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("feedsController acclist method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String lasttime = request.getParameter("lasttime");

		logger.info("ExpenseController list method openId =>" + openId);
		logger.info("ExpenseController list method publicId =>" + publicId);

		// 绑定对象
		String crmId = cRMService.getSugarService().getFeedsService().getCrmId(openId, publicId);
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			//插入时间
			Message msg = new Message();
			msg.setId(Get32Primarykey.getRandom32BeginTimePK());
			msg.setCrmId(crmId);
			msg.setMsgType(Constants.MESSAGE_TYPE_1);
			msg.setLastTime(DateTime.currentDate());
			cRMService.getDbService().getMessageService().addObj(msg);
			
			//查询feeds列表
			Feeds feed = new Feeds();
			feed.setCrmId(crmId);
			feed.setLasttime(lasttime);
			FeedsResp fResp = cRMService.getSugarService().getFeedsService().getNewFeedList(feed);
			String errorCode = fResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				request.setAttribute("feedList", fResp.getFeedList());
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}

		// requestinfo
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);

		return "feed/msglist";
	}
	
	/**
	 * 用户订阅
	 * @return
	 */
	@RequestMapping("/saveSub")
	@ResponseBody
	public String saveSub(Subscribe subscribe ,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = subscribe.getOpenId();
		String publicId = subscribe.getPublicId();
		String crmId = cRMService.getSugarService().getFeedsService().getCrmId(openId, publicId);
		CrmError crmError = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			String id = cRMService.getDbService().getSubscribeService().addObj(subscribe);
			if(StringUtils.isNotNullOrEmptyStr(id)){
				crmError.setErrorCode("0");
			}else{
				crmError.setErrorCode("1000000");
				crmError.setErrorMsg("操作失败");
			}
		}else{
			crmError.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmError.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmError).toString();
	}
	
	/**
	 * 用户订阅
	 * @return
	 */
	@RequestMapping("/save")
	@ResponseBody
	public String save(Subscribe subscribe ,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = subscribe.getOpenId();
		String publicId = subscribe.getPublicId();
		String crmId = cRMService.getSugarService().getFeedsService().getCrmId(openId, publicId);
		CrmError crmError = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			String id = cRMService.getDbService().getSubscribeService().addObj(subscribe);
			if(StringUtils.isNotNullOrEmptyStr(id)){
				crmError.setErrorCode("0");
			}else{
				crmError.setErrorCode("1000000");
				crmError.setErrorMsg("操作失败");
			}
		}else{
			crmError.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmError.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmError).toString();
	}
	
	/**
	 * 用户取消订阅
	 * @return
	 */
	@RequestMapping("/delSub")
	@ResponseBody
	public String delSub(Subscribe subscribe ,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = subscribe.getOpenId();
		String publicId = subscribe.getPublicId();
		String crmId = cRMService.getSugarService().getFeedsService().getCrmId(openId, publicId);
		String flag = request.getParameter("flag");
		CrmError crmError = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			try {
				cRMService.getDbService().getSubscribeService().deleteObjById(subscribe.getFeedid());
				 cRMService.getWxService().getWxHttpConUtil().removeSubFlag(crmId+";"+subscribe.getFeedid());
				if("endRecoed".equals(flag)){
					subscribe.setFeedid(null);
					subscribe.setCurrpages(0);
					subscribe.setPagecounts(999999999);
					List<String> list = (List<String>)cRMService.getDbService().getSubscribeService().findObjListByFilter(subscribe);
					if(list!=null&&list.size()>0){
						crmError.setErrorCode("0");
						crmError.setErrorMsg("notEndRecoed");
					}
				}else{
					crmError.setErrorCode("0");
				}
			} catch (Exception e) {
				throw new Exception("操作失败!");
			}
		}else{
			crmError.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmError.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmError).toString();
	}
	
	
	/**
	 * 用户是否订阅
	 */
	@RequestMapping("/isSub")
	@ResponseBody
	private String isSub(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String crmId = request.getParameter("crmId");
		String feedid = request.getParameter("feedid");
		Map  map = new HashMap();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			try {
				String rst = cRMService.getWxService().getWxHttpConUtil().getCrmUserSubFlag(crmId+";"+feedid);
				Subscribe subscribe = new Subscribe();
				subscribe.setFeedid(feedid);
				int count=cRMService.getDbService().getSubscribeService().countObjByFilter(subscribe);
				map.put("errorCode", "0");
				map.put("errorMsg", rst);
				map.put("count", count);
			} catch (Exception e) {
				throw new Exception("操作失败!");
			}
		}else{
			map.put("errorCode", ErrCode.ERR_CODE_1001001);
			map.put("errorMsg", ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(map).toString();
	}
}
