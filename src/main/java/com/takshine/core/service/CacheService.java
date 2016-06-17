package com.takshine.core.service;



/**
 * Cache
 * @author Yihailong
 *
 */
public interface CacheService{
	public Object get(String group,String key);
	public void set(String group,String key,Object value);
	public void remove(String group,String key);
	public void clear(String group);
}
