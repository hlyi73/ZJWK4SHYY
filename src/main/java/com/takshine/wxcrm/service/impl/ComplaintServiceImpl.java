package com.takshine.wxcrm.service.impl;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.common.ErrCode;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.Complaint;
import com.takshine.wxcrm.domain.ServeExecute;
import com.takshine.wxcrm.domain.ServeVisit;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.service.ComplaintService;

/**
 * 服务请求和 投诉 服务实现类
 * @author liulin
 *
 */
@Service("complaintService")
public class ComplaintServiceImpl extends BaseServiceImpl implements ComplaintService{

	public BaseModel initObj() {
		return null;
	}
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 查询 客户投诉 数据列表
	 * @param comp
	 * @return
	 */
	public Complaint getComplaintList(Complaint comp){
		
		comp.setModeltype(Constants.MODEL_TYPE_COMPLAINT);
		//排除不需要传的参数
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"crmid","count"});
		//转换为json
		String jsonStr = JSONObject.fromObject(comp, jsonConfig).toString();
		log.info("getComplaintList  => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		//rst = "{\"crmaccount\":\"eceaf1e1-9e7a-5ff6-c381-51c651abfc9b\",\"currpage\":\"1\",\"date_entered\":\"\",\"finish_time_c\":\"\",\"handle\":\"\",\"handle_date\":\"\",\"modeltype\":\"case\",\"name\":\"\",\"openid\":\"oAjmLt7pi13yasR8hJjxRBk96dCA\",\"opinion\":\"\",\"pagecount\":\"10\",\"position\":\"\",\"propose_time_c\":\"\",\"publicid\":\"gh_03b73dc63ef8\",\"rowid\":\"\",\"servertype\":\"servreq\",\"sponsor\":\"\",\"status\":\"\",\"subtype\":\"\",\"type\":\"search\",\"viewtype\":\"teamview\",\"count\":\"5\",\"comps\":[{\"belong_org\":\"\",\"case_number\":\"001001\",\"handle\":\"liulin\",\"complaint_source\":\"\",\"complaint_target\":\"\",\"name\":\"123123123\"}]}";
		log.info("getComplaintList  => rst is : " + rst);
		//返回结果
		if("".equals(rst)){
			comp.setErrcode(ErrCode.ERR_CODE_1001006);
			comp.setErrmsg(ErrCode.ERR_CODE_1001006_MSG);
			return comp;
		}
		//json化结果对象
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			log.info("getComplaintList  => count is :" + count);
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				@SuppressWarnings("unchecked")
				List<Complaint> list = (List<Complaint>)JSONArray.toCollection(jsonObject.getJSONArray("cases"), Complaint.class);
				comp.setComps(list);//列表
			}
			comp.setCount(count);//数字
		}else{
			comp.setErrcode(jsonObject.getString("errcode"));
			comp.setErrmsg(jsonObject.getString("errmsg"));
			log.info("getComplaintList  => errcode is : " + comp.getErrcode());
			log.info("getComplaintList  => errmsg is : " + comp.getErrmsg());
		}
		
		return comp;
	}
	
	/**
	 * 查询 服务执行 数据列表
	 * @param comp
	 * @return
	 */
	public ServeExecute getServeExecuteList(ServeExecute exe){
		
		exe.setModeltype(Constants.MODEL_TYPE_CASEEXEC);
		//排除不需要传的参数
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"crmid","count"});
		//转换为json
		String jsonStr = JSONObject.fromObject(exe, jsonConfig).toString();
		log.info("getComplaintList  => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		//rst = "{\"crmaccount\":\"eceaf1e1-9e7a-5ff6-c381-51c651abfc9b\",\"currpage\":\"1\",\"date_entered\":\"\",\"finish_time_c\":\"\",\"handle\":\"\",\"handle_date\":\"\",\"modeltype\":\"case\",\"name\":\"\",\"openid\":\"oAjmLt7pi13yasR8hJjxRBk96dCA\",\"opinion\":\"\",\"pagecount\":\"10\",\"position\":\"\",\"propose_time_c\":\"\",\"publicid\":\"gh_03b73dc63ef8\",\"rowid\":\"\",\"servertype\":\"servreq\",\"sponsor\":\"\",\"status\":\"\",\"subtype\":\"\",\"type\":\"search\",\"viewtype\":\"teamview\",\"count\":\"5\",\"comps\":[{\"belong_org\":\"\",\"case_number\":\"001001\",\"handle\":\"liulin\",\"complaint_source\":\"\",\"complaint_target\":\"\",\"name\":\"123123123\"}]}";
		log.info("getComplaintList  => rst is : " + rst);
		//返回结果
		if("".equals(rst)){
			exe.setErrcode(ErrCode.ERR_CODE_1001006);
			exe.setErrmsg(ErrCode.ERR_CODE_1001006_MSG);
			return exe;
		}
		//json化结果对象
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			log.info("getComplaintList  => count is :" + count);
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				@SuppressWarnings("unchecked")
				List<ServeExecute> list = (List<ServeExecute>)JSONArray.toCollection(jsonObject.getJSONArray("execs"), ServeExecute.class);
				exe.setExecs(list);//列表
			}
			exe.setCount(count);//数字
		}else{
			exe.setErrcode(jsonObject.getString("errcode"));
			exe.setErrmsg(jsonObject.getString("errmsg"));
			log.info("getComplaintList  => errcode is : " + exe.getErrcode());
			log.info("getComplaintList  => errmsg is : " + exe.getErrmsg());
		}
		
		return exe;
	}
	
	/**
	 * 查询 服务回访 数据列表
	 * @param comp
	 * @return
	 */
	public ServeVisit getServeVisitList(ServeVisit visit){
		
		visit.setModeltype(Constants.MODEL_TYPE_CASEVISIT);
		//排除不需要传的参数
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"crmid","count"});
		//转换为json
		String jsonStr = JSONObject.fromObject(visit, jsonConfig).toString();
		log.info("getComplaintList  => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		//rst = "{\"crmaccount\":\"eceaf1e1-9e7a-5ff6-c381-51c651abfc9b\",\"currpage\":\"1\",\"date_entered\":\"\",\"finish_time_c\":\"\",\"handle\":\"\",\"handle_date\":\"\",\"modeltype\":\"case\",\"name\":\"\",\"openid\":\"oAjmLt7pi13yasR8hJjxRBk96dCA\",\"opinion\":\"\",\"pagecount\":\"10\",\"position\":\"\",\"propose_time_c\":\"\",\"publicid\":\"gh_03b73dc63ef8\",\"rowid\":\"\",\"servertype\":\"servreq\",\"sponsor\":\"\",\"status\":\"\",\"subtype\":\"\",\"type\":\"search\",\"viewtype\":\"teamview\",\"count\":\"5\",\"comps\":[{\"belong_org\":\"\",\"case_number\":\"001001\",\"handle\":\"liulin\",\"complaint_source\":\"\",\"complaint_target\":\"\",\"name\":\"123123123\"}]}";
		log.info("getComplaintList  => rst is : " + rst);
		//返回结果
		if("".equals(rst)){
			visit.setErrcode(ErrCode.ERR_CODE_1001006);
			visit.setErrmsg(ErrCode.ERR_CODE_1001006_MSG);
			return visit;
		}
		//json化结果对象
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			log.info("getComplaintList  => count is :" + count);
			if(!"".equals(count) && Integer.parseInt(count) > 0){
				@SuppressWarnings("unchecked")
				List<ServeVisit> list = (List<ServeVisit>)JSONArray.toCollection(jsonObject.getJSONArray("visits"), ServeVisit.class);
				visit.setVisits(list);//列表
			}
			visit.setCount(count);//数字
		}else{
			visit.setErrcode(jsonObject.getString("errcode"));
			visit.setErrmsg(jsonObject.getString("errmsg"));
			log.info("getComplaintList  => errcode is : " + visit.getErrcode());
			log.info("getComplaintList  => errmsg is : " + visit.getErrmsg());
		}
		
		return visit;
	}

	/**
	 * 保存
	 */
	public CrmError addComplaint(Complaint complaint) {
		CrmError crmErr = new CrmError();
		complaint.setModeltype(Constants.MODEL_TYPE_COMPLAINT);
		complaint.setType(Constants.ACTION_ADD);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(complaint, jsonConfig).toString();
		log.info("addComplaint jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addComplaint rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addComplaint errcode => errcode is : " + errcode);
			log.info("addComplaint errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");//记录ID
				log.info("addComplaint rowId => rowid is : " + rowId);
				crmErr.setRowId(rowId);
			}
		}
		return crmErr;
	}
	
	/**
	 * 保存 执行
	 * @param complaint
	 * @return
	 */
	public CrmError addExec(ServeExecute exec){
		CrmError crmErr = new CrmError();
		exec.setModeltype(Constants.MODEL_TYPE_EXEC);
		exec.setType(Constants.ACTION_ADD);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(exec, jsonConfig).toString();
		log.info("addExec jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addExec rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addComplaint errcode => errcode is : " + errcode);
			log.info("addComplaint errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");//记录ID
				log.info("addComplaint rowId => rowid is : " + rowId);
				crmErr.setRowId(rowId);
			}
		}
		return crmErr;
	}

	/**
	 * 保存回访
	 */
	public CrmError addVisit(ServeVisit visit){
		CrmError crmErr = new CrmError();
		visit.setModeltype(Constants.MODEL_TYPE_VISIT);
		visit.setType(Constants.ACTION_ADD);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(visit, jsonConfig).toString();
		log.info("addVisit jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addVisit rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addComplaint errcode => errcode is : " + errcode);
			log.info("addComplaint errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");//记录ID
				log.info("addComplaint rowId => rowid is : " + rowId);
				crmErr.setRowId(rowId);
			}
		}
		return crmErr;
	}

	/**
	 * 服务派工 以及 状态更新 
	 * @param complaint
	 * @return
	 */
	public CrmError complaintStatusUpd(Complaint complaint){
		CrmError crmErr = new CrmError();
		
		complaint.setModeltype(Constants.MODEL_TYPE_COMPLAINT);
		complaint.setType(Constants.ACTION_UPDATE);
		
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		
		String jsonStr = JSONObject.fromObject(complaint, jsonConfig).toString();
		log.info("complaintStatusUpd jsonStr => jsonStr is : " + jsonStr);
		
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("complaintStatusUpd rst => rst is : " + rst);
		
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addSchedule errcode => errcode is : " + errcode);
			log.info("addSchedule errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
}
