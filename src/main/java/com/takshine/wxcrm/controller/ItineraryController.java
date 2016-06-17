package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.ZJWKUtil;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.Itinerary;
import com.takshine.wxcrm.domain.ItineraryInfo;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.CustomerResp;
import com.takshine.wxcrm.service.ItineraryService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 行程
 * 
 * @author lilei
 *
 */
@Controller
@RequestMapping("/itinerary")
public class ItineraryController {
	protected static Logger logger = Logger.getLogger(ItineraryController.class
			.getName());
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 行程列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	@ResponseBody
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		CrmError crmErr = new CrmError();
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String orgId = request.getParameter("orgId");
		if(!StringUtils.isNotNullOrEmptyStr(openId)){
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			return JSONObject.fromObject(crmErr).toString();
		}
		Itinerary itinerary = new Itinerary();
		itinerary.setOpenId(openId);
		itinerary.setOrgId(orgId);
		List<Itinerary> list = cRMService.getDbService().getItineraryService().searchMyAndFriendItinerary(itinerary);
		List<String> dataList = cRMService.getDbService().getItineraryService().searchMyAndFriendItineraryDate(itinerary);
		List<ItineraryInfo> itinerarylist=new ArrayList<ItineraryInfo>();
		for(String date:dataList){
			ItineraryInfo it = new ItineraryInfo();
			it.setItinerarydate(date);
			List<Itinerary> itList= new ArrayList<Itinerary>();
			for(Itinerary obj:list){
				if(date.equals(obj.getItinerarydate())){
				itList.add(obj);
				}

			}
			it.setList(itList);
			itinerarylist.add(it);
			
		}
		return JSONArray.fromObject(itinerarylist).toString();
	}
	
	/**
	 * 保存行程
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/save")
	@ResponseBody
	public String save(Itinerary itinerary,HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		List list= cRMService.getDbService().getItineraryService().findObjListByFilter(itinerary);
		if(list!=null&&list.size()>0){
			return "-1";
		}
		cRMService.getDbService().getItineraryService().addItinerary(itinerary);		
		return "1";
	}
	/**
	 * 删除行程
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/del")
	@ResponseBody
	public String del(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		cRMService.getDbService().getItineraryService().delItinerary(request.getParameter("id"));	
		return "";
	}
	@RequestMapping("/get")
	public String get(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String orgId = request.getParameter("orgId");
		String crmId=request.getParameter("crmId");
		request.setAttribute("orgId", orgId);
		request.setAttribute("crmId", crmId);
		return "/calendar/itinerarylist";
	}
}
