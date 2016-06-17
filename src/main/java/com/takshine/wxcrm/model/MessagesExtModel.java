package com.takshine.wxcrm.model;

import com.takshine.wxcrm.base.model.BaseModel;

/**
 * 消息
 * @author liulin
 *
 */
public class MessagesExtModel extends BaseModel{
	
	private String relaid;
	private String relatype;
	private String filename;
	private String source_filename;
	private String filetype;
	public String getRelaid() {
		return relaid;
	}
	public void setRelaid(String relaid) {
		this.relaid = relaid;
	}
	public String getRelatype() {
		return relatype;
	}
	public void setRelatype(String relatype) {
		this.relatype = relatype;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getSource_filename() {
		return source_filename;
	}
	public void setSource_filename(String source_filename) {
		this.source_filename = source_filename;
	}
	public String getFiletype() {
		return filetype;
	}
	public void setFiletype(String filetype) {
		this.filetype = filetype;
	}
	
}
