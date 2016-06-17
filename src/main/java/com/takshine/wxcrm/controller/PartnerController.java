package com.takshine.wxcrm.controller;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

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
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.Customer;
import com.takshine.wxcrm.domain.Partner;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.message.sugar.CustomerResp;
import com.takshine.wxcrm.message.sugar.PartnerAdd;
import com.takshine.wxcrm.message.sugar.PartnerResp;
import com.takshine.wxcrm.service.Customer2SugarService;
import com.takshine.wxcrm.service.Partner2SugarService;

/**
 * 合作伙伴 页面控制类
 * @author dengbo
 *
 */
@Controller
@RequestMapping("/partner")
public class PartnerController {
	    // 日志
		protected static Logger logger = Logger.getLogger(PartnerController.class.getName());
		
		@Autowired
		@Qualifier("cRMService")
		private CRMService cRMService;
		
		/**
		 *  保存合作伙伴
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value = "/save", method = RequestMethod.POST)
		public String save(Partner obj, HttpServletRequest request,
				HttpServletResponse response) throws Exception {
			logger.info("PartnerController save method id =>" + obj.getId());
			//rowId
			CrmError crmErr = cRMService.getSugarService().getPartner2SugarService().addPartner(obj);
			String rowId = crmErr.getRowId();
			if(null != rowId && !"".equals(rowId)){
				request.setAttribute("openId", obj.getOpenId());
				request.setAttribute("publicId", obj.getPublicId());
			}
			return "redirect:/oppty/detail?openId="+obj.getOpenId()+"&publicId="+obj.getPublicId()+"&rowId="+obj.getOpptyid()+"&orgId="+obj.getOrgId();
		}
		
		
		/**
		 * 添加合作伙伴
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/get")
		public String get(HttpServletRequest request,HttpServletResponse response)throws Exception{
			String openId =request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String opptyid = request.getParameter("opptyid");
			String viewtype = request.getParameter("viewtype");
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String customerid = request.getParameter("customerid");
			String customername=request.getParameter("customername");
			String crmId = request.getParameter("crmId");
			String orgId = request.getParameter("orgId");
			if(StringUtils.isNotNullOrEmptyStr(customername)){
				customername = URLDecoder.decode(customername,"UTF-8");
				customername = new String(customername.getBytes("ISO-8859-1"),"UTF-8");
			}	
			currpage = (null == currpage ? "1" : currpage);
			pagecount = (null == pagecount ? "10" : pagecount);
			viewtype = (viewtype == null) ? "partnerview" : viewtype;
//			String crmId = UserUtil.getCurrUser(request).getCrmId();
			logger.info("PartnerController get method openId =>" + openId);
			logger.info("PartnerController get method publicId =>" + publicId);
			logger.info("PartnerController get method crmId =>" + crmId);
			if(StringUtils.isNotNullOrEmptyStr(crmId)){
				//查询客户信息
				Customer sche = new Customer();
				sche.setCrmId(crmId);
				sche.setViewtype(viewtype);
				sche.setCurrpage(currpage);
				sche.setPagecount(pagecount);
				sche.setOpptyid(opptyid);
				sche.setOpenId(UserUtil.getCurrUser(request).getOpenId());
				// 查询返回结果
				CustomerResp cResp = cRMService.getSugarService().getCustomer2SugarService().getCustomerList(sche,
						"WX");
				List<CustomerAdd> cList = cResp.getCustomers();
				request.setAttribute("crmId", crmId);
				request.setAttribute("opptyid", opptyid);
				request.setAttribute("openId", openId);
				request.setAttribute("publicId", publicId);
				request.setAttribute("acctList", cList);
				request.setAttribute("orgId", orgId);
				request.setAttribute("customerid", customerid);
				request.setAttribute("customername", customername);
				return "partner/add";
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
		}
		
		/**
		 * 合作伙伴 list页面
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping("/list")
		public String list(HttpServletRequest request,HttpServletResponse response) throws Exception{
			logger.info("PartnerController acclist method begin=>");
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String currpage = request.getParameter("currpage");
			String pagecount = request.getParameter("pagecount");
			String opptyid =request.getParameter("opptyid");
		    currpage = (null == currpage ? "1" : currpage);
		    pagecount = (null == pagecount ? "10" : pagecount);
			logger.info("PartnerController list method openId =>" + openId);
			logger.info("PartnerController list method publicId =>" + publicId);
			logger.info("PartnerController list method currpage =>" + currpage);
			logger.info("PartnerController list method pagecount =>" + pagecount);
			//绑定对象
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			logger.info("crmId:-> is =" + crmId);
			//获取绑定的账户 在sugar系统的id
			if(!"".equals(crmId)){
				Partner partner = new Partner();
				partner.setCrmId(crmId);
				partner.setPagecount(pagecount);
				partner.setCurrpage(currpage);
				partner.setOpptyid(opptyid);
				PartnerResp pResp = cRMService.getSugarService().getPartner2SugarService().getPartnerList(partner,"WEB");
				List<PartnerAdd> list = pResp.getPartners();
				//放到页面上
				if(null != list && list.size() > 0){
					request.setAttribute("partnerList", list);
				}else{
					request.setAttribute("partnerList", new ArrayList<PartnerAdd>());
				}
			}else{
				throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述：" + ErrCode.ERR_MSG_UNBIND);
			}
			//requestinfo
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			request.setAttribute("pagecount", pagecount);
			request.setAttribute("currpage", currpage);
			request.setAttribute("opptyid", opptyid);
			request.setAttribute("crmId", crmId);
			return "partner/list";
		}
		
		/**
		 * 异步查询合作伙伴个数
		 * @param request
		 * @param response
		 * @return
		 */
		@RequestMapping(value="/alist")
		@ResponseBody
		public String alist(HttpServletRequest request,	HttpServletResponse response) throws Exception{
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String opptyid =request.getParameter("opptyid");
			logger.info("PartnerController alist method openId =>" + openId);
			logger.info("PartnerController alist method publicId =>" + publicId);
			//绑定对象
			String crmId = UserUtil.getCurrUser(request).getCrmId();
			logger.info("crmId:-> is =" + crmId);
			//error 对象
			CrmError crmErr = new CrmError();
			//获取绑定的账户 在sugar系统的id
			if(!"".equals(crmId)){
				Partner partner = new Partner();
				partner.setCrmId(crmId);
				partner.setOpptyid(opptyid);
				PartnerResp pResp = cRMService.getSugarService().getPartner2SugarService().getPartnerList(partner,"WEB");
				List<PartnerAdd> list = pResp.getPartners();
				if(list!=null&&list.size()>0){
					crmErr.setErrorCode(ErrCode.ERR_CODE_0);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_SUCC);
					crmErr.setRowCount(list.size() + "");
				}else{
					crmErr.setErrorCode(ErrCode.ERR_CODE_1001003);
					crmErr.setErrorMsg(ErrCode.ERR_MSG_ARRISEMPTY);
				}
			}else{
				crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
				crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
			}
			return JSONObject.fromObject(crmErr).toString(); 
		}
		
		/**
		 * 删除合作伙伴
		 * @return
		 */
		@RequestMapping("/del")
		public String delPartner(Partner partner,HttpServletRequest request,HttpServletResponse response){
			String openId = request.getParameter("openId");
			String publicId = request.getParameter("publicId");
			String opptyid = partner.getOpptyid();
			CrmError crmErr = cRMService.getSugarService().getPartner2SugarService().delPartner(partner);
			String errCode = crmErr.getErrorCode();
			if(ErrCode.ERR_CODE_0.equals(errCode)){
				request.setAttribute("openId", openId);
				request.setAttribute("publicId", publicId);
				request.setAttribute("opptyid", opptyid);
			}
			return "redirect:/partner/list?opptyid="+opptyid+"&openId="+openId+"&publicId="+publicId;
		}
}
