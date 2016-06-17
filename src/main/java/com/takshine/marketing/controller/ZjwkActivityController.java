package com.takshine.marketing.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletInputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Colour;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Activity;
import com.takshine.marketing.domain.ActivityItem;
import com.takshine.marketing.domain.ActivityParticipant;
import com.takshine.marketing.domain.ActivityPrint;
import com.takshine.marketing.domain.Activity_Rela;
import com.takshine.marketing.domain.Attachment;
import com.takshine.marketing.domain.Invite;
import com.takshine.marketing.domain.Participant;
import com.takshine.marketing.domain.SourceObject;
import com.takshine.marketing.model.DirectSendModel;
import com.takshine.marketing.service.Activity_RelaService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.HttpClient3Post;
import com.takshine.wxcrm.base.util.MailUtils;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.SenderInfor;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.base.util.runtime.SMSSentThread;
import com.takshine.wxcrm.base.util.runtime.ThreadExecute;
import com.takshine.wxcrm.base.util.runtime.ThreadRun;
import com.takshine.wxcrm.domain.BusinessCard;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.DiscuGroup;
import com.takshine.wxcrm.domain.DiscuGroupUser;
import com.takshine.wxcrm.domain.Messages;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.Schedule;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.domain.cache.CacheContact;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.oauth.AuthorizeInfo;
import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.message.sugar.ContactResp;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.CustomerResp;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.message.userinfo.UserInfo;
import com.takshine.wxcrm.service.Customer2SugarService;
import com.takshine.wxcrm.service.Schedule2SugarService;

