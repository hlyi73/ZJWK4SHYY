package com.takshine.wxcrm.service.impl;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.HttpClient3Post;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.base.util.runtime.SMSSentThread;
import com.takshine.wxcrm.base.util.runtime.ThreadExecute;
import com.takshine.wxcrm.base.util.runtime.ThreadRun;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.NoticeReport;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.CacheContactService;
import com.takshine.wxcrm.service.WxRespMsgService;
import com.takshine.wxcrm.service.ZJWKSystemTaskService;

/**
 * 报表   相关业务接口实现
 *
 */
@Service("zjwkSystemTaskService")
public class ZJWKSystemTaskServiceImpl extends BaseServiceImpl implements ZJWKSystemTaskService {
	
	private static Logger log = Logger.getLogger(ZJWKSystemTaskServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		

	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 获取所有名片信息
	 * 用于每日早报推送消息
	 */
	public List<NoticeReport> searchAllSystemCard(NoticeReport bc) {
		return getSqlSession().selectList("systemTaskSql.searchAllSystemCardList",bc);
	}
	
	/**
	 * 智能发送消息
	 * 1.优先微信发送
	 * 2.邮件发送
	 * 3.短信发送
	 * @param cardList  //发送队列
	 * @param content	//发送内容
	 * @param url 		//发送链接
	 * @param isSearchInfo  //是否需要查询用户信息 如果需要，根据partyId查询
	 * @param sendMethod //发送方式，0：智能发送，1：微信发送，2：短信发送，3：邮件发送
	 * @return true:发送成功， false：发送失败
	 */
	public boolean intelligentSendMessages(List<BusinessCard> cardList,String content, String url, String urlSms, String urlEmail, boolean isSearchInfo, String sendMethod) throws Exception {
		if(null == cardList || cardList.size() == 0 || !StringUtils.isNotNullOrEmptyStr(content)){
			return false;
		}
		if(!StringUtils.isNotNullOrEmptyStr(urlSms)){
			urlSms = url;
		}
		if(!StringUtils.isNotNullOrEmptyStr(urlEmail)){
			urlEmail = url;
		}
		// 是否需要查询用户
		if (isSearchInfo) {
			List<String> partyIdList = new ArrayList<String>();
			for (int i = 0; i < cardList.size(); i++) {
				partyIdList.add(cardList.get(i).getPartyId());
			}
			BusinessCard bc = new BusinessCard();
			bc.setParty_rowid_in(partyIdList);
			cardList = getSqlSession().selectList("systemTaskSql.searchUserInfoByPartyIds",bc);
		}
		
		//智能发送
		if(!StringUtils.isNotNullOrEmptyStr(sendMethod) || "0".equals(sendMethod)){
			BusinessCard bc = null;
			List<BusinessCard> wxCardList = new ArrayList<BusinessCard>();
			List<BusinessCard> smsCardList = new ArrayList<BusinessCard>();
			for(int i=0;i<cardList.size();i++){
				bc = cardList.get(i);
				//
				if(StringUtils.isNotNullOrEmptyStr(bc.getPartyId()) && ZJWKUtil.is48HourInner(bc.getPartyId())){
					wxCardList.add(bc);
				}
				//如果partyId为空，则短信发送
				else{
					smsCardList.add(bc);
				}
			}
			
			intelligentWXSend(wxCardList, content, url);
			intelligentSMSSend(smsCardList, content, urlSms);
			return true;
		}
		//微信发送
		else if("1".equals(sendMethod)){
			return intelligentWXSend(cardList, content, url);
		}
		//短信发送
		else if("2".equals(sendMethod)){
			return intelligentSMSSend(cardList, content, urlSms);
		}
		//邮件发送
		else if("3".equals(sendMethod)){
			return intelligentEmailSend(cardList, content, urlEmail);
		}
		return false;
	}

	/**
	 * 智能发送消息
	 * 1.优先微信发送
	 * 2.邮件发送
	 * 3.短信发送
	 * @param cardList  //发送队列
	 * @param content	//发送内容
	 * @param url 		//发送链接
	 * @param isSearchInfo  //是否需要查询用户信息 如果需要，根据partyId查询
	 * @param sendMethod //发送方式，0：智能发送，1：微信发送，2：短信发送，3：邮件发送
	 * @return true:发送成功， false：发送失败
	 */
	public boolean intelligentSendMessages(List<BusinessCard> cardList,String content, String url, boolean isSearchInfo, String sendMethod) throws Exception {
		if(null == cardList || cardList.size() == 0 || !StringUtils.isNotNullOrEmptyStr(content)){
			return false;
		}
		// 是否需要查询用户
		if (isSearchInfo) {
			List<String> partyIdList = new ArrayList<String>();
			for (int i = 0; i < cardList.size(); i++) {
				partyIdList.add(cardList.get(i).getPartyId());
			}
			BusinessCard bc = new BusinessCard();
			bc.setParty_rowid_in(partyIdList);
			cardList = getSqlSession().selectList("systemTaskSql.searchUserInfoByPartyIds",bc);
		}
		
		//智能发送
		if(!StringUtils.isNotNullOrEmptyStr(sendMethod) || "0".equals(sendMethod)){
			BusinessCard bc = null;
			List<BusinessCard> wxCardList = new ArrayList<BusinessCard>();
			List<BusinessCard> smsCardList = new ArrayList<BusinessCard>();
			for(int i=0;i<cardList.size();i++){
				bc = cardList.get(i);
				//
				if(StringUtils.isNotNullOrEmptyStr(bc.getPartyId()) && ZJWKUtil.is48HourInner(bc.getPartyId())){
					wxCardList.add(bc);
				}
				//如果partyId为空，则短信发送
				else{
					smsCardList.add(bc);
				}
			}
			
			intelligentWXSend(wxCardList, content, url);
			intelligentSMSSend(smsCardList, content, url);
			return true;
		}
		//微信发送
		else if("1".equals(sendMethod)){
			return intelligentWXSend(cardList, content, url);
		}
		//短信发送
		else if("2".equals(sendMethod)){
			return intelligentSMSSend(cardList, content, url);
		}
		//邮件发送
		else if("3".equals(sendMethod)){
			return intelligentEmailSend(cardList, content, url);
		}
		return false;
	}
	
	
	/**
	 * 短信发送
	 * @param cardList
	 * @param content
	 * @param url
	 * @return
	 */
	public boolean intelligentSMSSend(List<BusinessCard> cardList,String content,String url) throws Exception{
		BusinessCard bc = null;
		Map<String, Object> map1 = null;
		for(int i=0;i<cardList.size();i++){
			bc = cardList.get(i);
			if(!StringUtils.isNotNullOrEmptyStr(bc.getPhone())){
				continue;
			}
			/*map1 = new HashMap<String, Object>();
			map1.put("mobile", bc.getPhone());
			map1.put("code", "123456");
			if(StringUtils.isNotNullOrEmptyStr(url)){
				map1.put("content", content+"，点击查看详情"+PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+url));
			}else{
				map1.put("content", content);
			}
			HttpClient3Post.request(null, map1);
			*/
			String mycontent = null;
			if(StringUtils.isNotNullOrEmptyStr(url)){
				mycontent = content+"，点击查看详情"+PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+url);
			}else{
				mycontent = content;
			}

			ThreadRun thread = new SMSSentThread("123456", bc.getPhone(),mycontent);
			ThreadExecute.push(thread);

			
			return true;
		}
		return false;
	}

	/**
	 * 邮件发送 暂未处理
	 * @param cardList
	 * @param content
	 * @param url
	 * @return
	 */
	public boolean intelligentEmailSend(List<BusinessCard> cardList,String content,String url) throws Exception{
		
		return true;
	}
	
	/**
	 * 微信发送
	 * @param cardList
	 * @param content
	 * @param url
	 * @return
	 */
	public boolean intelligentWXSend(List<BusinessCard> cardList,String content,String url) throws Exception{
		BusinessCard bc = null;
		for(int i=0;i<cardList.size();i++){
			bc = cardList.get(i);
			if(!StringUtils.isNotNullOrEmptyStr(bc.getOpenId())){
				continue;
			}
			cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(bc.getOpenId(), content, url);
			return true;
		}
		
		return false;
	}
}
