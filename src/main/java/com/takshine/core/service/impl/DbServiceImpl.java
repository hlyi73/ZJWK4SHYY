package com.takshine.core.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.DbService;
import com.takshine.marketing.service.ActivityParticipantService;
import com.takshine.marketing.service.ActivityPrintService;
import com.takshine.marketing.service.ActivityService;
import com.takshine.marketing.service.Activity_RelaService;
import com.takshine.marketing.service.AttachmentService;
import com.takshine.marketing.service.DirectSendService;
import com.takshine.marketing.service.InviteService;
import com.takshine.marketing.service.LovService;
import com.takshine.marketing.service.Participant2WkService;
import com.takshine.marketing.service.ParticipantService;
import com.takshine.marketing.service.SourceObject2SourceSystemService;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.service.AccessLogsHisService;
import com.takshine.wxcrm.service.AccessLogsService;
import com.takshine.wxcrm.service.ArticleInfoService;
import com.takshine.wxcrm.service.ArticleTypeService;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.CacheContactService;
import com.takshine.wxcrm.service.CacheContractService;
import com.takshine.wxcrm.service.CacheCustomerService;
import com.takshine.wxcrm.service.CacheExpenseService;
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
import com.takshine.wxcrm.service.Group2ZjrmService;
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
import com.takshine.wxcrm.service.SignService;
import com.takshine.wxcrm.service.SocialContactService;
import com.takshine.wxcrm.service.SocialUserinfoService;
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
import com.takshine.wxcrm.service.impl.OrganizationServiceImpl;

/**
 * 系统中所有的数据库service实现类
 * @author dengbo
 *
 */
@Service("dbService")
public class DbServiceImpl extends BaseServiceImpl implements DbService {
	
	/**
	 * 活动
	 */
	@Autowired
	@Qualifier("activityService")
	public ActivityService activityService;

	/**
	 * 活动-查询参与活动
	 */
	@Autowired
	@Qualifier("activityParticipantService")
	public ActivityParticipantService activityParticipantService;
	
	/**
	 * 活动-印记
	 */
	@Autowired
	@Qualifier("activityPrintService")
	public ActivityPrintService activityPrintService;
	
	/**
	 * 活动-附件服务
	 */
	@Autowired
	@Qualifier("attachmentService")
	public AttachmentService attachmentService;
	
	/**
	 * 活动-图文直播
	 */
	@Autowired
	@Qualifier("directSendService")
	public DirectSendService directSendService;
	
	/**
	 * 活动-邀约
	 */
	@Autowired
	@Qualifier("inviteService")
	public InviteService inviteService;
	
	/**
	 * 活动-下拉列表
	 */
	@Autowired
	@Qualifier("lovService")
	public LovService lovService;
	
	/**
	 * 活动-同步联系人
	 */
	@Autowired
	@Qualifier("participant2WkService")
	public Participant2WkService participant2WkService;
	
	/**
	 * 活动-报名
	 */
	@Autowired
	@Qualifier("participantService")
	public ParticipantService participantService;
	
	/**
	 * 活动-查询用户或组织
	 */
	@Autowired
	@Qualifier("sourceObject2SourceSystemService")
	public SourceObject2SourceSystemService sourceObject2SourceSystemService;
	
	/**
	 * 日志
	 */
	@Autowired
	@Qualifier("accessLogsHisService")
	public AccessLogsHisService accessLogsHisService;

	/**
	 * 访问日志
	 */
	@Autowired
	@Qualifier("accessLogsService")
	public AccessLogsService accessLogsService;
	
	/**
	 * 文章信息
	 */
	@Autowired
	@Qualifier("articleInfoService")
	public ArticleInfoService articleInfoService;
	
	/**
	 * 文章类型
	 */
	@Autowired
	@Qualifier("articleTypeService")
	public ArticleTypeService articleTypeService;
	
	/**
	 * 名片
	 */
	@Autowired
	@Qualifier("businessCardService")
	public BusinessCardService businessCardService;
	
	/**
	 * 联系人前端缓存
	 */
	@Autowired
	@Qualifier("cacheContactService")
	public CacheContactService cacheContactService;
	
