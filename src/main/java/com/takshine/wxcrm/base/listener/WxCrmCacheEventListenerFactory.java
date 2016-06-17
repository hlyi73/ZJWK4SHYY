package com.takshine.wxcrm.base.listener;

import java.util.Properties;

import net.sf.ehcache.event.CacheEventListener;
import net.sf.ehcache.event.CacheEventListenerFactory;

public class WxCrmCacheEventListenerFactory extends CacheEventListenerFactory {  
  
	/**
	 * 创建缓存的时候被调用
	 */
    @Override  
    public CacheEventListener createCacheEventListener( final Properties properties) {  
        return WxAccessLogsCacheEventListener.INSTANCE;  
    }

}
