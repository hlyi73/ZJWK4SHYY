package com.takshine.wxcrm.service.impl;

import java.util.List;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.message.error.CrmError;
import com.takshine.wxcrm.message.sugar.LovReq;
import com.takshine.wxcrm.message.sugar.SysApplyAdd;
import com.takshine.wxcrm.message.sugar.UserAdd;
import com.takshine.wxcrm.service.RegisterService;

/**
 * 注册
 * @author dengbo
 *
 */
@Service("registerService")
public class RegisterServiceImpl extends BaseServiceImpl implements RegisterService{

	private static Logger log = Logger.getLogger(Oppty2SugarServiceImpl.class.getName());

	@Override
	protected String getDomainName() {
		return "SysApplyAdd";
	}
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "sysApplyAddSql.";
	}
	
	public BaseModel initObj() {
		return new SysApplyAdd();
	}
	
	/**
	 * 创建管理员用户
	 * @param sysApplyAdd
	 * @return
	 */
	public String createAdmin(SysApplyAdd sysApplyAdd){
		sysApplyAdd.setType(Constants.ACTION_OPEN);
		sysApplyAdd.setModeltype(Constants.MODEL_TYPE_USER);
		sysApplyAdd.setSource(Constants.SYS_SOURCE);
		//配置 排除掉某些属性不进行序列化
		String jsonStr = JSONObject.fromObject(sysApplyAdd).toString();
		log.info("createAdmin jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_AUTH, jsonStr, Constants.INVOKE_SINGLE);
		log.info("createAdmin rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		String crmId = "";
		// 如果请求成功
		if (null != jsonObject) {
			crmId = jsonObject.getString("rowid");//错误消息
			log.info("createAdmin crmId => crmId is : " + crmId);
		}
		return crmId;
	}
	
	
	
	/**
	 * 保存部门
	 * @param crmId
	 * @param dataColl
	 * @return
	 */
	public CrmError saveDepts(String crmId,String lovVal,String lovKey){
		CrmError crmErr = new CrmError();
		LovReq tq = new LovReq();
		tq.setCrmaccount(crmId);
		tq.setType(Constants.ACTION_UPDATE);
		tq.setModeltype(Constants.MODEL_TYPE_LOV);
		tq.setLov_key(lovKey);
		tq.setLov_val(lovVal);
		//转换为json
		String jsonStr = JSONObject.fromObject(tq).toString();
		log.info("saveDepts jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_INIT, jsonStr, Constants.INVOKE_MULITY);
		log.info("saveDepts rst => rst is : " + rst);
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("saveDepts errcode => errcode is : " + errcode);
			log.info("saveDepts errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}
	
	/**
	 * 保存用户
	 * @param userAdd
	 * @return
	 */
	public CrmError saveUser(UserAdd userAdd){
		CrmError crmErr = new CrmError();
		userAdd.setType(Constants.ACTION_ADD);
		userAdd.setModeltype(Constants.MODEL_TYPE_USER);
		userAdd.setSource(Constants.SYS_SOURCE);
		//转换为json
		String jsonStr = JSONObject.fromObject(userAdd).toString();
		log.info("saveUser jsonStr => jsonStr is : " + jsonStr);
		//单次调用sugar接口 
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_AUTH, jsonStr, Constants.INVOKE_MULITY);
		log.info("saveUser rst => rst is : " + rst);
		//解析JSON数据
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		if (null != jsonObject) {
			String errcode = jsonObject.getString("errcode");
			String errmsg = jsonObject.getString("errmsg");
			log.info("saveUser errcode => errcode is : " + errcode);
			log.info("saveUser errmsg => errmsg is : " + errmsg);
			crmErr.setErrorCode(errcode);
			crmErr.setErrorMsg(errmsg);
		}
		return crmErr;
	}

	public boolean addApply(SysApplyAdd sysApplyAdd) {
		int flag = getSqlSession().insert("sysApplyAddSql.insertSysApplyAdd", sysApplyAdd);
		if(flag >0){
			return true;
		}
		return false;
	}

	public List<SysApplyAdd> searchApplyOrgs(SysApplyAdd sysApplyAdd) {
		return getSqlSession().selectList("sysApplyAddSql.searchOrganizationByOpenId", sysApplyAdd);
	}
}
