package com.takshine.wxcrm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.TeamPeason;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.domain.cache.CacheContact;
import com.takshine.wxcrm.domain.cache.CacheContract;
import com.takshine.wxcrm.domain.cache.CacheCustomer;
import com.takshine.wxcrm.domain.cache.CacheExpense;
import com.takshine.wxcrm.domain.cache.CacheOppty;
import com.takshine.wxcrm.domain.cache.CacheQuote;
import com.takshine.wxcrm.domain.cache.CacheSchedule;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.service.CacheContactService;
import com.takshine.wxcrm.service.CacheContractService;
import com.takshine.wxcrm.service.CacheCustomerService;
import com.takshine.wxcrm.service.CacheOpptyService;
import com.takshine.wxcrm.service.CacheQuoteService;
import com.takshine.wxcrm.service.CacheScheduleService;
import com.takshine.wxcrm.service.DcCrmOperatorService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.TeamPeasonService;
import com.takshine.wxcrm.service.WxRespMsgService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 消息  页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/msgs")
public class MessagesController {
	    // 日志
		protected static Logger logger = Logger.getLogger(MessagesController.class.getName());
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		/**
		 *  新增 消息
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/save")
		@ResponseBody
		public String save(Messages msg, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("messages controller save=>" + msg.getOpenId());
			msg.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			logger.info("messages controller save isatten=>" + msg.getIsatten());
			String schetype = request.getParameter("schetype");
			String uname = msg.getUsername();
			uname = (null != uname) ? uname.trim() : "";
			DcCrmOperator tmp = getSendUserName(UserUtil.getCurrUser(request).getOpenId(),msg.getRelaModule(),msg.getRelaId());
			if(StringUtils.isNotNullOrEmptyStr(msg.getIsatten()) && "Y".equals(msg.getIsatten())){
				if(null != tmp && StringUtils.isNotNullOrEmptyStr(tmp.getOpName())){
					msg.setUsername(tmp.getOpName());
					msg.setUserId(tmp.getCrmId());
				}else{
					if(!"".equals(uname)&&!StringUtils.regZh(uname)){
						msg.setUsername(new String(uname.getBytes("ISO-8859-1"),"UTF-8"));
					}else if(!StringUtils.isNotNullOrEmptyStr(uname)){
						//如果用户未关注，则在DCCRM表中没有数据，则查询微信用户表
						WxuserInfo wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(msg.getUserId());
						if(StringUtils.isNotNullOrEmptyStr(wxuser.getNickname())){
							msg.setUsername(wxuser.getNickname());
						}else{
							msg.setUsername("匿名用户");
						}
					}
				}
			}else{
				if(!"".equals(uname)&&!StringUtils.regZh(uname)){
					msg.setUsername(new String(uname.getBytes("ISO-8859-1"),"UTF-8"));
				}else if(!StringUtils.isNotNullOrEmptyStr(uname)){
					//如果用户未关注，则在DCCRM表中没有数据，则查询微信用户表
					WxuserInfo wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(msg.getUserId());
					if(StringUtils.isNotNullOrEmptyStr(wxuser.getNickname())){
						msg.setUsername(wxuser.getNickname());
					}else{
						msg.setUsername("匿名用户");
					}
				}
			}
			msg.setOrgId(tmp.getOrgId());
			String tuname = msg.getTargetUName();
			tuname = (null != tuname) ? tuname : "";
			if(!"".equals(tuname)&&!StringUtils.regZh(tuname)){
				msg.setTargetUName(new String(tuname.getBytes("ISO-8859-1"),"UTF-8"));
			}
			String content = msg.getContent();
			content = (null != content) ? content : "";
			if(!"".equals(content)&&!StringUtils.regZh(content)){
				msg.setContent(new String(content.getBytes("ISO-8859-1"),"UTF-8"));
			}

			//如果是发送业务消息，targetUID设置为空
			if("customer".equals(msg.getRelaModule()) || "Accounts".equals(msg.getRelaModule()) || "contract".equals(msg.getRelaModule()) || "Opportunities".equals(msg.getRelaModule())
					|| "contact".equals(msg.getRelaModule()) || "quote".equals(msg.getRelaModule()) || "schedule".equals(msg.getRelaModule()) || "Activity".equals(msg.getRelaModule()) ||"ManageActivity".equals(msg.getRelaModule())
					|| "WorkReport".equals(msg.getRelaModule()) || "expense".equals(msg.getRelaModule())){
				//msg.setTargetUId(msg.getUserId());
				//msg.setTargetUName(msg.getUsername());
				//msg.setReadFlag("Y");
				msg.setTargetUId("");
				msg.setTargetUName("");
			}
			//消息发送人设置为partyId
			msg.setUserId(UserUtil.getCurrUser(request).getParty_row_id());
			if(StringUtils.isNotNullOrEmptyStr(msg.getRelaName())){
				msg.setRelaName(new String(msg.getRelaName().getBytes("ISO-8859-1"),"UTF-8"));
			}
			msg.setCreateTime(DateTime.currentDate());
			//save
			String id = cRMService.getDbService().getMessagesService().addObj(msg);
			logger.info("MessageController save method id =>" + id);
			//给各个成员发送客服消息
			sendCustMsg(msg, id,schetype,request);
			
			return id;
		}
		
		/**
		 * 获取消息发送者名字
		 * @param userid
		 * @param module
		 * @param rowid
		 * @return
		 */
		private DcCrmOperator getSendUserName(String openId,String module,String rowid){
			//获取orgId
			String orgId = "";
			if("customer".equals(module) || "Accounts".equals(module)){//客户
				CacheCustomer cu = cRMService.getDbService().getCacheCustomerService().getCrmIdByRowId(rowid);
				orgId = cu.getOrg_id();
			}else if("contract".equals(module)){
				CacheContract cacheContract = cRMService.getDbService().getCacheContractService().getCrmIdByRowId(rowid);
				orgId = cacheContract.getOrg_id();
			}else if("Opportunities".equals(module)){
				CacheOppty cacheOppty = cRMService.getDbService().getCacheOpptyService().getCrmIdByRowId(rowid);
				orgId = cacheOppty.getOrg_id();
			}else if("contact".equals(module)){
				CacheContact cacheContact = cRMService.getDbService().getCacheContactService().getCrmIdByRowId(rowid);
				orgId = cacheContact.getOrg_id();
			}else if("quote".equals(module)){
				CacheQuote cacheQuote = cRMService.getDbService().getCacheQuoteService().getCrmIdByRowId(rowid);
				orgId = cacheQuote.getOrg_id();
			}else if("schedule".equals(module)){
				CacheSchedule cacheSchedule = cRMService.getDbService().getCacheScheduleService().getCrmIdByRowId(rowid);
				orgId = cacheSchedule.getOrg_id();
			}else if("Activity".equals(module)){
				orgId = (String)RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+rowid);
			}else if("ManageActivity".equals(module)){
				orgId = (String)RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+rowid);
			}else if("WorkReport".equals(module)){
				orgId = RedisCacheUtil.getString(Constants.ZJWK_WORKPLAN_ROWID_RELA_ORGID+rowid);
			}else if("expense".equals(module))	{
				CacheExpense cacheExpense = cRMService.getDbService().getCacheExpenseService().getCrmIdByRowId(rowid);
				orgId = cacheExpense.getOrg_id();
			}
			else{
				return null;
			}
			
