package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.Gathering;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.GatheringAdd;
import com.takshine.wxcrm.message.sugar.GatheringReq;
import com.takshine.wxcrm.message.sugar.GatheringResp;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.service.Gathering2CrmService;

/**
 * 收款 相关业务接口实现
 * @author dengbo
 *
 */
@Service("gathering2CrmService")
public class Gathering2CrmServiceImpl extends BaseServiceImpl implements Gathering2CrmService{

	private static Logger log = Logger.getLogger(Gathering2CrmServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return null;
	}

	/**
	 * 查询收款数据列表
	 */
	@SuppressWarnings("unchecked")
	public GatheringResp getGatheringList(Gathering gath, String source) {
		//收款响应
		GatheringResp resp = new GatheringResp();
		//gath.setCrmId("5da1ce9f-74b5-d233-c286-51c64d153d5a");
		resp.setCrmaccount(gath.getCrmId());//crmId
		resp.setModeltype(Constants.MODEL_TYPE_GATHERING);//收款
		resp.setViewtype(gath.getViewtype());//视图类型
		//收款请求
		GatheringReq req = new GatheringReq();
		req.setCrmaccount(gath.getCrmId());
		req.setModeltype(Constants.MODEL_TYPE_GATHERING);
		req.setType(Constants.ACTION_SEARCH);//执行的是查询所有的操作
		req.setPagecount(gath.getPagecount());
		req.setCurrpage(gath.getCurrpage());
		req.setStatus(gath.getStatus());
		req.setDepart(gath.getDepart());
		req.setPlanDate(gath.getPlanDate());
		req.setMonth(gath.getMonth());
		req.setVerifityStatus(gath.getVerifityStatus());
		req.setAssignerId(gath.getAssignerId());
		req.setStartDate(gath.getStartDate());
		req.setEndDate(gath.getEndDate());
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getGatheringList jsonStr => is : "+jsonStr);
		//多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getGatheringList rst => is : "+rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			String count = jsonObject.getString("count");
			if(!"".equals(count)&&Integer.parseInt(count)>0){
				//把json对象转换成list集合
				List<GatheringAdd> list = (List<GatheringAdd>)JSONArray.toCollection(jsonObject.getJSONArray("gatherings"),GatheringAdd.class);
				resp.setGatherings(list);//收款列表
			}
			//记录条数
			resp.setCount(count);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getGatheringList errcode => errcode is : "+errcode);
			log.info("getGatheringList errmsg => errmsg is : "+errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
 	}
	
	/**
	 * 查询开票数据列表
	 */
	@SuppressWarnings("unchecked")
	public GatheringResp getGatheringListForInv(Gathering gath, String source) {
		//收款响应
		GatheringResp resp = new GatheringResp();
		resp.setCrmaccount(gath.getCrmId());//crmId
		resp.setModeltype(Constants.MODEL_TYPE_GATHERING);//收款
		resp.setViewtype(gath.getViewtype());//视图类型
		//收款请求
		GatheringReq req = new GatheringReq();
		req.setCrmaccount(gath.getCrmId());
		req.setModeltype(Constants.MODEL_TYPE_GATHERING);
		req.setType(Constants.ACTION_SEARCHID);//执行的是查询所有的操作
		req.setContractId(gath.getContractId());
		req.setRowid(gath.getRowid());
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getGatheringList jsonStr => is : "+jsonStr);
		//多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getGatheringList rst => is : "+rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			String count = jsonObject.getString("count");
			if(!"".equals(count)&&Integer.parseInt(count)>0){
				//把json对象转换成list集合
				List<GatheringAdd> list = (List<GatheringAdd>)JSONArray.toCollection(jsonObject.getJSONArray("gatherings"),GatheringAdd.class);
				List<GatheringAdd> gatherings = new ArrayList<GatheringAdd>();
				for(GatheringAdd gatheringAdd : list){
					GatheringAdd gaAdd = new GatheringAdd();
					try {
						BeanUtils.copyProperties(gaAdd, gatheringAdd);
					} catch (Exception e) {
						e.printStackTrace();
					} 
//					gaAdd.setVerifityAmount(StringUtils.showAmount(gatheringAdd.getVerifityAmount()));
					gatherings.add(gaAdd);
				}
				resp.setGatherings(gatherings);//收款列表
			}
			//记录条数
			resp.setCount(count);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getGatheringList errcode => errcode is : "+errcode);
			log.info("getGatheringList errmsg => errmsg is : "+errmsg);
		}
		return resp;
 	}

