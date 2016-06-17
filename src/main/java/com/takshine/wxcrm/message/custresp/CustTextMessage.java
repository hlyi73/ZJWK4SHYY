package com.takshine.wxcrm.message.custresp;

import com.takshine.wxcrm.base.message.resp.CustBaseMessage;

public class CustTextMessage extends CustBaseMessage {
	private CustText text;

	public CustText getText() {
		return text;
	}

	public void setText(CustText text) {
		this.text = text;
	}
	
	
}
