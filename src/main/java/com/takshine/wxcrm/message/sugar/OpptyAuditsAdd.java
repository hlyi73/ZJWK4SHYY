package com.takshine.wxcrm.message.sugar;


/**
 * 审批
 * @author 刘淋
 *
 */
public class OpptyAuditsAdd extends BaseCrm{
	
	//审批字段
	private String oppid = null;
	private String opdate = null ; //操作时间
	private String opname = null ; //操作人 
	private String opid = null; //操作人id
	private String optype = null ; //类型
	private String beforevalue = null ; //操作前的值
	private String aftervalue = null ; //操作后的值
	private String parentid = null; //业务机会跟进历史关联ID，可能是任务ID，可能是联系人ID
	private String parenttype = null; //关联类型
	
	public String getOpdate() {
		return opdate;
	}
	public void setOpdate(String opdate) {
		this.opdate = opdate;
	}
	public String getOpname() {
		return opname;
	}
	public void setOpname(String opname) {
		this.opname = opname;
	}

	public String getOptype() {
		return optype;
	}
	public void setOptype(String optype) {
		this.optype = optype;
	}
	public String getBeforevalue() {
		return beforevalue;
	}
	public void setBeforevalue(String beforevalue) {
		this.beforevalue = beforevalue;
	}
	public String getAftervalue() {
		return aftervalue;
	}
	public void setAftervalue(String aftervalue) {
		this.aftervalue = aftervalue;
	}
	public String getOppid() {
		return oppid;
	}
	public void setOppid(String oppid) {
		this.oppid = oppid;
	}
	public String getOpid() {
		return opid;
	}
	public void setOpid(String opid) {
		this.opid = opid;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public String getParenttype() {
		return parenttype;
	}
	public void setParenttype(String parenttype) {
		this.parenttype = parenttype;
	}
}