	/**
	 * 合同前端缓存
	 */
	@Autowired
	@Qualifier("cacheContractService")
	public CacheContractService cacheContractService;
	
	/**
	 * 客户前端缓存
	 */
	@Autowired
	@Qualifier("cacheCustomerService")
	public CacheCustomerService cacheCustomerService;
	
	/**
	 * 商机前端缓存
	 */
	@Autowired
	@Qualifier("cacheOpptyService")
	public CacheOpptyService cacheOpptyService;
	
	/**
	 * 报价前端缓存
	 */
	@Autowired
	@Qualifier("cacheQuoteService")
	public CacheQuoteService cacheQuoteService;
	
	/**
	 * 任务前端缓存
	 */
	@Autowired
	@Qualifier("cacheScheduleService")
	public CacheScheduleService cacheScheduleService;
	
	/**
	 * 任务前端缓存
	 */
	@Autowired
	@Qualifier("cacheExpenseService")
	public CacheExpenseService cacheExpenseService;

	/**
	 * 评价
	 */
	@Autowired
	@Qualifier("commentsService")
	public CommentsService commentsService;
	
	/**
	 * 用户绑定手机
	 */
	@Autowired
	@Qualifier("dcCrmOperatorService")
	public DcCrmOperatorService dcCrmOperatorService;
	
	/**
	 * 讨论组
	 */
	@Autowired
	@Qualifier("discuGroupService")
	public DiscuGroupService discuGroupService;
	
	/**
	 * 讨论组审批
	 */
	@Autowired
	@Qualifier("discuGroupExamService")
	public DiscuGroupExamService discuGroupExamService;
	
	/**
	 * 讨论组公告
	 */
	@Autowired
	@Qualifier("discuGroupNoticeService")
	public DiscuGroupNoticeService discuGroupNoticeService;
	
	/**
	 * 讨论组话题消息
	 */
	@Autowired
	@Qualifier("discuGroupTopicMsgService")
	public DiscuGroupTopicMsgService discuGroupTopicMsgService;
	
	/**
	 * 讨论组用户
	 */
	@Autowired
	@Qualifier("discuGroupUserService")
	public DiscuGroupUserService discuGroupUserService;
	
	/**
	 * 用户订阅
	 */
	@Autowired
	@Qualifier("innerUserService")
	public InnerUserService innerUserService;
	
	/**
	 * 积分
	 */
	@Autowired
	@Qualifier("integralService")
	public IntegralService integralService;

	/**
	 * 菜单
	 */
	@Autowired
	@Qualifier("menuService")
	public MenuService menuService;
	
	/**
	 * 消息
	 */
	@Autowired
	@Qualifier("messageService")
	public MessageService messageService;
	
	/**
	 * 消息（最新使用）
	 */
	@Autowired
	@Qualifier("messagesService")
	public MessagesService messagesService;
	
	/**
	 * 标签与实体关联实现类
	 */
	@Autowired
	@Qualifier("modelTagService")
	public ModelTagService modelTagService;
	
	/**
	 * 用户和手机绑定关系
	 */
	@Autowired
	@Qualifier("operatorMobileService")
	public OperatorMobileService operatorMobileService;
	
	/**
	 * 组织
	 */
	@Autowired
	@Qualifier("organizationService")
	public OrganizationService organizationService;
	
	/**
	 * 平台服务
	 */
	@Autowired
	@Qualifier("platformStatisticsService")
	public PlatformStatisticsService platformStatisticsService;
	
	/**
	 * 微客-印记
	 */
	@Autowired
	@Qualifier("printService")
	public PrintService printService;
	
	/**
	 * 注册
	 */
	@Autowired
	@Qualifier("registerService")
	public RegisterService registerService;
	
	/**
	 * 资料
	 */
	@Autowired
	@Qualifier("resourceService")
	public ResourceService resourceService;
	
	/**
	 * 用户新闻订阅
	 */
	@Autowired
	@Qualifier("rssNewsService")
	public RssNewsService rssNewsService;
	
