package com.takshine.wxcrm.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.DateTime;
import com.takshine.wxcrm.base.util.Get32Primarykey;
import com.takshine.wxcrm.domain.Sign;
import com.takshine.wxcrm.service.SignService;

/**
 * 考勤签到
 *
 */
@Service("signService")
public class SignServiceImpl extends BaseServiceImpl implements SignService{

	@Override
	protected String getDomainName() {
		return "Sign";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "signSql.";
	}
	
	public BaseModel initObj() {
		return new Sign();
	}

	/**
	 * 签到/签出
	 */
	public boolean addSign(Sign sign) throws Exception {
		sign.setId(Get32Primarykey.getRandom32PK());
		sign.setCreateTime(DateTime.currentDate());
		int flag = this.getSqlSession().insert("signSql.insertSign", sign);
		if(flag>0){
			return true;
		}else{
			return false;
		}
	}

	/**
	 * 查询列表
	 */
	public List<Sign> searchSignByFilter(Sign sign) throws Exception {
		return this.getSqlSession().selectList("signSql.findSignByFilter", sign);
	}
	
	
}
