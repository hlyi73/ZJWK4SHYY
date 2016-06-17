package com.takshine.wxcrm.message.custresp;

import com.takshine.wxcrm.base.message.resp.CustBaseMessage;

public class CustMusicMessage extends CustBaseMessage {
	
	private CustMedia music;

	public CustMedia getMusic() {
		return music;
	}

	public void setMusic(CustMedia music) {
		this.music = music;
	}
	
}