	/**
	 * 查询单个收款数据
	 */
	@SuppressWarnings("unchecked")
	public GatheringResp getGatheringSingle(String rowId, String crmId,String gatheringtype) {
		//收款响应
		GatheringResp resp = new GatheringResp();
		resp.setCrmaccount(crmId);
		resp.setModeltype(Constants.MODEL_TYPE_GATHERING);
		//收款请求
		GatheringAdd gaAdd = new GatheringAdd();
		gaAdd.setCrmaccount(crmId);
		gaAdd.setModeltype(Constants.MODEL_TYPE_GATHERING);
		gaAdd.setType(Constants.ACTION_SEARCHID);
		gaAdd.setRowid(rowId);
		gaAdd.setGatheringtype(gatheringtype);
		//转换为json
		String jsonStr = JSONObject.fromObject(gaAdd).toString();
		log.info("getGatheringSingle jsonStr =>  jsonStr is : "+jsonStr);
		//单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("getGatheringSingle rst => rst is : "+rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			List<GatheringAdd> list = new ArrayList<GatheringAdd>();
			JSONArray jsonArray = jsonObject.getJSONArray("gatherings");
			for(int i=0;i<jsonArray.size();i++){
				GatheringAdd gatheringAdd = new GatheringAdd();
				JSONObject jsonObject2 = (JSONObject)jsonArray.get(i);
				gatheringAdd.setRowid(jsonObject2.getString("rowid"));
				gatheringAdd.setTitle(jsonObject2.getString("title"));
				if(null!=jsonObject2.get("plantype")){
					gatheringAdd.setPlantype(jsonObject2.getString("plantype"));
				}
				if(null!=jsonObject2.get("typename")){
					gatheringAdd.setTypename(jsonObject2.getString("typename"));
				}
				if(null!=jsonObject2.get("planDate")){
					gatheringAdd.setPlanDate(jsonObject2.getString("planDate"));
				}
				if(null!=jsonObject2.get("planAmount")){
					String planAmount = StringUtils.showAmount(jsonObject2.getString("planAmount"));
					gatheringAdd.setPlanAmount(planAmount);
				}
				if(null!=jsonObject2.get("receivedDate")){
					gatheringAdd.setReceivedDate(jsonObject2.getString("receivedDate"));
				}
				if(null!=jsonObject2.get("receivedAmount")){
					String actAmount  =StringUtils.showAmount(jsonObject2.getString("receivedAmount"));
					gatheringAdd.setReceivedAmount(actAmount);
				}
				if(null!=jsonObject2.get("parentId")){
					gatheringAdd.setParentId(jsonObject2.getString("parentId"));
				}
				if(null!=jsonObject2.get("parentType")){
					gatheringAdd.setParentType(jsonObject2.getString("parentType"));
				}
				if(null!=jsonObject2.get("parentName")){
					gatheringAdd.setParentName(jsonObject2.getString("parentName"));
				}
				if(null!=jsonObject2.get("paymentsname")){
					gatheringAdd.setPaymentsname(jsonObject2.getString("paymentsname"));
				}
				if(null!=jsonObject2.get("payments")){
					gatheringAdd.setPayments(jsonObject2.getString("payments"));
				}
				if(null!=jsonObject2.get("status")){
					gatheringAdd.setStatus(jsonObject2.getString("status"));
				}
				if(null!=jsonObject2.get("statusname")){
					gatheringAdd.setStatusname(jsonObject2.getString("statusname"));
				}
				if(null!=jsonObject2.get("contractId")){
					gatheringAdd.setContractId(jsonObject2.getString("contractId"));
				}
				if(null!=jsonObject2.get("contractName")){
					gatheringAdd.setContractName(jsonObject2.getString("contractName"));
				}
				if(null!=jsonObject2.get("flag")){
					gatheringAdd.setFlag(jsonObject2.getString("flag"));
				}
				gatheringAdd.setAssigner(jsonObject2.getString("assigner"));
				gatheringAdd.setAssignid(jsonObject2.getString("assignid"));
				gatheringAdd.setCreater(jsonObject2.getString("creater"));
				gatheringAdd.setCreatedate(jsonObject2.getString("createdate"));
				gatheringAdd.setModifier(jsonObject2.getString("modifier"));
				gatheringAdd.setModifydate(jsonObject2.getString("modifydate"));
				gatheringAdd.setDesc(jsonObject2.getString("desc"));
				String margin = StringUtils.getMargin(StringUtils.replaceStr(gatheringAdd.getReceivedAmount()),StringUtils.replaceStr(gatheringAdd.getPlanAmount()));
				gatheringAdd.setMargin(StringUtils.repStr(margin));
				boolean flag = DateTime.compareTime(DateTime.currentDateTime(DateTime.DateFormat1), gatheringAdd.getPlanDate());
				gatheringAdd.setColor(flag+"");
				//修改历史
				if(jsonObject2.get("audits")!=null&&!"".equals(jsonObject2.get("audits"))){
					List<OpptyAuditsAdd> verifitys =(List<OpptyAuditsAdd>)JSONArray.toCollection(jsonObject2.getJSONArray("audits"),OpptyAuditsAdd.class);
					gatheringAdd.setAudits(verifitys);
				}
				list.add(gatheringAdd);
			}
			resp.setGatherings(list);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getGatheringSingle errcode => errcode is : "+errcode);
			log.info("getGatheringSingle errmsg => errmsg is : "+errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	
	/**
	 * 保存 回款跟进信息
	 */
	public String saveFollowup(Gathering obj, String rowId){
		log.info("saveFollowup start => obj is : "+obj);
		GatheringAdd gath = new GatheringAdd();
		gath.setCrmaccount(obj.getCrmId());
		gath.setModeltype(Constants.MODEL_TYPE_GATHERING);
		gath.setType(Constants.ACTION_FOLLOWUP);//回款跟进
		gath.setReceivedDate(obj.getReceivedDate());//回款日期
		gath.setDesc(obj.getDesc());//描述
		gath.setRowid(rowId);
		gath.setModifydate(obj.getModifydate());//跟进日期,也就是修改日期
		//配置 排除某些属相不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String[]{"color","margin","contractId","contractName","createdate","creater",
				"eamil","errcode","errmsg","modifier","parentId","parentName","parentType","planAmount","planDate"
				,"status","tasks","title","verifityDate","verifityStatus","name"});
		String jsonStr = JSONObject.fromObject(gath,jsonConfig).toString(); 
		log.info("addGathering jsonStr => jsonStr is : " + jsonStr);
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addGathering rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		//如果请求成功
		if(jsonObject!=null){
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addGathering errcode => errcode is : " + errcode);
			log.info("addGathering errmsg => errmsg is : " + errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				return "success";
			}
		}
		return "";
	}
	
