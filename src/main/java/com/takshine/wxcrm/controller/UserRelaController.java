package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.UserRela;
import com.takshine.wxcrm.service.UserRelaService;

/**
 * 用户  关联关系  页面控制器
 * 
 */
@Controller
@RequestMapping("/userRela")
public class UserRelaController {
	// 日志
	protected static Logger log = Logger.getLogger(UserRelaController.class.getName());
			
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询指尖好友数据列表 包括 威客好友  和  人脉好友
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/urelalist")
	public String urelalist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setAttribute("userId", request.getParameter("userId"));
		return "perslInfo/urelalist"; 
	}
	
	/**
	 * 建立好友
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/save")
	@ResponseBody
	public String save(UserRela userRela,HttpServletRequest request, HttpServletResponse response) throws Exception {
		String flag = cRMService.getDbService().getUserRelaService().addObj(userRela);
		if(StringUtils.isNotNullOrEmptyStr(flag)){
			return "success";
		}
		return "fail"; 
	}
	
	@RequestMapping("/remove")
	@ResponseBody
	public String remove(UserRela userRela,HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if(StringUtils.isNotNullOrEmptyStr(userRela.getUser_id()) && StringUtils.isNotNullOrEmptyStr(userRela.getRela_user_id())){
			cRMService.getDbService().getUserRelaService().removeUserRelaByPartyId(userRela);
			String user_id = userRela.getUser_id();
			userRela.setUser_id(userRela.getRela_user_id());
			userRela.setRela_user_id(user_id);
			cRMService.getDbService().getUserRelaService().removeUserRelaByPartyId(userRela);
			return "success";
			
		}else{
			return "fail";
		}
	}
	
	
	/**
	 * 查询指尖好友数据列表 包括 威客好友  和  人脉好友
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/zjlist")
	@ResponseBody
	public String zjlist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		log.info("zjlist = >");
		String userId = request.getParameter("userId");
		if(null == userId || "".equals(userId)) userId = "-1";
		log.info("userId = >" + userId);
		//威客好友  
		UserRela userRela = new UserRela();
		userRela.setUser_id(userId);
		userRela.setCurrpages(0);
		userRela.setPagecounts(9999);
		@SuppressWarnings("unchecked")
		List<UserRela> userRelaList = (List<UserRela>)cRMService.getDbService().getUserRelaService().findObjListByFilter(userRela);
		log.info("userRelaList size = >" + userRelaList.size());
		
		//人脉好友
		//调用联系人同步
		/*String url = PropertiesUtil.getAppContext("zjrm.url")+"/out/user/friend_list/" + userId;
		log.info("url = >" + url);
		//单次调用sugar接口
		Map<String, String> paramaps = new HashMap<String, String>();
		//add 参数
		//调用
		String invokrst = "";
		try {
			invokrst = util.postKeyValueData(url, paramaps);
			log.info(" invokrst => " + invokrst);
		} catch (Exception e) {
			log.info(" invokrst errmsg=> " + e.getMessage());
		}
		//解析JSON数据
		List<UserRela> rmUserRelaList = new ArrayList<UserRela>();
		JSONArray jsonArr = JSONArray.fromObject(invokrst);
		for (int i = 0; i < jsonArr.size(); i++) {
			//人脉关联用户
			JSONObject jsonObj = (JSONObject)jsonArr.get(i);
			String relation_user_id = jsonObj.getString("party_row_id");
			String relation_user_name = jsonObj.getString("name");
			String headimgurl = jsonObj.getString("headimgurl");
			String city = jsonObj.getString("city");
			String company = jsonObj.getString("company");
			String county = jsonObj.getString("county");
			String depart = jsonObj.getString("depart");
			String email_1 = jsonObj.getString("email_1");
			String mobile_no_1 = jsonObj.getString("mobile_no_1");
			String position = jsonObj.getString("position");
			String province = jsonObj.getString("province");
			log.info("relation_user_id = >" + relation_user_id);
			log.info("relation_user_name = >" + relation_user_name);
			log.info("headimgurl = >" + headimgurl);
			log.info("city = >" + city);
			log.info("company = >" + company);
			log.info("county = >" + county);
			log.info("depart = >" + depart);
			log.info("email_1 = >" + email_1);
			log.info("mobile_no_1 = >" + mobile_no_1);
			log.info("position = >" + position);
			log.info("province = >" + province);
			//用户关联
			UserRela ur = new UserRela();
			ur.setRela_user_id(relation_user_id);
			ur.setRela_user_name(relation_user_name);
			ur.setHeadimgurl(headimgurl);
			ur.setCity(city);
			ur.setCompany(company);
			ur.setCounty(county);
			ur.setDepart(depart);
			ur.setEmail_1(email_1);
			ur.setMobile_no_1(mobile_no_1);
			ur.setPosition(position);
			ur.setProvince(province);
			rmUserRelaList.add(ur);
		}*/
		
		Map<String, UserRela> newMargeRelaList = new HashMap<String, UserRela>();
		
		//威客关联用户
		for (int j = 0; j < userRelaList.size(); j++) {
			UserRela sUr = userRelaList.get(j);
			String sUserId = sUr.getUser_id();
			String sReUserId = sUr.getRela_user_id();
			log.info("sUserId = >" + sUserId);
			log.info("sReUserId = >" + sReUserId);
			if(!newMargeRelaList.keySet().contains(sReUserId)){
				newMargeRelaList.put(sReUserId, sUr);
			}
		}
		/*for (int j = 0; j < rmUserRelaList.size(); j++) {
			UserRela sUr = rmUserRelaList.get(j);
			String sUserId = sUr.getUser_id();
			String sReUserId = sUr.getRela_user_id();
			log.info("rmUserRelaList sUserId = >" + sUserId);
			log.info("rmUserRelaList sReUserId = >" + sReUserId);
			if(!newMargeRelaList.keySet().contains(sReUserId)){
				newMargeRelaList.put(sReUserId, sUr);
			}
		}*/
		log.info("newMargeRelaList size = >" + newMargeRelaList.size());
		
		List<UserRela> rstUr = new ArrayList<UserRela>();
		Set<Map.Entry<String, UserRela>> entryseSet = newMargeRelaList.entrySet();
		for (Map.Entry<String, UserRela> entry : entryseSet) {
			UserRela ur = entry.getValue();
			rstUr.add(ur);
		}
		
		String rst = JSONArray.fromObject(rstUr).toString();
		log.info("rst = >" + rst);
		
		return rst;
	}
}
