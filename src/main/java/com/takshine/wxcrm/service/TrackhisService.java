package com.takshine.wxcrm.service;


import java.util.List;

import com.takshine.wxcrm.base.services.EntityService;
import com.takshine.wxcrm.domain.Trackhis;
import com.takshine.wxcrm.message.sugar.OpptyAuditsAdd;

/**
 * 跟进历史
 *
 * @author liulin
 */
public interface TrackhisService extends EntityService {
	
	/**
	 * 查询 跟进历史 列表
	 * @param comp
	 * @return
	 */
	public Trackhis getTrackhisList(Trackhis his);
	
	/**
	 * 查询 跟进历史 列表
	 * @param comp
	 * @return
	 */
	public List<OpptyAuditsAdd> getTrackhisList2(Trackhis his);
	
}