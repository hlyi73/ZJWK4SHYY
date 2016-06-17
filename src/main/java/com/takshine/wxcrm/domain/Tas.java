package com.takshine.wxcrm.domain;

import com.takshine.wxcrm.model.TasModel;

/**
 * 销售方法论
 * @author 刘淋
 *
 */
public class Tas extends TasModel{
	
	private String opptyId  = null;//业务机会ID
	private String tasType = null;//销售方法论类别 value:价值主张 , event: 强制性事件 , strategy 
	private String key = null;//问题
	private String vids = null;//id
	private String vflags = null;//标记
	private String values = null;//值
	
	public String getOpptyId() {
		return opptyId;
	}
	public void setOpptyId(String opptyId) {
		this.opptyId = opptyId;
	}
	public String getTasType() {
		return tasType;
	}
	public void setTasType(String tasType) {
		this.tasType = tasType;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getValues() {
		return values;
	}
	public void setValues(String values) {
		this.values = values;
	}
	public String getVids() {
		return vids;
	}
	public void setVids(String vids) {
		this.vids = vids;
	}
	public String getVflags() {
		return vflags;
	}
	public void setVflags(String vflags) {
		this.vflags = vflags;
	}
	
}
