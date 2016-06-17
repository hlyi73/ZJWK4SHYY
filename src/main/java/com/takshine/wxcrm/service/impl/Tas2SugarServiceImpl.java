package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.PropertyFilter;

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
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.TasAdd;
import com.takshine.wxcrm.message.sugar.TasReq;
import com.takshine.wxcrm.message.sugar.TasResp;
import com.takshine.wxcrm.message.sugar.TasValueAdd;
import com.takshine.wxcrm.service.Tas2SugarService;

/**
 * tas销售方法论   相关业务接口实现
 *
 * @author liulin
 */
@Service("tas2SugarService")
public class Tas2SugarServiceImpl extends BaseServiceImpl implements Tas2SugarService{
	
	private static Logger log = Logger.getLogger(Tas2SugarServiceImpl.class.getName());
	
	// http  服务
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 查询  价值主张
	 * @param obj
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public TasResp searchVal(String crmId, String rowId){
		
		//tas销售方法论 响应
		TasResp resp = new TasResp();
		resp.setCrmaccount(crmId);//crm id
		resp.setModeltype(Constants.MODEL_TYPE_TAS);
	
		//tas销售方法论  请求
		TasReq sreq = new TasReq();
		sreq.setCrmaccount(crmId);//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_TAS);
		sreq.setType(Constants.ACTION_SEARCH);
		sreq.setTastype("value");//tastype: value/event
		sreq.setRowid(rowId);
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("searchEvt jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("searchEvt rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			JSONArray jarr = jsonObject.getJSONArray("tas");
			List<TasValueAdd> tasValueList = new ArrayList<TasValueAdd>();
			for(int i = 0; i < jarr.size() ;i++){
				TasValueAdd tas = new TasValueAdd();
				JSONObject jobj = (JSONObject)jarr.get(i);
				tas.setId(jobj.getString("id"));
				tas.setValue(jobj.getString("value"));
				tasValueList.add(tas);
			}
			resp.setTasValueList(tasValueList);
			
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getScheduleList errcode => errcode is : " + errcode);
			log.info("getScheduleList errmsg => errmsg is : " + errmsg);
		}
		return resp;
	}

