package com.takshine.core.service.impl;

import java.util.Map;

import org.springframework.stereotype.Service;

import com.takshine.core.service.CacheService;

@Service("cacheService")
public class CacheServiceImpl implements CacheService {
	public static final Map<String,Map<String,Object>> objectCache  = new java.util.concurrent.ConcurrentHashMap<String,Map<String,Object>>();

	public Object get(String group,String key) {
		Map<String,Object> map = objectCache.get(group);
		if (map==null){
			return null;
		}
		return map.get(key);
	}

	public void set(String group,String key, Object value) {
		Map<String,Object> map = objectCache.get(group);
		if (map==null){
			map = new java.util.concurrent.ConcurrentHashMap<String,Object>();
		}
		map.put(key, value);
		objectCache.put(group, map);
	}

	public void remove(String group,String key) {
		Map<String,Object> map = objectCache.get(group);
		if (map!=null){
			map.remove(key);
			objectCache.put(group, map);
		}
	}

	public void clear(String group) {
		objectCache.remove(group);
	}

}
