package com.takshine.wxcrm.service.impl;

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
import com.takshine.wxcrm.domain.ProductType;
import com.takshine.wxcrm.message.sugar.ProductAdd;
import com.takshine.wxcrm.message.sugar.ProductTypeAdd;
import com.takshine.wxcrm.message.sugar.ProductTypeReq;
import com.takshine.wxcrm.message.sugar.ProductTypeResp;
import com.takshine.wxcrm.service.ProductType2SugarService;

/**
 * 产品类别 相关业务接口实现
 *
 * @author huangpeng
 */
@Service("productType2SugarService")
public class ProductType2SugerServiceImpl extends BaseServiceImpl implements
		ProductType2SugarService {

	private static Logger log = Logger
			.getLogger(ProductType2SugerServiceImpl.class.getName());

	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;

	public BaseModel initObj() {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 查询产品类别列表
	 */
	@SuppressWarnings("unchecked")
	public ProductTypeResp getProducTypetList(ProductType pro) {
		// 产品类别响应
		ProductTypeResp resp = new ProductTypeResp();
		resp.setCrmaccount(pro.getCrmId());// crm id
		resp.setModeltype(Constants.MODEI_TYPE_PRODUCTTYPE);
		resp.setCurrpage(pro.getCurrpage());
		resp.setPagecount(pro.getPagecount());
		// 产品类别请求
		ProductTypeReq req = new ProductTypeReq();
		req.setCrmaccount(pro.getCrmId());// crm id
		req.setModeltype(Constants.MODEI_TYPE_PRODUCTTYPE);
		req.setType(Constants.ACTION_SEARCH);
		//req.setTypeId(pro.getTypeid());
		//req.setTypeName(pro.getTypename());
		// 转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getProductTypeList jsonStr => jsonStr is : " + jsonStr);
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
				log.info("getProductTypeList rst => rst is : " + rst);
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst
						.indexOf("{")));
				if (!jsonObject.containsKey("errcode")) {
					// 错误代码和消息
					List<ProductTypeAdd> prolist = (List<ProductTypeAdd>) JSONArray
							.toCollection(jsonObject.getJSONArray("producttype"),
									ProductAdd.class);
					resp.setPorductTypes(prolist);// 产品列表

				} else {
					String errcode = jsonObject.getString("errcode");
					String errmsg = jsonObject.getString("errmsg");
					log.info("getProductTypeList errcode => errcode is : " + errcode);
					log.info("getProductTypeList errmsg => errmsg is : " + errmsg);
					resp.setErrcode(errcode);
					resp.setErrmsg(errmsg);
				}
				return resp;
	}

	public ProductTypeResp getProducTypetList(ProductTypeReq proReq) {
		// TODO Auto-generated method stub
		return null;
	}

}
