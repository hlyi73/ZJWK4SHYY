package com.takshine.wxcrm.service.impl;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxMsgUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.base.util.cache.EhcacheUtil;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.UserFunc;
import com.takshine.wxcrm.message.oauth.AccessToken;
import com.takshine.wxcrm.message.resp.Article;
import com.takshine.wxcrm.service.MessagesService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.ScheduledScansService;
import com.takshine.wxcrm.service.UserFuncService;
import com.takshine.wxcrm.service.WxPushMsgService;
import com.takshine.wxcrm.service.WxRespMsgService;

/**
 * 响应消息的服务
 * @author liulin
 *
 */
@Service("wxRespMsgService")
public class WxRespMsgServiceImpl extends BaseServiceImpl implements WxRespMsgService {
	
	private static Logger logger = Logger.getLogger(WxRespMsgServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	

	/**
	 * 用户命令转换 返回对应的值
	 * @param fromUserName
	 * @param toUserName
	 * @param content
	 * @param option
	 * @return
	 */
	public String commandTransf(String fromUserName, String toUserName, String content, String option){
		
		if(!"def".equals(option)){
			/*OperatorMobile op = null;
			try {
				op = checkBinding(fromUserName, toUserName);
			} catch (Exception e) {
				log.error("commandTransf checkBinding " + e.getMessage());
			}*/
			/*if((op == null) 
					|| (null == op.getCrmId()) 
					|| "".equals(op.getCrmId()) ){
				return WxMsgUtil.bindAcctTip(fromUserName, toUserName);//账户未绑定的消息提示
			}else{
				//param
				String funParentId = "";
				String crmId = op.getCrmId();
				String funIdx = "";
				List<UserFunc> ufuncList = null;
				UserFunc ufc = null;
				
				Object sObj = WxCrmCacheUtil.get(fromUserName + "_funParentId");//从缓存中获取菜单访问该状态
			    funParentId = (sObj == null) ? "-1" : (String)sObj; 
			    
			    logger.info("crmId is frist = >" + crmId);
				logger.info("funIdx is frist = >" + funIdx);
				logger.info("funParentId frist  = >" + funParentId);
				String funModel = "";
				
				//查询主菜单   funParentId 为-1的所有菜单项
				if("M".equals(content) || "m".equals(content)){
					funIdx = null;
					funParentId = "-1";
					//清空缓存
					//WxCrmCacheUtil.put(fromUserName + "_funParentId", "-1");
				}
				//z 返回上一级菜单
				else if("Z".equals(content) || "z".equals(content)){
					Object highLevlObj = WxCrmCacheUtil.get(fromUserName + "_funHighLevelId");//上一级菜单
					String highLevl = (highLevlObj == null) ? "-1" : (String)highLevlObj;
					funParentId = highLevl;
					logger.info("highLevlObj funParentId is = >" + funParentId);
					//赋值
					//WxCrmCacheUtil.put(fromUserName + "_funParentId", highLevl);
				}else{
					funIdx = content;
					ufc = getMenuKey(fromUserName, crmId, funIdx, funParentId);//获取主键作为下一级查询的 func_parent_id
					funParentId = ufc.getFunId();//获取父func_parent_id
					funModel = ufc.getFunModel();//func model模块
				}
				
				logger.info("crmId is after= >" + crmId);
				logger.info("funIdx is after= >" + (null == funIdx ? "" : funIdx));
				logger.info("funParentId after is = >" + funParentId);
				if(null != ufc){
					logger.info("funId after is = >" + ufc.getFunId());
				}
				ufuncList = userFuncService.getUserFuncListByPara(crmId, null, funParentId);
				if(ufuncList.size() > 0){
					if(null != funModel && !"".equals(funModel)){
						//图文输出
						if(Constants.MODEL_TYPE_TASK.equals(funModel)){//任务
							return  respSchedualMenu(fromUserName, toUserName);
						}else if(Constants.MODEL_TYPE_EXPENSE.equals(funModel)){//费用
							return  respExpenseMenu(fromUserName, toUserName);
						}else if(Constants.MODEL_TYPE_ACCNT.equals(funModel)){//客户
							return respCustomerMenu(fromUserName, toUserName);
						}else if(Constants.MODEL_TYPE_CONTRACT.equals(funModel)){//合同
							return respContractMenu(fromUserName, toUserName);
						}else if(Constants.MODEL_TYPE_OPPTY.equals(funModel)){//业务机会
							return respOpptyMenu(fromUserName, toUserName);
						}
					}else{
						//文本输出
						content = generateMenu(fromUserName, toUserName, ufuncList);
					}
				}else{
					//所选菜单项 下无子菜单 则自动返回 到该菜单的上一级菜单
					//WxCrmCacheUtil.put(fromUserName + "_funParentId", ufc.getFunParentId());
					//content = "您需要办理什么业务?\n\n 回复 'M' 号回到主菜单. ";//
				}
			}*/
			if("M".equals(content) || "m".equals(content)){
				log.info("m 菜单 rebuild = >");
				String surl = "/login/" + fromUserName;
				content = "<a href='"+ PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content") + surl) +"'>点击链接进入指尖威客</a>";
				log.info("content = >" + content);
			}
			//日程
			else if("R".equals(content) || "r".equals(content)){
				log.info("---WxRespMsgServiceImpl --- R  in ---");
				List<Article> airtList = cRMService.getWxService().getWxPushMsgService().searchUnFinishTask(fromUserName);
				return WxMsgUtil.mulityMapTextMsg(fromUserName,toUserName,airtList);
			}
			//未读通知
			else if("T".equals(content) || "t".equals(content)){
				log.info("---WxRespMsgServiceImpl --- T  in ---");
			 	List<Article> airtList = cRMService.getWxService().getWxPushMsgService().searchUnReadMessages(fromUserName);
				return WxMsgUtil.mulityMapTextMsg(fromUserName,toUserName,airtList);
			}
			//评价
			else if("P".equals(content) || "p".equals(content)){
				log.info("---WxRespMsgServiceImpl --- P  in ---");
				List<Article> airtList = cRMService.getWxService().getWxPushMsgService().searchWorkPlanEval(fromUserName);
				return WxMsgUtil.mulityMapTextMsg(fromUserName,toUserName,airtList);
			}
			//关注的活动
			else if("H".equals(content) || "h".equals(content)){
				log.info("---WxRespMsgServiceImpl --- H  in ---");
				List<Article> airtList = cRMService.getWxService().getWxPushMsgService().searchNoticeActivity(fromUserName);
				return WxMsgUtil.mulityMapTextMsg(fromUserName,toUserName,airtList);
			}
			//早报
			else if("MP".equals(content) || "mp".equals(content) || "mP".equals(content) || "Mp".equals(content) || content.indexOf("每日早报") != -1 || content.indexOf("早报") != -1 || content.indexOf("日报") != -1){
				cRMService.getWxService().getScheduledScansService().processMessagesByWxMenuKey(fromUserName);
			}
		}
		//回复
		return WxMsgUtil.textMsg(fromUserName, toUserName, content);
	}
	
	/**
	 * 获取缓存的值
	 * @param crmId
	 * @param funIdx
	 * @param funParentId
	 * @return
	 */
	private UserFunc getMenuKey(String openId, String crmId, String funIdx, String funParentId){
		UserFunc ufc = new UserFunc();
		//获取一级菜单
		List<UserFunc> ufuncList = cRMService.getDbService().getUserFuncService().getUserFuncListByPara(crmId, funIdx, funParentId);
		logger.info("ufuncList =>" + ufuncList.size());
		if(ufuncList.size() >0 ){
			ufc = (UserFunc)ufuncList.get(0);
			EhcacheUtil.put(openId + "_funHighLevelId", funParentId); //上一级菜单
			EhcacheUtil.put(openId + "_funParentId", ufc.getFunId()); //把主键存入到缓存中 获取主键作为下一级查询的 func_parent_id
		}
		return ufc;
	}
	
	/** 
	 * 动态生成菜单数据 
	 *  
	 * @return 
	 */  
	public String generateMenu(String openId, String publicId, List<UserFunc> uFList) {  
	    StringBuffer buffer = new StringBuffer();  
	    buffer.append("您好, 很高兴为您服务！请选择相关业务类型: ").append("\n\n");
	    for (int i = 0; i < uFList.size(); i++) {
	    	UserFunc uf = (UserFunc)uFList.get(i);
	    	logger.info("generateMenu funIdx: = > " + uf.getFunIdx());
	    	//funIDx 标识
	    	if(uf.getFunIdx() != null){
	    		buffer.append("【").append(uf.getFunIdx()).append("】 ");
	    	}
	    	//uri
	    	String url = uf.getFunUri();
	    	logger.info("generateMenu url frst: = > " + url);
	    	if(null != url && !"".equals(url)){
	    		//追加前缀
	    		url = PropertiesUtil.getAppContext("app.content") + "/" + url;
	    		//追加 openId  和  publicId
	    		Pattern pUrl = Pattern.compile("/.*\\?.*+");
	    		Matcher pUrlCont = pUrl.matcher(url);
	    		logger.info("generateMenu url Pattern: = > " + pUrlCont.find());
	    		if(pUrlCont.find()) url += "&";
	    		else url += "?";
	    		//url 上追加 openId 和 publicId
	    		url += "openId=" + openId + "&publicId=" + publicId;
	    		buffer.append("<a href=\"").append(url).append("\">");
	    		buffer.append(uf.getFunName()).append("</a>").append("\n\n\n");
	    		
	    		logger.info("generateMenu url after: = > " + url);
	    	}else{
	    		buffer.append(uf.getFunName()).append("\n");
	    	}
		}
	    buffer.append("\n").append(" 回复 'M' 号回到主菜单. ");
	    buffer.append("\n").append(" 回复 'Z' 号回到上一级菜单. ");
	    logger.info("generateMenu mesg : = > " + buffer.toString());
	    return buffer.toString();  
	}
	
	/**
	 * 响应费用菜单选项
	 * @param fromUserName 发送方帐号（open_id）
	 * @param toUserName 公众号原始ID
	 * @return
	 */
	public String respExpenseMenu(String fromUserName, String toUserName) throws Exception{
		String respMessage = "";
        //判断是否绑定
		String crmId = getCrmId(fromUserName, toUserName);
		if(!"".equals(crmId)){
			//查询客户列表
			List<Article> custlist = cRMService.getWxService().getWxPushMsgService().searchExpenseAndTransfMsg(fromUserName, toUserName, crmId);
			logger.info("custlist size:-> is =" + custlist.size());
			respMessage = WxMsgUtil.mulityMapTextMsg(fromUserName, toUserName, custlist);
		}else{
		    respMessage = WxMsgUtil.bindAcctTip(fromUserName, toUserName);//账户未绑定的消息提示
		}
		return respMessage;
	}
	
	/**
	 * 响应联系人菜单选项
	 * @param fromUserName 发送方原始账号(openId)
	 * @param toUserName 公众号原始ID(publicId)
	 * @return
	 */
	public String respContactMenu(String fromUserName,String toUserName){
		String respMessage = "";
		//判断是否绑定
		String crmId = getCrmId(fromUserName, toUserName);
		if(!"".equals(crmId)){
			List<Article> gathList = cRMService.getWxService().getWxPushMsgService().searchContactAndTransfMsg(fromUserName, toUserName, crmId);
			logger.info("gathList size:-> is =" + gathList.size());
			respMessage = WxMsgUtil.mulityMapTextMsg(fromUserName, toUserName, gathList);
		}else{
			//账户未绑定的消息提示
			respMessage = WxMsgUtil.bindAcctTip(fromUserName, toUserName);
		}
		return respMessage;
	}
	
	/**
	 * 响应合同管理菜单选项
	 * @param fromUserName 发送方原始账号(openId)
	 * @param toUserName 公众号原始ID(publicId)
	 * @return
	 */
	public String respContractMenu(String fromUserName,String toUserName){
		String respMessage = "";
		//判断是否绑定
		String crmId = getCrmId(fromUserName, toUserName);
		if(!"".equals(crmId)){
			List<Article> conlist = cRMService.getWxService().getWxPushMsgService().searchContractAndTransfMsg(fromUserName, toUserName, crmId);
			logger.info("conlist size:-> is =" + conlist.size());
			respMessage = WxMsgUtil.mulityMapTextMsg(fromUserName, toUserName, conlist);
		}else{
			//账户未绑定的消息提示
			respMessage = WxMsgUtil.bindAcctTip(fromUserName, toUserName);
		}
		return respMessage;
	}
	
	/**
	 * 响应日程菜单选项
	 * @param fromUserName 发送方帐号（open_id）
	 * @param toUserName 公众号原始ID
	 * @return
	 */
	public String respSchedualMenu(String fromUserName, String toUserName){
		String respMessage = "";
        //判断是否绑定
		String crmId = getCrmId(fromUserName, toUserName);
		if(!"".equals(crmId)){
			//将日程列表转换为文章列表
			List<Article> artlist = cRMService.getWxService().getWxPushMsgService().searchTaskAndTransfMsg(fromUserName, toUserName, crmId);
			logger.info("artlist:-> is =" + artlist.size());
			respMessage = WxMsgUtil.mulityMapTextMsg(fromUserName, toUserName, artlist);
		}else{
		    respMessage = WxMsgUtil.bindAcctTip(fromUserName, toUserName);//账户未绑定的消息提示
		}
		return respMessage;
	}
	
	/**
	 * 活动流菜单选项
	 * @param fromUserName 发送方帐号（open_id）
	 * @param toUserName 公众号原始ID
	 * @return
	 */
	public String respFeedMenu(String fromUserName, String toUserName){
		String respMessage = "";
        //判断是否绑定
		String crmId = getCrmId(fromUserName, toUserName);
		if(!"".equals(crmId)){
			//将日程列表转换为文章列表
			List<Article> artlist = cRMService.getWxService().getWxPushMsgService().searchFeedAndTransfMsg(fromUserName, toUserName, crmId);
			logger.info("artlist:-> is =" + artlist.size());
			respMessage = WxMsgUtil.mulityMapTextMsg(fromUserName, toUserName, artlist);
		}else{
		    respMessage = WxMsgUtil.bindAcctTip(fromUserName, toUserName);//账户未绑定的消息提示
		}
		return respMessage;
	}
	
	/**
	 * 响应客户菜单选项
	 * @param fromUserName 发送方帐号（open_id）
	 * @param toUserName 公众号原始ID
	 * @return
	 */
	public String respCustomerMenu(String fromUserName, String toUserName){
		String respMessage = "";
        //判断是否绑定
		String crmId = getCrmId(fromUserName, toUserName);
		if(!"".equals(crmId)){
			//查询客户列表
			List<Article> custlist = cRMService.getWxService().getWxPushMsgService().searchCustAndTransfMsg(fromUserName, toUserName, crmId);
			logger.info("custlist size:-> is =" + custlist.size());
			respMessage = WxMsgUtil.mulityMapTextMsg(fromUserName, toUserName, custlist);
		}else{
		    respMessage = WxMsgUtil.bindAcctTip(fromUserName, toUserName);//账户未绑定的消息提示
		}
		return respMessage;
	}
	
	/**
	 * 响应业务机会菜单选项
	 * @param fromUserName 发送方帐号（open_id）
	 * @param toUserName 公众号原始ID
	 * @return
	 */
	public String respOpptyMenu(String fromUserName, String toUserName){
		String respMessage = "";
        //判断是否绑定
		String crmId = getCrmId(fromUserName, toUserName);
		if(!"".equals(crmId)){
			//查询客户列表
			List<Article> opptlist = cRMService.getWxService().getWxPushMsgService().searchOpptyAndTransfMsg(fromUserName, toUserName, crmId);
			logger.info("opptlist size:-> is =" + opptlist.size());
			respMessage = WxMsgUtil.mulityMapTextMsg(fromUserName, toUserName, opptlist);
		}else{
		    respMessage = WxMsgUtil.bindAcctTip(fromUserName, toUserName);//账户未绑定的消息提示
		}
		return respMessage;
	}
	
	
	/**
	 * 响应业务机会菜单选项
	 * @param fromUserName 发送方帐号（open_id）
	 * @param toUserName 公众号原始ID
	 * @return
	 */
	public String respBindingMenu(String fromUserName, String toUserName){
		String respMessage = "";
        //判断是否绑定
		String crmId = getCrmId(fromUserName, toUserName);
		if(!"".equals(crmId)){
			
			respMessage = WxMsgUtil.textMsg(fromUserName, toUserName, "亲，您已经绑定了账号，赶紧去体验吧！");
		}else{
		    respMessage = WxMsgUtil.bindAcctTip(fromUserName, toUserName);//账户未绑定的消息提示
		}
		return respMessage;
	}
	
	/**
	 * 
	 * @param fromUserName
	 * @param toUserName
	 * @return
	 */
	public String respCancelBindingMenu(String fromUserName, String toUserName){
		String respMessage = "";
        //判断是否绑定
		String crmId = getCrmId(fromUserName, toUserName);
		if(!"".equals(crmId)){
			if(cancelBinding(fromUserName, toUserName,"")){
				respMessage = WxMsgUtil.textMsg(fromUserName, toUserName, "您已经取消了绑定!");
			}else{
				respMessage = WxMsgUtil.textMsg(fromUserName, toUserName, "取消绑定账户操作失败，请联系管理员！");
			}
		}else{
			respMessage = WxMsgUtil.bindAcctTip(fromUserName, toUserName);//账户未绑定的消息提示
		}
		return respMessage;
	}
	
	/**
	 * 响应 微信订阅历史图文菜单
	 * @param fromUserName
	 * @param toUserName
	 * @return
	 */
	public String respWxSubscribeHisMenu(String fromUserName, String toUserName, boolean rstflag){
		List<Article> wxSubHis = new ArrayList<Article>();
		//if(!rstflag){
		    wxSubHis =  cRMService.getWxService().getWxPushMsgService().searchWxSubscribeHisMsg(fromUserName, "", "");
		//}else{
		//	wxSubHis =  cRMService.getWxService().getWxPushMsgService().searchWxSubscribeHisMsgAgain(fromUserName, "", "");
		//}
		logger.info("wxSubscribeHis size:-> is =" + wxSubHis.size());
		return WxMsgUtil.mulityMapTextMsg(fromUserName, toUserName, wxSubHis);
	}
	
	/**
	 * 帮助
	 * @param fromUserName
	 * @param toUserName
	 * @return
	 */
	public String respHelpMenu(String fromUserName, String toUserName){
		String respMessage = "";
        //判断是否绑定
		String crmId = getCrmId(fromUserName, toUserName);
		if(!"".equals(crmId)){
			//查询客户列表
//			List<Article> opptlist = cRMService.getWxService().getWxPushMsgService().help(fromUserName, toUserName, crmId);
//			respMessage = WxMsgUtil.mulityMapTextMsg(fromUserName, toUserName, opptlist);
			
		}else{
		    respMessage = WxMsgUtil.bindAcctTip(fromUserName, toUserName);//账户未绑定的消息提示
		}
		return respMessage;
	}
	
	/**
	 * 响应 报销 的  客服消息
	 * @return
	 */
	public void respExpCustMsg(String crmId, String rowId, String type, String orgId){
		String temp = "有一笔报销 提交给您审批";
		if("reject".equals(type)){
			temp = "您有一笔报销被驳回";
		}
		// 调用接口获取access_token
		AccessToken at = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
		log.info("access_token =>" + at.getToken());
		log.info("expires_in =>" + at.getExpiresIn());
		
		log.info("WxRespMsgServiceImpl rsspCustMsg begin crmId =>" + crmId );
		OperatorMobile obj  = new OperatorMobile();
		obj.setCrmId(crmId);
		 List<OperatorMobile> list = cRMService.getDbService().getOperatorMobileService().getOperMobileListByPara(obj);
		 log.info("WxRespMsgServiceImpl rsspCustMsg list size =>" + list.size() );
		 //遍历 size 集合 
		 for (int i = 0; i < list.size(); i++) {
			 OperatorMobile op = (OperatorMobile)list.get(i);
			 String openId = op.getOpenId(); 
			 log.info("openId =>" + openId);
			 //发送信息
			 String custMsgUrl = PropertiesUtil.getAppContext("app.content") +"/expense/detail?rowId="+ rowId +"&openId="+ op.getOpenId()+ "&publicId="+ op.getPublicId() + "&orgId=" +orgId;
			 String ct = temp + ", <a href='"+ custMsgUrl +"'>点击查看详情</a>";
			 logger.info("ct =>" + ct);
			 log.info("respCommCustMsg begin at  =>" + System.currentTimeMillis());
			 WxUtil.customMsgSend(at.getToken(), openId, ct);
			 log.info("respCommCustMsg success at  =>" + System.currentTimeMillis());
			 log.info("content =>" + ct);
		}
	}
	
	/**
	 * 响应 通用的  客服消息
	 * @return
	 */
	public void respCommCustMsgByCrmId(String crmId, String content, String detailUri){
		if(null == crmId || "".equals(crmId)){
			return;
		}
		log.info("WxRespMsgServiceImpl respCommCustMsgByCrmId begin crmId =>" + crmId );
		log.info("WxRespMsgServiceImpl respCommCustMsgByCrmId begin content =>" + content );
		log.info("WxRespMsgServiceImpl respCommCustMsgByCrmId begin detailUri =>" + detailUri );
		
		AccessToken at = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
		log.info("access_token =>" + at.getToken());//访问令牌
		log.info("expires_in =>" + at.getExpiresIn());
		
		//查询 crmId 关联的openId
		OperatorMobile obj  = new OperatorMobile();
		obj.setCrmId(crmId);
		List<OperatorMobile> list = cRMService.getDbService().getOperatorMobileService().getOperMobileListByPara(obj);
		log.info("WxRespMsgServiceImpl respCommCustMsgByCrmId list size =>" + list.size() );
		//遍历 size 集合 
		for (int i = 0; i < list.size(); i++) {
			OperatorMobile op = (OperatorMobile)list.get(i);
			String openId = op.getOpenId(); 
			log.info("openId =>" + openId);
			//追加的后缀参数
			String tpUrl = "crmid="+crmId; 
			//拼接发送的内容信息
			String ct = "";//整体的文本内容
			String custMsgUrl = "";//链接内容
			if(null != detailUri && !"".equals(detailUri)){
				custMsgUrl = detailUri;
				if(custMsgUrl.indexOf("?") != -1){
					custMsgUrl += "&" + tpUrl;
				}else{
					custMsgUrl += "?" + tpUrl;
				}
				logger.info("custMsgUrl =>" + PropertiesUtil.getAppContext("app.content") + transfMsgUrl(custMsgUrl));
			}
			if(!"".equals(custMsgUrl)){
				if(custMsgUrl.contains("zjactivity")){
					custMsgUrl = custMsgUrl.replace("zjactivity", "activity");
					ct = content + "  <a href='"+  PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("zjmarketing.url") + custMsgUrl) +"'>查看详情</a>";
				}else{
					ct = content + "  <a href='"+ PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content") + transfMsgUrl(custMsgUrl)) +"'>查看详情</a>";
				}
			}else{
				ct = content ;
			}
			
			//发送信息
			logger.info("ct =>" + ct);
			WxUtil.customMsgSend(at.getToken(), openId, ct);
			log.info("respCommCustMsgByCrmId success at  =>" + System.currentTimeMillis());
		}
	}
	
