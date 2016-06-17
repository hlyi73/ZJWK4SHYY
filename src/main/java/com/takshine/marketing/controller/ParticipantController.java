package com.takshine.marketing.controller;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.ActivityParticipant;
import com.takshine.marketing.domain.Participant;
import com.takshine.marketing.domain.SourceObject;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.HttpClient3Post;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.base.util.runtime.SMSSentThread;
import com.takshine.wxcrm.base.util.runtime.ThreadExecute;
import com.takshine.wxcrm.base.util.runtime.ThreadRun;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.message.oauth.AccessToken;
import com.takshine.wxcrm.message.userget.UserGet;

/**
 * 参与用户处理类
 */
@Controller
@RequestMapping("/participant")
public class ParticipantController {
	
	protected static Logger logger = Logger.getLogger(ParticipantController.class.getName());
	// 从sugar系统获取 LOV和 用户 的服务
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	

	/**
	 * 验证是否过期
	 * @param startKey
	 * @param endKey
	 * @return
	 */
	public boolean differ(String startKey,String endKey){
		int time  = Integer.parseInt(PropertiesUtil.getMsgContext("service.time"));
		//缓存code的开始时间
		String startTime = RedisCacheUtil.getString(startKey);
		String endTime = RedisCacheUtil.getString(endKey);
		if(StringUtils.isNotNullOrEmptyStr(startTime)&&StringUtils.isNotNullOrEmptyStr(endTime)){
			int differTime = Integer.parseInt(StringUtils.getMargin(endTime, startTime));
			if(differTime<=time){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	
	/**
	 * 报名
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/save")
	@ResponseBody
	public String add(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// openId publicId
		String rowid = request.getParameter("activityid");
		String opName=request.getParameter("opName");
		String opDuty=request.getParameter("opDuty");
		String opCompany=request.getParameter("opCompany");
		String opSignature=request.getParameter("opSignature");
		String opMobile=request.getParameter("opMobile");
		String sourceid=request.getParameter("sourceid");
		String source=request.getParameter("source");
		
		logger.info("----ParticipantController ---- add ---验证码");
		if("1".equals(PropertiesUtil.getMsgContext("service.open"))){
			String code = request.getParameter("code");
			String value = RedisCacheUtil.getString("Activity_Enlist_MessageCode_"+sourceid+rowid);
			if(StringUtils.isNotNullOrEmptyStr(value)&&value.contains(",")){
				String[] strs = value.split(",");
				for(String str : strs){
					if(code.equals(str)){
						if(!differ("Activity_Enlist_MessageCode_StartTime"+sourceid+rowid+"_"+code,"Activity_Enlist_MessageCode_EndTime"+sourceid+rowid+"_"+code)){
							return "errorCode";
						}	
					}
				}
			}else{
				if(!differ("Activity_Enlist_MessageCode_StartTime"+sourceid+rowid+"_"+code,"Activity_Enlist_MessageCode_EndTime"+sourceid+rowid+"_"+code)){
					return "errorCode";
				}
			}
		}
		
		logger.info("----ParticipantController ---- add ---验证名报参数");
		Map<String,String> map = new HashMap<String,String>();
//		if(sourceid==null){
//			return "-1";
//		}
		if(opName==null||"".equals(opName.trim())){
			return "-1";
		}
		if(opMobile==null||"".equals(opMobile.trim())){
			return "-1";
		}
		if(StringUtils.isNotNullOrEmptyStr(opName)&&!StringUtils.regZh(opName)){
			opName=new String(opName.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(opDuty)&&!StringUtils.regZh(opDuty)){
			opDuty=new String(opDuty.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(opCompany)&&!StringUtils.regZh(opCompany)){
			opCompany=new String(opCompany.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(opSignature)&&!StringUtils.regZh(opSignature)){
			opSignature=new String(opSignature.getBytes("ISO-8859-1"),"UTF-8");
		}
		logger.info("----ParticipantController ---- add ---获取活动信息");
		Activity ac = cRMService.getDbService().getActivityService().getActivitySingle(rowid);
		if(null == ac || "".equals(ac.getId())){
			return "-1";
		}
		ActivityParticipant apc= new ActivityParticipant();
		apc.setActivityid(rowid);
		if(!"meet".equals(ac.getType())){
			if(cRMService.getDbService().getActivityParticipantService().countObjByFilter(apc)>=ac.getLimit_number()){
				return "-1";
			}
		}
		logger.info("----ParticipantController ---- add ---验证重复报名");
		if(StringUtils.isNotNullOrEmptyStr(sourceid)){
			//当前用户是否已经报名
			apc.setSource(source);
			apc.setSourceid(sourceid);
			if(cRMService.getDbService().getActivityParticipantService().countObjByFilter(apc)>0){
				return "-1";
			}
		}
		logger.info("----ParticipantController ---- add ---保存报名信息");
		Participant act = new Participant();
		act.setOpName(opName);
		act.setOpMobile(opMobile);
		act.setOpDuty(opDuty);
		act.setOpCompany(opCompany);		
		act.setOpSignature(opSignature);
//		if("WX".equals(source)){
//			WxuserInfo wuInfo = new WxuserInfo();	
//			wuInfo.setParty_row_id(sourceid);
//			List<?> wuList = wxUserinfoService.findObjListByFilter(wuInfo);
//			if(null != wuList && wuList.size() > 0){
//				wuInfo = (WxuserInfo)wuList.get(0);
//			}
//			act.setOpImage(wuInfo.getHeadimgurl());
//		}else{
		
		if(StringUtils.isNotNullOrEmptyStr(sourceid)){
			SourceObject obj= cRMService.getDbService().getSourceObject2SourceSystemService().getSourceObject(sourceid, null);
			act.setOpImage(obj.getHeadImageUrl());
		}
		//活动发起人
		SourceObject actvityobj = cRMService.getDbService().getSourceObject2SourceSystemService().getSourceObject(ac.getCreateBy(), null);
		String openId = actvityobj.getOpenId();
//		}
		boolean flag = cRMService.getDbService().getParticipantService().addParticipant(act,rowid,sourceid,source);
		
		if (!flag) {
			return "-1";
		}
		
		logger.info("----ParticipantController ---- add ---如果不是匿名报名，则同步更新微信");
		//如果不是匿名报名，则同步更新微信
		if(StringUtils.isNotNullOrEmptyStr(sourceid)){
			//报名成功，需同步更新微客用户信息（20150317修改）
			BusinessCard bc = new BusinessCard();
			bc.setPartyId(sourceid);
			Object obj1 = cRMService.getDbService().getBusinessCardService().findObj(bc);
			if(null != obj1){
				bc = (BusinessCard)obj1;
				bc.setPhone(opMobile);
				bc.setCompany(opCompany);
				bc.setPosition(opDuty);
				bc.setName(opName);
				cRMService.getDbService().getBusinessCardService().updateObj(bc);
			}
		}

		request.setAttribute("rowid", rowid);
		String content = "";
		String activityUrl = "";
		//发送微信消息通知活动发起人
		if("meet".equals(ac.getType())){
			content = opName+"报名了您的聚会【"+ac.getTitle()+"】，";
			activityUrl = "zjwkactivity/meetdetail?id="+rowid+"&source="+source+"&sourceid="+ac.getCreateBy();
		}else{
			content = opName+"报名了您的活动【"+ac.getTitle()+"】，";
			activityUrl = "zjwkactivity/detail?id="+rowid+"&source="+source+"&sourceid="+ac.getCreateBy();
		}
		logger.info("----ParticipantController ---- add ---微信通知活动发起人，提示有人报名");
		cRMService.getWxService().getWxRespMsgService().respCommCustMsgByOpenId(openId,null,null,content,activityUrl);
		return JSONArray.fromObject(act).toString();
	}
	
	/**
	 * 同步到联系人
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/syncContact")
	@ResponseBody
	public String syncContact(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String sourceid=request.getParameter("sourceid");
		String source=request.getParameter("source");
		String participantid=request.getParameter("participantid");
		if(sourceid==null||"".equals(sourceid.trim())||participantid==null||"".equals(participantid.trim())){
			throw new Exception("错误编号："+ErrCode.ERR_CODE_1001001+"，错误描述："+ErrCode.ERR_CODE_1001001_MSG);
		}
		Participant pc = (Participant)cRMService.getDbService().getParticipantService().findObjById(participantid);
		pc.setOrgId(request.getParameter("orgId"));
		String str= cRMService.getDbService().getParticipant2WkService().syncParticipant2Contact(source,sourceid, pc);
		return str;
	}
	
	/**
	 * 更新用户
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updstatus")
	@ResponseBody
	public String updstatus(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String participantid = request.getParameter("participantid");
		String flag = request.getParameter("flag");
		String rowId = request.getParameter("actid");
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(rowId);
		String status = "";
		String content = "";
		if("Y".equals(flag)){
			status = "1";
			content = "您报名参加的活动【"+act.getTitle()+"】已通过审核。";
		}else if("N".equals(flag)){
			status = "0";
			content = "对不起，您报名的活动【"+act.getTitle()+"】未通过审核。";
		}
		Participant parti = new Participant();
		List<String> idList = new ArrayList<String>();
		if(StringUtils.isNotNullOrEmptyStr(participantid)&&participantid.contains(",")){
			String[] str = participantid.split(",");
			for(String id : str){
				Participant participant = new Participant();
				participant.setStatus(status);
				participant.setId(id);
				idList.add(id);
				parti.setStatus(status);
				Participant part = cRMService.getDbService().getParticipantService().getParticipantById(participant);
				/*Map<String, Object> map = new HashMap<String, Object>();
				map.put("mobile", part.getOpMobile());
				map.put("content",content);
				map.put("code", "123456");
				HttpClient3Post.request(null,map);*/
				ThreadRun thread = new SMSSentThread("123456", part.getOpMobile(),content);
				ThreadExecute.push(thread);

			}
			parti.setId_in(idList);
		}
//		int s = cRMService.getDbService().getParticipantService().updateStatus(participant);
		int s = cRMService.getDbService().getParticipantService().updateeBatchStatus(parti);
		if(s>0){
			return "success";
		}else{
			return "error";
		}
	}
	
