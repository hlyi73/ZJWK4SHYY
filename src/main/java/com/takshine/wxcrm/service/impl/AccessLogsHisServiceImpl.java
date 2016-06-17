package com.takshine.wxcrm.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.base.util.StringUtils;
import com.takshine.wxcrm.domain.AccessLogs;
import com.takshine.wxcrm.domain.AccessLogsHis;
import com.takshine.wxcrm.domain.Integral;
import com.takshine.wxcrm.service.AccessLogsHisService;
import com.takshine.wxcrm.service.IntegralService;

/**
 * 访问日志 历史
 * @author liulin
 *
 */
@Service("accessLogsHisService")
public class AccessLogsHisServiceImpl extends BaseServiceImpl implements AccessLogsHisService{

	private static Logger log = Logger.getLogger(AccessLogsHisServiceImpl.class.getName());
	
	private static Map<String, String> rules = new HashMap<String, String>();
	
	private IntegralService integralService;
	
	public void setIntegralService(IntegralService integralService) {
		this.integralService = integralService;
	}

	@Override
	protected String getDomainName() {
		return "AccessLogsHis";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "accessLogsHisSql.";
	}
	
	public BaseModel initObj() {
		return new AccessLogsHis();
	}
	
	/**
	 * 查询访问日志 历史
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<AccessLogsHis> findAccessLogHisByFilter(String startDate, String endDate){
		AccessLogsHis sear = new AccessLogsHis();
		sear.setStartDate(startDate);
		sear.setEndDate(endDate);
		return (List<AccessLogsHis>)findObjListByFilter(sear);
	}
	
	/**
	 * 查询访问日志数量
	 * @param entId
	 * @return
	 */
	public String countAccessLogsHis(String url, String params, String startDate, String endDate){
		if(null != url) url = "%"+ url +"%";
		if(null != params) params = "%"+ params +"%";
		//search param
		AccessLogs s = new AccessLogs();
		s.setUrl(url);
		s.setStartDate(startDate);
		s.setEndDate(endDate);
		s.setParams(params);
		
		List<String> data = getSqlSession().selectList("accessLogsSql.countAccessLogsHisByFilter", s);
		if(null != data && data.size() > 0 ){
			String rst= String.valueOf(data.get(0));
			log.info("countAccessLogsHis =>" + rst);
			return rst;
		}else{
			return "0";
		}
	}
	
	/**
	 * 加载统计积分的 规则
	 */
	@SuppressWarnings("rawtypes")
	public void loadRule(){
		try {
			if(rules.keySet().size() == 0){
				InputStream in = getClass().getResourceAsStream("/integralrule.properties");
				Properties pro = new Properties();
				pro.load(in);
				//迭代属性文件
				for (Iterator iterator = pro.keySet().iterator(); iterator.hasNext();) {
					String key = (String) iterator.next();
					if(key.indexOf("rule_name") != -1){
						String url = (String) pro.get("rule_" + pro.get(key) + "_url");
							   url = url.trim();
						String point = (String) pro.get("rule_" + pro.get(key) + "_point");
							   point = point.trim();
						rules.put(url, point);
					}
				}
			}
			
		} catch (IOException e) {
			log.error(e.getMessage());
		}
	}
	
	/**
	 * 分析访问历史数据 , 统计积分 
	 */
	public void addCalculateIntegralByLogsHis(List<AccessLogsHis> logsHis){
		loadRule();
		//缓存
		Map<String, String> integralCache = new HashMap<String, String>();
		Map<String, String> openIdCache = new HashMap<String, String>();
		//遍历日志历史
		for (int i = 0; i < logsHis.size(); i++) {
			handlerAccessLogHis(logsHis.get(i), integralCache, openIdCache);
		}
		//保存到积分数据表
		try {
			for (Iterator<String> iterator = integralCache.keySet().iterator(); iterator.hasNext();) {
				String crmId = (String) iterator.next();
				String point = integralCache.get(crmId);
				
				//查询积分是否存在
				Integral in = new Integral();
				in.setCrmId(crmId);
				in.setCurrpages(0);
				in.setPagecounts(10);
				@SuppressWarnings("unchecked")
				List<Integral> lst = (List<Integral>)integralService.findObjListByFilter(in);
				if(lst.size() > 0){
					Integral iobj = lst.get(0);
					Integer pAfter = iobj.getTotal() + Integer.parseInt(point);
					iobj.setTotal(pAfter);
					iobj.setTotalPre(iobj.getTotal());
					iobj.setUpdateTime(DateTime.currentDate());
					//更新积分对象
					integralService.updateObj(iobj);
				}else{
					in.setId(Get32Primarykey.getRandom32BeginTimePK());
					in.setTotal(Integer.parseInt(point));
					in.setTotalPre(Integer.parseInt(point));
					in.setCreateTime(DateTime.currentDate());
					in.setUpdateTime(DateTime.currentDate());
					integralService.addObj(in);
				}
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}
	
	/**
	 * 数据处理
	 * @param logs
	 * @param integralCache
	 * @param openIdCache
	 */
	@SuppressWarnings("rawtypes")
	private void handlerAccessLogHis(AccessLogsHis logs, 
			                          Map<String, String> integralCache, 
			                            Map<String, String> openIdCache){
		//url
		String key = logs.getUrl().trim();
		//遍历迭代集合
		for (Iterator iterator = rules.keySet().iterator(); iterator.hasNext();) {
			String url = (String) iterator.next();
				   url = url.trim();
			Pattern p = Pattern.compile("^.+" + url + "$");
			Matcher m = p.matcher(key);
			if(m.matches()){
				String crmId = "";
				//参数
				String paStr = logs.getParams();
				if(paStr.indexOf("crmId") == -1){
					String openId = StringUtils.getRankVal("openId", "&", paStr);
					String publicId = StringUtils.getRankVal("publicId", "&", paStr);
					//从缓存集合中取值 提高速度
					if(!openIdCache.containsKey(openId + "-" + publicId)){
						crmId = getCrmId(openId, publicId);
						openIdCache.put(openId + "-" + publicId, crmId);
					}else{
						crmId = openIdCache.get(openId + "-" + publicId);
					}
				}else{
					crmId = StringUtils.getRankVal("crmId", "&", paStr);
				}
				if("".equals(crmId)){
					continue;
				}
				//计算积分
				String point = rules.get(url);
				if(!integralCache.containsKey(crmId)){
					integralCache.put(crmId, point);
				}else{
					String pt = integralCache.get(crmId);
					String paf = String.valueOf(Integer.parseInt(point) + Integer.parseInt(pt));
					integralCache.put(crmId, paf);
				}
			}
		}
	}
}
