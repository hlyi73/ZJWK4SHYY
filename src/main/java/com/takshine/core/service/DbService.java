package com.takshine.core.service;

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

/**
 * 系统中所有的数据库service实现类
 * @author dengbo
 *
 */
public interface DbService{
	public ActivityService getActivityService();

	public ActivityParticipantService getActivityParticipantService();

	public ActivityPrintService getActivityPrintService();

	public AttachmentService getAttachmentService();

	public DirectSendService getDirectSendService();

	public InviteService getInviteService() ;

	public LovService getLovService();

	public Participant2WkService getParticipant2WkService();

	public ParticipantService getParticipantService();

	public SourceObject2SourceSystemService getSourceObject2SourceSystemService();

	public AccessLogsHisService getAccessLogsHisService();

	public AccessLogsService getAccessLogsService() ;

	public ArticleInfoService getArticleInfoService();

	public ArticleTypeService getArticleTypeService();

	public BusinessCardService getBusinessCardService();

	public CacheContactService getCacheContactService();

	public CacheContractService getCacheContractService();

	public CacheCustomerService getCacheCustomerService();

	public CacheOpptyService getCacheOpptyService();

	public CacheQuoteService getCacheQuoteService();

	public CacheScheduleService getCacheScheduleService();

	public CommentsService getCommentsService();

	public DcCrmOperatorService getDcCrmOperatorService();

	public DiscuGroupService getDiscuGroupService();

	public DiscuGroupExamService getDiscuGroupExamService();

	public DiscuGroupNoticeService getDiscuGroupNoticeService();

	public DiscuGroupTopicMsgService getDiscuGroupTopicMsgService();

	public DiscuGroupUserService getDiscuGroupUserService();

	public InnerUserService getInnerUserService();

	public IntegralService getIntegralService();

	public MenuService getMenuService();

	public MessageService getMessageService();

	public MessagesService getMessagesService();

	public ModelTagService getModelTagService();

	public OperatorMobileService getOperatorMobileService();

	public OrganizationService getOrganizationService();

	public PlatformStatisticsService getPlatformStatisticsService();

	public PrintService getPrintService();

	public RegisterService getRegisterService();

	public ResourceService getResourceService();

	public RssNewsService getRssNewsService();

	public SignService getSignService();

	public SocialContactService getSocialContactService();

	public StarModelService getStarModelService();

	public SubscribeService getSubscribeService();

	public TagModelService getTagModelService();

	public TagService getTagService();

	public TeamPeasonService getTeamPeasonService();

	public TemplateMsgService getTemplateMsgService();

	public UserExperienceService getUserExperienceService();

	public UserFocusService getUserFocusService();

	public UserFuncService getUserFuncService();

	public UserPerferencesService getUserPerferencesService();

	public UserRelaService getUserRelaService();

	public VersionsContentService getVersionsContentService();

	public WorkPlanRelaTaskService getWorkPlanRelaTaskService();

	public WorkPlanService getWorkPlanService();

	public MessagesExtService getMessagesExtService();

	public ItineraryService getItineraryService();
	
	public Group2ZjrmService getGroup2ZjrmService();
	
	public SocialUserinfoService getSocialUserinfoService();
	
	public CacheExpenseService getCacheExpenseService();
	
	public Activity_RelaService getActivity_RelaService();
}
