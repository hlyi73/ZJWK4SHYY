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
import com.takshine.wxcrm.domain.Rival;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.RivalAdd;
import com.takshine.wxcrm.message.sugar.RivalReq;
import com.takshine.wxcrm.message.sugar.RivalResp;
import com.takshine.wxcrm.service.Rival2SugarService;

/**
 * 竞争对手 相关业务接口实现
 * @author dengbo
 *
 */

@Service("rival2SugarService")
public class Rival2SugarServiceImpl extends BaseServiceImpl implements Rival2SugarService {
	
	private static Logger log = Logger.getLogger(Rival2SugarServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 保存竞争对手信息
	 * @param obj
	 * @return
	 */
	public CrmError addRival(Rival obj){
		CrmError crmErr = new CrmError();
		log.info("addRival start => obj is : " + obj);
		RivalAdd ra = new RivalAdd();
		ra.setCrmaccount(obj.getCrmId());
		ra.setModeltype(Constants.MODEL_TYPE_COMPETITOR);
		ra.setType(Constants.ACTION_ADD);
		ra.setOpptyid(obj.getOpptyid());
		ra.setCustomerid(obj.getCustomerid());
		ra.setCustomername(obj.getCustomername());
		ra.setThreat(obj.getThreat());
		ra.setDesc(obj.getDesc());
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(ra, jsonConfig).toString();
		log.info("addRival jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addRival rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addRival errcode => errcode is : " + errcode);
			log.info("addRival errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	

	/**
	 * 竞争对手列表
	 */
	@SuppressWarnings("unchecked")
	public RivalResp getRivalList(Rival rival, String source) {
		//请求
		RivalResp resp = new RivalResp();
		resp.setCrmaccount(rival.getCrmId());//crmId
		resp.setModeltype(Constants.MODEL_TYPE_COMPETITOR);//竞争对手
		resp.setViewtype(rival.getViewtype());//视图类型
		//响应
		RivalReq req = new RivalReq();
		req.setCrmaccount(rival.getCrmId());
		req.setModeltype(Constants.MODEL_TYPE_COMPETITOR);
		req.setType(Constants.ACTION_SEARCH);//执行的是查询所有的操作
		req.setPagecount(rival.getPagecount());
		req.setCurrpage(rival.getCurrpage());
		req.setOpptyid(rival.getOpptyid());
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getContactList jsonStr => is : "+jsonStr);
		//多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getContactList rst => is : "+rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			String count = jsonObject.getString("count");
			if(!"".equals(count)&&Integer.parseInt(count)>0){
				//把json对象转换成list集合
				List<RivalAdd> list = (List<RivalAdd>)JSONArray.toCollection(jsonObject.getJSONArray("competitors"),RivalAdd.class);
				resp.setRivals(list);//竞争对手列表
			}
			//记录条数
			resp.setCount(count);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getContactList errcode => errcode is : "+errcode);
			log.info("getContactList errmsg => errmsg is : "+errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	/**
	 * 删除竞争对手
	 */
	public CrmError delRival(Rival rival) {
		CrmError crmErr = new CrmError();
		log.info("delPartner start => rival is : " + rival);
		RivalAdd ra = new RivalAdd();
		ra.setCrmaccount(rival.getCrmId());
		ra.setModeltype(Constants.MODEL_TYPE_COMPETITOR);
		ra.setType(Constants.ACTION_DELETE);
		ra.setRowid(rival.getRowid());
		ra.setOpptyid(rival.getOpptyid());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(ra, jsonConfig).toString();
		log.info("delRival jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("delRival rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("delRival errcode => errcode is : " + errcode);
			log.info("delRival errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
}
