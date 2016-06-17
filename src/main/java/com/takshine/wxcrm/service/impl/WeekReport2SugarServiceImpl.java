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
import com.takshine.wxcrm.domain.WeekReport;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.ScheSingleReq;
import com.takshine.wxcrm.message.sugar.WeekReportAdd;
import com.takshine.wxcrm.message.sugar.WeekReportDetail;
import com.takshine.wxcrm.message.sugar.WeekReportReq;
import com.takshine.wxcrm.message.sugar.WeekReportResp;
import com.takshine.wxcrm.service.WeekReport2SugarService;

/**
 * 周报相关业务接口实现
 *
 * @author dengbo
 */
@Service("weekReport2SugarService")
public class WeekReport2SugarServiceImpl extends BaseServiceImpl implements WeekReport2SugarService {
	
	private static Logger log = Logger.getLogger(WeekReport2SugarServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
		
	public BaseModel initObj() {
		return null;
	}
	
	/**
	 * 查询 周报数据列表
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public WeekReportResp getWeekReportList(WeekReport wReport,String source){
		//周报响应
		WeekReportResp resp = new WeekReportResp();
		resp.setCrmaccount(wReport.getCrmId());//crm id
		resp.setModeltype(Constants.MODEL_TYPE_WEEKREPORT);
		resp.setViewtype(wReport.getViewtype());
		resp.setCurrpage(wReport.getCurrpage());
		resp.setPagecount(wReport.getPagecount());
		//周报请求
		WeekReportReq sreq = new WeekReportReq();
		sreq.setCrmaccount(wReport.getCrmId());//crm id
		sreq.setModeltype(Constants.MODEL_TYPE_WEEKREPORT);
		sreq.setType(Constants.ACTION_SEARCH);
		sreq.setViewtype(wReport.getViewtype());
		sreq.setCurrpage(wReport.getCurrpage());
		sreq.setAssignerid(wReport.getAssignerid());//责任人
		sreq.setCountweek(wReport.getCountweek());//周次
		//如果是WEB上显示
		if("WEB".equals(source)){
			sreq.setPagecount(wReport.getPagecount());
		}else{
			sreq.setPagecount(wReport.getPagecount());
		}
		//转换为json
		String jsonStr = JSONObject.fromObject(sreq).toString();
		log.info("getWeekReportList jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getWeekReportList rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			//错误代码和消息
			String count = jsonObject.getString("count");
			if(!"".equals(count)&& Integer.parseInt(count) > 0){
				List<WeekReportAdd> list = (List<WeekReportAdd>)JSONArray.toCollection(jsonObject.getJSONArray("weekreports"),WeekReportAdd.class);
				resp.setReports(list);//周报列表
			}
			resp.setCount(count);//数字
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
			log.info("getWeekReportList errcode => errcode is : " + errcode);
			log.info("getWeekReportList errmsg => errmsg is : " + errmsg);
		}
		return resp;
	}
	
	/**
	 * 查询单个周报数据
	 * @param rowId
	 * @param crmId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public WeekReportResp getWeekReportSingle(String rowId, String crmId){
		//周报响应
		WeekReportResp resp = new WeekReportResp();
		resp.setCrmaccount(crmId);//sugar id
		resp.setModeltype(Constants.MODEL_TYPE_WEEKREPORT);
		//周报请求
		ScheSingleReq single = new ScheSingleReq();
		single.setCrmaccount(crmId);//sugar id
		single.setModeltype(Constants.MODEL_TYPE_WEEKREPORT);
		single.setType(Constants.ACTION_SEARCHID);
		single.setRowid(rowId);
		//转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getWeekReportSingle jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getWeekReportSingle rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			JSONArray jsonArray = jsonObject.getJSONArray("weekreports");
			List<WeekReportAdd> olist = new ArrayList<WeekReportAdd>();
			for(int i=0;i<jsonArray.size();i++){
				JSONObject jobj = (JSONObject)jsonArray.get(i);
				WeekReportAdd weekReportAdd = new WeekReportAdd();
				weekReportAdd.setRowid(jobj.getString("rowid"));
				weekReportAdd.setAssignerid(jobj.getString("assignerid"));
				weekReportAdd.setAssigner(jobj.getString("assigner"));
				weekReportAdd.setDepartment(jobj.getString("department"));
				weekReportAdd.setDate(jobj.getString("date"));
				weekReportAdd.setCountweek(jobj.getString("countweek"));
				weekReportAdd.setReporttype(jobj.getString("reporttype"));
				weekReportAdd.setReporttypename(jobj.getString("reporttypename"));
				weekReportAdd.setAuthority(jobj.getString("authority"));
				if (null != jobj.getString("details")&& !"".equals(jobj.getString("details"))) {
					List<WeekReportDetail> opptyList = (List<WeekReportDetail>) JSONArray.toCollection(jobj.getJSONArray("details"),WeekReportDetail.class);
					weekReportAdd.setDetails(opptyList);
				}
				olist.add(weekReportAdd);
			}
			resp.setReports(olist);//任务列表
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getWeekReportSingle errcode => errcode is : " + errcode);
			log.info("getWeekReportSingle errmsg => errmsg is : " + errmsg);
			resp.setErrcode(errcode);
			resp.setErrmsg(errmsg);
		}
		return resp;
	}
	
	//保存周报信息
	public CrmError addWeekReport(WeekReport obj) {
		CrmError crmErr = new CrmError();
		// TODO Auto-generated method stub
		log.info("addWeekReport start => obj is : " + obj);
		WeekReportReq op = new WeekReportReq();
		op.setCrmaccount(obj.getCrmId());
		op.setModeltype(Constants.MODEL_TYPE_WEEKREPORT);
		op.setType(Constants.ACTION_ADD);
		op.setCountweek(obj.getCountweek());
		op.setWorktype(obj.getWorktype());
		op.setParenttype(obj.getParenttype());
		op.setContent(obj.getContent());
		op.setStartdate(obj.getStartdate());
		op.setEnddate(obj.getEnddate());
		op.setSummarize(obj.getSummarize());
		op.setProduct(obj.getProduct());
		op.setIndustry(obj.getIndustry());
		op.setGoal(obj.getGoal());
		op.setAssignerid(obj.getAssignerid());
		op.setProjectdynamic(obj.getProjectdynamic());
		op.setQutorsugg(obj.getQutorsugg());
		op.setParentid(obj.getParentid());
		op.setReporttype(obj.getReporttype());
		op.setQuesttype(obj.getQuesttype());
		//配置 排除掉某些属性不进行序列化
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
		String jsonStr = JSONObject.fromObject(op, jsonConfig).toString();
		log.info("addWeekReport jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addWeekReport rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addWeekReport errcode => errcode is : " + errcode);
			log.info("addWeekReport errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");//记录ID
				log.info("addWeekReport rowId => rowid is : " + rowId);
				crmErr.setRowId(rowId);
			}
		}
		return crmErr;
	}

}
