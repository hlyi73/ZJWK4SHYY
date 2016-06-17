package com.takshine.core.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.WxService;
import com.takshine.marketing.service.ActivityParticipantService;
import com.takshine.marketing.service.ActivityPrintService;
import com.takshine.marketing.service.ActivityService;
import com.takshine.marketing.service.AttachmentService;
import com.takshine.marketing.service.DirectSendService;
import com.takshine.marketing.service.InviteService;
import com.takshine.marketing.service.LovService;
import com.takshine.marketing.service.Participant2WkService;
import com.takshine.marketing.service.ParticipantService;
import com.takshine.marketing.service.SourceObject2SourceSystemService;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.service.AccessLogsHisService;
import com.takshine.wxcrm.service.AccessLogsService;
import com.takshine.wxcrm.service.ArticleInfoService;
import com.takshine.wxcrm.service.ArticleTypeService;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.CacheContactService;
import com.takshine.wxcrm.service.CacheContractService;
import com.takshine.wxcrm.service.CacheCustomerService;
import com.takshine.wxcrm.service.CacheOpptyService;
import com.takshine.wxcrm.service.CacheQuoteService;
import com.takshine.wxcrm.service.CacheScheduleService;
import com.takshine.wxcrm.service.CommentsService;
import com.takshine.wxcrm.service.DcCrmOperatorService;
import com.takshine.wxcrm.service.DiscuGroupExamService;
import com.takshine.wxcrm.service.DiscuGroupNoticeService;
import com.takshine.wxcrm.service.DiscuGroupService;
import com.takshine.wxcrm.service.DiscuGroupTopicMsgService;
import com.takshine.wxcrm.service.DiscuGroupUserService;
import com.takshine.wxcrm.service.InnerUserService;
import com.takshine.wxcrm.service.IntegralService;
import com.takshine.wxcrm.service.ItineraryService;
import com.takshine.wxcrm.service.MenuService;
import com.takshine.wxcrm.service.MessageService;
import com.takshine.wxcrm.service.MessagesExtService;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.ModelTagService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.OrganizationService;
import com.takshine.wxcrm.service.PlatformStatisticsService;
import com.takshine.wxcrm.service.PrintService;
import com.takshine.wxcrm.service.RegisterService;
import com.takshine.wxcrm.service.ResourceService;
import com.takshine.wxcrm.service.RssNewsService;
import com.takshine.wxcrm.service.ScheduledScansService;
import com.takshine.wxcrm.service.SignService;
import com.takshine.wxcrm.service.SocialContactService;
import com.takshine.wxcrm.service.StarModelService;
import com.takshine.wxcrm.service.SubscribeService;
import com.takshine.wxcrm.service.TagModelService;
import com.takshine.wxcrm.service.TagService;
import com.takshine.wxcrm.service.TeamPeasonService;
import com.takshine.wxcrm.service.TemplateMsgService;
import com.takshine.wxcrm.service.UserExperienceService;
import com.takshine.wxcrm.service.UserFocusService;
import com.takshine.wxcrm.service.UserFuncService;
import com.takshine.wxcrm.service.UserPerferencesService;
import com.takshine.wxcrm.service.UserRelaService;
import com.takshine.wxcrm.service.VersionsContentService;
import com.takshine.wxcrm.service.WorkPlanRelaTaskService;
import com.takshine.wxcrm.service.WorkPlanService;
import com.takshine.wxcrm.service.WxAddressInfoService;
import com.takshine.wxcrm.service.WxCoreService;
import com.takshine.wxcrm.service.WxPushMsgService;
import com.takshine.wxcrm.service.WxReplyService;
import com.takshine.wxcrm.service.WxRespMsgService;
import com.takshine.wxcrm.service.WxSubscribeHisService;
import com.takshine.wxcrm.service.WxTodayInHistoryService;
import com.takshine.wxcrm.service.WxUserLocationService;
import com.takshine.wxcrm.service.WxUserinfoService;
import com.takshine.wxcrm.service.ZJWKSystemTaskService;

/**
 * 系统中微信通用接口
 * @author dengbo
 *
 */
@Service("wxService")
public class WxServiceImpl implements WxService {
	
	/**
	 * 地址服务信息
	 */
	@Autowired
	@Qualifier("wxAddressInfoService")
	public WxAddressInfoService wxAddressInfoService;

	/**
	 * 核心服务
	 */
	@Autowired
	@Qualifier("wxCoreService")
	public WxCoreService wxCoreService;
	
	/**
	 * 微信信息处理服务
	 */
	@Autowired
	@Qualifier("wxReplyService")
	public WxReplyService wxReplyService;
	
	/**
	 * 响应消息
	 */
	@Autowired
	@Qualifier("wxRespMsgService")
	public WxRespMsgService wxRespMsgService;
	
	/**
	 * 微信订阅服务
	 */
	@Autowired
	@Qualifier("wxSubscribeHisService")
	public WxSubscribeHisService wxSubscribeHisService;
	
	/**
	 * 历史上的今天
	 */
	@Autowired
	@Qualifier("wxTodayInHistoryService")
	public WxTodayInHistoryService wxTodayInHistoryService;
	
	/**
	 * 微信用户服务实现
	 */
	@Autowired
	@Qualifier("wxUserinfoService")
	public WxUserinfoService wxUserinfoService;
	
	/**
	 * 微信用户地址服务
	 */
	@Autowired
	@Qualifier("wxUserLocationService")
	public WxUserLocationService wxUserLocationService;
	
	/**
	 * 微信智能发送
	 */
	@Autowired
	@Qualifier("zjwkSystemTaskService")
	public ZJWKSystemTaskService zjwkSystemTaskService;
	
	@Autowired
	@Qualifier("wxHttpConUtil")
	public WxHttpConUtil wxHttpConUtil;
	
	@Autowired
	@Qualifier("wxPushMsgService")
	public WxPushMsgService wxPushMsgService;
	
	@Autowired
	@Qualifier("scheduledScansService")
	public ScheduledScansService scheduledScansService;
	
	
	public ScheduledScansService getScheduledScansService() {
		return scheduledScansService;
	}

	public WxPushMsgService getWxPushMsgService() {
		return wxPushMsgService;
	}

	public WxHttpConUtil getWxHttpConUtil() {
		return wxHttpConUtil;
	}

	public ZJWKSystemTaskService getZjwkSystemTaskService() {
		return zjwkSystemTaskService;
	}

	public WxAddressInfoService getWxAddressInfoService() {
		return wxAddressInfoService;
	}

	public WxCoreService getWxCoreService() {
		return wxCoreService;
	}

	public WxReplyService getWxReplyService() {
		return wxReplyService;
	}

	public WxRespMsgService getWxRespMsgService() {
		return wxRespMsgService;
	}

	public WxSubscribeHisService getWxSubscribeHisService() {
		return wxSubscribeHisService;
	}

	public WxTodayInHistoryService getWxTodayInHistoryService() {
		return wxTodayInHistoryService;
	}

	public WxUserinfoService getWxUserinfoService() {
		return wxUserinfoService;
	}

	public WxUserLocationService getWxUserLocationService() {
		return wxUserLocationService;
	}
	
}
