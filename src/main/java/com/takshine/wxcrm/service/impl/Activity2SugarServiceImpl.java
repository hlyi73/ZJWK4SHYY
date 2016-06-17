package com.takshine.wxcrm.service.impl;

import java.util.List;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.filter.QueryFilter;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.Page;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.Activity;
import com.takshine.wxcrm.domain.OperatorMobile;
import com.takshine.wxcrm.domain.UserFunc;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ActivityReq;
import com.takshine.wxcrm.message.sugar.ProjectBase;
import com.takshine.wxcrm.message.sugar.ProjectResp;
import com.takshine.wxcrm.service.Activity2CrmService;
/**
 * 
 * @author lilei
 *
 */
@Service("activity2SugarService")
public class Activity2SugarServiceImpl extends BaseServiceImpl implements Activity2CrmService {
	private static Logger log = Logger.getLogger(Activity2SugarServiceImpl.class.getName());
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		
	public ProjectResp getActivityList(Activity sche, String source)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	public ProjectResp getActivitySingle(String rowid, String crmid)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	public CrmError addActivity(Activity pro) throws Exception {
		CrmError crmErr = new CrmError();
		log.info("addActivity start => obj is : " + pro);
		ActivityReq prob= new ActivityReq();
		prob.setModeltype(Constants.MODEL_TYPE_ACTIVITY);
		prob.setType(Constants.ACTION_ADD);
		prob.setActivitytype(pro.getType());
		prob.setCrmaccount(pro.getCrmId());
		prob.setDeadline(pro.getDeadline());
		prob.setDesc(pro.getDesc());
		prob.setImagename(pro.getImagename());
		prob.setPlace(pro.getPlace());
		prob.setStartdate(pro.getStartdate());
		prob.setTitle(pro.getTitle());
		prob.setPartner(pro.getPartner());
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(prob, jsonConfig).toString();
		log.info("addActivity jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addActivity rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addActivity errcode => errcode is : " + errcode);
			log.info("addActivity errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");//记录ID
				log.info("addActivity rowid => rowId is : " + rowId);
				crmErr.setRowId(rowId);
			}
		}
		return crmErr;
	}
	public CrmError updateActivity(Activity pro) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	public BaseModel initObj() {
		// TODO Auto-generated method stub
		return null;
	}

}
