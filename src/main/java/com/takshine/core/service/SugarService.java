package com.takshine.core.service;

import com.takshine.wxcrm.service.Activity2CrmService;
import com.takshine.wxcrm.service.AnalyticsService;
import com.takshine.wxcrm.service.ApproveListService;
import com.takshine.wxcrm.service.Attachment2CrmService;
import com.takshine.wxcrm.service.Bug2SugarService;
import com.takshine.wxcrm.service.CalendarService;
import com.takshine.wxcrm.service.Campaigns2CrmService;
import com.takshine.wxcrm.service.Campaigns2ZJMKTService;
import com.takshine.wxcrm.service.ComplaintService;
import com.takshine.wxcrm.service.Contact2SugarService;
import com.takshine.wxcrm.service.Contract2CrmService;
import com.takshine.wxcrm.service.Customer2SugarService;
import com.takshine.wxcrm.service.Expense2CrmService;
import com.takshine.wxcrm.service.FeedsService;
import com.takshine.wxcrm.service.Gathering2CrmService;
import com.takshine.wxcrm.service.Index2SugarService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.Oppty2SugarService;
import com.takshine.wxcrm.service.Partner2SugarService;
import com.takshine.wxcrm.service.Product2SugarService;
import com.takshine.wxcrm.service.ProductType2SugarService;
import com.takshine.wxcrm.service.Project2CrmService;
import com.takshine.wxcrm.service.Quote2CrmService;
import com.takshine.wxcrm.service.RepeatNameService;
import com.takshine.wxcrm.service.Rival2SugarService;
import com.takshine.wxcrm.service.Rss2SugarService;
import com.takshine.wxcrm.service.Schedule2SugarService;
import com.takshine.wxcrm.service.Share2SugarService;
import com.takshine.wxcrm.service.Tas2SugarService;
import com.takshine.wxcrm.service.TrackhisService;
import com.takshine.wxcrm.service.WeekReport2SugarService;

/**
 * 调用sugar服务类
 * @author dengbo
 *
 */
public interface SugarService {
	public AnalyticsService getAnalyticsService();

	public ApproveListService getApproveListService();

	public Attachment2CrmService getAttachment2CrmService();

	public Activity2CrmService getActivity2CrmService();

	public Bug2SugarService getBug2SugarService();
	
	public CalendarService getCalendarService();

	public Campaigns2CrmService getCampaigns2CrmService();

	public Campaigns2ZJMKTService getCampaigns2ZJmktService();

	public ComplaintService getComplaintService();

	public Contact2SugarService getContact2SugarService();

	public Contract2CrmService getContract2CrmService() ;

	public Expense2CrmService getExpense2CrmService();

	public Customer2SugarService getCustomer2SugarService();

	public FeedsService getFeedsService();

	public Gathering2CrmService getGathering2CrmService();
	public Index2SugarService getIndex2SugarService();

	public LovUser2SugarService getLovUser2SugarService();

	public Oppty2SugarService getOppty2SugarService();

	public Partner2SugarService getPartner2SugarService();

	public Product2SugarService getProduct2SugarService();

	public ProductType2SugarService getProductType2SugarService();

	public Project2CrmService getProject2CrmService();

	public Quote2CrmService getQuote2CrmService();

	public RepeatNameService getRepeatNameService();

	public Rival2SugarService getRival2SugarService();

	public Rss2SugarService getRss2SugarService();

	public Schedule2SugarService getSchedule2SugarService();

	public Share2SugarService getShare2SugarService();

	public Tas2SugarService getTas2SugarService();

	public TrackhisService getTrackhisService();

	public WeekReport2SugarService getWeekReport2SugarService();
}
