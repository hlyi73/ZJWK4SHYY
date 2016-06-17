package com.takshine.wxcrm.service;

import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Sign;

/**
 * 考勤签到
 *
 */
public interface SignService extends EntityService{

	public boolean addSign(Sign sign) throws Exception;
	

	public List<Sign> searchSignByFilter(Sign sign) throws Exception;
}
