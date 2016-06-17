package com.takshine.wxcrm.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.exception.CRMException;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.ActivityParticipant;
import com.takshine.marketing.domain.Participant;
import com.takshine.marketing.service.ActivityService;
import com.takshine.marketing.service.ParticipantService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.HttpClient3Post;
import com.takshine.wxcrm.base.util.MailUtils;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.SenderInfor;
import com.takshine.wxcrm.base.util.ServiceUtils;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.base.util.ZJDateUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.base.util.runtime.SMSSentThread;
import com.takshine.wxcrm.base.util.runtime.ThreadExecute;
import com.takshine.wxcrm.base.util.runtime.ThreadRun;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.Comments;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.NoticeReport;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.WorkReport;
import com.takshine.wxcrm.message.oauth.AccessToken;
import com.takshine.wxcrm.message.resp.Article;
import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.message.sugar.ExpenseAdd;
import com.takshine.wxcrm.message.sugar.GatheringAdd;
import com.takshine.wxcrm.message.sugar.GatheringReq;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleReq;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.CommentsService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.OrganizationService;
import com.takshine.wxcrm.service.ScheduledScansService;
import com.takshine.wxcrm.service.UserPerferencesService;
import com.takshine.wxcrm.service.WorkPlanService;
import com.takshine.wxcrm.service.WxRespMsgService;
import com.takshine.wxcrm.service.WxUserinfoService;
import com.takshine.wxcrm.service.ZJWKSystemTaskService;

@Service("scheduledScansService")
public class ScheduledScansServiceImpl implements ScheduledScansService {

	// 日志
	protected Logger logger = Logger.getLogger(ScheduledScansServiceImpl.class);
	
	//----------------------------------------------微信公众号命令菜单接口使用---------------------------------
	@Autowired
	@Qualifier("wxUserinfoService")
	private WxUserinfoService wxUserinfoService;
	@Autowired
	@Qualifier("zjwkSystemTaskService")
	private ZJWKSystemTaskService wxZJWKSystemTaskService;
	@Autowired
	@Qualifier("wxRespMsgService")
	private WxRespMsgService wxZJWKRespMsgService;
	//---------------------------------------------------------------------------------------

	private WxHttpConUtil util;
	private OrganizationService organizationService;
	private WxRespMsgService wxRespMsgService;
	private OperatorMobileService operatorMobileService;
	private BusinessCardService businessCardService;
	private ZJWKSystemTaskService zjwkSystemTaskService;
	private ActivityService activityService;
	private ParticipantService participantService;
	private UserPerferencesService userPerferencesService;
	private CommentsService commentsService;
	private WorkPlanService workPlanService;
	public WorkPlanService getWorkPlanService() {
		return workPlanService;
	}

	public void setWorkPlanService(WorkPlanService workPlanService) {
		this.workPlanService = workPlanService;
	}
	private LovUser2SugarService lovUser2SugarService;
	public void setLovUser2SugarService(LovUser2SugarService lovUser2SugarService) {
		this.lovUser2SugarService = lovUser2SugarService;
	}
	public void setCommentsService(CommentsService commentsService) {
		this.commentsService = commentsService;
	}
	public UserPerferencesService getUserPerferencesService() {
		return userPerferencesService;
	}

	public void setUserPerferencesService(
			UserPerferencesService userPerferencesService) {
		this.userPerferencesService = userPerferencesService;
	}

	
	public void setParticipantService(ParticipantService participantService) {
		this.participantService = participantService;
	}
	public void setActivityService(ActivityService activityService) {
		this.activityService = activityService;
	}

	public ZJWKSystemTaskService getZjwkSystemTaskService() {
		return zjwkSystemTaskService;
	}

	public void setZjwkSystemTaskService(ZJWKSystemTaskService zjwkSystemTaskService) {
		this.zjwkSystemTaskService = zjwkSystemTaskService;
	}

	public BusinessCardService getBusinessCardService() {
		return businessCardService;
	}

	public void setBusinessCardService(BusinessCardService businessCardService) {
		this.businessCardService = businessCardService;
	}

	public OrganizationService getOrganizationService() {
		return organizationService;
	}

	public void setOrganizationService(OrganizationService organizationService) {
		this.organizationService = organizationService;
	}

	public WxHttpConUtil getUtil() {
		return util;
	}

	public void setUtil(WxHttpConUtil util) {
		this.util = util;
	}

	public WxRespMsgService getWxRespMsgService() {
		return wxRespMsgService;
	}

	public void setWxRespMsgService(WxRespMsgService wxRespMsgService) {
		this.wxRespMsgService = wxRespMsgService;
	}

	public OperatorMobileService getOperatorMobileService() {
		return operatorMobileService;
	}

	public void setOperatorMobileService(
			OperatorMobileService operatorMobileService) {
		this.operatorMobileService = operatorMobileService;
	}