/**
 * 活动 控制器
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/zjwkactivity")
public class ZjwkActivityController {
	protected static Logger logger = Logger
			.getLogger(ZjwkActivityController.class.getName());
	
	// 从sugar系统获取 LOV和 用户 的服务
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	@Autowired
	@Qualifier("schedule2SugarService")
	private Schedule2SugarService schedule2SugarService;
	
	// 客户调用sugar接口的 服务
	@Autowired
	@Qualifier("customer2SugarService")
	private Customer2SugarService customer2SugarService;
	
	//活动关联
	@Autowired
	@Qualifier("activity_RelaService")
	private Activity_RelaService activity_RelaService;
	
	/**
	 * 活动选择
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/get")
	public String get(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// openId publicId
		String return_url = request.getParameter("return_url");
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		String orgId = request.getParameter("orgId");
		String type = request.getParameter("type");
		request.setAttribute("sourceid", sourceid);
		request.setAttribute("source", source);
		request.setAttribute("orgId", orgId);
		request.setAttribute("return_url", return_url);
		request.setAttribute("type", type);
		if(StringUtils.isNotNullOrEmptyStr(type)){
			return "redirect:/zjwkactivity/add?type="+type+"&orgId="+orgId+"&return_url="+return_url+"&sourceid="+sourceid+"&source="+source;
		}
		return "activity/choose";
	}

	/**
	 * 活动修改
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modify")
	public String modify(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// openId publicId
		String id = request.getParameter("id");
		String sourceid = request.getParameter("sourceid");
		if (sourceid == null) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		if (null == id || "".equals(id)) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		if (null == act || "".equals(act.getId())) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001002 + "，错误描述："+ ErrCode.ERR_CODE_1001002_MSG);
		}
		if (!sourceid.equals(act.getCreateBy())) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		Map<String, Map<String, String>> lovMap = cRMService.getDbService().getLovService().getLovList(null);
		if (null != lovMap) {
			request.setAttribute("lov_charge_type",lovMap.get("lov_charge_type"));
			request.setAttribute("lov_activity_type",lovMap.get("lov_activity_type"));
			request.setAttribute("lov_activity_status",lovMap.get("lov_activity_status"));
			request.setAttribute("lov_activity_ispublish",lovMap.get("lov_activity_ispublish"));
			request.setAttribute("lov_activity_islive",lovMap.get("lov_activity_islive"));
			request.setAttribute("lov_activity_isregist",lovMap.get("lov_activity_isregist"));
			request.setAttribute("lov_activity_live_parameter",lovMap.get("lov_activity_live_parameter"));
			request.setAttribute("lov_activity_displaymenber",lovMap.get("lov_activity_displaymenber"));
		} else {
			request.setAttribute("lov_charge_type",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_type",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_status",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_ispublish",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_islive",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_isregist",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_live_parameter",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_displaymenber",new HashMap<String, Map<String, String>>());
		}
		request.setAttribute("activity", act);
		request.setAttribute("sourceid", sourceid);
		request.setAttribute("source", act.getSource());
		// 是否从pc端进来
		if (StringUtils.isNotNullOrEmptyStr(act.getSource())&& "PC".equals(act.getSource())) {
			request.setAttribute("id", id);
			return "pcactivity/modify";
		}
		if ("meeting".equals(act.getType())) {
			return "activity/modifymeet";
		} else {
			return "activity/modifyact";
		}

	}

	/**
	 * 从PC端增加保存返回跳回
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/returnUrl")
	public String returnUrl(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String rowId = request.getParameter("rowId");
		String orgId = request.getParameter("orgId");
		String return_url = request.getParameter("return_url");
		String module = request.getParameter("module");
		return "redirect:" + return_url + "?module=" + module + "&rowId=" + rowId+ "&orgId=" + orgId;
	}

	/**
	 * 添加
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/add")
	public String add(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// openId publicId
		String type = request.getParameter("type");
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		String return_url = request.getParameter("return_url");
		String orgId = request.getParameter("orgId");

		Map<String, Map<String, String>> lovMap = cRMService.getDbService().getLovService().getLovList(null);
		if (null != lovMap) {
			request.setAttribute("lov_charge_type",lovMap.get("lov_charge_type"));
			request.setAttribute("lov_activity_type",lovMap.get("lov_activity_type"));
			request.setAttribute("lov_activity_status",lovMap.get("lov_activity_status"));
			request.setAttribute("lov_activity_ispublish",lovMap.get("lov_activity_ispublish"));
			request.setAttribute("lov_activity_islive",lovMap.get("lov_activity_islive"));
			request.setAttribute("lov_activity_isregist",lovMap.get("lov_activity_isregist"));
			request.setAttribute("lov_activity_live_parameter",lovMap.get("lov_activity_live_parameter"));
			request.setAttribute("lov_activity_displaymenber",lovMap.get("lov_activity_displaymenber"));
		} else {
			request.setAttribute("lov_charge_type",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_type",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_status",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_ispublish",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_islive",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_isregist",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_live_parameter",new HashMap<String, Map<String, String>>());
			request.setAttribute("lov_activity_displaymenber",new HashMap<String, Map<String, String>>());
		}
		request.setAttribute("type", type);
		request.setAttribute("return_url", return_url);
		request.setAttribute("sourceid", sourceid);
		request.setAttribute("source", source);
		if ("RM".equals(source)) {
			List<Organization> list = cRMService.getDbService().getSourceObject2SourceSystemService().getOrgList(sourceid);
			if (null != list && list.size() == 1) {
				orgId = list.get(0).getId();
			}
			request.setAttribute("orgList", list);
		}
		request.setAttribute("orgId", orgId);
		// 从PC端进来，共用一个add方法
		if ("PC".equals(source)) {
			return "pcactivity/add";
		}
		if (null == type || "".equals(type) || "activity".equals(type)) {
			return "activity/addact_yh";
		}else if("meet".equals(type)){
			return "activity/addact_jh";
		}
		return "";
	}

	/**
	 * 活动创建
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/save")
	public String add(Activity act, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		WxuserInfo wxuser = UserUtil.getCurrUser(request);
		String openId = wxuser.getOpenId();
		String return_url = request.getParameter("return_url");
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		String orgId = request.getParameter("orgId");
		if (sourceid == null) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		act.setCreateBy(sourceid);
		act.setSource(source);
		if ("PC".equals(source)) {
			source = "WK";
		}
		String crmId = cRMService.getDbService().getActivityService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		act.setHeadImageUrl(wxuser.getHeadimgurl());
		act.setCreateName(wxuser.getName());
		act.setOrgId(orgId);
		act.setCrmId(crmId);
		act.setContent(request.getParameter("content"));
		act.setEnabled_flag("enabled");
		String id = request.getParameter("rowid");
		if (StringUtils.isNotNullOrEmptyStr(id)) {
			act.setId(id);
			cRMService.getDbService().getActivityService().updateActivity(act);
		} else {
			id = cRMService.getDbService().getActivityService().addActivity(act);
		}
		if (null == id || "".equals(id)) {
			throw new Exception("保存活动失败");
		}
		//20150319修改
		if (null == return_url || "".equals(return_url)) {
			request.setAttribute("sourceid", sourceid);
			request.setAttribute("source", source);
			return "redirect:/zjactivity/list?viewtype=owner";
		} else {
			return_url = URLDecoder.decode(return_url, "utf-8");
			// 临时处理，后续再改
			if (return_url.indexOf("?") != -1) {
				return "redirect:" + return_url + "&rowId=" + id+ "&orgId=" + orgId;
			} else {
				return "redirect:" + return_url + "?rowId=" + id+ "&orgId=" + orgId;
			}
		}

	}

	/**
	 * 邀请好友（包括指尖好友和联系人）
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/groomUser")
	public String groomUser(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String return_url = request.getParameter("return_url");
		String rowId = request.getParameter("rowId");
		String orgId = request.getParameter("orgId");
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		// 获得指尖好友
		List<UserRela> list = getRelaUserId(sourceid);
		if (list.isEmpty()) {
			request.setAttribute("isEmpty", "true");
		}
		// 获得联系人
		request.setAttribute("userRelaList", list);
		request.setAttribute("sourceid", sourceid);
		request.setAttribute("source", source);
		request.setAttribute("return_url", return_url);
		request.setAttribute("rowId", rowId);
		request.setAttribute("orgId", orgId);
		return "activity/groomuser";
	}

	/**
	 * 保存邀请好友，并推送消息或发送短信
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveGroomUser")
	public String saveGroomUser(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String return_url = request.getParameter("return_url");
		String rowId = request.getParameter("rowId");
		String orgId = request.getParameter("orgId");
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		String id = request.getParameter("id");
		String optype = request.getParameter("optype");
		if (!"skip".equals(optype)) {
			Activity act = cRMService.getDbService().getActivityService().getActivitySingle(rowId);
			if (StringUtils.isNotNullOrEmptyStr(id) && id.contains(";")) {
				String content = act.getCreateName() + "邀请您参与他的活动【"+ act.getTitle() + "】，";
				String[] strs = id.split(";");
				for (String str : strs) {
					Map<String, String> map = RedisCacheUtil.getStringMapAll(Constants.LOGINTIME_KEY + "_"+ str.split(",")[0]);
					if (null != map && map.keySet().size() > 0) {
						String relaOpenId = (String) map.get("openId");
						String loginTime = (String) map.get("loginTime");
						String differtime = 172800000 + "";// 48小时
						// 若48小时未登录，则发送短信(20150204 短信模板没有定下来 暂时处理)
						if (StringUtils.isNotNullOrEmptyStr(loginTime)&& DateTime.comDate(loginTime, differtime,DateTime.DateTimeFormat1)) {
							String url = PropertiesUtil.getMsgContext("service.url1");
							String msg = PropertiesUtil.getMsgContext("message.model3");
							/*Map<String, Object> msgMap = new HashMap<String, Object>();
							msgMap.put("mobile", str.split(",")[1]);
							msgMap.put("content", msg);
							msgMap.put("code", "123123");
							HttpClient3Post.request(url, msgMap);*/
							ThreadRun thread = new SMSSentThread("123123", str.split(",")[1],msg);
							ThreadExecute.push(thread);

						} else {// 微信推送消息
							String url = "zjwkactivity/new_detail?flag=wkshare&id="+ rowId + "&source=" + source+ "&sourceid=" + str;
							cRMService.getWxService().getWxRespMsgService().respCommCustMsgByOpenId(relaOpenId, null, null, content, url);
						}
					}
				}
			}
		}
		// 20150305修改
		if (null == return_url || "".equals(return_url)) {
			request.setAttribute("sourceid", sourceid);
			request.setAttribute("source", source);
			return "redirect:/zjactivity/list?viewtype=owner";
		} else {
			return_url = URLDecoder.decode(return_url, "utf-8");
			// 临时处理，后续再改
			if (return_url.indexOf("?") != -1) {
				return "redirect:" + return_url + "&rowId=" + rowId+ "&orgId=" + orgId;
			} else {
				return "redirect:" + return_url + "?rowId=" + rowId+ "&orgId=" + orgId;
			}
		}
	}

	/**
	 * 活动预览
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/view")
	@ResponseBody
	public String view(Activity act, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		WxuserInfo wxuser = UserUtil.getCurrUser(request);
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		if (sourceid == null) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		act.setCreateBy(sourceid);
		act.setSource(source);
		if ("PC".equals(source)) {
			source = "WK";
		}
		act.setHeadImageUrl(wxuser.getHeadimgurl());
		act.setCreateName(wxuser.getName());
		act.setContent(request.getParameter("content"));
		act.setEnabled_flag("enabled");
		String id = "";
		CrmError crmError = new CrmError();
		String rowid = request.getParameter("rowid");
		try {
			if (StringUtils.isNotNullOrEmptyStr(rowid)) {
				act.setId(rowid);
				cRMService.getDbService().getActivityService().updateActivity(act);
				id = rowid;
			} else {
				String openId = UserUtil.getCurrUser(request).getOpenId();
				String crmId = cRMService.getDbService().getActivityService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), act.getOrgId());
				act.setCrmId(crmId);
				id = cRMService.getDbService().getActivityService().addActivity(act);
			}
		} catch (Exception e) {
			String str = e.getMessage();
			if (StringUtils.isNotNullOrEmptyStr(str)&& str.contains("PacketTooBigException")) {
				crmError.setErrorCode("1");
				crmError.setErrorMsg("保存失败，活动内容过长！");
			} else {
				crmError.setErrorCode("1222");
				crmError.setErrorMsg("保存失败，请联系管理员！");
			}
			return JSONObject.fromObject(crmError).toString();
		}
		String content = "尊敬的" + wxuser.getNickname() + "，您已成功发送活动"+ act.getTitle() +"的预览申请  查看详情。";
		String url = "zjwkactivity/detail?id=" + id + "&source=" + source+ "&sourceid=" + sourceid;
		try {
			cRMService.getWxService().getWxRespMsgService().respCommCustMsgByOpenId(wxuser.getOpenId(), null, null, content, url);
			crmError.setErrorCode("0");
			crmError.setRowId(id);
			crmError.setErrorMsg("请打开手机，查看微信消息！！！");
		} catch (Exception e) {
			crmError.setErrorCode("99999");
			crmError.setErrorMsg("预览失败，请联系管理员！！！");
		}
		return JSONObject.fromObject(crmError).toString();
	}

	/**
	 * 异步保存活动
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asysave")
	@ResponseBody
	public String asysave(Activity act, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		WxuserInfo wxuser = UserUtil.getCurrUser(request);
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		if (sourceid == null) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		String rowid = request.getParameter("rowid");
		String optype = request.getParameter("optype");
		CrmError crmError = new CrmError();
		try {
			if ("upd".equals(optype)) {
				// 修改的时候
				rowid = act.getId();
				cRMService.getDbService().getActivityService().updateActivity(act);
			} else if (StringUtils.isNotNullOrEmptyStr(rowid)) {
				// 预览完成之后，在保存
				act.setId(rowid);
				cRMService.getDbService().getActivityService().updateActivity(act);
			} else {
				// 直接保存
				act.setCreateBy(sourceid);
				act.setSource(source);
				act.setHeadImageUrl(wxuser.getHeadimgurl());
				act.setCreateName(wxuser.getName());
				act.setContent(request.getParameter("content"));
				act.setEnabled_flag("enabled");
				String openId = wxuser.getOpenId();
				String crmId = cRMService.getDbService().getActivityService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), act.getOrgId());
				act.setCrmId(crmId);
				rowid = cRMService.getDbService().getActivityService().addActivity(act);
			}
			crmError.setErrorCode("0");
			crmError.setRowId(rowid);
			crmError.setErrorMsg("保存成功！！！");
		} catch (Exception e) {
			String str = e.getMessage();
			if (StringUtils.isNotNullOrEmptyStr(str)&& str.contains("PacketTooBigException")) {
				crmError.setErrorCode("1");
				crmError.setErrorMsg("保存失败，活动内容过长！");
			} else {
				crmError.setErrorCode("1222");
				crmError.setErrorMsg("保存失败，请联系管理员！");
			}
		}
		return JSONObject.fromObject(crmError).toString();
	}

	/**
	 * 异步获取参与的活动列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asynclistbyid")
	@ResponseBody
	public String asynclistbyid(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		List<Activity> actList = new ArrayList<Activity>();
		String sourceid = request.getParameter("sourceid");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		ActivityParticipant participant = new ActivityParticipant();
		participant.setSourceid(sourceid);
		participant.setPagecounts(Integer.parseInt(pagecount));
		participant.setCurrpages(Integer.parseInt(currpage));
		actList =cRMService.getDbService().getActivityParticipantService().getActivityListById(participant);
		if (null == actList || actList.size() == 0) {
			return "";
		}
		String str = JSONArray.fromObject(actList).toString();
		logger.info("ActivityController --> asynclistbyid --> " + str);
		return str;
	}

	/**
	 * 异步获取推荐的活动列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asyactivitylist")
	@ResponseBody
	public String asyactivitylist(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		List<Activity> actList = new ArrayList<Activity>();
		actList = cRMService.getDbService().getActivityService().searchGroomActivity(new Activity());
		String str = "";
		if (actList.size() > 0) {
			str = JSONArray.fromObject(actList).toString();
		}
		logger.info("ActivityController asyactivitylist --> " + str);
		return str;
	}
	
	/**
	 * 异步获取推荐的活动列表（首页3条）
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/recomlist")
	@ResponseBody
	public String recomlist(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		List<Activity> actList = new ArrayList<Activity>();
		Activity act = new Activity();
		act.setCurrpages(0);
		act.setPagecounts(3);
		actList = cRMService.getDbService().getActivityService().searchGroomActivity(act);
		String str = "";
		if (actList.size() > 0) {
			str = JSONArray.fromObject(actList).toString();
		}
		logger.info("ActivityController asyactivitylist --> " + str);
		return str;
	}

	/**
	 * 异步获取活动列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String viewtype = request.getParameter("viewtype");
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		request.setAttribute("sourceid", sourceid);
		request.setAttribute("source", source);
		request.setAttribute("viewtype", viewtype);
		return "activity/list";
	}

	/**
	 * 异步获取活动列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/synclist")
	@ResponseBody
	public String synclist(Activity act, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String rst = "";
		String viewtype = request.getParameter("viewtype");
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		String firstChar = request.getParameter("firstchar");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String startdate = request.getParameter("startdate");
		String enddate = request.getParameter("enddate");
		if (currpage == null || "".equals(currpage.trim())) {
			currpage = "0";
		}
		if (pagecount == null || "".equals(pagecount.trim())) {
			pagecount = "10";
		}
		List<Activity> actList = null;
		if ("join".equals(viewtype)) {
			ActivityParticipant ap = new ActivityParticipant();
			ap.setSource(source);
			ap.setSourceid(sourceid);
			ap.setPagecounts(Integer.parseInt(pagecount));
			ap.setCurrpages(Integer.parseInt(currpage));
			if (StringUtils.isNotNullOrEmptyStr(startdate)) {
				ap.setStartdate(startdate);
			}
			if (StringUtils.isNotNullOrEmptyStr(enddate)) {
				ap.setEnddate(enddate);
			}
			actList = cRMService.getDbService().getActivityService().getJoinActivityList(ap);
		} else if ("owner".equals(viewtype)) {
			act.setCreateBy(sourceid);
			act.setSource(source);
			if (firstChar != null && !"null".equals(firstChar)&& !"".equals(firstChar.trim())) {
				act.setFirstChar(firstChar);
			}
			act.setPagecounts(Integer.parseInt(pagecount));
			act.setCurrpages(Integer.parseInt(currpage));
			if (StringUtils.isNotNullOrEmptyStr(startdate)) {
				act.setStart_date(startdate);
			}
			if (StringUtils.isNotNullOrEmptyStr(enddate)) {
				act.setEnd_date(enddate);
			}
			actList = cRMService.getDbService().getActivityService().getActivityList(act);
		} else {
			if (StringUtils.isNotNullOrEmptyStr(startdate)) {
				act.setStart_date(startdate);
			}
			if (StringUtils.isNotNullOrEmptyStr(enddate)) {
				act.setEnd_date(enddate);
			}
			act.setPagecounts(Integer.parseInt(pagecount));
			act.setCurrpages(Integer.parseInt(currpage));
			actList = cRMService.getDbService().getActivityService().getActivityList(act);
		}
		if (null == actList || actList.size() == 0) {
			rst = "";
		} else {
			rst = JSONArray.fromObject(actList).toString();
		}
		logger.info("ActivityController --> list --> " + rst);
		return rst;
	}

	/**
	 * 异步获取活动列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/synclistbyidlist")
	@ResponseBody
	public String synclistByIdList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ServletInputStream inputStream = request.getInputStream();
		StringBuffer sb = new StringBuffer();
		byte[] bytes = new byte[1024 * 1024];
		int len = 0;
		while ((len = inputStream.read(bytes)) != -1) {
			String str = new String(bytes, 0, len, "UTF-8");
			sb.append(str);
		}
		List<Activity> list = new ArrayList<Activity>();
		String str = "";
		if (null != sb.toString()) {
			JSONArray jsonArray = JSONArray.fromObject(sb.toString());
			for (int i = 0; i < jsonArray.size(); i++) {
				JSONObject jsonObject = jsonArray.getJSONObject(i);
				String rowid = jsonObject.getString("rowid");
				Activity act = cRMService.getDbService().getActivityService().getActivitySingle(rowid);
				if (null != act) {
					list.add(act);
				}
			}
			str = JSONArray.fromObject(list).toString();
		}
		return str;
	}

	/**
	 * 异步获取活动列表首字母
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/syncfirstbyidlist")
	@ResponseBody
	public String syncFirstByIdList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		List<String> actList = null;
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		Activity act = new Activity();
		act.setCreateBy(sourceid);
		act.setSource(source);
		actList = cRMService.getDbService().getActivityService().getFirstList(act);
		if (null == actList || actList.size() == 0) {
			return "";
		}
		String str = JSONArray.fromObject(actList).toString();
		logger.info("ActivityController --> list --> " + str);
		return str;
	}

	/**
	 * 修改市场活动
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/update")
	public String update(Activity act, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		if (sourceid == null) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		boolean flag = cRMService.getDbService().getActivityService().updateActivity(act);
		if (flag) {
			request.setAttribute("id", act.getId());
			return "redirect:/zjwkactivity/detail?id=" + act.getId() + "&sourceid="+ sourceid + "&source=" + source;
		} else {
			return "activity/msg";
		}
	}
	
	/**
	 * 修改市场活动
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updateParam")
	public String updateParam(Activity act, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		cRMService.getDbService().getActivityService().updateActivityByParams(act);
		String contactlist = act.getContactlistval();
		String [] conarr = contactlist.split(",");
		//联系人
		for (int i = 0; i < conarr.length; i++) {
			String []  sconarr = conarr[i].split("\\|");
			Activity_Rela ar = new Activity_Rela();
			ar.setRela_id(sconarr[0]);
			ar.setRela_name(sconarr[1] + " " + sconarr[2]);
			ar.setRela_type("contact");
			ar.setActivity_id(act.getId());
			activity_RelaService.addObj(ar);
		}
		//客户
		String customerlist = act.getCustomerlistval();
		String [] cusarr = customerlist.split(",");
		for (int i = 0; i < cusarr.length; i++) {
			String []  scusarrarr = cusarr[i].split("\\|");
			Activity_Rela ar = new Activity_Rela();
			ar.setRela_id(scusarrarr[0]);
			ar.setRela_name(scusarrarr[1]);
			ar.setRela_type("customer");
			ar.setActivity_id(act.getId());
			activity_RelaService.addObj(ar);
		}
		request.setAttribute("id", act.getId());
		return "redirect:/zjwkactivity/detail?id=" + act.getId() + "&sourceid="+ act.getId() + "&source=WK";
	}
	
	/**
	 * 获取关联关系列表数据
	 * @param request
	 * @return
	 */
	@RequestMapping("/syncActRelaList")
	@ResponseBody
	public String syncActRelaList(HttpServletRequest request){
		String actId = request.getParameter("actId");
		String type = request.getParameter("type");
		logger.info("actId = >" + actId);
		logger.info("type = >" + type);
		//活动关联
		Activity_Rela ar = new Activity_Rela();
		ar.setActivity_id(actId);
		ar.setRela_type(type);
		List<Activity_Rela> rlist = (List<Activity_Rela>)activity_RelaService.findObjListByFilter(ar);
		logger.info("rlist = >" + rlist);
		String rst = JSONArray.fromObject(rlist).toString();
		return rst;
	}

	/**
	 * 指尖活动详情
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ZJWKUtil.getRequestURL(request);// 获取请求的url
		String id = request.getParameter("id");
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		String flag = request.getParameter("flag");
		
		// 直接分享链接进来（20150128修改）
		if ("dtshare".equals(flag)) {
			Cookie[] cookies = request.getCookies();
			String url = PropertiesUtil.getAppContext("app.content") + "/zjwkactivity/share?id="+ id+ "&fopenId=" + sourceid;
			String clickevent = request.getParameter("clickevent");
			logger.info("------ZjwkActivityController ----> detail ---> clickevent" + clickevent );
			//创建活动
			if ("add".equals(clickevent)){
				url += "&return_url="+PropertiesUtil.getAppContext("app.content")+"/zjwkactivity/get?wk=wk";
			}
			//直播间
			else if ("live".equals(clickevent)){
				url += "&return_url="+PropertiesUtil.getAppContext("app.content")+"/zjwkactivity/direct?id="+id;
			}
			
			logger.info("------ZjwkActivityController ----> detail ---> return_url" + url );
			
			url  =URLEncoder.encode(url, "UTF-8");
			if (cookies != null && cookies.length > 0) {
				boolean cookieflag = false;
				for (int i = 0; i < cookies.length; i++) {
					String key = cookies[i].getName();
					if (Constants.ACTIVITY_PARTYID.equals(key)	&& StringUtils.isNotNullOrEmptyStr(cookies[i].getValue())) {
						cookieflag = true;
						sourceid = cookies[i].getValue();
						break;
					}
				}
				if (!cookieflag) {
					return "redirect:https://open.weixin.qq.com/connect/oauth2/authorize?appid="+ PropertiesUtil.getAppContext("wxcrm.appid")+ "&redirect_uri="+ url + "&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect";
				}
			} else {
				return "redirect:https://open.weixin.qq.com/connect/oauth2/authorize?appid="+ PropertiesUtil.getAppContext("wxcrm.appid")+ "&redirect_uri="+ url + "&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect";
			}
		}

		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		if (null == act || "".equals(act.getId())) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001007 + "，错误描述："+ErrCode.ERR_MSG_1001007);
		}
		
		if("meet".equals(act.getType())){
			return "redirect:/zjwkactivity/meetdetail?id=" + id+"&sourceid="+sourceid+"&source="+source+"&flag="+flag;
		}
		// 20150313修改
		if ("newshare".equals(flag)) {
			return "redirect:/zjwkactivity/new_detail?id=" + id;
		}
		String openId = UserUtil.getCurrUser(request).getOpenId();
		// 从消息进来
		if (!StringUtils.isNotNullOrEmptyStr(sourceid)&& "wkshare".equals(source)) {
			sourceid = UserUtil.getCurrUser(request).getParty_row_id();
		}
		if (sourceid == null) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		if (null == id || "".equals(id)) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		boolean isattenflag = true;
		// 从RM进来查看活动详情
		String orgId = request.getParameter("orgId");
		if (!StringUtils.isNotNullOrEmptyStr(orgId)) {
			orgId = (String) RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+ id);
			if(!StringUtils.isNotNullOrEmptyStr(orgId)){
				orgId = act.getOrgId();
			}
		}
		//当前用名字
		request.setAttribute("currusername", UserUtil.getCurrUser(request).getName());
		String optype = "";
		if ((sourceid).equals(act.getCreateBy())) {
			optype = "owner";
			isattenflag = false;
		}
		// 查询已访问数
		ActivityPrint ap = new ActivityPrint();
		ap.setActivityid(id);
		ap.setType("VISIT");
		int visitCount = cRMService.getDbService().getActivityPrintService().countObjByFilter(ap);
		ap.setSource(source);
		ap.setSourceid(sourceid);
		visitCount += 1;
		cRMService.getDbService().getActivityPrintService().addObj(ap);
		// 点赞统计
		ActivityPrint ap2 = new ActivityPrint();
		ap2.setActivityid(id);
		ap2.setType("PRAISE");
		int praiseCount = cRMService.getDbService().getActivityPrintService().countObjByFilter(ap2);
		List<ActivityPrint> praiseList = cRMService.getDbService().getActivityPrintService().searchActivityPrintList(ap2);// 点赞列表
		// ap2.setSource(source);
		ap2.setSourceid(sourceid);
		boolean ispraise = true;
		if ("owner".equals(optype)|| cRMService.getDbService().getActivityPrintService().countObjByFilter(ap2) > 0) {// 创建者和已点赞的不能在点赞
			ispraise = false;
		}
		ActivityParticipant apc = new ActivityParticipant();
		apc.setActivityid(id);
		apc.setOrderByString(" order by create_date ");
		List<Participant> paList = cRMService.getDbService().getParticipantService().getParticipantListByActivity(apc);// 报名列表
		List<Participant> participantList = new ArrayList<Participant>();
		// 从微客端获取好友列表
		List<UserRela> userList = getRelaUserId(sourceid);
		for (Participant participant : paList) {
			for (UserRela userRela : userList) {
				if (userRela.getRela_user_id().equals(participant.getSourceid())) {
					participant.setFlag("Y");
				}
			}
			participantList.add(participant);
		}
		request.setAttribute("userList", participantList);
		// 当前用户是否已经报名
		apc.setSourceid(sourceid);
		boolean isjoin = true;// 是否可以报名
		long endtime = DateTime.dateTimeParse(act.getEnd_date(),DateTime.DateFormat1);
		long currtime = System.currentTimeMillis();
		if (currtime > endtime) {// 截止日期
			isjoin = false;
		}else if (participantList != null&& participantList.size() >= act.getLimit_number()) {// 报名人数已满
			isjoin = false;
		}else if ("owner".equals(optype)) {
			isjoin = false;
		}else if (cRMService.getDbService().getActivityParticipantService().countObjByFilter(apc) > 0) {// 已报名
			isjoin = false;
			isattenflag = false;
		}
		// 转发统计
		ActivityPrint forward = new ActivityPrint();
		forward.setActivityid(id);
		forward.setType("forward");
		List<ActivityPrint> pList = cRMService.getDbService().getActivityPrintService().searchActivityPrintList(forward);
		int forwardcount = 0;
		if (null != pList && pList.size() > 0) {
			forwardcount = pList.size();
			// 统计次数
			//影响力还没想好，暂时不放开
//			for (int i = 0; i < pList.size(); i++) {
//				forward = pList.get(i);// 全部转发次数
//				forward.setForwardcount(countForward(pList,forward.getForwardid()));// 转发人转发的次数（一级人脉）
//			}
		}
		String errorCode = "";
		// 判断当前登录人是否可以查看统计信息(团队成员都可以看到)
		if (!(sourceid).equals(act.getCreateBy())) {
			errorCode = cRMService.getDbService().getActivityService().isTeamMembers(id, openId ,act.getCreateBy());
			if ("0".equals(errorCode)) {
				request.setAttribute("authority", "Y");
				request.setAttribute("temaflag", "Y");
				isattenflag = false;
			} else {
				request.setAttribute("authority", "N");
				//再判断当前用户是否为上级
				//获取当前的crmid
				String crmId = cRMService.getSugarService().getActivity2CrmService().getCrmIdByOrgId(UserUtil.getCurrUser(request).getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
				UserReq uReq  = new UserReq();
				uReq.setCrmaccount(crmId);
				uReq.setCurrpage("1");
				uReq.setPagecount("9999");
				uReq.setFlag("");
				uReq.setOpenId(openId);
				uReq.setOrgId(orgId);
				UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
				if(null == uResp || null == uResp.getUsers() || uResp.getUsers().size() == 0){
					request.setAttribute("authority", "N");
				}
				else
				{
					List<UserAdd> userList1 = uResp.getUsers();
					boolean isLead = false;
					for(int i=0;i<userList1.size();i++){
						if(userList1.get(i).getUserid().equals(act.getCrmId())){
							isLead = true;
							break;
						}
					}
					if(isLead){//领导
						request.setAttribute("authority", "Y");
					}
				}
				//end
			}
		} else if ((sourceid).equals(act.getCreateBy())) {
			errorCode = "0";
			request.setAttribute("authority", "Y");
		}
		if(isattenflag){
			//判断是否关注过此活动--2015-04-17
			Activity_Rela activity_Rela = new Activity_Rela();
			activity_Rela.setActivity_id(id);
			activity_Rela.setRela_type("NoticeActivityType");
			activity_Rela.setRela_id(openId);
			List<Activity_Rela> list = activity_RelaService.findActivity_RelaListByFilter(activity_Rela);
			if(null==list||list.size()==0){
				request.setAttribute("isatten", "notatten");
			}
		}
		String remark = act.getRemark();
		if (StringUtils.isNotNullOrEmptyStr(remark) && remark.contains("\n")) {
			act.setRemark(remark.replace("\n", ""));
			if(remark.contains("\r")){
				act.setRemark(act.getRemark().replace("\r", ""));
			}
		}
		if("0".equals(errorCode)) {
			request.setAttribute("shareusers",getList(sourceid, id, "Activity", openId,act));
			if ("wkshare".equals(source) || "share".equals(flag)|| "dtshare".equals(flag)) {
				if (!sourceid.equals(act.getCreateBy())) {
					request.setAttribute("teamaddflag", "N");
				}
			}
		}
		// 查询当前活动下的活动资料(暂时没有pc端，所以不支持上传附件)
		// List<Attachment> list =
		// attachmentService.getActivityAttachmentListByActId(id);
		// request.setAttribute("attlist", list);
		//获取活动的下拉列表
		Map<String, Map<String, String>> lovMap = cRMService.getDbService().getLovService().getLovList(null);
		Map<String, String> chaMap = lovMap.get("lov_charge_type");
		request.setAttribute("charge_type_value", chaMap.get(act.getCharge_type()));
		//推荐活动
		List<Activity> actList = new ArrayList<Activity>();
		Activity recommact = new Activity();
		recommact.setCurrpages(0);
		recommact.setPagecounts(9);
		actList = cRMService.getDbService().getActivityService().searchGroomActivity(recommact);
		//设置消息标志为已读
		Messages msg = new Messages();
		msg.setTargetUId(UserUtil.getCurrUser(request).getParty_row_id());
		msg.setRelaId(id);
		cRMService.getDbService().getMessagesService().updateMessagesFlag(msg);
		//附件
		List<Attachment> attList = cRMService.getDbService().getAttachmentService().getActivityAttachmentListByActId(id);
		request.setAttribute("attList", attList);
		request.setAttribute("actList", actList);
		request.setAttribute("forwardcount", forwardcount);
		request.setAttribute("activity", act);
		request.setAttribute("optype", optype);
		request.setAttribute("visit", visitCount);
		request.setAttribute("praise", praiseCount);
		request.setAttribute("ispraise", ispraise);
		request.setAttribute("id", id);
		request.setAttribute("appcontent",PropertiesUtil.getAppContext("app.content"));
		request.setAttribute("appid",PropertiesUtil.getAppContext("wxcrm.appid"));
		request.setAttribute("participantlist", participantList);
		request.setAttribute("publicId",PropertiesUtil.getAppContext("app.publicId"));
		request.setAttribute("praiselist", praiseList);
		request.setAttribute("sourceid", sourceid);
		request.setAttribute("source", source);
		request.setAttribute("isjoin", isjoin);
		request.setAttribute("flag", flag);
		request.setAttribute("orgId", orgId);
		String ossImgPath = "http://" + PropertiesUtil.getAppContext("aliyun.oss.bucket.pic").concat(".").concat(PropertiesUtil.getAppContext("aliyun.oss.endpoint")).concat("/");
		//request.setAttribute("zjwk_file_service", PropertiesUtil.getAppContext("zjmarketing.file.service.userpath"));
		request.setAttribute("zjwk_file_service", ossImgPath);
		return "activity/detail";
		
	}
	
	/**
	 * 指尖聚会详情
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/meetdetail")
	public String meetdetail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ZJWKUtil.getRequestURL(request);// 获取请求的url
		// openId publicId
		String id = request.getParameter("id");
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		String flag = request.getParameter("flag");
		String openId = UserUtil.getCurrUser(request).getOpenId();
		// 从消息进来
		if (!StringUtils.isNotNullOrEmptyStr(sourceid)&& "wkshare".equals(source)) {
			//SourceObject obj1 = cRMService.getDbService().getSourceObject2SourceSystemService().getSourceObject(openId, "share");
			//sourceid = obj1.getSourceid();
			sourceid = UserUtil.getCurrUser(request).getParty_row_id();
		}
		// 直接分享链接进来（20150128修改）
		if ("dtshare".equals(flag)) {
			Cookie[] cookies = request.getCookies();
			if (cookies != null && cookies.length > 0) {
				boolean cookieflag = false;
				for (int i = 0; i < cookies.length; i++) {
					String key = cookies[i].getName();
					if (Constants.ACTIVITY_PARTYID.equals(key)	&& StringUtils.isNotNullOrEmptyStr(cookies[i].getValue())) {
						cookieflag = true;
						sourceid = cookies[i].getValue();
						break;
					}
				}
				if (!cookieflag) {
					return "redirect:https://open.weixin.qq.com/connect/oauth2/authorize?appid="+ PropertiesUtil.getAppContext("wxcrm.appid")+ "&redirect_uri="+ URLEncoder.encode((PropertiesUtil.getAppContext("app.content")	+ "/zjwkactivity/share?id="+ id+ "&fopenId=" + sourceid+"&type=meet"), "UTF-8")+ "&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect";
				}
			} else {
				return "redirect:https://open.weixin.qq.com/connect/oauth2/authorize?appid="+ PropertiesUtil.getAppContext("wxcrm.appid")+ "&redirect_uri="+ URLEncoder.encode((PropertiesUtil.getAppContext("app.content")	+ "/zjwkactivity/share?id=" + id+ "&fopenId=" + sourceid+"&type=meet"), "UTF-8")+ "&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect";
			}
		}
		// 20150313修改
		if ("newshare".equals(flag)) {
			return "redirect:/zjwkactivity/new_meetdetail?id=" + id;
		}
		// 从RM进来查看活动详情
		String orgId = request.getParameter("orgId");
		if (!StringUtils.isNotNullOrEmptyStr(orgId)) {
			orgId = (String) RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+ id);
		}
		// 从WK进来查看活动详情
		String crmId = request.getParameter("crmId");
		if (sourceid == null) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		if (null == id || "".equals(id)) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		if (null == act || "".equals(act.getId())) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001007 + "，错误描述："+ErrCode.ERR_MSG_1001007);
		}
		
		SourceObject obj1 = cRMService.getDbService().getSourceObject2SourceSystemService().getSourceObject(sourceid, source);
		if (null != obj1) {
			request.setAttribute("currusername", obj1.getNickName());
		}
		String optype = "";
		if ((sourceid).equals(act.getCreateBy())) {
			optype = "owner";
		}
		ActivityParticipant apc = new ActivityParticipant();
		apc.setActivityid(id);
		apc.setOrderByString(" order by create_date ");
		List<Participant> paList = cRMService.getDbService().getParticipantService().getParticipantListByActivity(apc);// 报名列表
		List<Participant> participantList = new ArrayList<Participant>();
		// 从微客端获取好友列表
		List<UserRela> userList = getRelaUserId(sourceid);
		for (Participant participant : paList) {
			for (UserRela userRela : userList) {
				if (userRela.getRela_user_id().equals(participant.getSourceid())) {
					participant.setFlag("Y");
				}
			}
			participantList.add(participant);
		}
		request.setAttribute("userList", participantList);
		// 当前用户是否已经报名
		apc.setSourceid(sourceid);
		boolean isjoin = true;// 是否可以报名
		if (cRMService.getDbService().getActivityParticipantService().countObjByFilter(apc) > 0) {// 已报名
			isjoin = false;
		}
		if ("owner".equals(optype)) {
			isjoin = false;
		}
		String remark = act.getRemark();
		if (StringUtils.isNotNullOrEmptyStr(remark) && remark.contains("\n")) {
			act.setRemark(remark.replace("\n", ""));
			if(remark.contains("\r")){
				act.setRemark(act.getRemark().replace("\r", ""));
			}
		}
		if (StringUtils.isNotNullOrEmptyStr(act.getContent()) && act.getContent().contains("\n")) {
			act.setContent(act.getContent().replace("\n", "<br/>"));
			if(act.getContent().contains("\r")){
				act.setContent(act.getContent().replace("\r", "<br/>"));
			}
		}
		// 判断当前登录人是否可以查d看统计信息(团队成员都可以看到)
		if (!(sourceid).equals(act.getCreateBy())) {
			String errorCode = cRMService.getDbService().getActivityService().isTeamMembers(id, openId ,act.getCreateBy());
			if ("0".equals(errorCode)) {
				request.setAttribute("authority", "Y");
			} else {
				//当前用户是否为该工作计划的上级
				UserReq uReq  = new UserReq();
				uReq.setCrmaccount(crmId);
				uReq.setCurrpage("1");
				uReq.setPagecount("9999");
				uReq.setFlag("");
				uReq.setOpenId(openId);
				uReq.setOrgId(orgId);
				UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
				if(null == uResp || null == uResp.getUsers() || uResp.getUsers().size() == 0){
					request.setAttribute("authority", "N");
				}else{
					List<UserAdd> userList02 = uResp.getUsers();
					boolean isLead = false;
					for(int i=0;i<userList02.size();i++){
						if(userList02.get(i).getUserid().equals(act.getCrmId())){
							isLead = true;
							break;
						}
					}
					if(isLead){//领导
						request.setAttribute("authority", "Y");
					}
				}
				
			}
		} else if ((sourceid).equals(act.getCreateBy())) {
			request.setAttribute("authority", "Y");
		}
		
		
		request.setAttribute("activity", act);
		request.setAttribute("optype", optype);
		request.setAttribute("id", id);
		request.setAttribute("appcontent",PropertiesUtil.getAppContext("app.content"));
		request.setAttribute("appid",PropertiesUtil.getAppContext("wxcrm.appid"));
		request.setAttribute("participantlist", participantList);
		request.setAttribute("publicId",PropertiesUtil.getAppContext("app.publicId"));
		request.setAttribute("sourceid", sourceid);
		request.setAttribute("source", source);
		request.setAttribute("isjoin", isjoin);
		request.setAttribute("flag", flag);
		request.setAttribute("orgId", orgId);
		request.setAttribute("openId", openId);
		request.setAttribute("crmId", crmId);
		return "activity/meetdetail";
	}
	
	/**
	 * 指尖聚会（不需要授权，直接查看）2015-03-19修改
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/new_meetdetail")
	public String new_meetdetail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ZJWKUtil.getRequestURL(request);// 获取请求的url
		// openId publicId
		String id = request.getParameter("id");
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		if (null == act || "".equals(act.getId())) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001007 + "，错误描述："+ErrCode.ERR_MSG_1001007);
		}
		
		Cookie[] cookies = request.getCookies();
		String sourceid = "";
		if (cookies != null && cookies.length > 0) {
			boolean cookieflag = false;
			for (int i = 0; i < cookies.length; i++) {
				String key = cookies[i].getName();
				if (Constants.ACTIVITY_PARTYID.equals(key)&& StringUtils.isNotNullOrEmptyStr(cookies[i].getValue())) {
					cookieflag = true;
					sourceid = cookies[i].getValue();
					break;
				}
			}
			if (cookieflag) {
				return "redirect:/zjwkactivity/meetdetail?id=" + id + "&sourceid="+ sourceid;
			}
		}
		boolean isjoin = true;
		long endtime = DateTime.dateTimeParse(act.getEnd_date(),DateTime.DateFormat1);
		long currtime = System.currentTimeMillis();
		if (currtime > endtime) {// 截止日期
			isjoin = false;
		}
		request.setAttribute("isjoin",isjoin);
		ActivityParticipant apc = new ActivityParticipant();
		apc.setActivityid(id);
		apc.setOrderByString(" order by create_date ");
		List<Participant> paList = cRMService.getDbService().getParticipantService().getParticipantListByActivity(apc);// 报名列表
		String remark = act.getRemark();
		if (StringUtils.isNotNullOrEmptyStr(remark) && remark.contains("\n")) {
			act.setRemark(remark.replace("\n", ""));
			if(remark.contains("\r")){
				act.setRemark(act.getRemark().replace("\r", ""));
			}
		}
		if (StringUtils.isNotNullOrEmptyStr(act.getContent()) && act.getContent().contains("\n")) {
			act.setContent(act.getContent().replace("\n", "<br/>"));
			if(act.getContent().contains("\r")){
				act.setContent(act.getContent().replace("\r", "<br/>"));
			}
		}
		//2015-04-13统计转发次数
		ActivityPrint item = new ActivityPrint();
		item.setActivityid(id);
		item.setType("forward");
		item.setSource("WK");
		item.setSourceid(sourceid);
		cRMService.getDbService().getActivityPrintService().addObj(item);
		request.setAttribute("type", request.getParameter("type"));
		request.setAttribute("activity", act);
		request.setAttribute("id", id);
		request.setAttribute("appcontent",PropertiesUtil.getAppContext("app.content"));
		request.setAttribute("appid",PropertiesUtil.getAppContext("wxcrm.appid"));
		request.setAttribute("publicId",PropertiesUtil.getAppContext("app.publicId"));
		request.setAttribute("participantlist", paList);
		return "activity/new_meetdetail";
	}

	/**
	 * 指尖活动（不需要授权，直接查看）2015-03-13修改
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/new_detail")
	public String new_detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ZJWKUtil.getRequestURL(request);// 获取请求的url
		// openId publicId
		String id = request.getParameter("id");
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		if (null == act || "".equals(act.getId())) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001007 + "，错误描述："+ErrCode.ERR_MSG_1001007);
		}
		
		Cookie[] cookies = request.getCookies();
		String sourceid = "";
		if (cookies != null && cookies.length > 0) {
			boolean cookieflag = false;
			for (int i = 0; i < cookies.length; i++) {
				String key = cookies[i].getName();
				if (Constants.ACTIVITY_PARTYID.equals(key)&& StringUtils.isNotNullOrEmptyStr(cookies[i].getValue())) {
					cookieflag = true;
					sourceid = cookies[i].getValue();
					break;
				}
			}
			if (cookieflag) {
				return "redirect:/zjwkactivity/detail?id=" + id + "&sourceid="+ sourceid;
			}
		}
		// 查询已访问数
		ActivityPrint ap = new ActivityPrint();
		ap.setActivityid(id);
		ap.setType("VISIT");
		int visitCount = cRMService.getDbService().getActivityPrintService().countObjByFilter(ap);
		visitCount += 1;
		cRMService.getDbService().getActivityPrintService().addObj(ap);
		// 点赞统计
		ActivityPrint ap2 = new ActivityPrint();
		ap2.setActivityid(id);
		ap2.setType("PRAISE");
		int praiseCount = cRMService.getDbService().getActivityPrintService().countObjByFilter(ap2);
		List<ActivityPrint> praiseList = cRMService.getDbService().getActivityPrintService().searchActivityPrintList(ap2);// 点赞列表
		ActivityParticipant apc = new ActivityParticipant();
		apc.setActivityid(id);
		apc.setOrderByString(" order by create_date ");
		List<Participant> paList = cRMService.getDbService().getParticipantService().getParticipantListByActivity(apc);// 报名列表
		String remark = act.getRemark();
		if (StringUtils.isNotNullOrEmptyStr(remark) && remark.contains("\n")) {
			act.setRemark(remark.replace("\n", ""));
			if(remark.contains("\r")){
				act.setRemark(act.getRemark().replace("\r", ""));
			}
		}
		// 转发统计
		ActivityPrint forward = new ActivityPrint();
		forward.setActivityid(id);
		forward.setType("forward");
		List<ActivityPrint> pList = cRMService.getDbService().getActivityPrintService().searchActivityPrintList(forward);
		int forwardcount = 0;
		if (null != pList && pList.size() > 0) {
			forwardcount = pList.size();
			// 统计次数
			for (int i = 0; i < pList.size(); i++) {
				forward = pList.get(i);// 全部转发次数
				if(StringUtils.isNotNullOrEmptyStr(forward.getForwardid())){
					forward.setForwardcount(countForward(pList,forward.getForwardid()));// 转发人转发的次数（一级人脉）
				}
			}
		}
		boolean isjoin = true;
		long endtime = DateTime.dateTimeParse(act.getEnd_date(),DateTime.DateFormat1);
		long currtime = System.currentTimeMillis();
		if (currtime > endtime) {// 截止日期
			isjoin = false;
		}
		
		//推荐活动
		List<Activity> actList = new ArrayList<Activity>();
		Activity recommact = new Activity();
		recommact.setCurrpages(0);
		recommact.setPagecounts(9);
		actList = cRMService.getDbService().getActivityService().searchGroomActivity(recommact);
			
		request.setAttribute("actList", actList);
		
		//2015-04-13统计转发次数
		ActivityPrint item = new ActivityPrint();
		item.setActivityid(id);
		item.setType("forward");
		item.setSource("WK");
		item.setSourceid(sourceid);
		cRMService.getDbService().getActivityPrintService().addObj(item);
		
		//附件
		List<Attachment> attList = cRMService.getDbService().getAttachmentService().getActivityAttachmentListByActId(id);
		request.setAttribute("type", request.getParameter("type"));
		request.setAttribute("attList", attList);
		request.setAttribute("activity", act);
		request.setAttribute("visit", visitCount);
		request.setAttribute("praise", praiseCount);
		request.setAttribute("id", id);
		request.setAttribute("appcontent",PropertiesUtil.getAppContext("app.content"));
		request.setAttribute("appid",PropertiesUtil.getAppContext("wxcrm.appid"));
		request.setAttribute("publicId",PropertiesUtil.getAppContext("app.publicId"));
		request.setAttribute("praiselist", praiseList);
		request.setAttribute("isjoin", isjoin);
		request.setAttribute("forwardcount", forwardcount);
		request.setAttribute("participantlist", paList);
		String ossImgPath = "http://" + PropertiesUtil.getAppContext("aliyun.oss.bucket.pic").concat(".").concat(PropertiesUtil.getAppContext("aliyun.oss.endpoint")).concat("/");
		//request.setAttribute("zjwk_file_service", PropertiesUtil.getAppContext("zjmarketing.file.service.userpath"));
		request.setAttribute("zjwk_file_service", ossImgPath);
		return "activity/new_detail";
	}

	public List<ShareAdd> getList(String sourceid, String rowId,String parenttype, String openId,Activity act) {
		if (!StringUtils.isNotNullOrEmptyStr(openId)) {
			WxuserInfo atten_wxuser = new WxuserInfo();
			atten_wxuser.setParty_row_id(sourceid);
			openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(atten_wxuser).getOpenId();
		}
		String orgId = (String) RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID + rowId);
		String crmId = "";
		if(!StringUtils.isNotNullOrEmptyStr(orgId)){
			orgId = act.getOrgId();
		}
		
		if (StringUtils.isNotNullOrEmptyStr(orgId)) {
			crmId = cRMService.getDbService().getActivityService().getCrmIdByOrgId(openId,PropertiesUtil.getAppContext("app.publicId"), orgId);
		}
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			crmId = act.getCrmId();
		}
		Share share = new Share();
		share.setParentid(rowId);
		share.setParenttype(parenttype);
		share.setCrmId(crmId);
		ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
		List<ShareAdd> sharelist = sresp.getShares();
		List<ShareAdd> shareAdds = new ArrayList<ShareAdd>();
		for (ShareAdd shareObj : sharelist) {
			if (crmId.equals(shareObj.getShareuserid())) {
				shareObj.setFlag("N");
			}
			shareAdds.add(shareObj);
		}

		return shareAdds;
	}

	// 统计转发次数
	private int countForward(List<ActivityPrint> pList, String forwardid) {
		int count = 0;
		ActivityPrint item = null;
		for (int i = 0; i < pList.size(); i++) {
			item = pList.get(i);
			if (item.getForwardid().equals(forwardid)) {
				count++;
			}
		}
		return count;
	}

	/**
	 * 活动统计
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/count")
	public String count(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String id = request.getParameter("id");
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		String orgId = request.getParameter("orgId");
		// 转发次数
		String number = request.getParameter("number");
		if (!StringUtils.isNotNullOrEmptyStr(number)) {
			number = "0";
		}
		if (sourceid == null) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		if (null == id || "".equals(id)) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		if (null == act || "".equals(act.getId())) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001002 + "，错误描述："+ ErrCode.ERR_CODE_1001002_MSG);
		}
		// 参与人列表
		ActivityParticipant apc = new ActivityParticipant();
		apc.setActivityid(id);
		List<Participant> paList = cRMService.getDbService().getParticipantService().getParticipantListByActivity(apc);// 报名列表
		List<Participant> participantList = new ArrayList<Participant>();
		// 从微客端获取好友列表
		List<UserRela> urelaList = getRelaUserId(sourceid);
		for (Participant participant : paList) {
			for (UserRela userRela : urelaList) {
				if (userRela.getRela_user_id().equals(participant.getSourceid())) {
					participant.setFlag("Y");
				}
			}
			participantList.add(participant);
		}
		// 转发统计
		ActivityPrint forward = new ActivityPrint();
		forward.setActivityid(id);
		forward.setType("PRAISE");
		List<ActivityPrint> apList = cRMService.getDbService().getActivityPrintService().searchActivityPrintList(forward);
		forward.setType(null);
		List<ActivityPrint> tmpList = cRMService.getDbService().getActivityPrintService().searchActivityPrintListById(forward);
		Map<String, ActivityPrint> tmpUserList = new HashMap<String, ActivityPrint>();
		for (ActivityPrint activityPrint : tmpList) {
			// tmpUserList.put(wxuserInfo.getOpenId(),wxuserInfo);
			tmpUserList.put(activityPrint.getSourceid(), activityPrint);
		}
		forward.setType("forward");
		List<ActivityPrint> pList = cRMService.getDbService().getActivityPrintService().searchActivityPrintList(forward);
		int forwardcount = 0;
		String nodes = "[";
		String links = "[";
		int mcount = 0;
		if (null != pList && pList.size() > 0) {
			// 根据sourceid查找第一个
			for (int i = 0; i < pList.size(); i++) {
				forward = pList.get(i);
				if (forward.getForwardid().equals(sourceid)) {
					mcount++;
				}
			}

			if (sourceid.equals(act.getCreateBy())) {
				nodes += "{category:0, name: '" + act.getCreateName()+ "', value : 10, label: '" + act.getCreateName()+ "\\n（" + mcount + "次）'}";
			} else {
				ActivityPrint wu = null;
				if (null != tmpUserList.get(sourceid)) {
					wu = tmpUserList.get(sourceid);
					nodes += "{category:0, name: '" + wu.getSourcename()+ "', value : 10, label: '" + wu.getSourcename()+ "\\n（" + mcount + "次）'}";
				}
			}

			// 查找下级
			ActivityPrint forward1 = null;
			for (int i = 0; i < pList.size(); i++) {
				forward = pList.get(i);
				mcount = 0;
				for (int j = 0; j < pList.size(); j++) {
					forward1 = pList.get(j);
					if (forward1.getForwardid().equals(forward.getSourceid())) {
						mcount++;
					}
				}
				if (StringUtils.isNotNullOrEmptyStr(forward.getSourceid())&& mcount >= Integer.parseInt(number)) {
					String nickname = null;
					ActivityPrint wu = null;
					if (null != tmpUserList.get(forward.getSourceid())) {
						wu = tmpUserList.get(forward.getSourceid());
						nickname = wu.getSourcename();
						nodes += ",{category:0, name: '" + nickname+ "', value : 10, label: '" + nickname + "\\n（"+ mcount + "次）'}";
					}
					if (forward.getForwardid().equals(act.getCreateBy())) {
						if (!links.equals("[")) {
							links += ",";
						}
						links += "{source : '" + nickname + "', target : '"+ act.getCreateName() + "', weight : 10}";
					} else {
						if (null != tmpUserList.get(forward.getForwardid())) {
							wu = tmpUserList.get(forward.getForwardid());
							if (!links.equals("[")) {
								links += ",";
							}
							links += "{source : '" + nickname + "', target : '"+ wu.getSourcename() + "', weight : 10}";
						}
					}
				}
			}
		}
		nodes += "]";
		links += "]";
		// 获取用户绑定的org列表
		List<Organization> orgList = cRMService.getDbService().getSourceObject2SourceSystemService().getOrgList(sourceid, orgId);
		request.setAttribute("orgList", orgList);
		// 组装查询参数
		Messages obj = new Messages();
		obj.setRelaId(id);
		obj.setCurrpages(Integer.parseInt("0"));
		obj.setPagecounts(Integer.parseInt("9999999"));
		// 调用后台查询数据库
		List<Messages> mlist = (List<Messages>) cRMService.getDbService().getMessagesService().findObjListByFilter(obj);
		request.setAttribute("apList", apList);
		request.setAttribute("msgList", mlist);
		request.setAttribute("id", id);
		request.setAttribute("act", act);
		request.setAttribute("sourceid", sourceid);
		request.setAttribute("participantList", participantList);
		request.setAttribute("pList", pList);
		request.setAttribute("forwardcount", forwardcount);
		request.setAttribute("nodes", nodes);
		request.setAttribute("links", links);
		request.setAttribute("orgId", orgId);
		return "activity/count";
	}

	@RequestMapping("/share")
	public String share(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// openId publicId
		String code = request.getParameter("code");
		String guestOpenId = "";
		String unioid = "";
		String soucername = "";
		String partyId = "";
		if (null != code && !"".equals(code)) {
			AuthorizeInfo auth = WxUtil.getAccessToken(Constants.APPID,Constants.APPSECRET, code);
			// refresh
			AuthorizeInfo authRefresh = WxUtil.refreshToken(Constants.APPID,auth.getRefreshToken());
			// 获取微信用户信息
			UserInfo u = WxUtil.getSnsUserinfo(authRefresh.getOpenId(),authRefresh.getAccessToken());
			request.setAttribute("openId", u.getOpenId());
			request.setAttribute("nickName", u.getNickname());
			WxuserInfo wxu = new WxuserInfo();
			wxu.setOpenId(u.getOpenId());
			wxu.setNickname(u.getNickname());
			wxu.setHeadimgurl(u.getHeadImgurl());
			wxu.setCity(u.getCity());
			wxu.setCountry(u.getCountry());
			wxu.setLanguage(u.getLanguage());
			wxu.setUnionid(u.getUnionid());
			wxu.setSex(u.getSex() + "");
			soucername = u.getNickname();
			wxu.setProvince(u.getProvince());
			if (StringUtils.isNotNullOrEmptyStr(u.getUnionid())) {
				wxu.setUnionid(u.getUnionid());
			} else {
				wxu.setUnionid(auth.getOpenId());
			}
			unioid = wxu.getUnionid();
			logger.info("------------union--------" + unioid);
			// 获取缓存的partyid
			partyId = RedisCacheUtil.getString("ZJACC_UNIONID_" + unioid);
			// 是否关注
			// boolean isAtten =false;
			logger.info("------------partyId--------" + partyId);
			if (!StringUtils.isNotNullOrEmptyStr(partyId)) {
				// 创建指尖账户
				// partyId = createPartyAccount(unioid);
				//partyId = createPartyAccountSec(u.getOpenId(), unioid);
				partyId = cRMService.getWxService().getWxUserinfoService().synchroUserData(u.getOpenId(), unioid, "mkshare");
				logger.info("------------partyId2--------" + partyId);
				if (!StringUtils.isNotNullOrEmptyStr(partyId)) {
					partyId = unioid;
					logger.info("------------partyId3--------" + partyId);
				}
				// isAtten = true;
			}
			wxu.setParty_row_id(partyId);
			// 缓存到cookie
			Cookie cookie1 = new Cookie(Constants.ACTIVITY_UNIOD, unioid);
			Cookie cookie2 = new Cookie(Constants.ACTIVITY_PARTYID, partyId);
			cookie1.setMaxAge(Integer.parseInt(PropertiesUtil.getAppContext("activity.cookie.time")));
			cookie2.setMaxAge(Integer.parseInt(PropertiesUtil.getAppContext("activity.cookie.time")));
			response.addCookie(cookie1);
			response.addCookie(cookie2);
			cRMService.getWxService().getWxUserinfoService().saveOrUptUserInfo(wxu);
			guestOpenId = wxu.getOpenId();
			logger.info("------------save--------1111111111" + partyId);
		}

		String id = request.getParameter("id");
		// 如果是分享后进来的，记录日志
		String fopenId = request.getParameter("fopenId");
		if (StringUtils.isNotNullOrEmptyStr(fopenId)) {
			ActivityPrint item = new ActivityPrint();
			item.setActivityid(id);
			item.setOpenId(guestOpenId);
			item.setSourceid(partyId);
			item.setSourcename(soucername);
			item.setType("forward");
			item.setForwardid(fopenId);
			cRMService.getDbService().getActivityPrintService().addObj(item);
		}
		String type = request.getParameter("type");
		String return_url = request.getParameter("return_url");
		//
		logger.info("------ZjwkActivityController ----> share ---> return_url" + return_url);
		if(StringUtils.isNotNullOrEmptyStr(return_url)){
			return "redirect:"+return_url+"&sourceid="+partyId+"&source=WK";
		}else{
			if("meet".equals(type)){
				return "redirect:/zjwkactivity/meetdetail?flag=share&id=" + id+ "&source=WX&sourceid=" + partyId;
			}else{
				return "redirect:/zjwkactivity/detail?flag=share&id=" + id+ "&source=WX&sourceid=" + partyId;
			}
		}
	}

	/**
	 * 创建指尖账户
	 * 
	 * @param unionid
	 * @return
	 */
	public String createPartyAccount(String unionid) {
		if (org.apache.commons.lang.StringUtils.isBlank(unionid)) {
			return "";
		}
		logger.info(" unionid => " + unionid);
		// 调用指尖统一账户，建立账户
		String url = PropertiesUtil.getAppContext("zjsso.url")+ "/out/sso/account_create/" + unionid;
		logger.info(" 建立统一账户 => " + url);
		// 单次调用sugar接口
		Map<String, String> paramaps = new HashMap<String, String>();
		// 调用
		String invokrst = "{\"errorCode\":\"-1\"}";
		try {
			invokrst = cRMService.getWxService().getWxHttpConUtil().postKeyValueData(url, paramaps);
		} catch (Exception e1) {
			logger.info(" exception => " + e1.getMessage());
		}
		logger.info(" invokrst => " + invokrst);
		JSONObject invokObj = JSONObject.fromObject(invokrst);
		String party_user_id = "";
		if ("0".equals(invokObj.getString("errorCode"))) {
			party_user_id = invokObj.getString("user_id");
		}
		return party_user_id;
	}

	/**
	 * 创建指尖账户
	 * 
	 * @param unionid
	 * @return
	 */
	public String createPartyAccountSec(String openId, String unionid) {
		if (org.apache.commons.lang.StringUtils.isBlank(openId)) {
			return "";
		}
		logger.info(" openId => " + openId);
		logger.info(" unionid => " + unionid);
		// 调用指尖统一账户，建立账户
		String url = PropertiesUtil.getAppContext("zjsso.url")+ "/out/zjaccount_create";
		logger.info("createPartyAccountSec  建立统一指尖账户 => " + url);
		// 单次调用sugar接口
		Map<String, String> paramaps = new HashMap<String, String>();
		paramaps.put("openId", openId);
		paramaps.put("unionId", unionid);
		// 调用
		String invokrst = "{\"errorCode\":\"-1\"}";
		try {
			invokrst = cRMService.getWxService().getWxHttpConUtil().postKeyValueData(url, paramaps);
		} catch (Exception e1) {
			logger.info(" exception => " + e1.getMessage());
		}
		logger.info(" invokrst => " + invokrst);
		JSONObject invokObj = JSONObject.fromObject(invokrst);
		String crmId = invokObj.getString("crmId");
		String party_user_id = invokObj.getString("party_user_id");
		logger.info(" crmId => " + crmId);
		logger.info(" party_user_id => " + party_user_id);
		return party_user_id;
	}

	/**
	 * 根据partyId得到好友列表
	 * 
	 * @param partyId
	 * @return
	 */
	public List<UserRela> getRelaUserId(String partyId) {
		// 威客好友
		UserRela userRela = new UserRela();
		userRela.setUser_id(partyId);
		userRela.setCurrpages(0);
		userRela.setPagecounts(9999);
		List<UserRela> userRelaList = (List<UserRela>) cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);
		Map<String, UserRela> newMargeRelaList = new HashMap<String, UserRela>();
		// 威客关联用户
		for (int j = 0; j < userRelaList.size(); j++) {
			UserRela sUr = userRelaList.get(j);
			String sUserId = sUr.getUser_id();
			String sReUserId = sUr.getRela_user_id();
			if (!newMargeRelaList.keySet().contains(sReUserId)) {
				newMargeRelaList.put(sReUserId, sUr);
			}
		}
		List<UserRela> rstUr = new ArrayList<UserRela>();
		Set<Map.Entry<String, UserRela>> entryseSet = newMargeRelaList.entrySet();
		for (Map.Entry<String, UserRela> entry : entryseSet) {
			UserRela ur = entry.getValue();
			rstUr.add(ur);
		}
		return rstUr;
	}

	/**
	 * 市场活动详情（JSON）
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/syncdetail")
	@ResponseBody
	public String syncdetail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// openId publicId
		String id = request.getParameter("id");
		if (null == id || "".equals(id)) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}

		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);

		if (null == act || "".equals(act.getId())) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001002 + "，错误描述："+ ErrCode.ERR_CODE_1001002_MSG);
		}

		ActivityParticipant apc = new ActivityParticipant();
		apc.setActivityid(id);
		List<Participant> participantList = cRMService.getDbService().getParticipantService().getParticipantListByActivity(apc);

		act.setpList(participantList);

		return JSONObject.fromObject(act).toString();
	}

	/**
	 * 添加活动项
	 * 
	 * @param item
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveitem")
	@ResponseBody
	public String addItem(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// openId publicId
		String content = request.getParameter("content");
		if (content == null || "".equals(content.trim())) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		String start_date = request.getParameter("start_date");
		String end_date = request.getParameter("end_date");
		String experts = request.getParameter("experts");
		if (experts != null && !"".equals(experts.trim())) {
			experts = new String(experts.getBytes("ISO-8859-1"), "UTF-8");
		}
		content = new String(content.getBytes("ISO-8859-1"), "UTF-8");
		String activity_id = request.getParameter("activity_id");
		ActivityItem item = new ActivityItem();
		item.setActivity_id(activity_id);
		item.setContent(content);
		item.setStart_date(start_date);
		item.setEnd_date(end_date);
		item.setExperts(experts);
		boolean flag = cRMService.getDbService().getActivityService().addActivityItem(item);

		if (!flag) {
			return "-1";
		}
		return "0";
	}

	/**
	 * 添加活动印迹
	 * 
	 * @param item
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savePrint")
	@ResponseBody
	public String addPrint(ActivityPrint item, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// openId publicId
		String sourceid = request.getParameter("sourceid");
		String source = request.getParameter("source");
		if (sourceid == null) {
			throw new Exception("错误编号：" + ErrCode.ERR_CODE_1001001 + "，错误描述："+ ErrCode.ERR_CODE_1001001_MSG);
		}
		// if("WX".equals(source)){
		// WxuserInfo wuInfo = new WxuserInfo();
		// wuInfo.setParty_row_id(sourceid);
		// List<?> wuList = cRMService.getWxService().getWxUserinfoService().findObjListByFilter(wuInfo);
		// if(null != wuList && wuList.size() > 0){
		// wuInfo = (WxuserInfo)wuList.get(0);
		// request.setAttribute("username", wuInfo.getNickname());
		// request.setAttribute("headimgurl", wuInfo.getHeadimgurl());
		// }else{
		// wuInfo.setNickname("匿名用户");
		// }
		// item.setSourcename(wuInfo.getNickname());
		// }else{
		// SourceObject obj=
		// cRMService.getDbService().getSourceObject2SourceSystemService().getSourceObject(sourceid, source);
		// item.setSourcename(obj.getNickName());
		// }
		logger.info("活动点赞 sourceid ====>" + sourceid);
		SourceObject obj = cRMService.getDbService().getSourceObject2SourceSystemService().getSourceObject(sourceid, null);
		item.setSourcename(obj.getNickName());
		item.setSource(source);
		item.setSourceid(sourceid);
		ActivityPrint ap2 = new ActivityPrint();
		ap2.setActivityid(item.getActivityid());
		ap2.setType("PRAISE");
		ap2.setSource(source);
		ap2.setSourceid(sourceid);
		if (!StringUtils.isNotNullOrEmptyStr(item.getSourcename())|| "匿名用户".equals(item.getSourcename())) {
			return "-1";
		}
		if (cRMService.getDbService().getActivityPrintService().countObjByFilter(ap2) > 0) {// 已点赞
			return "-1";
		} else {
			String flag = cRMService.getDbService().getActivityPrintService().addObj(item);
			if ("-1".equals(flag)) {
				return "-1";
			} else {
				return item.getSourcename();
			}
		}
	}

	/**
	 * 异步更新活动标志
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/syncupdact")
	@ResponseBody
	public String syncupdact(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Activity act = new Activity();
		String id = request.getParameter("id");
		act = cRMService.getDbService().getActivityService().updActFlag(id);
		String str = JSONArray.fromObject(act).toString();
		logger.info("ActivityController --> list --> " + str);
		return str;
	}

	/**
	 * 在互直播
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/online")
	public String online(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Activity act = new Activity();
		String sourceid = request.getParameter("sourceid");
		String flag = request.getParameter("flag");
		String id = request.getParameter("id");
		String source = request.getParameter("source");
		act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		if ("share".equals(flag)) {
			// 通过分享链接进来的
			WxuserInfo wuInfo = new WxuserInfo();
			wuInfo.setParty_row_id(sourceid);
			List<?> wuList = cRMService.getWxService().getWxUserinfoService().findObjListByFilter(wuInfo);
			if (null != wuList && wuList.size() > 0) {
				wuInfo = (WxuserInfo) wuList.get(0);
				request.setAttribute("username", wuInfo.getNickname());
				request.setAttribute("headimgurl", wuInfo.getHeadimgurl());
			} else {
				request.setAttribute("username", "匿名用户");
			}
		} else {
			// 不是通过分享链接进来的，直接去来源的库里面去找用户
			SourceObject obj1 = cRMService.getDbService().getSourceObject2SourceSystemService()
					.getSourceObject(sourceid, source);
			if (null != obj1) {
				// if("RM".equals(source)){
				// request.setAttribute("username", obj1.getContacter());
				// }else{
				// }
				request.setAttribute("username", obj1.getNickName());
				request.setAttribute("headimgurl", obj1.getHeadImageUrl());
			} else {
				request.setAttribute("username", "匿名用户");
			}
		}
		request.setAttribute("sourceid", sourceid);
		request.setAttribute("activity", act);
		return "activity/online";
	}

	/**
	 * 图文直播
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/direct")
	public String direct(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String sourceid = request.getParameter("sourceid");
		String id = request.getParameter("id");
		String source = request.getParameter("source");
		// 获得活动的详情信息
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		// 得到当前登录人的信息
		/**
		 * WxuserInfo wuInfo = new WxuserInfo(); String partyId =
		 * RedisCacheUtil.getString("ZJACC_UNIONID_"+sourceid);
		 * if(!StringUtils.isNotNullOrEmptyStr(partyId)){ partyId = sourceid;
		 * wuInfo.setUnionid(partyId); }else{ wuInfo.setUnionid(partyId); }
		 * List<?> wuList = cRMService.getWxService().getWxUserinfoService().findObjListByFilter(wuInfo);
		 * if(null != wuList && wuList.size() > 0){ //
		 * if(!StringUtils.isNotNullOrEmptyStr(wuInfo.getHeadimgurl())){ //
		 * wuInfo.setHeadimgurl(PropertiesUtil.getAppContext("app.content") +
		 * "/image/defailt_person.png"); // } request.setAttribute("user",
		 * wuList.get(0)); }else{ wuInfo.setNickname("匿名用户");
		 * //wuInfo.setHeadimgurl(PropertiesUtil.getAppContext("app.content") +
		 * "/image/defailt_person.png"); request.setAttribute("user", wuInfo); }
		 */
		SourceObject obj1 = cRMService.getDbService().getSourceObject2SourceSystemService().getSourceObject(
				sourceid, "PC");
		if (null != obj1) {
			// if(!StringUtils.isNotNullOrEmptyStr(obj1.getHeadImageUrl())){
			// obj1.setHeadImageUrl(PropertiesUtil.getAppContext("app.content")
			// + "/image/defailt_person.png");
			// }
			request.setAttribute("user", obj1);
		} else {
			SourceObject obj2 = new SourceObject();
			obj2.setNickName("匿名用户");
			// obj2.setHeadImageUrl(PropertiesUtil.getAppContext("app.content")
			// + "/image/defailt_person.png");
			request.setAttribute("user", obj2);
		}
		// 读取历史图文数据
		DirectSendModel directSendModel = new DirectSendModel();
		directSendModel.setActivity_id(id);
		directSendModel.setCurrpages(0);
		directSendModel.setPagecounts(99999999);
		Object obj = cRMService.getDbService().getDirectSendService().findObjListByFilter(directSendModel);
		List<DirectSendModel> list = new ArrayList<DirectSendModel>();
		if (obj != null) {
			list = (List<DirectSendModel>) obj;
		}
		request.setAttribute("sourceid", sourceid);
		request.setAttribute("id", id);
		request.setAttribute("source", source);
		request.setAttribute("activity", act);
		request.setAttribute("msglist", list);
		return "pcactivity/news";
	}

	/**
	 * 异步读取直播内容
	 * 
	 * @param direct
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/readdirect")
	@ResponseBody
	public String readdirect(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String activity_id = request.getParameter("activity_id");
		String start = request.getParameter("start");
		int s = 0;
		if (StringUtils.isNotNullOrEmptyStr(start)) {
			s = Integer.parseInt(start);
		}
		List<?> directList = new ArrayList<DirectSendModel>();
		List<?> tlist = RedisCacheUtil.getListRange("ZJMARKETING_DIRECT_" + activity_id,0,RedisCacheUtil.getLengthOfList("ZJMARKETING_DIRECT_"+ activity_id));
		directList = RedisCacheUtil.getListRange("ZJMARKETING_DIRECT_" + activity_id,s,RedisCacheUtil.getLengthOfList("ZJMARKETING_DIRECT_"	+ activity_id)- s);
		// rs =
		// RedisCacheUtil.getSortedSetRange("ZJMARKETING_DIRECT_"+activity_id,
		// s,-1);
		// for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
		// DirectSendModel direct = (DirectSendModel) iterator.next();
		// directList.add(direct);
		// }
		if (null == directList || directList.size() == 0) {
			return "";
		}
		return JSONArray.fromObject(directList).toString();

	}

	/**
	 * 异步保存直播内容
	 * 
	 * @param direct
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savedirect")
	@ResponseBody
	public String savedirect(DirectSendModel direct,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String flg = cRMService.getDbService().getDirectSendService().addObj(direct);
		if (StringUtils.isNotNullOrEmptyStr(flg)) {
			// 级存
			direct.setCreated_time(DateTime.currentDateTime());
			direct.setId(flg);
			RedisCacheUtil.addToListRight("ZJMARKETING_DIRECT_" + direct.getActivity_id(), direct);
			// RedisCacheUtil.addToListRight("ZJMARKETING_DIRECT_"+direct.getActivity_id(),
			// direct);
			// RedisCacheUtil.addToSortedSet("ZJMARKETING_DIRECT_"+direct.getActivity_id(),
			// direct, 0);
			return flg;
		}
		return "";
	}

	/**
	 * 异步保存评论
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asysavenew")
	@ResponseBody
	public String asysavenews(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String survey_id = request.getParameter("survey_id");// 调查Id
		String unionid = request.getParameter("unionid");// 调查责任人Id
		String survey_name = request.getParameter("survey_name");// 调查名称
		if (StringUtils.isNotNullOrEmptyStr(survey_name)&& !StringUtils.regZh(survey_name)) {
			survey_name = new String(survey_name.getBytes("ISO-8859-1"),"UTF-8");
		}
		String id = request.getParameter("id");// 活动ID
		if (StringUtils.isNotNullOrEmptyStr(id)) {
			DirectSendModel direct = new DirectSendModel();
			direct.setActivity_id(id);
			direct.setCreated_by(unionid);
			direct.setMsg_type("link");
			direct.setSource("P");
			String content = "<a target='_blank' href='"+ PropertiesUtil.getAppContext("zjsurvey.url")+ "/survey/share?id=" + survey_id+ "&source=activity&stype=survey&sourceid=$$sourceid'>"+ survey_name + "</a>";
			direct.setContent(content);
			// 通过分享链接进来的
			// WxuserInfo wuInfo = new WxuserInfo();
			// wuInfo.setParty_row_id(unionid);
			// List<?> wuList = cRMService.getWxService().getWxUserinfoService().findObjListByFilter(wuInfo);
			// if(null != wuList && wuList.size() > 0){
			// wuInfo = (WxuserInfo)wuList.get(0);
			// direct.setCreate_name(wuInfo.getNickname());
			// direct.setHeadimgurl(wuInfo.getHeadimgurl());
			// }else{
			// direct.setCreate_name("匿名用户");
			// }
			SourceObject obj1 = cRMService.getDbService().getSourceObject2SourceSystemService().getSourceObject(unionid, "");
			if (null != obj1) {
				direct.setCreate_name(obj1.getNickName());
				direct.setHeadimgurl(obj1.getHeadImageUrl());
			} else {
				direct.setCreate_name("匿名用户");
			}
			direct.setCompere("1");
			String flg = cRMService.getDbService().getDirectSendService().addObj(direct);
			if (StringUtils.isNotNullOrEmptyStr(flg)) {
				// 级存
				direct.setCreated_time(DateTime.currentDateTime());
				direct.setId(flg);
				RedisCacheUtil.addToListRight("ZJMARKETING_DIRECT_" + direct.getActivity_id(),direct);
			}
			return "{\"errorCode\":\"0\",\"errorMsg\":\"success\"}";
		}
		return "{\"errorCode\":\"-1\",\"errorMsg\":\"fail\"}";
	}

	/**
	 * 删除评论
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delNews")
	@ResponseBody
	public String delNews(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String activityid = request.getParameter("activityid");
		String id = request.getParameter("id");
		CrmError crmErr = new CrmError();
		// 删除缓存
		List<DirectSendModel> directList = new ArrayList<DirectSendModel>();
		List<Object> list = RedisCacheUtil.getListRange("ZJMARKETING_DIRECT_" + activityid,0,RedisCacheUtil.getLengthOfList("ZJMARKETING_DIRECT_"+ activityid));
		RedisCacheUtil.delete("ZJMARKETING_DIRECT_" + activityid);
		try {
			// 删除数据库的评论
			cRMService.getDbService().getDirectSendService().deleteObjById(id);
			for (Iterator iterator = list.iterator(); iterator.hasNext();) {
				DirectSendModel directSendModel = (DirectSendModel) iterator.next();
				String directRowid = directSendModel.getId();
				if (!id.equals(directRowid)) {
					directList.add(directSendModel);
				}
			}
			for (int i = 0; i < directList.size(); i++) {
				RedisCacheUtil.addToListRight("ZJMARKETING_DIRECT_"+ activityid, directList.get(i));
			}
			crmErr.setErrorCode("0");
		} catch (Exception e) {
			e.printStackTrace();
			crmErr.setErrorCode("9");
		}
		return JSONObject.fromObject(crmErr).toString();
	}

	@RequestMapping("/initdirect")
	@ResponseBody
	public String initdirect(DirectSendModel direct,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// 获取历史图文历史数据
		String id = request.getParameter("activity_id");
		if (!StringUtils.isNotNullOrEmptyStr(id)) {
			return "";
		}
		DirectSendModel directSendModel = new DirectSendModel();
		directSendModel.setActivity_id(id);
		directSendModel.setCurrpages(0);
		directSendModel.setPagecounts(99999999);
		Object obj = cRMService.getDbService().getDirectSendService().findObjListByFilter(directSendModel);
		List<DirectSendModel> list = new ArrayList<DirectSendModel>();
		if (obj != null) {
			list = (List<DirectSendModel>) obj;
		} else {
			return "";
		}

		return JSONArray.fromObject(list).toString();
	}

	/**
	 * 物理删除活动
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delAct")
	@ResponseBody
	public String delActivity(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		String type = request.getParameter("type");
		logger.info("ActivityController delActivity id ===>" + id);
		String str = "";
		try {
			
			//资源删除 同步到讨论组
			if(org.apache.commons.lang.StringUtils.isNotBlank(id)){
				 cRMService.getDbService().getDiscuGroupService().delDiscuGroupTopicByTopicId(id);
			}
			if("activity".equals(type)){
				Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
				
				if(null != act && StringUtils.isNotNullOrEmptyStr(act.getId())){
					String title = act.getTitle();
					long start = DateTime.dateTimeParse(act.getStart_date(),DateTime.DateFormat1);
					long end = DateTime.dateTimeParse(act.getAct_end_date(),DateTime.DateFormat1);
					long curr =DateTime.dateTimeParse(DateTime.currentDate(DateTime.DateFormat1),DateTime.DateFormat1);
					boolean flag = false;
					String content = "";
					if(curr<start){
						flag = true;
						content = "对不起，您报名的会议【"+title+"】已经取消，给您造成的不便尽请谅解！";
					}else if(curr>end){
						flag = false;
					}else{
						flag = true;
						content = "对不起，您报名的会议【"+title+"】已删除，给您造成的不便尽请谅解！";
					}
					if(flag){
						ActivityParticipant ap = new ActivityParticipant();
						ap.setActivityid(id);
						List<Participant> parList = cRMService.getDbService().getParticipantService().getParticipantListByActivity(ap);
						/*Map<String, Object> msgMap = new HashMap<String, Object>();
						String url = PropertiesUtil.getMsgContext("service.url1");
						msgMap.put("code", "231231");
						for(Participant part : parList){
							String phone = part.getOpMobile();
							msgMap.put("mobile", phone);
							msgMap.put("content", content);
							HttpClient3Post.request(url, msgMap);
						}*/
						String code = "231231";
						for(Participant part : parList){
							String phone = part.getOpMobile();
							ThreadRun thread = new SMSSentThread(code,phone,content);
							ThreadExecute.push(thread);
						}
						
					}
				}
			}
			
			cRMService.getDbService().getActivityService().updActFlag(id);
			
			str = "0";
		} catch (Exception e) {
			str = "999999";
		}
		return str;
	}
	
	/**
	 * 判断是不是好友
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/isFriend")
	@ResponseBody
	public String isFriend(HttpServletRequest request,HttpServletResponse response) throws Exception{
		String partyId = request.getParameter("partyId");
		String sourceid = request.getParameter("sourceid");
		List<UserRela> list = getRelaUserId(sourceid);
		String str = "9999";
		if(list.size()>0){
			for(UserRela userRela : list){
				if(partyId.equals(userRela.getRela_user_id())){
					str = "0";
				}
			}
		}
		return str;
	}
	
	/**
	 * 进入聚会的管理界面
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/manager_jh")
	public String manage_jh(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String id = request.getParameter("id");
		String sourceid = request.getParameter("sourceid");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("ZjwkActivityController manage_jh crmId ==>"+crmId);
		logger.info("ZjwkActivityController manage_jh id ==>"+id);
		logger.info("ZjwkActivityController manage_jh sourceid ==>"+sourceid);
		Activity activity = cRMService.getDbService().getActivityService().getActivitySingle(id);
		request.setAttribute("shareusers",getList(activity.getCreateBy(), id, "Activity",request.getParameter("ownerOpenId"),activity));
		String teamaddflag = "";
		if(sourceid.equals(activity.getCreateBy())){
			teamaddflag = "Y";
		}else{
			teamaddflag = "N";
		}
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			getContactAdds(request,null);
		}
		//获取讨论组的信息
		DiscuGroup dg = new DiscuGroup();
		dg.setCreator(UserUtil.getCurrUser(request).getParty_row_id());
		List<DiscuGroup> dgList =  cRMService.getDbService().getDiscuGroupService().findJoinDiscuGroupList(dg);
		request.setAttribute("dgList", dgList);
		request.setAttribute("authority", teamaddflag);
		request.setAttribute("act", activity);
		request.setAttribute("rowId", id);
		request.setAttribute("sourceid", sourceid);
		String msgsize = RedisCacheUtil.getString("ZJWK_ACTIVITY_INVITE_MSG_meet_"+id);
		String groupsize = RedisCacheUtil.getString("ZJWK_ACTIVITY_INVITE_DISCUGROUP_meet_"+id);
		if("Y".equals(activity.getIsregist())){
			//获取报名人数
			ActivityParticipant apc = new ActivityParticipant();
			apc.setActivityid(id);
			apc.setOrderByString(" order by create_date ");
			List<Participant> paList = cRMService.getDbService().getParticipantService().getParticipantListByActivity(apc);// 报名列表
			int allsize = 0;
			int registSize = 0;
			if(null!=paList&&paList.size()>0){
				allsize += paList.size();
				registSize = paList.size();
				request.setAttribute("paList", paList);
			}
			//获取邀请人数
			Invite invite = new Invite();
			invite.setRela_id(id);
			invite.setRela_type("meet");
			List<Invite> lists =(List<Invite>)cRMService.getDbService().getInviteService().findObjListByFilter(invite);
			invite.setSend_type("wx");
			if(null!=lists&&lists.size()>0){
				allsize += lists.size();
				List<Invite> unregilist = new ArrayList<Invite>();
				List<Invite> clist = new ArrayList<Invite>();
				List<Invite> blist = new ArrayList<Invite>();
				for(Invite invite2 : lists){
					String mobile = invite2.getReceived_phone(); 
					boolean flag = false;
					for(Participant participant1 : paList){
						String phone = participant1.getOpMobile();
						if(phone.equals(mobile)){
							flag = true;
						}
						if(flag){
							continue;
						}
					}
					if(!flag){
						unregilist.add(invite2);
					}
					String send_type = invite2.getSend_type();
					if("sms".equals(send_type)){
						clist.add(invite2);
					}else if("wx".equals(send_type)){
						blist.add(invite2);
					}
				}
				if(null!=unregilist&&unregilist.size()>0){
					request.setAttribute("noRegistList", JSONArray.fromObject(unregilist).toString());
					request.setAttribute("unRegistSize", unregilist.size());
				}
				getContactAdds(request, clist);
				List<UserRela> userlist = getRelaUserId(sourceid);
				List<BusinessCard> bList = getBusinessCards(blist,userlist);
				request.setAttribute("bList", bList);
			}
			request.setAttribute("allsize", allsize);
			request.setAttribute("registSize", registSize);
		}
		request.setAttribute("msgsize",msgsize);
		request.setAttribute("groupsize",groupsize);
		return "activity/manager_jh";
	}
	
	public void getContactAdds(HttpServletRequest request,List<Invite> invites) throws Exception{
		//获取联系人
//		Contact contact = new Contact();
//		contact.setCrmId(UserUtil.getCurrUser(request).getCrmId());
//		contact.setPagecount(null);
//		contact.setCurrpage(Constants.ZERO+"");
//		contact.setOpenId(UserUtil.getCurrUser(request).getOpenId());
//		ContactResp cResp = cRMService.getSugarService().getContact2SugarService().getContactClist(contact,"WEB");
//		List<ContactAdd> list = cResp.getContacts();
//		//获取我的好友
//		UserRela userRela = new UserRela();
//		userRela.setUser_id(UserUtil.getCurrUser(request).getParty_row_id());
//		userRela.setCurrpages(Constants.ZERO);
//		userRela.setPagecounts(Constants.ALL_PAGECOUNT);
//		List<UserRela> userRelaList = (List<UserRela>)cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);
//		List<String> charList = new ArrayList<String>();
//		// 放到页面上
//		if (null != list && list.size() > 0) {
//			ContactAdd con = null;
//			for(int i=0;i<list.size();i++){
//				con = list.get(i);
//				if(con.getFirstname() != null && !charList.contains(con.getFirstname())){
//					charList.add(con.getFirstname());
//				}
//			}
//		} else {
//			list = new ArrayList<ContactAdd>();
//		}
//		if(null != userRelaList && userRelaList.size() >0){
//			UserRela ur = null;
//			for(int i=0;i<userRelaList.size();i++){
//				ur = userRelaList.get(i);
//				list.add(transUserRela(ur,charList));
//			}
//		}
		// 联系人----------------------------
				Contact contact = new Contact();
				contact.setPagecount(null);
				contact.setCurrpage("1");
				contact.setPagecount(Constants.ALL_PAGECOUNT + "");
				contact.setViewtype(Constants.SEARCH_VIEW_TYPE_MYALLVIEW);
				contact.setOpenId(UserUtil.getCurrUser(request).getOpenId());
				ContactResp cResp = cRMService.getSugarService().getContact2SugarService().getContactClist(contact, "WEB");
				List<ContactAdd> list = cResp.getContacts();
				List<ContactAdd> friendlist = new ArrayList<ContactAdd>();
				List<String> batchList = new ArrayList<String>();
				// 获取我的好友-------------------
				UserRela userRela = new UserRela();
				userRela.setUser_id(UserUtil.getCurrUser(request).getParty_row_id());
				userRela.setCurrpages(Constants.ZERO);
				userRela.setPagecounts(Constants.ALL_PAGECOUNT);
				List<UserRela> userRelaList = (List<UserRela>) cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);
				List<String> rstuid = new ArrayList<String>();
				List<Tag> taglist = new ArrayList<Tag>();
				Tag tag = new Tag();
				tag.setTagName("所有");
				tag.setModelType("all");
				taglist.add(tag);
				tag = new Tag();
				tag.setTagName("好友");
				tag.setModelType("friend");
				taglist.add(tag);
				if (null != list && list.size() > 0) {
					ContactAdd con = null;
					for (int i = 0; i < list.size(); i++) {
						con = list.get(i);
						rstuid.add(con.getRowid());
						if (StringUtils.isNotNullOrEmptyStr(con.getBatchno()) && !batchList.contains(con.getBatchno())) {
							batchList.add(con.getBatchno());
							tag = new Tag();
							tag.setTagName(con.getBatchno());
							tag.setModelType(con.getBatchno());
							tag.setModelId("batch");
							taglist.add(tag);
						}
					}
					if(rstuid.size() > 0){
						CacheContact csear = new CacheContact();
						csear.setRowid_in(rstuid);
						List<Tag> tags = (List<Tag>)cRMService.getDbService().getCacheContactService().findHandGroupCacheContactListByFilter(csear);
						if(null!=tags&&tags.size()>0){
							taglist.addAll(tags);
						}
					}
				} else {
					list = new ArrayList<ContactAdd>();
				}
				if (null != userRelaList && userRelaList.size() > 0) {
					UserRela ur = null;
					for (int i = 0; i < userRelaList.size(); i++) {
						ur = userRelaList.get(i);
						ContactAdd ca = new ContactAdd();
						ca.setConname(ur.getRela_user_name());
						ca.setRowid(ur.getRela_user_id());
						ca.setConjob(ur.getPosition());
						ca.setDepartment(ur.getDepart());
						ca.setPhonemobile(ur.getMobile_no_1());
						ca.setEmail(ur.getEmail_1());
						ca.setAccountname(ur.getCompany());
						ca.setConaddress((null == ur.getCounty() ? "" : ur.getCounty())+ (null == ur.getProvince() ? "" : ur.getProvince()) + (null == ur.getCity()?"":ur.getCity()));
						ca.setType("friend");
						list.add(ca);
						friendlist.add(ca);
					}
				}
		//首字母排序
//		Collections.sort(charList);
		if(null!=invites&&invites.size()>0){
			List<ContactAdd> cList = new ArrayList<ContactAdd>();
//			List<ContactAdd> conList = new ArrayList<ContactAdd>();
//			for(ContactAdd contactAdd:list){
//				String rowId = contactAdd.getRowid();
//				boolean flag = false;
//				for(Invite invite:invites){
//					if(rowId.equals(invite.getReceived_userid())){
//						contactAdd.setCreatedate(invite.getCreate_time());
//						cList.add(contactAdd);
//						flag=true;
//					}
//					if(flag){
//						continue;
//					}
//				}
//			}
			for(Invite invite : invites){
				String userid = invite.getReceived_userid();
				CacheContact cacheContact = new CacheContact();
				cacheContact.setRowid(userid);
				List<CacheContact> list2 =(List<CacheContact>) cRMService.getDbService().getCacheContactService().findObjListByFilter(cacheContact);
				ContactAdd contactAdd = new ContactAdd();
				boolean flag = false;
				for(UserRela userRela2 : userRelaList){
					if(userRela2.getRela_user_id().equals(userid)){
						flag = true;
					}
				}
				if(null!=list2&&list2.size()>0){
					contactAdd = cRMService.getDbService().getCacheContactService().invstransf(list2.get(0));
					contactAdd.setCreatedate(invite.getCreate_time());
					if(flag){
						contactAdd.setType("friend");
					}
					cList.add(contactAdd);
				}else{
					BusinessCard businessCard = new BusinessCard();
					businessCard.setPartyId(userid);
					List<BusinessCard> businessCards = (List<BusinessCard>) cRMService.getDbService().getBusinessCardService().findObjListByFilter(businessCard);
					if(null!=businessCards&&businessCards.size()>0){
						businessCard = businessCards.get(0);
						contactAdd.setConname(businessCard.getName());
						contactAdd.setRowid(businessCard.getPartyId());
						contactAdd.setConjob(businessCard.getPosition());
						contactAdd.setCreatedate(invite.getCreate_time());
						contactAdd.setPhonemobile(businessCard.getPhone());
						if(flag){
							contactAdd.setType("friend");
						}
						cList.add(contactAdd);
					}
				}
			}
			request.setAttribute("contactList1", cList);
		}
		else{
			request.setAttribute("contactList", list);
		}
		request.setAttribute("taglist", taglist);//手工分组的
		request.setAttribute("friendlist", friendlist);//好友的
//		request.setAttribute("charList", charList);
	}
	
	/**
	 * 好友与联系人对像转换
	 * @param ur
	 * @return
	 */
	private ContactAdd transUserRela(UserRela ur,List<String> charList){
		ContactAdd ca = new ContactAdd();
		ca.setConname(ur.getRela_user_name());
		ca.setRowid(ur.getRela_user_id());
		ca.setConjob(ur.getPosition());
		ca.setDepartment(ur.getDepart());
		ca.setPhonemobile(ur.getMobile_no_1());
		ca.setEmail(ur.getEmail_1());
		if(StringUtils.isNotNullOrEmptyStr(ur.getRela_user_name())){
			String findex = ZJWKUtil.getFirstSpell(ur.getRela_user_name());
			if(!charList.contains(findex)){
				charList.add(findex);
			}
			ca.setFirstname(findex);
		}else{
			if(!charList.contains("#")){
				charList.add("#");
			}
			ca.setFirstname("#");
		}
		ca.setAccountname(ur.getCompany());
		ca.setConaddress((null == ur.getCounty() ? "" : ur.getCounty())+ (null == ur.getProvince() ? "" : ur.getProvince()) + (null == ur.getCity()?"":ur.getCity()));
		ca.setType("friend");
		return ca;
	}
	
	/**
	 * 发送短信
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveconlist")
	@ResponseBody
	public String saveconlist(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String cids = request.getParameter("cids");
		String id = request.getParameter("id");
		String sourceid = request.getParameter("sourceid");
		if(!StringUtils.isNotNullOrEmptyStr(sourceid)){
			sourceid = UserUtil.getCurrUser(request).getParty_row_id();
		}
		String model = request.getParameter("model");
		Map<String, String> map = new HashMap<String, String>();
		logger.info("ZjwkActivityController saveconlist cids ===>"+cids);
		logger.info("ZjwkActivityController saveconlist id ===>"+id);
		logger.info("ZjwkActivityController saveconlist sourceid ===>"+sourceid);
		logger.info("ZjwkActivityController saveconlist model ===>"+model);
		String batch_number = Get32Primarykey.get8RandomValiteCode(8);
		Activity activity = cRMService.getDbService().getActivityService().getActivitySingle(id);
		WxuserInfo wxuserInfo = UserUtil.getCurrUser(request);
		String orgId =(String) RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+ id);
		if(!StringUtils.isNotNullOrEmptyStr(orgId)){
			orgId = activity.getOrgId();
		}
		String crmId = cRMService.getDbService().getActivityService().getCrmIdByOrgId(wxuserInfo.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
		if(StringUtils.isNotNullOrEmptyStr(cids)&&cids.contains(";")){
			String[] strs = cids.split(";");
			String size = RedisCacheUtil.getString("ZJWK_ACTIVITY_INVITE_MSG_"+model+"_"+id);
			if(StringUtils.isNotNullOrEmptyStr(size)){
				size = Integer.parseInt(size)+strs.length+"";
			}else{
				size = strs.length+"";
			}
			for(String str : strs){
				if(StringUtils.isNotNullOrEmptyStr(str)&&str.contains(",")){
					String cid = str.split(",")[0];
					String cname = str.split(",")[1];
					if(StringUtils.isNotNullOrEmptyStr(cname)&&!StringUtils.regZh(cname)){
						cname = new String(cname.getBytes("ISO-8859-1"),"UTF-8");
					}
					//存入数据库用来分析
					Invite invite = new Invite();
					invite.setBatch_number(batch_number);
					invite.setRela_id(id);
					invite.setRela_name(activity.getTitle());
					invite.setRela_type(model);
					invite.setSend_type("sms");
					invite.setSend_status("sms_send_ok");
					invite.setReceived_userid(cid);
					invite.setReceived_username(cname);
					invite.setCreate_by(wxuserInfo.getParty_row_id());
					invite.setOrg_id(orgId);
					invite.setCrm_id(crmId);
					if(str.split(",").length<3){
						if(!sourceid.equals(cid)){
							cRMService.getDbService().getInviteService().addObj(invite);
						}
						continue;
					}
					String cphone = str.split(",")[2];
					if(StringUtils.isNotNullOrEmptyStr(cphone)){
						if(sourceid.equals(cid)){
							size = (Integer.parseInt(size) - 1)+"";
						}else{
							map.put(cid, cphone+","+cname);
						}
					}   
					invite.setReceived_phone(cphone);
					cRMService.getDbService().getInviteService().addObj(invite);
				}
			}
			RedisCacheUtil.setString("ZJWK_ACTIVITY_INVITE_MSG_"+model+"_"+id,size);
		}
		//批量发送短信
		if(null!=map&&map.keySet().size()>0){
			for(String key : map.keySet()){
				String str = map.get(key);
				String url = PropertiesUtil.getMsgContext("service.url1");
				String msg = PropertiesUtil.getMsgContext("message.activity.visit");
				msg = msg.replace("$$name", str.split(",")[1]);
				String surl = "";
				if("meet".equals(model)){
					surl = "/zjwkactivity/new_meetdetail?id="+id+"&type=sms";
				}else if("activity".equals(model)){
					surl = "/zjwkactivity/new_detail?id="+id+"&type=sms";
				}else if("act_meet".equals(model)){
					surl = "/zjwkactivity/new_detail?id="+id+"&type=sms";
				}
				String link ="点此查看详情" + PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content") + surl) ;
				msg = msg.replace("$$assignername", wxuserInfo.getName());
				msg = msg.replace("$$activitytitle", activity.getTitle());
				msg = msg.replace("$$detail", link);
				/*Map<String, Object> msgMap = new HashMap<String, Object>();
				msgMap.put("mobile", str.split(",")[0]);
				msgMap.put("content", msg);
				msgMap.put("code", "231231");
				HttpClient3Post.request(url, msgMap);*/
				
				ThreadRun thread = new SMSSentThread("231231", str.split(",")[0],msg);
				ThreadExecute.push(thread);

			}
		}
		return "success";
	}
	
	/**
	 * 发送到讨论组
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savegrouplist")
	@ResponseBody
	public String savegrouplist(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String cids = request.getParameter("cids");
		String id = request.getParameter("id");
		String sourceid = request.getParameter("sourceid");
		if(!StringUtils.isNotNullOrEmptyStr(sourceid)){
			sourceid = UserUtil.getCurrUser(request).getParty_row_id();
		}
		String model = request.getParameter("model");
		Map<String, String> map = new HashMap<String, String>();
		logger.info("ZjwkActivityController savegrouplist cids ===>"+cids);
		logger.info("ZjwkActivityController savegrouplist id ===>"+id);
		logger.info("ZjwkActivityController savegrouplist sourceid ===>"+sourceid);
		logger.info("ZjwkActivityController savegrouplist model ===>"+model);
		String batch_number = Get32Primarykey.get8RandomValiteCode(8);
		Activity activity = cRMService.getDbService().getActivityService().getActivitySingle(id);
		String source = request.getParameter("source");
		WxuserInfo wxuserInfo = UserUtil.getCurrUser(request);
		String orgId =(String) RedisCacheUtil.get(Constants.ZJWK_ACTIVITY_ORGID+ id);
		if(!StringUtils.isNotNullOrEmptyStr(orgId)){
			orgId = activity.getOrgId();
		}
		String crmId = cRMService.getDbService().getActivityService().getCrmIdByOrgId(wxuserInfo.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), orgId);
		if(StringUtils.isNotNullOrEmptyStr(cids)&&cids.contains(";")){
			String[] strs = cids.split(";");
			int size = 0;
			for(String str : strs){
				if(StringUtils.isNotNullOrEmptyStr(source)&&"continue".equals(source)){
					Invite invite = new Invite();
					invite.setBatch_number(batch_number);
					invite.setRela_id(id);
					invite.setRela_name(activity.getTitle());
					invite.setRela_type(model);
					invite.setSend_type("wx");
					invite.setSend_status("wx_send_ok");
					invite.setReceived_userid(str.split(",")[1]);
					invite.setReceived_phone("");
					invite.setReceived_username(str.split(",")[2]);
					invite.setCreate_by(wxuserInfo.getParty_row_id());
					invite.setOrg_id(orgId);
					invite.setCrm_id(crmId);
					invite.setReceived_parentid(str.split(",")[0]);
					String name = str.split(",")[1];
					if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
						name=new String(name.getBytes("ISO-8859-1"),"UTF-8");
					}
					invite.setReceived_parentname(name);
					if(!sourceid.equals(str.split(",")[1])){
						cRMService.getDbService().getInviteService().addObj(invite);
					}
					if(!sourceid.equals(str.split(",")[1])){
						map.put(str.split(",")[1],str.split(",")[2]);
						size ++;
					}
				}else{
					DiscuGroupUser discuGroupUser = new DiscuGroupUser();
					discuGroupUser.setDis_id(str.split(",")[0]);
					discuGroupUser.setCurr_user_id(wxuserInfo.getParty_row_id());
					List<DiscuGroupUser> list = (List<DiscuGroupUser>)cRMService.getDbService().getDiscuGroupService().findDiscuGroupUserList(discuGroupUser);
					for(DiscuGroupUser dg : list){
						//存入数据库用来分析
						Invite invite = new Invite();
						invite.setBatch_number(batch_number);
						invite.setRela_id(id);
						invite.setRela_name(activity.getTitle());
						invite.setRela_type(model);
						invite.setSend_type("wx");
						invite.setSend_status("wx_send_ok");
						invite.setReceived_userid(dg.getUser_id());
						invite.setReceived_phone(dg.getUser_phone());
						invite.setReceived_username(dg.getUser_name());
						invite.setCreate_by(wxuserInfo.getParty_row_id());
						invite.setOrg_id(orgId);
						invite.setCrm_id(crmId);
						invite.setReceived_parentid(str.split(",")[0]);
						String name = str.split(",")[1];
						if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
							name=new String(name.getBytes("ISO-8859-1"),"UTF-8");
						}
						invite.setReceived_parentname(name);
						if(!sourceid.equals(dg.getUser_id())){
							cRMService.getDbService().getInviteService().addObj(invite);
						}
						if(!sourceid.equals(dg.getUser_id())){
							map.put(dg.getUser_id(), dg.getUser_name());
							size ++;
						}
					}
				}
			}
			String length = RedisCacheUtil.getString("ZJWK_ACTIVITY_INVITE_DISCUGROUP_"+model+"_"+id);
			if(StringUtils.isNotNullOrEmptyStr(length)){
				length = Integer.parseInt(length)+size+"";
			}else{
				length = size+"";
			}
			RedisCacheUtil.setString("ZJWK_ACTIVITY_INVITE_DISCUGROUP_"+model+"_"+id,length);
		}
		//推送微信消息
		if(null!=map&&map.keySet().size()>0){
			for(String key : map.keySet()){
				String content = "";
				String surl = "";
				if("meet".equals(model)){
					surl = "/zjwkactivity/new_meetdetail?id="+id;
					content = "邀请您参加它的小型聚会【"+activity.getTitle()+"】，";
				}else if("activity".equals(model)){
					surl = "/zjwkactivity/new_detail?id="+id;
					content = "邀请您参加它的正式会议【"+activity.getTitle()+"】，";
				}else if("act_meet".equals(model)){
					surl = "/zjwkactivity/new_detail?id="+id;
					content = "邀请您参加它的正式会议【"+activity.getTitle()+"】，";
				}
				WxuserInfo wxuser = new WxuserInfo();
				wxuser.setParty_row_id(key);
				String openId = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser).getOpenId();
				cRMService.getWxService().getWxRespMsgService().respSimpCustMsgByOpenId(openId, wxuserInfo.getNickname()+content, surl);
			}
		}
		return "success";
	}

	/**
	 * 进入讨论组详情页面
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/showDiscuGroup")
	public String showDiscuGroup(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String id = request.getParameter("id");
		String sourceid = request.getParameter("sourceid");
		String model = request.getParameter("model");
		String key = request.getParameter("key");
		Invite invite = new Invite();
		invite.setRela_id(id);
		if("sms".equals(key)){
			invite.setSend_type("sms");
		}else if("discugroup".equals(key)){
			invite.setSend_type("wx");
		}
		invite.setRela_type(model);
		List<Invite> list = new ArrayList<Invite>();
		if("sms".equals(key)){
			list = (List<Invite>)cRMService.getDbService().getInviteService().findAllSmsInviteList(invite);
			String msgsize = RedisCacheUtil.getString("ZJWK_ACTIVITY_INVITE_MSG_meet_"+id);
			request.setAttribute("msgsize",msgsize);
		}else if("discugroup".equals(key)){
			String groupsize = RedisCacheUtil.getString("ZJWK_ACTIVITY_INVITE_DISCUGROUP_meet_"+id);
			list = (List<Invite>)cRMService.getDbService().getInviteService().findAllDiscuGroupInviteList(invite);
			request.setAttribute("groupsize",groupsize);
		}
		//得到表中接受者的数据
		List<Invite> lists =(List<Invite>)cRMService.getDbService().getInviteService().findObjListByFilter(invite);
		//得到好友列表
		List<UserRela> userlist = getRelaUserId(sourceid);
		if("discugroup".equals(key)){
			List<BusinessCard> bList = getBusinessCards(lists,userlist);
			request.setAttribute("bList", bList);
		}else if("sms".equals(key)){
			getContactAdds(request,lists);
		}
		request.setAttribute("sourceid", sourceid);
		request.setAttribute("id", id);
		request.setAttribute("model", model);
		request.setAttribute("list", list);
		request.setAttribute("type", key);
		return "activity/invite_meet_detail";
	}
	
	public List<BusinessCard> getBusinessCards(List<Invite> lists,List<UserRela> userlist){
		List<BusinessCard> bList = new ArrayList<BusinessCard>();
		if(null!=lists&&lists.size()>0){
			for(int i=0;i<lists.size();i++){
				String partyId = lists.get(i).getReceived_userid();
				BusinessCard businessCard = new BusinessCard();
				businessCard.setPartyId(partyId);
				List<BusinessCard> businessCards = (List<BusinessCard>) cRMService.getDbService().getBusinessCardService().findObjListByFilter(businessCard);
				if(null!=businessCards&&businessCards.size()>0){
					businessCard = businessCards.get(0);
					boolean flag = false;
					for(UserRela userRela:userlist){
						if(partyId.equals(userRela.getRela_user_id())){
							businessCard.setStatus("friend");
							flag=true;
						}
						if(flag){
							continue;
						}
					}
				}
				businessCard.setOpenId(lists.get(i).getReceived_parentid());
				businessCard.setIsValidation(lists.get(i).getBatch_number());
				bList.add(businessCard);
			}
		}
		return bList;
	}
	
	/**
	 * ***********************************************************************************************
	 * 会议管理
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/manage")
	public String manage(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String id = request.getParameter("id");
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		String sourceid = UserUtil.getCurrUser(request).getParty_row_id();
		// 判断当前登录人是否可以查看统计信息(团队成员都可以看到)
		String errorCode = "";
		if (!(sourceid).equals(act.getCreateBy())) {
			errorCode = cRMService.getDbService().getActivityService().isTeamMembers(id, UserUtil.getCurrUser(request).getOpenId(),act.getCreateBy());
			if ("0".equals(errorCode)) {
				request.setAttribute("authority", "Y");
				request.setAttribute("temaflag", "Y");
			} else {
				request.setAttribute("authority", "N");
			}
		} else if ((sourceid).equals(act.getCreateBy())) {
			errorCode = "0";
			request.setAttribute("authority", "Y");
		}
		//获得crmid
		String crmId = schedule2SugarService.getCrmIdByOrgId(UserUtil.getCurrUser(request).getOpenId(),PropertiesUtil.getAppContext("app.publicId"), act.getOrgId());
		logger.info("crmId = >" + crmId);
		//获取相关任务
		List<ScheduleAdd> taskList = new ArrayList<ScheduleAdd>();
		//查询的任务列表
		Schedule schedule = new Schedule();
		schedule.setOpenId(UserUtil.getCurrUser(request).getOpenId());
		schedule.setParentId(id);
		schedule.setCrmId(crmId);
		schedule.setParentType("Activity");
		schedule.setViewtype("myallview");
		ScheduleResp resp = schedule2SugarService.getScheduleList(schedule, "");
		if(null != resp && null != resp.getTasks()){
			taskList = resp.getTasks();
		}
		//获取活动的下拉列表
		Map<String, Map<String, String>> lovMap = cRMService.getDbService().getLovService().getLovList(null);
		Map<String, String> chaMap = lovMap.get("lov_charge_type");
		request.setAttribute("charge_type_value", chaMap.get(act.getCharge_type()));
		//获取任务的下拉列表
		Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
		request.setAttribute("statusDom", mp.get("status_dom"));
		request.setAttribute("periodList", mp.get("task_period_list"));
		request.setAttribute("taskList", taskList);
		request.setAttribute("shareusers",getList(act.getCreateBy(), id, "Activity", request.getParameter("ownerOpenId"), act));
		request.setAttribute("act", act);
		request.setAttribute("sourceid", sourceid);
		return "activity/manage";
	}
	
	/**
	 * 活动管理 -- 基本信息
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/manage_basic")
	public String manage_basic(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String id = request.getParameter("id");
		String sourceid = UserUtil.getCurrUser(request).getParty_row_id();
		logger.info("id = >" + id);
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		//客户端类型
		boolean isMobile = ZJWKUtil.isMobileAccess(request);
		//客户
		Activity_Rela ar = new Activity_Rela();
		ar.setActivity_id(id);
		ar.setRela_type("customer");
		List<Activity_Rela> ctlist = (List<Activity_Rela>)activity_RelaService.findObjListByFilter(ar);
		logger.info("ctlist = >" + ctlist);
		//联系人
		ar = new Activity_Rela();
		ar.setActivity_id(id);
		ar.setRela_type("contact");
		List<Activity_Rela> conlist = (List<Activity_Rela>)activity_RelaService.findObjListByFilter(ar);
		logger.info("conlist = >" + conlist);
		//获取报名列表
		ActivityParticipant ap = new ActivityParticipant();
		ap.setActivityid(id);
		List<Participant> parList = cRMService.getDbService().getParticipantService().getParticipantListByActivity(ap);
		int registSize = 0;
		if(null!=parList&&parList.size()>0){
			registSize = parList.size();
		}
		//获取活动的下拉列表
		Map<String, Map<String, String>> lovMap = cRMService.getDbService().getLovService().getLovList(null);
		Map<String, String> chaMap = lovMap.get("lov_charge_type");
		request.setAttribute("charge_type_value", chaMap.get(act.getCharge_type()));
		request.setAttribute("registSize", registSize);
		String content = act.getContent();
		if (StringUtils.isNotNullOrEmptyStr(content) && content.contains("\n")) {
			act.setContent(content.replace("\n", ""));
			if(content.contains("\r")){
				act.setContent(act.getContent().replace("\r", ""));
			}
		}
		//附件
		List<Attachment> attList = cRMService.getDbService().getAttachmentService().getActivityAttachmentListByActId(id);
		request.setAttribute("attList", attList);
		//请求
		request.setAttribute("isMobile", isMobile);
		request.setAttribute("ctlist", ctlist);
		request.setAttribute("conlist", conlist);
		String ossImgPath = "http://" + PropertiesUtil.getAppContext("aliyun.oss.bucket.pic").concat(".").concat(PropertiesUtil.getAppContext("aliyun.oss.endpoint")).concat("/");
		//request.setAttribute("zjwk_file_service", PropertiesUtil.getAppContext("zjmarketing.file.service.userpath"));
		request.setAttribute("zjwk_file_service", ossImgPath);
		request.setAttribute("act", act);
		request.setAttribute("sourceid", sourceid);
		return "activity/manage_basic";
	}
	/**
	 * 活动管理 -- 基本信息
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/manage_basic_info")
	public String manage_basic_info(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String id = request.getParameter("id");
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		request.setAttribute("act", act);
		//获取所属的组织名称
		String orgId = act.getOrgId();
		Organization org = new Organization();
		String orgName = "";
		if(!Constants.DEFAULT_ORGANIZATION.equals(orgId)){
			org.setId(orgId);
			List<Organization> orgList = (List<Organization>)cRMService.getDbService().getOrganizationService().findObjListByFilter(org);
			if(null!=orgList&&orgList.size()>0){
				orgName = orgList.get(0).getName();
			}
			
		}
		//查询联系人 和 好友列表
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			//获取联系人
			Contact contact = new Contact();
			contact.setCrmId(crmId);
			contact.setPagecount(null);
			contact.setCurrpage(Constants.ZERO+"");
			contact.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			ContactResp cResp =  cRMService.getSugarService().getContact2SugarService().getContactClist(contact,"WEB");
			List<ContactAdd> list = cResp.getContacts();
			//获取我的好友
			UserRela userRela = new UserRela();
			userRela.setUser_id(UserUtil.getCurrUser(request).getParty_row_id());
			userRela.setCurrpages(Constants.ZERO);
			userRela.setPagecounts(Constants.ALL_PAGECOUNT);
			List<UserRela> userRelaList = (List<UserRela>)cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);
			List<String> charList = new ArrayList<String>();
			// 放到页面上
			if (null != list && list.size() > 0) {
				ContactAdd con = null;
				for(int i=0;i<list.size();i++){
					con = list.get(i);
					if(con.getFirstname() != null && !charList.contains(con.getFirstname())){
						charList.add(con.getFirstname());
					}
				}
			} else {
				list = new ArrayList<ContactAdd>();
			}
			if(null != userRelaList && userRelaList.size() >0){
				UserRela ur = null;
				for(int i=0;i<userRelaList.size();i++){
					ur = userRelaList.get(i);
					list.add(transUserRela(ur,charList));
				}
			}
			//获取首字母集合
			//首字母排序
			Collections.sort(charList);
			request.setAttribute("contactList", list);
			request.setAttribute("charList", charList);
		}
		//客户列表
		Customer sche = new Customer();
		sche.setCrmId(UserUtil.getCurrUser(request).getCrmId());
		sche.setViewtype("myallview");
		sche.setCurrpage("1");
		sche.setPagecount("999");
		sche.setFirstchar("");
		sche.setOrgId(act.getOrgId());
		sche.setOpenId(UserUtil.getCurrUser(request).getOpenId());
		// 查询返回结果
		CustomerResp cRespsec = customer2SugarService.getCustomerList(sche, "WX");
		List<CustomerAdd> cList = cRespsec.getCustomers();
		request.setAttribute("accList", cList);
		Map<String, Map<String, String>> lovMap = cRMService.getDbService().getLovService().getLovList(null);
		if (null != lovMap) {
			request.setAttribute("lov_activity_isregist",lovMap.get("lov_activity_isregist"));
			request.setAttribute("lov_activity_displaymenber",lovMap.get("lov_activity_displaymenber"));
			request.setAttribute("lov_charge_type",lovMap.get("lov_charge_type"));
		}
		WxuserInfo user = UserUtil.getCurrUser(request);
		request.setAttribute("user", user);
		request.setAttribute("orgName", orgName);
		return "activity/manage_basic_info";
	}
	
	/**
	 * 活动管理 -- 邀约
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/manage_invit")
	public String manage_invit(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String id = request.getParameter("id");
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		
		//讨论组-------------------
		//获取讨论组的信息
		DiscuGroup dg = new DiscuGroup();
		dg.setCreator(UserUtil.getCurrUser(request).getParty_row_id());
		List<DiscuGroup> dgList =  cRMService.getDbService().getDiscuGroupService().findJoinDiscuGroupList(dg);
		
		//获取我的联系人和好友
		getMyAllContacts(request);
				
		//获取已邀约的人
		Invite invite = new Invite();
		invite.setRela_id(id);
		invite.setRela_type("act_meet");
		List<?> invList = cRMService.getDbService().getInviteService().findObjListByFilter(invite);
		
		//短信邀约
		List<Invite> smsList = new ArrayList<Invite>();
		//讨论组
		List<Invite> wxList = new ArrayList<Invite>();
		for(int i=0;i<invList.size();i++){
			invite = (Invite)invList.get(i);
			if("sms".equals(invite.getSend_type())){
				smsList.add(invite);
			}else{
				wxList.add(invite);
			}
		}
		
		// 获取我的好友-------------------
		UserRela userRela = new UserRela();
		userRela.setUser_id(UserUtil.getCurrUser(request).getParty_row_id());
		userRela.setCurrpages(Constants.ZERO);
		userRela.setPagecounts(Constants.ALL_PAGECOUNT);
		List<UserRela> userRelaList = (List<UserRela>) cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);

		//获取已报名的人
		ActivityParticipant ap = new ActivityParticipant();
		ap.setActivityid(id);
		List<Participant> parList = cRMService.getDbService().getParticipantService().getParticipantListByActivity(ap);
		Participant par = null;
		//设置好友
		for(int i=0;i<parList.size();i++){
			par = parList.get(i);
			for(int j=0;j<userRelaList.size();j++){
				userRela = userRelaList.get(j);
				if(userRela.getRela_user_id().equals(par.getSourceid())){
					par.setFlag("1");
				}
			}
		}
		int num = 0;
		List<Participant> allList = new ArrayList<Participant>();
		//报名未通过的
		List<Participant> ngList = new ArrayList<Participant>();
		//报销待审核的
		List<Participant> auditList = new ArrayList<Participant>();
		//报名通过的
		List<Participant> passList = new ArrayList<Participant>();
		
		for(int i=0;i<parList.size();i++){
			par = parList.get(i);
			if(!StringUtils.isNotNullOrEmptyStr(par.getStatus())){
				auditList.add(par);
			}else if("0".equals(par.getStatus())){
				ngList.add(par);
			}else{
				passList.add(par);
			}
		}
		if(parList.size()>0){
			num = parList.size();
			allList.addAll(parList);
		}
		
		//发送邀请，未报名
		List<Invite> noRegList = new ArrayList<Invite>();
		boolean flag = false;
		for(int i=0;i<invList.size();i++){
			flag = false;
			invite = (Invite)invList.get(i);
			for(int j=0;j<passList.size();j++){
				par = passList.get(j);
				if(invite.getReceived_userid().equals(par.getSourceid())){
					flag = true;
				}
			}
			if(!flag){
				for(int j=0;j<userRelaList.size();j++){
					userRela = userRelaList.get(j);
					if(userRela.getRela_user_id().equals(invite.getReceived_userid())){
						invite.setFriend("1");
						break;
					}
				}
				noRegList.add(invite);
				Participant part = new Participant();
				part.setOpName(invite.getReceived_username());
				part.setOpCompany("");
				part.setOpDuty("");
				part.setSourceid(invite.getReceived_userid());
				allList.add(part);
			}
		}	
		if(noRegList.size()>0){
			num += noRegList.size();
		}
		
		
		request.setAttribute("sourceid", UserUtil.getCurrUser(request).getParty_row_id());
		request.setAttribute("noRegList", noRegList);
		request.setAttribute("smsList", smsList);
		request.setAttribute("wxList", wxList);
		request.setAttribute("passList", passList);
		request.setAttribute("ngList", ngList);
		request.setAttribute("auditList", auditList);
		request.setAttribute("parList", parList);
		request.setAttribute("dgList", dgList);
		request.setAttribute("act", act);
		request.setAttribute("num", num);
		request.setAttribute("allList", allList);
		return "activity/manage_invit";
	}
	
	/**
	 * 活动管理 -- 分析
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/manage_analytics")
	public String manage_analytics(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String id = request.getParameter("id");
		// 转发次数
		String number = request.getParameter("number");
		if (!StringUtils.isNotNullOrEmptyStr(number)) {
			number = "0";
		}
		String sourceid = UserUtil.getCurrUser(request).getParty_row_id();
		Activity act = cRMService.getDbService().getActivityService().getActivitySingle(id);
		// 转发统计
		ActivityPrint forward = new ActivityPrint();
		forward.setActivityid(id);
		forward.setType("PRAISE");
		List<ActivityPrint> apList = cRMService.getDbService().getActivityPrintService().searchActivityPrintList(forward);
		forward.setType(null);
		List<ActivityPrint> tmpList = cRMService.getDbService().getActivityPrintService().searchActivityPrintListById(forward);
		Map<String, ActivityPrint> tmpUserList = new HashMap<String, ActivityPrint>();
		for (ActivityPrint activityPrint : tmpList) {
			tmpUserList.put(activityPrint.getSourceid(), activityPrint);
		}
		forward.setType("forward");
		List<ActivityPrint> pList = cRMService.getDbService().getActivityPrintService().searchActivityPrintList(forward);
		int forwardcount = 0;
		String nodes = "[";
		String links = "[";
		int mcount = 0;
		if (null != pList && pList.size() > 0) {
			// 根据sourceid查找第一个
			for (int i = 0; i < pList.size(); i++) {
				forward = pList.get(i);
				if (sourceid.equals(forward.getForwardid())) {
					mcount++;
				}
			}

			if (sourceid.equals(act.getCreateBy())) {
				nodes += "{category:0, name: '" + act.getCreateName()+ "', value : 10, label: '" + act.getCreateName()+ "\\n（" + mcount + "次）'}";
			} else {
				ActivityPrint wu = null;
				if (null != tmpUserList.get(sourceid)) {
					wu = tmpUserList.get(sourceid);
					nodes += "{category:0, name: '" + wu.getSourcename()+ "', value : 10, label: '" + wu.getSourcename()+ "\\n（" + mcount + "次）'}";
				}
			}

			// 查找下级
			ActivityPrint forward1 = null;
			for (int i = 0; i < pList.size(); i++) {
				forward = pList.get(i);
				mcount = 0;
				for (int j = 0; j < pList.size(); j++) {
					forward1 = pList.get(j);
					if (StringUtils.isNotNullOrEmptyStr(forward1.getForwardid())&&forward1.getForwardid().equals(forward.getSourceid())) {
						mcount++;
					}
				}
				if (StringUtils.isNotNullOrEmptyStr(forward.getSourceid())&& mcount >= Integer.parseInt(number)) {
					String nickname = null;
					ActivityPrint wu = null;
					if (null != tmpUserList.get(forward.getSourceid())) {
						wu = tmpUserList.get(forward.getSourceid());
						nickname = wu.getSourcename();
						nodes += ",{category:0, name: '" + nickname+ "', value : 10, label: '" + nickname + "\\n（"+ mcount + "次）'}";
					}
					if (StringUtils.isNotNullOrEmptyStr(forward1.getForwardid())&&forward.getForwardid().equals(act.getCreateBy())) {
						if (!links.equals("[")) {
							links += ",";
						}
						links += "{source : '" + nickname + "', target : '"+ act.getCreateName() + "', weight : 10}";
					} else {
						if (StringUtils.isNotNullOrEmptyStr(forward1.getForwardid())&&null != tmpUserList.get(forward.getForwardid())) {
							wu = tmpUserList.get(forward.getForwardid());
							if (!links.equals("[")) {
								links += ",";
							}
							links += "{source : '" + nickname + "', target : '"+ wu.getSourcename() + "', weight : 10}";
						}
					}
				}
			}
		}
		nodes += "]";
		links += "]";
		// 组装查询参数
		Messages obj = new Messages();
		obj.setRelaId(id);
		obj.setCurrpages(Integer.parseInt("0"));
		obj.setPagecounts(Integer.parseInt("9999999"));
		// 调用后台查询数据库
		List<Messages> mlist = (List<Messages>) cRMService.getDbService().getMessagesService().findObjListByFilter(obj);
		request.setAttribute("apList", apList);
		request.setAttribute("msgList", mlist);
		request.setAttribute("id", id);
		request.setAttribute("act", act);
		request.setAttribute("pList", pList);
		request.setAttribute("forwardcount", forwardcount);
		request.setAttribute("nodes", nodes);
		request.setAttribute("links", links);
		request.setAttribute("act", act);
		return "activity/manage_analytics";
	}
	
	/**
	 * 获取我的所有联系人
	 * @param request
	 */
	private void getMyAllContacts(HttpServletRequest request) throws Exception{
		// 联系人----------------------------
		Contact contact = new Contact();
		contact.setPagecount(null);
		contact.setCurrpage("1");
		contact.setPagecount(Constants.ALL_PAGECOUNT + "");
		contact.setViewtype(Constants.SEARCH_VIEW_TYPE_MYALLVIEW);
		contact.setCrmId(UserUtil.getCurrUser(request).getCrmId());
		contact.setOpenId(UserUtil.getCurrUser(request).getOpenId());
		//如果是个人账户的查询，则只查询 缓存表的数据 不用调用后台
		if("Default Organization".equals(contact.getOrgId())){
			contact.setViewtype("");
		}
		ContactResp cResp = cRMService.getSugarService().getContact2SugarService().getContactClist(contact, "WEB");
		List<ContactAdd> list = cResp.getContacts();
		List<ContactAdd> friendlist = new ArrayList<ContactAdd>();
		List<String> batchList = new ArrayList<String>();
		// 获取我的好友-------------------
		UserRela userRela = new UserRela();
		userRela.setUser_id(UserUtil.getCurrUser(request).getParty_row_id());
		userRela.setCurrpages(Constants.ZERO);
		userRela.setPagecounts(Constants.ALL_PAGECOUNT);
		List<UserRela> userRelaList = (List<UserRela>) cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);
		List<String> rstuid = new ArrayList<String>();
		List<Tag> taglist = new ArrayList<Tag>();
		Tag tag = new Tag();
		tag.setTagName("所有");
		tag.setModelType("all");
		taglist.add(tag);
		tag = new Tag();
		tag.setTagName("好友");
		tag.setModelType("friend");
		taglist.add(tag);
		if (null != list && list.size() > 0) {
			ContactAdd con = null;
			for (int i = 0; i < list.size(); i++) {
				con = list.get(i);
				rstuid.add(con.getRowid());
				if (StringUtils.isNotNullOrEmptyStr(con.getBatchno()) && !batchList.contains(con.getBatchno())) {
					batchList.add(con.getBatchno());
					tag = new Tag();
					tag.setTagName(con.getBatchno());
					tag.setModelType(con.getBatchno());
					tag.setModelId("batch");
					taglist.add(tag);
				}
			}
			if(rstuid.size() > 0){
				CacheContact csear = new CacheContact();
				csear.setRowid_in(rstuid);
				List<Tag> tags = (List<Tag>)cRMService.getDbService().getCacheContactService().findHandGroupCacheContactListByFilter(csear);
				if(null!=tags&&tags.size()>0){
					taglist.addAll(tags);
				}
			}
		} else {
			list = new ArrayList<ContactAdd>();
		}
		if (null != userRelaList && userRelaList.size() > 0) {
			UserRela ur = null;
			for (int i = 0; i < userRelaList.size(); i++) {
				ur = userRelaList.get(i);
				ContactAdd ca = new ContactAdd();
				ca.setConname(ur.getRela_user_name());
				ca.setRowid(ur.getRela_user_id());
				ca.setConjob(ur.getPosition());
				ca.setDepartment(ur.getDepart());
				ca.setPhonemobile(ur.getMobile_no_1());
				ca.setEmail(ur.getEmail_1());
				ca.setAccountname(ur.getCompany());
				ca.setConaddress((null == ur.getCounty() ? "" : ur.getCounty())+ (null == ur.getProvince() ? "" : ur.getProvince()) + (null == ur.getCity()?"":ur.getCity()));
				ca.setType("friend");
				list.add(ca);
				friendlist.add(ca);
			}
		}
		request.setAttribute("contactList", list);//所有的
		request.setAttribute("taglist", taglist);//手工分组的
		request.setAttribute("friendlist", friendlist);//好友的
