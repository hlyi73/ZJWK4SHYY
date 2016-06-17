package com.takshine.wxcrm.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.Bug;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.BugReq;
import com.takshine.wxcrm.message.sugar.BugResp;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;
import com.takshine.wxcrm.message.sugar.ScheduleComplete;
import com.takshine.wxcrm.message.sugar.ScheduleReq;
import com.takshine.wxcrm.message.sugar.ScheduleResp;
import com.takshine.wxcrm.service.Bug2SugarService;
/**
 * 
 * @author lilei
 *
 */
@Service("bug2SugarService")
public class Bug2SugarSerivceImpl extends BaseServiceImpl implements
		Bug2SugarService {
	private static Logger log = Logger.getLogger(Bug2SugarSerivceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		
	public BaseModel initObj() {
		// TODO Auto-generated method stub
		return null;
	}

	public BugResp getBugList(Bug bug) {
		BugResp resp = new BugResp();
		resp.setCrmaccount(bug.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_BUG);
		resp.setViewtype(bug.getViewtype());
		BugReq sreq = new BugReq();
		sreq.setCrmaccount(bug.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_BUG);
		sreq.setViewtype(bug.getViewtype());//试图类型
		sreq.setType(Constants.ACTION_SEARCH);
		if(bug.getRowid()!=null&&!"".equals(bug.getRowid())){		
			sreq.setRowid(bug.getRowid());
		}else{
		sreq.setAssigner(bug.getAssignerid());
		sreq.setCurrpage(bug.getCurrpage());
		sreq.setStatus(bug.getStatus());
		sreq.setParentid(bug.getParentid());
		sreq.setPagecount(bug.getPagecount());
		}
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getBugList jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getBugList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count) 
					&& Integer.parseInt(count) > 0){
				List<Bug> slist = (List<Bug>)JSONArray.toCollection(jsonObject.getJSONArray("bugs"), Bug.class);
				resp.setBugs(slist);//bug列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getBugList errcode => errcode is : " + errcode);
			log.info("getBugList errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}

	public BugResp getBug(String rowId, String crmId) {
		Bug bug = new Bug();
		bug.setRowid(rowId);
		bug.setCrmId(crmId);
		return this.getBugList(bug);
	}

	public CrmError addBug(Bug obj) {
		// TODO Auto-generated method stub
		return null;
	}

	public CrmError updateBugStatus(Bug bug, String crmId) {
		
		CrmError crmErr = new CrmError();
		Map map = new HashMap();
		map.put("crmaccount", bug.getCrmId());
		map.put("rowid", bug.getRowid());
		map.put("modeltype", Constants.MODEL_TYPE_BUG);
		map.put("type", Constants.ACTION_UPDATE);
		map.put("status", bug.getStatus());
		map.put("log", bug.getLog());
		map.put("analyze", bug.getAnalyze());
		//转换为json
		String jsonStr = JSONObject.fromObject(map).toString();
		log.info("updateBugStatus jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("updateBugStatus rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		//errormsg
		String errcode = jsonObject.getString("errcode");
		String errmsg = jsonObject.getString("errmsg");
		log.info("updateBugStatus errcode => errcode is : " + errcode);
		log.info("updateBugStatus errmsg => errmsg is : " + errmsg);
		crmErr.setErrorCode(errcode);
		crmErr.setErrorMsg(errmsg);
		
		return crmErr;
	}
public static void main(String[] args){
	Map map = new HashMap();
	map.put("crmaccount", "123213");
	map.put("rowid", "2324");
	map.put("modeltype", Constants.MODEL_TYPE_BUG);
	map.put("type", Constants.ACTION_UPDATE);
	map.put("status","234");
	map.put("log", "234234");
	//转换为json
	String jsonStr = JSONObject.fromObject(map).toString();
	System.out.print(jsonStr);
	
}

}
