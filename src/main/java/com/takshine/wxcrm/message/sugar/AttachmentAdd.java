package com.takshine.wxcrm.message.sugar;


/**
 * 附件 模型
 * @author liulin
 *
 */
public class AttachmentAdd extends BaseCrm{
	/**
	 * 调用sugar接口传递的参数
	 */
	private String filename;//附件名字
	private String url;//附件url
	private String filetype;//附件类型
	private String filesize;//附件大小
	private String parentid ;//附件相关ID
	private String parenttype ;//附件相关类型
	private String mimetype; //Mime type
	
	
	public String getMimetype() {
		return mimetype;
	}
	public void setMimetype(String mimetype) {
		this.mimetype = mimetype;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getFiletype() {
		return filetype;
	}
	public void setFiletype(String filetype) {
		this.filetype = filetype;
	}
	public String getFilesize() {
		return filesize;
	}
	public void setFilesize(String filesize) {
		this.filesize = filesize;
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
