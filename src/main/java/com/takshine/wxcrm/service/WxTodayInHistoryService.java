package com.takshine.wxcrm.service;

/**
 * 历史上的今天
 * @author liulin
 *
 */
public interface WxTodayInHistoryService {
	
	/** 
     * 封装历史上的今天查询方法，供外部调用 
     *  
     * @return 
     */  
    public String getTodayInHistoryInfo();
}
