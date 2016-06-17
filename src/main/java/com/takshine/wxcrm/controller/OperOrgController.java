package com.takshine.wxcrm.controller;

import java.net.URLDecoder;
import java.util.List;

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
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.Contact;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.WxuserInfo;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.message.sugar.ContactResp;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.CustomerResp;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.OpptyResp;
import com.takshine.wxcrm.service.Contact2SugarService;
import com.takshine.wxcrm.service.Customer2SugarService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.Oppty2SugarService;
import com.takshine.wxcrm.service.WxUserinfoService;

/**
 * 组织控制类
 * @author liulin
 *
 */
@Controller
@RequestMapping("/operorg")
public class OperOrgController {
	// 日志
	protected static Logger log = Logger.getLogger(OperOrgController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询组织列表
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String orglist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String publicId = PropertiesUtil.getAppContext("app.publicId");
		String redirectUrl = request.getParameter("redirectUrl");
		String source = request.getParameter("source");
		if(StringUtils.isNotNullOrEmptyStr(source)&&"aync".equals(source)&&StringUtils.isNotNullOrEmptyStr(redirectUrl)&&!StringUtils.regZh(redirectUrl)){
			redirectUrl = URLDecoder.decode(redirectUrl, "UTF-8");
		}
		log.info("openId =>" + openId);
		log.info("publicId =>" + publicId);
		log.info("redirectUrl =>" + redirectUrl);
		request.setAttribute("redirectUrl", redirectUrl);
		//查询用户绑定列表
		OperatorMobile obj = new OperatorMobile();
		obj.setOpenId(openId);
		List<OperatorMobile> orglist = cRMService.getDbService().getOperatorMobileService().getOrgList(obj);
		
		//如果是工作计划，则需要去掉默认组织，然后再选择
		if(StringUtils.isNotNullOrEmptyStr(source) && ("WorkReport".equals(source) || "Expense".equals(source))){
			for(int i=0;i<orglist.size();i++){
				obj = orglist.get(i);
				if(obj.getOrgId().equals(Constants.DEFAULT_ORGANIZATION)){
					orglist.remove(i);
					break;
				}
			}
		}
		
		log.info("orglist = >" + orglist.size());
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("orglist", orglist);
		if(orglist.size() > 1){
			return "commom/orglist";
		}else{
			String orgId = "";
			if(orglist.size() > 0){
				orgId = orglist.get(0).getOrgId();
				log.info("orgId = >" + orgId);
			}
			String rst = "orgId=" + orgId;
			if(redirectUrl.lastIndexOf("&") == -1 && redirectUrl.lastIndexOf("?") == -1){
				rst = "?" + rst;
			}else{
				rst = "&" + rst;
			}
			if(StringUtils.isNotNullOrEmptyStr(redirectUrl)&&redirectUrl.contains("http")){
				return "redirect:" +redirectUrl + "&orgId=" + orgId ;
			}
			return "redirect:/" + redirectUrl + rst;
		}
	}
	
