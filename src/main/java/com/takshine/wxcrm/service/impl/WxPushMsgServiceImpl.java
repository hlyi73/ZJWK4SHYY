package com.takshine.wxcrm.service.impl;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.Activity_Rela;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.ArticleInfo;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Contract;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.Expense;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.domain.WorkReport;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.resp.Article;
import com.takshine.wxcrm.message.sugar.ContractResp;
import com.takshine.wxcrm.message.sugar.CustomerResp;
import com.takshine.wxcrm.message.sugar.ExpenseResp;
import com.takshine.wxcrm.message.sugar.OpptyResp;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleResp;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.Contact2SugarService;
import com.takshine.wxcrm.service.Contract2CrmService;
import com.takshine.wxcrm.service.Customer2SugarService;
import com.takshine.wxcrm.service.Expense2CrmService;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.Oppty2SugarService;
import com.takshine.wxcrm.service.Schedule2SugarService;
import com.takshine.wxcrm.service.UserFuncService;
import com.takshine.wxcrm.service.WorkPlanService;
import com.takshine.wxcrm.service.WxAddressInfoService;
import com.takshine.wxcrm.service.WxPushMsgService;
import com.takshine.wxcrm.service.WxRespMsgService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 微信 消息推送服务 实现类
 * @author liulin
 *
 */
@Service("wxPushMsgService")
public class WxPushMsgServiceImpl extends BaseServiceImpl implements WxPushMsgService {
	
	private static Logger logger = Logger.getLogger(WxPushMsgServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 把日程列表转换成文章列表
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public List<Article> searchTaskAndTransfMsg(String openId, String publicId, String crmId){
        //访问文章列表
		List<Article> articleList = new ArrayList<Article>(); 
		/*
		//查询 日程  数据  列表
		List<UserFunc> ufuncList = userFuncService.getUserFuncListByPara(crmId, null, "WXCRM_MEMU_CALENDAR");
		log.info("searchExpense ufuncList size =>" + ufuncList.size());
		for (int i = 0; i < ufuncList.size(); i++) {
			UserFunc uf = (UserFunc)ufuncList.get(i);
			log.info("getFunMem =:>" + uf.getFunMem());
			log.info("getFunImg =:>" + uf.getFunImg());
			log.info("getFunName =:>" + uf.getFunName());
			log.info("getFunUri before=:>" + uf.getFunUri());
			//查询文章的内容
			Article article = null;
			article = new Article();  
			article.setDescription(uf.getFunMem());//desc  
			article.setPicUrl(PropertiesUtil.getAppContext("app.content") + uf.getFunImg()); //pic url
			//uri 设置值
			String uri = uf.getFunUri();
			if(null != uri && !"".equals(uri)){
				uri = PropertiesUtil.getAppContext("app.content") + uf.getFunUri();
				if(uri.indexOf("?") != -1) uri += "&";
				else uri += "?";
				uri += "openId=" + openId + "&publicId=" + publicId;
				article.setUrl(uri); 
			}
			log.info("article.getUrl after =:>" + article.getUrl());
			
			article.setTitle(uf.getFunName());//title
			
			logger.info("getPicUrl => " + article.getPicUrl());
			logger.info("getTitle => " + article.getTitle());
			//放入集合
			if(articleList.size() >= 10) continue;//大于等于10则不再加入图文
	        articleList.add(article);  
		}
		*/
		
		Schedule sche = new Schedule();
		sche.setCrmId(crmId);
		sche.setCurrpage(null);
		sche.setPagecount(null);
		
		//创建任务
		Article article = null;
		article = new Article();  
		article.setTitle("【点击  创建任务】");
		article.setDescription("点击  创建任务");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/title_task_manager.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/schedule/get?openId="+openId+"&publicId="+publicId); 
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
		//当日
		article = new Article();  
		sche.setViewtype("todayview");//视图类型
//		ScheduleResp sResp = schedule2SugarService.getScheduleList(sche, "WX");
		ScheduleResp sResp = null;
		article.setTitle("  当日任务（"+sResp.getCount()+"）");
		article.setDescription("  当日任务");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_task_today.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/schedule/list?viewtype=todayview&openId="+openId+"&publicId="+publicId); 
		articleList.add(article);
		//历史
		sche.setViewtype("historyview");//视图类型
//		sResp = schedule2SugarService.getScheduleList(sche, "WX");
		article = new Article();  
		article.setTitle("  历史任务（"+sResp.getCount()+"）");
		article.setDescription("  历史任务");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_task_complete.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/schedule/list?viewtype=historyview&openId="+openId+"&publicId="+publicId); 
		articleList.add(article);
		//计划
		article = new Article();  
		sche.setViewtype("planview");//视图类型
//		sResp = schedule2SugarService.getScheduleList(sche, "WX");
		article.setTitle("  计划任务（"+sResp.getCount()+"）");
		article.setDescription("  计划任务");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_task_plan.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/schedule/list?viewtype=planview&openId="+openId+"&publicId="+publicId); 
		articleList.add(article);
		//团队
		article = new Article();  
		sche.setViewtype("teamview");//视图类型
//		sResp = schedule2SugarService.getScheduleList(sche, "WX");
		article.setTitle("  团队任务（"+sResp.getCount()+"）");
		article.setDescription("  团队任务");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_task_team.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/schedule/list?viewtype=teamview&openId="+openId+"&publicId="+publicId); 
		articleList.add(article);
		//关注
		article = new Article();  

		//sche.setViewtype("focusview");//视图类型
		//sResp = schedule2SugarService.getScheduleList(sche, "WX");
		article.setTitle("  我关注的任务");
		article.setDescription("  我关注的任务");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_task_focus.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/schedule/list?viewtype=focusview&openId="+openId+"&publicId="+publicId); 
		articleList.add(article);
        return articleList;  
	}
	
	/**
	 * 查询费用信息列表并做消息转换
	 * @param crmId
	 */
	public List<Article> searchExpenseAndTransfMsg(String openId, String publicId, String crmId) throws Exception{
		//访问文章列表
		List<Article> articleList = new ArrayList<Article>(); 
		/*
		//查询  费用 数据  列表
		List<UserFunc> ufuncList = userFuncService.getUserFuncListByPara(crmId, null, "WXCRM_MEMU_EXPENSE");
		log.info("searchExpense ufuncList size =>" + ufuncList.size());
		for (int i = 0; i < ufuncList.size(); i++) {
			UserFunc uf = (UserFunc)ufuncList.get(i);
			log.info("getFunMem =:>" + uf.getFunMem());
			log.info("getFunImg =:>" + uf.getFunImg());
			log.info("getFunName =:>" + uf.getFunName());
			log.info("getFunUri before=:>" + uf.getFunUri());
			//查询文章的内容
			Article article = null;
			article = new Article();  
			article.setDescription(uf.getFunMem());//desc  
			article.setPicUrl(PropertiesUtil.getAppContext("app.content") + uf.getFunImg()); //pic url
			//uri 设置值
			String uri = uf.getFunUri();
			if(null != uri && !"".equals(uri)){
				uri = PropertiesUtil.getAppContext("app.content") + uf.getFunUri();
				if(uri.indexOf("?") != -1) uri += "&";
				else uri += "?";
				uri += "openId=" + openId + "&publicId=" + publicId;
				article.setUrl(uri); 
			}
			log.info("article.getUrl after =:>" + article.getUrl());
			log.info("apdExpBizData  =:>" + apdExpBizData(crmId, article.getUrl()));
			
			article.setTitle(uf.getFunName() + apdExpBizData(crmId, article.getUrl()));//title
			
			logger.info("getPicUrl => " + article.getPicUrl());
			logger.info("getTitle => " + article.getTitle());
			//放入集合
			if(articleList.size() >= 10) continue;//大于等于10则不再加入图文
	        articleList.add(article);  
		}
		*/
		//查询客户信息
		Expense sche = new Expense();
		sche.setCrmId(crmId);
		sche.setExpensedate(null);
		sche.setDepart(null);
		sche.setExpensesubtype(null);
		sche.setCurrpage(null);
		sche.setPagecount(null);
		
		//费用报销
		Article article = null;
		article = new Article();  
		article.setTitle("【点击  报销费用】");
		article.setDescription("点击  报销费用");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/title_expense_manager.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/expense/get?openId="+openId+"&publicId="+publicId); 
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
		
		//我的待提交报销
		article = new Article();  
		sche.setViewtype("myview");//视图类型
		sche.setApproval("new");
		ExpenseResp cResp = cRMService.getSugarService().getExpense2CrmService().getExpenseList(sche,"WX");
		
		article.setTitle("  我的待提交报销（"+cResp.getCount()+"）");
		article.setDescription("  我的待提交报销");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_expense_new.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/expense/list?viewtype=myview&viewtypesel=myview_new&approval=new&openId="+openId+"&publicId="+publicId); 
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
        
        //我的历史报销
        article = new Article();  
        sche.setViewtype("myview");//视图类型
        sche.setApproval("approved");
        cResp =   cRMService.getSugarService().getExpense2CrmService().getExpenseList(sche,"WX");
        
        article.setTitle("  我的已批准报销（"+cResp.getCount()+"）");
        article.setDescription("  我的已批准报销");  
        article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_expense_approved.png");  
        article.setUrl(PropertiesUtil.getAppContext("app.content") + "/expense/list?viewtype=myview&viewtypesel=myview_approved&approval=approved&openId="+openId+"&publicId="+publicId); 
        logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
        
        
        sche.setApproval("approving");
		sche.setViewtype("myview");
		cResp =   cRMService.getSugarService().getExpense2CrmService().getExpenseList(sche,"WX");
		//我的待审批报销
		article = new Article();  
		sche.setViewtype("myview");//视图类型
		sche.setApproval("approving");
		article.setTitle("  我的待审批报销（"+cResp.getCount()+"）");
		article.setDescription("  我的待审批报销");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_expense_wait.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/expense/list?viewtype=myview&viewtypesel=myview_approval&approval=approving&openId="+openId+"&publicId="+publicId); 
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
        
        sche.setApproval("reject");
		sche.setViewtype("myview");
		cResp = cRMService.getSugarService().getExpense2CrmService().getExpenseList(sche,"WX");
		//驳回的报销列表
		article = new Article();  
		article.setTitle("  驳回的报销（"+cResp.getCount()+"）");
		article.setDescription("  驳回的报销");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_expense_reject.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/expense/list?viewtype=myview&viewtypesel=myview_reject&approval=reject&openId="+openId+"&publicId="+publicId); 
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article); 
        
        
        sche.setApproval(null);
		sche.setViewtype("teamview");
		cResp = cRMService.getSugarService().getExpense2CrmService().getExpenseList(sche,"WX");
		//团队报销列表
		article = new Article();  
		article.setTitle("  我的团队报销（"+cResp.getCount()+"）");
		article.setDescription("  我的团队报销");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_expense_team.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/expense/list?viewtype=teamview&viewtypesel=teamview&openId="+openId+"&publicId="+publicId); 
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article); 
        