	/**
	 * 考勤签到/签出
	 */
	@Autowired
	@Qualifier("signService")
	public SignService signService;
	
	/**
	 * 微博联系人关联
	 */
	@Autowired
	@Qualifier("socialContactService")
	public SocialContactService socialContactService;
	
	/**
	 * 星标与实体关联
	 */
	@Autowired
	@Qualifier("starModelService")
	public StarModelService starModelService;
	
	/**
	 * 用户订阅
	 */
	@Autowired
	@Qualifier("subscribeService")
	public SubscribeService subscribeService;
	
	/**
	 * 标签与实体关联
	 */
	@Autowired
	@Qualifier("tagModelService")
	public TagModelService tagModelService;
	
	/**
	 * 标签实现
	 */
	@Autowired
	@Qualifier("tagService")
	public TagService tagService;
	
	/**
	 * 微博联系人关联
	 */
	@Autowired
	@Qualifier("teamPeasonService")
	public TeamPeasonService teamPeasonService;
	
	/**
	 * 发送模板消息
	 */
	@Autowired
	@Qualifier("templateMsgService")
	public TemplateMsgService templateMsgService;
	
	/**
	 * 履历实现
	 */
	@Autowired
	@Qualifier("userExperienceService")
	public UserExperienceService userExperienceService;
	
	/**
	 * 用户关注
	 */
	@Autowired
	@Qualifier("userFocusService")
	public UserFocusService userFocusService;
	
	/**
	 * 用户的菜单集
	 */
	@Autowired
	@Qualifier("userFuncService")
	public UserFuncService userFuncService;
	
	/**
	 * 用户的个性化服务
	 */
	@Autowired
	@Qualifier("userPerferencesService")
	public UserPerferencesService userPerferencesService;
	
	/**
	 * 用户关联
	 */
	@Autowired
	@Qualifier("userRelaService")
	public UserRelaService userRelaService;
	
	/**
	 * 版本管理
	 */
	@Autowired
	@Qualifier("versionsContentService")
	public VersionsContentService versionsContentService;
	
	/**
	 * 工作计划关联任务
	 */
	@Autowired
	@Qualifier("workPlanRelaTaskService")
	public WorkPlanRelaTaskService workPlanRelaTaskService;
	
	/**
	 * 工作计划
	 */
	@Autowired
	@Qualifier("workPlanService")
	public WorkPlanService workPlanService;
	
	@Autowired
	@Qualifier("messagesExtService")
	public MessagesExtService messagesExtService;
	
	@Autowired
	@Qualifier("itineraryService")
	public ItineraryService itineraryService;

	@Autowired
	@Qualifier("socialUserinfoService")
	public SocialUserinfoService socialUserinfoService;
	
	@Autowired
	@Qualifier("group2ZjrmService")
	public Group2ZjrmService group2ZjrmService;

	/**
	 * 活动关联
	 */
	@Autowired
	@Qualifier("activity_RelaService")
	public Activity_RelaService activity_RelaService;

	public Activity_RelaService getActivity_RelaService() {
		return activity_RelaService;
	}

	public SocialUserinfoService getSocialUserinfoService() {
		return socialUserinfoService;
	}

	public Group2ZjrmService getGroup2ZjrmService() {
		return group2ZjrmService;
	}

	public ActivityService getActivityService() {
		return activityService;
	}

	public ActivityParticipantService getActivityParticipantService() {
		return activityParticipantService;
	}

	public ActivityPrintService getActivityPrintService() {
		return activityPrintService;
	}

	public AttachmentService getAttachmentService() {
		return attachmentService;
	}

	public DirectSendService getDirectSendService() {
		return directSendService;
	}

	public InviteService getInviteService() {
		return inviteService;
	}

	public LovService getLovService() {
		return lovService;
	}

	public Participant2WkService getParticipant2WkService() {
		return participant2WkService;
	}

	public ParticipantService getParticipantService() {
		return participantService;
	}

	public SourceObject2SourceSystemService getSourceObject2SourceSystemService() {
		return sourceObject2SourceSystemService;
	}

	public AccessLogsHisService getAccessLogsHisService() {
		return accessLogsHisService;
	}

