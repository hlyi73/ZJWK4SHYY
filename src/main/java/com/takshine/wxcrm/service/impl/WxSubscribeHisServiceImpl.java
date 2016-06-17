package com.takshine.wxcrm.service.impl;

import java.io.UnsupportedEncodingException;
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
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.HttpClient3Post;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.base.util.runtime.SMSSentThread;
import com.takshine.wxcrm.base.util.runtime.ThreadExecute;
import com.takshine.wxcrm.base.util.runtime.ThreadRun;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxSubscribeHis;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.domain.cache.CacheSchedule;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.CacheScheduleService;
import com.takshine.wxcrm.service.UserRelaService;
import com.takshine.wxcrm.service.WxSubscribeHisService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 微信订阅服务
 *
 */
@Service("wxSubscribeHisService")
public class WxSubscribeHisServiceImpl extends BaseServiceImpl implements WxSubscribeHisService{
	
	private static Logger log = Logger.getLogger(WxSubscribeHisServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	@Override
	protected String getDomainName() {
		return "WxSubscribeHis";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "wxSubscribeHisSql.";
	}
	
	public BaseModel initObj() {
		return new WxSubscribeHis();
	}
	
	/**
	 * 添加微信订阅记录 
	 */
	public void addWxSubscribeHis(String openid, String subtype){
		String nickname = "";
		WxuserInfo wxinfo = new WxuserInfo();
		wxinfo.setOpenId(openid);
		Object wxinfobj = cRMService.getWxService().getWxUserinfoService().findObj(wxinfo);
		if(wxinfobj != null){
			wxinfo = (WxuserInfo)wxinfobj;
			nickname = wxinfo.getNickname();
		}
		log.info("nickname = >" + nickname);
		try {
			WxSubscribeHis wx = new WxSubscribeHis();
			wx.setId(Get32Primarykey.getRandom32PK());
			wx.setOpen_id(openid);
			wx.setNick_name(nickname);
			wx.setSub_type(subtype);
			addObj(wx);
		} catch (Exception e) {
			log.info("addWxSubscribeHis = >" + e.getMessage());
		}
	}
	
	/**
	 * 查询微信订阅记录
	 */
	public boolean searchWxSubHisExits(String openid){
		WxSubscribeHis wx = new WxSubscribeHis();
		wx.setOpen_id(openid);
		Object wxobj = findObj(wx);
		if(wxobj != null){
			return true;
		}
		return false;
	}
	
	/**
	 * 取消关注的时候  发送手机短信 
	 */
	public void cannelSubSendPhoneMsg(String openId){
		WxuserInfo wx = new WxuserInfo();
		wx.setOpenId(openId);
		Object wxobj = cRMService.getWxService().getWxUserinfoService().findObj(wx);
		if(wxobj != null){
			wx = (WxuserInfo)wxobj;
		}
		String partyId = wx.getParty_row_id();
		log.info("cannelSubSendPhoneMsg = >");
		log.info("openId = >" + openId);
		log.info("partyId = >" + partyId);
		
		String mobile = "";
		BusinessCard bc = new BusinessCard();
		bc.setPartyId(partyId);
		Object bcobj = cRMService.getDbService().getBusinessCardService().findObj(bc);
		if(bcobj != null){
			bc = (BusinessCard)bcobj;
			mobile = bc.getPhone();
		}
		
		log.info("mobile search= >" + mobile);
		
		//如果手机号码为空，直接返回
		if(!StringUtils.isNotNullOrEmptyStr(mobile)){
			return;
		}
		//如果名片中的姓名不为空，则用名片中的名字
		if(StringUtils.isNotNullOrEmptyStr(bc.getName())){
			wx.setNickname(bc.getName());
		}
		
		//添加了${zjfriendcount}个指尖好友
		UserRela ur = new UserRela();
		ur.setUser_id(partyId);
		ur.setCurrpages(Constants.ZERO);
		ur.setPagecounts(Constants.ALL_PAGECOUNT);
		List<UserRela> urlist = (List<UserRela>)cRMService.getDbService().getUserRelaService().findObjListByFilter(ur);
		log.info("urlist size = >" + urlist.size());
		
		//还有${schecount}个日程没有完成.
		List<String> crmIds = cRMService.getDbService().getCacheScheduleService().getCrmIdArr(openId, PropertiesUtil.getAppContext("app.publicId"),"");
		CacheSchedule casch = new CacheSchedule();
		casch.setCrm_id_in(crmIds);
		casch.setCurrpage(Constants.ZERO);
		casch.setPagecount(Constants.ALL_PAGECOUNT);
		List<CacheSchedule> caschlist = (List<CacheSchedule>) cRMService.getDbService().getCacheScheduleService().findObjListByFilter(casch);
		
		List<String> statusList = new ArrayList<String>();
		statusList.add("In Progress");
		statusList.add("Not Started");
		casch.setStatus_in(statusList);
		List<CacheSchedule> caschComplist = (List<CacheSchedule>) cRMService.getDbService().getCacheScheduleService().findObjListByFilter(casch);

		String psumryUrl = PropertiesUtil.getAppContext("app.content") + "/dcCrm/psumry?partyId="+wx.getParty_row_id();
		
		log.info("psumryUrl = >" + psumryUrl);
				
		psumryUrl = PropertiesUtil.getAppContext("zjwk.short.url") + "e?u="+ ZJWKUtil.shortUrl(psumryUrl);
		
		log.info("openid = >" + openId);
		//点击链接查看更多" + PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(psumryUrl);
		String content = "亲爱的" + wx.getNickname() + "，感谢您使用指尖微客。使用期间交往了" + urlist.size() + "个指尖好友，创建了"+ caschlist.size() +"个任务， 还有"+ caschComplist.size() +"个未完成。";
		content += "点击查看" + psumryUrl;
		
		log.info("content = >" + content);
		log.info("mobile = >" + mobile);
		/*Map<String, Object> map = new HashMap<String, Object>();
		map.put("mobile", mobile);
		map.put("content", content);
		map.put("code", "123456");
		try {
			HttpClient3Post.request("", map);
		} catch (Exception e) {
			log.info("error msg = >" + e.getMessage());
		}*/
		ThreadRun thread = new SMSSentThread("123456",mobile,content);
		ThreadExecute.push(thread);

	}
	
}
