package com.takshine.wxcrm.service.impl;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.IndexKPI;
import com.takshine.wxcrm.service.Index2SugarService;
@Service("index2SugarService")
public class Index2SugarServiceImpl extends BaseServiceImpl implements
		Index2SugarService {
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		// TODO Auto-generated method stub
		return null;
	}
	public IndexKPI getIndexKPI(String crmId, String startDate, String endDate)throws Exception {
		//转换为json
		        Map<String,String> map = new HashMap<String,String>();
		        map.put("crmId", crmId);
		        map.put("startDate", startDate);
		        map.put("endDate", endDate);
		        map.put("crmaccount", crmId);
				String jsonStr = JSONObject.fromObject(map).toString();
				log.info("getIndexKPI jsonStr => jsonStr is : " + jsonStr);
				//单次调用sugar接口 
				String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
				log.info("getIndexKPI rst => rst is : " + rst);
				JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
				IndexKPI index=new IndexKPI();
				if(!jsonObject.containsKey("errcode")){
					//错误代码和消息
					index.setCrmId(crmId);
					index.setCollectionCompleted(jsonObject.getString("collectionCompleted"));
					index.setCollectionTargets(jsonObject.getString("collectionTargets"));
					index.setSalesCompleted(jsonObject.getString("salesCompleted"));
					index.setUnfinishedTask(jsonObject.getString("unfinishedTask"));
					index.setSalesTargets(jsonObject.getString("salesTargets"));

				}else{
					String errcode = jsonObject.getString("errcode");
					String errmsg = jsonObject.getString("errmsg");
					log.info("getIndexKPI errcode => errcode is : " + errcode);
					log.info("getIndexKPI errmsg => errmsg is : " + errmsg);
					index.setErrcode(errcode);
					index.setErrmsg(errmsg);
				}
				return index;
	}

}