	/**
	 * 定时扫描通知信息（每天早上九点）并发邮件通知
	 */
	@SuppressWarnings("unchecked")
	public void noticeWorks() {
		Organization obj = new Organization();
		obj.setCurrpages(0);
		obj.setPagecounts(10000);
		// 调用后台查询数据库
		List<Organization> orgList = (List<Organization>) organizationService.findObjListByFilter(obj);
		if (orgList != null && orgList.size() > 0) {
			for (Organization organization : orgList) {
				String crmurl = organization.getCrmurl();
				if (StringUtils.isNotNullOrEmptyStr(crmurl)) {
					GatheringReq greq = new GatheringReq();
					greq.setModeltype(Constants.MODEL_TYPE_NOTICE);
					greq.setType(Constants.ACTION_SEARCH);
					greq.setCrmaccount(Constants.CRMID);
					// 转换为json
					String jsonStrGath = JSONObject.fromObject(greq).toString();
					logger.info("noticeWork jsonStrGath => jsonStrGath is : "+ jsonStrGath);
					// 多次调用sugar接口
					String rstGath = util.postJsonData(crmurl,Constants.MODEL_URL_NOTICE, jsonStrGath,Constants.INVOKE_MULITY);
					logger.info("noticeWork rst => rstGath is : " + rstGath);
					JSONObject jsonGath = JSONObject.fromObject(rstGath.substring(rstGath.indexOf("{")));
					List<GatheringAdd> glist = new ArrayList<GatheringAdd>();
					List<ScheduleAdd> slist = new ArrayList<ScheduleAdd>();
					List<ExpenseAdd> elist = new ArrayList<ExpenseAdd>();
					List<OpptyAdd> olist = new ArrayList<OpptyAdd>();
					List<ContactAdd> clist = new ArrayList<ContactAdd>();
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
					} else {
						// 错误代码和消息
						String errcode = jsonGath.getString("errcode");
						String errmsg = jsonGath.getString("errmsg");
						logger.info("noticeWork jsonGath errcode => errcode is : "+ errcode);
						logger.info("noticeWork jsonGath errmsg => errmsg is : "+ errmsg);
					}
					// 邮件模板
					String mainMailModule = PropertiesUtil.getMailContext("mainMailModule");
					String branchMailModule = PropertiesUtil.getMailContext("branchMailModule");
					String signature = PropertiesUtil.getMailContext("signature");
					String link = PropertiesUtil.getMailContext("link");
					// 封装的邮件内容与邮箱地址
					Map<String, StringBuffer> map = new HashMap<String, StringBuffer>();
					StringBuffer stringBuffer = new StringBuffer();
					// 封装的wx推送消息与责任人
					Map<String, StringBuffer> mapWx = new HashMap<String, StringBuffer>();
					StringBuffer sbWx = new StringBuffer();
					// email为key,content为value
					// Map<String, String> mapKey = new HashMap<String,
					// String>();
					// 回款
					if (glist != null && glist.size() > 0) {
						String email = "";
						// String ccemail = "";
						Map<String, List<GatheringAdd>> mapGath = new HashMap<String, List<GatheringAdd>>();
						List<GatheringAdd> list = new ArrayList<GatheringAdd>();
						for (int i = 0; i < glist.size(); i++) {
							GatheringAdd gatheringAdd = glist.get(i);
							GatheringAdd gathering = new GatheringAdd();
							boolean flag = true;
							// String planDate =
							// gatheringAdd.getPlanDate();//计划收款日期
							email = gatheringAdd.getEmail();// 邮箱地址
							// if(email==null){
							// email="dengbo@takshine.com";
							// }
							// ccemail=gatheringAdd.getCcemail();//抄送人邮件地址
							// 判断实际收款日期与当前日期是否相差三天
							// if(DateTime.comDate(planDate)){
							if (mapGath.keySet() != null&& mapGath.keySet().size() > 0&& !mapGath.keySet().contains(email)) {
								list = new ArrayList<GatheringAdd>();
								flag = false;
							}
							gathering.setAssigner(gatheringAdd.getAssigner());
							gathering.setContractName(gatheringAdd.getContractName());
							gathering.setPlanDate(gatheringAdd.getPlanDate());
							gathering.setPlanAmount(gatheringAdd.getPlanAmount());
							gathering.setReceivedAmount(gatheringAdd.getReceivedAmount());
							gathering.setAssignid(gatheringAdd.getAssignid());
							if (StringUtils.isNotNullOrEmptyStr(email)) {
								if (i == 0 || !flag) {
									list.add(gathering);
									mapGath.put(email, list);
								} else {
									List<GatheringAdd> lists = mapGath.get(email);
									lists.add(gatheringAdd);
									mapGath.put(email, lists);
								}
								// mapKey.put(email, ccemail);
							}
						}
						if (mapGath != null && mapGath.size() > 0) {
							for (String key : mapGath.keySet()) {
								int i = 1;
								String content = "";
								String str = "";
								for (GatheringAdd gatheringAdd : mapGath.get(key)) {
									str += "<div>" + (i++) + "、关于合同【"+ gatheringAdd.getContractName()+ "】：计划于"+ gatheringAdd.getPlanDate()+ "收款￥"+ gatheringAdd.getPlanAmount()+ "万元";
									if (StringUtils.isNotNullOrEmptyStr(gatheringAdd.getReceivedAmount())) {
										str += "，目前已收￥"+ gatheringAdd.getReceivedAmount()+ "万元";
									}
									str += "；</div></br>";
								}
								String assigner = mapGath.get(key).get(0).getAssigner();
								content = branchMailModule.replaceAll("@@count@@",mapGath.get(key).size()+ "笔回款需要催收，请及时跟进！ ").replaceAll("@@list@@", str).replaceAll("@@assigner@@", assigner);
								stringBuffer.append(content);
								map.put(key, stringBuffer);
								// SenderInfor senderInfor = new SenderInfor();
								// String
								// string=mainMailModule.replaceAll("@@content@@",
								// content).replaceAll("@@link@@",link).replaceAll("@@signature@@",
								// signature);
								// senderInfor.setContent(string);
								// senderInfor.setSubject("收款通知");
								// senderInfor.setToEmails(key.split(";")[1]);
								// MailUtils.sendEmail(senderInfor);
								stringBuffer = new StringBuffer();

								// 微信推送消息
								String assignerId = mapGath.get(key).get(0).getAssignid();
								String planDate = mapGath.get(key).get(0).getPlanDate();
								String cont = "您今天有" + mapGath.get(key).size()+ "笔回款需要催收,";
								String detailUrl = "/gathering/list?viewtype=analyticsview&assignerId="+ assignerId+ "&startDate="+ planDate+ "&endDate=" + planDate;
								sbWx.append(cont + "___" + detailUrl + ";");
								mapWx.put(assignerId, sbWx);
								sbWx = new StringBuffer();
								// wxRespMsgService.respCommCustMsgByCrmId(assignerId,cont,detailUrl,operatorMobileService);
							}
						}
					}
					// 报销
					if (elist != null && elist.size() > 0) {
						String email = "";
						Map<String, List<ExpenseAdd>> mapExpe = new HashMap<String, List<ExpenseAdd>>();
						List<ExpenseAdd> list = new ArrayList<ExpenseAdd>();
						for (int i = 0; i < elist.size(); i++) {
							ExpenseAdd expenseAdd = elist.get(i);
							boolean flag = true;
							ExpenseAdd expense = new ExpenseAdd();
							email = expenseAdd.getEmail();// 邮箱地址
							if (mapExpe.keySet() != null&& mapExpe.keySet().size() > 0&& !mapExpe.keySet().contains(email)) {
								list = new ArrayList<ExpenseAdd>();
								flag = false;
							}
							expense.setAssigner(expenseAdd.getAssigner());// 经办人
							// expense.setExpenseamount(expenseAdd.getExpenseamount());//报销金额
							// expense.setExpensesubtypename(expenseAdd.getExpensesubtypename());
							// expense.setExpensedate(expenseAdd.getExpensedate());
							expense.setAssignid(expenseAdd.getAssignid());
							expense.setExpensestatus(expenseAdd.getExpensestatus());
							if (StringUtils.isNotNullOrEmptyStr(email)) {
								if (i == 0 || !flag) {
									list.add(expense);
									mapExpe.put(email, list);
								} else {
									List<ExpenseAdd> lists = mapExpe.get(email);
									lists.add(expense);
									mapExpe.put(email, lists);
								}
							}
						}
						if (mapExpe != null && mapExpe.size() > 0) {
							for (String key : mapExpe.keySet()) {
								int i = 1;
								String content = "";
								// 微信推送消息
								String assignerId = mapExpe.get(key).get(0).getAssignid();
								// String str="map2.get(string)+"笔报销费用"+";
								String string = "";
								Map<String, String> map2 = new HashMap<String, String>();
								for (ExpenseAdd expenseAdd : mapExpe.get(key)) {
									map2.put(expenseAdd.getExpensestatus(),(i++) + "");
								}
								if (map2.keySet().contains("approving")) {
									String detailUrl = "/expense/list?viewtype=approvalview&viewtypesel=approvalview";
									string += map2.get("approving")+ "笔报销费用需要审批;";
									if (mapWx != null && mapWx.size() > 0) {
										if (mapWx.containsKey(assignerId)) {
											sbWx = mapWx.get(assignerId);
											sbWx.append("您今天有" + string+ "____" + detailUrl + ";");
											mapWx.put(assignerId, sbWx);
											sbWx = new StringBuffer();
										} else {
											mapWx.put(assignerId,new StringBuffer().append("您今天有"+ string+ "___"+ detailUrl+ ";"));
										}
									}
									// wxRespMsgService.respCommCustMsgByCrmId(assignerId,"您今天有报销费用需要审批，",detailUrl,operatorMobileService);
								}
								if (map2.keySet().contains("reject")) {
									String detailUrl = "/expense/list?viewtype=myview&viewtypesel=myview_reject&approval=reject";
									string += map2.get("reject") + "笔报销费用被驳回;";
									if (mapWx.containsKey(assignerId)) {
										sbWx = mapWx.get(assignerId);
										sbWx.append("您今天有" + string + "___"+ detailUrl + ";");
										mapWx.put(assignerId, sbWx);
										sbWx = new StringBuffer();
									} else {
										mapWx.put(assignerId,new StringBuffer().append("您今天有" + string+ "___"+ detailUrl+ ";"));
									}
									// wxRespMsgService.respCommCustMsgByCrmId(assignerId,"您今天有报销费用被驳回，",detailUrl,operatorMobileService);
								}
								content = branchMailModule.replaceAll("@@count@@", string).replaceAll("@@list@@", "");
								if (map.keySet().contains(key)) {
									content = content.replaceFirst("@@assigner@@，您好！</br>", "");
									stringBuffer = map.get(key);
									stringBuffer.append(content);
									map.put(key, stringBuffer);
									stringBuffer = new StringBuffer();
								} else {
									content = content.replaceAll("@@assigner@@", mapExpe.get(key).get(0).getAssigner());
									map.put(key,new StringBuffer().append(content));
								}
							}
							// for(String key : mapExpe.keySet()){
							// int i=1;
							// String content="";
							// String str="";
							// String string="";
							// for(ExpenseAdd expenseAdd:mapExpe.get(key)){
							// if("approved".equals(expenseAdd.getExpensestatus())){
							// string="需要您审批;";
							// }else
							// if("reject".equals(expenseAdd.getExpensestatus())){
							// string="被驳回;";
							// }
							// str +=
							// "<div>"+(i++)+"、"+expenseAdd.getAssigner()+"于"+expenseAdd.getExpensedate()+",在"+expenseAdd.getDepartment()+expenseAdd.getParenttype()+"【"+expenseAdd.getParentname()+"】过程中产生了一笔"+expenseAdd.getExpensesubtypename()+"（￥"+expenseAdd.getExpenseamount()+"）"+string+"</div>";
							// }
							// content=branchMailModule.replaceAll("@@count@@",mapExpe.get(key).size()+"笔报销费用"+string).replaceAll("@@list@@",
							// str).replaceAll("@@assigner@@",mapExpe.get(key).get(0).getAssigner());
							// if(map!=null&&map.keySet().size()>0&&map.keySet().contains(key)){
							// stringBuffer.append(content);
							// map.put(key, stringBuffer.toString());
							// }else{
							// map.put(key,content);
							// }
							// }
						}
					}
					// 任务
					if (slist != null && slist.size() > 0) {
						String email = "";
						Map<String, List<ScheduleAdd>> mapSche = new HashMap<String, List<ScheduleAdd>>();
						List<ScheduleAdd> list = new ArrayList<ScheduleAdd>();
						for (int i = 0; i < slist.size(); i++) {
							boolean flag = true;
							ScheduleAdd scheduleAdd = slist.get(i);
							ScheduleAdd schedule = new ScheduleAdd();
							email = scheduleAdd.getEmail();// 邮箱地址
							schedule.setAssigner(scheduleAdd.getAssigner());// 责任人
							schedule.setStartdate(scheduleAdd.getStartdate());// 开始时间
							schedule.setTitle(scheduleAdd.getTitle());// 主题
							schedule.setAssignerid(scheduleAdd.getAssignerid());
							if (mapSche.keySet() != null&& mapSche.keySet().size() > 0&& !mapSche.keySet().contains(email)) {
								list = new ArrayList<ScheduleAdd>();
								flag = false;
							}
							if (StringUtils.isNotNullOrEmptyStr(email)) {
								if (i == 0 || !flag) {
									list.add(schedule);
									mapSche.put(email, list);
								} else {
									List<ScheduleAdd> lists = mapSche.get(email);
									lists.add(schedule);
									mapSche.put(email, lists);
								}
							}
						}
						if (mapSche != null && mapSche.size() > 0) {
							for (String key : mapSche.keySet()) {
								int i = 1;
								String content = "";
								String str = "";
								for (ScheduleAdd scheduleAdd : mapSche.get(key)) {
									str += "<div>" + (i++) + "、【"+ scheduleAdd.getTitle() + "】：开始于"+ scheduleAdd.getStartdate()+ "；</div></br>";
								}
								content = branchMailModule.replaceAll("@@count@@",mapSche.get(key).size() + "个任务,请及时查看！").replaceAll("@@list@@", str);
								if (map.keySet().contains(key)) {
									content = content.replaceFirst("@@assigner@@，您好！</br>", "");
									stringBuffer = map.get(key);
									stringBuffer.append(content);
									map.put(key, stringBuffer);
									stringBuffer = new StringBuffer();
								} else {
									content = content.replaceAll("@@assigner@@", mapSche.get(key).get(0).getAssigner());
									map.put(key,new StringBuffer().append(content));
								}
								// 微信推送消息
								String assignerId = mapSche.get(key).get(0).getAssignerid();
								String cont = "您今天有" + mapSche.get(key).size()+ "个任务，";
								String detailUrl = "/schedule/list?viewtype=todayview";
								if (mapWx.containsKey(assignerId)) {
									sbWx = mapWx.get(assignerId);
									sbWx.append(cont + "___" + detailUrl + ";");
									mapWx.put(assignerId, sbWx);
									sbWx = new StringBuffer();
								} else {
									mapWx.put(assignerId,new StringBuffer().append(cont+ "___" + detailUrl + ";"));
								}
								// wxRespMsgService.respCommCustMsgByCrmId(assignerId,cont,detailUrl,operatorMobileService);
							}
						}
					}
					// 业务机会
					if (olist != null && olist.size() > 0) {
						String email = "";
						Map<String, List<OpptyAdd>> mapOpp = new HashMap<String, List<OpptyAdd>>();
						List<OpptyAdd> list = new ArrayList<OpptyAdd>();
						for (int i = 0; i < olist.size(); i++) {
							boolean flag = true;
							OpptyAdd opptyAdd = olist.get(i);
							OpptyAdd oppty = new OpptyAdd();
							email = opptyAdd.getEmail();// 邮箱地址
							oppty.setAssigner(opptyAdd.getAssigner());// 责任人
							oppty.setAssignerid(opptyAdd.getAssignerid());
							oppty.setName(opptyAdd.getName());// 业务机会名称
							oppty.setDateclosed(opptyAdd.getDateclosed());// 业务机会结束时间
							oppty.setSalesstagename(opptyAdd.getSalesstagename());// 业务机会阶段名称
							if (mapOpp.keySet() != null&& mapOpp.keySet().size() > 0&& !mapOpp.keySet().contains(email)) {
								list = new ArrayList<OpptyAdd>();
								flag = false;
							}
							if (StringUtils.isNotNullOrEmptyStr(email)) {
								if (i == 0 || !flag) {
									list.add(oppty);
									mapOpp.put(email, list);
								} else {
									List<OpptyAdd> lists = mapOpp.get(email);
									lists.add(oppty);
									mapOpp.put(email, lists);
								}
							}
						}
						if (mapOpp != null && mapOpp.size() > 0) {
							for (String key : mapOpp.keySet()) {
								int i = 1;
								String content = "";
								String str = "";
								for (OpptyAdd opptyAdd : mapOpp.get(key)) {
									str += "<div>" + (i++) + "、【"+ opptyAdd.getName() + "】：处于"+ opptyAdd.getSalesstagename()+ "阶段,预期关闭时间:"+ opptyAdd.getDateclosed()+ "</div></br>";
								}
								content = branchMailModule.replaceAll("您今天有@@count@@","您有" + mapOpp.get(key).size()+ "个业务机会停留时间过长,请及时查看！").replaceAll("@@list@@", str);
								if (map.keySet().contains(key)) {
									content = content.replaceFirst("@@assigner@@，您好！</br>", "");
									stringBuffer = map.get(key);
									stringBuffer.append(content);
									map.put(key, stringBuffer);
									stringBuffer = new StringBuffer();
								} else {
									content = content.replaceAll("@@assigner@@", mapOpp.get(key).get(0).getAssigner());
									map.put(key,new StringBuffer().append(content));
								}
								// 微信推送消息
								String assignerId = mapOpp.get(key).get(0).getAssignerid();
								String cont = "您有" + mapOpp.get(key).size()+ "个业务机会停留时间过长，";
								String detailUrl = "/analytics/oppty/salestage?assignerId="+ assignerId;
								if (mapWx.containsKey(assignerId)) {
									sbWx = mapWx.get(assignerId);
									sbWx.append(cont + "___" + detailUrl + ";");
									mapWx.put(assignerId, sbWx);
									sbWx = new StringBuffer();
								} else {
									mapWx.put(assignerId,new StringBuffer().append(cont+ "___" + detailUrl + ";"));
								}
								// wxRespMsgService.respCommCustMsgByCrmId(assignerId,cont,detailUrl,operatorMobileService);
							}
						}
					}
					// 联系人
					if (clist != null && clist.size() > 0) {
						String email = "";
						Map<String, List<ContactAdd>> mapCon = new HashMap<String, List<ContactAdd>>();
						List<ContactAdd> list = new ArrayList<ContactAdd>();
						for (int i = 0; i < clist.size(); i++) {
							ContactAdd contactAdd = clist.get(i);
							ContactAdd contact = new ContactAdd();
							email = contactAdd.getEmail();// 邮箱地址
							contact.setAssigner(contactAdd.getAssigner());// 责任人
							contact.setConname(contactAdd.getConname());// 联系人姓名
							contact.setPhonemobile(contactAdd.getPhonemobile());// 联系人电话
							contact.setAssignerId(contactAdd.getAssignerId());
							contact.setTimefre(contactAdd.getTimefre());
							if (null == email) {
								continue;
							}
							if (mapCon.keySet() == null
									|| !mapCon.keySet().contains(email)) {
								list = new ArrayList<ContactAdd>();
								list.add(contact);
								mapCon.put(email, list);
							} else {
								List<ContactAdd> lists = mapCon.get(email);
								lists.add(contact);
								mapCon.put(email, lists);
							}
						}
						if (mapCon != null && mapCon.size() > 0) {
							for (String key : mapCon.keySet()) {
								int i = 1;
								String content = "";
								String str = "";
								for (ContactAdd contactAdd : mapCon.get(key)) {
									str += "<div>" + (i++) + "、【"+ contactAdd.getConname() + "】";
									if (StringUtils.isNotNullOrEmptyStr(contactAdd.getPhonemobile())) {
										str += ",电话号码:"+ contactAdd.getPhonemobile();
									}
									str += "；</div></br>";
								}
								content = branchMailModule.replaceAll("您今天有@@count@@","您有" + mapCon.get(key).size()+ "个联系人长时间没联系了,请及时查看！")
										.replaceAll("@@list@@", str);
								if (map.keySet().contains(key)) {
									content = content.replaceFirst("@@assigner@@，您好！</br>", "");
									stringBuffer = map.get(key);
									stringBuffer.append(content);
									map.put(key, stringBuffer);
									stringBuffer = new StringBuffer();
								} else {
									content = content.replaceAll("@@assigner@@", mapCon.get(key).get(0).getAssigner());
									map.put(key,new StringBuffer().append(content));
								}
								// 微信推送消息
								String assignerId = mapCon.get(key).get(0).getAssignerId();
								String timefre = mapCon.get(key).get(0).getTimefre();
								String cont = "您有" + mapCon.get(key).size()+ "个联系人长时间没联系了，";
								String date = DateTime.currentTime(DateTime.DateFormat1);
								String detailUrl = "/contact/clist?viewtype=myview&datetime="+ date+ "&assignerid="+ assignerId+ "&timefre=" + timefre;
								if (mapWx.containsKey(assignerId)) {
									sbWx = mapWx.get(assignerId);
									sbWx.append(cont + "___" + detailUrl + ";");
									mapWx.put(assignerId, sbWx);
									sbWx = new StringBuffer();
								} else {
									mapWx.put(assignerId,new StringBuffer().append(cont+ "___" + detailUrl + ";"));
								}
								// wxRespMsgService.respCommCustMsgByCrmId(assignerId,cont,detailUrl,operatorMobileService);
							}
						}
					}

					// 推送消息
					if (mapWx != null && mapWx.size() > 0) {
						for (String key : mapWx.keySet()) {
							String str = mapWx.get(key).toString();
							String[] strs = str.split(";");
							wxRespMsgService.respCommCustMsgByCrmId(key, strs,operatorMobileService);
						}
					}

					// 發送郵件
					if (map != null && map.size() > 0) {
						for (String key : map.keySet()) {
							SenderInfor senderInfor = new SenderInfor();
							senderInfor.setToEmails(key);
							String content = map.get(key).toString();
							// String ccemail = mapKey.get(key);
							// senderInfor.setCcemail(ccemail);
							String str = mainMailModule.replaceAll("@@content@@", content).replaceAll("@@link@@", link).replaceAll("@@signature@@", signature);
							senderInfor.setContent(str);
							senderInfor.setSubject("信息通知");
							String mailDerail = PropertiesUtil.getMailContext("mail.derail");
							if ("1".equals(mailDerail)) {
								MailUtils.sendEmail(senderInfor);
							}
						}
					}
				}
			}
		}
	}

	/**
	 * 定时扫描通知信息(每天早上九点)并推送图文消息
	 */
	@SuppressWarnings("unchecked")
	public void noticeWork() {
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
		List<Organization> orgList = (List<Organization>) organizationService.findObjListByFilter(obj);
		if (orgList != null && orgList.size() > 0) {
			for (Organization organization : orgList) {
				String crmurl = organization.getCrmurl();
				logger.info("ScheduledScansServiceImpl crmurl is ==>" + crmurl);
				if (StringUtils.isNotNullOrEmptyStr(crmurl)) {
					GatheringReq greq = new GatheringReq();
					greq.setModeltype(Constants.MODEL_TYPE_NOTICE);
					greq.setType(Constants.ACTION_SEARCH);
					greq.setCrmaccount(Constants.CRMID);
					// 转换为json
					String jsonStrNotice = JSONObject.fromObject(greq).toString();
					logger.info("ScheduledScansServiceImpl noticeWork jsonStrnotice => jsonStrNotice is : "+ jsonStrNotice);
					// 多次调用sugar接口
					try {
						String rstNotice = util.postJsonData(crmurl,Constants.MODEL_URL_NOTICE, jsonStrNotice,Constants.INVOKE_SINGLE,30000);
						logger.info("ScheduledScansServiceImpl noticeWork rst => rstNotice is : "+ rstNotice);
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
						// 定义一个全局map变量
						Map<String, List<Article>> map = new HashMap<String, List<Article>>();
						// 邮件全局变量
						Map<String, String> mailMap = new HashMap<String, String>();
						List<Article> list = new ArrayList<Article>();
						String date = DateTime.currentDate("yyyy年MM月dd日");
						String projectname = PropertiesUtil.getAppContext("app.content");
						// 定义简报的标题
						Article article = new Article();
						article.setTitle("【" + date + "简报" + "】");
						article.setDescription("【" + date + "简报" + "】");
						article.setPicUrl(projectname+ "/image/title_report_manager.png");
						article.setUrl("");
						String title = "";// 图文消息名称
						String desc = "";// 描述
						String url = "";// 地址
						String picurl = "";// 图片地址
						String string = "";// 邮件详细内容
						logger.info("ScheduledScansServiceImpl each expenselist start....");
						logger.info("ScheduledScansServiceImpl expenselist size ==>"+ elist.size());
						// 报销费用
						for (int i = 0; i < elist.size(); i++) {
							Article article1 = new Article();
							ExpenseAdd expenseAdd = elist.get(i);
							String assignerid = expenseAdd.getAssignid();
							String noticetype = expenseAdd.getNoticetype();
							String nums = expenseAdd.getNums();
							if (StringUtils.isNotNullOrEmptyStr(noticetype)) {
								if (noticetype.contains("expense_reject")) {
									title = "我的被驳回的报销（" + nums + "）";
									desc = "我的被驳回的报销";
									picurl = "/image/list_expense_reject.png";
									url = "/expense/list?viewtype=myview&viewtypesel=myview_reject&approval=reject&";
									string = "<div>-- " + nums+ "条被驳回的报销；</div>";
								} else if (noticetype.contains("expense_approving")) {
									title = "需要我审批的报销（" + nums + "）";
									desc = "需要我审批的报销";
									picurl = "/image/list_expense_wait.png";
									url = "/expense/list?viewtype=approvalview&viewtypesel=approvalview&";
									string = "<div>-- " + nums+ "条需要我审批的报销；</div>";
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
						logger.info("ScheduledScansServiceImpl opptylist size ====>"
								+ olist.size());
						// 商机
						for (int i = 0; i < olist.size(); i++) {
							Article article1 = new Article();
							OpptyAdd opptyAdd = olist.get(i);
							String assignerid = opptyAdd.getAssignerid();
							String noticetype = opptyAdd.getNoticetype();
							String nums = opptyAdd.getNums();
							if (StringUtils.isNotNullOrEmptyStr(noticetype)) {
								if (noticetype.contains("oppty_delay")) {
									title = "超过15天未跟进的业务机会（" + nums + "）";
									desc = "超过15天未跟进的业务机会";
									picurl = "/image/list_oppty_flow.png";
									url = "/oppty/opptylist?viewtype=noticeview&";
									string = "<div>-- " + nums+ "个超过15天未跟进的业务机会；</div>";
								} else if (noticetype.contains("oppty_closed")) {
									title = "过期未关闭的业务机会（" + nums + "）";
									desc = "过期未关闭的业务机会";
									picurl = "/image/list_oppty_unflow.png";
									url = "/oppty/opptylist?viewtype=noclosedview&";
									string = "<div>-- " + nums+ "个过期未关闭的业务机会；</div>";
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
						logger.info("ScheduledScansServiceImpl tasklist size====>"
								+ slist.size());
						// 任务
						for (int i = 0; i < slist.size(); i++) {
							Article article1 = new Article();
							ScheduleAdd scheduleAdd = slist.get(i);
							String assignerid = scheduleAdd.getAssignerid();
							String noticetype = scheduleAdd.getNoticetype();
							String nums = scheduleAdd.getNums();
							if (StringUtils.isNotNullOrEmptyStr(noticetype)) {
								if (noticetype.contains("task_today")) {
									title = "今日任务（" + nums + "）";
									desc = "今日任务";
									picurl = "/image/list_task_today.png";
									url = "/schedule/list?viewtype=todayview&";
									string = "<div>-- " + nums + "个今日任务；</div>";
								} else if (noticetype.contains("task_history")) {
									title = "延期未完成任务（" + nums + "）";
									desc = "延期未完成任务";
									picurl = "/image/list_task_uncomplete.png";
									url = "/schedule/list?viewtype=noticeview&";
									string = "<div>-- " + nums+ "个延期未完成的任务；</div>";
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
						logger.info("ScheduledScansServiceImpl contactlist size===>"
								+ clist.size());
						// 联系人
						for (int i = 0; i < clist.size(); i++) {
							Article article1 = new Article();
							ContactAdd contactAdd = clist.get(i);
							String assignerid = contactAdd.getAssignerId();
							String noticetype = contactAdd.getNoticetype();
							String nums = contactAdd.getNums();
							if (StringUtils.isNotNullOrEmptyStr(noticetype)) {
								if (noticetype.contains("contact_freq")) {
									title = "长期未联系的人（" + nums + "）";
									desc = "长期未联系的人";
									picurl = "/image/list_accnt_my.png";
									url = "/contact/clist?viewtype=noticeview&";
									string = "<div>-- " + nums+ "个长期未联系的人；</div>";
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
						logger.info("ScheduledScansServiceImpl dclist size===>"
								+ dclist.size());
						// 邮件列表
						for (int i = 0; i < dclist.size(); i++) {
							DcCrmOperator dcCrmOperator = dclist.get(i);
							String email = dcCrmOperator.getOpEmail();
							String assignername = dcCrmOperator.getOpName();
							String assignerid = dcCrmOperator.getOpId();
							if (StringUtils.isNotNullOrEmptyStr(assignerid)) {
								eMap.put(assignerid, assignername + "-" + email);
							}
						}
						logger.info("ScheduledScansServiceImpl each map start......");
						// 发送图文消息
						if (map != null && map.size() > 0) {
							logger.info("ScheduledScansServiceImpl map size ===>"+ map.size());
							for (String key : map.keySet()) {
								List<Article> articles = map.get(key);
								OperatorMobile oper = new OperatorMobile();
								oper.setCrmId(key);
								List<OperatorMobile> operlist = operatorMobileService.getOperMobileListByPara(oper);
								String mailstr = eMap.get(key);
								String assignername = "";
								String email = "";
								if (StringUtils.isNotNullOrEmptyStr(mailstr)&& mailstr.contains("-")) {
									assignername = mailstr.split("-")[0];
									email = mailstr.split("-")[1];
								}
								String mailmodule = PropertiesUtil.getMailContext("mailModule");
								String mailcontent = mailMap.get(key);
								logger.info("ScheduledScansServiceImpl send assignerid is ===>"+ key);
								logger.info("ScheduledScansServiceImpl send assignername is ===>"+ assignername);
								logger.info("ScheduledScansServiceImpl send email is ===>"+ email);
								logger.info("ScheduledScansServiceImpl send mailcontent is ===>"+ mailcontent);
								if (operlist != null && operlist.size() > 0) {
									AccessToken at = WxUtil.getAccessToken(Constants.APPID,Constants.APPSECRET);
									logger.info("ScheduledScansServiceImpl post wxuser at ===>"+ at);
									OperatorMobile op = (OperatorMobile) operlist.get(0);
									String openId = op.getOpenId();
									String publicId = op.getPublicId();
									logger.info("ScheduledScansServiceImpl post wxuser openId ===>"+ openId);
									logger.info("ScheduledScansServiceImpl post wxuser publicId ===>"+ publicId);
									// 追加的后缀参数
									String tpUrl = "openId=" + op.getOpenId()+ "&publicId=" + publicId;
									logger.info("ScheduledScansServiceImpl post wxuser tpUrl ===>"+ tpUrl);
									WxUtil.customArticleMsgSend(at.getToken(),openId, articles, tpUrl);
									String loginTime = RedisCacheUtil.getString(Constants.LOGINTIME_KEY+ "_" + key);
									logger.info("ScheduledScansServiceImpl post wxuser loginTime ===>"+ loginTime);
									if (StringUtils.isNotNullOrEmptyStr(loginTime)&& DateTime.comDate(loginTime,PropertiesUtil.getMailContext("mail.differtime"),DateTime.DateTimeFormat1)) {
										logger.info("ScheduledScansServiceImpl send assigneremail start ===>");
										SenderInfor senderInfor = new SenderInfor();
										senderInfor.setContent(mailmodule.replaceAll("@@assigner@@",assignername).replaceAll("@@content@@",mailcontent));
										senderInfor.setSubject(date + "简报");
										if (StringUtils.isNotNullOrEmptyStr(email)) {
											senderInfor.setToEmails(email);
											logger.info("ScheduledScansServiceImpl send assigneremail email (longtime)===>"+ email);
											String mailDerail = PropertiesUtil.getMailContext("mail.derail");
											if ("1".equals(mailDerail)) {
												MailUtils.sendEmail(senderInfor);
											}
										}
									}
								} else {
									logger.info("ScheduledScansServiceImpl send email start ===>");
									SenderInfor senderInfor = new SenderInfor();
									senderInfor.setContent(mailmodule.replaceAll("@@assigner@@",assignername).replaceAll("@@content@@", mailcontent));
									senderInfor.setSubject(date + "简报");
									if (StringUtils.isNotNullOrEmptyStr(email)) {
										senderInfor.setToEmails(email);
										logger.info("ScheduledScansServiceImpl send email is ===>"+ email);
										String mailDerail = PropertiesUtil.getMailContext("mail.derail");
										if ("1".equals(mailDerail)) {
											MailUtils.sendEmail(senderInfor);
										}
									}
								}
							}
						}
					} catch (Exception e) {
						logger.error(e);
						continue;
					}
				}
			}
		}
	}
	@SuppressWarnings("unused")
	private int getUnderlingPlanNoEvalCount(String openId,String name) throws Exception
	{
		int n = 0;
		List<String> rstuid = new ArrayList<String>();
/*		List<String> crmIds = zjwkSystemTaskService.getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"), "Default Organization");
		log.info("crmIds size = >" + crmIds.size());
		
		for (int i = 0; i < crmIds.size(); i++) {
			String crmid = crmIds.get(i);
			log.info("crmid = >" + crmid);*/
			//查询接口 获取人的数据列表
			UserReq uReq  = new UserReq();
			//uReq.setCrmaccount(crmid);
			uReq.setCurrpage("1");
			uReq.setPagecount("9999");
			//uReq.setFlag("");
			uReq.setOpenId(openId);
			uReq.setFlag("direct_subordinates");
			uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);


			//UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
		    UsersResp uResp = lovUser2SugarService.getUserList(uReq,util);
			String errorCode = uResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				String count = uResp.getCount();
				List<UserAdd> ulist = uResp.getUsers();
				if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
					for(UserAdd userAdd:uResp.getUsers()){
						String userid = userAdd.getUserid();
						rstuid.add(userid) ;
					}
				}
				/*if(count != null && Integer.parseInt(count) > 0){
					for (int j = 0; j < ulist.size(); j++) {
						UserAdd ua = ulist.get(j);
						String uid = ua.getUserid();
						log.info("uid = >" + uid);
						rstuid.add(uid);
					}
				}*/
			}
		//}
		for(int j=0;j<rstuid.size();j++){
			Comments comments= new Comments();
			comments.setAssignerid(rstuid.get(j));
			comments.setCreator(name);
			comments.setEval_type("lead");
			n+= commentsService.findWorkReportNoEvalCount(comments);
			
		}
		return n;
	}
	
	/**
	 * 每日消息推送
	 * 1. 消息推送方式为微信
	 * 2. 每天早上9点定时发送
	 * 3. 推送内容包括：日程、未读通知、工作计划评价
	 */
	public void processMessages(){
		try{
			//获取所有用户信息
			NoticeReport bc = new NoticeReport();
			bc.setCurrpages(Constants.ZERO);
			bc.setPagecounts(999999);
			List<NoticeReport> cardList = zjwkSystemTaskService.searchAllSystemCard(bc);
			sendMessage(cardList);
		}catch(Exception ec){
			logger.error(ec);
		}
		
		try{
			//2015-04-16 新增 活动提醒
			Activity act = new Activity();
			String date = DateTime.preDayTime(DateTime.DateFormat1, 1);
			act.setStart_date(date);
			List<Activity> list = ServiceUtils.getCRMService().getDbService().getActivityService().searchAllActivity(act);
			if(null!=list && list.size()>0){
				String url = PropertiesUtil.getMsgContext("service.url1");
				for(Activity activity : list){
					String title = activity.getTitle();
					String id = activity.getId();
					String type = activity.getType();
					String place = activity.getPlace();
					String surl = ""; 
					if("meet".equals(type)){
						surl = "/zjwkactivity/new_meetdetail?id="+id+"&type=sms";
					}else{
						surl = "/zjwkactivity/new_detail?id="+id+"&type=sms";
					}
					ActivityParticipant ap = new ActivityParticipant();
					ap.setActivityid(id);
					List<Participant> parList = participantService.getParticipantListByActivity(ap);
					if(null!=parList&&parList.size()>0){
						for(Participant participant : parList){
							String opMobile = participant.getOpMobile();
							if(StringUtils.isNotNullOrEmptyStr(opMobile)){
								String opName = participant.getOpName();
								String content = "亲爱的"+opName+"您好，您报名的活动【"+title+"】将于明天在"+place+"举办。点此查看详情" + PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content") + surl);
								/*Map<String, Object> msgMap = new HashMap<String, Object>();
								msgMap.put("mobile", opMobile);
								msgMap.put("content", content);
								msgMap.put("code", "231231");
								HttpClient3Post.request(url, msgMap);*/
								ThreadRun thread = new SMSSentThread("231231", opMobile,content);
								ThreadExecute.push(thread);

							}
						}
					}
				}
			}
		}catch(Exception e){
			logger.error(e);
		}
	}
	
	
	public void sendMessage(List<NoticeReport> cardList){
		Map<String,String> cityMap = new HashMap<String,String>();
		final Map<String,String> messages = new HashMap<String,String>();
		String currdate = "今天是"+DateTime.currentDate("MM月dd日") + "" + ZJDateUtil.getWeekOfDate(new Date()) +"。";
		if(null != cardList){
			for(NoticeReport bc : cardList){
				try{
					String responseData = "";
					String weather = "";
					responseData += "亲爱的"+bc.getName() + " 早安！\r\n" + currdate;
					if(StringUtils.isNotNullOrEmptyStr(bc.getCity())){
						if(null == cityMap.get(bc.getCity())){
							weather = ZJWKUtil.getWeatherByCity(bc.getCity());
							cityMap.put(bc.getCity(), weather);
						}else{
							weather = cityMap.get(bc.getCity());
						}
						if(StringUtils.isNotNullOrEmptyStr(weather)){
							responseData += bc.getCity() +"：" + weather +"\r\n";
						}
					}
					
					
					if(bc.getMsgcount() >0){
						responseData += "<a href=\""+PropertiesUtil.getAppContext("app.content")+"/home/index\">您一共有"+bc.getMsgcount() +"条未读通知。(回复字母T查看相关通知)</a> \r\n";
					}
					if(bc.getEvalcount() >0){
						responseData += "<a href=\""+PropertiesUtil.getAppContext("app.content")+"/workplan/list\">您昨天共收到"+bc.getEvalcount() +"个工作计划评价。(回复字母P查看相关评价)</a> \r\n";
					}
	/*				if(bc.getOwnerNoEvalCount() >0){
						responseData += "<a href=\""+PropertiesUtil.getAppContext("app.content")+"/workplan/list\">您今天还有"+bc.getOwnerNoEvalCount() +"个工作计划未自我评价。(P)</a> \r\n";
					}
					Integer n = getUnderlingPlanNoEvalCount(bc.getOpenId(),bc.getName());
					if(n >0){
						responseData += "<a href=\""+PropertiesUtil.getAppContext("app.content")+"/workplan/list\">您今天还有"+bc.getOwnerNoEvalCount() +"个工作计划未自我评价。(P)</a> \r\n";
					}				
	*/				if(bc.getActivitycount() >0){
						responseData += "<a href=\""+PropertiesUtil.getAppContext("app.content")+"/zjactivity/noticelist\">您一共有"+bc.getActivitycount() +"个关注活动将要开始。(回复字母H查看相关活动)</a> \r\n";
					}
					if(bc.getTaskcount() >0 && bc.getUntaskcount() >0){
						responseData += "<a href=\""+PropertiesUtil.getAppContext("app.content")+"/calendar/calendar\">您今天有"+bc.getTaskcount() +"个任务,"+bc.getUntaskcount()+"个延期任务。(回复字母R查看相关任务)</a> \r\n";
					}
					else if(bc.getUntaskcount() >0){
						responseData +="<a href=\""+PropertiesUtil.getAppContext("app.content")+"/calendar/calendar\">您还有"+bc.getUntaskcount()+"个延期任务。(回复字母R查看相关任务)</a> \r\n";
					}
					
					responseData += "\r\n             您的朋友：小薇";
					responseData += "\r\n                 "+DateTime.currentDate("yyyy-MM-dd");
					
					messages.put(bc.getOpenId(), responseData);
				}catch(Exception ec){
					logger.error(ec);
				}
			}
		}
		for(String openid : messages.keySet()){
			try{
				wxRespMsgService.respReportByOpenId(openid,messages.get(openid));
			}catch(Exception ec){
				logger.error(ec);
			}
		}
	}
	
	/**
	 * 每日消息推送
	 * 1. 消息推送方式为微信
	 * 2. 每天早上9点定时发送
	 * 3. 推送内容包括：日程、未读通知、工作计划评价
	 */
	public void processMessagesByWxMenuKey(String openId){

		String partyId = wxUserinfoService.getWxuserInfo(openId).getParty_row_id();
		//获取所有用户信息
		NoticeReport bc = new NoticeReport();
		bc.setCurrpages(Constants.ZERO);
		bc.setPagecounts(999999);
		bc.setPartyId(partyId);
		List<NoticeReport> cardList = wxZJWKSystemTaskService.searchAllSystemCard(bc);
		sendMessage(cardList);
	}
	
	
	/**
	 * 提醒,每隔十五分钟扫描一次,并推送文字消息
	 */
	public void scanTask() {
		Organization obj = new Organization();
		obj.setCurrpages(0);
		obj.setPagecounts(10000);
		// 调用后台查询数据库
		List<Organization> orgList = (List<Organization>) organizationService.findObjListByFilter(obj);
		if (orgList != null && orgList.size() > 0) {
			for (Organization organization : orgList) {
				String crmurl = organization.getCrmurl();
				if (StringUtils.isNotNullOrEmptyStr(crmurl)) {
					ScheduleReq sreq = new ScheduleReq();
					sreq.setModeltype(Constants.MODEL_TYPE_NOTICE);
					sreq.setType(Constants.ACTION_SEARCH);
					sreq.setCrmaccount(Constants.CRMID);
					// 转换为json
					String jsonStrNotice = JSONObject.fromObject(sreq).toString();
					logger.info("scanTask jsonStrnotice => jsonStrNotice is : "+ jsonStrNotice);
					// 多次调用sugar接口
					String rstNotice = util.postJsonData(crmurl,Constants.MODEL_URL_NOTICE, jsonStrNotice,Constants.INVOKE_MULITY);
					logger.info("scanTask rst => rstNotice is : " + rstNotice);
					JSONObject jsonTask = JSONObject.fromObject(rstNotice.substring(rstNotice.indexOf("{")));
					List<ScheduleAdd> slist = new ArrayList<ScheduleAdd>();
					if (!jsonTask.containsKey("errcode")) {
						if (StringUtils.isNotNullOrEmptyStr(jsonTask.getString("tasks"))) {
							slist = (List<ScheduleAdd>) JSONArray.toCollection(jsonTask.getJSONArray("tasks"),ScheduleAdd.class);
						}
					} else {
						// 错误代码和消息
						String errcode = jsonTask.getString("errcode");
						String errmsg = jsonTask.getString("errmsg");
						logger.info("scanTask jsonTask errcode => errcode is : "+ errcode);
						logger.info("scanTask jsonTask errmsg => errmsg is : "+ errmsg);
					}
					if (slist != null && slist.size() > 0) {
						for (ScheduleAdd scheduleAdd : slist) {
							String assignerid = scheduleAdd.getAssignerid();
							String assigner = scheduleAdd.getAssigner();
							String title = scheduleAdd.getTitle();
							String rowid = scheduleAdd.getRowid();
							// 微信推送消息
							String cont = assigner + "您好!您在十五分钟之后有一个【" + title+ "】任务需要您参与,";
							String detailUrl = "/schedule/detail?rowId="+ rowid;
							String[] strs = new String[] { cont + "___"+ detailUrl };
							wxRespMsgService.respCommCustMsgByCrmId(assignerid,strs, operatorMobileService);
						}
					}
				}
			}
		}
	}

	/**
	 * 发送短信
	 */
	public void sendMsg() throws Exception{
		Map<String, String> map = RedisCacheUtil.getStringMapAll(Constants.ZJWK_NOTICE_SEND);
		if(null!=map&&map.keySet().size()>0){
			BusinessCard bc = new BusinessCard();
			String content = PropertiesUtil.getMsgContext("message.model3");
			for(String key : map.keySet()){
				bc.setOpenId(key);
				String str = map.get(key);
				String cardSize = str.split(";")[0];
				String taskSize = str.split(";")[1];
				content = content.replaceAll("$$cardsize", cardSize).replaceAll("$$tasksize", taskSize);
				List<BusinessCard> list  = businessCardService.getList(bc);
				if(list!=null&&list.size()>0){
					BusinessCard businessCard = list.get(0);
					String phone = businessCard.getPhone();
					if(StringUtils.isNotNullOrEmptyStr(phone)){
						/*Map<String, Object> map1 = new HashMap<String, Object>();
						map1.put("phone", phone);
						map1.put("content", content);
						HttpClient3Post.request(null, map1);*/
						ThreadRun thread = new SMSSentThread("", phone,content);
						ThreadExecute.push(thread);

					}
				}
			}
		}
	}
	
	/**
	 * 发送邮件
	 */
	public void sendEmail(){
		Map<String, String> map = RedisCacheUtil.getStringMapAll(Constants.ZJWK_NOTICE_SEND);
		if(null!=map&&map.keySet().size()>0){
			BusinessCard bc = new BusinessCard();
			String mainMailModule = PropertiesUtil.getMailContext("noticemailmodule");
			for(String key : map.keySet()){
				bc.setOpenId(key);
				String str = map.get(key);
				String cardSize = str.split(";")[0];
				String taskSize = str.split(";")[1];
				List<BusinessCard> list  = businessCardService.getList(bc);
				if(list!=null&&list.size()>0){
					BusinessCard businessCard = list.get(0);
					String email = businessCard.getEmail();
					if(StringUtils.isNotNullOrEmptyStr(email)){
						SenderInfor senderInfor = new SenderInfor();
						senderInfor.setToEmails(email);
						String content = mainMailModule.replaceAll("$$cardsize", cardSize).replaceAll("$$tasksize", taskSize);
						senderInfor.setContent(content);
						senderInfor.setSubject("消息通知");
						String mailDerail = PropertiesUtil.getMailContext("mail.derail");
						if ("1".equals(mailDerail)) {
							MailUtils.sendEmail(senderInfor);
						}
					}
				}
			}
		}
	}

	
	protected String getNoticeActivityMessage(int num){
		try{
			if (num == 0) return "";
			StringBuffer sb = new StringBuffer();
			sb.append("<a href=\"");
			sb.append(PropertiesUtil.getAppContext("app.content"));
			sb.append(String.format("/zjactivity/list?viewtype=owner\">您关注了%d个活动。(H)</a>",num));
			return sb.toString();
		}catch(Exception ec){
			return "";
		}
	
	}
	/**
	 * 导出评价(周)，发送邮件
	 */
	public void exportWeekAppraise(){
		try {
			//取前一个自然周时间段
			Calendar cal2 = Calendar.getInstance();
			//cal2.setFirstDayOfWeek(Calendar.MONDAY);  
			cal2.add(Calendar.DAY_OF_WEEK, -7);
			cal2.set(Calendar.HOUR_OF_DAY, 0);
			cal2.set(Calendar.MINUTE, 0);
			cal2.set(Calendar.SECOND, 0);
			Calendar cal4 = Calendar.getInstance();
			//cal2.setFirstDayOfWeek(Calendar.MONDAY);  
			cal4.set(Calendar.HOUR_OF_DAY, 0);
			cal4.set(Calendar.MINUTE, 0);
			cal4.set(Calendar.SECOND, 0);
			cal4.add(Calendar.SECOND, -1);

			
			Date start = cal2.getTime();
			Date end = cal4.getTime();
			ServiceUtils.getCRMService().getBusinessService().getWorkPlanService().exportAppraise(start,end);
		} catch (CRMException e) {
			logger.error(e);
		}
	}
	/**
	 * 导出评价(月)，发送邮件
	 */
	public void exportMonthAppraise(){
		try {
			
			//取前一个自然月时间段
			Calendar cal1 = Calendar.getInstance();
			cal1.add(Calendar.MONTH, -1);
			cal1.set(Calendar.DAY_OF_MONTH, 1);
			cal1.set(Calendar.HOUR_OF_DAY, 0);
			cal1.set(Calendar.MINUTE, 0);
			cal1.set(Calendar.SECOND, 0);
			Calendar cal3 = Calendar.getInstance();
			cal3.set(Calendar.DAY_OF_MONTH, 1);
			cal3.set(Calendar.HOUR_OF_DAY, 0);
			cal3.set(Calendar.MINUTE, 0);
			cal3.set(Calendar.SECOND, 0);
			cal3.add(Calendar.SECOND, -1);
			
			Date start = cal1.getTime();
			Date end = cal3.getTime();
			ServiceUtils.getCRMService().getBusinessService().getWorkPlanService().exportAppraise(start,end);
		} catch (CRMException e) {
			logger.error(e);
		}
	}
	/**
	 * 自动创建周工作计划
	 */	
	public void autoWorkReportWeek() throws Exception{
		userPerferencesService.updateAutoWeekWorkRerportByParam();
		
		List<WorkReport> wReportList = new ArrayList<WorkReport>();
		WorkReport wr = new WorkReport();
		wr.setType("week");
		wr.setStatus("draft");
		Date d = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String  create_time = sdf.format(d);
		wr.setCreate_time(create_time);
		wr.setRemark("自动生成工作计划");
		wReportList = workPlanService.searchWorkPlanList(wr);
		if(wReportList!=null&&wReportList.size()>0){
			String responseData = "";
			for(int i=0;i<wReportList.size();i++){
				wr = wReportList.get(i);
				responseData = "系统已经自动为您创建了周工作计划："+wr.getTitle();
				String detailUrl = "/workplan/detail?rowId="+ wr.getId()+"&viewtype=myview";
				String assignerid = wr.getCrmId();
				String[] strs = new String[] { responseData + "___"+ detailUrl };
				wxRespMsgService.respCommCustMsgByCrmId(assignerid,strs, operatorMobileService);
				
			}
					
		}
	}
	/**
	 * 自动创建日工作计划
	 */
	public void autoWorkReportDay() throws Exception{
		userPerferencesService.updateAutoDayWorkRerportByParam();
	
		List<WorkReport> wReportList = new ArrayList<WorkReport>();
		WorkReport wr = new WorkReport();
		wr.setType("day");
		wr.setStatus("draft");
		Date d = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String  create_time = sdf.format(d);
		wr.setCreate_time(create_time);
		wr.setRemark("自动生成工作计划");
		wReportList = workPlanService.searchWorkPlanList(wr);
		if(wReportList!=null&&wReportList.size()>0){
			String responseData = "";
			for(int i=0;i<wReportList.size();i++){
				wr = wReportList.get(i);
				responseData = "系统已经自动为您创建了日工作计划："+wr.getTitle();
				String detailUrl = "/workplan/detail?rowId="+ wr.getId()+"&viewtype=myview";
				String assignerid = wr.getCrmId();
				String[] strs = new String[] { responseData + "___"+ detailUrl };
				wxRespMsgService.respCommCustMsgByCrmId(assignerid,strs, operatorMobileService);
				
			}
					
		}
	}
}
