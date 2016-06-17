package com.takshine.wxcrm.base.filter;

import java.util.HashMap;
import java.util.Map;

public class QueryFilter {

	public QueryFilter() {
		startNum = 0;
		endNum = 0;
		orderByString = null;
	}

	private String baseOrganType;
	
	@SuppressWarnings("unused")
	private int startNum;
	@SuppressWarnings("unused")
	private int endNum;
	
	private String queryString;
	private String orderByString;
	private boolean exactMatch;
	private String id;
	
	private Map<String, String> like = new HashMap<String, String>();
	private Map<String, String> equal = new HashMap<String, String>();
	private Map<String, Object> inMap = new HashMap<String, Object>();
	private int page;//第几页
	private int rows;//每页多少行数
	private int pagesize = 1;

	public String getBaseOrganType() {
		return baseOrganType;
	}

	public void setBaseOrganType(String baseOrganType) {
		this.baseOrganType = baseOrganType;
	}

	public int getStartNum() {
		return (this.page - 1) * this.rows;
	}

	public void setStartNum(int startNum) {
		this.startNum = startNum;
	}

	public int getEndNum() {
		return getStartNum() + this.pagesize * this.rows;
	}

	public void setEndNum(int endNum) {
		this.endNum = endNum;
	}

	public String getQueryString() {
		return queryString;
	}

	public void setQueryString(String queryString) {
		this.queryString = queryString;
	}

	public String getOrderByString() {
		return orderByString;
	}

	public void setOrderByString(String orderByString) {
		this.orderByString = orderByString;
	}

	public boolean isExactMatch() {
		return exactMatch;
	}

	public void setExactMatch(boolean exactMatch) {
		this.exactMatch = exactMatch;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Map<String, String> getLike() {
		return like;
	}

	public void setLike(Map<String, String> like) {
		this.like = like;
	}

	public Map<String, String> getEqual() {
		return equal;
	}

	public void setEqual(Map<String, String> equal) {
		this.equal = equal;
	}

	public Map<String, Object> getInMap() {
		return inMap;
	}

	public void setInMap(Map<String, Object> inMap) {
		this.inMap = inMap;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getRows() {
		return rows;
	}

	public void setRows(int rows) {
		this.rows = rows;
	}

	public int getPagesize() {
		return pagesize;
	}

	public void setPagesize(int pagesize) {
		this.pagesize = pagesize;
	}
	
}
