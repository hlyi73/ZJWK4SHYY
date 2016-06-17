package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.domain.Organization;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ApproveListAdd;
import com.takshine.wxcrm.message.sugar.ApproveListResp;
import com.takshine.wxcrm.service.ApproveListService;

/**
 * 审批实现类
 * @author dengbo
 *
 */
@Service("approveListService")
public class ApproveList2CrmServiceImpl extends BaseServiceImpl implements ApproveListService{

	private static Logger log = Logger.getLogger(ApproveList2CrmServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return null;
	}

	/**
	 * 查询审批列表
	 * @param approve
	 * @param source
	 * @return
	 */
	public ApproveListResp getApproveList(ApproveListAdd approve, String source)throws Exception{
		//合同响应
		ApproveListResp resp = new ApproveListResp();
		approve.setModeltype(Constants.MODEL_TYPE_AUDIT);//审批
		approve.setType(Constants.ACTION_SEARCH);
		
		List<Organization> crmIds = getCrmIdAndOrgIdArr(approve.getOpenId(), PropertiesUtil.getAppContext("app.publicId"), null);
		log.info("crmIds size = >" + crmIds.size());
		List<ApproveListAdd> applist = new ArrayList<ApproveListAdd>();
		List<String> jsonStrArray = new ArrayList<String>();
		Map<String,String> cachcOrgid = new HashMap<String,String>();
		for (int i = 0; i < crmIds.size(); i++) {
			approve.setCrmaccount(crmIds.get(i).getCrmId());
			approve.setOrgUrl(crmIds.get(i).getCrmurl());
			//OperatorMobile operatorMobile = new OperatorMobile();
			//operatorMobile.setCrmId(crmIds.get(i).getCrmId());
			//OperatorMobile operatorMobile2 = checkBinding(operatorMobile);
			//String orgId = operatorMobile2.getOrgId();
			//转换为json
			String jsonStr = JSONObject.fromObject(approve).toString();
			log.info("getApproveList jsonStr => is : "+jsonStr);
			cachcOrgid.put(jsonStr, crmIds.get(i).getOrgId());
		}
		//多次调用sugar接口
		Map<String,String> retmap = cRMService.getWxService().getWxHttpConUtil().postJsonDataRetMapBodyKey(Constants.MODEL_URL_ENTRY, jsonStrArray, Constants.INVOKE_MULITY);
		for(String jsonStr : retmap.keySet()){
			try{
				String rst = retmap.get(jsonStr);
				log.info("getApproveList rst => is : "+rst);
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				if(!jsonObject.containsKey("errcode")){
					String count = jsonObject.getString("count");
					if(!"".equals(count)&&Integer.parseInt(count)>0){
						List<ApproveListAdd> list = (List<ApproveListAdd>)JSONArray.toCollection(jsonObject.getJSONArray("audits"),ApproveListAdd.class);
						List<ApproveListAdd> alist = new ArrayList<ApproveListAdd>();
						for(ApproveListAdd approveListAdd : list){
							ApproveListAdd add = new ApproveListAdd();
							BeanUtils.copyProperties(add, approveListAdd);
							add.setOrgId(cachcOrgid.get(jsonStr));
							alist.add(add);
						}
						applist.addAll(alist);
					}
				}
			}catch(Exception ec){
				
			}
		}
		resp.setApproves(applist);
//		if(!jsonObject.containsKey("errcode")){
//			String count = jsonObject.getString("count");
//			if(!"".equals(count)&&Integer.parseInt(count)>0){
//				//把json对象转换成list集合
//				List<ApproveListAdd> list = (List<ApproveListAdd>)JSONArray.toCollection(jsonObject.getJSONArray("audits"),ApproveListAdd.class);
//				resp.setApproves(list);
//			}
//			//记录条数
//			resp.setCount(count);
//		}else{
//			String errcode = jsonObject.getString("errcode");
//			String errmsg = jsonObject.getString("errmsg");
//			log.info("getContractList errcode => errcode is : "+errcode);
//			log.info("getContractList errmsg => errmsg is : "+errmsg);
//			resp.setErrcode(errcode);
//			resp.setErrmsg(errmsg);
//		}
		return resp;
 	}

	/**
	 * 批量审批
	 * @param approve
	 * @return
	 */
	public CrmError updateApproveList(ApproveListAdd approve){
		CrmError crmErr = new CrmError();
		approve.setModeltype(Constants.MODEL_TYPE_AUDIT);
		//配置 排除某些属相不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String[]{"",""});
		String jsonStr = JSONObject.fromObject(approve,jsonConfig).toString(); 
		log.info("updateApproveList jsonStr => jsonStr is : " + jsonStr);
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("updateApproveList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		//如果请求成功
		if(jsonObject!=null){
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("updateApproveList errcode => errcode is : " + errcode);
			log.info("updateApproveList errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
}