//			if(StringUtils.isNotNullOrEmptyStr(RedisCacheUtil.getString(openId+"_"+orgId))){
//				return RedisCacheUtil.getString(openId+"_"+orgId);
//			}
			//根据openId,orgid获取名字
			DcCrmOperator dm = new DcCrmOperator();
			dm.setOrgId(orgId);
			dm.setOpenId(openId);
			dm = cRMService.getDbService().getDcCrmOperatorService().findDcCrmOperatorByOpenId(dm);
			if(dm == null){
				dm =  new DcCrmOperator(); 
			}
			dm.setOrgId(orgId);
			//如果用户未关注，则在DCCRM表中没有数据，则查询微信用户表
			if(!StringUtils.isNotNullOrEmptyStr(dm.getOpName())){
				WxuserInfo wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId);
				if(StringUtils.isNotNullOrEmptyStr(wxuser.getNickname())){
					dm.setOpName(wxuser.getNickname());
				}else{
					dm.setOpName("匿名用户");
				}
			}
			//存入缓存
//			if(StringUtils.isNotNullOrEmptyStr(dm.getOpName())){
//				RedisCacheUtil.setString(openId+"_"+orgId, dm.getOpName());				
//			}else{
//				return null;
//			}
			return dm;
		}

		
		/**
		 * 发送客服消息
		 * @param msg
		 * @param id
		 */
		private void sendCustMsg(Messages msg, String id,String schetype,HttpServletRequest request) throws Exception{
			
			sendCustMsg2TeamPer(msg, id,schetype,request);//发送客服消息给团队成员
			logger.info("messages controller save=>" + msg.getOpenId());
			sendCustMsg2Atten(msg, id, schetype,request);
		}
		
		/**
		 * 发送客服消息给团队成员
		 * @param msg
		 * @param id
		 */
		private void sendCustMsg2TeamPer(Messages msg, String id,String schetype,HttpServletRequest request) throws Exception{
			//查询当前任务下关联的共享用户
			Share share = new Share();
			share.setParentid(msg.getRelaId());
			share.setParenttype(modelNameTransf(msg.getRelaModule()));
			share.setCrmId(msg.getOwnerCrmId());
			//查询分享的用户名
			ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
			List<ShareAdd> shareAdds = sresp.getShares();
			String currPartyId = UserUtil.getCurrUser(request).getParty_row_id();
			//遍历用户列表
			for (int i = 0; i < shareAdds.size(); i++) {

				ShareAdd add = shareAdds.get(i);
				String uid = add.getShareuserid();
				
				String oid = cRMService.getWxService().getWxUserinfoService().getOpenIdByCrmId(uid);
				String partyId = cRMService.getWxService().getWxUserinfoService().getPartyRowId(oid);
				//不给自己发
				if(partyId.equals(currPartyId)) continue;
				
				//记录消息
				if(StringUtils.isNotNullOrEmptyStr(partyId)){
					msg.setTargetUId(partyId);
					cRMService.getDbService().getMessagesService().addObj(msg);
				}
				
				String param="";
				
				if("Opportunities".equals(msg.getRelaModule())){
					msg.setRelaModule("oppty");
				}
				else if("Accounts".equals(msg.getRelaModule())){
					msg.setRelaModule("customer");
				}
				else if("Cases".equals(msg.getRelaModule())){
					msg.setRelaModule("complaint");
				}
				else if("schedule".equals(msg.getRelaModule())){
					param = "&schetype="+schetype;
				}
				else if("Campaigns".equals(msg.getRelaModule())){
					msg.setRelaModule("campaigns");
				}
				else if("Activity".equals(msg.getRelaModule())){
					msg.setRelaModule("zjactivity");
				}else if("WorkReport".equals(msg.getRelaModule())){
					msg.setRelaModule("workplan");
				}
				
				
				
				String cont = msg.getUsername()+ " 回复消息：\r\n" + subStr(msgTransf(msg.getMsgType(), msg.getContent()));
				if(null != msg.getMsgType() && ("img".equals(msg.getMsgType()) || "doc".equals(msg.getMsgType()))){
					cont = msg.getUsername()+ " " + subStr(msgTransf(msg.getMsgType(), msg.getContent()));
				}
				
				String url = "/"+msg.getRelaModule()+"/detail?rowId="+msg.getRelaId()+"&rowid="+msg.getRelaId()+"&orgId="+msg.getOrgId()+param;
				//发送客服消息
				//cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(uid, cont, url);
				cRMService.getWxService().getWxRespMsgService().respCommCustMsgByOpenId(oid, msg.getOwnerOpenId(), PropertiesUtil.getAppContext("app.publicId"), cont, url);
			}
		}
		
		/**
		 * 发送客服消息给团队成员
		 * @param msg
		 * @param id
		 */
		@SuppressWarnings("unchecked")
		private void sendCustMsg2Atten(Messages msg, String id,String schetype,HttpServletRequest request) throws Exception{
			logger.info("messages controller save3=>" + msg.getOpenId());
			TeamPeason peason = new TeamPeason();
			peason.setRelaId(msg.getRelaId());
			List<TeamPeason> plist = (List<TeamPeason>)cRMService.getDbService().getTeamPeasonService().findObjListByFilter(peason);
			for(int i =0; i < plist.size() ; i ++){
				TeamPeason p = plist.get(i);
				String openid = p.getOpenId();
				String partyId = p.getParty_row_id();
				//发送给自己 就跳过
				if(msg.getOpenId().equals(openid)){
					continue;
				}
				
				//记录消息
				if(StringUtils.isNotNullOrEmptyStr(partyId)){
					msg.setTargetUId(partyId);
					cRMService.getDbService().getMessagesService().addObj(msg);
				}
				
				if("Opportunities".equals(msg.getRelaModule())){
					msg.setRelaModule("oppty");
				}
				else if("Accounts".equals(msg.getRelaModule())){
					msg.setRelaModule("customer");
				}
				else if("Cases".equals(msg.getRelaModule())){
					msg.setRelaModule("complaint");
				}
				else if("Campaigns".equals(msg.getRelaModule())){
					msg.setRelaModule("campaigns");
				}else if("WorkReport".equals(msg.getRelaModule())){
					msg.setRelaModule("workplan");
				}
				String param = ""; //关注用户的openid
				if("schedule".equals(msg.getRelaModule())){
					param += "&schetype="+schetype;
				}
				
				String cont = msg.getUsername()+ " 回复消息：\r\n" + subStr(msgTransf(msg.getMsgType(), msg.getContent()));
				if(null != msg.getMsgType() && ("img".equals(msg.getMsgType()) || "doc".equals(msg.getMsgType()))){
					cont = msg.getUsername()+ " " + subStr(msgTransf(msg.getMsgType(), msg.getContent()));
				}
				String url = "/"+msg.getRelaModule()+"/detail?rowId="+msg.getRelaId()+"&orgId="+msg.getOrgId()+param;
				
				logger.info("messages controller save4=>" + msg.getOpenId());
				logger.info("messages controller save4 ownerOpenId=>" + msg.getOwnerOpenId());
				cRMService.getWxService().getWxRespMsgService().respCommCustMsgByOpenId(openid, msg.getOwnerOpenId(), PropertiesUtil.getAppContext("app.publicId"), cont, url);
			}
			
		}
		
		/**
		 * 模块名转换
		 * @param sourName
		 */
		private String modelNameTransf(String sourName){
			if(null == sourName || "".equals(sourName)){
				return "";
			}
			if("schedule".equals(sourName)){
				return "Tasks";
			}
			if("oppty".equals(sourName)){
				return "Opportunities";
			}
			if("customer".equals(sourName)){
				return "Accounts";
			}
			if("contact".equals(sourName)){
				return "Contacts";
			}
			if("contract".equals(sourName)){
				return "Contract";
			}
			if("project".equals(sourName)){
				return "Project";
			}
			if("campaigns".equals(sourName)){
				return "Campaigns";
			}
			if("activity".equals(sourName)){
				return "Activity";
			}
			if("weekreport".equals(sourName)){
				return "WeekReport";
			}
			if("quote".equals(sourName)){
				return "Quote";
			}
			logger.info("sourName = >" + sourName);
			return sourName;
		}
		
		private String msgTransf(String msgType, String content){
			if(null != msgType && "img".equals(msgType)){
				return "上传了一个图片";
			}
			if(null != msgType && "doc".equals(msgType)){
				return "上传了一个文件";
			}
			return content;
		}
		
		/**
		 * 消息截串
		 * @param str
		 * @return
		 */
		private String subStr(String str){
			if(null !=str && str.length() > 200){
				return str.substring(0, 200) + "...";
			}
			return str;
		}
		
		/**
		 * 异步获取 消息数据 列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping("/asynclist")
		@ResponseBody
		public String asynclist(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("MessageController asynclist method begin=>");
			String relaModule = request.getParameter("relaModule");
			String relaId = request.getParameter("relaId");
			String subRelaId = request.getParameter("subRelaId");
			       subRelaId = "".equals(subRelaId) ? null : subRelaId;
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String readFlag = request.getParameter("readFlag");
			       currpage = (null == currpage ? "0" : currpage);
			       pagecount = (null == pagecount ? "10" : pagecount);
			       
			logger.info("relaModule := >" + relaModule);
			logger.info("relaId := >" + relaId);
			logger.info("subRelaId := >" + subRelaId);
			//组装查询参数
			Messages obj = new Messages();
			obj.setRelaId(relaId);
			obj.setSubRelaId(subRelaId);
			obj.setRelaModule(relaModule);
			obj.setCurrpages(Integer.parseInt(currpage));
			obj.setPagecounts(Integer.parseInt(pagecount));
			obj.setReadFlag(readFlag);
			//调用后台查询数据库
			List<Messages> mlist = (List<Messages>)cRMService.getDbService().getMessagesService().findObjListByFilter(obj);
			String rst = "[]";
			// 放到页面上
			if (null != mlist && mlist.size() > 0) {
				rst = JSONArray.fromObject(mlist).toString();
			}
			
			//更新消息标志(根据targetUID更新)
			if(UserUtil.hasCurrUser(request)){
				obj.setTargetUId(UserUtil.getCurrUser(request).getParty_row_id());
				cRMService.getDbService().getMessagesService().updateMessagesFlag(obj);
			}
			return rst;
		}
		
		

		
		/**
		 * 获取消息总数
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/countmsg")
		@ResponseBody
		public String countmsg(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("MessageController asynclist method begin=>");
			String relaModule = request.getParameter("relaModule");
			String relaId = request.getParameter("relaId");
			String readFlag = request.getParameter("readFlag");
			       
			logger.info("relaModule := >" + relaModule);
			logger.info("relaId := >" + relaId);
			//组装查询参数
			Messages obj = new Messages();
			obj.setRelaId(relaId);
			obj.setRelaModule(relaModule);
			obj.setReadFlag(readFlag);
			//调用后台查询数据库
			int msgCount = cRMService.getDbService().getMessagesService().countObjByFilter(obj);
			
			return msgCount+"";
		}
		
		
		/**
		 * 异步获取 最后一条未读读消息数据
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping("/syncmsglist")
		@ResponseBody
		public String syncmsglist(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("MessageController syncmsglist method begin=>");
			//String crmId = request.getParameter("crmId");
			String openId=UserUtil.getCurrUser(request).getOpenId();
			String relaModule = request.getParameter("relaModule");
			String relaId = request.getParameter("relaId");	       
			logger.info("relaModule := >" + relaModule);
			logger.info("relaId := >" + relaId);
			String lastVisitTime=(String) RedisCacheUtil.get("WK_"+relaModule+"_"+openId+"_"+relaId);
		/*	logger.info("subRelaId := >" + subRelaId);*/
			//组装查询参数
			Messages obj = new Messages();
			obj.setRelaId(relaId);
			/*obj.setSubRelaId(subRelaId);*/
			obj.setCurrpages(0);
			obj.setPagecounts(1);
			//调用后台查询数据库
			List<Messages> mlist = (List<Messages>)cRMService.getDbService().getMessagesService().findObjListByFilter(obj);
			String rst = "";
			// 放到页面上
			if (null != mlist && mlist.size() > 0) {
				Map map =new HashMap();
				int count =0;
				if(lastVisitTime!=null&&!"".equals(lastVisitTime)){
					obj.setCreateTime(DateTime.str2DateTime(lastVisitTime));
					obj.setOwnerOpenId(openId);
					count =cRMService.getDbService().getMessagesService().countObjByFilter(obj);
				}
				map.put("count",count);
				map.put("username", mlist.get(0).getUsername());
				map.put("content", mlist.get(0).getContent());
				rst = JSONArray.fromObject(map).toString();
			}
			//更新消息标志
			return rst;
		}
		
		
		/**
		 * 异步获取 未读消息数
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping("/syncmsgcount")
		@ResponseBody
		public String syncmsgcount(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String openId=UserUtil.getCurrUser(request).getOpenId();
			String relaModule = request.getParameter("relaModule");
			String relaId = request.getParameter("relaId");	       
			logger.info("relaModule := >" + relaModule);
			logger.info("relaId := >" + relaId);
			String lastVisitTime=(String) RedisCacheUtil.get("WK_"+relaModule+"_"+openId+"_"+relaId);
			Messages obj = new Messages();
			obj.setRelaId(relaId);
			obj.setCurrpages(0);
			obj.setPagecounts(1);
			// 放到页面上
			int count =0;
			if(lastVisitTime!=null&&!"".equals(lastVisitTime)){
				obj.setCreateTime(DateTime.str2DateTime(lastVisitTime));
				obj.setOwnerOpenId(openId);
				count =cRMService.getDbService().getMessagesService().countObjByFilter(obj);
			}
			return count+"";
		}
		
		/**
		 * 查询消息总条数
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/count")
		@ResponseBody
		public String count(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String relaId = request.getParameter("relaId");
			String relaModule = request.getParameter("relaModule");
			Messages message = new Messages();
			message.setRelaId(relaId);
			message.setRelaModule(relaModule);
			message.setCurrpages(Constants.ZERO);
			message.setPagecounts(Constants.ALL_PAGECOUNT);
			message.setTargetUId(UserUtil.getCurrUser(request).getParty_row_id());
			int count = cRMService.getDbService().getMessagesService().countObjByFilter(message);
			return count+"";
		}
		
		@RequestMapping(value = "/delmsg")
		@ResponseBody
		public String delmsg(Messages msg ,HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			if(StringUtils.isNotNullOrEmptyStr(msg.getId())){
				cRMService.getDbService().getMessagesService().deleteObjById(msg.getId());
				return "success";
			}
			return "fail";
		}
		
		
		
		/**
		 * 异步获取 消息数据 列表
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping("/readmsg")
		@ResponseBody
		public String readmsg(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String readFlag = request.getParameter("readFlag");
			currpage = (null == currpage ? "0" : currpage);
			pagecount = (null == pagecount ? "50" : pagecount);
			       
			//组装查询参数
			Messages obj = new Messages();
			obj.setCurrpages(Integer.parseInt(currpage));
			obj.setPagecounts(Integer.parseInt(pagecount));
			obj.setTargetUId(UserUtil.getCurrUser(request).getParty_row_id());
			obj.setReadFlag(readFlag);
			//调用后台查询数据库
			List<Messages> mlist = (List<Messages>)cRMService.getDbService().getMessagesService().searchSystemMessages(obj);
			String rst = "[]";
			// 放到页面上
			if (null != mlist && mlist.size() > 0) {
				rst = JSONArray.fromObject(mlist).toString();
			}
//			obj = new Messages();
//			//更新消息标志(根据targetUID更新)
//			obj.setTargetUId(UserUtil.getCurrUser(request).getParty_row_id());
//			cRMService.getDbService().getMessagesService().updateMessagesFlag(obj);
			
			return rst;
		}
		
		
		/**
		 * 更新未读标志
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/updReadFlg")
		@ResponseBody
		public String updateMsgReadFlg(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			Messages obj = new Messages();
			//如果有传入消息id则根据消息id更新标志
			String msgid = request.getParameter("msgid");
			if (StringUtils.isNotNullOrEmptyStr(msgid))
			{
				obj.setId(msgid);
			}
			else
			{
				//更新消息标志(根据targetUID更新)
				obj.setTargetUId(UserUtil.getCurrUser(request).getParty_row_id());
			}

			cRMService.getDbService().getMessagesService().updateMessagesFlag(obj);
			
			return "success";
		}
		
		@RequestMapping(value = "/delallmsg")
		@ResponseBody
		public String delallmsg(Messages msg ,HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			Messages obj = new Messages();
			//更新消息标志(根据targetUID更新)
			obj.setTargetUId(UserUtil.getCurrUser(request).getParty_row_id());
			cRMService.getDbService().getMessagesService().deleteMessagesByTargetUId(obj);
			return "success";
		}
}
