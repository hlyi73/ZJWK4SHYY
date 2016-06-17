package com.takshine.wxcrm.service.impl;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.Partner;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.PartnerAdd;
import com.takshine.wxcrm.message.sugar.PartnerReq;
import com.takshine.wxcrm.message.sugar.PartnerResp;
import com.takshine.wxcrm.service.Partner2SugarService;

/**
 * 合作伙伴 业务接口实现类
 * @author dengbo
 *
 */
@Service("partner2SugarService")
public class Partner2SugarServiceImpl extends BaseServiceImpl implements Partner2SugarService {
	
	private static Logger log = Logger.getLogger(Partner2SugarServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 保存合作伙伴信息
	 * @param obj
	 * @return
	 */
	public CrmError addPartner(Partner obj){
		CrmError crmErr = new CrmError();
		log.info("addPartner start => obj is : " + obj);
		PartnerAdd sa = new PartnerAdd();
		sa.setCrmaccount(obj.getCrmId());
		sa.setModeltype(Constants.MODEL_TYPE_PARTNER);
		sa.setType(Constants.ACTION_ADD);
		sa.setDesc(obj.getDesc());
		sa.setCustomerid(obj.getCustomerid());
		sa.setCustomername(obj.getCustomername());
		sa.setOpptyid(obj.getOpptyid());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("addPartner jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addPartner rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addPartner errcode => errcode is : " + errcode);
			log.info("addPartner errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	
	/**
	 * 查询合作伙伴列表
	 */
	@SuppressWarnings("unchecked")
	public PartnerResp getPartnerList(Partner partner, String source) {
		//联系人响应
		PartnerResp resp = new PartnerResp();
		resp.setCrmaccount(partner.getCrmId());//crmId
		resp.setModeltype(Constants.MODEL_TYPE_PARTNER);//合作伙伴
		resp.setViewtype(partner.getViewtype());//视图类型
		//联系人请求
		PartnerReq req = new PartnerReq();
		req.setCrmaccount(partner.getCrmId());
		req.setModeltype(Constants.MODEL_TYPE_PARTNER);
		req.setType(Constants.ACTION_SEARCH);//执行的是查询所有的操作
		req.setPagecount(partner.getPagecount());
		req.setCurrpage(partner.getCurrpage());
		req.setOpptyid(partner.getOpptyid());
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getPartnerList jsonStr => is : "+jsonStr);
		//多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getPartnerList rst => is : "+rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			String count = jsonObject.getString("count");
			if(!"".equals(count)&&Integer.parseInt(count)>0){
				//把json对象转换成list集合
				List<PartnerAdd> list = (List<PartnerAdd>)JSONArray.toCollection(jsonObject.getJSONArray("partners"),PartnerAdd.class);
				resp.setPartners(list);//合作合伙列表
			}
			//记录条数
			resp.setCount(count);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getPartnerList errcode => errcode is : "+errcode);
			log.info("getPartnerList errmsg => errmsg is : "+errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	/**
	 * 删除合作伙伴
	 */
	public CrmError delPartner(Partner obj) {
		CrmError crmErr = new CrmError();
		log.info("delPartner start => obj is : " + obj);
		PartnerAdd pa = new PartnerAdd();
		pa.setCrmaccount(obj.getCrmId());
		pa.setModeltype(Constants.MODEL_TYPE_PARTNER);
		pa.setType(Constants.ACTION_DELETE);
		pa.setRowid(obj.getRowid());
		pa.setOpptyid(obj.getOpptyid());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(pa, jsonConfig).toString();
		log.info("delPartner jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("delPartner rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("delPartner errcode => errcode is : " + errcode);
			log.info("delPartner errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
}
