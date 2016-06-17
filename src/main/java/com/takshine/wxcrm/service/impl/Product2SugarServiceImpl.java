package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Product;
import com.takshine.wxcrm.message.sugar.ProductAdd;
import com.takshine.wxcrm.message.sugar.ProductCostAdd;
import com.takshine.wxcrm.message.sugar.ProductPriceAdd;
import com.takshine.wxcrm.message.sugar.ProductReq;
import com.takshine.wxcrm.message.sugar.ProductResp;
import com.takshine.wxcrm.service.Product2SugarService;

/**
 * 产品相关业务接口实现
 *
 * @author huangpeng
 */
@Service("product2SugarService")
public class Product2SugarServiceImpl extends BaseServiceImpl implements
		Product2SugarService {

	private static Logger log = Logger.getLogger(Product2SugarServiceImpl.class
			.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 查询产品列表
	 */
	@SuppressWarnings("unchecked")
	public ProductResp getProductList(Product pro, String source) {
		// 产品响应
		ProductResp resp = new ProductResp();
		resp.setCrmaccount(pro.getCrmId());// crm id
		resp.setModeltype(Constants.MODEI_TYPE_PRODUCT);
		resp.setCurrpage(pro.getCurrpage());
		resp.setPagecount(pro.getPagecount());
		// 产品请求
		ProductReq req = new ProductReq();
		req.setCrmaccount(pro.getCrmId());// crm id
		req.setModeltype(Constants.MODEI_TYPE_PRODUCT);
		req.setType(Constants.ACTION_SEARCH);
		req.setCurrpage(pro.getCurrpage());
		req.setPagecount(pro.getPagecount());
		// 转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getProductList jsonStr => jsonStr is : " + jsonStr);
		// 单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr,
				Constants.INVOKE_MULITY);
		// 做空判断
		if (null == rst || "".equals(rst)) {
			resp.setErrcode(ErrCode.ERR_CODE_1001004);
			resp.setErrmsg(ErrCode.ERR_MSG_SEARCHEMPTY);
			return resp;
		}
		// 解析JSON数据
		log.info("getProductList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst
				.indexOf("{")));
		if (!jsonObject.containsKey("errcode")) {
			// 错误代码和消息
			List<ProductAdd> prolist = (List<ProductAdd>) JSONArray
					.toCollection(jsonObject.getJSONArray("products"),
							ProductAdd.class);
			resp.setPorducts(prolist);// 产品列表

		} else {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getCustomerList errcode => errcode is : " + errcode);
			log.info("getCustomerList errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	/**
	 * 查询单个产品
	 */
	@SuppressWarnings("unchecked")
	public ProductResp getProductSingle(String rowId, String crmId) {
		// 产品响应
		ProductResp resp = new ProductResp();
		resp.setCrmaccount(crmId);// sugar id
		resp.setModeltype(Constants.MODEI_TYPE_PRODUCT);

		// 产品请求
		ProductReq single = new ProductReq();
		single.setCrmaccount(crmId);// sugar id
		single.setModeltype(Constants.MODEI_TYPE_PRODUCT);
		single.setType(Constants.ACTION_SEARCHROW);
		single.setRowid(rowId);
		// 转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getProductSingle jsonStr => jsonStr is : " + jsonStr);
		// 单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr,
				Constants.INVOKE_MULITY);
		log.info("getProductSingle rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst
				.indexOf("{")));
		if (!jsonObject.containsKey("errcode")) {
			// 错误代码和消息
			List<ProductAdd> prolist = new ArrayList<ProductAdd>();
			JSONArray jarr = jsonObject.getJSONArray("product");
			log.info("getProductSingle jarr => rst is : " + jarr);
			for (int i = 0; i < jarr.size(); i++) {
				ProductAdd pro = new ProductAdd();
				JSONObject jobj = (JSONObject) jarr.get(i);
				// 设置相应的参数
				pro.setRowid(jobj.getString("rowid"));
				pro.setName(jobj.getString("name"));
				pro.setStartdate(jobj.getString("startdate"));
				pro.setEnddate(jobj.getString("enddate"));
				pro.setVersion(jobj.getString("version"));
				pro.setType(jobj.getString("type"));
				pro.setPaytype(jobj.getString("paytype"));
				pro.setPicklist(jobj.getString("picklist"));
				pro.setDesc(jobj.getString("desc"));
				//获取产品父类
				if (null != jobj.getString("parent")&& !"".equals(jobj.getString("parent"))) {
					List<ProductAdd> parent = (List<ProductAdd>) JSONArray
							.toCollection(jobj.getJSONArray("parent"),
									ProductAdd.class);
					pro.setParent(parent);
				}
				//获取产品价格表
				if (null != jobj.getString("productPrice")&& !"".equals(jobj.getString("productPrice"))) {
					List<ProductPriceAdd> priceList = (List<ProductPriceAdd>) JSONArray
							.toCollection(jobj.getJSONArray("productPrice"),
									ProductPriceAdd.class);
					pro.setProductPrice(priceList);
				}
				
				//获取产品成本列表
				if (null != jobj.getString("costPrice")&& !"".equals(jobj.getString("costPrice"))) {
					List<ProductCostAdd> costList = (List<ProductCostAdd>) JSONArray
							.toCollection(jobj.getJSONArray("costPrice"),
									ProductCostAdd.class);
					pro.setCostPrice(costList);
				}

				prolist.add(pro);

			}
			resp.setPorducts(prolist);// 产品列表

		} else {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getCustomerSingle errcode => errcode is : " + errcode);
			log.info("getCustomerSingle errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
}