        sche.setApproval(null);
		sche.setViewtype("approvalview");
		cResp = cRMService.getSugarService().getExpense2CrmService().getExpenseList(sche,"WX");
		//待我审批的报销
		article = new Article(); 
		article.setTitle("  提交给我审批的报销（"+cResp.getCount()+"）");
		article.setDescription("  提交给我审批的报销");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_expense_approving.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/expense/list?viewtype=approvalview&viewtypesel=approvalview&openId="+openId+"&publicId="+publicId); 
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article); 
        
        //统计分析
        if(checkFunc(crmId, Constants.FUNC_WXCRM_MENU_ANALYTICS_EXPENSE_DEP)){
			article = new Article();  
			article.setTitle("  费用报销统计分析");
			article.setDescription("  费用统计分析");  
			article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_expense_analytics.png");  
			article.setUrl(PropertiesUtil.getAppContext("app.content") + "/analytics/expense/type?&openId="+openId+"&publicId="+publicId);  
			logger.info("getPicUrl => " + article.getPicUrl());
	        articleList.add(article); 
		}
		
		return articleList;
	}
	
	/**
	 * 追加费用类型业务数据
	 */
	private String apdExpBizData(String crmId, String uri)  throws Exception{
		String viewtype = StringUtils.getRankVal("viewtype", "\\&", uri);
		if("".equals(viewtype)) return "";
		String approval = StringUtils.getRankVal("approval", "\\&", uri);
		       approval = approval.equals("") ? null : approval ;
		logger.info("apdExpBizData viewtype :=>" + viewtype);
		logger.info("apdExpBizData approval :=>" + approval);
		//我的待审批报销
		Expense sche = new Expense();
		sche.setCrmId(crmId);
		sche.setExpensedate(null);
		sche.setDepart(null);
		sche.setExpensesubtype(null);
		sche.setCurrpage(null);
		sche.setPagecount(null);
		sche.setApproval(approval);
		sche.setViewtype(viewtype);
		ExpenseResp cResp =   cRMService.getSugarService().getExpense2CrmService().getExpenseList(sche,"WX");
		return "（"+cResp.getCount()+"）";
	}
	
	/**
	 * 查询客户信息列表并做消息转换
	 * @param crmId
	 */
	public List<Article> searchCustAndTransfMsg(String openId, String publicId, String crmId){
		//访问文章列表
		List<Article> articleList = new ArrayList<Article>(); 
		/*
		//查询  客户  数据  列表
		List<UserFunc> ufuncList = userFuncService.getUserFuncListByPara(crmId, null, "WXCRM_MEMU_ACC");
		log.info("searchCust ufuncList size =>" + ufuncList.size());
		for (int i = 0; i < ufuncList.size(); i++) {
			UserFunc uf = (UserFunc)ufuncList.get(i);
			log.info("getFunMem =:>" + uf.getFunMem());
			log.info("getFunImg =:>" + uf.getFunImg());
			log.info("getFunName =:>" + uf.getFunName());
			log.info("getFunUri before=:>" + uf.getFunUri());
			//查询文章的内容
			Article article = null;
			article = new Article();  
			article.setDescription(uf.getFunMem());//desc  
			article.setPicUrl(PropertiesUtil.getAppContext("app.content") + uf.getFunImg()); //pic url
			//uri 设置值
			String uri = uf.getFunUri();
			if(null != uri && !"".equals(uri)){
				uri = PropertiesUtil.getAppContext("app.content") + uf.getFunUri();
				if(uri.indexOf("?") != -1) uri += "&";
				else uri += "?";
				uri += "openId=" + openId + "&publicId=" + publicId;
				article.setUrl(uri); 
			}
			log.info("article.getUrl after =:>" + article.getUrl());
			log.info("apdCustBizData  =:>" + apdCustBizData(crmId, article.getUrl()));
			
			article.setTitle(uf.getFunName() + apdCustBizData(crmId, article.getUrl()));//title
			
			logger.info("getPicUrl => " + article.getPicUrl());
			logger.info("getTitle => " + article.getTitle());
			//放入集合
			if(articleList.size() >= 10) continue;//大于等于10则不再加入图文
	        articleList.add(article);   
		}
		*/
		//查询客户信息
		Customer sc = new Customer();
		sc.setCrmId(crmId);
		sc.setCurrpage(null);
		sc.setPagecount(null);
		
		Article article = null;
		article = new Article();  
		article.setTitle("【点击  创建客户】");
		article.setDescription("【点击  创建客户】");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/title_accnt_manager.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/customer/get?openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
        
        //我的客户
        sc.setViewtype("myview");
//		CustomerResp cResp = customer2SugarService.getCustomerList(sc,"WX");
		CustomerResp cResp = null;
        
        article = new Article();  
		article.setTitle("  我的客户（"+cResp.getCount()+"）");
		article.setDescription("  我的客户");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_accnt_my.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/customer/acclist?viewtype=myview&openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article); 
        
		//我团队的客户
        sc.setViewtype("teamview");
