package com.takshine.wxcrm.service.impl;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.BaiduMapUtil;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxMsgUtil;
import com.takshine.wxcrm.domain.Resource;
import com.takshine.wxcrm.domain.UserLocation;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.service.Expense2CrmService;
import com.takshine.wxcrm.service.ResourceService;
import com.takshine.wxcrm.service.WxCoreService;
import com.takshine.wxcrm.service.WxPushMsgService;
import com.takshine.wxcrm.service.WxReplyService;
import com.takshine.wxcrm.service.WxRespMsgService;
import com.takshine.wxcrm.service.WxSubscribeHisService;
import com.takshine.wxcrm.service.WxUserLocationService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 核心服务类
 * 
 * @author liulin
 * @date 2014-02-26
 */
@Service("wxCoreService")
public class WxCoreServiceImpl extends BaseServiceImpl implements WxCoreService{
	
	private static Logger logger = Logger.getLogger(WxCoreServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 处理微信发来的请求
	 * 
	 * @param request
	 * @return
	 */
	public String processRequest(HttpServletRequest request) {
		String respMessage = null;
		try {
			// 默认返回的文本消息内容
			String respContent = "请求处理异常，请稍候尝试！";

			// xml请求解析
			Map<String, String> requestMap = WxMsgUtil.parseXml(request);

			// 验证参数
			String signature = requestMap.get("signature");
			String timestamp = requestMap.get("timestamp");
			String nonce = requestMap.get("nonce");
			// 发送方帐号（open_id）
			String fromUserName = requestMap.get("FromUserName");
			// 公众帐号  开发者微信号  原始ID 与appId不同
			//appid	 是	 第三方用户唯一凭证
			//secret	 是	 第三方用户唯一凭证密钥，即appsecret
			String toUserName = requestMap.get("ToUserName");
			// 消息创建的时间(整型的秒数)
			String createTime = requestMap.get("CreateTime");
			// 消息类型
			String msgType = requestMap.get("MsgType");
			// 文本消息内容   
			String content = requestMap.get("Content");
			// 消息ID, 64位整数
			String msgId = requestMap.get("MsgId");
			//菜单的key
			String eventKey = requestMap.get("EventKey");
			
			logger.info("coreGet begin:-> signature:=" + signature);
	    	logger.info("coreGet begin:-> timestamp:=" + timestamp);
	    	logger.info("coreGet begin:-> nonce:=" + nonce);
			logger.info("processRequest begin:->fromUserName=" + fromUserName);
			logger.info("processRequest begin:->toUserName=" + toUserName);
			logger.info("processRequest begin:->createTime=" + WxMsgUtil.formatTime(createTime));
			logger.info("processRequest begin:->msgType=" + msgType);
			logger.info("processRequest begin:->content=" + content);
			logger.info("processRequest begin:->msgId=" + msgId);

			// 文本消息
			if (msgType.equals(WxMsgUtil.REQ_MESSAGE_TYPE_TEXT)) {
				respMessage =  cRMService.getWxService().getWxRespMsgService().commandTransf(fromUserName, toUserName, content, "");
				//Modify by Kater Yi 2015/3/3
				//wxReplyService.processRequest(content,request);
			}
			// 图片消息
			else if (msgType.equals(WxMsgUtil.REQ_MESSAGE_TYPE_IMAGE)) {
				respContent = "您发送的是图片消息！";
				respMessage =  cRMService.getWxService().getWxRespMsgService().commandTransf(fromUserName, toUserName, respContent, "def");
			}
			// 地理位置消息
			else if (msgType.equals(WxMsgUtil.REQ_MESSAGE_TYPE_LOCATION)) {
				//用户发送的经纬度
				String lng = requestMap.get("Location_Y");
				String lat = requestMap.get("Location_X");
				logger.info("地理位置纬度 :-> is =" + lat);
				logger.info("地理位置经度 :-> is =" + lng);
				//坐标转换后的经纬度
				String bd09Lng = null;
				String bd09Lat = null;
				//调用接口转换坐标
				UserLocation userLocation =  BaiduMapUtil.convertCoord(lng, lat);
				if(null != userLocation){
					bd09Lng = userLocation.getBd09Lng();
					bd09Lat = userLocation.getBd09Lat();
				}
				//保存用户地理位置
				UserLocation ul = new UserLocation();
				ul.setId(Get32Primarykey.getRandom32BeginTimePK());
				ul.setOpenId(fromUserName);
				ul.setLng(lng);
				ul.setLat(lat);
				ul.setBd09Lng(bd09Lng);
				ul.setBd09Lat(bd09Lat);
				ul.setCreateTime(DateTime.currentDate());
				cRMService.getWxService().getWxUserLocationService().addObj(ul);
				
				StringBuffer buffer = new StringBuffer();
				buffer.append(" 成功接收您的位置! ").append("\n\n");
				buffer.append(" 您可以输入搜索关键词获得周边信息了，例如：").append("\n");
				buffer.append("       附近 ATM").append("\n");
				buffer.append("       附近 KTV").append("\n");
				buffer.append("       附近 厕所").append("\n");
				buffer.append(" 必须以 '附近' 两个字开头 ！ ");
				//返回消息
				respMessage =  cRMService.getWxService().getWxRespMsgService().commandTransf(fromUserName, toUserName, buffer.toString(), "def");
			}
			// 链接消息
			else if (msgType.equals(WxMsgUtil.REQ_MESSAGE_TYPE_LINK)) {
				//标题
				String title = requestMap.get("Title");
				//描述
				String desc = requestMap.get("Description");
				//url
				String url = requestMap.get("Url");
				log.info("title= >" + title);
				log.info("desc= >" + desc);
				log.info("url= >" + url);
				
				//转入指尖系统
				Resource res = new Resource();
				res.setResourceTitle(title);
				res.setResourceContent(desc);
				res.setResourceUrl(url);
				res.setResourceType(WxMsgUtil.REQ_MESSAGE_TYPE_LINK);
				
				String openId = fromUserName;
				WxuserInfo user = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(openId);
				
				if (null != user && StringUtils.isNotNullOrEmptyStr(user.getParty_row_id()))
				{
					res.setCreator(user.getParty_row_id());
				}
				else
				{
					throw new Exception("没有获取到当前登陆的用户信息");
				}
				int ret =cRMService.getDbService().getResourceService().addResource(res);
				
				if (ret == 1)
				{
					respContent = "您的文章已保存到指尖微客资料库中";
				}
				else if (ret == 2)
				{
					respContent = "您的文章已在指尖微客资料库中存在";
				}
				else
				{
					respContent = "文章保存失败";
				}
				
				respMessage =  cRMService.getWxService().getWxRespMsgService().commandTransf(fromUserName, toUserName, respContent, "def");
			}
			// 音频消息
			else if (msgType.equals(WxMsgUtil.REQ_MESSAGE_TYPE_VOICE)) {
				//语音消息媒体id，可以调用多媒体文件下载接口拉取该媒体
				String mediaID = requestMap.get("MediaID");
				//语音格式：amr
				String format = requestMap.get("Format");
				//语音识别结果
				String recognition = requestMap.get("Recognition");
				logger.info("mediaID:-> is =" + mediaID);
				logger.info("format:-> is =" + format);
				logger.info("recognition:-> is =" + recognition);
				
				if(!StringUtils.isNotNullOrEmptyStr(recognition)){
					respContent = "您发送的是音频消息！";
				}else{
					respContent = recognition;
				}
				respMessage =  cRMService.getWxService().getWxRespMsgService().commandTransf(fromUserName, toUserName, respContent, "");
				
				if(!StringUtils.isNotNullOrEmptyStr(respMessage)){
					respMessage = "您发送的是音频消息！";
					respMessage =  cRMService.getWxService().getWxRespMsgService().commandTransf(fromUserName, toUserName, respContent, "");
				}
			}
			// 事件推送
			else if (msgType.equals(WxMsgUtil.REQ_MESSAGE_TYPE_EVENT)) {
				// 事件类型
				String eventType = requestMap.get("Event");
				logger.info("eventKey:-> is =" + eventKey);
				// 订阅
				if (eventType.equals(WxMsgUtil.EVENT_TYPE_SUBSCRIBE)) {
					//调用接口同步 关注信息到我们的系统
					cRMService.getWxService().getWxUserinfoService().synchroUserData(fromUserName,null, "subscribe");
					//respMessage = "/:rose 感谢您关注指尖微客，小微在此恭候多时啦！/::)";
					//respMessage = "感谢您关注指尖微客！指尖微客可以帮助您管理社区，发起、分享活动，管理生意。点击底部菜单即开始使用系统。小薇期待您常来光顾。";
					//respMessage = WxMsgUtil.textMsg(fromUserName, toUserName, respMessage);
					boolean rstflag = cRMService.getWxService().getWxSubscribeHisService().searchWxSubHisExits(fromUserName);
					String subtype = "subscribe";
					if(rstflag) subtype = "subscribe_again";
					cRMService.getWxService().getWxSubscribeHisService().addWxSubscribeHis(fromUserName, subtype);
					log.info("rstflag = >" + rstflag);
					respMessage = cRMService.getWxService().getWxRespMsgService().respWxSubscribeHisMenu(fromUserName, toUserName, rstflag);
					//欢迎任务和创建名片任务
				}
				// 取消订阅
				else if (eventType.equals(WxMsgUtil.EVENT_TYPE_UNSUBSCRIBE)) {
					cRMService.getWxService().getWxSubscribeHisService().addWxSubscribeHis(fromUserName, "cannel_subscribe");
					//取消订阅后 发送短信消息给用户
					//cRMService.getWxService().getWxSubscribeHisService().cannelSubSendPhoneMsg(fromUserName);
					//取消关注时，暂不删除用户相关信息，如发现问题后再放开
					//cRMService.getWxService().getWxUserinfoService().deleteObjById(fromUserName);//删除微信用户信息
				}
				// 自定义菜单点击事件
				else if (eventType.equals(WxMsgUtil.EVENT_TYPE_CLICK)) {
					// 事件KEY值，与创建自定义菜单时指定的KEY值对应   
					if (eventKey.equals("11")) {  
					    
					} else if (eventKey.equals("12")) {//客户
						respMessage = cRMService.getWxService().getWxRespMsgService().respCustomerMenu(fromUserName, toUserName);
					} else if (eventKey.equals("13")) {//业务机会
					    respMessage = cRMService.getWxService().getWxRespMsgService().respOpptyMenu(fromUserName, toUserName);
					}
					else if (eventKey.equals("14")) {  //联系人
						respMessage = cRMService.getWxService().getWxRespMsgService().respContactMenu(fromUserName, toUserName);
					} 
					else if (eventKey.equals("15")) { //合同管理
						respMessage = cRMService.getWxService().getWxRespMsgService().respContractMenu(fromUserName, toUserName);
					}else if (eventKey.equals("21")) {  
					    respContent = "敬请期待！";  
					    respMessage =  cRMService.getWxService().getWxRespMsgService().commandTransf(fromUserName, toUserName, respContent, "def");
					} else if (eventKey.equals("22")) {//日程
						respMessage = cRMService.getWxService().getWxRespMsgService().respSchedualMenu(fromUserName, toUserName);
					} else if (eventKey.equals("23")) {//费用报销
						respMessage =  cRMService.getWxService().getWxRespMsgService().respExpenseMenu(fromUserName, toUserName);
					} else if(eventKey.equals("24")){//讨论圈
						respMessage = cRMService.getWxService().getWxRespMsgService().respFeedMenu(fromUserName, toUserName);
					} else if (eventKey.equals("31")) { //账户绑定
						respMessage = cRMService.getWxService().getWxRespMsgService().respBindingMenu(fromUserName, toUserName);
					} else if (eventKey.equals("32")) { //取消绑定
						respMessage = cRMService.getWxService().getWxRespMsgService().respCancelBindingMenu(fromUserName, toUserName);
					} else if (eventKey.equals("33")) {//帮助菜单
						respMessage = cRMService.getWxService().getWxRespMsgService().respHelpMenu(fromUserName, toUserName);
					}
					
				// 位置上报事件
				}else if(eventType.equals(WxMsgUtil.EVENT_TYPE_LOCATION)) {
					logger.info("地理位置纬度 :-> is =" + requestMap.get("Latitude"));
					logger.info("地理位置经度 :-> is =" + requestMap.get("Longitude"));
					logger.info("地理位置精度 :-> is =" + requestMap.get("Precision"));
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return respMessage;
	}
}
