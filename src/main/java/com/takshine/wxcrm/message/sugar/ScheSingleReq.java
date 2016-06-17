package com.takshine.wxcrm.message.sugar;

/**
 * 查询当个日程的参数 
 * @author liulin 
 *
 */
public class ScheSingleReq extends BaseCrm{
	
	private String rowid ;//日程rowid
	private String flag;//标志位
	private String schetype; //任务类型
	
	
	public String getSchetype() {
		return schetype;
	}

	public void setSchetype(String schetype) {
		this.schetype = schetype;
	}

	public String getRowid() {
		return rowid;
	}

	public void setRowid(String rowid) {
		this.rowid = rowid;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

}
