package com.takshine.wxcrm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.error.BaseError;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.MD5Util;
import com.takshine.wxcrm.base.util.Page;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.base.util.cache.EhcacheUtil;
import com.takshine.wxcrm.domain.DcCrmOperator;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.sugar.AuthResp;
import com.takshine.wxcrm.service.BusinessCardService;
import com.takshine.wxcrm.service.DcCrmOperatorService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.OrganizationService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 用户和手机关联关系 页面控制器
 * 
 * @author [liulin Date:2014-01-10]
 * 
 */
@Controller
@RequestMapping("/operMobile")
public class OperatorMobileController {
	// 日志
	protected static Logger logger = Logger.getLogger(OperatorMobileController.class.getName());
	
	private WxHttpConUtil util = new WxHttpConUtil();

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	
	/**
	 * 查询 用户和手机关联关系 信息列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// search param
		String entId = request.getParameter("entId");// entId 企业ID
		List<OperatorMobile> rstlist = cRMService.getDbService().getOperatorMobileService().getOperMobileListByPara(entId);
		request.setAttribute("rstlist", rstlist);
		return "opermobile/list";
	}

	/**
	 * 分页查询用户和手机关联关系 列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/page")
	public String page(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// search param
		String page = request.getParameter("page");// 当前页
		String pageRows = request.getParameter("pageRows");// 每页的条数
		if (null == page || "".equals(page) || Integer.parseInt(page) < 1) {
			page = "1";
		}
		if (null == pageRows || "".equals(pageRows)) {
			pageRows = "10";
		}

		String entId = request.getParameter("entId");// entId 企业ID
		Page p = cRMService.getDbService().getOperatorMobileService().getOperMobileListByPage(entId, page, pageRows);
		request.setAttribute("rstlist", p.getData());
		request.setAttribute("page", p.getPage());
		request.setAttribute("pageRows", p.getPageSize());
		request.setAttribute("size", p.getSize());// 总记录数
		request.setAttribute("totalPageCount", p.getTotalPageCount());

		return "opermobile/list";
	}

	/**
	 * 根据ID 查询用户和手机关联关系
	 * 
	 * @param cardNo
	 *            会员卡号
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "get", method = RequestMethod.GET)
	public String get(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("OperatorMobileController get method begin=>");
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		logger.info("OperatorMobileController get method openId =>" + openId);
		logger.info("OperatorMobileController get method publicId =>" + publicId);
		
		if(null == openId  || "".equals(openId)
				|| null == publicId  || "".equals(publicId)){
			//来源问题
			request.setAttribute("bindSucc", "sources");
			return "opermobile/msg";
		}
		
		//OperatorMobile info = operatorMobileService.checkBinding(openId, publicId);
		//logger.info("info:-> is =" + info);
		//logger.info("crmId:-> is =" + info.getCrmId());
		
		//if (null == info
		//		|| null == info.getCrmId()
		//		|| "".equals(info.getCrmId())){
		//	info = new OperatorMobile();
			
			//查询组织列表
			OperatorMobile om = new OperatorMobile();
			om.setOpenId(openId);
			List<OperatorMobile> orgList = cRMService.getDbService().getOperatorMobileService().getNoBindingOrgList(om);
			request.setAttribute("orgList", orgList);
			//request信息
		//	request.setAttribute("command", info);
			//request.setAttribute("openId", openId);
			//request.setAttribute("publicId", publicId);
			return "opermobile/add";
		//}else{
		//	//已经绑定
		//	request.setAttribute("bindSucc", "already");
		//	return "opermobile/msg";
		//}
	}

	/**
	 * 新增 用户和手机关联关系
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public String save(OperatorMobile obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String bindSucc = "success";
		logger.info("OperatorMobileController save method openId =>" + obj.getOpenId());
		logger.info("OperatorMobileController save method publicId =>" + obj.getPublicId());
		logger.info("OperatorMobileController save method orgId =>" + obj.getOrgId());
		//密码
		obj.setCrmPass(MD5Util.digest(obj.getCrmPass()));
		
		// 调用sugar接口获取sugar的用户ID
		AuthResp aResp = cRMService.getDbService().getOperatorMobileService().bindCrmAccount(obj);
		String crmId = aResp.getCrmid();
		logger.info("OperatorMobileController save method crmId =>" + crmId);
		
		//保存crmId 到数据库    =>>> crmId 不为空 则 表示 在该 组织下对应的后台sugarCRM系统 存在 对应的 用户
		if(crmId != null && !"".equals(crmId)){
			//获取德成用户对象
			DcCrmOperator dcCrmOper = addDCCrmOper(crmId, obj.getOrgId(), aResp);
			logger.info("OperatorMobileController save method OpId =>" + dcCrmOper.getOpId());
			
			//保存 用户与手机绑定关系表
			//取OpenId 和publicId
			obj.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			obj.setPublicId(PropertiesUtil.getAppContext("app.publicId"));
			String oprst = addOperMobile(obj, crmId, dcCrmOper.getOpId());
			if(!"".equals(oprst)){
				bindSucc = oprst;
			}
			
			//绑定时数据同步到 指尖结算 //暂不处理
			//invoke_ZjbillBindData(obj.getOpenId(), obj.getOrgId());
			
			//清除缓存
			EhcacheUtil.remove("ZJWK_FEEDS_"+obj.getOpenId());
			
			//修改session默认的org列表
			UserUtil.setBindOrgList(request, cRMService.getDbService().getBusinessCardService(), obj.getOpenId());
		
		}else{
			bindSucc = "fail";
		}
		
		// 获取用户头像数据
		Object ouser = cRMService.getWxService().getWxUserinfoService().findObjById(obj.getOpenId());
		WxuserInfo wxuinfo = null;
		if (null != ouser) {
			wxuinfo = (WxuserInfo) ouser;
		}
		if (null == ouser || null == wxuinfo || null == wxuinfo.getHeadimgurl() || null == wxuinfo.getNickname()) {
			request.setAttribute("headimgurl", PropertiesUtil.getAppContext("app.content") + "/scripts/plugin/wb/css/images/user.png");
			request.setAttribute("nick", "");
		} else {
			request.setAttribute("headimgurl", wxuinfo.getHeadimgurl());
			request.setAttribute("nick", wxuinfo.getNickname());
		}

		/*request.setAttribute("openId", obj.getOpenId());
		request.setAttribute("publicId", obj.getPublicId());*/
		request.setAttribute("bindSucc", bindSucc);
		if("success".equals(bindSucc)){
			return "redirect:/sys/list";
		}else{
			return "redirect:/operMobile/msg?bindSucc=" + bindSucc;
		}
	}
	
	/**
	 * 绑定用户数据
	 * @param userid
	 * @param username
	 * @param orgid
	 * @param orgname
	 * @return
	 */
	private String invoke_ZjbillBindData(String userid, String orgid){
		logger.info("userid = >" + userid);
		logger.info("orgid = >" + orgid);
		String username = "";
		WxuserInfo wx = new WxuserInfo();
		wx.setOpenId(userid);
		Object rstwx = cRMService.getWxService().getWxUserinfoService().findObj(wx);
		if(rstwx != null){
			wx = (WxuserInfo)rstwx;
			username = wx.getNickname();
		}
		logger.info("username = >" + username);
		
		String orgname = "";
		Organization org = new Organization();
		org.setId(orgid);
		Object rstorg = cRMService.getDbService().getOrganizationService().findObj(org);
		if(rstorg != null){
			org = (Organization)rstorg;
			orgname = org.getName();
		}
		logger.info("orgname = >" + orgname);
		
		BaseError em = new BaseError();
		//调用联系人同步
		String url = PropertiesUtil.getAppContext("zjbill.url")+"/billUserEnteruser/bind";
		logger.info("url = >" + url);
		//单次调用sugar接口
		Map<String, String> paramaps = new HashMap<String, String>();
		paramaps.put("userid", userid);
		paramaps.put("username", username);
		paramaps.put("orgid", orgid);
		paramaps.put("orgname", orgname);
		paramaps.put("source", "WK");
		//调用
		String invokrst = "";
		try {
			invokrst = util.postKeyValueData(url, paramaps);
		} catch (Exception e) {
			invokrst = "";
		}
		logger.info(" invokrst => " + invokrst);
		//做空判断
		if(null == invokrst || "".equals(invokrst)){
			em.setErrorCode(ErrCode.ERR_CODE_1001006);
			em.setErrorMsg(ErrCode.ERR_CODE_1001006_MSG);
			return JSONObject.fromObject(em).toString();
		} 
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(invokrst);
		em.setErrorCode(jsonObject.getString("errorCode"));
		em.setErrorMsg(jsonObject.getString("errorMsg"));
		return JSONObject.fromObject(em).toString();
	}
	
	/**
	 * 威客系统对外提供的接口-> 异步保存数据的方法
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/wk_asycnsave")
	@ResponseBody
	public String wk_asycnsave(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String login_name = request.getParameter("login_name");
		String login_pwd = request.getParameter("login_pwd");
		String org_id = request.getParameter("org_id");
		logger.info("login_name = >" + login_name);
		logger.info("login_pwd = >" + login_pwd);
		logger.info("org_id = >" + org_id);
		if(null == login_name || "".equals(login_name) ||
			null == login_pwd || "".equals(login_pwd) ||
			null == org_id || "".equals(org_id)){
			return "{\"errorCode\":\"7\",\"errorMsg\"：\"参数填写不完整\"}";
		}
		OperatorMobile op = new OperatorMobile();
		op.setCrmAccount(login_name);
		op.setCrmPass(MD5Util.digest(login_pwd));
		op.setOrgId(org_id);
		// 调用sugar接口获取sugar的用户ID
		AuthResp aResp = cRMService.getDbService().getOperatorMobileService().bindCrmAccount(op);
		String crmId = aResp.getCrmid();
		logger.info(" asycnsave crmId =>" + crmId);
		DcCrmOperator dccrm = new DcCrmOperator();
		dccrm.setCrmId(crmId);
	    Object rstobj = cRMService.getDbService().getDcCrmOperatorService().findObj(dccrm);
	    String opid = "";
	    if(rstobj != null){
	    	dccrm = (DcCrmOperator)rstobj;
	    	opid = dccrm.getOpId();
	    }
	    logger.info(" asycnsave opid =>" + opid);
		return "{\"crmid\":\""+crmId+"\",\"opid\":\""+ opid +"\"}";
	}
	
	/**
	 * 新增 用户和手机关联关系
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/msg")
	@SuppressWarnings("unchecked")
	public String msg(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		request.setAttribute("bindSucc", request.getParameter("bindSucc"));
		//查询组织列表
		//Organization org = new Organization();
		//List<Organization> orgList = (List<Organization>)organizationService.findObjListByFilter(org);
		OperatorMobile om = new OperatorMobile();
		om.setOpenId(UserUtil.getCurrUser(request).getOpenId());
		List<OperatorMobile> orgList = cRMService.getDbService().getOperatorMobileService().getNoBindingOrgList(om);
		request.setAttribute("orgList", orgList);
		return "opermobile/add";
	}
	
	/**
	 * 保存 德成CRM用户
	 * @param crmId
	 * @param orgId
	 */

	@SuppressWarnings("unchecked")
	private DcCrmOperator addDCCrmOper(String crmId, String orgId, AuthResp aResp) throws Exception{
		//获取    德成CRM用户
		DcCrmOperator dcCrmOper = new DcCrmOperator();
		dcCrmOper.setCrmId(crmId);
		dcCrmOper.setOrgId(orgId);//企业组织ID
		
		List<DcCrmOperator> dcList =  (List<DcCrmOperator>)cRMService.getDbService().getDcCrmOperatorService().findObjListByFilter(dcCrmOper);
		if(dcList.size() == 0 ){
			dcCrmOper.setOpId(Get32Primarykey.getRandom32BeginTimePK());
			dcCrmOper.setOpStatus(Constants.DCCRMOPER_STATUS_OPEN);//启用
			copyPro(dcCrmOper, aResp);
			cRMService.getDbService().getDcCrmOperatorService().addObj(dcCrmOper);
		}else{
			dcCrmOper = dcList.get(0);
			copyPro(dcCrmOper, aResp);
			cRMService.getDbService().getDcCrmOperatorService().updateObj(dcCrmOper);
		}
		return dcCrmOper;
	}
	
	/**
	 * 复制属性
	 * @param dcCrmOper
	 * @param aResp
	 */
	private void copyPro(DcCrmOperator dcCrmOper, AuthResp aResp){
		dcCrmOper.setOpName(aResp.getOpname());
		dcCrmOper.setOpDepart(aResp.getOpdepart());
		dcCrmOper.setOpDuty(aResp.getOpduty());
		dcCrmOper.setOpMobile(aResp.getOpmobile());
		dcCrmOper.setOpEmail(aResp.getOpemail());
		dcCrmOper.setOpAddress(aResp.getOpaddress());
	}
	
	/**
	 * 保存 用户与手机绑定关系表
	 * @param crmId
	 * @param orgId
	 */

	@SuppressWarnings("unchecked")
	private String addOperMobile(OperatorMobile obj, String crmId, String opId) throws Exception{
		//获取    手机绑定关系   
		OperatorMobile search = new OperatorMobile();
		search.setCrmId(crmId);
		List<OperatorMobile> opList = (List<OperatorMobile>)cRMService.getDbService().getOperatorMobileService().findObjListByFilter(search);
		if(opList.size() > 0){
			return "already";
		}
		/*if(opList.size() > 0){
			//循环删除缓存中的数据
			for (int i = 0; i < opList.size(); i++) {
				OperatorMobile op = opList.get(i);
				String ck = "crmId_" + op.getOpenId() + "_" + op.getPublicId();
				WxCrmCacheUtil.remove(ck);
			}
			operatorMobileService.delOperMobileByCrmId(crmId);// 先删除 后新增  永远只维护一个CRMID 与手机的关系
		}*/
		//主键
		obj.setId(Get32Primarykey.getRandom32BeginTimePK());
		
		//三个条件 1.openId 2.publicId 3.opId 决定了一个用户, opId 由 crmId 和 orgId共同决定
		obj.setOpId(opId);
		
		obj.setCrmId(crmId);//冗余字段crmId
		obj.setOrgId(obj.getOrgId());//冗余字段 crmUrl TODO 
		
		// creator and date
		obj.setCreateBy("1");// 创建人ID
		obj.setCreateTime(DateTime.currentDate());// 创建时间
		//入库
		cRMService.getDbService().getOperatorMobileService().addObj(obj);
		//加入缓存
		String cacheKey = "crmId_" + obj.getOpenId() + "_" + obj.getPublicId();
		EhcacheUtil.put(cacheKey, crmId);
		
		return "";
		
	}

	/**
	 * 删除 用户和手机关联关系
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/del")
	@ResponseBody
	public String del(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");//  id
		if (null != id && !"".equals(id))
			cRMService.getDbService().getOperatorMobileService().delOperMobile(id);
		return "Y";
	}

	/**
	 * 用户和手机关联关系 详情信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// TODO
		return "";
	}
	
}
