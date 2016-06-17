/**
 * com.takshine.jf.controller.LoginController.java
 * COPYRIGHT © 2014 TAKSHINE.com Inc.,ALL RIGHTS RESERVED. 
 * 北京德成鸿业咨询服务有限公司版权所有.
 */
package com.takshine.wxcrm.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.MessagesService;

/**
 * 个人私信留言
 * @author [liulin Date:2014-01-10]
 */

@Controller
@RequestMapping("/personalmsg")
public class PersonalMsgController {
	// 日志
	protected static Logger log = Logger.getLogger(PersonalMsgController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 保存私信和留言
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savepersonalmsg")
	@ResponseBody
	public String savepersonalmsg(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		WxuserInfo wxu = UserUtil.getCurrUser(request);
		String type = request.getParameter("type");
		String bid = request.getParameter("bid");
		String content = request.getParameter("content");
		if(StringUtils.isNotBlank(content)){
			content = new String(content.getBytes("iso-8859-1"), "utf-8");
		}
		String relaid = request.getParameter("relaid");
		log.info("type = >" + type);
		log.info("bid = >" + bid);
		log.info("content = >" + content);
		log.info("relaid = >" + relaid);
		
		String tui = "", tname = "";
        tui = request.getParameter("tid");
        tname = request.getParameter("tname");
        if(StringUtils.isNotBlank(tname)){
        	tname = new String(tname.getBytes("iso-8859-1"), "utf-8");
		}
		if(StringUtils.isNotBlank(bid)){
			//查名片信息
			BusinessCard bc = new BusinessCard();
			bc.setId(bid);
			Object bcobj = cRMService.getDbService().getBusinessCardService().findObj(bc);
			if(bcobj != null){
				bc = (BusinessCard)bcobj;
				tui = bc.getPartyId();
				tname = bc.getName();
			}
		}
		log.info("tui = >" + tui);
		log.info("tname = >" + tname);

		if(StringUtils.isNotBlank(tui) && StringUtils.isNotBlank(content)){
			if("System_Personal_Msg".equals(type)){
				//发私信
			 Messages msg=cRMService.getDbService().getMessagesService().sendMsg2(wxu.getParty_row_id(), wxu.getNickname(), tui, tname, content, "System_Personal_Msg", "", "", "txt", "N", DateTime.currentDate(), "");
				
				return JSONObject.fromObject(msg).toString();
			}
			else if("System_Liu_Msg".equals(type)){
				//发留言
				Messages msg=cRMService.getDbService().getMessagesService().sendMsg2(wxu.getParty_row_id(), wxu.getNickname(), tui, tname, content, "System_Liu_Msg", "", "", "txt", "N", DateTime.currentDate(), "");
				return JSONObject.fromObject(msg).toString();
			}
			else if("System_LiuPer_Msg_Reply".equals(type)){
				//留言私信回复
				Messages msg=cRMService.getDbService().getMessagesService().sendMsg2(wxu.getParty_row_id(), wxu.getNickname(), tui, tname, content, "System_LiuPer_Msg_Reply", relaid, "", "txt", "N", DateTime.currentDate(), "");
				return JSONObject.fromObject(msg).toString();
			}
		}
		return "fail";
	}
	
	/**
	 * 保存私信和留言
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delpersonalmsg")
	@ResponseBody
	public String delpersonalmsg(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		log.info("delpersonalmsg = >");
		String relaid = request.getParameter("relaid");
		log.info("relaid = >" + relaid);
		if(StringUtils.isNotBlank(relaid)){
			cRMService.getDbService().getMessagesService().deleteObjById(relaid);
			return "success";	
		}
		return "fail";
	}
	
	
	/**
	 * 私信和留言列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/perliumsglist")
	@ResponseBody
	public String perliumsglist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		WxuserInfo wxu = UserUtil.getCurrUser(request);
		String loginPartyId = wxu.getParty_row_id();
		String tui = request.getParameter("bcpartyid");//查询名片信息
		String pagecounts = request.getParameter("pagecounts");
		String currpages = request.getParameter("currpages");
		if(StringUtils.isBlank(pagecounts)) pagecounts = "10";
		if(StringUtils.isBlank(currpages)) currpages = "0";
		log.info("loginPartyId = >" + loginPartyId);
		log.info("tui = >" + tui);
		log.info("pagecounts = >" + pagecounts);
		log.info("currpages = >" + currpages);
		//留言
		Messages msg = new Messages();
		msg.setRelaModule("System_Liu_Msg");
		msg.setTargetUId(tui);
		msg.setPagecounts(new Integer(pagecounts));
		msg.setCurrpages(new Integer(currpages));
		List<Messages> liulist = (List<Messages>)cRMService.getDbService().getMessagesService().findObjListByFilter(msg);
		log.info("liulist size = >" + liulist.size());
		//私信
		if(StringUtils.isNotBlank(tui) && tui.equals(loginPartyId)){
			msg.setRelaModule("System_Personal_Msg");
			List<Messages> perlist = (List<Messages>)cRMService.getDbService().getMessagesService().findObjListByFilter(msg);
			log.info("perlist size = >" + perlist.size());
			liulist.addAll(perlist);
		}
		for(Messages obj: liulist){
			if("N".equals(obj.getReadFlag())){//把未读消息更新为已读
				cRMService.getDbService().getMessagesService().updateMessagesFlag(obj);
			}
		}
		String rst = JSONArray.fromObject(liulist).toString();
		log.info("rst = >" + rst);
		return rst;
	}
	
	/**
	 * 回复列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/replymsglist")
	@ResponseBody
	public String replymsglist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		WxuserInfo wxu = UserUtil.getCurrUser(request);
		String loginPartyId = wxu.getParty_row_id();
		String relaid = request.getParameter("relaid");
		String userid = request.getParameter("userid");
		log.info("loginPartyId = >" + loginPartyId);
		log.info("relaid = >" + relaid);
		log.info("userid = >" + userid);
		//留言
		Messages msg = new Messages();
		msg.setRelaModule("System_LiuPer_Msg_Reply");
		msg.setRelaId(relaid);
		msg.setTargetUId(userid);
		msg.setUserId(userid);
		List<Messages> replymsglist = (List<Messages>)cRMService.getDbService().getMessagesService().findObjListByFilter(msg);
		log.info("replymsglist size = >" + replymsglist.size());
		String rst = JSONArray.fromObject(replymsglist).toString();
		log.info("rst = >" + rst);
		return rst;
	}
	
	/**
	 * 更多 私信和留言列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/personalmsglist")
	public String personalmsglist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		WxuserInfo user = UserUtil.getCurrUser(request);
		request.setAttribute("user",user);
		
		String bcpartyid = request.getParameter("bcpartyid");
		log.info("bcpartyid = >" + bcpartyid	);
		BusinessCard bc = new BusinessCard();
	    bc.setPartyId(bcpartyid);
	    bc.setStatus("0");
	    List<BusinessCard> list = cRMService.getDbService().getBusinessCardService().getList(bc);
	    if(list!=null&&list.size()>0){
	    	bc=list.get(0);
	    }
	    request.setAttribute("BusinessCard",bc);
		return "perslInfo/personalmsglist";
	}
}