package com.takshine.core.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.SugarService;
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
@Service("sugarService")
public class SugarServiceImpl implements SugarService {
	
	/**
	 * 活动对接sugar后端
	 */
	@Autowired
	@Qualifier("activity2SugarService")
	public Activity2CrmService activity2CrmService;
	
	/**
	 * 报表对接sugar后端
	 */
	@Autowired
	@Qualifier("analyticsService")
	public AnalyticsService analyticsService;
	
	/**
	 * 审批对接sugar后端
	 */
	@Autowired
	@Qualifier("approveListService")
	public ApproveListService approveListService;

	/**
	 * 附件对接sugar后端
	 */
	@Autowired
	@Qualifier("attachment2CrmService")
	public Attachment2CrmService attachment2CrmService;
	
	/**
	 * bug对接sugar后端
	 */
	@Autowired
	@Qualifier("bug2SugarService")
	public Bug2SugarService bug2SugarService;
	
	/**
	 * 日历对接sugar后端
	 */
	@Autowired
	@Qualifier("calendarService")
	public CalendarService calendarService;
	
	/**
	 * 市场活动对接sugar后端
	 */
	@Autowired
	@Qualifier("campaigns2CrmService")
	public Campaigns2CrmService campaigns2CrmService;
	
	/**
	 * 市场活动对接sugar后端
	 */
	@Autowired
	@Qualifier("campaigns2ZJmktService")
	public Campaigns2ZJMKTService campaigns2ZJmktService;
	
	/**
	 * 服务请求对接sugar后端
	 */
	@Autowired
	@Qualifier("complaintService")
	public ComplaintService complaintService;
	
	/**
	 * 联系人对接sugar后端
	 */
	@Autowired
	@Qualifier("contact2SugarService")
	public Contact2SugarService contact2SugarService;
	
	/**
	 * 合同对接sugar后端
	 */
	@Autowired
	@Qualifier("contract2CrmService")
	public Contract2CrmService contract2CrmService;
	
	/**
	 * 费用对接sugar后端
	 */
	@Autowired
	@Qualifier("expense2CrmService")
	public Expense2CrmService expense2CrmService;
	
	/**
	 * 客户对接sugar后端
	 */
	@Autowired
	@Qualifier("customer2SugarService")
	public Customer2SugarService customer2SugarService;
	
	/**
	 * 报表对接sugar后端
	 */
	@Autowired
	@Qualifier("feedsService")
	public FeedsService feedsService;
	
	/**
	 * 收款对接sugar后端
	 */
	@Autowired
	@Qualifier("gathering2CrmService")
	public Gathering2CrmService gathering2CrmService;
	
	/**
	 * KPI对接sugar后端
	 */
	@Autowired
	@Qualifier("index2SugarService")
	public Index2SugarService index2SugarService;
	
	/**
	 * 下拉列表对接sugar后端
	 */
	@Autowired
	@Qualifier("lovUser2SugarService")
	public LovUser2SugarService lovUser2SugarService;
	
	/**
	 * 商机对接sugar后端
	 */
	@Autowired
	@Qualifier("oppty2SugarService")
	public Oppty2SugarService oppty2SugarService;
	
	/**
	 * 合作伙伴对接sugar后端
	 */
	@Autowired
	@Qualifier("partner2SugarService")
	public Partner2SugarService partner2SugarService;
	
	/**
	 * 产品对接sugar后端
	 */
	@Autowired
	@Qualifier("product2SugarService")
	public Product2SugarService product2SugarService;

	/**
	 * 产品列表对接sugar后端
	 */
	@Autowired
	@Qualifier("productType2SugarService")
	public ProductType2SugarService productType2SugarService;
	
	/**
	 * 项目对接sugar后端
	 */
	@Autowired
	@Qualifier("project2CrmService")
	public Project2CrmService project2CrmService;

	/**
	 * 报价对接sugar后端
	 */
	@Autowired
	@Qualifier("quote2CrmService")
	public Quote2CrmService quote2CrmService;
	
