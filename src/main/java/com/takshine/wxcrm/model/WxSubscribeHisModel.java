package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 微信关注历史
 * @author liulin
 *
 */
public class WxSubscribeHisModel extends BaseModel {
	
	private String open_id = null ; 
	private String nick_name = null ; 
    private String sub_type = null ; //关注：SUBSCRIBE 取消关注：UNSUBSCRIBE
    private String create_time = null ; //创建时间
    
	public String getOpen_id() {
		return open_id;
	}
	public void setOpen_id(String open_id) {
		this.open_id = open_id;
	}
	public String getNick_name() {
		return nick_name;
	}
	public void setNick_name(String nick_name) {
		this.nick_name = nick_name;
	}
	public String getSub_type() {
		return sub_type;
	}
	public void setSub_type(String sub_type) {
		this.sub_type = sub_type;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
}
