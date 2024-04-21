package com.sxl.util;

import java.util.List;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class Ehcache {

	static CacheManager manager = CacheManager.create();

	/**
	 * create singleton,  according to ehcache.xml get relevant key
	 * @param key
	 * @return
	 */
	public static Cache getEhcache(String key) {
		Cache cache = manager.getCache(key);
		return cache;
	}

	/**
	 * put element to cache
	 * @param cache
	 * @param name
	 * @param command
	 */
	@SuppressWarnings("rawtypes")
	public static void addElementToCache(Cache cache, String name,
			List command) {
		Element element = new Element(name, command);
		cache.put(element);
	}

	/**
	 * remove cache by key
	 * @param key
	 */
	public static void delCache(String key) {
		manager.removeCache(key);
	}
	
}