//		cResp = customer2SugarService.getCustomerList(sc,"WX");
        
        article = new Article();  
		article.setTitle("  我团队的客户（"+cResp.getCount()+"）");
		article.setDescription("  我团队的客户");
		
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_accnt_team.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/customer/acclist?viewtype=teamview&openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
		articleList.add(article); 
		
		
		article = new Article();  
		article.setTitle("  客户统计分析");
		article.setDescription("  客户统计分析");
		
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_expense_analytics.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/analytics/customer/industry?openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
		articleList.add(article); 
		        
		return articleList;
	}
	
	/**
	 * 追加  客户  业务数据
	 */
	private String apdCustBizData(String crmId, String uri){
		String viewtype = StringUtils.getRankVal("viewtype", "\\&", uri);
		if("".equals(viewtype)) return "";
		String approval = StringUtils.getRankVal("approval", "\\&", uri);
		       approval = approval.equals("") ? null : approval ;
		logger.info("apdCustBizData viewtype :=>" + viewtype);
		logger.info("apdCustBizData approval :=>" + approval);
		//客户查询
		Customer sc = new Customer();
		sc.setCrmId(crmId);
		sc.setCurrpage(null);
		sc.setPagecount(null);
		sc.setViewtype(viewtype);
//		CustomerResp cResp = customer2SugarService.getCustomerList(sc,"WX");
		CustomerResp cResp = null;
		return "（"+cResp.getCount()+"）";
	}
	
	/**
	 * 查询业务机会信息列表并做消息转换
	 * @param crmId
	 */
	public List<Article> searchOpptyAndTransfMsg(String openId, String publicId, String crmId){
		//访问文章列表
		List<Article> articleList = new ArrayList<Article>(); 
		/*
		//查询  业务机会  数据  列表
		List<UserFunc> ufuncList = userFuncService.getUserFuncListByPara(crmId, null, "WXCRM_MEMU_OPPTY");
		log.info("searchCust ufuncList size =>" + ufuncList.size());
		for (int i = 0; i < ufuncList.size(); i++) {
			UserFunc uf = (UserFunc)ufuncList.get(i);
			log.info("getFunMem =:>" + uf.getFunMem());
			log.info("getFunImg =:>" + uf.getFunImg());
			log.info("getFunName =:>" + uf.getFunName());
			log.info("getFunUri before=:>" + uf.getFunUri());
			//查询文章的内容
			Article article = null;
			article = new Article();  
			article.setDescription(uf.getFunMem());//desc  
			article.setPicUrl(PropertiesUtil.getAppContext("app.content") + uf.getFunImg()); //pic url
			//uri 设置值
			String uri = uf.getFunUri();
			if(null != uri && !"".equals(uri)){
				uri = PropertiesUtil.getAppContext("app.content") + uf.getFunUri();
				if(uri.indexOf("?") != -1) uri += "&";
				else uri += "?";
				uri += "openId=" + openId + "&publicId=" + publicId;
				article.setUrl(uri); 
			}
			log.info("article.getUrl after =:>" + article.getUrl());
			log.info("apdOpptyBizData  =:>" + apdOpptyBizData(crmId, article.getUrl()));
			
			article.setTitle(uf.getFunName() + apdOpptyBizData(crmId, article.getUrl()));//title
			
			logger.info("getPicUrl => " + article.getPicUrl());
			logger.info("getTitle => " + article.getTitle());
			//放入集合
			if(articleList.size() >= 10) continue;//大于等于10则不再加入图文
	        articleList.add(article);    
		}
		*/
		//查询客户信息
		Opportunity opp = new Opportunity();
		opp.setCrmId(crmId);
		opp.setCurrpage(null);
		opp.setPagecount(null);
		
		//添加业务机会
		Article article = null;
		article = new Article();  
		article.setTitle("【点击  创建业务机会】");  
		article.setDescription("【点击  创建业务机会】");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/title_oppty_manager.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/oppty/get?openId="+openId+"&publicId="+publicId);
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
        
        opp.setViewtype("myfollowingview");
//        OpptyResp oppResp = oppty2SugarService.getOpportunityList(opp,"WX");
        OpptyResp oppResp = null;
        
        //我的正在跟进的业务机会
        article = new Article();  
		article.setTitle("  我的正在跟进的业务机会（"+oppResp.getCount()+"）");
		article.setDescription("  我的正在跟进的业务机会");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_oppty_flow.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/oppty/opptylist?viewtype=myfollowingview&openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
        
        opp.setViewtype("mywonview");
//        oppResp = oppty2SugarService.getOpportunityList(opp,"WX");
        //我的已成单的业务机会
        article = new Article();  
        article.setTitle("  我的已成单的业务机会（"+oppResp.getCount()+"）");
        article.setDescription("  我的已成单的业务机会");  
        article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_oppty_won.png");  
        article.setUrl(PropertiesUtil.getAppContext("app.content") + "/oppty/opptylist?viewtype=mywonview&openId="+openId+"&publicId="+publicId);  
        logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article); 
        
        opp.setViewtype("myclosedview");
