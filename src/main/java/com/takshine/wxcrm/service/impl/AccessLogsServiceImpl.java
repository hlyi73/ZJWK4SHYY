package com.takshine.wxcrm.service.impl;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.core.service.CRMService;
import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.domain.AccessLogs;
import com.takshine.wxcrm.domain.AccessLogsHis;
import com.takshine.wxcrm.message.sugar.AccesslogAdd;
import com.takshine.wxcrm.message.sugar.AccesslogReq;
import com.takshine.wxcrm.message.sugar.AccesslogResp;
import com.takshine.wxcrm.message.sugar.CustomerAdd;
import com.takshine.wxcrm.service.AccessLogsHisService;
import com.takshine.wxcrm.service.AccessLogsService;

/**
 * 访问日志
 * @author liulin
 *
 */
@Service("accessLogsService")
public class AccessLogsServiceImpl extends BaseServiceImpl implements AccessLogsService{

	private static Logger log = Logger.getLogger(AccessLogsServiceImpl.class.getName());
	
	@Override
	protected String getDomainName() {
		return "AccessLogs";
	}
	

	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "accessLogsSql.";
	}
	
	@Autowired
	@Qualifier("cRMService")
	private CRMService cRMService;
	
	public BaseModel initObj() {
		return new AccessLogs();
	}
	
	/**
	 * 查询访问日志 
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<AccessLogs> findAccessLogByFilter(String crmId,String startDate, String endDate, Integer curr, Integer pagecount){
		AccessLogs sear = new AccessLogs();
		sear.setStartDate(startDate);
		sear.setEndDate(endDate);
		sear.setCurrpages(curr);
		sear.setPagecounts(pagecount);
		sear.setCrmId(crmId);
		return (List<AccessLogs>)findObjListByFilter(sear);
	}
	
	/**
	 * 查询访问日志数量
	 * @param entId
	 * @return
	 */
	public String countAccessLogs(String crmId,String url, String params, String startDate, String endDate){
		if(null != url) url = "%"+ url +"%";
		if(null != params) params = "%"+ params +"%";
		//search param
		AccessLogs s = new AccessLogs();
		s.setUrl(url);
		s.setStartDate(startDate);
		s.setEndDate(endDate);
		s.setParams(params);
		s.setCrmId(crmId);
		List<String> data = getSqlSession().selectList("accessLogsSql.countAccessLogsByFilter", s);
		if(null != data && data.size() > 0 ){
			String rst= String.valueOf(data.get(0));
			log.info("countAccessLogs =>" + rst);
			return rst;
		}else{
			return "0";
		}
	}
	
	
	
	
	/**
	 * 积分计算
	 */
	public void calculateIntegral(){
		Long t1 = DateTime.currentTimeMillis();
		try {
			//清空访问历史数据
			getSqlSession().delete("accessLogsHisSql.deleteAccessLogsHis");
			//开始日期 结束日期 -7
			String startDate = DateTime.preDayTime("yyyy-MM-dd", -7), endDate = DateTime.currentDateTime("yyyy-MM-dd");
			List<AccessLogsHis> logsHisList = new ArrayList<AccessLogsHis>();
			//剩余
			List<AccessLogsHis> leftHisList = new ArrayList<AccessLogsHis>();
			//查询集合
			List<AccessLogs> logsList = findAccessLogByFilter("",startDate, endDate, 0, 50000);
			
			//对象属性数据复制 并且录入到历史数据表中
			for (int i = 0; i < logsList.size(); i++) {
				AccessLogs logs = (AccessLogs)logsList.get(i);
				AccessLogsHis logsHis = new AccessLogsHis();
				BeanUtils.copyProperties(logsHis, logs);
				logsHisList.add(logsHis);
				
				if(i % 200 == 0){
					getSqlSession().insert("batchInsertAccessLogsHis", logsHisList);
					logsHisList.clear();
					leftHisList.clear();
				}else{
					leftHisList.add(logsHis);
				}
			}
			//剩余的数据入库
			if(leftHisList.size() > 0){
				getSqlSession().insert("batchInsertAccessLogsHis", leftHisList);
			}
			//分析访问数据 并且计算积分
			cRMService.getDbService().getAccessLogsHisService().addCalculateIntegralByLogsHis(logsHisList);
			
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		Long t2 = DateTime.currentTimeMillis();
		log.info("calculateIntegral cost time is = >" + (t2 - t1));
	}

	
	/**
	 * 每日访问访问统计
	 */
	public List<AccessLogs> countAccessLogs(String openId,String startDate, String endDate,String type) {
		AccessLogs s = new AccessLogs();
		s.setStartDate(startDate);
		s.setEndDate(endDate);
		s.setOpenId(openId);
		s.setOrgId(Constants.DEFAULT_ORGANIZATION);
		List<AccessLogs> accessList = null;
		if("day".equals(type)){
			accessList = getSqlSession().selectList("accessLogsSql.countAccessLogsByDate", s);
		}else if("module".equals(type)){
			accessList = getSqlSession().selectList("accessLogsSql.countAccessLogsByModule", s);
		}else if("user".equals(type)){
			accessList = getSqlSession().selectList("accessLogsSql.countAccessLogsByUser", s);
		}else if("top5".equals(type)){
			accessList = getSqlSession().selectList("accessLogsSql.countAccessLogsByUserTop5", s);
		}else if("bottom5".equals(type)){
			accessList = getSqlSession().selectList("accessLogsSql.countAccessLogsByUserBottom5", s);
		}
		return accessList;
	}
	
	/**
	 * 查询 用户访问行为数据列表
	 * 
	 * @param source
	 *            是用于微信平台上，还是在WEB上显示
	 * @return
	 */
	public AccesslogResp addcountAccessLogs(AccessLogs sche, String source) {
		// 接口响应
		AccesslogResp resp = new AccesslogResp();
        resp.setCrmaccount(sche.getCrmId());
        resp.setModeltype(Constants.MODEL_TYPE_ACCESSLOG);
		
		//接口请求
		AccesslogReq req = new AccesslogReq();
		req.setCrmaccount(sche.getCrmId());
        req.setModeltype(Constants.MODEL_TYPE_ACCESSLOG);
        req.setType(Constants.ACTION_SEARCH);
        req.setStartDate(sche.getStartDate());//开始时间
		req.setEndDate(sche.getEndDate());//结束时间
		
		// 如果是WEB上显示
		if ("WEB".equals(source)) {
			req.setPagecount(sche.getPagecount());
		} else {
			req.setPagecount(sche.getPagecount());
		}
		// 转换为json
		String jsonStr = JSONObject.fromObject(req).toString();
		log.info("getAccesslogList jsonStr => jsonStr is : " + jsonStr);
		// 单次调用sugar接口
		String rst = cRMService.getWxService().getWxHttpConUtil().postJsonData(Constants.MODEL_URL_ENTRY, jsonStr,Constants.INVOKE_MULITY);
		// 做空判断
		if (null == rst || "".equals(rst))
					return resp;
		// 解析JSON数据
		log.info("getAccesslogList rst => rst is : " + rst);
		JSONObject jsonObject = JSONObject.fromObject(rst.substring(rst.indexOf("{")));
		   if (!jsonObject.containsKey("errcode")) {
			// 错误代码和消息
			String count = jsonObject.getString("count");
			if (!"".equals(count) && Integer.parseInt(count) > 0) {
						List<AccesslogAdd> list = (List<AccesslogAdd>) JSONArray.toCollection(jsonObject.getJSONArray("accesslogs"),AccesslogAdd.class);
//						List<AccesslogAdd> clist = new ArrayList<AccesslogAdd>();
//						for(AccesslogAdd accesslogAdd : list){
//							AccesslogAdd cadd = new AccesslogAdd();
//							try {
//								BeanUtils.copyProperties(cadd, accesslogAdd);
//							} catch (Exception e) {
//								e.printStackTrace();
//							} 
//							clist.add(cadd);
//						}
						resp.setAccesslog(list);// 用户行为列表
					}
				} else {
					String errcode = jsonObject.getString("errcode");
					String errmsg = jsonObject.getString("errmsg");
					log.info("getAccesslogList errcode => errcode is : " + errcode);
					log.info("getAccesslogList errmsg => errmsg is : " + errmsg);
					resp.setErrcode(errcode);
					resp.setErrmsg(errmsg);
				}
				return resp;
	}

}
