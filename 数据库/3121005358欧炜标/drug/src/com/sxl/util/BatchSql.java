package com.sxl.util;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class BatchSql {
	@SuppressWarnings("rawtypes")
	private List sqlList = new ArrayList();

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void addBatch(String sql, Object[] objects) {
		Map map = new HashMap();
		map.put("sql", sql);
		map.put("objects", objects);
		sqlList.add(map);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void addBatch(String sql) {
		Map map = new HashMap();
		map.put("sql", sql);
		map.put("objects", new Object[] {});
		sqlList.add(map);
	}

	@SuppressWarnings("rawtypes")
	public List getSqlList() {
		return sqlList;
	}
	
	@SuppressWarnings("rawtypes")
	public void clear() {
		sqlList = new ArrayList();
	}
}