//        oppResp = oppty2SugarService.getOpportunityList(opp,"WX");
        //我的已关闭的业务机会
        article = new Article();  
        article.setTitle("  我的已关闭的业务机会（"+oppResp.getCount()+"）");
        article.setDescription("  我的已关闭的业务机会");  
        article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_oppty_lose.png");  
        article.setUrl(PropertiesUtil.getAppContext("app.content") + "/oppty/opptylist?viewtype=myclosedview&openId="+openId+"&publicId="+publicId);  
        logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
        
        opp.setViewtype("teamview");
//        oppResp = oppty2SugarService.getOpportunityList(opp,"WX");
        //我团队的业务机会
        article = new Article();  
		article.setTitle("  我团队的业务机会（"+oppResp.getCount()+"）");
		article.setDescription("  我团队的业务机会");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_oppty_team.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/oppty/opptylist?viewtype=teamview&openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
        //业务机会统计分析
        article = new Article();  
		article.setTitle("  业务机会统计分析");
		article.setDescription("  业务机会统计分析");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_oppty_analytics.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/analytics/oppty/pipeline?openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);
        
		return articleList;
	}
	
	/**
	 * 追加  客户  业务数据
	 */
	private String apdOpptyBizData(String crmId, String uri){
		String viewtype = StringUtils.getRankVal("viewtype", "\\&", uri);
		if("".equals(viewtype)) return "";
		logger.info("apdOpptyBizData viewtype :=>" + viewtype);
		//业务机会查询
		Opportunity opp = new Opportunity();
		opp.setCrmId(crmId);
		opp.setCurrpage(null);
		opp.setPagecount(null);
		opp.setViewtype(viewtype);
//        OpptyResp oppResp = oppty2SugarService.getOpportunityList(opp,"WX");
        OpptyResp oppResp = null;
		return "（"+oppResp.getCount()+"）";
	}

	/**
	 * 帮助
	 */
	public List<Article> help(String openId, String publicId, String crmId) {
		// 
		List<Article> articleList = new ArrayList<Article>();
		
		Article article = null;
		article = new Article();
		article.setTitle("德成微信CRM小秘书");
		article.setDescription("德成微信CRM小秘书");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content")
				+ "/image/wxcrm_logo.png");
		articleList.add(article);
		
		article = new Article();
		article.setTitle("【关于德成微信CRM】 \r\n   德成微信CRM是利用移动互联网和社交网络搭建的一个销售平台，以销售人员为中心，融合销售流程、销售知识库、团队协作及日常办公等核心功能于一体，通过便捷易用的移动端，全面提升销售团队效率和业绩。");
		articleList.add(article);
		
		article = new Article();
		article.setTitle("【版本发布】 \r\n   本次版本发布内容：费用报销及查询、客户查询、业务机会查询、安排任务。同时支持菜单与关键字。");
		articleList.add(article);
		
		article = new Article();
		article.setTitle("【首次使用注意事项】 \r\n   如果您是第一次使用，需要绑定您的内部CRM系统账号，打开德成鸿业测试公众号，选择菜单\"更多--账户绑定\"进行操作.");
		articleList.add(article);
		
		article = new Article();
		article.setTitle("【反馈与建议】 \r\n   使用过程中，如有任何建议或想法，欢迎在【德成微信CRM沟通群】中提出，您的支持是我们前进的动力，您的宝贵意见是我们改进的方向！");
		articleList.add(article);
		
		return articleList;
	}
	
	/**
	 * 查询联系人信息列表并作消息转换
	 * @param openId     发送方账号
	 * @param publicId	 公众号原始账号
	 * @param crmId      
	 * @throws Exception 
	 */
	public List<Article> searchContactAndTransfMsg(String openId,String publicId, String crmId){
		//访问文章列表
		List<Article> articleList = new ArrayList<Article>(); 
		/*
		//查询  回款  数据  列表
		List<UserFunc> ufuncList = userFuncService.getUserFuncListByPara(crmId, null, "WXCRM_MENU_GATHERING");
		log.info("searchCust ufuncList size =>" + ufuncList.size());
		for (int i = 0; i < ufuncList.size(); i++) {
			UserFunc uf = (UserFunc)ufuncList.get(i);
			log.info("getFunMem =:>" + uf.getFunMem());
			log.info("getFunImg =:>" + uf.getFunImg());
			log.info("getFunName =:>" + uf.getFunName());
			log.info("getFunUri before=:>" + uf.getFunUri());
			//查询文章的内容
			Article article = null;
			article = new Article();  
			article.setDescription(uf.getFunMem());//desc  
			article.setPicUrl(PropertiesUtil.getAppContext("app.content") + uf.getFunImg()); //pic url
			//uri 设置值
			String uri = uf.getFunUri();
			if(null != uri && !"".equals(uri)){
				uri = PropertiesUtil.getAppContext("app.content") + uf.getFunUri();
				if(uri.indexOf("?") != -1) uri += "&";
				else uri += "?";
				uri += "openId=" + openId + "&publicId=" + publicId;
				article.setUrl(uri); 
			}
			log.info("article.getUrl after =:>" + article.getUrl());
			log.info("apdGatherBizData  =:>" + apdGatherBizData(crmId, article.getUrl()));
			
			article.setTitle(uf.getFunName() + apdGatherBizData(crmId, article.getUrl()));//title
			
			logger.info("getPicUrl => " + article.getPicUrl());
			logger.info("getTitle => " + article.getTitle());
			//放入集合
			if(articleList.size() >= 10) continue;//大于等于10则不再加入图文
	        articleList.add(article);    
		}
		*/	
		Contact contact = new Contact();
		contact.setCrmId(crmId);
		contact.setPagecount(null);
		contact.setCurrpage(null);
		
		//查询联系人信息
		Article article = null;
		article = new Article();  
		article.setTitle("【点击  创建联系人】");  
		article.setDescription("【点击  创建联系人】"); 
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/wxcrm_logo.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/contact/add?flag=addCon&openId="+openId+"&publicId="+publicId); 
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
        
        //我的联系人
        article = new Article();  
        contact.setViewtype("myview");
//        ContactResp cResp = contact2SugarService.getContactClist(contact, "WX");
        
//		article.setTitle("  我的联系人列表 （"+(cResp.getCount())+"）");
		article.setDescription("  我的联系人列表");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/my.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/contact/clist?viewtype=myview&openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article); 
        
        //我团队的联系人
        article = new Article();  
        contact.setViewtype("teamview");
