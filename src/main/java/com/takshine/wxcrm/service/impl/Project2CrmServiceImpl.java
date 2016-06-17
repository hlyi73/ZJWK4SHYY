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
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.Project;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;
import com.takshine.wxcrm.message.sugar.ProjectAdd;
import com.takshine.wxcrm.message.sugar.ProjectBase;
import com.takshine.wxcrm.message.sugar.ProjectReq;
import com.takshine.wxcrm.message.sugar.ProjectResp;
import com.takshine.wxcrm.service.Project2CrmService;

/**
 * 项目  相关业务接口实现
 * @author dengbo
 *
 */
@Service("project2CrmService")
public class Project2CrmServiceImpl extends BaseServiceImpl implements Project2CrmService{

	private static Logger log = Logger.getLogger(Project2CrmServiceImpl.class.getName());
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return null;
	}

	/**
	 * 查询项目数据列表
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 */
	@SuppressWarnings("unchecked")
	public ProjectResp getProjectList(Project gath, String source) throws Exception {
		//项目响应
		ProjectResp resp = new ProjectResp();
		resp.setCrmaccount(gath.getCrmId());//crmId
		resp.setModeltype(Constants.MODEL_TYPE_PROJ);//项目
		resp.setViewtype(gath.getViewtype());//视图类型
		//项目请求
		ProjectReq req = new ProjectReq();
		req.setCrmaccount(gath.getCrmId());
		req.setModeltype(Constants.MODEL_TYPE_PROJ);
		req.setViewtype(gath.getViewtype());
		req.setType(Constants.ACTION_SEARCH);//执行的是查询所有的操作
		req.setPagecount(gath.getPagecount());
		req.setCurrpage(gath.getCurrpage());
		req.setFirstchar(gath.getFirstchar());
		//转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getProjectList jsonStr => is : "+jsonStr);
		//多次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getProjectList rst => is : "+rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			String count = jsonObject.getString("count");
			if(!"".equals(count)&&Integer.parseInt(count)>0){
				//把json对象转换成list集合
				List<ProjectAdd> list = (List<ProjectAdd>)JSONArray.toCollection(jsonObject.getJSONArray("projects"),ProjectAdd.class);
				List<ProjectAdd> plist = new ArrayList<ProjectAdd>();
				for(ProjectAdd projectAdd:list){
					ProjectAdd pAdd = new ProjectAdd();
					BeanUtils.copyProperties(pAdd, projectAdd);
					if(StringUtils.isNotNullOrEmptyStr(projectAdd.getStartdate())){
						String startdate = DateTime.date2Str(DateTime.str2Date(projectAdd.getStartdate()),DateTime.DateFormat1);
						pAdd.setStartdate(startdate);
					}
					if(StringUtils.isNotNullOrEmptyStr(projectAdd.getEnddate())){
						String enddate = DateTime.date2Str(DateTime.str2Date(projectAdd.getEnddate()),DateTime.DateFormat1);
						pAdd.setEnddate(enddate);
					}
					plist.add(pAdd);
				}
				resp.setProjects(plist);
			}
			//记录条数
			resp.setCount(count);
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getProjectList errcode => errcode is : "+errcode);
			log.info("getProjectList errmsg => errmsg is : "+errmsg);
		}
		return resp;
 	}

	/**
	 * 查询单个项目数据
	 * @param rowid
	 * @param crmid
	 * @return
	 * @throws Exception
	 */
	public ProjectResp getProjectSingle(String rowid, String crmid)
			throws Exception {
	    ProjectResp resp = new ProjectResp();
		resp.setCrmaccount(crmid);//crm id
		resp.setModeltype(Constants.MODEL_TYPE_PROJ);
		ProjectReq single = new ProjectReq();
		single.setCrmaccount(crmid);//sugar id
		single.setModeltype(Constants.MODEL_TYPE_PROJ);
		single.setType(Constants.ACTION_SEARCHID);
		single.setRowid(rowid);
		//转换为json
		String jsonStr = JSONObject.fromObject(single).toString();
		log.info("getProjectSingle jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_MULITY);
		log.info("getProjectSingle rst => rst is : " + rst);
		//做空判断
		if(null == rst || "".equals(rst)) return resp;
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if(!jsonObject.containsKey("errcode")){
			if(StringUtils.isNotNullOrEmptyStr(jsonObject.getString("projects"))){
				List<ProjectAdd> plist = new ArrayList<ProjectAdd>();
				JSONArray jarr = jsonObject.getJSONArray("projects");
				ProjectAdd pa = null;
				for (int i = 0; i < jarr.size(); i++) {
					JSONObject jobj = (JSONObject) jarr.get(i);
					pa = new ProjectAdd();
					pa.setAssigner(jobj.getString("assigner"));
					pa.setAssignerid(jobj.getString("assignerid"));
					pa.setCreatedate(jobj.getString("createdate"));
					pa.setCreater(jobj.getString("creater"));
					pa.setDesc(jobj.getString("desc"));
					pa.setEnddate(jobj.getString("enddate"));
					pa.setModifier(jobj.getString("modifier"));
					pa.setModifydate(jobj.getString("modifydate"));
					pa.setName(jobj.getString("name"));
					pa.setPriorityname(jobj.getString("priorityname"));
					pa.setRowid(jobj.getString("rowid"));
					pa.setStartdate(jobj.getString("startdate"));
					pa.setStatus(jobj.getString("status"));
					pa.setAuthority(jobj.getString("authority"));
					pa.setPriority(jobj.getString("priority"));
					pa.setStatusname(jobj.getString("statusname"));				
					//跟进
					if(null != jobj.getString("audits") && !"".equals(jobj.getString("audits"))){
						List<OpptyAuditsAdd> auditsList = (List<OpptyAuditsAdd>)JSONArray.toCollection(jobj.getJSONArray("audits"), OpptyAuditsAdd.class);
					    pa.setAudits(auditsList);
					}
					
					plist.add(pa);
				}
				//List<ProjectAdd> plist = (List<ProjectAdd>)JSONArray.toCollection(jsonObject.getJSONArray("projects"), ProjectAdd.class);
				resp.setProjects(plist);//列表
			}
		}else{
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("getProjectSingle errcode => errcode is : " + errcode);
			log.info("getProjectSingle errmsg => errmsg is : " + errmsg);
		}
		return resp;
	}
	public CrmError addProject(Project pro) throws Exception {
		CrmError crmErr = new CrmError();
		log.info("addProject start => obj is : " + pro);
		ProjectBase prob= new ProjectBase();
		prob.setModeltype(Constants.MODEL_TYPE_PROJ);
		prob.setType(Constants.ACTION_ADD);
		//配置 排除掉某些属性不进行序列化
		prob.setCrmaccount(pro.getCrmId());
		prob.setAssigner(pro.getAssigner());
		prob.setAssignerid(pro.getAssignerid());
		prob.setDesc(pro.getDesc());
		prob.setEnddate(pro.getEnddate());
		prob.setStartdate(pro.getStartdate());
		prob.setName(pro.getName());
		prob.setStatus(pro.getStatus());
		prob.setPriority(pro.getPriority());
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(prob, jsonConfig).toString();
		log.info("addProject jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("addProject rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("addProject errcode => errcode is : " + errcode);
			log.info("addProject errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
			//错误编码
			if(ErrCode.ERR_CODE_0.equals(errcode)){
				String rowId = jsonObject.getString("rowid");//记录ID
				log.info("addProject rowid => rowId is : " + rowId);
				crmErr.setRowId(rowId);
			}
		}
		return crmErr;
	}

	public CrmError updateProject(Project pro) throws Exception {
		CrmError crmErr = new CrmError();
		log.info("updateProject start => obj is : " + pro);
		ProjectBase prob= new ProjectBase();
		prob.setRowid(pro.getRowid());
		prob.setModeltype(Constants.MODEL_TYPE_PROJ);
		prob.setType(Constants.ACTION_UPDATE);
		//配置 排除掉某些属性不进行序列化
		prob.setCrmaccount(pro.getCrmId());
		prob.setAssigner(pro.getAssigner());
		prob.setAssignerid(pro.getAssignerid());
		prob.setDesc(pro.getDesc());
		prob.setEnddate(pro.getEnddate());
		prob.setStartdate(pro.getStartdate());
		prob.setName(pro.getName());
		prob.setStatus(pro.getStatus());
		prob.setPriority(pro.getPriority());
		prob.setOptype(pro.getOptype());
		prob.setOpptyid(pro.getOpptyid());
		prob.setOpptyname(pro.getOpptyname());
		prob.setCustomer(pro.getCustomer());
		prob.setCustomerid(pro.getCustomerid());
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setExcludes(new String []{"",""});
				
		String jsonStr = JSONObject.fromObject(prob, jsonConfig).toString();
		log.info("updateProject jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		log.info("updateProject rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		// 如果请求成功
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");//错误编码
			String errmsg = jsonObject.getString("errmsg");//错误消息
			log.info("updateProject errcode => errcode is : " + errcode);
			log.info("updateProject errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
}
