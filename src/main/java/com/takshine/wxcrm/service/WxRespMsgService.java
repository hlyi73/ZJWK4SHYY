package com.takshine.wxcrm.service;

/**
 * 微信 相应消息服务
 * @author liulin
 *
 */
public interface WxRespMsgService {
	/**
	 * 用户命令转换 返回对应的值
	 * @param fromUserName
	 * @param toUserName
	 * @param content
	 * @param option
	 * @return
	 */
	public String commandTransf(String fromUserName, String toUserName, String content, String option);
	
	/**
	 * 响应费用菜单选项
	 * @param fromUserName 发送方帐号（open_id）
	 * @param toUserName 公众号原始ID
	 * @return
	 */
	public String respExpenseMenu(String fromUserName, String toUserName) throws Exception;
	
	/**
	 * 响应联系人菜单选项
	 * @param fromUserName 发送方原始账号(openId)
	 * @param toUserName 公众号原始ID(publicId)
	 * @return
	 */
	public String respContactMenu(String fromUserName,String toUserName);
	
	/**
	 * 响应合同管理菜单选项
	 * @param fromUserName 发送方原始账号(openId)
	 * @param toUserName 公众号原始ID(publicId)
	 * @return
	 */
	public String respContractMenu(String fromUserName,String toUserName);
	
	/**
	 * 响应日程菜单选项
	 * @param fromUserName 发送方帐号（open_id）
	 * @param toUserName 公众号原始ID
	 * @return
	 */
	public String respSchedualMenu(String fromUserName, String toUserName);
	
	/**
	 * 响应客户菜单选项
	 * @param fromUserName 发送方帐号（open_id）
	 * @param toUserName 公众号原始ID
	 * @return
	 */
	public String respCustomerMenu(String fromUserName, String toUserName);
	
	/**
	 * 响应业务机会菜单选项
	 * @param fromUserName 发送方帐号（open_id）
	 * @param toUserName 公众号原始ID
	 * @return
	 */
	public String respOpptyMenu(String fromUserName, String toUserName);
	
	/**
	 * 响应业务机会菜单选项
	 * @param fromUserName 发送方帐号（open_id）
	 * @param toUserName 公众号原始ID
	 * @return
	 */
	public String respBindingMenu(String fromUserName, String toUserName);
	
	/**
	 * 
	 * @param fromUserName
	 * @param toUserName
	 * @return
	 */
	public String respCancelBindingMenu(String fromUserName, String toUserName);
	
	/**
	 * 响应 微信订阅历史图文菜单
	 * @param fromUserName
	 * @param toUserName
	 * @return
	 */
	public String respWxSubscribeHisMenu(String fromUserName, String toUserName, boolean rstflag);
	
	/**
	 * 帮助
	 * @param fromUserName
	 * @param toUserName
	 * @return
	 */
	public String respHelpMenu(String fromUserName, String toUserName);
	
	/**
	 * 活动流
	 * @param fromUserName
	 * @param toUserName
	 * @return
	 */
	public String respFeedMenu(String fromUserName, String toUserName);
	
	/**
	 * 响应客服消息
	 * @return
	 */
	public void respExpCustMsg(String crmId, String rowId, String type, String orgId);
	
	/**
	 * 响应 通用的  客服消息
	 * @param crmId 后台CRM客户ID
	 * @param content 发送的内容
	 * @param detailUri 查看详情的链接
	 * @return
	 */
	public void respCommCustMsgByCrmId(String crmId, String content, String detailUri);
	
	/**
	 * 根据openId 发送客服消息
	 * @param receiveopenId 消息接受者的openId
	 * @param openId 数据拥有者的openId
	 * @param publicId
	 * @param content
	 * @param detailUri
	 */
	public void respCommCustMsgByOpenId(String receiveopenId, String openId, 
			                                 String publicId, String content, String detailUri);
	
	/**
	 * (针对简报)响应客服消息
	 * @param crmId
	 * @param content
	 * @param detailUri
	 * @param operatorMobileService
	 */
	public void respCommCustMsgByCrmId(String crmId, String[] strs,OperatorMobileService operatorMobileService);

	/**
	 * 推送消息
	 * @param openId
	 * @param content
	 * @param detailUri
	 */
	public void respSimpCustMsgByOpenId(String openId, String content, String detailUri);
	
	/**
	 * 每天早报推送消息
	 * @param receiveopenId
	 * @param content
	 */
	public void respReportByOpenId(String receiveopenId,String content);
}