package com.takshine.wxcrm.message.custresp;

import com.takshine.wxcrm.base.message.resp.CustBaseMessage;

public class CustVoiceMessage extends CustBaseMessage {
	
	private CustMedia voice;

	public CustMedia getVoice() {
		return voice;
	}

	public void setVoice(CustMedia voice) {
		this.voice = voice;
	}
	
}
