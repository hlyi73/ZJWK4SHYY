package com.takshine.wxcrm.domain;

import java.util.Date;

import com.takshine.wxcrm.model.RssNewsModel;

/**
 * 封装百度新闻订阅的实体类
 * @author dengbo
 *
 */
public class RssNews extends RssNewsModel{

	private String title;//标题
	private String link;//链接
	private String desc;//简介
	private String pubdate;//发布时间
	private String author;//作者
	private String imgurl;//图片地址
	
	//表中的字段
	private String content;//订阅的关键字内容
	private String url;//订阅的rss地址
	private String type;//订阅类型
	
	private Integer currpages = 1;
	private Integer pagecounts = 10;
	
	public Integer getCurrpages() {
		return currpages;
	}
	public void setCurrpages(Integer currpages) {
		this.currpages = currpages;
	}
	public Integer getPagecounts() {
		return pagecounts;
	}
	public void setPagecounts(Integer pagecounts) {
		this.pagecounts = pagecounts;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getLink() {
		return link;
	}
	public void setLink(String link) {
		this.link = link;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getPubdate() {
		return pubdate;
	}
	public void setPubdate(String pubdate) {
		this.pubdate = pubdate;
	}
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getImgurl() {
		return imgurl;
	}
	public void setImgurl(String imgurl) {
		this.imgurl = imgurl;
	}
	
}
