package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Activity;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.Campaigns;
import com.takshine.wxcrm.domain.DiscuGroup;
import com.takshine.wxcrm.domain.DiscuGroupExam;
import com.takshine.wxcrm.domain.DiscuGroupNotice;
import com.takshine.wxcrm.domain.DiscuGroupTopic;
import com.takshine.wxcrm.domain.DiscuGroupTopicMsg;
import com.takshine.wxcrm.domain.DiscuGroupUser;
import com.takshine.wxcrm.domain.MessagesExt;
import com.takshine.wxcrm.domain.Resource;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CampaignsAdd;
import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;

/**
 * 讨论组  页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/discuGroup")
public class DiscuGroupController {
	    // 日志
		//protected static Logger log = Logger.getLogger(DiscuGroupController.class.getName());
		
		// discugroup 日志
		private static Log log = LogFactory.getLog("discugroup");
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		/**
		 *  我的主页
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/list")
		public String list(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			log.info("discuGroupService list method  =>");
			return "discugroup/list";
		}
		
		/**
		 *  添加讨论组
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/add")
		public String add(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			log.info("discuGroupService mylist method  =>");
			String openId = UserUtil.getCurrUser(request).getOpenId();
			request.setAttribute("sysAccount", cRMService.getBusinessService().getDiscuGroupMainService().getOrgList(openId));
			request.setAttribute("orgId", "Default Organization");
			return "discugroup/add";
		}
		
		/**
		 *  讨论组详情 从短信链接进来
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/detail_fsms")
		public String detail_fsms(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			ZJWKUtil.getRequestURL(request);
			log.info("discuGroupService detail_fsms method  =>");
			//讨论组
			String rowId = request.getParameter("rowId");
			String orgId = request.getParameter("orgId");
			log.info("rowId = >" + rowId);
			log.info("orgId = >" + orgId);
			if(StringUtils.isNotBlank(rowId)){
				//讨论组详情信息
				request.setAttribute("dg", cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupById(rowId));
				//讨论组用户列表
				request.setAttribute("dgulist", cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupUsers(rowId));
			}
			request.setAttribute("zjmarketing_url", PropertiesUtil.getAppContext("zjmarketing.url"));
			return "discugroup/detail_fsms";
		}
		
		/**
		 *  讨论组详情
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/detail")
		public String detail(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			ZJWKUtil.getRequestURL(request);
			log.info("discuGroupService detail method  =>");
			WxuserInfo currUser = UserUtil.getCurrUser(request);//登陆用户
			request.setAttribute("curr_user", currUser);
			String partyId = currUser.getParty_row_id();
			log.info("partyId  = >" + partyId);
			//讨论组
			String rowId = request.getParameter("rowId");
			String orgId = request.getParameter("orgId");
			log.info("rowId = >" + rowId);
			log.info("orgId = >" + orgId);
			
			if(StringUtils.isNotBlank(rowId)){
				//讨论组基本信息
				DiscuGroup dg = cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupById(rowId);
				//先判断讨论组是否被解散
				if (StringUtils.isBlank(dg.getId()))
				{
					throw new Exception(ErrCode.ERR_CODE_1001007);
				}
				
				request.setAttribute("dg", dg);
				
				//讨论组成员信息
				List<DiscuGroupUser> dgulist = cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupUsers(rowId);
				log.info("dgulist size = >" + dgulist.size());
				request.setAttribute("dgulist", dgulist);//群用户列表
				
				//是否是群主标志
				if(cRMService.getBusinessService().getDiscuGroupMainService().isDiscuOwner(rowId, partyId)){
					request.setAttribute("cu_isdgowner", "yes");//判断是否是群主
					request.setAttribute("cu_isindg", "yes");//判断是否在群里面
				}
				if(cRMService.getBusinessService().getDiscuGroupMainService().isDiscuIn(rowId, partyId)){
					request.setAttribute("cu_isindg", "yes");//判断是否在群里面
				}
				if(cRMService.getBusinessService().getDiscuGroupMainService().isDiscuAdmin(rowId, partyId)){
					request.setAttribute("cu_isdgadmin", "yes");//判断是否是管理员
					request.setAttribute("cu_isindg", "yes");
				}
				//不在讨论组中则查询 审批记录   并且不是群主
				//modify by zhihe 不需要判断群组成员是否为0  &&dgulist.size() == 0 
				if(!partyId.equals(dg.getCreator())
						&& cRMService.getBusinessService().getDiscuGroupMainService().isDiscuAudit(rowId, partyId)){
					request.setAttribute("cu_isaudit_flag", "auditing");//正在审核
				}
				//short url
				request.setAttribute("shorturl", PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+"/entr/access?parentId="+dg.getId()+"&parentType=discuGroup"));
				//消息处理
				cRMService.getBusinessService().getDiscuGroupMainService().handlerMesssageFlag(partyId, rowId);;
			}
			
			request.setAttribute("zjmarketing_url", PropertiesUtil.getAppContext("zjmarketing.url"));
			
			return "discugroup/detail";
		}
		
		/**
		 *  群发信息
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/mass")
		public String mass(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			log.info("discuGroupService mass method  =>");
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			request.setAttribute("dgid", dgid);
			request.setAttribute("appContent", PropertiesUtil.getAppContext("app.content"));
			request.setAttribute("currPartyId", UserUtil.getCurrUserId(request));
			return "discugroup/mass";
		}
		
		/**
		 *  群发信息
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/sendMass")
		public String sendMass(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			log.info("discuGroupService sendMass method  =>");
			String dgid = request.getParameter("dgid");
			String massType = request.getParameter("massType");//获取群发类型
			String relaId = request.getParameter("relaId");//关联资源id
			String messageType = request.getParameter("messageType");//获取消息方式
			if (StringUtils.isBlank(messageType)){
				messageType = "auto";
			}
			log.info("dgid = >" + dgid);
			log.info("massType = >" + massType);
			log.info("relaId = >" + relaId);
			log.info("dgid = >" + dgid);
			if (StringUtils.isNotBlank(dgid) 
					&& StringUtils.isNotBlank(relaId) 
					&& StringUtils.isNotBlank(massType)){
				//群发信息
				cRMService.getBusinessService().getDiscuGroupMainService().sendMassInfo(dgid, UserUtil.getCurrUserId(request), 
																							UserUtil.getCurrUser(request).getNickname(), 
																								relaId, massType);
			}
			return "redirect:/discuGroup/detail?rowId=" +dgid ;
		}
		
		/**
		 *  讨论组管理
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/manage")
		public String manage(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			log.info("discuGroupService manage method  =>");
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			if(StringUtils.isNotBlank(dgid)){
				//判断是不是群主
				if(cRMService.getBusinessService().getDiscuGroupMainService().isDiscuOwner(dgid, UserUtil.getCurrUserId(request))){
					request.setAttribute("cu_isdgowner", "yes");
				}
				//查询标签
				request.setAttribute("addrList", cRMService.getBusinessService().getDiscuGroupMainService().getTagModelList(dgid, "discu_group_addr"));
				request.setAttribute("tagList", cRMService.getBusinessService().getDiscuGroupMainService().getTagModelList(dgid, "discu_group_tag"));
				request.setAttribute("dgid", dgid);
				request.setAttribute("dg", cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupById(dgid));
				
				//话题申请数量
				List<DiscuGroupExam> dgexlist = cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupExams(dgid, "mass_apply");
				request.setAttribute("mass_apply_count", dgexlist.size());
				//申请加精的数量
				dgexlist = cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupExams(dgid, "addess_apply");
				request.setAttribute("addess_apply_count", dgexlist.size());
				//申请入群数量
				dgexlist = cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupExams(dgid, "join_apply");
				request.setAttribute("join_apply_count", dgexlist.size());
				
				//公告数量
				List<DiscuGroupNotice> dgnclist = cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupNotices(dgid);
				request.setAttribute("dg_notice_count", dgnclist.size());
				request.setAttribute("noticeCount", dgnclist.size());
				
				//管理员人列表
				request.setAttribute("dguadminlist", cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupAdminRelaUsers(dgid, UserUtil.getCurrUserId(request)));
				
				//当前用户
				request.setAttribute("curr_user", UserUtil.getCurrUser(request));
			
			}
			return "discugroup/manage";
		}
		
		/**
		 *  退出 讨论组
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/exit")
		@ResponseBody
		public String exit(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			log.info("discuGroupService exit method  =>");
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			if(StringUtils.isNotBlank(dgid)){
				DiscuGroupUser dgu = new DiscuGroupUser();
				dgu.setDis_id(dgid);
				dgu.setUser_id(UserUtil.getCurrUser(request).getParty_row_id());
				dgu.setUser_type("delete");//删除的用户状态
				cRMService.getDbService().getDiscuGroupUserService().updateDiscuGroupUserType(dgu);
				
				//给群主和管理发送申请加入的消息
				List<DiscuGroupUser> userList = cRMService.getBusinessService().getDiscuGroupMainService().getDiscuGroupAdminUsers(dgid);
				for (Iterator iterator = userList.iterator(); iterator
						.hasNext();) {
					DiscuGroupUser obj = (DiscuGroupUser) iterator.next();
					String uid = obj.getUser_id();
					log.info("uid = >" + uid);
					//给发送消息  申请加群
					cRMService.getDbService().getMessagesService().sendMsg(UserUtil.getCurrUser(request).getParty_row_id(), UserUtil.getCurrUser(request).getNickname(), uid, "", UserUtil.getCurrUser(request).getNickname() +"退出了您的讨论组", "Discugroup_ExitGroup", dgid, "", "txt", "N", DateTime.currentDate(), "");
					//推送微信消息
					String url = "/discuGroup/detail?rowId="+dgid;
					WxuserInfo wxuser = new WxuserInfo();
					wxuser.setParty_row_id(uid);
					String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
					log.info("respSimpCustMsg url =>" + url);
					log.info("respSimpCustMsg openId =>" + openId);
					cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, UserUtil.getCurrUser(request).getNickname() +"退出了您的讨论组", url);
				}
				
				return "success";
			}
			return "fail";
		}
		
		/**
		 *  进入邀请好友的列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/conlist")
		public String conlist(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			log.info("discuGroupService manage method  =>");
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			request.setAttribute("dgid", dgid);
			
			//查询联系人 和 好友列表
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			log.info("crmId:-> is =" + crmId);
			// 获取绑定的账户 在sugar系统的id
			if (!"".equals(crmId)) {
				//获取联系人
				List<ContactAdd> list = null;
				/*Contact contact = new Contact();
				contact.setCrmId(crmId);
				contact.setPagecount(null);
				contact.setCurrpage(Constants.ZERO+"");
				contact.setOpenId(UserUtil.getCurrUser(request).getOpenId());
				ContactResp cResp = cRMService.getSugarService().getContact2SugarService().getContactClist(contact,"WEB");
				List<ContactAdd> list = cResp.getContacts();*/
				
				//获取我的好友
				UserRela userRela = new UserRela();
				userRela.setUser_id(UserUtil.getCurrUser(request).getParty_row_id());
				userRela.setCurrpages(Constants.ZERO);
				userRela.setPagecounts(Constants.ALL_PAGECOUNT);
				List<UserRela> userRelaList = (List<UserRela>)cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);
				
				List<String> charList = new ArrayList<String>();
				
				// 放到页面上
				if (null != list && list.size() > 0) {

					ContactAdd con = null;
					for(int i=0;i<list.size();i++){
						con = list.get(i);
						if(con.getFirstname() != null && !charList.contains(con.getFirstname())){
							charList.add(con.getFirstname());
						}
					}
				} else {
					list = new ArrayList<ContactAdd>();
				}
				if(null != userRelaList && userRelaList.size() >0){
					UserRela ur = null;
					for(int i=0;i<userRelaList.size();i++){
						ur = userRelaList.get(i);
						list.add(transUserRela(ur,charList));
					}
				}
				//获取首字母集合
				//首字母排序
				Collections.sort(charList);
				request.setAttribute("contactList", list);
				request.setAttribute("charList", charList);
				
			}
			return "discugroup/conlist";
		}
		
		/**
		 *  保存邀请好友的列表信息
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/saveconlist")
		@ResponseBody
		public String saveconlist(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			log.info("discuGroupService saveconlist method  =>");
			String cids = request.getParameter("cids");
			log.info("cids = >" + cids);
			String dgid = request.getParameter("dgid");
			String dgname = "";
			DiscuGroup dg = new DiscuGroup();
			dg.setId(dgid);
			Object obj = cRMService.getDbService().getDiscuGroupService().findObj(dg);//查询讨论组
			if(obj != null){
				dg = (DiscuGroup)obj;
				dgname = dg.getName();
			}
			log.info("dgid = >" + dgid);
			log.info("dgname = >" + dgname);
			if(StringUtils.isNotBlank(dgid) 
					&& StringUtils.isNotBlank(cids)){
				String [] cidarr = cids.split(",");
				String newcids = "";
				
				//过滤掉已有的成员id
				DiscuGroupUser dgu = new DiscuGroupUser();
				dgu.setDis_id(dgid);
				dgu.setCurr_user_id(UserUtil.getCurrUser(request).getParty_row_id());
				//list
				List<DiscuGroupUser> dguserlist = (List<DiscuGroupUser>)cRMService.getDbService().getDiscuGroupService().findDiscuGroupUserList(dgu);
				
				if (null != dguserlist && !dguserlist.isEmpty())
				{
					for (String temp : cidarr)
					{
						boolean addFlag = true;
						for (DiscuGroupUser user : dguserlist)
						{
							if (temp.equals(user.getUser_id()))
							{
								addFlag = false;
								break;
							}
						}
						
						if (addFlag)
						{
							newcids += temp+",";
						}
					}
				}

				//过滤后的
				cidarr = newcids.split(",");
				
				for(int i = 0; i < cidarr.length ; i++){
					String cid = cidarr[i];
					log.info("cid = >" + cid);
					//邀请朋友入群
					if(StringUtils.isNotBlank(cid)){
						cRMService.getDbService().getMessagesService().sendMsg(curruser.getParty_row_id(), curruser.getNickname(), cid, "", "邀请您加入讨论组 "+dgname, "Discugroup_Join", dgid, "", "txt", "N", DateTime.currentDate(), "");
						
						//推送微信消息
//						String url = "/discuGroup/detail?rowId="+dgid;
//						WxuserInfo wxuser = new WxuserInfo();
//						wxuser.setParty_row_id(cid);
//						String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
//						log.info("respSimpCustMsg url =>" + url);
//						log.info("respSimpCustMsg openId =>" + openId);
//						cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, curruser.getNickname()+"邀请您加入讨论组【"+dgname+"】 ", url);
					
						//推送微信消息 2015-04-13 修改
						String url = "/discuGroup/detail?rowId="+dgid;
						String smsurl = "/discuGroup/detail_fsms?rowId="+dgid;
						String content = curruser.getNickname()+"邀请您加入讨论组【"+dgname+"】 ";
						//批量发送
						List<BusinessCard> cardList = new ArrayList<BusinessCard>();
						BusinessCard bc = new BusinessCard();
						bc.setPartyId(cid);
						cardList.add(bc);
						cRMService.getWxService().getZjwkSystemTaskService().intelligentSendMessages(cardList, content, url, smsurl, url, true, "0");
					}
				}
				return "success";
			}
			return "fail";
		}
		
		/**
		 * 好友与联系人对像转换
		 * @param ur
		 * @return
		 */
		private ContactAdd transUserRela(UserRela ur,List<String> charList){
			ContactAdd ca = new ContactAdd();
			ca.setConname(ur.getRela_user_name());
			ca.setRowid(ur.getRela_user_id());
			ca.setConjob(ur.getPosition());
			ca.setDepartment(ur.getDepart());
			ca.setPhonemobile(ur.getMobile_no_1());
			ca.setEmail(ur.getEmail_1());
			if(StringUtils.isNotBlank(ur.getRela_user_name())){
				String findex = ZJWKUtil.getFirstSpell(ur.getRela_user_name());
				if(!charList.contains(findex)){
					charList.add(findex);
				}
				ca.setFirstname(findex);
			}else{
				if(!charList.contains("#")){
					charList.add("#");
				}
				ca.setFirstname("#");
			}
			ca.setAccountname(ur.getCompany());
			ca.setConaddress((null == ur.getCounty() ? "" : ur.getCounty())+ (null == ur.getProvince() ? "" : ur.getProvince()) + (null == ur.getCity()?"":ur.getCity()));
			
			ca.setType("friend");
			return ca;
		}
		
		/**
		 *  解散 讨论组
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/dissolution")
		@ResponseBody
		public String dissolution(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			log.info("discuGroupService dissolution method begin =>");
			String dgid = request.getParameter("dgid");
			log.info("dgid =>" + dgid);
			if(StringUtils.isNotBlank(dgid)){
				DiscuGroup sdg = new DiscuGroup();
				sdg.setId(dgid);
				Object sdgobj = cRMService.getDbService().getDiscuGroupService().findObj(sdg);
				if(sdgobj != null){
					sdg = (DiscuGroup)sdgobj;
					String cid = sdg.getCreator();
					log.info("cid = >" + cid);
					//是自己创建的才能解散
					if(cid.equals(UserUtil.getCurrUser(request).getParty_row_id())){
						DiscuGroup dg = new DiscuGroup();
						dg.setId(dgid);
						dg.setEnabled_flag("disabled");//禁用
						cRMService.getDbService().getDiscuGroupService().updateDiscuGroupStatus(dg);
						
						//解散之后给每个人发送解散的消息
						DiscuGroupUser dgu = new DiscuGroupUser();
						dgu.setDis_id(dgid);
						dgu.setCurr_user_id(UserUtil.getCurrUser(request).getParty_row_id());
						//list
						List<DiscuGroupUser> dguserlist = (List<DiscuGroupUser>)cRMService.getDbService().getDiscuGroupService().findDiscuGroupUserList(dgu);
						log.info("dguserlist size = >" + dguserlist.size());
						for (int i = 0; i < dguserlist.size(); i++) {
							DiscuGroupUser sgldg = (DiscuGroupUser)dguserlist.get(i);
							String user_id = sgldg.getUser_id();
							log.info("user_id = >" + user_id);
							//发送指尖消息
							//cRMService.getDbService().getMessagesService().sendMsg(UserUtil.getCurrUser(request).getParty_row_id(), UserUtil.getCurrUser(request).getNickname(), user_id, "", "您加入的讨论组【"+sdg.getName()+"】已被解散 ", "Discugroup_Dissolution", dgid, "", "txt", "N", DateTime.currentDate(), "");
							
							//推送微信消息
							WxuserInfo wxuser = new WxuserInfo();
							wxuser.setParty_row_id(user_id);
							String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
							log.info("respSimpCustMsg openId =>" + openId);
							cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, "您加入的讨论组【"+sdg.getName()+"】已被解散", "");
						}
					}
					return "success";
				}
			}
			return "fail";
		}
		
		/**
		 *  修改 讨论组
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/update")
		@ResponseBody
		public String update(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			log.info("discuGroupService update method begin =>");
			String id = request.getParameter("id");
			String name = request.getParameter("name");
			String msg_group_flag = request.getParameter("msg_group_flag");
			String joinin_flag = request.getParameter("joinin_flag");
			log.info("id =>" + id);
			log.info("name =>" + name);
			log.info("msg_group_flag =>" + msg_group_flag);
			log.info("joinin_flag =>" + joinin_flag);
			if(StringUtils.isNotBlank(name)&&!com.takshine.wxcrm.base.util.StringUtils.regZh(name)){
				name= new String(name.getBytes("ISO-8859-1"),"UTF-8");
			}
			if("updname".equals(request.getParameter("flag"))){
				DiscuGroup dg = new DiscuGroup();
				dg.setName(name);
				List<DiscuGroup> list = (List<DiscuGroup>)cRMService.getDbService().getDiscuGroupService().findObjListByFilter(dg);
				if(null!=list&&list.size()>0){
					return "repeat";
				}
			}
			if(StringUtils.isNotBlank(id)){
				DiscuGroup dg = new DiscuGroup();
				dg.setName(name);
				dg.setId(id);
				dg.setModifier(UserUtil.getCurrUser(request).getParty_row_id());
				dg.setModify_time(DateTime.currentDateTime());
				dg.setMsg_group_flag(msg_group_flag);
				dg.setJoinin_flag(joinin_flag);
				cRMService.getDbService().getDiscuGroupService().updateObj(dg);
				return "success";
			}
			return "fail";
		}
		
		/**
		 *  新增 讨论组
		 * 
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/save")
		@ResponseBody
		public String save(DiscuGroup dg, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			log.info("discuGroupService save method begin =>");
			dg.setName(new String(dg.getName().getBytes("iso-8859-1"), "utf-8"));
			dg.setAddress(new String(dg.getAddress().getBytes("iso-8859-1"), "utf-8"));
			dg.setDistags(new String(dg.getDistags().getBytes("iso-8859-1"), "utf-8"));
			//
			dg.setId(Get32Primarykey.getRandom32BeginTimePK());
			dg.setEnabled_flag("enabled");
			dg.setCreate_time(DateTime.currentDateTime());
			dg.setCreator(UserUtil.getCurrUser(request).getParty_row_id());
			dg.setWeight("0");//人工权重
			//判断是否重复
			String name = dg.getName();
			DiscuGroup s = new DiscuGroup();
			s.setName(name);
			Object so = cRMService.getDbService().getDiscuGroupService().findObj(s);
			if(so == null){
				//orgId
				String orgId = dg.getOrgId();
				log.info("orgId = >" + orgId);
				if(StringUtils.isNotBlank(orgId)){
					String crmId = cRMService.getDbService().getDiscuGroupService().getCrmIdByOrgId(UserUtil.getCurrUser(request).getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
					log.info("crmId = > " + crmId);
					dg.setCrmId(crmId);
				}
				//save
				cRMService.getDbService().getDiscuGroupService().addObj(dg);
			}else{
				return "repeat";
			}
			
			String addres= dg.getAddress();
			String distags = dg.getDistags();
			log.info("addres =>" + addres);
			log.info("distags =>" + distags);
			if(StringUtils.isNotBlank(addres)){
				String [] addrarr = addres.split(",");
				for(int i=0 ; i < addrarr.length ; i++){
					//保存tag
					Tag tag = new Tag();
					tag.setModelId(dg.getId());
					tag.setModelType("discu_group_addr");
					tag.setTagName(addrarr[i]);
					tag.setOpenId(UserUtil.getCurrUser(request).getOpenId());
					tag.setId(Get32Primarykey.getRandom32PK());
					tag.setCreateBy(UserUtil.getCurrUser(request).getParty_row_id());
					cRMService.getDbService().getTagModelService().saveTag(tag);
				}
			}
			if(StringUtils.isNotBlank(distags)){
				String [] distagsarr = distags.split(",");
				for(int i=0 ; i < distagsarr.length ; i++){
					//保存tag
					Tag tag = new Tag();
					tag.setModelId(dg.getId());
					tag.setModelType("discu_group_tag");
					tag.setTagName(distagsarr[i]);
					tag.setOpenId(UserUtil.getCurrUser(request).getOpenId());
					tag.setId(Get32Primarykey.getRandom32PK());
					tag.setCreateBy(UserUtil.getCurrUser(request).getParty_row_id());
					cRMService.getDbService().getTagModelService().saveTag(tag);
				}
			}
			
			return "success";
		}
		
		/**
		 *  系统推荐的讨论组列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/weightlist")
		@ResponseBody
		public String weightlist(HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			log.info("discuGroupService syslist method");
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String pid = curruser.getParty_row_id();
			String currpages = request.getParameter("currpages");
			String pagecounts = request.getParameter("pagecounts");
			log.info("pid = >" + pid);
			log.info("pagecounts = >" + pagecounts);
			log.info("currpages = >" + currpages);
			if(StringUtils.isNotBlank(pid)){
				DiscuGroup dg = new DiscuGroup();
				dg.setCurrpages(new Integer(currpages));
				dg.setPagecounts(new Integer(pagecounts));
				List<DiscuGroup> dglist = (List<DiscuGroup>)cRMService.getDbService().getDiscuGroupService().findWeightDiscuGroupList(dg);
				log.info("dglist size = >" + dglist.size());
				String rst = JSONArray.fromObject(dglist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 根据 特定条件 查询 讨论组列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/conditionlist")
		@ResponseBody
		public String conditionlist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService conditionlist method");
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String pid = curruser.getParty_row_id();
			String name = request.getParameter("stxt");
			log.info("pid = >" + pid);
			log.info("name = >" + name);
			if(StringUtils.isNotBlank(pid)){
				DiscuGroup dg = new DiscuGroup();
				dg.setName(name);
				List<DiscuGroup> dglist = (List<DiscuGroup>)cRMService.getDbService().getDiscuGroupService().findConditionGroupListByFilter(dg);
				log.info("dglist size = >" + dglist.size());
				String rst = JSONArray.fromObject(dglist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 我的 讨论组列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/mygrouplist")
		@ResponseBody
		public String mygrouplist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService syslist method");
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String pid = curruser.getParty_row_id();
			String name = request.getParameter("stxt");
			String currpages = request.getParameter("currpages");
			String pagecounts = request.getParameter("pagecounts");
			String orgId = request.getParameter("orgId");
			if(StringUtils.isBlank(pagecounts)){
				currpages = "0";
				pagecounts = "10";
			}
			log.info("currpages = >" + currpages);
			log.info("pagecounts = >" + pagecounts);
			if(StringUtils.isNotBlank(name)){
				name = new String(name.getBytes("iso-8859-1"), "utf-8");
			}
			log.info("pid = >" + pid);
			log.info("name = >" + name);
			if(StringUtils.isNotBlank(pid)){
				DiscuGroup dg = new DiscuGroup();
				dg.setCreator(pid);
				dg.setName(name);
				dg.setCurrpages(new Integer(currpages));
				dg.setPagecounts(new Integer(pagecounts));
				dg.setOrgId(orgId);
				//save
				List<DiscuGroup> dglist = (List<DiscuGroup>)cRMService.getDbService().getDiscuGroupService().findJoinDiscuGroupList(dg);
				log.info("dglist size = >" + dglist.size());
				//判断是否还有继续的数据
				dg.setCurrpages(new Integer(currpages + 1));
				dg.setPagecounts(new Integer(pagecounts));
				List<DiscuGroup> dgcontlist = (List<DiscuGroup>)cRMService.getDbService().getDiscuGroupService().findJoinDiscuGroupList(dg);
				log.info("dgcontlist size = >" + dgcontlist.size());
				//整合集合
				dglist.addAll(dgcontlist);
				String rst = JSONArray.fromObject(dglist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 讨论组用户列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/groupuserlist")
		@ResponseBody
		public String groupuserlist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService groupuserlist method");
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			if(StringUtils.isNotBlank(dgid)){
				DiscuGroupUser dgu = new DiscuGroupUser();
				dgu.setDis_id(dgid);
				dgu.setCurr_user_id(UserUtil.getCurrUser(request).getParty_row_id());
				//list
				List<DiscuGroupUser> dguserlist = (List<DiscuGroupUser>)cRMService.getDbService().getDiscuGroupService().findDiscuGroupUserList(dgu);
				log.info("dguserlist size = >" + dguserlist.size());
				String rst = JSONArray.fromObject(dguserlist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 讨论组管理员用户列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/groupadminuserlist")
		@ResponseBody
		public String groupadminuserlist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService groupadminuserlist method");
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			if(StringUtils.isNotBlank(dgid)){
				//管理员人列表
				DiscuGroupUser dgu = new DiscuGroupUser();
				dgu.setDis_id(dgid);
				dgu.setUser_type("admin");
				List<DiscuGroupUser> dguadminlist = (List<DiscuGroupUser>)cRMService.getDbService().getDiscuGroupUserService().findObjListByFilter(dgu);
				log.info("dguadminlist size = >" + dguadminlist.size());
				String rst = JSONArray.fromObject(dguadminlist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 讨论组话题列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/grouptopiclist")
		@ResponseBody
		public String grouptopiclist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService grouptopiclist method");
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			if(StringUtils.isNotBlank(dgid)){
				List<DiscuGroupTopic> dgtlist = cRMService.getBusinessService().getDiscuGroupMainService().getGroupTopicList(dgid);
				log.info("dgtlist size = >" + dgtlist.size());
				String rst = JSONArray.fromObject(dgtlist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 讨论组公告列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/groupnoticelist")
		@ResponseBody
		public String groupnoticelist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService groupnoticelist method");
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			if(StringUtils.isNotBlank(dgid)){
				//获取话题
				DiscuGroupNotice dgn = new DiscuGroupNotice();
				dgn.setRela_id(dgid);
				dgn.setRela_type("discugroup");
				dgn.setCurrpages(new Integer(0));
				dgn.setPagecounts(new Integer(999));
				List<DiscuGroupNotice> dgnlist = (List<DiscuGroupNotice>)cRMService.getDbService().getDiscuGroupNoticeService().findObjListByFilter(dgn);
				log.info("dgnlist size = >" + dgnlist.size());
				String rst = JSONArray.fromObject(dgnlist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 添加公告
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/addgroupnotice")
		@ResponseBody
		public String addgroupnotice(DiscuGroupNotice dgn,HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService addgroupnotice method");
			// 获取话题
			dgn.setCreator(UserUtil.getCurrUser(request).getParty_row_id());
			String id = cRMService.getDbService().getDiscuGroupNoticeService().addObj(dgn);
			return id;
		}
		
		/**
		 * 删除公告
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/delgroupnotice")
		@ResponseBody
		public String delgroupnotice(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService delgroupnotice method");
			String id = request.getParameter("id");
			if(StringUtils.isNotBlank(id)){
				cRMService.getDbService().getDiscuGroupNoticeService().deleteObjById(id);
				return "success";
			}else{
				return "fail";
			}
		}
		
		/**
		 * 我的  讨论组话题列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/mygrouptopiclist")
		@ResponseBody
		public String mygrouptopiclist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService mygrouptopiclist method");
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String pid = curruser.getParty_row_id();
			log.info("pid = >" + pid);
			if(StringUtils.isNotBlank(dgid)){
				//获取话题
				DiscuGroupTopic dgt = new DiscuGroupTopic();
				dgt.setDis_id(dgid);
				dgt.setCreator(pid);
				dgt.setCurrpages(new Integer(0));
				dgt.setPagecounts(new Integer(999));
				List<DiscuGroupTopic> dgtlist = cRMService.getDbService().getDiscuGroupService().findDiscuGroupTopicList(dgt);
				log.info("dgtlist size = >" + dgtlist.size());
				//遍历查询话题列表 文章 article   活动 activity  调查 survey 互助 help
				for (int i = 0; i < dgtlist.size(); i++) {
					DiscuGroupTopic sdgt = (DiscuGroupTopic)dgtlist.get(i);
					String ttp = sdgt.getTopic_type();
					String tid = sdgt.getTopic_id();
					log.info("ttp = >" + ttp);
					log.info("tid = >" + tid);
					if(StringUtils.isBlank(sdgt.getCardimg())){
						sdgt.setTopic_imgurl(sdgt.getHeadimgurl());
					}else{
						sdgt.setTopic_imgurl("http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/" + sdgt.getCardimg());
					}
					if("activity".equals(ttp)){//活动
						Activity act = cRMService.getDbService().getDiscuGroupService().findActivityById(tid);
						sdgt.setTopic_name(act.getTitle());
						sdgt.setTopic_startdate(act.getStart_date());
						if(StringUtils.isNotBlank(sdgt.getTopic_sendname())){
							sdgt.setCreator_name(sdgt.getTopic_sendname());
						}
					}else if("article".equals(sdgt.getTopic_type())){//文章
						Resource res = cRMService.getDbService().getDiscuGroupService().findArticleById(tid);
						if(StringUtils.isNotBlank(res.getResourceId())){//删除的文章不显示了
							sdgt.setTopic_name(res.getResourceTitle());
							//sdgt.setTopic_imgurl(res.getResourceInfo1());
						}else{
							sdgt.setTopic_status("deleted");
						}
					}else if("survey".equals(sdgt.getTopic_type())){
						
					}else if("help".equals(sdgt.getTopic_type())){
						
					}
					else if ("text".equals(sdgt.getTopic_type()))
					{
						if(StringUtils.isBlank(sdgt.getCardimg())){
							sdgt.setTopic_imgurl(sdgt.getHeadimgurl());
						}else{
							sdgt.setTopic_imgurl("http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/" + sdgt.getCardimg());
						}
					}
				}
				log.info("dgtlist size = >" + dgtlist.size());
				String rst = JSONArray.fromObject(dgtlist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 删除讨论组话题
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		public String delgrouptopic(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("delgrouptopic = >");
			String topicid = request.getParameter("topicid");
			log.info("topicid = >" + topicid);
			if(StringUtils.isNotBlank(topicid)){
				cRMService.getDbService().getDiscuGroupService().delDiscuGroupTopicByTopicId(topicid);
				return "success";
			}
			return "fail";
		}
		
		/**
		 * 讨论组加精话题列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/groupesstopiclist")
		@ResponseBody
		public String groupesstopiclist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService groupesstopiclist method");
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String pid = curruser.getParty_row_id();
			log.info("pid = >" + pid);
			if(StringUtils.isNotBlank(dgid)){
				//获取话题
				DiscuGroupTopic dgt = new DiscuGroupTopic();
				dgt.setDis_id(dgid);
				//dgt.setCreator(pid);
				dgt.setCurrpages(new Integer(0));
				dgt.setPagecounts(new Integer(999));
				dgt.setEss_flag("1"); //精华
				dgt.setTopic_status("audited");
				List<DiscuGroupTopic> dgtlist = cRMService.getDbService().getDiscuGroupService().findDiscuGroupTopicList(dgt);
				log.info("dgtlist size = >" + dgtlist.size());
				//遍历查询话题列表 文章 article   活动 activity  调查 survey 互助 help
				for (int i = 0; i < dgtlist.size(); i++) {
					DiscuGroupTopic sdgt = (DiscuGroupTopic)dgtlist.get(i);
					String ttp = sdgt.getTopic_type();
					String tid = sdgt.getTopic_id();
					log.info("ttp = >" + ttp);
					log.info("tid = >" + tid);
					
					//add by zhihe 增加与话题列表统一的图标处理逻辑
					if(StringUtils.isBlank(sdgt.getCardimg())){
						sdgt.setTopic_imgurl(sdgt.getHeadimgurl());
					}else{
						sdgt.setTopic_imgurl("http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/" + sdgt.getCardimg());
					}
					//end by zhihe
					
					if("activity".equals(ttp)){//活动
						Activity act = cRMService.getDbService().getDiscuGroupService().findActivityById(tid);
						sdgt.setTopic_name(act.getTitle());
						sdgt.setTopic_startdate(act.getStart_date());
						if(StringUtils.isNotBlank(sdgt.getTopic_sendname())){
							sdgt.setCreator_name(sdgt.getTopic_sendname());
						}
						if(StringUtils.isBlank(sdgt.getCardimg())){
							sdgt.setTopic_imgurl(sdgt.getHeadimgurl());
						}else{
							sdgt.setTopic_imgurl("http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/" + sdgt.getCardimg());
						}						
					}else if("article".equals(sdgt.getTopic_type())){//文章
						Resource res = cRMService.getDbService().getDiscuGroupService().findArticleById(tid);
						if(StringUtils.isNotBlank(res.getResourceId())){//删除的文章不显示了
							sdgt.setTopic_name(res.getResourceTitle());
							//sdgt.setTopic_imgurl(res.getResourceInfo1());
						}else{
							sdgt.setTopic_status("deleted");
						}
					}else if("survey".equals(sdgt.getTopic_type())){
						
					}else if("help".equals(sdgt.getTopic_type())){
						
					}
				}
				log.info("dgtlist size = >" + dgtlist.size());
				String rst = JSONArray.fromObject(dgtlist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 保存 讨论组话题消息
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/savegrouptopicmsg")
		@ResponseBody
		public String savegrouptopicmsg(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService savegrouptopicmsg method");
			String dgid = request.getParameter("dgid");
			String dgname = request.getParameter("dgname");
			String topicid = request.getParameter("topicid");
			String targetuid = request.getParameter("targetuid");
			String targetuname = request.getParameter("targetuname");
			String content = request.getParameter("content");
			log.info("dgid = >" + dgid);
			log.info("dgname = >" + dgname);
			log.info("topicid = >" + topicid);
			log.info("targetuid = >" + targetuid);
			log.info("targetuname = >" + targetuname);
			log.info("content = >" + content);
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String pid = curruser.getParty_row_id();
			log.info("pid = >" + pid);
			if(StringUtils.isNotBlank(dgid) 
					&& StringUtils.isNotBlank(topicid)
					&& StringUtils.isNotBlank(pid)){
				DiscuGroupTopicMsg dgtm = new DiscuGroupTopicMsg();
				dgtm.setDis_id(dgid);
				dgtm.setTopic_id(topicid);
				dgtm.setSend_user_id(pid);
				dgtm.setTarget_user_id(targetuid);
				dgtm.setMsg_type("common");//普通类型
				dgtm.setContent(content);
				dgtm.setCreate_time(DateTime.currentDateTime());
				cRMService.getDbService().getDiscuGroupTopicMsgService().addObj(dgtm);
				
				//查询话题的创建人
				DiscuGroupTopic dgt = new DiscuGroupTopic();
				dgt.setId(topicid);
				List<DiscuGroupTopic> objdgt = cRMService.getDbService().getDiscuGroupService().findDiscuGroupTopicByParam(dgt);
				if(objdgt.size() > 0){
					dgt = objdgt.get(0);
					String creator = dgt.getCreator();
					log.info("creator = >" + creator);
					//创建人不少当前的登陆用户才发送消息 否则不发送
					if(StringUtils.isNotBlank(creator) && !pid.equals(creator)){
						//给发送消息  申请加群
						cRMService.getDbService().getMessagesService().sendMsg(curruser.getParty_row_id(), curruser.getNickname(), creator, "", curruser.getNickname() +" 在您的讨论组【"+dgname+"】进行了讨论", "Discugroup_topicMsgTip", dgid, "", "txt", "N", DateTime.currentDate(), "");
						//推送微信消息
						String url = "/discuGroup/detail?rowId="+dgid;
						WxuserInfo wxuser = new WxuserInfo();
						wxuser.setParty_row_id(creator);
						String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
						log.info("respSimpCustMsg url =>" + url);
						log.info("respSimpCustMsg openId =>" + openId);
						cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, curruser.getNickname() +" 在您的讨论组【"+dgname+"】进行了讨论", url);
					}
				}
				
				return "success";
			}
			return "fail";
		}
		
		/**
		 * 讨论组话题消息列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/grouptopicmsglist")
		@ResponseBody
		public String grouptopicmsglist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService grouptopicmsglist method");
			String dgid = request.getParameter("dgid");
			String topicid = request.getParameter("topicid");
			log.info("dgid = >" + dgid);
			log.info("topicid = >" + topicid);
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String pid = curruser.getParty_row_id();
			log.info("pid = >" + pid);
			if(StringUtils.isNotBlank(dgid) && StringUtils.isNotBlank(topicid)){
				DiscuGroupTopicMsg dgtm = new DiscuGroupTopicMsg();
				dgtm.setDis_id(dgid);
				dgtm.setTopic_id(topicid);
				List<DiscuGroupTopicMsg> dgtmlist = (List<DiscuGroupTopicMsg>)cRMService.getDbService().getDiscuGroupTopicMsgService().findObjListByFilter(dgtm);
				log.info("dgtmlist size = >" + dgtmlist.size());
				String rst = JSONArray.fromObject(dgtmlist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 我的讨论组话题消息列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/mygrouptopicmsglist")
		@ResponseBody
		public String mygrouptopicmsglist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("cRMService.getDbService().getDiscuGroupService() mygrouptopicmsglist method");
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String pid = curruser.getParty_row_id();
			log.info("pid = >" + pid);
			if(StringUtils.isNotBlank(dgid)){
				//log.info("dgtlist size = >" + dgtlist.size());
				//String rst = JSONArray.fromObject(dgtlist).toString();
				//log.info("rst  = >" + rst);
				return "";
			}
			return "[]";
		}
		
		/**
		 * 讨论组 申请列表列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/discugroupexamlist")
		@ResponseBody
		public String discugroupexamlist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService discugroupexamlist method");
			String dgid = request.getParameter("dgid");
			String etype = request.getParameter("etype");
			log.info("dgid = >" + dgid);
			log.info("etype = >" + etype);
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String pid = curruser.getParty_row_id();
			log.info("pid = >" + pid);
			if(StringUtils.isNotBlank(dgid) 
					&& StringUtils.isNotBlank(etype) //申请入群  join  信息群发申请mass  申请停用 stop
					&& StringUtils.isNotBlank(pid)){
				DiscuGroupExam exam = new DiscuGroupExam();
				exam.setDis_id(dgid);
				exam.setEvent_type(etype);
				List<DiscuGroupExam> dgexlist = (List<DiscuGroupExam>)cRMService.getDbService().getDiscuGroupExamService().findObjListByFilter(exam);
				for (int i = 0; i < dgexlist.size(); i++) {
					DiscuGroupExam dge = (DiscuGroupExam)dgexlist.get(i);
					String eventtype = dge.getEvent_type();
					String rtype = dge.getRela_type();
					String rrelaid = dge.getRela_id();
					String rtopic_id = dge.getTopic_id();
					log.info("eventtype = >" + eventtype);
					log.info("rtype = >" + rtype);
					log.info("rrelaid = >" + rrelaid);
					log.info("rtopic_id = >" + rtopic_id);
					if(StringUtils.isNotBlank(dge.getApply_user_card_name())){
						dge.setApply_user_name(dge.getApply_user_card_name());
					}
					if(StringUtils.isBlank(dge.getCardimg())){
						dge.setTopic_imgurl(dge.getHeadimgurl());
					}else{
						dge.setTopic_imgurl("http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/" + dge.getCardimg());
					}
					//群发申请
					if("mass_apply".equals(eventtype)){//群发申请
						if("activity".equals(rtype)){//活动
							Activity act = cRMService.getDbService().getDiscuGroupService().findActivityById(rtopic_id);
							if(StringUtils.isBlank(act.getId())){
								dge.setTopic_status("deleted");
							}
							dge.setRela_name(act.getTitle());
							dge.setTopic_startdate(act.getStart_date());
							dge.setTopic_addr(act.getPlace());
						}else if("article".equals(rtype)){//文章
							Resource res = cRMService.getDbService().getDiscuGroupService().findArticleById(rtopic_id);
							if(StringUtils.isNotBlank(res.getResourceId())){//删除的文章不显示了
								dge.setRela_name(res.getResourceTitle());
								dge.setTopic_imgurl(res.getResourceInfo1());
							}else{
								dge.setTopic_status("deleted");
							}
						}else if("survey".equals(rtype)){
							
						}else if("help".equals(rtype)){
							
						}
					//加入申请
					}else if("join_apply".equals(eventtype)){//加入申请
					
					}else if("addess_apply".equals(eventtype)){//申请加精
						if("activity".equals(rtype)){//活动
							Activity act = cRMService.getDbService().getDiscuGroupService().findActivityById(rtopic_id);
							if(StringUtils.isBlank(act.getId())){
								dge.setTopic_status("deleted");
							}
							dge.setRela_name(act.getTitle());
							dge.setTopic_startdate(act.getStart_date());
							dge.setTopic_addr(act.getPlace());
						}else if("article".equals(rtype)){//文章
							Resource res = cRMService.getDbService().getDiscuGroupService().findArticleById(rtopic_id);
							if(StringUtils.isNotBlank(res.getResourceId())){//删除的文章不显示了
								dge.setRela_name(res.getResourceTitle());
								dge.setTopic_imgurl(res.getResourceInfo1());
							}else{
								dge.setTopic_status("deleted");
							}
						}else if("survey".equals(rtype)){
							
						}else if("help".equals(rtype)){
							
						}
					}
				}
				
				log.info("dgexlist size = >" + dgexlist.size());
				String rst = JSONArray.fromObject(dgexlist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 加入讨论组
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/joindg")
		@ResponseBody
		public String joindg(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService joindg method");
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String dgid = request.getParameter("dgid");
			log.info("dgid = >" + dgid);
			if(StringUtils.isNotBlank(dgid)){
				String joinflag = "";
				DiscuGroup dg = new DiscuGroup();
				dg.setId(dgid);
				Object objdg = cRMService.getDbService().getDiscuGroupService().findObj(dg);
				if(objdg != null){
					dg = (DiscuGroup)objdg;
					joinflag = dg.getJoinin_flag();
				}
				log.info("joinflag = >" + joinflag);
				if("admin".equals(joinflag)){
					DiscuGroupExam sdge = new DiscuGroupExam();
					sdge.setDis_id(dgid);
					sdge.setApply_user_id(curruser.getParty_row_id());
					sdge.setEvent_type("join_apply");//群发申请
					Object objsdge = cRMService.getDbService().getDiscuGroupExamService().findObj(sdge);
					if(objsdge == null){
						DiscuGroupExam dge = new DiscuGroupExam();
						dge.setDis_id(dgid);
						dge.setApply_time(DateTime.currentDateTime());
						dge.setApply_user_id(curruser.getParty_row_id());
						dge.setRela_id("");
						dge.setRela_type("");
						dge.setEvent_type("join_apply");//群发申请
						cRMService.getDbService().getDiscuGroupExamService().addObj(dge);
						
						//给群主和管理发送申请加入的消息
						DiscuGroupUser dgu = new DiscuGroupUser();
						dgu.setDis_id(dgid);
						dgu.setUser_type("admin");
						List<?> userList = cRMService.getDbService().getDiscuGroupUserService().findAllDiscuGroupUser(dgu);
						for (Iterator iterator = userList.iterator(); iterator
								.hasNext();) {
							DiscuGroupUser obj = (DiscuGroupUser) iterator.next();
							String uid = obj.getUser_id();
							log.info("uid = >" + uid);
							//给发送消息  申请加群
							cRMService.getDbService().getMessagesService().sendMsg(curruser.getParty_row_id(), curruser.getNickname(), uid, "", curruser.getNickname() +"申请加入您的讨论组【"+dg.getName()+"】", "Discugroup_ApplyJoinGroup", dgid, "", "txt", "N", DateTime.currentDate(), "");
							//推送微信消息
							String url = "/discuGroup/manage?dgid="+dgid;
							WxuserInfo wxuser = new WxuserInfo();
							wxuser.setParty_row_id(uid);
							String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
							log.info("respSimpCustMsg url =>" + url);
							log.info("respSimpCustMsg openId =>" + openId);
							cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, curruser.getNickname() +"申请加入您的讨论组【"+dg.getName()+"】", url);
						}
					}
				}else{
					DiscuGroupUser seardgu = new DiscuGroupUser();
					seardgu.setDis_id(dgid);
					seardgu.setUser_id(curruser.getParty_row_id());
					Object objseardgu = cRMService.getDbService().getDiscuGroupUserService().findObj(seardgu);
					if(objseardgu == null){
						//讨论组用户
						DiscuGroupUser dgu = new DiscuGroupUser();
						dgu.setDis_id(dgid);
						dgu.setUser_id(curruser.getParty_row_id());
						dgu.setUser_type("common");
						dgu.setCreate_time(DateTime.currentDateTime());
						cRMService.getDbService().getDiscuGroupUserService().addObj(dgu);
					}else{
						//更新 讨论组用户 状态
						DiscuGroupUser dgu = new DiscuGroupUser();
						dgu.setDis_id(dgid);
						dgu.setUser_id(curruser.getParty_row_id());
						dgu.setUser_type("common");
						cRMService.getDbService().getDiscuGroupUserService().updateDiscuGroupUserType(dgu);
					}
					
					//加入者 给群主发送消息 告诉群主谁加入了
					//给发送消息  申请加群
					cRMService.getDbService().getMessagesService().sendMsg(curruser.getParty_row_id(), curruser.getNickname(), dg.getCreator(), "", curruser.getNickname() +"加入了您的讨论组【"+dg.getName()+"】", "Discugroup_ApplyJoinGroup", dgid, "", "txt", "N", DateTime.currentDate(), "");
					//推送微信消息
					String url = "/discuGroup/detail?rowId="+dgid;
					WxuserInfo wxuser = new WxuserInfo();
					wxuser.setParty_row_id(dg.getCreator());
					String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
					log.info("respSimpCustMsg url =>" + url);
					log.info("respSimpCustMsg openId =>" + openId);
					cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, curruser.getNickname() +"加入了您的讨论组【"+dg.getName()+"】", url);
					
					//讨论组公告
					DiscuGroupNotice dgn = new DiscuGroupNotice();
					dgn.setRela_id(dgid);
					dgn.setRela_type("discugroup");
					dgn.setContent("【" + curruser.getNickname() +" 】 加入了讨论组");
					dgn.setType("group_notice");
					dgn.setCreator(dg.getCreator());
					cRMService.getDbService().getDiscuGroupNoticeService().addObj(dgn);
				}
				return "success";
			}
			return "fail";
		}
		
		/**
		 * 群发活动列表
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/massactlist")
		@ResponseBody
		public String massactlist(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService massactlist method");
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String type = request.getParameter("type");
			log.info("type = >" + type);
			if(StringUtils.isNotBlank(type)){
				List<CampaignsAdd> actlist = cRMService.getDbService().getDiscuGroupService().findActivityListByType(curruser.getParty_row_id(), type);
				log.info("actlist size = >" + actlist.size());
				String rst = JSONArray.fromObject(actlist).toString();
				log.info("rst  = >" + rst);
				return rst;
			}
			return "[]";
		}
		
		/**
		 * 群发活动列表02
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/massactlist02")
		@ResponseBody
		public String massactlist02(HttpServletRequest request, HttpServletResponse response) throws Exception {
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String viewtype = request.getParameter("viewtype");
			String startdate=request.getParameter("start_date");
			String enddate=request.getParameter("end_date");
			String assignerId = request.getParameter("assignerId");
			String addAssigner = request.getParameter("addAssigner");
			String title = request.getParameter("title");
			if(com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(title) && !com.takshine.wxcrm.base.util.StringUtils.regZh(title)){
				title = new String(title.getBytes("ISO-8859-1"),"UTF-8");
			}
			if(com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(addAssigner) && !com.takshine.wxcrm.base.util.StringUtils.regZh(addAssigner)){
				addAssigner = new String(addAssigner.getBytes("ISO-8859-1"),"UTF-8");
			}
			if (null == currpage || "".equals(currpage)) {
				currpage = "0";
			}
			if (null == pagecount || "".equals(pagecount)) {
				pagecount = "10";
			}
			if(!StringUtils.isNotBlank(viewtype)){
				viewtype = "owner";
			}
			currpage = Integer.parseInt(currpage) * Integer.parseInt(pagecount) +"";
			String partyRowId = UserUtil.getCurrUser(request).getParty_row_id();
			// 绑定对象
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			log.info("crmId:-> is =" + crmId);
			Campaigns camp = new Campaigns();
			camp.setCurrpage(currpage);
			camp.setPagecount(pagecount);
			camp.setOpenId(partyRowId);
			camp.setStartdate(startdate);
			camp.setEnddate(enddate);
			String flag = request.getParameter("flag");
			List<Activity> activities = new ArrayList<Activity>();
			List<Activity> activityAll = new ArrayList<Activity>();
			if("owner".equals(viewtype)){//我发起 创建的活动
				
				List<Activity> list = new ArrayList<Activity>();
				Activity act = new Activity();
				act.setCreateBy(camp.getOpenId());
				act.setSource("WEB");
				act.setPagecounts(Integer.parseInt(pagecount));
				act.setCurrpages(Integer.parseInt(currpage));
				if(StringUtils.isNotBlank(startdate)){
					act.setStart_date(startdate);
				}
				if(StringUtils.isNotBlank(enddate)){
					act.setEnd_date(enddate);
				}
				list = cRMService.getDbService().getActivityService().getActivityList(act);
				if(list.size()>0){
					activityAll.addAll(list);
				}
				
			}else if("regist".equals(viewtype)){//我报名的
				activities = cRMService.getSugarService().getCampaigns2ZJmktService().getJoinCampaignsList(camp, "WEB");
				if(activities.size()>0){
					activityAll.addAll(activities);
				}
			}else if("join".equals(viewtype)){//我参与的
				camp.setViewtype("shareview");
				camp.setCrmId(crmId);
				activities = cRMService.getSugarService().getCampaigns2ZJmktService().getCampaigns(camp);
				if(activities.size()>0){
					activityAll.addAll(activities);
				}
			}
			else if("branch".equals(viewtype)){//我下属的活动
				Activity activity = new Activity();
				activity.setCurrpages(0);
				activity.setPagecounts(999999);
				if("search".equals(flag)){
					activity.setStart_date(startdate);
					activity.setEnd_date(enddate);
					activity.setTitle(title);
				}
				List<Activity> list = new ArrayList<Activity>();
				if(StringUtils.isNotBlank(assignerId)){
					String[] assids = assignerId.split(",");
					List<String> assList = new ArrayList<String>();
					for(int i=0;i<assids.length;i++){
						assList.add(assids[i]);
					}
					activity.setCrm_id_in(assList);
					list = cRMService.getDbService().getActivityService().searchBranchActivity(activity);
					activityAll.addAll(list);
				}else{
					UserReq uReq = new UserReq();
					uReq.setCurrpage("1");
					uReq.setPagecount("1000");
					uReq.setOpenId(UserUtil.getCurrUser(request).getOpenId());
					uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
					UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
					if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
						for(UserAdd userAdd:uResp.getUsers()){
							String userid = userAdd.getUserid();
							assignerId += userid+",";
						}
					}
					if(StringUtils.isNotBlank(assignerId)){
						String[] assids = assignerId.split(",");
						List<String> assList = new ArrayList<String>();
						for(int i=0;i<assids.length;i++){
							assList.add(assids[i]);
						}
						activity.setCrm_id_in(assList);
						list = cRMService.getDbService().getActivityService().searchBranchActivity(activity);
						activityAll.addAll(list);
					}
				}
			}
			if("search".equals(flag)){
				//获取参与推荐活动列表
				List<Activity> list = cRMService.getSugarService().getCampaigns2ZJmktService().getRecommendCampaignsList();
				request.setAttribute("recommendList", list);
			}
			log.info("activityAll size = >" + activityAll.size());
			String rst = JSONArray.fromObject(activityAll).toString();
			log.info("rst  = >" + rst);
			
			return rst;
		}
		
		/**
		 * 同意群发 消息
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/discugroup_examoperator")
		@ResponseBody
		public String discugroup_examoperator(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService discugroup_examoperator method");
			String op_type = request.getParameter("op_type");
			String massid = request.getParameter("massid");
			String relaid = request.getParameter("relaid");
			String dgid = request.getParameter("dgid");
			String dgname = request.getParameter("dgname");
			String user_id = request.getParameter("user_id");
			WxuserInfo curruser = UserUtil.getCurrUser(request);
			String pid = curruser.getParty_row_id();
			log.info("pid = >" + pid);
			log.info("op_type = >" + op_type);
			log.info("user_id = >" + user_id);
			log.info("relaid = >" + relaid);
			log.info("dgid = >" + dgid);
			log.info("dgname = >" + dgname);
			
			
			if(StringUtils.isNotBlank(massid) 
					&& StringUtils.isNotBlank(pid) 
					&& StringUtils.isNotBlank(op_type)){
				DiscuGroupExam dge = new DiscuGroupExam();
				dge.setId(massid);
				dge.setExam_user_id(pid);
				if("agreejoingroup".equals(op_type) 
						|| "agreemassmsg".equals(op_type)
						|| "agreeaddessmsg".equals(op_type)){
					dge.setExam_result("agree");
					//同意用户入群申请
					if("agreejoingroup".equals(op_type)){
						//讨论组用户
						DiscuGroupUser dgu = new DiscuGroupUser();
						dgu.setDis_id(dgid);
						dgu.setUser_id(user_id);
						List<DiscuGroupUser> dgulist = cRMService.getDbService().getDiscuGroupUserService().findDiscuGroupUserByParam(dgu);
						log.info("agreejoingroup dgulist = >" + dgulist.size());
						if(dgulist.size() == 0){
							dgu.setUser_type("common");
							dgu.setCreate_time(DateTime.currentDateTime());
							cRMService.getDbService().getDiscuGroupUserService().addObj(dgu);
						}else{
							dgu.setUser_type("common");
							cRMService.getDbService().getDiscuGroupUserService().updateDiscuGroupUserType(dgu);
						}
						log.info("agreejoingroup begin send msg = >");
						//给发送消息
						cRMService.getDbService().getMessagesService().sendMsg(UserUtil.getCurrUser(request).getParty_row_id(), UserUtil.getCurrUser(request).getNickname(), user_id, "", "管理员【"+ curruser.getName() +"】同意了您加入讨论组【"+dgname+"】", "Discugroup_AgreeJoinGroup", dgid, "", "txt", "N", DateTime.currentDate(), "");
						//推送微信消息
						String url = "/discuGroup/detail?rowId="+dgid;
						WxuserInfo wxuser = new WxuserInfo();
						wxuser.setParty_row_id(user_id);
						wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser);
						String openId = wxuser.getOpenId();
						log.info("respSimpCustMsg url =>" + url);
						log.info("respSimpCustMsg openId =>" + openId);
						cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, "管理员【"+ curruser.getName() +"】同意了您加入讨论组【"+dgname+"】", url);
						
						//讨论组公告
						DiscuGroupNotice dgn = new DiscuGroupNotice();
						dgn.setRela_id(dgid);
						dgn.setRela_type("discugroup");
						dgn.setContent("【" + wxuser.getNickname() +" 】 加入了讨论组");
						dgn.setType("group_notice");
						dgn.setCreator(UserUtil.getCurrUser(request).getParty_row_id());
						cRMService.getDbService().getDiscuGroupNoticeService().addObj(dgn);
					}
					//同意申请群发消息
					else if("agreemassmsg".equals(op_type)){
					    DiscuGroupTopic upd = new DiscuGroupTopic();
					    upd.setTopic_status("audited");
					    upd.setId(relaid);
						cRMService.getDbService().getDiscuGroupService().updateDiscuGroupTopic(upd);

						//查询类型发送消息
						String massType = "";
						DiscuGroupTopic dgtpic = new DiscuGroupTopic();
						dgtpic.setId(relaid);
						List<DiscuGroupTopic> dgtpiclist = cRMService.getDbService().getDiscuGroupService().findDiscuGroupTopicList(dgtpic);
						if(dgtpiclist.size() > 0){
							dgtpic = dgtpiclist.get(0);
							massType = dgtpic.getTopic_type();
						}
						//文章创建人的用户名
						WxuserInfo wx_user_id = new WxuserInfo();
						wx_user_id.setParty_row_id(dgtpic.getCreator());
						String wx_user_name = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wx_user_id).getNickname();
						log.info("wx_user_name = >" + wx_user_name);
						
						log.info("massType = >" + massType);
						
						//同意群发申请 管理员给文章创建人发送信息
						cRMService.getDbService().getMessagesService().sendMsg(UserUtil.getCurrUser(request).getParty_row_id(), UserUtil.getCurrUser(request).getNickname(), user_id, "", "管理员【"+ curruser.getName() +"】同意了您的群发申请", "Discugroup_AgreeJoinGroup", dgid, "", "txt", "N", DateTime.currentDate(), "");
						//推送微信消息
						String urlstr = "/discuGroup/detail?rowId="+dgid;
						WxuserInfo wxuser = new WxuserInfo();
						wxuser.setParty_row_id(user_id);
						wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser);
						String openId = wxuser.getOpenId();
						log.info("respSimpCustMsg urlstr =>" + urlstr);
						log.info("respSimpCustMsg openId =>" + openId);
						cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, "管理员【"+ curruser.getName() +"】同意了您的群发申请", urlstr);
						
						//获取讨论组成员
						DiscuGroupUser dgu = new DiscuGroupUser();
						dgu.setDis_id(dgid);
						List<DiscuGroupUser> dgulist = (List<DiscuGroupUser>)cRMService.getDbService().getDiscuGroupUserService().findObjListByFilter(dgu);
						log.info("dgulist size = >" + dgulist.size());
						//给群组里所有成员发消息
						for(int i = 0; i < dgulist.size() ;i++){
							DiscuGroupUser sdgu = (DiscuGroupUser)dgulist.get(i);
							String sduid = sdgu.getUser_id();
							if(sduid.equals(UserUtil.getCurrUser(request).getParty_row_id())){
								continue;
							}
							log.info("sduid = >" + sduid);
							String content = wx_user_name;
							if("activity".equals(massType)){
								content += "在讨论组【"+dgname+"】中发起了一个活动";
							}else{
								content += "在讨论组【"+dgname+"】中发表了一篇文章";
							}
							cRMService.getDbService().getMessagesService().sendMsg(user_id, wx_user_name, sduid, "", content, "Discugroup_Mass", dgtpic.getTopic_id(), massType, "txt", "N", DateTime.currentDate(), "");
							//推送微信消息
							String url = "/discuGroup/detail?rowId="+dgid;
							String smsurl = "/discuGroup/detail_fsms?rowId="+dgid;
							if(massType.equals("activity")){//活动
								url =  "/zjwkactivity/detail?id="+dgtpic.getTopic_id()+"&source=wkshare&sourceid="+UserUtil.getCurrUser(request).getParty_row_id();
								smsurl =  "/zjwkactivity/new_detail?id="+dgtpic.getTopic_id()+"&source=wkshare";
							}else if(massType.equals("article")){//文章
								url = "/resource/detail?id="+dgtpic.getTopic_id();
							}
							//批量发送
							List<BusinessCard> cardList = new ArrayList<BusinessCard>();
							BusinessCard bc = new BusinessCard();
							bc.setPartyId(sduid);
							cardList.add(bc);
							cRMService.getWxService().getZjwkSystemTaskService().intelligentSendMessages(cardList, content, url, smsurl, url, true, "0");
						}
					}
					//同意申请加精群发消息
					else if("agreeaddessmsg".equals(op_type)){
						//给发送消息
						cRMService.getDbService().getMessagesService().sendMsg(UserUtil.getCurrUser(request).getParty_row_id(), UserUtil.getCurrUser(request).getNickname(), user_id, "", "管理员同意了您的加精申请", "Discugroup_AgreeAddEss", dgid, "", "txt", "N", DateTime.currentDate(), "");
						//推送微信消息
						String url = "/discuGroup/detail?rowId="+dgid;
						WxuserInfo wxuser = new WxuserInfo();
						wxuser.setParty_row_id(user_id);
						String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
						log.info("respSimpCustMsg url =>" + url);
						log.info("respSimpCustMsg openId =>" + openId);
						cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, "管理员同意了您的加精申请", url);
						//更新话题加精华
						DiscuGroupTopic dgt = new DiscuGroupTopic();
						dgt.setEss_flag("1");
						dgt.setId(relaid);
						cRMService.getDbService().getDiscuGroupService().updateDiscuGroupTopic(dgt);
					}
					
				}else if("refusejoingroup".equals(op_type) 
						|| "refusemassmsg".equals(op_type)
						|| "refuseaddessmsg".equals(op_type)){
					
					dge.setExam_result("refuse");
					//拒绝用户的入群申请
					if("refusejoingroup".equals(op_type)){
						
						//给发送消息
						cRMService.getDbService().getMessagesService().sendMsg(UserUtil.getCurrUser(request).getParty_row_id(), UserUtil.getCurrUser(request).getNickname(), user_id, "", "管理员拒绝了您加入讨论组【"+dgname+"】", "Discugroup_RefuseJoinGroup", dgid, "", "txt", "N", DateTime.currentDate(), "");
						//推送微信消息
						WxuserInfo wxuser = new WxuserInfo();
						wxuser.setParty_row_id(user_id);
						String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
						log.info("respSimpCustMsg openId =>" + openId);
						cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, "管理员拒绝了您加入讨论组【"+dgname+"】", "");
					}
					//拒绝群发消息
					else if("refusemassmsg".equals(op_type)){
						DiscuGroupTopic upd = new DiscuGroupTopic();
					    upd.setTopic_status("reject");
					    upd.setId(relaid);
						cRMService.getDbService().getDiscuGroupService().updateDiscuGroupTopic(upd);
						
						//给发送消息
						cRMService.getDbService().getMessagesService().sendMsg(UserUtil.getCurrUser(request).getParty_row_id(), UserUtil.getCurrUser(request).getNickname(), user_id, "", "您在讨论组【"+dgname+"】的群发信息被驳回", "Discugroup_RefuseJoinGroup", dgid, "", "txt", "N", DateTime.currentDate(), "");
						//推送微信消息
						String url = "/discuGroup/detail?rowId="+dgid;
						WxuserInfo wxuser = new WxuserInfo();
						wxuser.setParty_row_id(user_id);
						String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
						log.info("respSimpCustMsg url =>" + url);
						log.info("respSimpCustMsg openId =>" + openId);
						cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, "您在讨论组【"+dgname+"】的群发信息被驳回", url);
					}
					//拒绝加精消息
					else if("refuseaddessmsg".equals(op_type)){
						//给发送消息
						cRMService.getDbService().getMessagesService().sendMsg(UserUtil.getCurrUser(request).getParty_row_id(), UserUtil.getCurrUser(request).getNickname(), user_id, "", "管理员驳回了您的加精申请", "Discugroup_RefuseAddEss", dgid, "", "txt", "N", DateTime.currentDate(), "");
						//推送微信消息
						WxuserInfo wxuser = new WxuserInfo();
						wxuser.setParty_row_id(user_id);
						String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
						log.info("respSimpCustMsg openId =>" + openId);
						cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, "管理员驳回了您的加精申请", "");
					}
				}
				dge.setExam_time(DateTime.currentDateTime());
				dge.setExam_content("");
				cRMService.getDbService().getDiscuGroupExamService().updateObj(dge);
				return "success";
			}
			return "fail";
		}
		
		/**
		 * 设置管理员
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/setmgeuser")
		@ResponseBody
		public String setmanageuser(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService setmanageuser method");
			String user_id = request.getParameter("user_id");
			String dgid = request.getParameter("dgid");
			String dgname = request.getParameter("dgname");
			log.info("user_id = >" + user_id);
			log.info("dgid = >" + dgid);
			log.info("dgname = >" + dgname);
			if(StringUtils.isNotBlank(user_id) && StringUtils.isNotBlank(dgid)){
				//跟新系统状态
				DiscuGroupUser dguupd = new DiscuGroupUser();
				dguupd.setDis_id(dgid);
				dguupd.setUser_id(user_id);
				dguupd.setUser_type("admin");
				cRMService.getDbService().getDiscuGroupUserService().updateDiscuGroupUserType(dguupd);
				
				//给指定的人发送消息
				cRMService.getDbService().getMessagesService().sendMsg(UserUtil.getCurrUser(request).getParty_row_id(), UserUtil.getCurrUser(request).getNickname(), user_id, "", "您被设置为讨论组【"+dgname+"】的管理员", "Discugroup_SetMgnUser", dgid, "", "txt", "N", DateTime.currentDate(), "");
				//推送微信消息
				String url = "/discuGroup/detail?rowId="+dgid;
				WxuserInfo wxuser = new WxuserInfo();
				wxuser.setParty_row_id(user_id);
				String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
				log.info("respSimpCustMsg url =>" + url);
				log.info("respSimpCustMsg openId =>" + openId);
				cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, "您被设置为讨论组【"+dgname+"】的管理员", url);
				
				return "success";
			}
			return "fail";
		}
		
		/**
		 * 取消管理员
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/cannelmgeuser")
		@ResponseBody
		public String cannelmanageuser(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService cannelmanageuser method");
			String user_id = request.getParameter("user_id");
			String dgid = request.getParameter("dgid");
			String name = request.getParameter("dgname");
			log.info("user_id = >" + user_id);
			log.info("dgid = >" + dgid);
			if(StringUtils.isNotBlank(user_id) && StringUtils.isNotBlank(dgid)){
				//退出新系统状态
				DiscuGroupUser dguupd = new DiscuGroupUser();
				dguupd.setDis_id(dgid);
				dguupd.setUser_id(user_id);
				dguupd.setUser_type("common");
				cRMService.getDbService().getDiscuGroupUserService().updateDiscuGroupUserType(dguupd);
				
				//推送微信消息
				String url = "/discuGroup/detail?rowId="+dgid;
				WxuserInfo wxuser = new WxuserInfo();
				wxuser.setParty_row_id(user_id);
				String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
				log.info("respSimpCustMsg url =>" + url);
				log.info("respSimpCustMsg openId =>" + openId);
				cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, "您在讨论组【"+name+"】的管理员资格已被取消", url);
				return "success";
			}
			return "fail";
		}
		
		/**
		 * 删除群成员
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/removeuser")
		@ResponseBody
		public String removeuser(HttpServletRequest request, HttpServletResponse response) throws Exception {
			log.info("discuGroupService removeuser method");
			String user_id = request.getParameter("user_id");
			String dgid = request.getParameter("dgid");
			String dgname = request.getParameter("dgname");
			log.info("user_id = >" + user_id);
			log.info("dgid = >" + dgid);
			if(StringUtils.isNotBlank(user_id) && StringUtils.isNotBlank(dgid)){
				cRMService.getDbService().getDiscuGroupUserService().removeDiscuGroupUser(dgid, user_id, dgname);
				return "success";
			}
			return "fail";
		}
		
		/**
		 * 加精
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/addess")
		@ResponseBody
		public String addess(HttpServletRequest request, HttpServletResponse response) throws Exception {
			String topicid = request.getParameter("topicid");
			CrmError crmErr = new CrmError();
			if(StringUtils.isNotBlank(topicid)){
				DiscuGroupTopic dgt = new DiscuGroupTopic();
				dgt.setEss_flag("1");
				dgt.setId(topicid);
				crmErr = cRMService.getDbService().getDiscuGroupService().updateDiscuGroupTopic(dgt);
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE__1);
			}
			return JSONObject.fromObject(crmErr).toString();
		}
		
		/**
		 * 推荐加精
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/recomess")
		@ResponseBody
		public String recomess(HttpServletRequest request, HttpServletResponse response) throws Exception {
			String topicid = request.getParameter("topicid");
			String dgid = request.getParameter("dgid");
			String dgname = request.getParameter("dgname");
			String topictype = request.getParameter("topictype");
			String relaid = request.getParameter("relaid");//话题关联的实体id
			log.info("topicid = >" + topicid);
			log.info("dgid = >" + dgid);
			log.info("dgname = >" + dgname);
			log.info("topictype = >" + topictype);
			if(StringUtils.isNotBlank(dgid) 
					|| StringUtils.isNotBlank(topicid)
					|| StringUtils.isNotBlank(topictype)){
				DiscuGroupExam seardge = new DiscuGroupExam();
				seardge.setDis_id(dgid);
				seardge.setRela_id(topicid);
				seardge.setEvent_type("addess_apply");//申请加精
				List<DiscuGroupExam> seardgelist = (List<DiscuGroupExam>)cRMService.getDbService().getDiscuGroupExamService().findObjListByFilter(seardge);
				if(seardgelist.size() == 0){
					//添加审批记录
					DiscuGroupExam dge = new DiscuGroupExam();
					dge.setDis_id(dgid);
					dge.setApply_time(DateTime.currentDateTime());
					dge.setApply_user_id(UserUtil.getCurrUser(request).getParty_row_id());
					dge.setRela_id(topicid);
					dge.setRela_type(topictype);
					dge.setEvent_type("addess_apply");//申请加精
					cRMService.getDbService().getDiscuGroupExamService().addObj(dge);
				}
				
				//获取话题的content
				String content = "";
				String tempStr = "";
				if ("text".equals(topictype))
				{
					DiscuGroupTopic topic = new DiscuGroupTopic();
					topic.setId(topicid);
					List<DiscuGroupTopic> topicList = cRMService.getDbService().getDiscuGroupService().findDiscuGroupTopicByParam(topic);
					if (null != topicList && !topicList.isEmpty())
					{
						tempStr = topicList.get(0).getContent();
						if (StringUtils.isNotBlank(tempStr))
						{
							content = getAbstract(tempStr);
						}
					}
				}
				else if ("article".equals(topictype))
				{
					Resource res = new Resource();
					res.setResourceId(relaid);
					List<Resource> resList =  cRMService.getDbService().getResourceService().findResourceListByFilter(res);
					if (null != resList && !resList.isEmpty())
					{
						tempStr = resList.get(0).getResourceTitle();
						if (StringUtils.isNotBlank(tempStr))
						{
							content = getAbstract(tempStr);
						}
					}
				}
				else if ("activity".equals(topictype))
				{
					Activity act = cRMService.getDbService().getActivityService().getActivitySingle(relaid);
					if (null != act)
					{
						tempStr = act.getTitle();
						if (StringUtils.isNotBlank(tempStr))
						{
							content = getAbstract(tempStr);
						}
					}
				}
				//end 
				
				//向管理员发送申请审核的消息
				//给群主和管理发送申请加入的消息
				DiscuGroupUser dgu = new DiscuGroupUser();
				dgu.setDis_id(dgid);
				dgu.setUser_type("admin");
				List<?> userList = cRMService.getDbService().getDiscuGroupUserService().findAllDiscuGroupUser(dgu);
				for (Iterator iterator = userList.iterator(); iterator
						.hasNext();) {
					DiscuGroupUser obj = (DiscuGroupUser) iterator.next();
					String uid = obj.getUser_id();
					log.info("uid = >" + uid);
					//给发送消息  申请加精
					cRMService.getDbService().getMessagesService().sendMsg(UserUtil.getCurrUser(request).getParty_row_id(), UserUtil.getCurrUser(request).getNickname(),
				    							uid, "",  UserUtil.getCurrUser(request).getNickname() +" 申请话题加精，话题摘要【"+content+"】",
				    								"Discugroup_ApplyAddEss", dgid, "", "txt", "N", DateTime.currentDate(), "");
					//推送微信消息
					String url = "/discuGroup/manage?dgid="+dgid;
					WxuserInfo wxuser = new WxuserInfo();
					wxuser.setParty_row_id(uid);
					String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
					log.info("respSimpCustMsg url =>" + url);
					log.info("respSimpCustMsg openId =>" + openId);
					cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, UserUtil.getCurrUser(request).getNickname() +" 申请话题加精，话题摘要【"+content+"】", url);
				}
				
				
				return "success";
			}
			return "fail";
		}
		
		/**
		 * 返回字符串特定长度
		 * @param temp
		 * @return
		 */
		private String getAbstract(String temp)
		{
			if (temp.length() > 10)
			{
				return  temp.substring(0,10);
			}
			else
			{
				return temp;
			}
		}
		
		/**
		 *  发起话题
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/towntalk")
		public String towntalk(HttpServletRequest request,
				HttpServletResponse response) throws Exception 
		{
			ZJWKUtil.getRequestURL(request);//获取请求的url
			//透传讨论组id
			String dgId = request.getParameter("dgid");
			request.setAttribute("dgid", dgId);
			
			return "discugroup/addtalk";
		}
		
		/**
		 *  保存话题
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/saveTalk")
		@ResponseBody
		public String saveTalk(HttpServletRequest request,
				HttpServletResponse response) throws Exception 
		{
			String disId = request.getParameter("dgid");
			String content = request.getParameter("talkContent");
			
			String topicId = cRMService.getBusinessService().getDiscuGroupMainService().sendTextTopic(disId, content, UserUtil.getCurrUserId(request));
			
			return topicId;
		}
		
		/**
		 *  查看话题详情
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/topicDetail")
		public String topicDetail(HttpServletRequest request,
				HttpServletResponse response) throws Exception 
		{
			String topicId = request.getParameter("id");
			//获取话题详情
			DiscuGroupTopic topic = cRMService.getBusinessService().getDiscuGroupMainService().getSingleGroupTopic(topicId);

			if (StringUtils.isBlank(topic.getContent()) && topic.getContent().contains("\n")) {
				topic.setContent(topic.getContent().replace("\n", "<br/>"));
				if(topic.getContent().contains("\r")){
					topic.setContent(topic.getContent().replace("\r", "<br/>"));
				}
			}
			
			request.setAttribute("topic", topic);
			
			//获取话题的图片信息
			//拿所有图片
			MessagesExt mext = new MessagesExt();
			mext.setRelaid(topicId);
			mext.setPagecounts(new Integer(999));
			mext.setCurrpages(new Integer(0));
			List<MessagesExt>imgList = cRMService.getDbService().getResourceService().getAllMessagesExtByRelaId(mext);
			
			if (null != imgList && !imgList.isEmpty())
			{
				request.setAttribute("imgList", imgList);
			}
			else
			{
				request.setAttribute("imgList", new ArrayList<MessagesExt>());
			}
			
			request.setAttribute("filepath","http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/");
			
			return "discugroup/topicdetail";
		}
		
		/**
		 *  删除话题
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/delTopic")
		@ResponseBody
		public String delTopicById(HttpServletRequest request,
				HttpServletResponse response) throws Exception 
		{
			String topicId = request.getParameter("topicid");
			DiscuGroupTopic dgt = new DiscuGroupTopic();
			dgt.setId(topicId);
			
			CrmError crmErr = cRMService.getDbService().getDiscuGroupService().deleteDiscuGroupTopic(dgt);
			
			if (null != crmErr && ErrCode.ERR_CODE_0.equals(crmErr.getErrorCode()))
			{
				return "success";
			}
			else
			{
				return "fail";
			}
		}
}
