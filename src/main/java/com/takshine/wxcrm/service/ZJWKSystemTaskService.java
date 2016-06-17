package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.NoticeReport;

/**
 * 指尖微客系统任务处理类
 *
 */
public interface ZJWKSystemTaskService extends EntityService {
	public List<NoticeReport> searchAllSystemCard(NoticeReport bc);
	
	public boolean intelligentSendMessages(List<BusinessCard> cardList,String content,String url,boolean isSearchInfo,String sendMethod) throws Exception;
	
	public boolean intelligentSendMessages(List<BusinessCard> cardList,String content,String url,String smsurl,String emailurl,boolean isSearchInfo,String sendMethod) throws Exception;
	
	public boolean intelligentSMSSend(List<BusinessCard> cardList,String content,String url) throws Exception;
	
	public boolean intelligentEmailSend(List<BusinessCard> cardList,String content,String url) throws Exception;
	
	public boolean intelligentWXSend(List<BusinessCard> cardList,String content,String url) throws Exception;
}