//		List<String> charList = new ArrayList<String>();
//		if (null != list && list.size() > 0) {
//			ContactAdd con = null;
//			for (int i = 0; i < list.size(); i++) {
//				con = list.get(i);
//				if (con.getFirstname() != null&& !charList.contains(con.getFirstname())) {
//					charList.add(con.getFirstname());
//				}
//			}
//		} else {
//			list = new ArrayList<ContactAdd>();
//		}
//		if (null != userRelaList && userRelaList.size() > 0) {
//			UserRela ur = null;
//			for (int i = 0; i < userRelaList.size(); i++) {
//				ur = userRelaList.get(i);
//				list.add(transUserRela(ur, charList));
//			}
//		}
//		Collections.sort(charList);
	}

	/**
	 * 异步更新活动
	 * @param act
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asyupd")
	@ResponseBody
	public String asyupd(Activity act, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		boolean flag = cRMService.getDbService().getActivityService().updateActivity(act);
		if(flag){
			try{
				//更新联系人和主办单位
				if(StringUtils.isNotNullOrEmptyStr(act.getContactlistval())){
					List<Activity_Rela> arList = new ArrayList<Activity_Rela>();
					String[] cons = act.getContactlistval().split(",");
					Activity_Rela ar = null;
					for(int i=0;i<cons.length;i++){
						if(!StringUtils.isNotNullOrEmptyStr(cons[i])){
							continue;
						}
						ar = new Activity_Rela();
						String[] con = cons[i].split("\\|");
						if(null == con || con.length != 3){
							continue;
						}
						ar.setActivity_id(act.getId());
						ar.setRela_id(con[0]);
						ar.setRela_name(con[1]);
						ar.setRela_user_phone(con[2]);
						ar.setRela_type("contact");
						ar.setId(Get32Primarykey.getRandom32PK());
						ar.setCreate_by(UserUtil.getCurrUser(request).getParty_row_id());
						arList.add(ar);
					}
					if(arList.size()>0){
						ar = new Activity_Rela();
						ar.setActivity_id(act.getId());
						ar.setRela_type("contact");
						cRMService.getDbService().getActivity_RelaService().deleteActivityRelaByActivityId(ar);
						cRMService.getDbService().getActivity_RelaService().batchAddActivityRela(arList);
					}
				}
				
				if(StringUtils.isNotNullOrEmptyStr(act.getCustomerlistval())){
					List<Activity_Rela> arList = new ArrayList<Activity_Rela>();
					String[] accnts = act.getCustomerlistval().split(";");
					Activity_Rela ar = null;
					for(int i=0;i<accnts.length;i++){
						if(!StringUtils.isNotNullOrEmptyStr(accnts[i])){
							continue;
						}
						ar = new Activity_Rela();
						String[] con = accnts[i].split("\\|");
						if(null == con || con.length != 2){
							continue;
						}
						ar.setActivity_id(act.getId());
						ar.setRela_id(con[0]);
						ar.setRela_name(con[1]);
						ar.setRela_type("customer");
						ar.setId(Get32Primarykey.getRandom32PK());
						ar.setCreate_by(UserUtil.getCurrUser(request).getParty_row_id());
						arList.add(ar);
					}
					if(arList.size() >0){
						ar = new Activity_Rela();
						ar.setActivity_id(act.getId());
						ar.setRela_type("customer");
						cRMService.getDbService().getActivity_RelaService().deleteActivityRelaByActivityId(ar);
						cRMService.getDbService().getActivity_RelaService().batchAddActivityRela(arList);
					}
				}
			}catch(Exception e){
				logger.error("error ----------"+e.toString());
			}
			return "success";
		}else{
			return "error";
		}
		
	}
	
	/**
	 * 导出名单
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/exportlist")
	@ResponseBody
	public String exportlist(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String source = request.getParameter("source");
		String userid = request.getParameter("userid");
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		//查找用户是否有验证的邮箱
		BusinessCard bc = new BusinessCard();
		bc.setPartyId(partyId);
		Object obj = cRMService.getDbService().getBusinessCardService().findObj(bc);
		if(null == obj || !StringUtils.isNotNullOrEmptyStr(((BusinessCard)obj).getEmail())){
			//维护名片
			return "noemail";
		}
		List<Participant> list = new ArrayList<Participant>();
		String email = ((BusinessCard)obj).getEmail();
		if(StringUtils.isNotNullOrEmptyStr(userid)&&userid.contains(",")){
			String[] strs = userid.split(",");
			for(String id : strs){
				if("invite".equals(source)){
					Invite invite = (Invite)cRMService.getDbService().getInviteService().findObjById(id);
					Participant part = new Participant();
					part.setOpName(invite.getReceived_username());
					part.setOpPhone(invite.getReceived_phone());
					list.add(part);
				}else if("regist".equals(source)){
					Participant part = (Participant)cRMService.getDbService().getParticipantService().findObjById(id);
					list.add(part);
				}
			}
		}
		//生成CSV文件
		File f = reportConlistToCSV(list);
		//发送邮件
		sendEmail(email, f,UserUtil.getCurrUser(request).getNickname(),list.size());
		return "success";
	}
	
	/**
	 * 创建批量导出客户的 excel 报告
	 * @param list
	 * @param assigner
	 * @param approvename
	 * @param email
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	private File reportConlistToCSV(List<Participant> list)
	{
		try 
		{
			File f = new File("test.xls");
			if(!f.exists())
			{
				f.createNewFile();
			}
			FileOutputStream os = new FileOutputStream(f);
			 //创建工作薄
			WritableWorkbook workbook = Workbook.createWorkbook(os);
			//创建新的一页
			WritableSheet sheet = workbook.createSheet("客户",0);
			sheet.setColumnView(0, 20);
			sheet.setColumnView(1, 20);
			sheet.setColumnView(2, 20);
			sheet.setColumnView(3, 20);
			
			//合并单元格
			sheet.mergeCells(0, 0, 5, 0);
			sheet.setRowView(0, 750);
			//创建要显示的内容,创建一个单元格，第一个参数为列坐标，第二个参数为行坐标，第三个参数为内容
			Label rtile = new Label(0, 0, "我的会议名单");
			rtile.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,12));
			sheet.addCell(rtile);
			
			Label exportdatetxt = new Label(0, 1, "导出时间：");
			exportdatetxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(exportdatetxt);
			
			Label exportdate = new Label(1, 1, DateTime.currentDate(DateTime.DateFormat1));
			exportdate.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(exportdate);
			
			Label contactnumtxt = new Label(3, 1, "总数：");
			contactnumtxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(contactnumtxt);
			
			Label contactnum = new Label(4, 1, list.size()+"");
			contactnum.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(contactnum);
			
			//创建要显示的内容,创建一个单元格，第一个参数为列坐标，第二个参数为行坐标，第三个参数为内容
			Label nametxt = new Label(0, 2, "用户名");
			nametxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(nametxt);
			
			Label mobiletxt = new Label(1, 2, "电话");
			mobiletxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(mobiletxt);
			
			Label addrtxt = new Label(2,2,"公司");
			addrtxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
			sheet.addCell(addrtxt);
			
			Label industytxt = new Label(3,2,"职位");
			industytxt.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
			sheet.addCell(industytxt);
			
			sheet.setRowView(1, 500);
			
			Participant ca = null;
			for(int i=0;i<list.size();i++)
			{
				ca = list.get(i);
				Label name = new Label(0, i+3,ca.getOpName());
				name.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(name);
				
				//传入的电话号码有可能是opPhone，有可能是opMobile modify by zhihe
				Label mobile = new Label(1, i+3,StringUtils.isNotNullOrEmptyStr(ca.getOpPhone())?ca.getOpPhone():ca.getOpMobile());
				mobile.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(mobile);
				
				Label addr = new Label(2,i+3,ca.getOpCompany());
				addr.setCellFormat(getCellFormat(Colour.WHITE,Alignment.LEFT,10));
				sheet.addCell(addr);
				
				Label industy = new Label(3,i+3,ca.getOpDuty());
				industy.setCellFormat(getCellFormat(Colour.WHITE,Alignment.CENTRE,10));
				sheet.addCell(industy);

				sheet.setRowView(1, 500);
			}
			
			//把创建的内容写入到输出流中，并关闭输出流
			workbook.write();
			workbook.close();
			os.close();
			
			//返回数据
	        return f;
	        
		} catch (Exception e) 
		{
			return null;
		}
	}
	/**
	 * 发送邮件
	 * @param startDate
	 * @param email
	 * @param assigner
	 * @param approvename
	 * @param wdays
	 * @param filePath
	 */
	private void sendEmail(String email,File f,String username,int conSize)
	{
		SenderInfor senderInfor = new SenderInfor();
        StringBuffer content = new StringBuffer();  
        content.append("亲爱的").append(username).append("，您好！").append("<br/>").append("您本次共导出").append(conSize).append("个会议参与人，感谢您的使用！");
        senderInfor.setToEmails(email);  
        senderInfor.setSubject("我的会议名单");  
        senderInfor.setContent(content.toString());
        Map<String, String> m = new HashMap<String, String>();
        m.put("会议名单_("+ DateTime.currentDateTime(DateTime.DateFormat1) + ").xls", f.getAbsolutePath());
        senderInfor.setAttachments(m);
        MailUtils.sendEmail(senderInfor);
        
        f.delete();
	}
	
	/**
	 * 设置格式
	 * @return
	 */
	private WritableCellFormat getCellFormat(Colour color, Alignment posi ,Integer size)
	{
		try 
		{
			//设置字体;  
			WritableFont font1 = new WritableFont(WritableFont.createFont("微软雅黑"), size, WritableFont.NO_BOLD);
			//WritableFont font1 = new WritableFont(WritableFont.ARIAL,14,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,Colour.RED);  

			WritableCellFormat cellFormat1 = new WritableCellFormat(font1);  
			//设置背景颜色;  
			//cellFormat1.setBackground(color); 
			//设置自动换行;  
			cellFormat1.setWrap(true);  
			//设置文字居中对齐方式;  
			cellFormat1.setAlignment(posi);  
			//设置垂直居中;  
			cellFormat1.setVerticalAlignment(VerticalAlignment.CENTRE);
			
			return cellFormat1;
		}
		catch (WriteException e) 
		{
			logger.info(e.getMessage());
			return null;
		} 
	}

	/**
	 * 关注活动
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/attenAct")
	@ResponseBody
	public String attenAct(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String id = request.getParameter("rowId");
		String openId = UserUtil.getCurrUser(request).getOpenId();
		try{
			cRMService.getBusinessService().getActivityService().noticeActivity(openId, id);
		}catch(Exception e){
			return "error";
		}
		return "success";
	}
}
