package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 消息
 * @author liulin
 *
 */
public class IntegralModel extends BaseModel{
	
	private Integer total = 0;
	private Integer totalPre = 0;
	
	public Integer getTotal() {
		return total;
	}
	public void setTotal(Integer total) {
		this.total = total;
	}
	public Integer getTotalPre() {
		return totalPre;
	}
	public void setTotalPre(Integer totalPre) {
		this.totalPre = totalPre;
	}
	
}
