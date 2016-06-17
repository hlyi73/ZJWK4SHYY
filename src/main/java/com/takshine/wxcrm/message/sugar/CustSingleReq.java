package com.takshine.wxcrm.message.sugar;

/**
 * 查询当个客户的参数 
 * @author liulin 
 *
 */
public class CustSingleReq extends BaseCrm{
	
	private String rowid ;//日程rowid

	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
	}

}
