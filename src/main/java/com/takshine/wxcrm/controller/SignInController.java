package com.takshine.wxcrm.controller;

import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Formatter;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.aliyun.oss.common.utils.DateUtil;
import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.domain.Sign;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.oauth.AccessToken;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UserReq;
import com.takshine.wxcrm.message.sugar.UsersResp;

/**
 * 活动 控制器
 * 
 * @author lilei
 *
 */
@Controller
@RequestMapping("/sign")
public class SignInController {
	protected static Logger logger = Logger.getLogger(SignInController.class
			.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 签到
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/get")
	public String get(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ZJWKUtil.getRequestURL(request);//获取请求的url
		// openId publicId
		String openId = UserUtil.getCurrOpenId(request);//request.getParameter("openId");
		String orgId = request.getParameter("orgId");
		if(!StringUtils.isNotNullOrEmptyStr(orgId)){
			orgId = "Default Organization";
		}
		String signLongitude = request.getParameter("signLongitude");
		String signLatitude = request.getParameter("signLatitude");
		String signType = request.getParameter("signType");
		
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if(StringUtils.isNotNullOrEmptyStr(orgId) && !Constants.DEFAULT_ORGANIZATION.equals(orgId)){
			UserReq uReq = new UserReq();
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			uReq.setFlag(Constants.SEARCH_USER_INFO);
			uReq.setOrgId(orgId);
			uReq.setOpenId(openId);
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			List<UserAdd> list = uResp.getUsers();
			if(list!=null&&list.size()>0){
				crmId = list.get(0).getUserid();
			}
		}
		
		request.setAttribute("signLatitude", signLatitude);
		request.setAttribute("signLongitude", signLongitude);
		request.setAttribute("crmId", crmId);
		request.setAttribute("openId", openId);
		request.setAttribute("orgId", orgId);
		request.setAttribute("signType", signType);
		return "sign/add";
	}

	/**
	 * 签到详情
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.info("SignInController : list"); 
		ZJWKUtil.getRequestURL(request);
		String openId = UserUtil.getCurrOpenId(request);//request.getParameter("openId");
		String orgId = request.getParameter("orgId");
		String stype = request.getParameter("stype");
		String startdate = "";
		String enddate = "";
		Sign sign = new Sign();
		Calendar cal =Calendar.getInstance();
		String search = request.getParameter("search");
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
		if("month".equals(stype)){
			cal.add(Calendar.MONTH, 0);
			cal.set(Calendar.DAY_OF_MONTH,1);
			startdate = format.format(cal.getTime());
			sign.setStartdate(startdate);
			cal.add(Calendar.MONTH, 1);
			cal.set(Calendar.DAY_OF_MONTH,0);
			enddate = format.format(cal.getTime());
			sign.setEnddate(enddate);
		}else if("search".equals(stype) && StringUtils.isNotNullOrEmptyStr(search)){
			sign.setEnddate(format.format(cal.getTime()));
			if("30".equals(search)){
				cal.add(Calendar.DATE, -30);
				sign.setStartdate(format.format(cal.getTime()));
			}else if("60".equals(search)){
				cal.add(Calendar.DATE, -60);
				sign.setStartdate(format.format(cal.getTime()));
			}else{
				cal.add(Calendar.DATE, -90);
				sign.setStartdate(format.format(cal.getTime()));
			}
		}else{
			int dayofweek = cal.get(Calendar.DAY_OF_WEEK) - 1;
			if (dayofweek == 0)
				dayofweek = 7;
			cal.add(Calendar.DATE, -dayofweek + 1);
			sign.setStartdate(format.format(cal.getTime()));
			dayofweek = cal.get(Calendar.DAY_OF_WEEK) - 1;
			if (dayofweek == 0)
				dayofweek = 7;
			cal.add(Calendar.DATE, -dayofweek + 7);
			sign.setEnddate(format.format(cal.getTime()));
		}
		sign.setOpenId(openId);
		sign.setCurrpages(0);
		sign.setPagecounts(99999);
		//自己的所有签到数据
		List<Sign> signList = cRMService.getDbService().getSignService().searchSignByFilter(sign);
		//下属的签到数据
		List<String> crmIdList = new ArrayList<String>();
		UserReq uReq = new UserReq();
		uReq.setCurrpage("1");
		uReq.setPagecount("1000");
		uReq.setOpenId(openId);
		//uReq.setFlag("direct_subordinates");
		uReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);
		UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
		if(null!=uResp.getUsers()&&uResp.getUsers().size()>0){
			for(UserAdd userAdd:uResp.getUsers()){
				crmIdList.add(userAdd.getUserid());
			}
		}
		if(crmIdList.size() > 0){
			sign.setOpenId(null);
			sign.setCrm_id_in(crmIdList);
			List<Sign> teamList = cRMService.getDbService().getSignService().searchSignByFilter(sign);
			if(null != teamList && teamList.size() > 0){
				if(null == signList){
					signList = new ArrayList<Sign>();
				}
				signList.addAll(teamList);
			}
		}
		Collections.sort(signList, new Comparator<Sign>() {
			public int compare(Sign o1, Sign o2) {
				String createTime1 = DateTime.date2Str(o1.getCreateTime(),DateTime.DateTimeFormat1);
				String createTime2 = DateTime.date2Str(o2.getCreateTime(),DateTime.DateTimeFormat1);
				if(!DateTime.compareTime(createTime1, createTime2)){
					return -1;
				}
				return 0;
			}
		});
		
		request.setAttribute("signList", signList);
		request.setAttribute("openId", openId);
		request.setAttribute("orgId", orgId);
		
		return "sign/list";
	}
	
	/**
	 * 保存签到
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/save")
	public String save(Sign sign,HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String name = "";
		if(StringUtils.isNotNullOrEmptyStr(sign.getOrgId()) && !Constants.DEFAULT_ORGANIZATION.equals(sign.getOrgId())){
			UserReq uReq = new UserReq();
			uReq.setCurrpage("1");
			uReq.setPagecount("1000");
			uReq.setFlag(Constants.SEARCH_USER_INFO);
			uReq.setOrgId(sign.getOrgId());
			uReq.setOpenId(sign.getOpenId());
			UsersResp uResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(uReq);
			List<UserAdd> list = uResp.getUsers();
			if(list!=null&&list.size()>0){
				name = list.get(0).getUsername();
			}
		}
		if(!StringUtils.isNotNullOrEmptyStr(name)){
			WxuserInfo wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(sign.getOpenId());
			name = wxuser.getNickname();
		}
		System.out.println(name);
		sign.setName(name);
		
		cRMService.getDbService().getSignService().addSign(sign);
		
		
		return "redirect:/sign/list?openId="+sign.getOpenId()+"&orgId="+sign.getOrgId();
	}
}