	/**
	 * 选择单个组织
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/select")
	public String selectOrg(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String redirectUrl = request.getParameter("redirectUrl");
		if(StringUtils.isNotNullOrEmptyStr(redirectUrl)&&!StringUtils.regZh(redirectUrl)){
			redirectUrl = new String(redirectUrl.getBytes("ISO-8859-1"),"UTF-8");
		}
/*		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");*/
		String orgId = request.getParameter("orgId");
		if(StringUtils.isNotNullOrEmptyStr(redirectUrl)&&redirectUrl.contains("http")){
			return "redirect:" +redirectUrl + "&orgId=" + orgId ;
		}
		if(!"".equals(redirectUrl) && redirectUrl.lastIndexOf("?") == -1){
			redirectUrl += "?1=1";
		}
		log.info("redirectUrl =>" + redirectUrl);
		log.info("orgId =>" + orgId);
		return "redirect:/" + redirectUrl + "&orgId=" + orgId;/* + "&openId=" + openId + "&publicId=" + publicId*/
	}
	
	
	/**
	 * 查询组织列表
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/synclist")
	@ResponseBody
	public String syncorglist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String orgIdNot = request.getParameter("orgIdNot");
		//查询用户绑定列表
		OperatorMobile obj = new OperatorMobile();
		obj.setOpenId(openId);
		obj.setOrgIdNot(orgIdNot);
		List<OperatorMobile> orglist = cRMService.getDbService().getOperatorMobileService().getOrgList(obj);
		
		return JSONArray.fromObject(orglist).toString();
	}
	
	
	/**
	 * 查询组织列表
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/synorglist")
	@ResponseBody
	public String synorglist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String partyId = request.getParameter("partyId");
		String orgIdNot = request.getParameter("orgIdNot");
		//根据partyid查找openId
		WxuserInfo wxuser = new WxuserInfo();
		wxuser.setParty_row_id(partyId);
		wxuser = cRMService.getWxService().getWxUserinfoService().getWxuserInfo(wxuser);
		if(!StringUtils.isNotNullOrEmptyStr(wxuser.getOpenId())){
			return "";
		}
		//查询用户绑定列表
		OperatorMobile obj = new OperatorMobile();
		obj.setOpenId(wxuser.getOpenId());
		obj.setOrgIdNot(orgIdNot);
		List<OperatorMobile> orglist = cRMService.getDbService().getOperatorMobileService().getOrgList(obj);
		return JSONArray.fromObject(orglist).toString();
	}
	
	
	/**
	 * 同步数据
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/importRecord")
	@ResponseBody
	public String importRecord(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String openId = UserUtil.getCurrUser(request).getOpenId();
		String targetOrgId = request.getParameter("targetOrgId");
		String sourceOrgId = request.getParameter("sourceOrgId");
		String parentid = request.getParameter("parentid");
		String parenttype = request.getParameter("parenttype");
		
		if(!StringUtils.isNotNullOrEmptyStr(openId) || !StringUtils.isNotNullOrEmptyStr(targetOrgId) || !StringUtils.isNotNullOrEmptyStr(parentid) || !StringUtils.isNotNullOrEmptyStr(parenttype)){
			//throw Exception();
		}
		String rst = "";
		String sourceCrmId = getNewCrmId(openId,sourceOrgId);
		String targetCrmId = getNewCrmId(openId,targetOrgId);
		//同步客户
		if("Accounts".equals(parenttype)){
			Customer cust = new Customer();
			cust.setRowId(parentid);
			cust.setCrmId(sourceCrmId);
			cust.setOrgId(sourceOrgId);
			CustomerResp resp = cRMService.getSugarService().getCustomer2SugarService().getCustomerSingle(cust, "WEB");
			if(null != resp){
				List<CustomerAdd> custList = resp.getCustomers();
				if(null != custList && custList.size()>0){
					CustomerAdd custadd = custList.get(0);
					cust = new Customer();
					cust.setCrmId(targetCrmId);
					cust.setOrgId(targetOrgId);
					cust.setName(custadd.getName());
					cust.setPhoneoffice(custadd.getPhoneoffice());
					cust.setAccnttype(custadd.getAccnttype());
					cust.setIndustry(custadd.getIndustry());
					cust.setStreet(custadd.getStreet());
					cust.setAnnualrevenue(custadd.getAnnualrevenue());
					cust.setDesc(custadd.getDesc());
					cust.setWebsite(custadd.getWebsite());
					cust.setPhonefax(custadd.getPhonefax());
					cust.setPostalcode(custadd.getPostalcode());
					cust.setTickersymbol(custadd.getTickersymbol());
					cust.setEmployees(custadd.getEmployees());
					cust.setSiccode(custadd.getSiccode());
					cust.setAssignerid(targetCrmId);
					cust.setStar(custadd.getStar());  //星标
					cust.setLegal(custadd.getLegal());
					cust.setRegistered(custadd.getRegistered());
					cust.setNature(custadd.getNature());
					cust.setNaturename(custadd.getNaturename());
					cust.setProduct(custadd.getProduct());
					cust.setCustomer(custadd.getCustomer());
					cust.setBrand(custadd.getBrand());
					cust.setSource(custadd.getSource());
					cust.setSourcename(custadd.getSourcename());
					cust.setBuilddate(custadd.getBuilddate());
					cust.setRegistmark(custadd.getRegistmark());
					cust.setRegistadress(custadd.getRegistadress());
					cust.setParentcompany(custadd.getParentcompany());
					cust.setChildcompany(custadd.getChildcompany());
					cust.setFirms(custadd.getFirms());
					cust.setSalesregions(custadd.getSalesregions());
					cust.setAbbreviation(custadd.getAbbreviation());
					
					CrmError crmErr = cRMService.getSugarService().getCustomer2SugarService().addCustomer(cust);
					if("0".equals(crmErr.getErrorCode())){
						rst = "0";
					}else{
						rst = crmErr.getErrorMsg();
					}
				}else{
					rst = "没有找到客户";
				}
			}else{
				rst = "没有找到客户";
			}
		}
		//同步商机
		else if("Opportunities".equals(parenttype)){
			OpptyResp resp = cRMService.getSugarService().getOppty2SugarService().getOpportunitySingle(parentid, sourceCrmId);
			if(null != resp){
				List<OpptyAdd> opptyList = resp.getOpptys();
				if(null != opptyList && opptyList.size()>0){
					OpptyAdd oppty = opptyList.get(0);
					
					//添加业务机会前，需要先导入客户
					Customer cust = new Customer();
					cust.setRowId(oppty.getCustomerid());
					cust.setCrmId(sourceCrmId);
					cust.setOrgId(sourceOrgId);
					CustomerResp custResp = cRMService.getSugarService().getCustomer2SugarService().getCustomerSingle(cust, "WEB");
					if(null != custResp){
						List<CustomerAdd> custList = custResp.getCustomers();
						if(null != custList && custList.size()>0){
							CustomerAdd custadd = custList.get(0);
							cust = new Customer();
							cust.setCrmId(targetCrmId);
							cust.setOrgId(targetOrgId);
							cust.setName(custadd.getName());
							cust.setPhoneoffice(custadd.getPhoneoffice());
							cust.setAccnttype(custadd.getAccnttype());
							cust.setIndustry(custadd.getIndustry());
							cust.setStreet(custadd.getStreet());
							cust.setAnnualrevenue(custadd.getAnnualrevenue());
							cust.setDesc(custadd.getDesc());
							cust.setWebsite(custadd.getWebsite());
							cust.setPhonefax(custadd.getPhonefax());
							cust.setPostalcode(custadd.getPostalcode());
							cust.setTickersymbol(custadd.getTickersymbol());
							cust.setEmployees(custadd.getEmployees());
							cust.setSiccode(custadd.getSiccode());
							cust.setAssignerid(targetCrmId);
							cust.setStar(custadd.getStar());  //星标
							cust.setLegal(custadd.getLegal());
							cust.setRegistered(custadd.getRegistered());
							cust.setNature(custadd.getNature());
							cust.setNaturename(custadd.getNaturename());
							cust.setProduct(custadd.getProduct());
							cust.setCustomer(custadd.getCustomer());
							cust.setBrand(custadd.getBrand());
							cust.setSource(custadd.getSource());
							cust.setSourcename(custadd.getSourcename());
							cust.setBuilddate(custadd.getBuilddate());
							cust.setRegistmark(custadd.getRegistmark());
							cust.setRegistadress(custadd.getRegistadress());
							cust.setParentcompany(custadd.getParentcompany());
							cust.setChildcompany(custadd.getChildcompany());
							cust.setFirms(custadd.getFirms());
							cust.setSalesregions(custadd.getSalesregions());
							cust.setAbbreviation(custadd.getAbbreviation());
							
							CrmError crmErr = cRMService.getSugarService().getCustomer2SugarService().addCustomer(cust);
							if("0".equals(crmErr.getErrorCode()) || "100008".equals(crmErr.getErrorCode())){
								String custid = crmErr.getRowId();
								//导入客户后，再导入业务机会
								Opportunity op = new Opportunity();
								op.setCrmId(targetCrmId);
								op.setOrgId(targetOrgId);
								op.setCustomerid(custid);
								op.setOpptyname(oppty.getName());//业务机会名称
								op.setAmount(oppty.getAmount());//业务机会金额
								op.setDateclosed(oppty.getDateclosed());
								op.setProbability(oppty.getProbability());
								op.setOpptytype(oppty.getOpptytype());
								op.setLeadsource(oppty.getLeadsource());
								op.setSalesstage(oppty.getSalesstage());
								op.setAssignId(targetCrmId);
								op.setDesc(oppty.getDesc());
								op.setCampaigns(oppty.getCampaigns());
								op.setLoseDesc(oppty.getLoseDesc());//丢单描述
								op.setNextstep(oppty.getNextstep());//下一步骤
								op.setFailreason(oppty.getFailreason());//失败原因
								op.setFactdateclosed(oppty.getFactdateclosed());//实际关闭日期
								op.setCompetitive(oppty.getCompetitive()); //竞争策略
								
								crmErr = cRMService.getSugarService().getOppty2SugarService().addOppty(op);
								if("0".equals(crmErr.getErrorCode())){
									rst = "0";
								}else{
									rst = crmErr.getErrorMsg();
								}
								
							}else{
								rst = crmErr.getErrorMsg();
							}
						}else{
							rst = "没有找到客户";
						}
					}else{
						rst = "没有找到客户";
					}
					
				}else{
					rst = "没有找到业务机会";
				}
			}else{
				rst = "没有找到业务机会";
			}
		}
		//同步联系人
		else if("Contacts".equals(parenttype)){
			//查找原联系人
			ContactResp resp = cRMService.getSugarService().getContact2SugarService().getContactSingle(parentid, sourceCrmId);
			if(null != resp){
				List<ContactAdd> conList = resp.getContacts();
				if(null != conList && conList.size() >0){
					//将联系人导入到新的org
					ContactAdd conadd = conList.get(0);
					Contact con = new Contact();
					con.setCrmId(targetCrmId);
					con.setSalutation(conadd.getSalutation());//称谓
					con.setConname(conadd.getConname());//姓名
					con.setEmail0(conadd.getEmail0());//邮箱
					con.setConaddress(conadd.getConaddress());//地址
					con.setConjob(conadd.getConjob());//职位
					con.setPhonemobile(conadd.getPhonemobile());//移动电话
					con.setPhonework(conadd.getPhonework());//办公电话
					con.setDepartment(conadd.getDepartment());//部门
					con.setAssignerId(targetCrmId);//责任人ID
					con.setFilename(conadd.getFilename());//图片名称
					con.setTimefre(conadd.getTimefre());//联系人频率
					con.setConaddress(conadd.getConaddress());
					con.setDesc(conadd.getDesc());
					con.setOrgId(targetOrgId);
					CrmError crmErr = cRMService.getSugarService().getContact2SugarService().addContact(con);
					if("0".equals(crmErr.getErrorCode())){
						rst = "0";
					}else{
						rst = crmErr.getErrorMsg();
					}
				}else{
					rst = "没有找到联系人";
				}
			}else{
				rst = "没有找到联系人";
			}
		}
		return rst;
	}
	
	
	private String getNewCrmId(String openId,String orgId) throws Exception{
		try {
			if(StringUtils.isNotNullOrEmptyStr(orgId)){
				String newCrmId = cRMService.getSugarService().getCustomer2SugarService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
				if(StringUtils.isNotNullOrEmptyStr(newCrmId)){
					return newCrmId;
				}
			}
		} catch (Exception e) {
			log.info("error mesg = >" + e.getMessage());
		}
		return "";
	}
}