	/**
	 * 微信推送消息
	 * @param crmId
	 * @param content
	 * @param detailUri
	 */
	public void respSimpCustMsgByOpenId(String openId, String content, String detailUri){
		AccessToken at = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
		String ct = content;
		if(StringUtils.isNotNullOrEmptyStr(detailUri)){
			ct += "  <a href='"+ PropertiesUtil.getAppContext("app.content") + transfMsgUrl(detailUri) +"'>查看详情</a>";
		}
		boolean flag = getUrlSource(openId,detailUri);
		if(!flag){
			WxUtil.customMsgSend(at.getToken(), openId, ct);
		}
	}
	
	/**
	 * 判断当前url的来源
	 * @param url
	 */
	public boolean getUrlSource(String openId,String url){
		boolean flag = false;
		//来源于交换名片||来源于任务
		if(StringUtils.isNotNullOrEmptyStr(url)){
			if(url.contains("sendMsgFlag")||url.contains("schetype")){
				Map<String, String> map = RedisCacheUtil.getStringMapAll(Constants.LOGINTIME_KEY + "_" + openId);
				if(null!=map&&map.keySet().size()>0){
					String loginTime = map.get("loginTime");
					if(StringUtils.isNotNullOrEmptyStr(loginTime)&&DateTime.comDate(loginTime, PropertiesUtil.getMailContext("mail.differtime"), DateTime.DateTimeFormat1)){
						Map<String, String> map1 = RedisCacheUtil.getStringMapAll(Constants.ZJWK_NOTICE_SEND);
						String cardSize = "";
						String taskSize = "";
						if(null!=map1&&map1.keySet().size()>0){
							String str = map1.get(openId);
							if(StringUtils.isNotNullOrEmptyStr(str)&&str.contains(";")){
								cardSize= str.split(";")[0];
								taskSize = str.split(";")[1];
								if(url.contains("sendMsgFlag")){
									cardSize = Integer.parseInt(cardSize)+1+"";
								}else if(url.contains("schetype")){
									taskSize = Integer.parseInt(taskSize)+1+"";
								}
							}else{
								cardSize = 1+"";
								taskSize = 1+"";
							}
						}
						map1.put(openId, cardSize+";"+taskSize);
						RedisCacheUtil.putStringToMap(Constants.ZJWK_NOTICE_SEND, map1);
						flag = true;
					}
				}
			}
		}
		return flag;
	}
	
