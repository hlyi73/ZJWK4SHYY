package com.takshine.wxcrm.service.impl;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.message.sugar.RepeatNameReq;
import com.takshine.wxcrm.message.sugar.RepeatNameResp;
import com.takshine.wxcrm.service.RepeatNameService;

/**
 * 检查重复名称相关业务接口实现
 * @author dengbo
 */
@Service("repeatNameService")
public class RepeatNameServiceImpl extends BaseServiceImpl implements RepeatNameService {
	
	private static Logger log = Logger.getLogger(RepeatNameServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		
	public BaseModel initObj() {
		return null;
	}

	/**
	 * 检查是否有重名的情况
	 */
	public RepeatNameResp checkName(RepeatNameReq req) {
		RepeatNameResp resp = new RepeatNameResp();
		resp.setCrmaccount(req.getCrmaccount());//crmId
		req.setModeltype(Constants.MODEI_TYPE_VALIDATE);
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("checkName jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_VALIDATE, jsonStr, Constants.INVOKE_MULITY);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		log.info("checkName  rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		String errcode = "";
		String errmsg = "";
		if(!jsonObject.containsKey("errcode")){
			errcode = "0";
			errmsg = "没有重名";
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}else{
			errcode = jsonObject.getString("errcode");
			errmsg = jsonObject.getString("errmsg");
			log.info("checkName errcode => errcode is : " + errcode);
			log.info("checkName errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

}
