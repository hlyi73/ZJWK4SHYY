package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.message.resp.Article;

/**
 * 微信 消息推送服务 实现类
 * @author liulin
 *
 */
public interface WxPushMsgService {
	
	/**
	 * 把日程列表转换成文章列表
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public List<Article> searchTaskAndTransfMsg(String openId, String publicId, String crmId);
	
	/**
	 * 活动流
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public List<Article> searchFeedAndTransfMsg(String openId, String publicId, String crmId);
	
	/**
	 * 查询费用信息列表并做消息转换
	 * @param crmId
	 */
	public List<Article> searchExpenseAndTransfMsg(String openId, String publicId, String crmId) throws Exception;
	
	/**
	 * 查询客户信息列表并做消息转换
	 * @param crmId
	 */
	public List<Article> searchCustAndTransfMsg(String openId, String publicId, String crmId);
	
	/**
	 * 查询业务机会信息列表并做消息转换
	 * @param crmId
	 */
	public List<Article> searchOpptyAndTransfMsg(String openId, String publicId, String crmId);
	
	/**
	 * 查询联系人信息列表并做消息转换
	 * @param openId
	 * @param publicId
	 * @param crmId
	 * @return
	 */
	public List<Article> searchContactAndTransfMsg(String openId,String publicId,String crmId); 
	
	/**
	 * 查询合同信息列表并作消息转换
	 * @param openId
	 * @param publicId
	 * @param crmId
	 * @return
	 */
	public List<Article> searchContractAndTransfMsg(String openId,String publicId,String crmId);
	
	/**
	 * 取消绑定
	 * @param openId
	 * @param publicId
	 * @param crmId
	 * @return
	 */
	public List<Article> help(String openId,String publicId,String crmId);
	
	/**
	 * 微信关注历史消息
	 * @param openId
	 * @param publicId
	 * @param crmId
	 * @return
	 */
	public List<Article> searchWxSubscribeHisMsg(String openId, String publicId, String crmId) ;
	
	/**
	 * 再次   微信关注历史消息
	 * @param openId
	 * @param publicId
	 * @param crmId
	 * @return
	 */
	public List<Article> searchWxSubscribeHisMsgAgain(String openId, String publicId, String crmId) ;
	
	/**
	 * 获取未读消息
	 * @param openId
	 * @return
	 */
	public List<Article> searchUnReadMessages(String openId) ;
	
	
	/**
	 * 获取未完成的任务
	 * @param openId
	 * @return
	 */
	public List<Article> searchUnFinishTask(String openId) ;
	
	
	/**
	 * 获取工作计划评价
	 * @param openId
	 * @return
	 */
	public List<Article> searchWorkPlanEval(String openId) ;
	

	/**
	 * 获取关注的活动
	 * @param openId
	 * @return
	 */
	public List<Article> searchNoticeActivity(String openId) ;
}