	/**
	 * 消息路径转换
	 * @param url
	 * @return
	 */
	private String transfMsgUrl(String url){
		try {
			log.info("url = >" + url);
			String msgUrl = "/msgentr/access?redirectUrl=" + URLEncoder.encode(url, "utf-8");
			log.info("msgUrl = >" + msgUrl);
			return msgUrl;
		} catch (UnsupportedEncodingException e) {
			log.info("error msg = >" + e.getMessage());
		}
		return "";
	}
	
	/**
	 * 响应 通用的  客服消息
	 * @return
	 */
	public void respCommCustMsgByOpenId(String receiveopenId, String openId, 
			                                 String publicId, String content, String detailUri){
		if(null == receiveopenId || "".equals(receiveopenId)){
			return;
		}
		log.info("WxRespMsgServiceImpl respCommCustMsgByOpenId begin receiveopenId =>" + receiveopenId );
		log.info("WxRespMsgServiceImpl respCommCustMsgByOpenId begin openId =>" + openId );
		log.info("WxRespMsgServiceImpl respCommCustMsgByOpenId begin publicId =>" + publicId );
		log.info("WxRespMsgServiceImpl respCommCustMsgByOpenId begin content =>" + content );
		log.info("WxRespMsgServiceImpl respCommCustMsgByOpenId begin detailUri =>" + detailUri );
		
		AccessToken at = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
		log.info("access_token =>" + at.getToken());//访问令牌
		log.info("expires_in =>" + at.getExpiresIn());

		//追加的后缀参数
		String tpUrl = "";//"openId="+ receiveopenId + "&publicId="+ publicId+"&openid="+ receiveopenId + "&publicid="+ publicId;
		//拼接发送的内容信息
		String ct = "";//整体的文本内容
		String custMsgUrl = "";//链接内容
		if(null != detailUri && !"".equals(detailUri)){
			custMsgUrl = detailUri;
			if(custMsgUrl.indexOf("?") != -1){
				custMsgUrl += "&" + tpUrl;
			}else{
				custMsgUrl += "?" + tpUrl;
			}
			logger.info("custMsgUrl =>" + PropertiesUtil.getAppContext("app.content") + transfMsgUrl(custMsgUrl));
		}
		if(!"".equals(custMsgUrl)){
			if(custMsgUrl.contains("zjactivity")){
				custMsgUrl = custMsgUrl.replace("zjactivity", "activity");
				ct = content + "  <a href='"+ PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("zjmarketing.url") + custMsgUrl) +"'>查看详情</a>";
			}else{
				ct = content + "  <a href='"+ PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content") + transfMsgUrl(custMsgUrl)) +"'>查看详情</a>";
			}
		}else{
			ct = content ;
		}
		//发送信息
		logger.info("ct =>" + ct);
		boolean flag = getUrlSource(openId,detailUri);
		if(!flag){
			WxUtil.customMsgSend(at.getToken(), receiveopenId, ct);
		}
		log.info("respCommCustMsgByCrmId success at  =>" + System.currentTimeMillis());
		
	}
	
	/**
	 * 每日早报
	 * @return
	 */
	public void respReportByOpenId(String receiveopenId,String content){
		if(null == receiveopenId || "".equals(receiveopenId)){
			return;
		}
		log.info("WxRespMsgServiceImpl respCommCustMsgByOpenId begin receiveopenId =>" + receiveopenId );
		log.info("WxRespMsgServiceImpl respCommCustMsgByOpenId begin content =>" + content );
		
		AccessToken at = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
		log.info("access_token =>" + at.getToken());//访问令牌
		log.info("expires_in =>" + at.getExpiresIn());

		WxUtil.customMsgSend(at.getToken(), receiveopenId, content);
		log.info("respReportByOpenId success at  =>" + System.currentTimeMillis());
	}
	
	/**
	 * 响应客服消息(针对简报)
	 * @return
	 */
	public void respCommCustMsgByCrmId(String crmId, String[] strs,OperatorMobileService operatorMobileService){
		log.info("WxRespMsgServiceImpl respCommCustMsgByCrmId begin crmId =>" + crmId );
		log.info("WxRespMsgServiceImpl respCommCustMsgByCrmId begin strs =>" + strs );
		// 调用接口获取access_token
		AccessToken at = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
		log.info("access_token =>" + at.getToken());//访问令牌
		log.info("expires_in =>" + at.getExpiresIn());
		//查询 crmId 关联的openId
		OperatorMobile obj  = new OperatorMobile();
		obj.setCrmId(crmId);
		List<OperatorMobile> list = operatorMobileService.getOperMobileListByPara(obj);
		log.info("WxRespMsgServiceImpl respCommCustMsgByCrmId list size =>" + list.size() );
		//遍历 size 集合 
		for (int i = 0; i < list.size(); i++) {
			OperatorMobile op = (OperatorMobile)list.get(i);
			String openId = op.getOpenId();
			String publicId = op.getPublicId();
			log.info("openId =>" + openId);
			//追加的后缀参数
			String tpUrl = "openId="+ op.getOpenId()+ "&publicId="+publicId;
			//拼接发送的内容信息
			String ct = "";//整体的文本内容
			String custMsgUrl = "";//链接内容
			if(null != strs && strs.length>0){
				for(String str:strs){
					String content = str.split("___")[0];
					String detailUri = str.split("___")[1];
					custMsgUrl =  detailUri;
					if(custMsgUrl.indexOf("?") != -1){
						custMsgUrl += "&" + tpUrl;
					}else{
						custMsgUrl += "?" + tpUrl;
					}
					logger.info("custMsgUrl =>" + PropertiesUtil.getAppContext("app.content") + transfMsgUrl(custMsgUrl));
					ct += content + "<a href='"+ custMsgUrl +"'>点击查看详情</a>\n";
				}
			}
			//发送信息
			logger.info("ct =>" + ct);
			boolean flag = getUrlSource(openId,custMsgUrl);
			if(!flag){
				WxUtil.customMsgSend(at.getToken(), openId, ct);
			}
			log.info("respCommCustMsgByCrmId success at  =>" + System.currentTimeMillis());
		}
	}
}
