
package com.takshine.wxcrm.domain;

import java.io.Serializable;

import com.takshine.wxcrm.base.model.BaseModel;


/**
 * 登录用户 所拥有的功能菜单
 * @author liulin
 *
 */
public class UserFunc  extends BaseModel implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String opId = null;
	private String crmId = null;
	private String opName = null;
	private String entId = null;
	private String roleId = null;
	private String funId = null;
	private String funName = null;
	private String funLevel = null;
	private String funParentId = null;
	private String funIdx = null;
	private String funMem = null;
	private String funModel = null;
	private String funUri = null;
	private String funImg = null;
	
	public String getOpId() {
		return opId;
	}
	public void setOpId(String opId) {
		this.opId = opId;
	}
	public String getCrmId() {
		return crmId;
	}
	public void setCrmId(String crmId) {
		this.crmId = crmId;
	}
	public String getOpName() {
		return opName;
	}
	public void setOpName(String opName) {
		this.opName = opName;
	}
	public String getEntId() {
		return entId;
	}
	public void setEntId(String entId) {
		this.entId = entId;
	}
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public String getFunId() {
		return funId;
	}
	public void setFunId(String funId) {
		this.funId = funId;
	}
	public String getFunName() {
		return funName;
	}
	public void setFunName(String funName) {
		this.funName = funName;
	}
	public String getFunLevel() {
		return funLevel;
	}
	public void setFunLevel(String funLevel) {
		this.funLevel = funLevel;
	}
	public String getFunParentId() {
		return funParentId;
	}
	public void setFunParentId(String funParentId) {
		this.funParentId = funParentId;
	}
	public String getFunIdx() {
		return funIdx;
	}
	public void setFunIdx(String funIdx) {
		this.funIdx = funIdx;
	}
	public String getFunMem() {
		return funMem;
	}
	public void setFunMem(String funMem) {
		this.funMem = funMem;
	}
	public String getFunUri() {
		return funUri;
	}
	public void setFunUri(String funUri) {
		this.funUri = funUri;
	}
	public String getFunImg() {
		return funImg;
	}
	public void setFunImg(String funImg) {
		this.funImg = funImg;
	}
	public String getFunModel() {
		return funModel;
	}
	public void setFunModel(String funModel) {
		this.funModel = funModel;
	}
	
}
