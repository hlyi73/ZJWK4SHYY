package com.takshine.wxcrm.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Menu;
import com.takshine.wxcrm.domain.UserPerferences;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.MenuService;
import com.takshine.wxcrm.service.UserPerferencesService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 菜单与用户个性化控制器
 * 
 * @author [liulin Date:2015-01-10]
 * 
 */

@Controller
@RequestMapping("/urperf")
public class UserPerferencesController {
	
	// 日志
	protected static Logger log = Logger.getLogger(UserPerferencesController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	/**
	 * 查询菜单列表 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/menulist")
	@ResponseBody
	public String menulist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		log.info("menulist start = >");
		String type = request.getParameter("type");
		log.info("type = >" + type);
		if(StringUtils.isBlank(type)) type = "DEFAULT";
		String m = RedisCacheUtil.getString("WK_MENUDEFLIST_" + type);
		if(StringUtils.isNotBlank(m)){
			log.info(" m = >" + m);
			return m;
		}
		Menu menu = new Menu();
		menu.setMenu_type(type);
		menu.setEnabled_flag("enabled");
		menu.setPagecounts(new Integer(999));
		List<Menu> mlist = (List<Menu>)cRMService.getDbService().getMenuService().findObjListByFilter(menu);
		log.info("mlist size = >" + mlist.size());
		String rst = JSONArray.fromObject(mlist).toString();
		RedisCacheUtil.setString("WK_MENUDEFLIST_DEFAULT", rst, 180);
		log.info(" rst = >" + rst);
		return rst;
	}
	
	/**
	 * 查询菜单列表 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/urperflist")
	@ResponseBody
	public String urperflist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		log.info("urperflist start = >");
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		log.info("partyId = >" + partyId);
		if(StringUtils.isBlank(partyId)){
			return "";
		}
		/*UserPerferences up = new UserPerferences();
		up.setUser_id(partyId);
		up.setCategory("menu");
		List<UserPerferences> uplist = (List<UserPerferences>)userPerferencesService.findObjListByFilter(up);
		log.info("uplist size = >" + uplist.size());
		String rst = JSONArray.fromObject(uplist).toString();
		log.info(" rst = >" + rst);*/
		return "";
	}
	
	/**
	 * 菜单管理
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/menumng")
	public String menumng(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setAttribute("parentid", request.getParameter("parentid"));
		return "perslInfo/menumng";
	}
	
	/**
	 * 保存菜单管理配置
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savemenuurperf")
	@ResponseBody
	public String savemenuurperf(UserPerferences up, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		log.info("partyId = >" + partyId);
		if(StringUtils.isBlank(partyId)){
			return "fail";
		}
		
		String con = up.getContents();
		log.info("con = >" + con);
		con = new String(con.getBytes("iso-8859-1"), "UTF-8");
		log.info("con aft= >" + con);
		
		if(StringUtils.isNotBlank(con)){
			UserPerferences delu = new UserPerferences();
			delu.setUser_id(partyId);
			if(!com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(up.getCategory())){
				delu.setCategory("menu");
			}else{
				delu.setCategory(up.getCategory());
			}
			cRMService.getDbService().getUserPerferencesService().deleteUserPerferencesByParam(delu);
			
			up.setId(Get32Primarykey.getRandom32PK());
			up.setUser_id(partyId);
			if(!com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(up.getCategory())){
			up.setCategory("menu");
			}
			up.setContents(con);
			up.setCreate_time(DateTime.currentDateTime());
			up.setModify_time(DateTime.currentDateTime());
			cRMService.getDbService().getUserPerferencesService().addObj(up);
			if("config".equals(up.getCategory())){
			UserUtil.setCurrUserByPartyId(request, partyId, cRMService.getWxService().getWxUserinfoService(),cRMService.getDbService().getBusinessCardService());	
			}
		   return "success";	
		}
		return "fail";
	}
	
	/**
	 * 保存账户默认值
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveaccntperf")
	@ResponseBody
	public String saveaccntperf(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String partyId = UserUtil.getCurrUser(request).getParty_row_id();
		String orgId = request.getParameter("orgId");
		log.info("partyId = >" + partyId);
		if(StringUtils.isBlank(partyId) || StringUtils.isBlank(orgId)){
			return "fail";
		}
		
		UserPerferences up = new UserPerferences();
		up.setUser_id(partyId);
		up.setCategory("Default_Organization");
		cRMService.getDbService().getUserPerferencesService().deleteUserPerferencesByParam(up);

		up.setId(Get32Primarykey.getRandom32PK());
		up.setUser_id(partyId);
		up.setCategory("Default_Organization");
		up.setContents("");
		up.setCreate_time(DateTime.currentDateTime());
		up.setModify_time(DateTime.currentDateTime());
		String id = cRMService.getDbService().getUserPerferencesService().addObj(up);
		if (StringUtils.isNotBlank(id)) {
			RedisCacheUtil.setString(Constants.ZJWK_USER_DEFAULT_ORGANIZATION+"_"+partyId, orgId);
			return "success";
		}
		return "fail";
	}
}
