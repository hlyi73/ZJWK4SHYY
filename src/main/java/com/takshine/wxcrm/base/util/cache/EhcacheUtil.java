package com.takshine.wxcrm.base.util.cache;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import org.apache.log4j.Logger;

/**
 * 微信 缓存工具类
 * @author liulin
 *
 */
public class EhcacheUtil {
	private static Logger logger = Logger.getLogger(EhcacheUtil.class.getName());
	
	//缓存对象
	private static CacheManager cacheManager = null ;
	private static Cache wxCrmSerCache = null;
	
	static{
		cacheManager = CacheManager.getInstance();
		wxCrmSerCache = cacheManager.getCache("wxCrmSerCache");
		logger.info("init wxCrmSerCache succ=>");
	}
	
	/**
	 * 获取元素
	 * @param key
	 * @return
	 */
	public static Object get(String key){
		Element ele = wxCrmSerCache.get(key);
		if(ele != null) return ele.getObjectValue();
		else return null;
	}
	
	/**
	 * 存入数据到缓存
	 */
	public static void put(String key, Object obj){
		if(obj != null){
			Element element = new Element(key, obj);
			wxCrmSerCache.put(element);
		}
	}
	
	/**
	 * 移除元素
	 */
	public static void remove(String key){
		wxCrmSerCache.remove(key);
	}
}
