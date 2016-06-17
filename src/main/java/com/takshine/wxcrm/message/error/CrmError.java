package com.takshine.wxcrm.message.error;

import com.takshine.wxcrm.base.error.BaseError;

/**
 * crm返回的错误信息
 * @author liulin
 *
 */
public class CrmError extends BaseError {
	
	private String rowId = null;
	private String rowCount = null;//行数字

	public String getRowId() {
		return rowId;
	}

	public void setRowId(String rowId) {
		this.rowId = rowId;
	}

	public String getRowCount() {
		return rowCount;
	}

	public void setRowCount(String rowCount) {
		this.rowCount = rowCount;
	}
	
	
	
}