//        cResp = contact2SugarService.getContactClist(contact, "WX");
//		article.setTitle("  我团队的联系人 （"+(cResp.getCount())+"）");
		article.setDescription("  我团队的联系人");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/team.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/contact/clist?viewtype=teamview&openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article); 
        
		return articleList;
	}
	
	
	/**
	 * 追加  客户  业务数据
	 */
	private String apdGatherBizData(String crmId, String uri){
		String viewtype = StringUtils.getRankVal("viewtype", "\\&", uri);
		if("".equals(viewtype)) return "";
		
		//TODO
		return "";
	}

	/**
	 * 查询合同管理信息列表并作消息转换
	 * @param openId     发送方账号
	 * @param publicId	 公众号原始账号
	 * @param crmId      
	 */
	public List<Article> searchContractAndTransfMsg(String openId,
		String publicId, String crmId) {
		//访问文章列表
		List<Article> articleList = new ArrayList<Article>();
		/*
		//查询  合同  数据  列表
		List<UserFunc> ufuncList = userFuncService.getUserFuncListByPara(crmId, null, "WXCRM_MEMU_CONTRACT");
		log.info("searchCust ufuncList size =>" + ufuncList.size());
		for (int i = 0; i < ufuncList.size(); i++) {
			UserFunc uf = (UserFunc)ufuncList.get(i);
			log.info("getFunMem =:>" + uf.getFunMem());
			log.info("getFunImg =:>" + uf.getFunImg());
			log.info("getFunName =:>" + uf.getFunName());
			log.info("getFunUri before=:>" + uf.getFunUri());
			//查询文章的内容
			Article article = null;
			article = new Article();  
			article.setDescription(uf.getFunMem());//desc  
			article.setPicUrl(PropertiesUtil.getAppContext("app.content") + uf.getFunImg()); //pic url
			//uri 设置值
			String uri = uf.getFunUri();
			if(null != uri && !"".equals(uri)){
				uri = PropertiesUtil.getAppContext("app.content") + uf.getFunUri();
				if(uri.indexOf("?") != -1) uri += "&";
				else uri += "?";
				uri += "openId=" + openId + "&publicId=" + publicId;
				article.setUrl(uri); 
			}
			log.info("article.getUrl after =:>" + article.getUrl());
			article.setTitle(uf.getFunName());//title
			logger.info("getPicUrl => " + article.getPicUrl());
			logger.info("getTitle => " + article.getTitle());
			//放入集合
			if(articleList.size() >= 10) continue;//大于等于10则不再加入图文
	        articleList.add(article);    
		}
		*/
		
		Contract contract = new Contract();
		contract.setCrmId(crmId);
		contract.setPagecount(null);
		contract.setCurrpage(null);
		
		//查询合同信息
		Article article = null;
		article = new Article();  
		article.setTitle("合同");
		article.setDescription("合同");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/title_contract_manager.png");  
//		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/contract/get?openId="+openId+"&publicId="+publicId); 
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
        
        //我负责的合同
        contract.setContractstatus("effective");
        contract.setViewtype("myview");
        contract.setViewtypesel("myview_effective");
        ContractResp cResp = null;
//        ContractResp cResp = contract2CrmService.getContractList(contract, "WX");
        article = new Article();  
		article.setTitle("  正在履行的合同 （"+(cResp.getCount())+"）");
		article.setDescription("  正在履行的合同");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_contract_flow.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/contract/list?viewtype=myview&viewtypesel=myview_effective&status=effective&openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article); 
        
        //已完成的合同
        contract.setContractstatus("finish");
        contract.setViewtype("myview");
        contract.setViewtypesel("myview_finish");
//        cResp = contract2CrmService.getContractList(contract, "WX");
        article = new Article();  
		article.setTitle("  已完工的合同 （"+(cResp.getCount())+"）");
		article.setDescription("  已完工的合同");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_contract_finish.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/contract/list?viewtype=myview&viewtypesel=myview_finish&status=finish&openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article); 
        
        /*
        //异常的合同
        article = new Article();  
		article.setTitle("  异常合同");
		article.setDescription("  异常合同");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/tasks.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/contract/list?viewtype=myview&viewtypesel=myview_stop&status=stop&openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);
        */
        
        //我团队负责的合同
        contract.setContractstatus(null);
        contract.setViewtype("teamview");
        contract.setViewtypesel("teamview");
