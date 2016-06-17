package com.takshine.marketing.domain;

import com.takshine.marketing.model.AttachmentModel;
/**
 * 
 * 下拉列表
 */
public class Attachment extends AttachmentModel {
	private String id;//主键
	private String file_name;//文件显示名称
	private String file_type;//文件类型，如img/doc/...
	private String file_size;//文件大小
	private String url;//地址或文件名称
	private String attachment_type; //附件类型，如活动图片、活动附件等
	private String file_rela_name;
	private String activity_id; 
	private String create_time;
	private String rela_id;  //附件与活动关系id
	
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public String getRela_id() {
		return rela_id;
	}
	public void setRela_id(String rela_id) {
		this.rela_id = rela_id;
	}
	public String getActivity_id() {
		return activity_id;
	}
	public void setActivity_id(String activity_id) {
		this.activity_id = activity_id;
	}
	public String getFile_rela_name() {
		return file_rela_name;
	}
	public void setFile_rela_name(String file_rela_name) {
		this.file_rela_name = file_rela_name;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getFile_name() {
		return file_name;
	}
	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}
	public String getFile_type() {
		return file_type;
	}
	public void setFile_type(String file_type) {
		this.file_type = file_type;
	}
	public String getFile_size() {
		return file_size;
	}
	public void setFile_size(String file_size) {
		this.file_size = file_size;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getAttachment_type() {
		return attachment_type;
	}
	public void setAttachment_type(String attachment_type) {
		this.attachment_type = attachment_type;
	}
	
	
}
