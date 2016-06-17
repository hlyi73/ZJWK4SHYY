package com.takshine.wxcrm.service.impl;


import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.domain.SocialUserInfo;
import com.takshine.wxcrm.service.SocialUserinfoService;

/**
 * 第三方平台用户服务实现
 * @author 
 *
 */
@Service("socialUserinfoService")
public class SocialUserinfoServiceImpl extends BaseServiceImpl implements SocialUserinfoService {
	
	private static Logger log = Logger.getLogger(SocialUserinfoServiceImpl.class.getName());
	
	@Override
	protected String getDomainName() {
		return "SocialUserInfo";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "socialUserInfoSql.";
	}
	
	public BaseModel initObj() {
		return new SocialUserInfo();
	}

	public SocialUserInfo getWbuserInfo(SocialUserInfo u) {
		List<SocialUserInfo> ulist = (List<SocialUserInfo>)findObjListByFilter(u);
		if(ulist.size() > 0){
			u = ulist.get(0);
			return u;
		}else{
			return null;
		}
	}

	public void saveOrUptUserInfo(SocialUserInfo u) {
		// TODO Auto-generated method stub
		try {
			//根据ID 查询数据对象
			SocialUserInfo searchObj = new SocialUserInfo();
			searchObj.setOpenId(u.getOpenId());
			//查询结果集返回对象
			if(null != findObj(searchObj)){
				//更新用户信息数据
				updateObj(u);
			}else{
				addObj(u);
			}
		} catch (Exception e) {
			log.info("saveOrUptUserInfo method =>" + e.getMessage());
		}
	}

	

}
