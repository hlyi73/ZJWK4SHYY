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

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.MailUtils;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.SenderInfor;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.message.oauth.AccessToken;
import com.takshine.wxcrm.message.resp.Article;
import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.message.sugar.ExpenseAdd;
import com.takshine.wxcrm.message.sugar.GatheringAdd;
import com.takshine.wxcrm.message.sugar.GatheringReq;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.OrganizationService;
import com.takshine.wxcrm.service.WxRespMsgService;

/**
 * 若简报没有发送成功,则手动发送
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/noticeReport")
public class SendNoticeReportController {

	Logger logger = Logger.getLogger(SendNoticeReportController.class);
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 定时扫描通知信息(每天早上九点)并推送图文消息
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/noticeWork")
	public void noticeWork(HttpServletRequest request,HttpServletResponse response)throws Exception{
		 SenderInfor senderInfor1 = new SenderInfor();
		 senderInfor1.setContent("每日简报九点定时启动");
		 senderInfor1.setSubject("每日简报九点定时启动");
		 senderInfor1.setToEmails("pengmd@takshine.com");
		 String mailDerail1 = PropertiesUtil.getMailContext("mail.derail");
		 if ("1".equals(mailDerail1)) {
			 MailUtils.sendEmail(senderInfor1);
		 }
		
		Organization obj = new Organization();
		obj.setCurrpages(0);
		obj.setPagecounts(10000);
		// 调用后台查询数据库
		List<Organization> orgList = (List<Organization>) cRMService.getDbService().getOrganizationService().findObjListByFilter(obj);
		if (orgList != null && orgList.size() > 0) {
			for (Organization organization : orgList) {
				String crmurl = organization.getCrmurl();
				logger.info("SendNoticeReportController crmurl is ==>"+crmurl);
				if (StringUtils.isNotNullOrEmptyStr(crmurl)) {
					GatheringReq greq = new GatheringReq();
					greq.setModeltype(Constants.MODEL_TYPE_NOTICE);
					greq.setType(Constants.ACTION_SEARCH);
					greq.setCrmaccount(Constants.CRMID);
					// 转换为json
					String jsonStrNotice = JSONObject.fromObject(greq).toString();
					logger.info("SendNoticeReportController noticeReport jsonStrnotice => jsonStrNotice is : "+ jsonStrNotice);
					// 多次调用sugar接口
					try{
						String rstNotice = cRMService.getWxService().getWxHttpConUtil().postJsonData(crmurl,Constants.MODEL_URL_NOTICE, jsonStrNotice,Constants.INVOKE_MULITY);
						logger.info("SendNoticeReportController noticeReport rst => rstNotice is : " + rstNotice);
						JSONObject jsonGath = JSONObject.fromObject(rstNotice.substring(rstNotice.indexOf("{")));
						List<GatheringAdd> glist = new ArrayList<GatheringAdd>();
						List<ScheduleAdd> slist = new ArrayList<ScheduleAdd>();
						List<ExpenseAdd> elist = new ArrayList<ExpenseAdd>();
						List<OpptyAdd> olist = new ArrayList<OpptyAdd>();
						List<ContactAdd> clist = new ArrayList<ContactAdd>();
						List<DcCrmOperator> dclist = new ArrayList<DcCrmOperator>(); 
						if (!jsonGath.containsKey("errcode")) {
							if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("tasks"))) {
								slist = (List<ScheduleAdd>) JSONArray.toCollection(jsonGath.getJSONArray("tasks"),ScheduleAdd.class);
							}
							if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("gathering"))) {
								glist = (List<GatheringAdd>) JSONArray.toCollection(jsonGath.getJSONArray("gathering"),GatheringAdd.class);
							}
							if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("expense"))) {
								elist = (List<ExpenseAdd>) JSONArray.toCollection(jsonGath.getJSONArray("expense"),ExpenseAdd.class);
							}
							if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("opptys"))) {
								olist = (List<OpptyAdd>) JSONArray.toCollection(jsonGath.getJSONArray("opptys"),OpptyAdd.class);
							}
							if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("contacts"))) {
								clist = (List<ContactAdd>) JSONArray.toCollection(jsonGath.getJSONArray("contacts"),ContactAdd.class);
							}
							if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("emails"))) {
								dclist = (List<DcCrmOperator>) JSONArray.toCollection(jsonGath.getJSONArray("emails"),DcCrmOperator.class);
							}
						} else {
							// 错误代码和消息
							String errcode = jsonGath.getString("errcode");
							String errmsg = jsonGath.getString("errmsg");
							logger.info("noticeWork jsonGath errcode => errcode is : "+ errcode);
							logger.info("noticeWork jsonGath errmsg => errmsg is : "+ errmsg);
						}
						Map<String, String> map = new HashMap<String, String>();
						logger.info("SendNoticeReportController each expenselist start....");
						logger.info("SendNoticeReportController expenselist size ==>"+elist.size());
						//报销费用
						for (int i = 0; i < elist.size(); i++) {
							ExpenseAdd expenseAdd = elist.get(i);
							String assignerid = expenseAdd.getAssignid();
							String noticetype = expenseAdd.getNoticetype();
							String nums = expenseAdd.getNums();
							if (map.keySet() == null|| !map.keySet().contains(assignerid)) {
								map.put(assignerid, noticetype+"-"+nums+";");
							} else {
								String str = map.get(assignerid);
								map.put(assignerid, str+noticetype+"-"+nums+";");
							}
						}
						logger.info("SendNoticeReportController each opptylist start.....");
						logger.info("SendNoticeReportController opptylist size ====>"+olist.size());
						//商机
						for (int i = 0; i < olist.size(); i++) {
							OpptyAdd opptyAdd = olist.get(i);
							String assignerid = opptyAdd.getAssignerid();
							String noticetype = opptyAdd.getNoticetype();
							String nums = opptyAdd.getNums();
							if (map.keySet() == null|| !map.keySet().contains(assignerid)) {
								map.put(assignerid, noticetype+"-"+nums+";");
							} else {
								String str = map.get(assignerid);
								map.put(assignerid, str+noticetype+"-"+nums+";");
							}
						}
						logger.info("SendNoticeReportController each tasklist start.....");
						logger.info("SendNoticeReportController tasklist size====>"+slist.size());
						//任务
						for (int i = 0; i < slist.size(); i++) {
							ScheduleAdd scheduleAdd = slist.get(i);
							String assignerid = scheduleAdd.getAssignerid();
							String noticetype = scheduleAdd.getNoticetype();
							String nums = scheduleAdd.getNums();
							if (map.keySet() == null|| !map.keySet().contains(assignerid)) {
								map.put(assignerid, noticetype+"-"+nums+";");
							} else {
								String str = map.get(assignerid);
								map.put(assignerid, str+noticetype+"-"+nums+";");
							}
						}
						logger.info("SendNoticeReportController each contactlist start.....");
						logger.info("SendNoticeReportController contactlist size===>"+clist.size());
						//联系人
						for (int i = 0; i < clist.size(); i++) {
							ContactAdd contactAdd = clist.get(i);
							String assignerid = contactAdd.getAssignerId();
							String noticetype = contactAdd.getNoticetype();
							String nums = contactAdd.getNums();
							if (map.keySet() == null|| !map.keySet().contains(assignerid)) {
								map.put(assignerid, noticetype+"-"+nums+";");
							} else {
								String str = map.get(assignerid);
								map.put(assignerid, str+noticetype+"-"+nums+";");
							}
						}
						Map<String, String> mailMap = new HashMap<String, String>();
						logger.info("SendNoticeReportController each dclist start......");
						logger.info("SendNoticeReportController dclist size===>"+dclist.size());
						//邮件列表
						for(int i=0;i<dclist.size();i++){
							DcCrmOperator dcCrmOperator = dclist.get(i);
							String email = dcCrmOperator.getOpEmail();
							String assignername = dcCrmOperator.getOpName();
							String assignerid = dcCrmOperator.getOpId();
							if(StringUtils.isNotNullOrEmptyStr(assignerid)){
								mailMap.put(assignerid, assignername+"-"+email);
							}
						}
						logger.info("SendNoticeReportController each map start......");
						//发送图文消息
						if(map!=null&&map.size()>0){
							logger.info("SendNoticeReportController map size ===>"+map.size());
							String date = DateTime.currentDate("yyyy年MM月dd日");
							for(String key:map.keySet()){
								OperatorMobile oper  = new OperatorMobile();
								oper.setCrmId(key);
								List<OperatorMobile> list = cRMService.getDbService().getOperatorMobileService().getOperMobileListByPara(oper);
								String mailmodule = PropertiesUtil.getMailContext("mailModule");
								String mailstr = mailMap.get(key);
								String assignername = "";
								String email = "";
								if(StringUtils.isNotNullOrEmptyStr(mailstr)&&mailstr.contains("-")){
									assignername=mailstr.split("-")[0];
									email=mailstr.split("-")[1];
								}
								logger.info("SendNoticeReportController send assignerid is ===>"+key);
								logger.info("SendNoticeReportController send assignername is ===>"+assignername);
								logger.info("SendNoticeReportController send email is ===>"+email);
								String mailcontent = "";
								String projectname = PropertiesUtil.getAppContext("app.content");
								String str = map.get(key);
								String[] array = null;
								if(StringUtils.isNotNullOrEmptyStr(str)&&str.contains(";")){
									array = str.split(";");
								}
								logger.info("SendNoticeReportController send str is ===>"+str);
								List<Article> articles = new ArrayList<Article>();
								Article article = new Article();
								article.setTitle("【"+date+"简报"+"】");
								article.setDescription("【"+date+"简报"+"】");  
								article.setPicUrl(projectname + "/image/title_report_manager.png");  
								article.setUrl(""); 
								articles.add(article);
								Article article1 = null;
								String title = "";
								String desc = "";
								String url = "";
								String picurl="";
								String string="";
								logger.info("SendNoticeReportController packaging content start .....");
								for(String content:array){
									String type = content.split("-")[0];
									String nums = content.split("-")[1];
									article1 = new Article();
									if(type.contains("task_today")){
										title = "今日任务（"+nums+"）";
										desc="今日任务";
										picurl="/image/list_task_today.png";
										url="/schedule/list?viewtype=todayview&";
										string = "-- "+nums+"个今日任务；";
									}else if(type.contains("task_history")){
										title = "延期未完成任务（"+nums+"）";
										desc="延期未完成任务";
										picurl="/image/list_task_uncomplete.png";
										url="/schedule/list?viewtype=noticeview&";
										string = "-- "+nums+"个延期未完成的任务；";
									}else if(type.contains("expense_reject")){
										title = "我的被驳回的报销（"+nums+"）";
										desc="我的被驳回的报销";
										picurl="/image/list_expense_reject.png";
										url="/expense/list?viewtype=myview&viewtypesel=myview_reject&approval=reject&";
										string = "-- "+nums+"条被驳回的报销；";
									}else if(type.contains("expense_approving")){
										title = "需要我审批的报销（"+nums+"）";
										desc="需要我审批的报销";
										picurl="/image/list_expense_wait.png";
										url="/expense/list?viewtype=approvalview&viewtypesel=approvalview&";
										string = "-- "+nums+"条需要我审批的报销；";
									}else if(type.contains("oppty_delay")){
										title = "超过15天未跟进的业务机会（"+nums+"）";
										desc="超过15天未跟进的业务机会";
										picurl="/image/list_oppty_flow.png";
										url="/oppty/opptylist?viewtype=noticeview&";
										string = "-- "+nums+"个超过15天未跟进的业务机会；";
									}else if(type.contains("oppty_closed")){
										title = "过期未关闭的业务机会（"+nums+"）";
										desc="过期未关闭的业务机会";
										picurl="/image/list_oppty_unflow.png";
										url="/oppty/opptylist?viewtype=noclosedview&";
										string = "-- "+nums+"个过期未关闭的业务机会；";
									}else if(type.contains("contact_freq")){
										title = "长期未联系的人（"+nums+"）";
										desc="长期未联系的人";
										picurl="/image/list_accnt_my.png";
										url="/contact/clist?viewtype=noticeview&";
										string = "-- "+nums+"个长期未联系的人；";
									}
									article1.setTitle(title);
									article1.setDescription(desc);  
									article1.setPicUrl(projectname + picurl);  
									article1.setUrl(projectname + url); 
									articles.add(article1);
									mailcontent+="<div>"+string+"</div>";
								}
								logger.info("SendNoticeReportController post wxuser start ===>");
								if(list!=null&&list.size()>0){
									for (int i = 0; i < list.size(); i++) {
										AccessToken at = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
										logger.info("SendNoticeReportController post wxuser at ===>"+at);
										OperatorMobile op = (OperatorMobile)list.get(i);
										String openId = op.getOpenId();
										String publicId = op.getPublicId();
										logger.info("SendNoticeReportController post wxuser openId ===>"+openId);
										logger.info("SendNoticeReportController post wxuser publicId ===>"+publicId);
										//追加的后缀参数
										 String tpUrl = "openId="+ op.getOpenId()+ "&publicId="+publicId;
										 logger.info("SendNoticeReportController post wxuser tpUrl ===>"+tpUrl);
										 WxUtil.customArticleMsgSend(at.getToken(),openId,articles,tpUrl);
										 String loginTime = RedisCacheUtil.getString(Constants.LOGINTIME_KEY+"_"+key);
										 logger.info("SendNoticeReportController post wxuser loginTime ===>"+loginTime);
										 if(StringUtils.isNotNullOrEmptyStr(loginTime)&&DateTime.comDate(loginTime,PropertiesUtil.getMailContext("mail.differtime"),DateTime.DateTimeFormat1)){
											 logger.info("SendNoticeReportController send assigneremail start ===>");
											 SenderInfor senderInfor = new SenderInfor();
											 senderInfor.setContent(mailmodule.replaceAll("@@assigner@@", assignername).replaceAll("@@content@@",mailcontent));
											 senderInfor.setSubject(date+"简报");
											 if(StringUtils.isNotNullOrEmptyStr(email)){
												 senderInfor.setToEmails(email);
												 logger.info("SendNoticeReportController send assigneremail email (longtime)===>"+email);
												 String mailDerail = PropertiesUtil.getMailContext("mail.derail");
												 if ("1".equals(mailDerail)) {
													 MailUtils.sendEmail(senderInfor);
												 } 
											 }
										 }
									}
								}else{
									 logger.info("SendNoticeReportController send email start ===>");
									 SenderInfor senderInfor = new SenderInfor();
									 senderInfor.setContent(mailmodule.replaceAll("@@assigner@@", assignername).replaceAll("@@content@@",mailcontent));
									 senderInfor.setSubject(date+"简报");
									 if(StringUtils.isNotNullOrEmptyStr(email)){
										 senderInfor.setToEmails(email);
										 logger.info("SendNoticeReportController send email is ===>"+email);
										 String mailDerail = PropertiesUtil.getMailContext("mail.derail");
										 if ("1".equals(mailDerail)) {
											 MailUtils.sendEmail(senderInfor);
										 }
									 }
								}
							}
						}
					  }catch(Exception e){
						e.printStackTrace();
						continue;
					 }
				}
			}
		}
	}

	@RequestMapping("/notice")
	public void noticeWorks(HttpServletRequest request,HttpServletResponse response)throws Exception{
		Organization obj = new Organization();
		obj.setCurrpages(0);
		obj.setPagecounts(10000);
		// 调用后台查询数据库
		List<Organization> orgList = (List<Organization>) cRMService.getDbService().getOrganizationService().findObjListByFilter(obj);
		if (orgList != null && orgList.size() > 0) {
			for (Organization organization : orgList) {
				String crmurl = organization.getCrmurl();
				logger.info("ScheduledScansServiceImpl crmurl is ==>"+crmurl);
				if (StringUtils.isNotNullOrEmptyStr(crmurl)) {
					GatheringReq greq = new GatheringReq();
					greq.setModeltype(Constants.MODEL_TYPE_NOTICE);
					greq.setType(Constants.ACTION_SEARCH);
					greq.setCrmaccount(Constants.CRMID);
					// 转换为json
					String jsonStrNotice = JSONObject.fromObject(greq).toString();
					logger.info("ScheduledScansServiceImpl noticeWork jsonStrnotice => jsonStrNotice is : "+ jsonStrNotice);
					// 多次调用sugar接口
					try{
					String rstNotice = cRMService.getWxService().getWxHttpConUtil().postJsonData(crmurl,Constants.MODEL_URL_NOTICE, jsonStrNotice,Constants.INVOKE_MULITY);
					logger.info("ScheduledScansServiceImpl noticeWork rst => rstNotice is : " + rstNotice);
					JSONObject jsonGath = JSONObject.fromObject(rstNotice.substring(rstNotice.indexOf("{")));
					List<GatheringAdd> glist = new ArrayList<GatheringAdd>();
					List<ScheduleAdd> slist = new ArrayList<ScheduleAdd>();
					List<ExpenseAdd> elist = new ArrayList<ExpenseAdd>();
					List<OpptyAdd> olist = new ArrayList<OpptyAdd>();
					List<ContactAdd> clist = new ArrayList<ContactAdd>();
					List<DcCrmOperator> dclist = new ArrayList<DcCrmOperator>(); 
					if (!jsonGath.containsKey("errcode")) {
						if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("tasks"))) {
							slist = (List<ScheduleAdd>) JSONArray.toCollection(jsonGath.getJSONArray("tasks"),ScheduleAdd.class);
						}
						if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("gathering"))) {
							glist = (List<GatheringAdd>) JSONArray.toCollection(jsonGath.getJSONArray("gathering"),GatheringAdd.class);
						}
						if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("expense"))) {
							elist = (List<ExpenseAdd>) JSONArray.toCollection(jsonGath.getJSONArray("expense"),ExpenseAdd.class);
						}
						if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("opptys"))) {
							olist = (List<OpptyAdd>) JSONArray.toCollection(jsonGath.getJSONArray("opptys"),OpptyAdd.class);
						}
						if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("contacts"))) {
							clist = (List<ContactAdd>) JSONArray.toCollection(jsonGath.getJSONArray("contacts"),ContactAdd.class);
						}
						if (StringUtils.isNotNullOrEmptyStr(jsonGath.getString("emails"))) {
							dclist = (List<DcCrmOperator>) JSONArray.toCollection(jsonGath.getJSONArray("emails"),DcCrmOperator.class);
						}
					} else {
						// 错误代码和消息
						String errcode = jsonGath.getString("errcode");
						String errmsg = jsonGath.getString("errmsg");
						logger.info("ScheduledScansServiceImpl noticeWork jsonGath errcode => errcode is : "+ errcode);
						logger.info("ScheduledScansServiceImpl noticeWork jsonGath errmsg => errmsg is : "+ errmsg);
					}
					//定义一个全局map变量
					Map<String, List<Article>> map = new HashMap<String, List<Article>>();
					//邮件全局变量
					Map<String, String> mailMap = new HashMap<String, String>();
					List<Article> list = new ArrayList<Article>();
					String date = DateTime.currentDate("yyyy年MM月dd日");
					String projectname = PropertiesUtil.getAppContext("app.content");
					//定义简报的标题
					Article article = new Article();
					article.setTitle("【"+date+"简报"+"】");
					article.setDescription("【"+date+"简报"+"】");  
					article.setPicUrl(projectname + "/image/title_report_manager.png");  
					article.setUrl("");
					String title = "";//图文消息名称
					String desc = "";//描述
					String url = "";//地址
					String picurl="";//图片地址
					String string="";//邮件详细内容
					logger.info("ScheduledScansServiceImpl each expenselist start....");
					logger.info("ScheduledScansServiceImpl expenselist size ==>"+elist.size());
					//报销费用
					for (int i = 0; i < elist.size(); i++) {
						Article article1 = new Article();
						ExpenseAdd expenseAdd = elist.get(i);
						String assignerid = expenseAdd.getAssignid();
						String noticetype = expenseAdd.getNoticetype();
						String nums = expenseAdd.getNums();
						if(StringUtils.isNotNullOrEmptyStr(noticetype)){
							if(noticetype.contains("expense_reject")){
								title = "我的被驳回的报销（"+nums+"）";
								desc="我的被驳回的报销";
								picurl="/image/list_expense_reject.png";
								url="/expense/list?viewtype=myview&viewtypesel=myview_reject&approval=reject&";
								string = "<div>-- "+nums+"条被驳回的报销；</div>";
							}else if(noticetype.contains("expense_approving")){
								title = "需要我审批的报销（"+nums+"）";
								desc="需要我审批的报销";
								picurl="/image/list_expense_wait.png";
								url="/expense/list?viewtype=approvalview&viewtypesel=approvalview&";
								string = "<div>-- "+nums+"条需要我审批的报销；</div>";
							}
							article1.setTitle(title);
							article1.setDescription(desc);  
							article1.setPicUrl(projectname + picurl);  
							article1.setUrl(projectname + url); 
						}
						if (map.keySet() == null|| !map.keySet().contains(assignerid)) {
							list = new ArrayList<Article>();
							list.add(article);
							list.add(article1);
							map.put(assignerid, list);
							mailMap.put(assignerid, string);
						} else {
							List<Article> artlist = map.get(assignerid);
							artlist.add(article1);
							map.put(assignerid, artlist);
							String str = mailMap.get(assignerid);
							str += string;
							mailMap.put(assignerid, str);
						}
					}
					logger.info("ScheduledScansServiceImpl each opptylist start.....");
					logger.info("ScheduledScansServiceImpl opptylist size ====>"+olist.size());
					//商机
					for (int i = 0; i < olist.size(); i++) {
						Article article1 = new Article();
						OpptyAdd opptyAdd = olist.get(i);
						String assignerid = opptyAdd.getAssignerid();
						String noticetype = opptyAdd.getNoticetype();
						String nums = opptyAdd.getNums();
						if(StringUtils.isNotNullOrEmptyStr(noticetype)){
							if(noticetype.contains("oppty_delay")){
								title = "超过15天未跟进的业务机会（"+nums+"）";
								desc="超过15天未跟进的业务机会";
								picurl="/image/list_oppty_flow.png";
								url="/oppty/opptylist?viewtype=noticeview&";
								string = "<div>-- "+nums+"个超过15天未跟进的业务机会；</div>";
							}else if(noticetype.contains("oppty_closed")){
								title = "过期未关闭的业务机会（"+nums+"）";
								desc="过期未关闭的业务机会";
								picurl="/image/list_oppty_unflow.png";
								url="/oppty/opptylist?viewtype=noclosedview&";
								string = "<div>-- "+nums+"个过期未关闭的业务机会；</div>";
							}
							article1.setTitle(title);
							article1.setDescription(desc);  
							article1.setPicUrl(projectname + picurl);  
							article1.setUrl(projectname + url); 
						}
						if (map.keySet() == null|| !map.keySet().contains(assignerid)) {
							list = new ArrayList<Article>();
							list.add(article);
							list.add(article1);
							map.put(assignerid, list);
							mailMap.put(assignerid, string);
						} else {
							List<Article> artlist = map.get(assignerid);
							artlist.add(article1);
							map.put(assignerid, artlist);
							String str = mailMap.get(assignerid);
							str += string;
							mailMap.put(assignerid, str);
						}
					}
					logger.info("ScheduledScansServiceImpl each tasklist start.....");
					logger.info("ScheduledScansServiceImpl tasklist size====>"+slist.size());
					//任务
					for (int i = 0; i < slist.size(); i++) {
						Article article1 = new Article();
						ScheduleAdd scheduleAdd = slist.get(i);
						String assignerid = scheduleAdd.getAssignerid();
						String noticetype = scheduleAdd.getNoticetype();
						String nums = scheduleAdd.getNums();
						if(StringUtils.isNotNullOrEmptyStr(noticetype)){
							if(noticetype.contains("task_today")){
								title = "今日任务（"+nums+"）";
								desc="今日任务";
								picurl="/image/list_task_today.png";
								url="/schedule/list?viewtype=todayview&";
								string = "<div>-- "+nums+"个今日任务；</div>";
							}else if(noticetype.contains("task_history")){
								title = "延期未完成任务（"+nums+"）";
								desc="延期未完成任务";
								picurl="/image/list_task_uncomplete.png";
								url="/schedule/list?viewtype=noticeview&";
								string = "<div>-- "+nums+"个延期未完成的任务；</div>";
							}
							article1.setTitle(title);
							article1.setDescription(desc);  
							article1.setPicUrl(projectname + picurl);  
							article1.setUrl(projectname + url); 
						}
						if (map.keySet() == null|| !map.keySet().contains(assignerid)) {
							list = new ArrayList<Article>();
							list.add(article);
							list.add(article1);
							map.put(assignerid, list);
							mailMap.put(assignerid, string);
						} else {
							List<Article> artlist = map.get(assignerid);
							artlist.add(article1);
							map.put(assignerid, artlist);
							String str = mailMap.get(assignerid);
							str += string;
							mailMap.put(assignerid, str);
						}
					}
					logger.info("ScheduledScansServiceImpl each contactlist start.....");
					logger.info("ScheduledScansServiceImpl contactlist size===>"+clist.size());
					//联系人
					for (int i = 0; i < clist.size(); i++) {
						Article article1 = new Article();
						ContactAdd contactAdd = clist.get(i);
						String assignerid = contactAdd.getAssignerId();
						String noticetype = contactAdd.getNoticetype();
						String nums = contactAdd.getNums();
						if(StringUtils.isNotNullOrEmptyStr(noticetype)){
							if(noticetype.contains("contact_freq")){
								title = "长期未联系的人（"+nums+"）";
								desc="长期未联系的人";
								picurl="/image/list_accnt_my.png";
								url="/contact/clist?viewtype=noticeview&";
								string = "<div>-- "+nums+"个长期未联系的人；</div>";
							}
							article1.setTitle(title);
							article1.setDescription(desc);  
							article1.setPicUrl(projectname + picurl);  
							article1.setUrl(projectname + url); 
						}
						if (map.keySet() == null|| !map.keySet().contains(assignerid)) {
							list = new ArrayList<Article>();
							list.add(article);
							list.add(article1);
							map.put(assignerid, list);
							mailMap.put(assignerid, string);
						} else {
							List<Article> artlist = map.get(assignerid);
							artlist.add(article1);
							map.put(assignerid, artlist);
							String str = mailMap.get(assignerid);
							str += string;
							mailMap.put(assignerid, str);
						}
					}
					Map<String, String> eMap = new HashMap<String, String>();
					logger.info("ScheduledScansServiceImpl each dclist start......");
					logger.info("ScheduledScansServiceImpl dclist size===>"+dclist.size());
					//邮件列表
					for(int i=0;i<dclist.size();i++){
						DcCrmOperator dcCrmOperator = dclist.get(i);
						String email = dcCrmOperator.getOpEmail();
						String assignername = dcCrmOperator.getOpName();
						String assignerid = dcCrmOperator.getOpId();
						if(StringUtils.isNotNullOrEmptyStr(assignerid)){
							eMap.put(assignerid, assignername+"-"+email);
//							eMap.put(assignerid, assignername+"-dengbo@takshine.com");
						}
					}
					logger.info("ScheduledScansServiceImpl each map start......");
					//发送图文消息
					if(map!=null&&map.size()>0){
						logger.info("ScheduledScansServiceImpl map size ===>"+map.size());
						for(String key:map.keySet()){
							List<Article> articles = map.get(key);
							OperatorMobile oper  = new OperatorMobile();
							oper.setCrmId(key);
							List<OperatorMobile> operlist = cRMService.getDbService().getOperatorMobileService().getOperMobileListByPara(oper);
							String mailstr = eMap.get(key);
							String assignername = "";
							String email = "";
							if(StringUtils.isNotNullOrEmptyStr(mailstr)&&mailstr.contains("-")){
								assignername=mailstr.split("-")[0];
								email=mailstr.split("-")[1];
							}
							String mailmodule = PropertiesUtil.getMailContext("mailModule");
							String mailcontent = mailMap.get(key);
							logger.info("ScheduledScansServiceImpl send assignerid is ===>"+key);
							logger.info("ScheduledScansServiceImpl send assignername is ===>"+assignername);
							logger.info("ScheduledScansServiceImpl send email is ===>"+email);
							logger.info("ScheduledScansServiceImpl send mailcontent is ===>"+mailcontent);
							if(operlist!=null&&operlist.size()>0){
								AccessToken at = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
								logger.info("ScheduledScansServiceImpl post wxuser at ===>"+at);
								OperatorMobile op = (OperatorMobile)operlist.get(0);
								String openId = op.getOpenId();
								String publicId = op.getPublicId();
								logger.info("ScheduledScansServiceImpl post wxuser openId ===>"+openId);
								logger.info("ScheduledScansServiceImpl post wxuser publicId ===>"+publicId);
								//追加的后缀参数
								String tpUrl = "openId="+ op.getOpenId()+ "&publicId="+publicId;
								logger.info("ScheduledScansServiceImpl post wxuser tpUrl ===>"+tpUrl);
								WxUtil.customArticleMsgSend(at.getToken(),openId,articles,tpUrl);
								String loginTime = RedisCacheUtil.getString(Constants.LOGINTIME_KEY+"_"+key);
								logger.info("ScheduledScansServiceImpl post wxuser loginTime ===>"+loginTime);
								if(StringUtils.isNotNullOrEmptyStr(loginTime)&&DateTime.comDate(loginTime,PropertiesUtil.getMailContext("mail.differtime"),DateTime.DateTimeFormat1)){
									 logger.info("ScheduledScansServiceImpl send assigneremail start ===>");
									 SenderInfor senderInfor = new SenderInfor();
									 senderInfor.setContent(mailmodule.replaceAll("@@assigner@@", assignername).replaceAll("@@content@@",mailcontent));
									 senderInfor.setSubject(date+"简报");
									 if(StringUtils.isNotNullOrEmptyStr(email)){
										 senderInfor.setToEmails(email);
										 logger.info("ScheduledScansServiceImpl send assigneremail email (longtime)===>"+email);
										 String mailDerail = PropertiesUtil.getMailContext("mail.derail");
										 if ("1".equals(mailDerail)) {
											 MailUtils.sendEmail(senderInfor);
										 } 
									 }
								 }
							}else{
								 logger.info("ScheduledScansServiceImpl send email start ===>");
								 SenderInfor senderInfor = new SenderInfor();
								 senderInfor.setContent(mailmodule.replaceAll("@@assigner@@", assignername).replaceAll("@@content@@",mailcontent));
								 senderInfor.setSubject(date+"简报");
								 if(StringUtils.isNotNullOrEmptyStr(email)){
									 senderInfor.setToEmails(email);
									 logger.info("ScheduledScansServiceImpl send email is ===>"+email);
									 String mailDerail = PropertiesUtil.getMailContext("mail.derail");
									 if ("1".equals(mailDerail)) {
										 MailUtils.sendEmail(senderInfor);
									 }
								}
							}
						}
					}
				}catch(Exception e){
					e.printStackTrace();
					continue;
					}
				}
			}
		}
	}
}
