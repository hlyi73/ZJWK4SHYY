/**
 * com.takshine.jf.controller.LoginController.java
 * COPYRIGHT © 2014 TAKSHINE.com Inc.,ALL RIGHTS RESERVED. 
 * 北京德成鸿业咨询服务有限公司版权所有.
 */
package com.takshine.wxcrm.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.UserUtil;
import com.takshine.wxcrm.domain.Product;
import com.takshine.wxcrm.domain.ProductType;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ProductAdd;
import com.takshine.wxcrm.message.sugar.ProductResp;
import com.takshine.wxcrm.message.sugar.ProductTypeAdd;
import com.takshine.wxcrm.message.sugar.ProductTypeReq;
import com.takshine.wxcrm.message.sugar.ProductTypeResp;
import com.takshine.wxcrm.message.sugar.QuoteAdd;
import com.takshine.wxcrm.message.sugar.QuoteResp;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.message.sugar.UsersResp;
import com.takshine.wxcrm.service.ArticleInfoService;
import com.takshine.wxcrm.service.LovUser2SugarService;
import com.takshine.wxcrm.service.OperatorMobileService;
import com.takshine.wxcrm.service.Product2SugarService;
import com.takshine.wxcrm.service.ProductType2SugarService;

/**
 * 产品信息 页面控制器
 * 
 * @author [huangpeng Date:2014-08-13]
 * 
 */
@Controller
@RequestMapping("/product")
public class ProductController {
	// 日志
	protected static Logger logger = Logger
			.getLogger(ArticleInfoController.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	/**
	 * 查询所有产品列表信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.info("productController list method begin=>");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		// 通过openId,publicId来拿到crmId
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		// 判断crmId是否为空
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			Product pro = new Product();
			ProductType protype = new ProductType();
			pro.setCrmId(crmId);
			pro.setCurrpage(currpage);
			pro.setPagecount(pagecount);
			// 查询返回结果
			ProductResp pResp = cRMService.getSugarService().getProduct2SugarService().getProductList(pro, "WX");
			ProductTypeResp pTypeResp = cRMService.getSugarService().getProductType2SugarService()
					.getProducTypetList(protype);
			String errorCode = pResp.getErrcode();
			if (ErrCode.ERR_CODE_0.equals(errorCode)) {
				List<ProductAdd> proList = pResp.getPorducts();
				List<ProductTypeAdd> proTypeList = pTypeResp.getPorductTypes();
				logger.info("proList is ->" + proList.size());
				logger.info("proTypeList is ->" + proTypeList.size());
				request.setAttribute("proList", proList);
				request.setAttribute("proTypeList", proTypeList);

				// 获得LOV列表值
				Map<String, Map<String, String>> mp = cRMService.getSugarService().getLovUser2SugarService()
						.getLovList(crmId);
				request.setAttribute("unitdom", mp.get("unit_dom"));// 获取单位下拉框的值
				request.setAttribute("statusdom", mp.get("status_dom"));// 获取状态下拉框的值
				request.setAttribute("paytypedom", mp.get("paytype_dom"));// 获取状态下拉框的值
			} else {
				if (!ErrCode.ERR_CODE_1001004.equals(errorCode)) {
					throw new Exception("错误编码：" + pResp.getErrcode() + "，错误描述："
							+ pResp.getErrmsg());
				}
			}
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		// requst info
		request.setAttribute("openId", openId);
		request.setAttribute("publicId", publicId);
		request.setAttribute("pagecount", pagecount);

		return "product/list";
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
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		String orgId = request.getParameter("orgId");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		// 通过openId,publicId来拿到crmId
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		if (StringUtils.isNotNullOrEmptyStr(crmId)) {
			Product pro = new Product();
			pro.setCrmId(crmId);
			pro.setCurrpage(currpage);
			pro.setPagecount(pagecount);
			pro.setOrgId(orgId);
			// 查询返回结果
			ProductResp pResp = cRMService.getSugarService().getProduct2SugarService().getProductList(pro, "WX");
			String errorCode = pResp.getErrcode();
			if (ErrCode.ERR_CODE_0.equals(errorCode)) {
				List<ProductAdd> proList = pResp.getPorducts();
				logger.info("cList is ->" + proList.size());
				str = JSONArray.fromObject(proList).toString();
				logger.info("str is ->" + str);
				return str;
			}else{
			    crmErr.setErrorCode(pResp.getErrcode());
			    crmErr.setErrorMsg(pResp.getErrmsg());
			}
		}else{
			crmErr.setErrorCode(ErrCode.ERR_CODE_1001001);
			crmErr.setErrorMsg(ErrCode.ERR_MSG_UNBIND);
		}
		return JSONObject.fromObject(crmErr).toString();
	}
	
	/**
	 * 查询所有产品详细信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("ProductController detail method begin=>");
		String rowId = request.getParameter("rowId");// rowId
		String openId = request.getParameter("openId");
		String publicId = request.getParameter("publicId");
		String currpage = request.getParameter("currpage");
		String pagecount = request.getParameter("pagecount");
		currpage = (null == currpage ? "1" : currpage);
		pagecount = (null == pagecount ? "10" : pagecount);
		logger.info("ProductController detail method rowId =>" + rowId);
		logger.info("ProductController detail method openId =>" + openId);
		logger.info("ProductController detail method publicId =>" + publicId);
		// 绑定对象
		String crmId = UserUtil.getCurrUser(request).getCrmId();
		logger.info("crmId:-> is =" + crmId);
		// 获取绑定的账户 在sugar系统的id
		if (!"".equals(crmId)) {
			ProductResp pResp = cRMService.getSugarService().getProduct2SugarService().getProductSingle(rowId,
					crmId);
			String errorCode = pResp.getErrcode();
			if (ErrCode.ERR_CODE_0.equals(errorCode)) {
				List<ProductAdd> proList = pResp.getPorducts();
				if (null != proList && proList.size() > 0) {
					// 设置页面显示的参数
					request.setAttribute("name", proList.get(0).getName());
					request.setAttribute("sd", proList.get(0));
					request.setAttribute("priceList", proList.get(0)
							.getProductPrice());
					request.setAttribute("costList", proList.get(0)
							.getCostPrice());
					request.setAttribute("parentList", proList.get(0)
							.getParent());
				}
			} else {
				if (!ErrCode.ERR_CODE_1001004.equals(errorCode)) {
					throw new Exception("错误编码：" + pResp.getErrcode() + "，错误描述："
							+ pResp.getErrmsg());
				}
			}
			request.setAttribute("openId", openId);
			request.setAttribute("publicId", publicId);
			request.setAttribute("crmId", crmId);
		} else {
			throw new Exception("错误编码：" + ErrCode.ERR_CODE_1001001 + "，错误描述："
					+ ErrCode.ERR_MSG_UNBIND);
		}
		return "product/detail";
	}
}
