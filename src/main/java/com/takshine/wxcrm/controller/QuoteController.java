package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.base.util.cache.RedisCacheUtil;
import com.takshine.wxcrm.domain.Share;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ProductQuoteAdd;
import com.takshine.wxcrm.message.sugar.QuoteAdd;
import com.takshine.wxcrm.message.sugar.QuoteResp;
import com.takshine.wxcrm.message.sugar.ShareAdd;
import com.takshine.wxcrm.message.sugar.ShareResp;

/**
 * 报价页面控制器
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/quote")
public class QuoteController {
	// 日志
	protected static Logger logger = Logger.getLogger(QuoteController.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询报价列表
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.info("QuoteController acclist method begin=>");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String viewtype = request.getParameter("viewtype");
		String name = request.getParameter("name");
		String status = request.getParameter("quotestatus");
		String assignerid = request.getParameter("assignerid");
		String startdate = request.getParameter("startdate");
		String enddate = request.getParameter("enddate");
		String customername = request.getParameter("customername");
		viewtype = (null==viewtype?"myview":viewtype);
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(customername)&&!StringUtils.regZh(customername)){
			customername = new String(customername.getBytes("ISO-8859-1"),"UTF-8");
		}
		String orderString = request.getParameter("orderString");
		logger.info("QuoteController list method openId =>" + openId);
		logger.info("QuoteController list method publicId =>" + publicId);
		logger.info("QuoteController list method currpage =>" + currpage);
		logger.info("QuoteController list method pagecount =>" + pagecount);
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			QuoteAdd quote = new QuoteAdd();
			quote.setCrmaccount(crmId);
			quote.setPagecount(pagecount);
			quote.setCurrpage(currpage);
			quote.setViewtype(viewtype);
			if(null != startdate && !"".equals(startdate)){
				quote.setStartdate(startdate.replaceAll("-",""));
			}
			if(null != enddate && !"".equals(enddate)){
				quote.setEnddate(enddate.replaceAll("-",""));
			}
			quote.setAssignerid(assignerid);
			quote.setName(name);
			quote.setCustomername(customername);
			quote.setQuotestatus(status);
			quote.setOrderString(orderString);
			quote.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			QuoteResp sResp = cRMService.getSugarService().getQuote2CrmService().getQuoteList(quote,"WEB");
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				request.setAttribute("quotes", sResp.getQuotes());
				//获取下拉列表信息和 责任人的用户列表信息 
				Map<String, Map<String, String>> mpSta = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
				request.setAttribute("statusDom", mpSta.get("quote_status_list"));
			}else{
				if(!ErrCode.ERR_CODE_1001004.equals(errorCode)){
					throw new Exception("错误编码：" + sResp.getErrcode() + "，错误描述：" + sResp.getErrmsg());
				}
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		//requestinfo
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		request.setAttribute("pagecount", pagecount);
		request.setAttribute("currpage", currpage);
		request.setAttribute("startdate", startdate);
		request.setAttribute("enddate", enddate);
		request.setAttribute("assignerid", assignerid);
		request.setAttribute("name", name);
		request.setAttribute("customername", customername);
		request.setAttribute("status", status);
		request.setAttribute("viewtype", viewtype);
		return "quote/list";
	}
	
	
	/**
	 * 异步查询报价列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/asylist")
	@ResponseBody
	public String asylist(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("QuoteController acclist method begin=>");
		String str = "";
		//error 对象
		CrmError crmErr = new CrmError();
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String viewtype = request.getParameter("viewtype");
		String name = request.getParameter("name");
		String status = request.getParameter("status");
		String assignerid = request.getParameter("assignerid");
		String startdate = request.getParameter("startdate");
		String enddate = request.getParameter("enddate");
		String customername = request.getParameter("customername");
		viewtype = (null==viewtype?"myview":viewtype);
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(customername)&&!StringUtils.regZh(customername)){
			customername = new String(customername.getBytes("ISO-8859-1"),"UTF-8");
		}
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		String orderString = request.getParameter("orderString");
		logger.info("QuoteController acclist method openId =>" + openId);
		logger.info("QuoteController acclist method publicId =>" + publicId);
		logger.info("QuoteController list method viewtype =>" + viewtype);
		logger.info("QuoteController list method currpage =>" + currpage);
		logger.info("QuoteController list method pagecount =>" + pagecount);
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			QuoteAdd quote = new QuoteAdd();
			quote.setCrmaccount(crmId);
			quote.setPagecount(pagecount);
			quote.setCurrpage(currpage);
			quote.setViewtype(viewtype);
			if(null != startdate && !"".equals(startdate)){
				quote.setStartdate(startdate.replaceAll("-",""));
			}
			if(null != enddate && !"".equals(enddate)){
				quote.setEnddate(enddate.replaceAll("-",""));
			}
			quote.setAssignerid(assignerid);
			quote.setName(name);
			quote.setCustomername(customername);
			quote.setStatus(status);
			quote.setOrderString(orderString);
			quote.setOpenId(UserUtil.getCurrUser(request).getOpenId());
			QuoteResp sResp = cRMService.getSugarService().getQuote2CrmService().getQuoteList(quote,"WEB");
			String errorCode = sResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<QuoteAdd> cList = sResp.getQuotes();
				logger.info("cList is ->" + cList.size());
				str = JSONArray.fromObject(cList).toString();
				logger.info("str is ->" + str);
				return str;
			}else{
			    crmErr.setErrorCode(sResp.getErrcode());
			    crmErr.setErrorMsg(sResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 增加报价明细
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addMxquote")
	public String addMxquote(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String parentId = request.getParameter("parentId");
		String opptyId = request.getParameter("opptyId");
		String source = request.getParameter("source");
		String crmId = request.getParameter("crmId");
		String orgId = request.getParameter("orgId");
		logger.info("QuoteController addMxquote method crmId =>" + crmId);
		logger.info("QuoteController addMxquote method openId =>" + openId);
		logger.info("QuoteController addMxquote method publicId =>" + publicId);
		logger.info("QuoteController addMxquote method opptyId =>" + opptyId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			request.setAttribute("parentId", parentId);
			request.setAttribute("crmId", crmId);
			request.setAttribute("orgId", orgId);
			request.setAttribute("opptyId", opptyId);
			request.setAttribute("source", source);
			return "quote/addMxquote";
		}else{
			throw new Exception("操作失败!错误编号:"+ErrCode.ERR_CODE_1001001+"错误描述:"+ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 保存报价明细
	 * @param productQuoteAdd
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveMxquote")
	public String saveMxquote(ProductQuoteAdd productQuoteAdd,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String opptyId = request.getParameter("opptyId");
		String crmId = request.getParameter("crmId");
		String orgId = request.getParameter("orgId");
		String flag = request.getParameter("mxquoteflag");
		String source = request.getParameter("source");
		logger.info("QuoteController saveMxquote method crmId =>" + crmId);
		logger.info("QuoteController saveMxquote method openId =>" + openId);
		logger.info("QuoteController saveMxquote method publicId =>" + publicId);
		logger.info("QuoteController saveMxquote method opptyId =>" + opptyId);
		logger.info("QuoteController saveMxquote method source =>" + source);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			productQuoteAdd.setCrmaccount(crmId);
			productQuoteAdd.setAssignerid(crmId);
			CrmError crmError = cRMService.getSugarService().getQuote2CrmService().saveMxquote(productQuoteAdd);
			String errorcode = crmError.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorcode)){
				if("continue".equals(flag)){
					request.setAttribute("parentId", productQuoteAdd.getParentid());
					request.setAttribute("openId", openId);
					request.setAttribute("publicId", publicId);
					request.setAttribute("crmId", crmId);
					request.setAttribute("opptyId", opptyId);
					request.setAttribute("source", source);
					request.setAttribute("orgId", orgId);
					return "quote/addMxquote";
				}else{
					if("oppty".equals(source)){
						return "redirect:/oppty/detail?openId="+openId+"&publicId="+publicId+"&rowId="+opptyId+"&orgId="+orgId;
					}else{
						return "redirect:/quote/detail?openId="+openId+"&publicId="+publicId+"&rowId="+productQuoteAdd.getParentid()+"&orgId="+orgId;
					}
				}
			}else{
				throw new Exception("操作失败!错误编号:"+crmError.getErrorCode()+"错误描述:"+crmError.getErrorMsg());
			}
		}else{
			throw new Exception("操作失败!错误编号:"+ErrCode.ERR_CODE_1001001+"错误描述:"+ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 增加报价
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/get")
	public String add(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String orgId = request.getParameter("orgId");
		String source = request.getParameter("source");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String parentId = request.getParameter("parentId");
		String parentName = request.getParameter("parentName");
		if(StringUtils.isNotNullOrEmptyStr(parentName)&&!StringUtils.regZh(parentName)){
			parentName= new String(parentName.getBytes("ISO-8859-1"),"UTF-8");
		}
		String parenttype = request.getParameter("parentType");
		String quotecode = Get32Primarykey.get8RandomValiteCode(8);
//		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String crmId = getNewCrmId(request);
		logger.info("QuoteController add method crmId =>" + crmId);
		logger.info("QuoteController add method openId =>" + openId);
		logger.info("QuoteController add method publicId =>" + publicId);
		logger.info("QuoteController add method orgId =>" + orgId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			request.setAttribute("orgId", orgId);
			request.setAttribute("source", source);
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			request.setAttribute("parentId", parentId);
			request.setAttribute("parentName", parentName);
			request.setAttribute("crmId", crmId);
			request.setAttribute("parenttype", parenttype);
			request.setAttribute("quotecode", quotecode);
			return "quote/add";
		}else{
			throw new Exception("操作失败!错误编号:"+ErrCode.ERR_CODE_1001001+"错误描述:"+ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 保存报价
	 * @param quoteAdd
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/save")
	public String save(QuoteAdd quoteAdd,HttpServletRequest request,HttpServletResponse response)throws Exception{
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		//String crmId = UserUtil.getCurrUser(request).getCrmId();
		String crmId = cRMService.getSugarService().getQuote2CrmService().getCrmIdByOrgId(openId, publicId, quoteAdd.getOrgId());
		quoteAdd.setAssignerid(crmId);
		String source = request.getParameter("source");
		logger.info("QuoteController save method crmId =>" + crmId);
		logger.info("QuoteController save method openId =>" + openId);
		logger.info("QuoteController save method publicId =>" + publicId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			quoteAdd.setCrmaccount(getNewCrmId(request));
			quoteAdd.setAssignerid(crmId);
			CrmError crmError = cRMService.getSugarService().getQuote2CrmService().saveQuote(quoteAdd);
			String errorcode = crmError.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorcode)){
				return "redirect:/quote/addMxquote?openId="+openId+"&publicId="+publicId+"&parentId="+crmError.getRowId()+"&opptyId="+quoteAdd.getParentid()+"&source="+source;
			}else{
				throw new Exception("操作失败!错误编号:"+crmError.getErrorCode()+"错误描述:"+crmError.getErrorMsg());
			}
		}else{
			throw new Exception("操作失败!错误编号:"+ErrCode.ERR_CODE_1001001+"错误描述:"+ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 查询新的crmid
	 * @param request
	 * @return
	 */
	private String getNewCrmId(HttpServletRequest request) throws Exception{
		String crmId = request.getParameter("crmId");// crmIdID
		String orgId = request.getParameter("orgId");
		if(!StringUtils.isNotNullOrEmptyStr(orgId)){
			return UserUtil.getCurrUser(request).getCrmId();
		}
		try {
			if(StringUtils.isNotNullOrEmptyStr(orgId)){
				String openId = UserUtil.getCurrUser(request).getOpenId();
				logger.info("openId = >" + openId);
				String newCrmId = cRMService.getSugarService().getQuote2CrmService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
				if(StringUtils.isNotNullOrEmptyStr(newCrmId)){
					return newCrmId;
				}
			}
		} catch (Exception e) {
			logger.info("error mesg = >" + e.getMessage());
		}
		return crmId;
	}
	
	/**
	 * 报价详情信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("QuoteController detail method begin=>");
		String rowId = request.getParameter("rowId");//  rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		logger.info("QuoteController detail method rowId =>" + rowId);
		logger.info("QuoteController detail method openId =>" + openId);
		logger.info("QuoteController detail method publicId =>" + publicId);
		String orgId = request.getParameter("orgId");
		// 绑定对象
		String crmId = "";
		Object obj = RedisCacheUtil.get(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId);
		if(null==obj){
			crmId = cRMService.getSugarService().getQuote2CrmService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		}else{
			crmId = (String)obj;
		}
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		RedisCacheUtil.set(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId,crmId);
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			QuoteResp quoResp = cRMService.getSugarService().getQuote2CrmService().getQuoteSingle(rowId, crmId);
			String errorCode = quoResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<QuoteAdd> list = quoResp.getQuotes();
				//放到页面上
				if(null != list && list.size() > 0){
					request.setAttribute("quoteName", list.get(0).getName());
					//审批历史
					if(list.get(0).getApproves()!=null&&list.get(0).getApproves().size()>0){
						request.setAttribute("approList", list.get(0).getApproves());
					}
					if(list.get(0).getApproves()!=null&&list.get(0).getAudits().size()>0){
						request.setAttribute("auditList", list.get(0).getAudits());
					}
					request.setAttribute("sd", list.get(0));
				}else{
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
				throw new Exception("错误编码：" + quoResp.getErrcode() + "，错误描述：" + quoResp.getErrmsg());
			}
//			//获取当前操作用户
//			UserReq currReq = new UserReq();
//			currReq.setCrmaccount(crmId);
//			currReq.setFlag("single");
//			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
//			currReq.setCurrpage("1");
//			currReq.setPagecount("1000");
//			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
//			currResp.getUsers();
//			if(null != currResp.getUsers() && null != currResp.getUsers().get(0).getUsername()){
//				request.setAttribute("assigner", currResp.getUsers().get(0).getUsername());
//			}
			//查询当前报价下关联的共享用户
			Share share = new Share();
			share.setParentid(rowId);
			share.setParenttype("Quote");
			share.setCrmId(crmId);
			ShareResp sresp = cRMService.getSugarService().getShare2SugarService().getShareUserList(share, "WX");
			List<ShareAdd> shareAdds = sresp.getShares();
			request.setAttribute("shareusers", shareAdds);
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		//requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		//分享控制按钮
		request.setAttribute("shareBtnContol", request.getParameter("shareBtnContol"));
		return "quote/detail";
	}

	/**
	 * 报价明细详情页面
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/mxdetail")
	public String mxdetail(HttpServletRequest request,HttpServletResponse response) throws Exception {
		String rowId = request.getParameter("rowId");//  rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String parentId = request.getParameter("parentId");
		logger.info("QuoteController mxdetail method rowId =>" + rowId);
		logger.info("QuoteController mxdetail method openId =>" + openId);
		logger.info("QuoteController mxdetail method publicId =>" + publicId);
		//绑定对象
		String crmId = request.getParameter("crmId");
		String orgId = request.getParameter("orgId");
		logger.info("crmId:-> is =" + crmId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			//获取当前操作用户
//			UserReq currReq = new UserReq();
//			currReq.setCrmaccount(crmId);
//			currReq.setFlag("single");
//			currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
//			currReq.setCurrpage("1");
//			currReq.setPagecount("1000");
//			UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
//			currResp.getUsers();
//			if(null != currResp.getUsers() && null != currResp.getUsers().get(0).getUsername()){
//				request.setAttribute("assigner", currResp.getUsers().get(0).getUsername());
//			}
			ProductQuoteAdd productQuoteAdd = cRMService.getSugarService().getQuote2CrmService().getMxQuote(rowId,crmId);
			if(null!=productQuoteAdd){
				request.setAttribute("openId", openId);
				request.setAttribute("publicId", publicId);
				request.setAttribute("rowId", rowId);
				request.setAttribute("crmId", crmId);
				request.setAttribute("orgId", orgId);
				request.setAttribute("ga", productQuoteAdd);
				request.setAttribute("parentId", parentId);
				return "quote/mxdetail";
			}else{
				throw new Exception("错误编码：" + productQuoteAdd.getErrcode() + "，错误描述：" + productQuoteAdd.getErrmsg());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 修改报价明细
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updatemxquote")
	public String updatemxquote(ProductQuoteAdd productQuoteAdd,HttpServletRequest request,HttpServletResponse response) throws Exception {
		String rowId = productQuoteAdd.getRowid();//  rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		logger.info("QuoteController updatemxquote method rowId =>" + rowId);
		logger.info("QuoteController updatemxquote method openId =>" + openId);
		logger.info("QuoteController updatemxquote method publicId =>" + publicId);
		//绑定对象
		String crmId =request.getParameter("crmId");
		
		logger.info("crmId:-> is =" + crmId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			productQuoteAdd.setCrmaccount(crmId);
			CrmError crmError = cRMService.getSugarService().getQuote2CrmService().updateMxQuote(productQuoteAdd);
			String errorCode = crmError.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				if("del".equals(productQuoteAdd.getOptype())){
					return "redirect:/quote/detail?orgId="+request.getParameter("orgId")+"openId="+openId+"&publicId="+publicId+"&rowId="+productQuoteAdd.getParentid();
				}else{
					return "redirect:/quote/mxdetail?openId="+openId+"&publicId="+publicId+"&rowId="+rowId+"&crmId="+crmId;
				}
			}else{
				throw new Exception("错误编码：" + crmError.getErrorCode() + "，错误描述：" + crmError.getErrorMsg());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	
	/**
	 * 复制报价单
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/copyquote")
	public String copyquote(HttpServletRequest request,HttpServletResponse response) throws Exception {
		String rowId = request.getParameter("rowId");//  rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String type = request.getParameter("type");
		logger.info("QuoteController copyquote method rowId =>" + rowId);
		logger.info("QuoteController copyquote method openId =>" + openId);
		logger.info("QuoteController copyquote method publicId =>" + publicId);
		//绑定对象
		String crmId = request.getParameter("crmId");
		logger.info("crmId:-> is =" + crmId);
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			CrmError crmError = cRMService.getSugarService().getQuote2CrmService().copyQuote(rowId,crmId,type);
			String errorCode = crmError.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				return "redirect:/quote/modify?openId="+openId+"&publicId="+publicId+"&rowId="+crmError.getRowId()+"&orgId="+request.getParameter("orgId");
			}else{
				throw new Exception("错误编码：" + crmError.getErrorCode() + "，错误描述：" + crmError.getErrorMsg());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
	}
	/**
	 * 报价详情信息(修改页面)
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/modify")
	public String modify(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("QuoteController detail method begin=>");
		String rowId = request.getParameter("rowId");//  rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		logger.info("QuoteController detail method rowId =>" + rowId);
		logger.info("QuoteController detail method openId =>" + openId);
		logger.info("QuoteController detail method publicId =>" + publicId);
		String orgId = request.getParameter("orgId");
		// 绑定对象
		String crmId = "";
		Object obj = RedisCacheUtil.get(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId);
		if(null==obj){
			crmId = cRMService.getSugarService().getQuote2CrmService().getCrmIdByOrgId(openId, PropertiesUtil.getAppContext("app.publicId"), orgId);
		}else{
			crmId = (String)obj;
		}
		if(!StringUtils.isNotNullOrEmptyStr(crmId)){
			crmId = UserUtil.getCurrUser(request).getCrmId();
		}
		RedisCacheUtil.set(Constants.ZJWK_UNIQUE_ACCOUNT+openId+"_"+orgId,crmId);
		logger.info("crmId:-> is =" + crmId);
		//获取绑定的账户 在sugar系统的id
		if(!"".equals(crmId)){
			QuoteResp quoResp = cRMService.getSugarService().getQuote2CrmService().getQuoteSingle(rowId, crmId);
			String errorCode = quoResp.getErrcode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				List<QuoteAdd> list = quoResp.getQuotes();
				//放到页面上
				if(null != list && list.size() > 0){
					request.setAttribute("quoteName", list.get(0).getName());
//					//获取当前操作用户
//					UserReq currReq = new UserReq();
//					currReq.setCrmaccount(crmId);
//					currReq.setFlag("single");
//					currReq.setViewtype(Constants.SEARCH_VIEW_TYPE_TEAMVIEW);//新建任务时候 查询 我团队的用户
//					currReq.setCurrpage("1");
//					currReq.setPagecount("1000");
//					UsersResp currResp = cRMService.getSugarService().getLovUser2SugarService().getUserList(currReq);
//					currResp.getUsers();
//					if(null != currResp.getUsers() && null != currResp.getUsers().get(0).getUsername()){
//						request.setAttribute("assigner", currResp.getUsers().get(0).getUsername());
//					}
					//获取下拉列表信息和 责任人的用户列表信息 
					Map<String, Map<String, String>> mpSta = cRMService.getSugarService().getLovUser2SugarService().getLovList(crmId);
					request.setAttribute("statusDom", mpSta.get("quote_status_list"));
					//审批历史
					if(list.get(0).getApproves()!=null&&list.get(0).getApproves().size()>0){
						request.setAttribute("approList", list.get(0).getApproves());
					}
					request.setAttribute("con", list.get(0));
				}else{
					throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001003 + "，错误描述：" + ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
				throw new Exception("错误编码：" + quoResp.getErrcode() + "，错误描述：" + quoResp.getErrmsg());
			}

		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		//requestinfo
		request.setAttribute("rowId", rowId);
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("crmId", crmId);
		//分享控制按钮
		request.setAttribute("shareBtnContol", request.getParameter("shareBtnContol"));
		return "quote/modify";
	}
	
	/**
	 * 报价审批
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/update")
	public String update(QuoteAdd obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String rowId = request.getParameter("rowId");
		String crmId = request.getParameter("crmId");
		logger.info("crmId:-> is =" + crmId);
		String approvalstatus=obj.getApprovalstatus();//审批状态
		if (null != crmId && !"".equals(crmId)) {
			obj.setCrmaccount(crmId);
			obj.setRowid(rowId);
			CrmError crmErr = cRMService.getSugarService().getQuote2CrmService().updateQuote(obj);
			String str="";
			String url="/quote/detail?rowId="+rowId+"&parentid="+ obj.getParentid()+"&orgId="+obj.getOrgId();
			String errorCode = crmErr.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errorCode)){
				request.setAttribute("openId", openId);
				request.setAttribute("publicId", publicId);
				request.setAttribute("rowId", rowId);
				request.setAttribute("crmId", crmId);
				//发消微信息提醒
				if("approving".equals(approvalstatus)||("approved".equals(approvalstatus)&&StringUtils.isNotNullOrEmptyStr(obj.getApprovalid()))){//给审批人推送消息
					str="您有一笔报价提交给您审批,";
					//推送审批消息  Commitid 审批人ID
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getApprovalid(),str,url);
				}
				if("reject".equals(approvalstatus)){//报销被驳回  给费用对象发送消息
					str="您有一笔报价被驳回,";
					//推送审批消息 Assignid 费用对象ID
					cRMService.getWxService().getWxRespMsgService().respCommCustMsgByCrmId(obj.getAssignerid(), str,url);
				}
			}else{
				throw new Exception("错误编码：" + crmErr.getErrorCode() + "，错误描述：" + crmErr.getErrorMsg());
			}
		}else{
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
		}
		//取消动作
		if(!"cancel".equals(obj.getType())){
			String commitid = obj.getCommitid();//审批人ID
			if(null != commitid && !"".equals(commitid)){
				//commitid不为空 则指定了审批人 
				return "redirect:/quote/list?openId="+ openId+ "&publicId="+ publicId;
			}else{
				//commitid为空  则表示为 “保存动作”
				return "redirect:/quote/modify?rowId="+ rowId +"&openId="+ openId+ "&publicId="+ publicId+"&orgId="+obj.getOrgId();
			}
		}else{
			return "redirect:/quote/list?openId="+ openId+ "&publicId="+ publicId;
		}
	}

	/**
	 * 删除查询条件
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delcache")
	@ResponseBody
	public String delcache(HttpServletRequest request,HttpServletResponse response)throws Exception{
		String name = request.getParameter("name");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			List<String> searchList = new ArrayList<String>();
			Set<String> rs = RedisCacheUtil.getSortedSetRange("quote_search_"+ crmId, 0, 0);
			RedisCacheUtil.delete("quote_search_" + crmId);
			if(rs!=null&&rs.size()==1){
				rs =new HashSet<String>();
			}
			try{
				for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
					String searchcon = (String) iterator.next();
					logger.info("QuoteController searchcache method searchcon=>"+ searchcon);
					if(!searchcon.contains(name)){
						searchList.add(searchcon);
					}
				}
				for (int i = 0; i < searchList.size(); i++) {
					RedisCacheUtil.addToSortedSet("quote_search_"+crmId, searchList.get(i), i);
				}
				crmErr.setErrorCode("0");
			}catch(Exception e){
				e.printStackTrace();
				crmErr.setErrorCode("9");
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 保存查询条件
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/savesearch")
	@ResponseBody
	public String savesearch(HttpServletRequest request,
			HttpServletResponse response)throws Exception{
		String assignerid=request.getParameter("assignerid");
		String name = request.getParameter("name");
		String status =request.getParameter("status");
		String searchname =request.getParameter("searchname");
		String modifydateflag =request.getParameter("modifydateflag");
		String customername =request.getParameter("customername");
		if(StringUtils.isNotNullOrEmptyStr(searchname)&&!StringUtils.regZh(searchname)){
			searchname = new String(searchname.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(customername)&&!StringUtils.regZh(customername)){
			customername = new String(customername.getBytes("ISO-8859-1"),"UTF-8");
		}
		if(StringUtils.isNotNullOrEmptyStr(name)&&!StringUtils.regZh(name)){
			name = new String(name.getBytes("ISO-8859-1"),"UTF-8");
		}
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		String searchcon=searchname+"|"+"name:"+name+"|"+"status:"+status+"|"+"assignerid:"+assignerid+"|"+"customername1:"+customername+"|"+"modifydateflag:"+modifydateflag;
		logger.info("QuoteController  savesearch method crmId =>" + crmId);
		logger.info("QuoteController  savesearch method searchcon =>" + searchcon);
		CrmError crmErr = new CrmError();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			//cache
			List<String> searchList = new ArrayList<String>();
			searchList.add(searchcon);
			try{
				for (int i = 0; i < searchList.size(); i++) {
					RedisCacheUtil.addToSortedSet("quote_search_"+crmId, searchList.get(i), i);
				}
				crmErr.setErrorCode("0");
			}catch(Exception e){
				e.printStackTrace();
				crmErr.setErrorCode("9");
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 加载缓存的查询条件
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/searchcache")
	@SuppressWarnings("rawtypes")
	@ResponseBody
	public String searchcache(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("QuoteController searchcache method crmId =>" + crmId);
		// cache
		List<String> sealist = new ArrayList<String>();
		if(StringUtils.isNotNullOrEmptyStr(crmId)){
			// 获取缓存的查询条件
			Set<String> rs = RedisCacheUtil.getSortedSetRange("quote_search_"+ crmId, 0, 0);
			for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
				String searchcon = (String) iterator.next();
				sealist.add(searchcon);
				logger.info("QuoteController searchcache method searchcon=>"+ searchcon);
			}
		}else{
			throw new Exception("操作失败,错误编码:"+ErrCode.ERR_CODE_1001001+"操作描述:"+ErrCode.ERR_MSG_UNBIND);
		}
		return JSONArray.fromObject(sealist).toString();
	}
	
	/**
	 * 删除实体对象
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/delQuote")
	@ResponseBody
	public String delQuote(QuoteAdd obj, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	    String optype = request.getParameter("optype");
		String rowId = request.getParameter("rowid");
		String crmId = UserUtil.getCurrUser(request).getCrmId();
	
		obj.setCrmaccount(crmId);
		obj.setRowid(rowId);
		obj.setOptype(optype);
		cRMService.getSugarService().getQuote2CrmService().deleteQuote(obj);
	
		return "success";
	}
	
	
}
