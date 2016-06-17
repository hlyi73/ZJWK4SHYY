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
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.Print;
import com.takshine.wxcrm.domain.Tag;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.model.PrintModel;
import com.takshine.wxcrm.service.PrintService;
import com.takshine.wxcrm.service.WxUserinfoService;

@Controller
@RequestMapping("/print")
public class PrintController {
	
	protected static Logger logger = Logger.getLogger(PrintController.class.getName());
	
	@Autowired
	@Qualifier("printService")
	private PrintService printService;
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 添加活动印迹
	 * @param item
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savePrint")
	@ResponseBody
	public String addPrint(Print item, HttpServletRequest request, HttpServletResponse response) throws Exception {
		WxuserInfo user=UserUtil.getCurrUser(request);
		if(user==null){
			//抛出异常
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_SESSION_INVALID + "，错误描述："
					+ ErrCode.ERR_CODE_SESSION_INVALID_MSG);
		}
		logger.info("点赞 partyId ====>"+user.getParty_row_id());
		item.setOperativeid(user.getParty_row_id());
		PrintModel pm = new PrintModel();
		pm.setOperativeid(user.getParty_row_id());
		pm.setOperativetype(item.getOperativetype());
		pm.setObjectid(item.getObjectid());
		pm.setObjecttype(item.getObjecttype());
		if(printService.countObjByFilter(pm)>0){//已点赞
			return "-1";
		}else{
			int flag = printService.insert(item);
			if(flag==-1){
				return "-1";
			}else{
				return "1";
			}
		}
	}
	
	/**
	 * 查询访客列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/vulist")
	@ResponseBody
	public String visitUserList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String partyId =request.getParameter("bcpartyid");
		/*WxuserInfo user=UserUtil.getCurrUser(request);
		String partyId = user.getParty_row_id();*/
		logger.info("partyId = >" + partyId);
		if(StringUtils.isNotBlank(partyId)){
			String pagecounts = request.getParameter("pagecounts");
			PrintModel pm = new PrintModel();
			pm.setOwnid(partyId);
			pm.setObjecttype("PERSONAL_HOMEPAGE");
			pm.setCurrpages(0);
			if(com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(pagecounts)){
				pm.setPagecounts(Integer.parseInt(pagecounts));
			}else{
				pm.setPagecounts(-1); //-1表示所有
			}
			List<Print> plist = printService.getVisitUserList(pm);
			logger.info("plist size = >" + plist.size());
			String rst = JSONArray.fromObject(plist).toString();
			logger.info("rst = >" + rst);
			return rst;
		}
		return "[]";
	}
	
	/**
	 * 查询访客列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/printList")
	@ResponseBody
	public String myPrintList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String partyId =request.getParameter("bcpartyid");
		/*WxuserInfo user=UserUtil.getCurrUser(request);
		String partyId = user.getParty_row_id();*/
		logger.info("partyId = >" + partyId);
		if(StringUtils.isNotBlank(partyId)){
			String pagecounts = request.getParameter("pagecounts");
			PrintModel pm = new PrintModel();
			pm.setOperativeid(partyId);
			pm.setCurrpages(0);
			if(com.takshine.wxcrm.base.util.StringUtils.isNotNullOrEmptyStr(pagecounts)){
				pm.setPagecounts(Integer.parseInt(pagecounts));
			}else{
				pm.setPagecounts(-1); //-1表示所有
			}
			List<Print> plist = printService.getMyPrintList(pm);
			logger.info("plist size = >" + plist.size());
			String rst = JSONArray.fromObject(plist).toString();
			logger.info("rst = >" + rst);
			return rst;
		}
		return "[]";
	}
	
	
	/**
	 * 跳转至动态列表页
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/goPrintList")
	public String goPrintList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String partyId =request.getParameter("partyId");
		WxuserInfo user=UserUtil.getCurrUser(request);
	    WxuserInfo visitUser = new WxuserInfo();
	    visitUser.setParty_row_id(partyId);
	    visitUser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(visitUser);
	    visitUser=cRMService.getWxService().getWxUserinfoService().getUserConfig(visitUser);//获取被访问用户配置信息
	    request.setAttribute("visitUser",visitUser);
	    request.setAttribute("user",user);
	  return "perslInfo/myprintlist";
	}
	/**
	 * 跳转至访客列表页
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/goVisitUserList")
	public String goVisitUserList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String partyId =request.getParameter("partyId");
		WxuserInfo user=UserUtil.getCurrUser(request);
	    WxuserInfo visitUser = new WxuserInfo();
	    visitUser.setParty_row_id(partyId);
	    visitUser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(visitUser);
	    visitUser=cRMService.getWxService().getWxUserinfoService().getUserConfig(visitUser);//获取被访问用户配置信息
	    request.setAttribute("visitUser",visitUser);
	    request.setAttribute("user",user);
	  return "perslInfo/visituserlist";
	}
}