	public AccessLogsService getAccessLogsService() {
		return accessLogsService;
	}

	public ArticleInfoService getArticleInfoService() {
		return articleInfoService;
	}

	public ArticleTypeService getArticleTypeService() {
		return articleTypeService;
	}

	public BusinessCardService getBusinessCardService() {
		return businessCardService;
	}

	public CacheContactService getCacheContactService() {
		return cacheContactService;
	}

	public CacheContractService getCacheContractService() {
		return cacheContractService;
	}

	public CacheCustomerService getCacheCustomerService() {
		return cacheCustomerService;
	}

	public CacheOpptyService getCacheOpptyService() {
		return cacheOpptyService;
	}

	public CacheQuoteService getCacheQuoteService() {
		return cacheQuoteService;
	}

	public CacheScheduleService getCacheScheduleService() {
		return cacheScheduleService;
	}

	public CommentsService getCommentsService() {
		return commentsService;
	}

	public DcCrmOperatorService getDcCrmOperatorService() {
		return dcCrmOperatorService;
	}

	public DiscuGroupService getDiscuGroupService() {
		return discuGroupService;
	}

	public DiscuGroupExamService getDiscuGroupExamService() {
		return discuGroupExamService;
	}

	public DiscuGroupNoticeService getDiscuGroupNoticeService() {
		return discuGroupNoticeService;
	}

	public DiscuGroupTopicMsgService getDiscuGroupTopicMsgService() {
		return discuGroupTopicMsgService;
	}

	public DiscuGroupUserService getDiscuGroupUserService() {
		return discuGroupUserService;
	}

	public InnerUserService getInnerUserService() {
		return innerUserService;
	}

	public IntegralService getIntegralService() {
		return integralService;
	}

	public MenuService getMenuService() {
		return menuService;
	}

	public MessageService getMessageService() {
		return messageService;
	}

	public MessagesService getMessagesService() {
		return messagesService;
	}

	public ModelTagService getModelTagService() {
		return modelTagService;
	}

	public OperatorMobileService getOperatorMobileService() {
		return operatorMobileService;
	}

	public OrganizationService getOrganizationService() {
		return organizationService;
	}

	public PlatformStatisticsService getPlatformStatisticsService() {
		return platformStatisticsService;
	}

	public PrintService getPrintService() {
		return printService;
	}

	public RegisterService getRegisterService() {
		return registerService;
	}

	public ResourceService getResourceService() {
		return resourceService;
	}

	public RssNewsService getRssNewsService() {
		return rssNewsService;
	}

	public SignService getSignService() {
		return signService;
	}

	public SocialContactService getSocialContactService() {
		return socialContactService;
	}

	public StarModelService getStarModelService() {
		return starModelService;
	}

	public SubscribeService getSubscribeService() {
		return subscribeService;
	}

	public TagModelService getTagModelService() {
		return tagModelService;
	}

	public TagService getTagService() {
		return tagService;
	}

	public TeamPeasonService getTeamPeasonService() {
		return teamPeasonService;
	}

	public TemplateMsgService getTemplateMsgService() {
		return templateMsgService;
	}

	public UserExperienceService getUserExperienceService() {
		return userExperienceService;
	}

	public UserFocusService getUserFocusService() {
		return userFocusService;
	}

	public UserFuncService getUserFuncService() {
		return userFuncService;
	}

	public UserPerferencesService getUserPerferencesService() {
		return userPerferencesService;
	}

	public UserRelaService getUserRelaService() {
		return userRelaService;
	}

	public VersionsContentService getVersionsContentService() {
		return versionsContentService;
	}

	public WorkPlanRelaTaskService getWorkPlanRelaTaskService() {
		return workPlanRelaTaskService;
	}

	public WorkPlanService getWorkPlanService() {
		return workPlanService;
	}

	public MessagesExtService getMessagesExtService() {
		return messagesExtService;
	}

	public ItineraryService getItineraryService() {
		return itineraryService;
	}

	public CacheExpenseService getCacheExpenseService() {
		return cacheExpenseService;
	}

}
