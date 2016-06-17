package com.takshine.wxcrm.base.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class Page {
	/**
	 * 总数
	 */
	private int size;
	/**
	 * 一页显示条数
	 */
	private int pageCount = 15;
	/**
	 * 当前页
	 */
	private int page = 1;
	/**
	 * 多少页
	 */
	private int pageSize;
	
	/**
	 * 每页的数据
	 */
    private Collection<?> data;

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getPageCount() {
		return pageCount;
	}

	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}

	public int getPageSize() {
		return pageSize;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
		this.pageSize = this.size / pageCount
				+ (this.size % pageCount == 0 ? 0 : 1);
		if (this.page > this.pageSize) {
			this.page = this.pageSize;
		}
	}

	public List getPagination() {
		int star = page - 3;
		int end = page + 3;
		if (star <= 1) {
			star = 1;
			end = 7;
			if (end > pageSize) {
				end = pageSize;
			}
		}
		if (end > pageSize) {
			end = pageSize;
			star = pageSize - 7;
			if (star <= 1) {
				star = 1;
			}
		}
		List pageList = new ArrayList();
		for (; star <= end; star++) {
			Page page1 = new Page();
			page1.setPage(star);
			pageList.add(page1);
		}
		return pageList;
	}

	public List getPageNumList() {
		List pageNumList = new ArrayList();
		if (((page + 3) <= pageSize) && (page - 3) >= 1 && pageSize != 7) {
			for (int i = (page - 3); i <= (page + 3); i++) {
				Page tempPage = new Page();
				tempPage.setPage(i);
				pageNumList.add(tempPage);
			}
		}
		if (pageSize <= 7) {
			for (int i = 1; i <= pageSize; i++) {
				Page tempPage = new Page();
				tempPage.setPage(i);
				pageNumList.add(tempPage);
			}
		}
		if (pageSize > 7 && (page + 3) > pageSize) {
			for (int i = (pageSize - 6); i <= pageSize; i++) {
				Page tempPage = new Page();
				tempPage.setPage(i);
				pageNumList.add(tempPage);
			}
		}
		if (pageSize > 7 && (page - 3) < 1) {
			for (int i = 1; i <= 7; i++) {
				Page tempPage = new Page();
				tempPage.setPage(i);
				pageNumList.add(tempPage);
			}
		}
		return pageNumList;
	}
	
	 public int getTotalPageCount()
	 {
	    if (this.size % this.pageSize == 0) {
	      return this.size / this.pageSize;
	    }
	    return this.size / this.pageSize + 1;
	 }

	 public Collection<?> getData() {
		return data;
	 }

	 public void setData(Collection<?> data) {
		this.data = data;
	 }

	 public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	 }
	 
}
