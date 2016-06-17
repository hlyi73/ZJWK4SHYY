package com.takshine.wxcrm.service.impl;

import java.lang.reflect.InvocationTargetException;
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
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.Campaigns;
import com.takshine.wxcrm.domain.Opportunity;
import com.takshine.wxcrm.domain.Project;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.CampaignsAdd;
import com.takshine.wxcrm.message.sugar.CampaignsReq;
import com.takshine.wxcrm.message.sugar.CampaignsResp;
import com.takshine.wxcrm.message.sugar.ContactAdd;
import com.takshine.wxcrm.message.sugar.ContactReq;
import com.takshine.wxcrm.message.sugar.ContactResp;
import com.takshine.wxcrm.message.sugar.OpptyAdd;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.message.sugar.ProjectAdd;
import com.takshine.wxcrm.message.sugar.ProjectReq;
import com.takshine.wxcrm.message.sugar.ProjectResp;
import com.takshine.wxcrm.service.Campaigns2CrmService;
import com.takshine.wxcrm.service.Project2CrmService;

/**
 * 市场活动  相关业务接口实现
 * @author dengbo
 *
 */
@Service("campaigns2CrmService")
public class Campaigns2CrmServiceImpl extends BaseServiceImpl implements Campaigns2CrmService{

	private static Logger log = Logger.getLogger(Campaigns2CrmServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return null;
	}

