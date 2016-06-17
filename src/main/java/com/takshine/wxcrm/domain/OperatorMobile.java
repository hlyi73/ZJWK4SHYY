
package com.takshine.wxcrm.domain;

import java.io.Serializable;

import com.takshine.wxcrm.model.OperatorMobileModel;

/**
 * 用户手机绑定关系 DTO对象
 * @author liulin
 *
 */
public class OperatorMobile extends OperatorMobileModel implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String crmAccount =null;
	private String crmPass = null;
	
	public String getCrmAccount() {
		return crmAccount;
	}
	public void setCrmAccount(String crmAccount) {
		this.crmAccount = crmAccount;
	}
	public String getCrmPass() {
		return crmPass;
	}
	public void setCrmPass(String crmPass) {
		this.crmPass = crmPass;
	}
	
}