//        cResp = contract2CrmService.getContractList(contract, "WX");
        article = new Article();  
		article.setTitle("  我团队的合同 （"+(cResp.getCount())+"）");
		article.setDescription("  我团队的合同");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_contract_team.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/contract/list?viewtype=teamview&viewtypesel=teamview&openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);
        
        article = new Article();  
		article.setTitle("  回款统计分析");
		article.setDescription("  回款统计分析");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_contract_analytics.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/analytics/gathering/month?openId="+openId+"&publicId="+publicId);  
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article); 
        
		return articleList;
	}

	/**
	 * 查询传播信息列表并作消息转换
	 * @param openId     发送方账号
	 * @param publicId	 公众号原始账号
	 * @param crmId      
	 */
	public List<Article> searchArticleInfoAndTransfMsg(String openId,
			String publicId, String crmId) {
		
		ArticleInfo articleInfo = new ArticleInfo();
		articleInfo.setCrmId(crmId);
		articleInfo.setPagecount(null);
		articleInfo.setCurrpage(null); 
		
		
		
		return null;
	}
	
	public List<Article> searchFeedAndTransfMsg(String openId, String publicId, String crmId) {
		//访问文章列表
		List<Article> articleList = new ArrayList<Article>();
		//查询文章的内容
		Article article  = new Article();  
		article.setTitle("活动流");
		article.setDescription("活动流");//desc  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/title_feed_manager.png"); //pic url
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/feed/list?openId="+openId+"&publicId="+publicId);  
		articleList.add(article);   
		return articleList;
	}
	
	/**
	 * 微信关注历史消息
	 * @param openId
	 * @param publicId
	 * @param crmId
	 * @return
	 */
	public List<Article> searchWxSubscribeHisMsg(String openId, String publicId, String crmId) {
		//访问文章列表
		List<Article> articleList = new ArrayList<Article>(); 
		
		//
		Article article = null;
		article = new Article();  
		article.setTitle("指尖微客-我的商务社交圈");
		article.setDescription("指尖微客可以帮助您管理社区，发起、分享活动，管理生意。点击底部菜单即开始使用系统。小薇期待您常来光顾。");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/zjwk_focus.png");  
		article.setUrl(""); 
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
        
        //判断是否有名片
        boolean isExistsCard = false;
        BusinessCard bc = null;
        String partyId = cRMService.getWxService().getWxUserinfoService().getPartyRowId(openId);
        if(StringUtils.isNotNullOrEmptyStr(partyId)){
        	bc = new BusinessCard();
        	bc.setPartyId(partyId);
        	bc.setStatus("0");
        	List<BusinessCard> cardList = cRMService.getDbService().getBusinessCardService().getList(bc);
        	if(cardList.size() > 0){
        		bc = (BusinessCard)cardList.get(0);
        		if(StringUtils.isNotNullOrEmptyStr(bc.getPhone())){
        			isExistsCard = true;
        		}
        	}
        }
        
        String createScheUrl = "";
        //创建名片
		article = new Article();  
        //存在名片
        if(isExistsCard){
			article.setTitle("完善名片："+bc.getName() + "("+bc.getPhone()+")");
        }
        //不存在名片
        else{
			article.setTitle("新建名片");
        }
        article.setDescription("点我完善您的名片信息");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/menu/wx_msgs/msg_businesscard.png"); 
		try {
			createScheUrl = PropertiesUtil.getAppContext("app.content") + "msgentr/menu?userid="+openId+"&redirectUrl=" + URLEncoder.encode("/businesscard/modify", "UTF-8");
			log.info("createScheUrl = >" + createScheUrl);
		} catch (UnsupportedEncodingException e) {
			log.info("error = >" + e.getMessage());
		}
		article.setUrl(createScheUrl);
		articleList.add(article);
		
		//建立人脉-讨论组
		article = new Article();  
		article.setTitle("建立人脉-【讨论组】");
		article.setDescription("建立人脉-【讨论组】");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/menu/wx_msgs/msg_discugroup.png");  
		try {
			createScheUrl = PropertiesUtil.getAppContext("app.content") + "msgentr/menu?userid="+openId+"&redirectUrl=" + URLEncoder.encode("discuGroup/list", "UTF-8");
			log.info("createScheUrl = >" + createScheUrl);
		} catch (UnsupportedEncodingException e) {
			log.info("error = >" + e.getMessage());
		}
		article.setUrl(createScheUrl);
		articleList.add(article);
		
		//扩大影响-活动
		article = new Article();  
		article.setTitle("扩大影响-【活动】");
		article.setDescription("扩大影响-【活动】");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/menu/wx_msgs/msg_activity.png");  
		try {
			createScheUrl = PropertiesUtil.getAppContext("app.content") + "msgentr/menu?userid="+openId+"&redirectUrl=" + URLEncoder.encode("zjactivity/list", "UTF-8");
			log.info("createScheUrl = >" + createScheUrl);
		} catch (UnsupportedEncodingException e) {
			log.info("error = >" + e.getMessage());
		}
		article.setUrl(createScheUrl);
		articleList.add(article);
		
		//分享见闻-文章
		article = new Article();  
		article.setTitle("分享见闻-【文章】");
		article.setDescription("分享见闻-【文章】");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/menu/wx_msgs/msg_resource.png");  
		try {
			createScheUrl = PropertiesUtil.getAppContext("app.content") + "msgentr/menu?userid="+openId+"&redirectUrl=" + URLEncoder.encode("resource/list", "UTF-8");
			log.info("createScheUrl = >" + createScheUrl);
		} catch (UnsupportedEncodingException e) {
			log.info("error = >" + e.getMessage());
		}
		article.setUrl(createScheUrl);
		articleList.add(article);
		
		//提升效率-日程
		article = new Article();  
		article.setTitle("提升效率-【日程】");
		article.setDescription("提升效率-【日程】");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/menu/wx_msgs/msg_task.png");
		try {
			createScheUrl = PropertiesUtil.getAppContext("app.content") + "msgentr/menu?userid="+openId+"&redirectUrl=" + URLEncoder.encode("calendar/calendar", "UTF-8");
			log.info("createScheUrl = >" + createScheUrl);
		} catch (UnsupportedEncodingException e) {
			log.info("error = >" + e.getMessage());
		}
		article.setUrl(createScheUrl); 
		articleList.add(article);
		
//		//发送系统任务消息
//		WxuserInfo wxinfo = new WxuserInfo();
//		wxinfo.setOpenId(openId);
//		log.info("openId = >" + openId);
//		Object wxinfobj = cRMService.getWxService().getWxUserinfoService().findObj(wxinfo);
//		if(wxinfobj != null){
//			wxinfo = (WxuserInfo)wxinfobj;
//			String partyId = wxinfo.getParty_row_id();
//			String nickname = wxinfo.getNickname();
//			log.info("partyId = >" + partyId);
//			log.info("nickname = >" + nickname);
//			if(StringUtils.isNotNullOrEmptyStr(partyId)){
//				//关注指尖微客
//				cRMService.getDbService().getMessagesService().sendMsg("", "", partyId, nickname, "感谢您关注指尖微客", "System_Task_Welcome", "", "", "txt", "N", DateTime.currentDate(), "");
//				//创建名片任务
//				cRMService.getDbService().getMessagesService().sendMsg("", "", partyId, nickname, "点我完善您的名片信息", "System_Task_CreateCard", "", "", "txt", "N", DateTime.currentDate(), "");
//			}
//		}
		return articleList;
	}
	
	/**
	 * 再次   微信关注历史消息
	 * @param openId
	 * @param publicId
	 * @param crmId
	 * @return
	 */
	public List<Article> searchWxSubscribeHisMsgAgain(String openId, String publicId, String crmId) {
		//访问文章列表
		List<Article> articleList = new ArrayList<Article>(); 
		
		//创建任务
		Article article = null;
		article = new Article();  
		article.setTitle("感谢您再次关注指尖微客");
		article.setDescription("指尖微客可以帮助您管理社区，发起、分享活动，管理生意。点击底部菜单即开始使用系统。小薇期待您常来光顾。");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/zjwk_focus.png");  
		article.setUrl(""); 
		logger.info("getPicUrl => " + article.getPicUrl());
        articleList.add(article);  
		//创建名片
		article = new Article();  
		article.setTitle("  创建名片");
		article.setDescription("  点我完善您的名片信息");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/navbar_7.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") + "/businesscard/modify"); 
		articleList.add(article);
		
		String psumryUrl = "";
		String frlistUrl = "";
		try {
			psumryUrl = PropertiesUtil.getAppContext("app.content") + "msgentr/access?redirectUrl=" + URLEncoder.encode("dcCrm/psumry", "UTF-8");
			frlistUrl = PropertiesUtil.getAppContext("app.content") + "msgentr/access?redirectUrl=" + URLEncoder.encode("dcCrm/frlist", "UTF-8");
		} catch (UnsupportedEncodingException e) {
			log.info("error = >" + e.getMessage());
		}
		log.info("psumryUrl = >" + psumryUrl);
		log.info("frlistUrl = >" + frlistUrl);
		//个人总结报告
		article = new Article();  
		article.setTitle(" 个人总结报告");
		article.setDescription("  点我查看个人报告");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/expense_status_wait.png");  
		article.setUrl(psumryUrl); 
		articleList.add(article);
		//批量好友邀请
		/*article = new Article();  
		article.setTitle("  批量好友邀请");
		article.setDescription("  批量好友邀请列表");
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/list_task_today.png");  
		article.setUrl(frlistUrl); 
		articleList.add(article);*/
				
		return articleList;
	}
	
	/**
	 * 获取未读消息
	 * @param openId
	 * @return
	 */
	public List<Article> searchUnReadMessages(String openId) {
		List<Article> articleList = new ArrayList<Article>();
		
		//
		Article article = null;
		article = new Article();  
		article.setTitle("点击查看【通知】");
		article.setDescription("指尖微客可以帮助您管理社区，发起、分享活动，管理生意。点击底部菜单即开始使用系统。小薇期待您常来光顾。");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/zjwk_focus.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") +"/home/index"); 
        articleList.add(article); 
        
		//获取账户信息
		WxuserInfo wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId);
		String partyId = wxuser.getParty_row_id();
		Messages obj = new Messages();
		obj.setCurrpages(0);
		obj.setPagecounts(9);
		obj.setTargetUId(partyId);
		obj.setReadFlag("N");
		
		//调用后台查询数据库
		try{
			List<Messages> mlist = (List<Messages>)cRMService.getDbService().getMessagesService().searchSystemMessages(obj);
			if(null != mlist && mlist.size() > 0){
				String relaModule = "";
				String msgType = "";
				String msglink = "";
				String title = "";
				for(int i=0;i<mlist.size();i++){
					obj = mlist.get(i);
					relaModule = obj.getRelaModule();
					msgType = obj.getMsgType();
					
					article = new Article();  
					
					if("System_Activity".equals(relaModule)){
		    			title = "【活动】";
		    			msglink = PropertiesUtil.getAppContext("zjmarketing.url")+"/activity/detail?flag=share&id="+obj.getRelaId()+"&sourceid="+obj.getTargetUId();
		    		}
		    		else if("System_Group".equals(relaModule)){
		    			if("exchange_apply".equals(msgType) ||  "exchange_agree".equals(msgType)|| "exchange_reject".equals(msgType) || "group_apply".equals(msgType) || "group_notice".equals(msgType)){
		    				msglink = PropertiesUtil.getAppContext("app.content")+obj.getContent();
		    			}
		    		}
		    		else if("System_ChangeCard".equals(relaModule)){
						title = "【名片】";
		    			msglink = PropertiesUtil.getAppContext("app.content") +"/out/user/card?flag=Change&partyId="+obj.getUserId()+"&atten_partyId="+obj.getTargetUId();
		    		}
		    		else if("System_AgreeCard".equals(relaModule) || "System_RejectCard".equals(relaModule)){
						title = "【名片】";
		    			msglink = PropertiesUtil.getAppContext("app.content") +"/out/user/card?flag=RM&partyId="+obj.getUserId()+"&atten_partyId="+obj.getTargetUId();
		    		}
		    		else if("schedule".equals(relaModule)){
						title = "【任务】";
		    			msglink = PropertiesUtil.getAppContext("app.content") +"/schedule/detail?rowId="+obj.getRelaId()+"&orgId="+obj.getOrgId();
		    		}
					else if("customer".equals(relaModule)){
						title = "【客户】";
						msglink = PropertiesUtil.getAppContext("app.content") +"/customer/detail?rowId="+obj.getRelaId()+"&orgId="+obj.getOrgId();
					}
					else if("WorkReport".equals(relaModule)){
						title = "【工作计划】";
						msglink = PropertiesUtil.getAppContext("app.content") + "/workplan/detail?rowId="+obj.getRelaId()+"&orgId="+obj.getOrgId();
					}
					else if("Opportunities".equals(relaModule)){
						title = "【生意】";
						msglink = PropertiesUtil.getAppContext("app.content") + "/oppty/detail?rowId="+obj.getRelaId()+"&orgId="+obj.getOrgId();
					}else if("System_Task_CreateCard".equals(relaModule)){
						msglink = PropertiesUtil.getAppContext("app.content") + "/out/user/card?flag=RM&partyId="+obj.getRelaId()+"&atten_partyId="+obj.getTargetUId();
					}
					else if("System_Liu_Msg".equals(relaModule)){//留言
						title = "【留言】";
						msglink = PropertiesUtil.getAppContext("app.content")  +"/businesscard/detail?flag=0&partyId="+obj.getUserId();
					}
					else if("System_Personal_Msg".equals(relaModule)){//私信
						title = "【私信】";
						msglink = PropertiesUtil.getAppContext("app.content")  + "/businesscard/detail?flag=0&partyId="+obj.getUserId();
					}
					else if("System_LiuPer_Msg_Reply".equals(relaModule)){//留言回复
						title = "【留言】";
						msglink = PropertiesUtil.getAppContext("app.content") +"/businesscard/detail?flag=0&partyId="+obj.getUserId();
					}
					else if("Discugroup_Join".equals(relaModule)){//讨论组邀请消息
						title = "【讨论组】";
						msglink = PropertiesUtil.getAppContext("app.content") + "/discuGroup/detail?rowId="+obj.getRelaId();
					}
		    		
		    		if(!StringUtils.isNotNullOrEmptyStr(msglink)){
		    			msglink = "";
		    		}
		    			    		
		    		if(StringUtils.isNotNullOrEmptyStr(obj.getRelaName()) && ("customer".equals(relaModule) || "schedule".equals(relaModule) || "Opportunities".equals(relaModule))){
						title = title + obj.getRelaName();
		    		}else{
		    			 title = title+ (null == obj.getUsername() ? "小微" : obj.getUsername());
		    		}
		    		
		    		if("exchange_apply".equals(msgType)){
		    			title = "【名片】";
						obj.setContent("申请与您交换名片");
					}else if("exchange_apply".equals(msgType)){
						title = "【名片】";
						obj.setContent("同意与您的交换名片");
					}else if("exchange_reject".equals(msgType)){
						title = "【名片】";
						obj.setContent("驳回了您的名片申请");
					}else if("group_apply".equals(msgType)){
						if(StringUtils.isNotNullOrEmptyStr(obj.getRelaName())){
							obj.setContent("申请加入您的群【"+obj.getRelaName()+"】");
						}else{
							obj.setContent("申请加入您的群");
						}
					}else if("group_notice".equals(msgType)){
						obj.setContent(obj.getUsername() + "已经加入了您的群");
			    	}else if("group_agree".equals(msgType)){
			    		obj.setContent(obj.getUsername() + "同意了您的加群申请");
			    	}
					article.setTitle(title + "\r\n" + obj.getContent());
					article.setDescription("  点我完善您的名片信息");
					article.setPicUrl("");  
					article.setUrl(msglink); 
					articleList.add(article);
				}
			}else{
				article = new Article();
				article.setTitle("没有未读通知");
				article.setDescription("  点我完善您的名片信息");
				article.setPicUrl("");  
				article.setUrl(""); 
				articleList.add(article);
			}
		}catch(Exception e){
			logger.error("searchUnReadMessages ---- error -" + e.toString());
		}
		
		return articleList;
	}

	/**
	 * 
	 */
	public List<Article> searchUnFinishTask(String openId) {
		List<Article> articleList = new ArrayList<Article>();
		
		//
		Article article = null;
		article = new Article();  
		article.setTitle("点击查看【日程】");
		article.setDescription("指尖微客可以帮助您管理社区，发起、分享活动，管理生意。点击底部菜单即开始使用系统。小薇期待您常来光顾。");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/zjwk_focus.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") +"/calendar/calendar"); 
        articleList.add(article); 
        
        Schedule sche = new Schedule();
        sche.setViewtype("WXMenuView");
        sche.setOpenId(openId);
        sche.setCurrpage("1");
        sche.setPagecount("9");
        sche.setStatus("In Progress,Planned,Not Started");
        try{
	        ScheduleResp scheResp =cRMService.getSugarService().getSchedule2SugarService().getScheduleList(sche, "");
	      	String delayDays = null;
	        if(null != scheResp && null != scheResp.getTasks() && scheResp.getTasks().size() >0){
	        	List<ScheduleAdd> taskList = scheResp.getTasks();
	        	ScheduleAdd sa = null;
	        	for(int i=0;i<taskList.size();i++){
	        		if(i>=9){
	        			break;
	        		}
	        		sa = taskList.get(i);
	        		article = new Article();
	        		delayDays = "";
	        		if(StringUtils.isNotNullOrEmptyStr(sa.getEnddate())){
	        			Long days = DateTime.daysBetween(DateTime.currentDate("yyyy-MM-dd hh:mm"),sa.getEnddate(),false,null);
	        			if(days >0){
	        				delayDays = " 延期"+days+"天";
	        			}
	        		}
	        		
	        		if("00:00".equals(sa.getStartdate().substring(11)) && StringUtils.isNotNullOrEmptyStr(sa.getEnddate()) && "00:00".equals(sa.getEnddate().substring(11))){
	        			article.setTitle(sa.getStartdate().substring(5,10) + "  全天  \r\n" + sa.getTitle() + "("+sa.getStatusname()+")" + delayDays);
	        		}else{
	        			article.setTitle(sa.getStartdate().substring(5) + (StringUtils.isNotNullOrEmptyStr(sa.getEnddate()) ? " - " + sa.getEnddate().substring(11) : "") + "  \r\n" + sa.getTitle() + "("+sa.getStatusname()+")" + delayDays);
	        		}
					article.setDescription("");
					article.setPicUrl("");  
					article.setUrl(PropertiesUtil.getAppContext("app.content") + "/schedule/detail?rowId="+sa.getRowid() + "&schetype=task&orgId="+sa.getOrgId()); 
					articleList.add(article);
	        	}
	        }else{
	        	article = new Article();
				article.setTitle("没有找到日程数据");
				article.setDescription("");
				article.setPicUrl("");  
				article.setUrl(""); 
				articleList.add(article);
	        }
        }catch(Exception e){
        	logger.error("searchUnFinishTask ---- error -" + e.toString());
        }
		return articleList;
	}

	/**
	 * 
	 */
	public List<Article> searchWorkPlanEval(String openId) {
		List<Article> articleList = new ArrayList<Article>();
		
		//
		Article article = null;
		article = new Article();  
		article.setTitle("点击查看【工作计划】");
		article.setDescription("指尖微客可以帮助您管理社区，发起、分享活动，管理生意。点击底部菜单即开始使用系统。小薇期待您常来光顾。");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/zjwk_focus.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") +"/workplan/list"); 
        articleList.add(article); 
        
        //获取账户信息
        WxuserInfo wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId);
      	String partyId = wxuser.getParty_row_id();
      	
      	WorkReport workReport = new WorkReport();
      	workReport.setOrderByString(" create_time desc ");
      	workReport.setCurrpages(0);
      	workReport.setPagecounts(9);
      	workReport.setViewtype(Constants.SEARCH_VIEW_TYPE_MYVIEW);
      	workReport.setAssigner_id(partyId);
      	//workReport.setStart_date(DateTime.preDayTime(DateTime.DateFormat1));
      	//workReport.setEnd_date(DateTime.preDayTime(DateTime.DateFormat1));
      	try{
      		List<WorkReport> wReportList =  cRMService.getDbService().getWorkPlanService().findWorkReportComments(workReport);
//      		String avg = "";
      		if(null != wReportList && wReportList.size() >0){
	        	for(int i=0;i<wReportList.size();i++){
	        		workReport = wReportList.get(i);
	        		article = new Article();
//	        		avg = RedisCacheUtil.getString("ZJWK_WORKPLAN_SINGLE_AVG_"+workReport.getId());
//	        		if(!StringUtils.isNotNullOrEmptyStr(avg)){
//	        			avg = "";
//	        		}else{
//	        			avg =avg.substring(avg.lastIndexOf(";"));
//	        		}
					article.setTitle(workReport.getTitle() + "\r\n" + workReport.getCreator() +" : "+workReport.getComments_grade());
					article.setDescription("");
					article.setPicUrl("");  
					article.setUrl(PropertiesUtil.getAppContext("app.content") + "/workplan/detail?rowId="+workReport.getId() + "&orgId="+workReport.getOrgId()); 
					articleList.add(article);
	        	}
	        }else{
	        	article = new Article();
				article.setTitle("没有找到评价数据");
				article.setDescription("");
				article.setPicUrl("");  
				article.setUrl(""); 
				articleList.add(article);
	        }
      	}catch(Exception e){
      		logger.error("searchWorkPlanEval ---- error -" + e.toString());
      	}
		return articleList;
	}

	public List<Article> searchNoticeActivity(String openId) {
		List<Article> articleList = new ArrayList<Article>();
		
		//
		Article article = null;
		article = new Article();  
		article.setTitle("点击查看【关注的活动】");
		article.setDescription("指尖微客可以帮助您管理社区，发起、分享活动，管理生意。点击底部菜单即开始使用系统。小薇期待您常来光顾。");  
		article.setPicUrl(PropertiesUtil.getAppContext("app.content") + "/image/zjwk_focus.png");  
		article.setUrl(PropertiesUtil.getAppContext("app.content") +"/zjactivity/list"); 
        articleList.add(article); 
        
        //获取账户信息
        WxuserInfo wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId);
      	String partyId = wxuser.getParty_row_id();
      	
      	try{
      		List<Activity_Rela> list =  cRMService.getBusinessService().getActivityService().getNoticeActivitiesByOpenId(openId);
//      		String avg = "";
      		if(null != list && list.size() >0){
	        	for(Activity_Rela ar : list){
	        		Activity act = cRMService.getBusinessService().getActivityService().geActivityById(ar.getActivity_id());
	        		article = new Article();
					article.setTitle(act.getTitle());
					article.setDescription(act.getContent());
					article.setPicUrl("http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/" + act.getLogo());  
					article.setUrl(PropertiesUtil.getAppContext("app.content") + "/zjwkactivity/detail?id="+ar.getActivity_id() + "&sourceid="+partyId); 
					articleList.add(article);
	        	}
	        }else{
	        	article = new Article();
				article.setTitle("没有找到关注的活动");
				article.setDescription("");
				article.setPicUrl("");  
				article.setUrl(""); 
				articleList.add(article);
	        }
      	}catch(Exception e){
      		logger.error("searchNoticeActivity ---- error -" + e.toString());
      	}
		return articleList;
	}
}