	/**
	 * 财务审核信息
	 */
	@SuppressWarnings("unchecked")
	public String finaceVerifity(Gathering obj, String invoicedId){
		//收款响应
		GatheringResp resp = new GatheringResp();
		resp.setCrmaccount(obj.getCrmId());//crmId
		resp.setModeltype(Constants.MODEL_TYPE_GATHERING);//收款
		log.info("finaceVerifity start => obj is : "+obj);
		GatheringAdd gath = new GatheringAdd();
		gath.setCrmaccount(obj.getCrmId());
		gath.setModeltype(Constants.MODEL_TYPE_GATHERING);
		gath.setType(Constants.ACTION_CHECK);//财务审核
		//配置 排除某些属相不进行序列化
 		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String[]{"color","margin","contractId","contractName","createdate","creater",
				"eamil","errcode","errmsg","receivedAmount","receivedDate","modifier","modifydate",
				"name","parentId","parentName","parentType","planAmount","planDate"
				,"status","tasks","title","vlist"});
		//json字符串
		String jsonStr = JSONObject.fromObject(gath,jsonConfig).toString(); 
		log.info("addGathering jsonStr => jsonStr is : " + jsonStr);
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addGathering rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		//如果请求成功
		if(jsonObject!=null){
			String count = jsonObject.getString("count");
			if(!"".equals(count)&&Integer.parseInt(count)>0){
				//把json对象转换成list集合
				List<GatheringAdd> list = (List<GatheringAdd>)JSONArray.toCollection(jsonObject.getJSONArray("gatherings"),GatheringAdd.class);
				resp.setGatherings(list);//收款列表
			}
			//记录条数
			resp.setCount(count);
			return "success";
		}
		return "";
	}
	
	/**
	 * 保存回款
	 * @return
	 */
	public CrmError addGathering(GatheringAdd gatheringAdd){
		CrmError crmErr = new CrmError();
		gatheringAdd.setModeltype(Constants.MODEL_TYPE_GATHERING);
		gatheringAdd.setType(Constants.ACTION_ADD);
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(gatheringAdd, jsonConfig).toString();
		log.info("addGathering jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addGathering rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addGathering errcode => errcode is : " + errcode);
			log.info("addGathering errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");//记录ID
				log.info("addGathering rowId => rowid is : " + rowId);
				crmErr.setRowId(rowId);
			}
			
		}
		return crmErr;
	}
	
	/**
	 * 修改回款
	 * @return
	 */
	public CrmError updateGathering(GatheringAdd gatheringAdd){
		CrmError crmErr = new CrmError();
		gatheringAdd.setModeltype(Constants.MODEL_TYPE_GATHERING);
		gatheringAdd.setType(Constants.ACTION_UPDATE);
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(gatheringAdd, jsonConfig).toString();
		log.info("updateGathering jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("updateGathering rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("updateGathering errcode => errcode is : " + errcode);
			log.info("updateGathering errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	
}
