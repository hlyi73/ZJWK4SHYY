package com.takshine.wxcrm.base.listener;

import net.sf.ehcache.CacheException;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;
import net.sf.ehcache.event.CacheEventListener;

import org.apache.log4j.Logger;

import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.base.util.cache.EhcacheUtil;
import com.takshine.wxcrm.domain.AccessLogs;
import com.takshine.wxcrm.service.AccessLogsService;

public class WxAccessLogsCacheEventListener implements CacheEventListener {  
	public static final String syncObject = "";

	// 用户和手机绑定关系  服务
	private AccessLogsService accessLogsService;
  
	private static Logger logger = Logger.getLogger(WxHttpConUtil.class.getName());
	
	public static final CacheEventListener INSTANCE = new WxAccessLogsCacheEventListener();

	public void notifyElementRemoved(Ehcache cache, Element element)
			throws CacheException {
		//logger.info("WxAccessLogsCacheEventListener notifyElementRemoved begin => ");		
	}

	public void notifyElementPut(Ehcache cache, Element element)
			throws CacheException {
		//logger.info("WxAccessLogsCacheEventListener notifyElementPut begin => ");
		setAccessLogsService();
		busiEleHandler(element);
	}

	public void notifyElementUpdated(Ehcache cache, Element element)
			throws CacheException {
		//logger.info("WxAccessLogsCacheEventListener notifyElementUpdated begin => ");
		setAccessLogsService();
		busiEleHandler(element);
	}

	public void notifyElementExpired(Ehcache cache, Element element) {
		// TODO Auto-generated method stub
		
	}

	public void notifyElementEvicted(Ehcache cache, Element element) {
		// TODO Auto-generated method stub
		
	}

	public void notifyRemoveAll(Ehcache cache) {
		// TODO Auto-generated method stub
		
	}

	public void dispose() {
		// TODO Auto-generated method stub
		
	}  
	
	public Object clone() throws CloneNotSupportedException {  
        throw new CloneNotSupportedException("Singleton instance");  
    } 
	
	/**
	 * 设置属性值
	 */
	public void setAccessLogsService() {
		synchronized (syncObject) {
			if(null == accessLogsService){
				Object obj = EhcacheUtil.get("accessLogsOperObj");
				if(null != obj){
					this.accessLogsService = (AccessLogsService)obj;
				}
			}
		}
	}
	
	
	class WriteLogThread extends Thread{
		AccessLogsService accessLogsService;
		AccessLogs acclog;
		public WriteLogThread(AccessLogsService accessLogsService,AccessLogs acclog){
			this.accessLogsService = accessLogsService;
			this.acclog = acclog;
		}
		public void run(){
			try {
				synchronized (syncObject) {
					accessLogsService.addObj(acclog);
					logger.info("WriteLogThread run acclog => " + acclog.getId());
				}
			} catch (Exception e) {
				logger.info("WriteLogThread run exception => " + e.getMessage());	
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * 业务处理类
	 * @param ele
	 */
	private void busiEleHandler(Element ele) {
		try {
			String key = (String)ele.getObjectKey();
			Object obj = ele.getObjectValue();
			//访问控制
			if(null != key && "accessLogs".equals(key)){
				AccessLogs acclog = (AccessLogs)obj;
				/*
				logger.info("busiEleHandler acclog => " + acclog.getId());
				accessLogsService.addObj(acclog);*/
				new WriteLogThread(accessLogsService,acclog).start();
			}
		} catch (Exception e) {
			logger.info("busiEleHandler exception => " + e.getMessage());	
			e.printStackTrace();
		}
	}
   
}
