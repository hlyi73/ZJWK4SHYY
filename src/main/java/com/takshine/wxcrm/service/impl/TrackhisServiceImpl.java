package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
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
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.Trackhis;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.service.TrackhisService;

/**
 * 跟进历史
 *
 * @author liulin
 */
@Service("trackhisService")
public class TrackhisServiceImpl extends BaseServiceImpl implements TrackhisService {
	
	private static Logger log = Logger.getLogger(TrackhisServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 查询 跟进历史 列表
	 * @param comp
	 * @return
	 */
	public Trackhis getTrackhisList(Trackhis his){
		
		his.setModeltype(Constants.MODEL_TYPE_FOLLOW);
		his.setType(Constants.ACTION_SEARCH);
		//排除不需要传的参数
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		//转换为json
		String jsonStr = JSONObject.fromObject(his, jsonConfig).toString();
		log.info("getTrackhisList  => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getTrackhisList  => rst is : " + rst);
		//返回结果
		if("".equals(rst)){
			his.setErrcode(ErrCode.ERR_CODE_1001006);
			his.setErrmsg(ErrCode.ERR_CODE_1001006_MSG);
			return his;
		}
		//json化结果对象
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			log.info("getTrackhisList  => count is :" + count);
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				@SuppressWarnings("unchecked")
				List<Trackhis> list = (List<Trackhis>)JSONArray.toCollection(jsonObject.getJSONArray("audits"), Trackhis.class);
				his.setHis(list);//列表
			}
			his.setCount(count);//数字
		}else{
			his.setErrcode(jsonObject.getString("errcode"));
			his.setErrmsg(jsonObject.getString("errmsg"));
			log.info("getTrackhisList  => errcode is : " + his.getErrcode());
			log.info("getTrackhisList  => errmsg is : " + his.getErrmsg());
		}
		
		return his;
	}
	
	
	/**
	 * 查询 跟进历史 列表
	 * @param comp
	 * @return
	 */
	public List<OpptyAuditsAdd> getTrackhisList2(Trackhis his){
		List<OpptyAuditsAdd> auditList = new ArrayList<OpptyAuditsAdd>();
		his.setModeltype(Constants.MODEL_TYPE_FOLLOW);
		his.setType(Constants.ACTION_SEARCH);
		//排除不需要传的参数
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		//转换为json
		String jsonStr = JSONObject.fromObject(his, jsonConfig).toString();
		log.info("getTrackhisList  => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getTrackhisList  => rst is : " + rst);
		//返回结果
		if("".equals(rst)){
			his.setErrcode(ErrCode.ERR_CODE_1001006);
			his.setErrmsg(ErrCode.ERR_CODE_1001006_MSG);
			return auditList;
		}
		//json化结果对象
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			log.info("getTrackhisList  => count is :" + count);
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				auditList = (List<OpptyAuditsAdd>)JSONArray.toCollection(jsonObject.getJSONArray("audits"), OpptyAuditsAdd.class);
			}
		}else{
			his.setErrcode(jsonObject.getString("errcode"));
			his.setErrmsg(jsonObject.getString("errmsg"));
			log.info("getTrackhisList  => errcode is : " + his.getErrcode());
			log.info("getTrackhisList  => errmsg is : " + his.getErrmsg());
		}
		
		return auditList;
	}
}