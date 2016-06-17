package com.takshine.marketing.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.core.service.CRMService;
import com.takshine.marketing.domain.Lov;
import com.takshine.marketing.service.LovService;

/**
 * 下拉列表服务类
 */
@Service("lovService")
public class LovServiceImpl extends BaseServiceImpl implements LovService{
	
	// 日志
	protected static Logger log = Logger.getLogger(LovServiceImpl.class.getName());
	

	@Override
	protected String getDomainName() {
		return "Lov";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "lovSql.";
	}
	
	public BaseModel initObj() {
		return new Lov();
	}
	
	/**
	 * 查询 下拉列表
	 * @return
	 */
	
	public Map<String, Map<String, String>> getLovList(Lov lov){
		List<Lov> lovList = getSqlSession().selectList("lovSql.findLovList", lov);
		
		Map<String, Map<String, String>> lovMap = null;
		
		if(null != lovList && lovList.size() > 0 ){
			lovMap = new HashMap<String, Map<String,String>>();
			Map<String, String> m = null;
			for(int i=0;i<lovList.size();i++){
				lov = lovList.get(i);
				if(lovMap.containsKey(lov.getName())){
					m = lovMap.get(lov.getName());
					m.put(lov.getKey(), lov.getValue());
					
				}else{
					m = new HashMap<String, String>();
					m.put(lov.getKey(), lov.getValue());
					lovMap.put(lov.getName(), m);
				}
			}
		}
		
		return lovMap;
	}
}