	/**
	 * 发送短信获取验证码
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/sendMsg")
	@ResponseBody
	public String sendMsg(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String phoneNumber = request.getParameter("phonenumber");
		String code = request.getParameter("code");
		String sourceid = request.getParameter("sourceid");
		String activityid = request.getParameter("activityid");
		logger.info("ParticipantController sendMsg phoneNumber ==>"+phoneNumber);
		logger.info("ParticipantController sendMsg code ==>"+code);
		//缓存code的开始时间
		RedisCacheUtil.setString("Activity_Enlist_MessageCode_StartTime"+sourceid+activityid+"_"+code, DateTime.currentTimeMillis()+"");
		String str = RedisCacheUtil.getString("Activity_Enlist_MessageCode_"+sourceid+activityid);
		if(StringUtils.isNotNullOrEmptyStr(str)){
			str = str+","+code;
		}
		//缓存到redies
		RedisCacheUtil.setString("Activity_Enlist_MessageCode_"+sourceid+activityid,str);
		//缓存code的结束时间
		RedisCacheUtil.setString("Activity_Enlist_MessageCode_EndTime"+sourceid+activityid+"_"+code, DateTime.currentTimeMillis()+"");
		String url = PropertiesUtil.getMsgContext("service.url1");
		String content = PropertiesUtil.getMsgContext("message.model1").replace("$$code", code);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mobile", phoneNumber);
		map.put("content",content);
		map.put("code", code);
		ActivityParticipant ap = new ActivityParticipant();
		ap.setActivityid(activityid);
		List<Participant> parList = cRMService.getDbService().getParticipantService().getParticipantListByActivity(ap);
		if(null!=parList&&parList.size()>0){
			for(Participant part : parList){
				String phonenumber = part.getOpMobile();
				if(phonenumber.equals(phoneNumber)){
					return "-1";
				}
			}
		}
		String result = HttpClient3Post.request(url,map);
		if(StringUtils.isNotNullOrEmptyStr(result)&&result.equals(code)){
			return "0";
		}else{
			return "1";
		}
	}

	/**
	 * 报名成功之后，进入报名成功页面
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/msg")
	public String msg(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String username = request.getParameter("username");
		String id = request.getParameter("id");
		if(StringUtils.isNotNullOrEmptyStr(username)&&!StringUtils.regZh(username)){
			username = new String(username.getBytes("ISO-8859-1"),"UTF-8");
		}
		request.setAttribute("partyId", UserUtil.getCurrUser(request).getParty_row_id());
		request.setAttribute("filepath","http://"+PropertiesUtil.getAppContext("file.service") + PropertiesUtil.getAppContext("file.service.userpath").replace("/usr", "").replace("/zjftp","")+"/");
		String openId = UserUtil.getCurrUser(request).getOpenId();
		//获取关注指尖微客的用户列表
		AccessToken at = WxUtil.getAccessToken(Constants.APPID, Constants.APPSECRET);
		UserGet userGet = WxUtil.userGet("", at);
		for(String openid : userGet.getOpenidlist()){
			if(openid.equals(openId)){
				request.setAttribute("flag", "already");
			}
		}
		Activity activity = cRMService.getDbService().getActivityService().getActivitySingle(id);
		request.setAttribute("activityname", activity.getTitle());
		request.setAttribute("type", activity.getType());
		request.setAttribute("username", username);
		return "activity/success_regist";
	}
	
	public static void main(String[] args) throws UnsupportedEncodingException {
		String content = PropertiesUtil.getMsgContext("message.model1").replace("$$code", "123123");
		String signature = PropertiesUtil.getMsgContext("msg.signature");
		String msgmodule = new String((content+signature).getBytes("utf-8"),"utf-8");
		System.out.println(msgmodule);
	}
}