	/**
	 * 查询市场活动数据列表
	 * @throws Exception 
	 */
	public CampaignsResp getCampaignsList(Campaigns gath, String source) throws Exception {
//		//项目响应
//		CampaignsResp resp = new CampaignsResp();
//		resp.setCrmaccount(gath.getCrmId());//crmId
//		resp.setModeltype(Constants.MODEL_TYPE_CAMP);
//		//项目请求
//		CampaignsReq req = new CampaignsReq();
//		req.setCrmaccount(gath.getCrmId());
//		req.setModeltype(Constants.MODEL_TYPE_CAMP);
//		req.setType(Constants.ACTION_SEARCH);//执行的是查询所有的操作
//		req.setPagecount(gath.getPagecount());
//		req.setCurrpage(gath.getCurrpage());
//		req.setFirstchar(gath.getFirstchar());
//		//转换为json
//		String jsonStr = JSONObject.fromObject(req).toString();
//		log.info("getCampaignsList jsonStr => is : "+jsonStr);
//		//多次调用sugar接口
//		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
//		log.info("getCampaignsList rst => is : "+rst);
//		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
//		if(!jsonObject.containsKey("errcode")){
//			String count = jsonObject.getString("count");
//			if(!"".equals(count)&&Integer.parseInt(count)>0){
//				//把json对象转换成list集合
//				List<CampaignsAdd> list = (List<CampaignsAdd>)JSONArray.toCollection(jsonObject.getJSONArray("campaigns"),CampaignsAdd.class);
//				List<CampaignsAdd> plist = new ArrayList<CampaignsAdd>();
//				for(CampaignsAdd camAdd:list){
//					CampaignsAdd cAdd = new CampaignsAdd();
//					BeanUtils.copyProperties(cAdd, camAdd);
//					if(StringUtils.isNotNullOrEmptyStr(camAdd.getStartdate())){
//						String startdate = DateTime.date2Str(DateTime.str2Date(camAdd.getStartdate()),DateTime.DateFormat1);
//						cAdd.setStartdate(startdate);
//					}
//					if(StringUtils.isNotNullOrEmptyStr(camAdd.getEnddate())){
//						String enddate = DateTime.date2Str(DateTime.str2Date(camAdd.getEnddate()),DateTime.DateFormat1);
//						cAdd.setEnddate(enddate);
//					}
//					plist.add(cAdd);
//				}
//				resp.setCams(plist);
//			}
//			//记录条数
//			resp.setCount(count);
//		}else{
//			String errcode = jsonObject.getString("errcode");
//			String errmsg = jsonObject.getString("errmsg");
//			log.info("getCampaignsList errcode => errcode is : "+errcode);
//			log.info("getCampaignsList errmsg => errmsg is : "+errmsg);
//		}
//		return resp;
		
		CampaignsResp resp = new CampaignsResp();
		String url = PropertiesUtil.getAppContext("zjmarketing.url")+"/activity/synclist?source=WK&sourceid="+gath.getOpenId()+"&currpage="+gath.getCurrpage()+"&pagecount="+gath.getPagecount()+"&viewtype=owner&firstchar="+gath.getFirstchar();
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(url,"", "", Constants.INVOKE_MULITY);
		log.info("getCampaignsSingle rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		//JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		JSONArray jsonArray = JSONArray.fromObject(rst);
		
		if(null != jsonArray && jsonArray.size()>0){
			List<CampaignsAdd> cams = new ArrayList<CampaignsAdd>();
			CampaignsAdd campaignsAdd = null;
			JSONObject jsonObject = null;
			for(int i=0;i<jsonArray.size();i++){
				jsonObject = jsonArray.getJSONObject(i);
				campaignsAdd = new CampaignsAdd();
				campaignsAdd.setRowid(jsonObject.getString("id"));
				campaignsAdd.setName(jsonObject.getString("title"));
				campaignsAdd.setStartdate(jsonObject.getString("start_date"));
				campaignsAdd.setLogo(jsonObject.getString("logo"));
				campaignsAdd.setPlace(jsonObject.getString("place"));
				cams.add(campaignsAdd);
				resp.setCams(cams);
			}
		}
		return resp;
		
 	}

	/**
	 * 查询单个市场活动数据
	 * @param rowid
	 * @param crmid
	 * @return
	 * @throws Exception
	 */
	public CampaignsResp getCampaignsSingle(String rowid, String crmid)
			throws Exception {
		CampaignsResp resp = new CampaignsResp();
		resp.setCrmaccount(crmid);//crm id
		resp.setModeltype(Constants.MODEL_TYPE_CAMP);
		CampaignsReq single = new CampaignsReq();
		single.setCrmaccount(crmid);//sugar id
		single.setModeltype(Constants.MODEL_TYPE_CAMP);
		single.setType(Constants.ACTION_SEARCHID);
		single.setRowid(rowid);
		//转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getCampaignsSingle jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getCampaignsSingle rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			if(StringUtils.isNotNullOrEmptyStr(jsonObject.getString("campaigns"))){
				List<CampaignsAdd> plist = new ArrayList<CampaignsAdd>();
				JSONArray jsonArray = jsonObject.getJSONArray("campaigns");
				for(int i=0;i<jsonArray.size();i++){
					CampaignsAdd campaignsAdd = new CampaignsAdd();
					JSONObject jsonObject2 = jsonArray.getJSONObject(i);
					campaignsAdd.setRowid(jsonObject2.getString("rowid"));
					campaignsAdd.setName(jsonObject2.getString("name"));
					campaignsAdd.setStatus(jsonObject2.getString("status"));
					campaignsAdd.setStatuskey(jsonObject2.getString("statuskey"));
					campaignsAdd.setStartdate(jsonObject2.getString("startdate"));
					campaignsAdd.setEnddate(jsonObject2.getString("enddate"));
					campaignsAdd.setType(jsonObject2.getString("type"));
					campaignsAdd.setTypekey(jsonObject2.getString("typekey"));
					if(StringUtils.isNotNullOrEmptyStr(jsonObject2.getString("budget"))){
						campaignsAdd.setBudget(jsonObject2.getString("budget"));
					}else{
						campaignsAdd.setBudget("0");
					}
					if(StringUtils.isNotNullOrEmptyStr(jsonObject2.getString("budgetcost"))){
						campaignsAdd.setBudgetcost(jsonObject2.getString("budgetcost"));
					}else{
						campaignsAdd.setBudgetcost("0");
					}
					if(StringUtils.isNotNullOrEmptyStr(jsonObject2.getString("expectcost"))){
						campaignsAdd.setExpectcost(jsonObject2.getString("expectcost"));
					}else{
						campaignsAdd.setExpectcost("0");
					}
					if(StringUtils.isNotNullOrEmptyStr(jsonObject2.getString("factcost"))){
						campaignsAdd.setFactcost(jsonObject2.getString("factcost"));
					}else{
						campaignsAdd.setFactcost("0");
					}
					campaignsAdd.setGoal(jsonObject2.getString("goal"));
					campaignsAdd.setDesc(jsonObject2.getString("desc"));
					campaignsAdd.setAssigner(jsonObject2.getString("assigner"));
					campaignsAdd.setAssignerid(jsonObject2.getString("assignerid"));
					campaignsAdd.setCreater(jsonObject2.getString("creater"));
					campaignsAdd.setCreatedate(jsonObject2.getString("createdate"));
					campaignsAdd.setModifier(jsonObject2.getString("modifier"));
					campaignsAdd.setModifydate(jsonObject2.getString("modifydate"));
					campaignsAdd.setAuthority(jsonObject2.getString("authority"));
					if(null != jsonObject2.getString("audits") && !"".equals(jsonObject2.getString("audits"))){
						List<OpptyAuditsAdd> auditsList = (List<OpptyAuditsAdd>)JSONArray.toCollection(jsonObject2.getJSONArray("audits"), OpptyAuditsAdd.class);
						campaignsAdd.setAudits(auditsList);
					}
					plist.add(campaignsAdd);
				}
				resp.setCams(plist);//列表
			}
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getCampaignsSingle errcode => errcode is : " + errcode);
			log.info("getCampaignsSingle errmsg => errmsg is : " + errmsg);
		}
		return resp;
	}

	/**
	 * 保存市场活动
	 */
	public CrmError saveCampaigns(CampaignsAdd campaignsAdd) throws Exception {
		CrmError crmErr = new CrmError();
		campaignsAdd.setModeltype(Constants.MODEL_TYPE_CAMP);
		campaignsAdd.setType(Constants.ACTION_ADD);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(campaignsAdd, jsonConfig).toString();
		log.info("saveCampaigns jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("saveCampaigns rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("saveCampaigns errcode => errcode is : " + errcode);
			log.info("saveCampaigns errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");//记录ID
				log.info("saveCampaigns rowId => rowid is : " + rowId);
				crmErr.setRowId(rowId);
			}
			
		}
		return crmErr;
	}

	/**
	 * 修改市场活动
	 */
	public CrmError updateCampaigns(CampaignsAdd campaignsAdd) throws Exception {
		CrmError crmErr = new CrmError();
		campaignsAdd.setModeltype(Constants.MODEL_TYPE_CAMP);
		campaignsAdd.setType(Constants.ACTION_UPDATE);
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(campaignsAdd, jsonConfig).toString();
		log.info("updateCampaigns jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("updateCampaigns rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("updateCampaigns errcode => errcode is : " + errcode);
			log.info("updateCampaigns errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
}
