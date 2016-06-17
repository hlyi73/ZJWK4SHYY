package com.takshine.wxcrm.service;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Analytics;
import com.takshine.wxcrm.domain.IndexKPI;
import com.takshine.wxcrm.message.sugar.AnalyticsResp;

/**
 * 报表 业务处理接口
 *
 */
public interface AnalyticsService extends EntityService {

	/**
	 * 费用报表-按部门统计
	 * 
	 * @return
	 */
	public AnalyticsResp getAnalyticsExpense4Depart(Analytics analytics);

	/**
	 * 费用报表-按类型统计
	 * 
	 * @return
	 */
	public AnalyticsResp getAnalyticsExpense4Type(Analytics analytics);

	/**
	 * 费用报表-按类型统计
	 * 
	 * @return
	 */
	public AnalyticsResp getAnalyticsExpense4SubType(Analytics analytics);

	/**
	 * 业务机会阶段统计表
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsOppty4Stage(Analytics analytics);

	/**
	 * 业务机会阶段统计表
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsOppty4SPipeline(Analytics analytics);

	/**
	 * 业务机会失败原因统计表
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsOppty4Failure(Analytics analytics);
	
	/**
	 * 业务机会成单率统计表
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsOppty4Rate(Analytics analytics);
	
	/**
	 * 业务机会成单排名统计表
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsOppty4Rank(Analytics analytics);
	
	/**
	 * 业务机会成单同比统计表
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsOppty4Yearcompare(Analytics analytics);
	
	
	/**
	 * 业务机会成单环比统计表
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsOppty4Monthcompare(Analytics analytics);

	/**
	 * 业务机会阶段统计表
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp opptyAnalyticsOppty4Salestage(Analytics analytics);

	/**
	 * 回款统计-by月份
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsReceivable4Month(Analytics analytics);

	/**
	 * 回款统计表-by部门
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsReceivable4Depart(Analytics analytics);

	/**
	 * 回款统计-by客户
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsReceivable4Customer(Analytics analytics);

	/**
	 * 异常回款分析
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsReceivable4Unusual(Analytics analytics);

	/**
	 * 客户行业分析
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsReceivable4Industry(Analytics analytics);

	/**
	 * 客户地理分布分析
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsCustomer4Distribute(Analytics analytics);

	/**
	 * 客户贡献分析
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticCustomer4Contribution(Analytics analytics);

	/**
	 * 客户未来业务机会分析
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsCustomer4Futureoppty(Analytics analytics);
	
	/**
	 * 联系人贡献分析
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsContact4Contribution(Analytics analytics);

	/**
	 * 联系人未来业务机会分析
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsContact4Futureoppty(Analytics analytics);

	/**
	 * 潜在客户时间分析
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsReceivable4Latent(Analytics analytics);

	/**
	 * 销售目标分析(季度)
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsQuota4Quarter(Analytics analytics);

	/**
	 * 销售目标分析(月份)
	 * 
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsQuota4Month(Analytics analytics);
	
	/**
	 * 服务请求分析(月份)
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsComplaint4Month(Analytics analytics);
	
	/**
	 * 服务请求分析(类型)
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsComplaint4Subtype(Analytics analytics);

	/**
	 * 服务请求分析(部门)
	 * @param analytics
	 * @return
	 */
	public AnalyticsResp getAnalyticsComplaint4Depart(Analytics analytics);
	
	public IndexKPI getIndexKPI(String crmId, String startDate, String endDate)throws Exception;
}