	/**
	 * 修改价值主张
	 */
	public String updateVal(String crmId, String rowId, String dataColl) {
		
		TasReq tq = new TasReq();
		tq.setCrmaccount(crmId);
		tq.setModeltype(Constants.MODEL_TYPE_TAS);
		tq.setType(Constants.ACTION_UPDATE);
		tq.setTastype("value");
		tq.setRowid(rowId);
		
		String [] carr = dataColl.split("\\@");
		//v 集合
		List<TasValueAdd> tvlist = new ArrayList<TasValueAdd>();
		for (int j = 0; j < carr.length; j++) {
			String [] varr = carr[j].split("\\,");
			
			TasValueAdd tasV = new TasValueAdd();
			tasV.setId(varr[0]);
			tasV.setValue(varr[1]);
			tasV.setFlag(varr[2]);
			
			tvlist.add(tasV);
		}
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		//排除掉类熟悉的 方法
		jsonConfig.setExcludes(new String []{"errcode","errmsg"});//方法一
		JSONObject jobjTmp = JSONObject.fromObject(tq, jsonConfig);
		
		jsonConfig = new JsonConfig();
		jsonConfig.setJsonPropertyFilter(new PropertyFilter() {//方法二
			public boolean apply(Object source, String name, Object value) {
				if(source.getClass().getName().equals("com.takshine.wxcrm.message.sugar.TasValueAdd") ){
					if(name.equals("errcode"))return true;
					if(name.equals("errmsg"))return true;
					if(name.equals("crmaccount"))return true;
					if(name.equals("modeltype"))return true;
					if(name.equals("type"))return true;
				}
				return false;
			}
		});
		//tasList
		String jsonStr = jobjTmp.element("tasList", tvlist, jsonConfig).toString();
		log.info("addVal jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addVal rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addVal errcode => errcode is : " + errcode);
			log.info("addVal errmsg => errmsg is : " + errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				return "success";
			}
		}
		return "";
	}
	
	/**
	 * 查询强制性事件
	 * @param obj
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public TasResp searchEvt(String crmId, String rowId){
		//tas销售方法论 响应
		TasResp resp = new TasResp();
		resp.setCrmaccount(crmId);//crm id
		resp.setModeltype(Constants.MODEL_TYPE_TAS);
	
		//tas销售方法论  请求
		TasReq sreq = new TasReq();
		sreq.setCrmaccount(crmId);//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_TAS);
		sreq.setType(Constants.ACTION_SEARCH);
		sreq.setTastype("event");//tastype: value/event
		sreq.setRowid(rowId);
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("searchEvt jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("searchEvt rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			JSONArray jarr = jsonObject.getJSONArray("tas");
			List<TasAdd> tasList = new ArrayList<TasAdd>();
			for(int i = 0; i < jarr.size() ;i++){
				TasAdd tas = new TasAdd();
				JSONObject jobj = (JSONObject)jarr.get(i);
				tas.setKey(jobj.getString("key"));
				tas.setName(jobj.getString("name"));

				//循环 问题的答案
				JSONArray varrs = jobj.getJSONArray("values");
				List<TasValueAdd> svList = new ArrayList<TasValueAdd>();
				for(int j = 0; j < varrs.size() ;j++){
					TasValueAdd tv = new TasValueAdd();
					JSONObject sv = (JSONObject)varrs.get(j);
					tv.setId(sv.getString("id"));
					tv.setValue(sv.getString("value"));
					svList.add(tv);
				}
				tas.setValues(svList);
				tasList.add(tas);
			}
			resp.setTasList(tasList);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getScheduleList errcode => errcode is : " + errcode);
			log.info("getScheduleList errmsg => errmsg is : " + errmsg);
		}
		return resp;
		
	}

	/**
	 * 修改强制性事件
	 */
	public String updateEvt(String crmId, String rowId, String dataColl) {
		TasReq tq = new TasReq();
		tq.setCrmaccount(crmId);
		tq.setRowid(rowId);
		tq.setModeltype(Constants.MODEL_TYPE_TAS);
		tq.setType(Constants.ACTION_UPDATE);
		tq.setTastype("event");
		
		String [] sarr = dataColl.split("\\$");
		List<TasAdd> tlist = new ArrayList<TasAdd>();
		for(int i = 0; i < sarr.length ; i ++){
			TasAdd sTas = new TasAdd();
			String [] carr = sarr[i].split("\\|");
			String k = carr[0];
			String vs = carr[1];
			log.info("updateEvt method k =>" + k);
			log.info("updateEvt method vs =>" + vs);
			//v 集合
			String [] varr = vs.split("\\@");
			List<TasValueAdd> tvlist = new ArrayList<TasValueAdd>();
			for (int j = 0; j < varr.length; j++) {
				log.info("updateEvt method v =>" + varr[j]);
				TasValueAdd tasV = new TasValueAdd();
				String [] svarr = varr[j].split("\\,");
				tasV.setId(svarr[0]);
				tasV.setValue(svarr[1]);
				tasV.setFlag(svarr[2]);
				tvlist.add(tasV);
			}
			sTas.setKey(k);
			sTas.setValues(tvlist);
			tlist.add(sTas);
		}
		tq.setTasList(tlist);
		
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		//排除掉类熟悉的 方法
		jsonConfig.setExcludes(new String []{"errcode","errmsg"});//方法一
		jsonConfig.setJsonPropertyFilter(new PropertyFilter() {//方法二
			public boolean apply(Object source, String name, Object value) {
				if(source.getClass().getName().equals("com.takshine.wxcrm.message.sugar.TasAdd")
					|| source.getClass().getName().equals("com.takshine.wxcrm.message.sugar.TasValueAdd") ){
					if(name.equals("crmaccount"))return true;
					if(name.equals("modeltype"))return true;
					if(name.equals("type"))return true;
				}
				return false;
			}
		});
				
		String jsonStr = JSONObject.fromObject(tq, jsonConfig).toString();
		log.info("updateEvt jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("updateEvt rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("updateEvt errcode => errcode is : " + errcode);
			log.info("updateEvt errmsg => errmsg is : " + errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				return "success";
			}
		}
		
		return "";
	}

	
	/**
	 * 修改竞争策略
	 * @param obj
	 * @return
	 */
	public String updateSgy(Opportunity oppty) {
		OpptyAdd sa = new OpptyAdd();
		sa.setCrmaccount(oppty.getCrmId());//crmId
		sa.setModeltype(Constants.MODEL_TYPE_OPPTY);
		sa.setType(Constants.ACTION_UPDATE);
		sa.setRowid(oppty.getRowId());//rowId
		sa.setCompetitive(oppty.getCompetitive());//竞争策略
		
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"name","customerid","customername","currency","opptytype",
				"leadsource","probability","nextstep","campaigns","desc","creater","createdate","tasks",
				"audits","cons","errcode","errmsg","amount","assigner","contacts","dateclosed",
				"feedid","loseDesc","modifier","modifyDate","salesstage","salesstagename"});
		
		String jsonStr = JSONObject.fromObject(sa, jsonConfig).toString();
		log.info("updateOppty jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("updateOppty rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addSchedule errcode => errcode is : " + errcode);
			log.info("addSchedule errmsg => errmsg is : " + errmsg);
			//错误编码
			if("0".equals(errcode)){
				return "success";
			}
		}
		return "";
	}

}