	/**
	 * 去重对接sugar后端
	 */
	@Autowired
	@Qualifier("repeatNameService")
	public RepeatNameService repeatNameService;
	
	/**
	 * 竞争对手对接sugar后端
	 */
	@Autowired
	@Qualifier("rival2SugarService")
	public Rival2SugarService rival2SugarService;
	
	/**
	 * 活动对接sugar后端
	 */
	@Autowired
	@Qualifier("rss2SugarService")
	public Rss2SugarService rss2SugarService;
	
	/**
	 * 日程对接sugar后端
	 */
	@Autowired
	@Qualifier("schedule2SugarService")
	public Schedule2SugarService schedule2SugarService;
	
	/**
	 * 团队对接sugar后端
	 */
	@Autowired
	@Qualifier("share2SugarService")
	public Share2SugarService share2SugarService;
	
	/**
	 * Tas销售论对接sugar后端
	 */
	@Autowired
	@Qualifier("tas2SugarService")
	public Tas2SugarService tas2SugarService;
	
	/**
	 * 跟进历史对接sugar后端
	 */
	@Autowired
	@Qualifier("trackhisService")
	public TrackhisService trackhisService;
	
	/**
	 * 周报对接sugar后端
	 */
	@Autowired
	@Qualifier("weekReport2SugarService")
	public WeekReport2SugarService weekReport2SugarService;

	public AnalyticsService getAnalyticsService() {
		return analyticsService;
	}

	public ApproveListService getApproveListService() {
		return approveListService;
	}

	public Attachment2CrmService getAttachment2CrmService() {
		return attachment2CrmService;
	}

	public Activity2CrmService getActivity2CrmService() {
		return activity2CrmService;
	}

	public Bug2SugarService getBug2SugarService() {
		return bug2SugarService;
	}

	public CalendarService getCalendarService() {
		return calendarService;
	}

	public Campaigns2CrmService getCampaigns2CrmService() {
		return campaigns2CrmService;
	}

	public Campaigns2ZJMKTService getCampaigns2ZJmktService() {
		return campaigns2ZJmktService;
	}

	public ComplaintService getComplaintService() {
		return complaintService;
	}

	public Contact2SugarService getContact2SugarService() {
		return contact2SugarService;
	}

	public Contract2CrmService getContract2CrmService() {
		return contract2CrmService;
	}

	public Expense2CrmService getExpense2CrmService() {
		return expense2CrmService;
	}

	public Customer2SugarService getCustomer2SugarService() {
		return customer2SugarService;
	}

	public FeedsService getFeedsService() {
		return feedsService;
	}

	public Gathering2CrmService getGathering2CrmService() {
		return gathering2CrmService;
	}

	public Index2SugarService getIndex2SugarService() {
		return index2SugarService;
	}

	public LovUser2SugarService getLovUser2SugarService() {
		return lovUser2SugarService;
	}

	public Oppty2SugarService getOppty2SugarService() {
		return oppty2SugarService;
	}

	public Partner2SugarService getPartner2SugarService() {
		return partner2SugarService;
	}

	public Product2SugarService getProduct2SugarService() {
		return product2SugarService;
	}

	public ProductType2SugarService getProductType2SugarService() {
		return productType2SugarService;
	}

	public Project2CrmService getProject2CrmService() {
		return project2CrmService;
	}

	public Quote2CrmService getQuote2CrmService() {
		return quote2CrmService;
	}

	public RepeatNameService getRepeatNameService() {
		return repeatNameService;
	}

	public Rival2SugarService getRival2SugarService() {
		return rival2SugarService;
	}

	public Rss2SugarService getRss2SugarService() {
		return rss2SugarService;
	}

	public Schedule2SugarService getSchedule2SugarService() {
		return schedule2SugarService;
	}

	public Share2SugarService getShare2SugarService() {
		return share2SugarService;
	}

	public Tas2SugarService getTas2SugarService() {
		return tas2SugarService;
	}

	public TrackhisService getTrackhisService() {
		return trackhisService;
	}

	public WeekReport2SugarService getWeekReport2SugarService() {
		return weekReport2SugarService;
	}
	
}
