package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxMsgUtil;
import com.takshine.wxcrm.domain.cache.CacheSchedule;
import com.takshine.wxcrm.service.CacheScheduleService;
import com.takshine.wxcrm.service.WxReplyService;
import com.takshine.wxcrm.service.WxRespMsgService;

/**
 * 微信信息处理服务类
 * 
 * @author Kater Yi
 * @date 2015-03-03
 */
@Service("wxReplyService")
public class WxReplyServiceImpl extends BaseServiceImpl implements WxReplyService{
	
	private static Logger logger = Logger.getLogger(WxReplyServiceImpl.class.getName());
	//发送消息
	@Autowired
	@Qualifier("wxRespMsgService")
	private WxRespMsgService wxRespMsgService;

	
	@Autowired
	@Qualifier("cacheScheduleService")
	private CacheScheduleService cacheScheduleService;
	


	/**
	 * 处理微信发来的请求
	 * 
	 * @param request
	 * @return
	 */
	public String processRequest(String request,HttpServletRequest httprequest) {
		String shortid = getShortId(request);
		if (shortid == null){
			
		}else{
			Map<String,String> messagemap = WxMsgUtil.getMessageIdAndType(shortid);
			String template = PropertiesUtil.getMsgContext("message.schedule.message");

			StringBuffer sendContent = new StringBuffer();
			for(String key: messagemap.keySet()){
				String val = messagemap.get(key);
				CacheSchedule cacheSchedule = cacheScheduleService.getCrmIdByRowId(key);
				template = template.replace("$$messageid",WxMsgUtil.getMessageShortId(key, val));
				//template = template.replace("$$creatername", UserUtil.getCurrUser(httprequest).getName());
				/*template = template.replace("$$task", obj.getTitle());
				template = template.replace("$$assigner", obj.getAssignerName());
				template = template.replace("$$team");
				template = template.replace("$$str_message", obj.getAssignerName());*/
				sendContent.append(template);
				//cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(cacheSchedule.,sendContent.toString(),"");// "schedule/detail?rowId="+obj.getRowid()+"&schetype="+obj.getSchetype()+"&orgId="+obj.getOrgId());
			}
			
		}
		return null;
	}
	
	/**
	 * 查找内容中类似于“#1234”的内容区域
	 * @param request
	 * @return
	 */
	public static final String getShortIdArea(String request){
		Pattern p = Pattern.compile("(#[0-9][0-9][0-9][0-9])");
		Matcher m = p.matcher(request);
		while(m.find()){
			String s = m.group();
			if (s==null || s.length() == 0) break;
			return s;
		}
		return null;
	}
	/**
	 * 内容中，取得毒短ID
	 * @param request
	 * @return
	 */
	public static final String getShortId(String request){
		String s = getShortIdArea(request);
		if (s==null) return null;
		return s.substring(1);
	}
	/**
	 * 取得消息内容
	 * @param request
	 * @return
	 */
	public static final String getMessage(String request){
		String retstr = request.replace(getShortIdArea(request), "");
		return retstr;
	}
}
