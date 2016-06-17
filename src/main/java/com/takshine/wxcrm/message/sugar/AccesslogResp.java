package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;

/**
 * 查询用户行为统计接口 从crm响应回来的参数
 * 
 * @author huangpeng
 *
 */
public class AccesslogResp extends BaseCrm {
	private String currpage = "1";//当前页
	private String pagecount = "5";//每页的条数
	private List<AccesslogAdd> accesslog = new ArrayList<AccesslogAdd>();

	

	public String getCurrpage() {
		return currpage;
	}

	public void setCurrpage(String currpage) {
		this.currpage = currpage;
	}

	public String getPagecount() {
		return pagecount;
	}

	public void setPagecount(String pagecount) {
		this.pagecount = pagecount;
	}

	public List<AccesslogAdd> getAccesslog() {
		return accesslog;
	}

	public void setAccesslog(List<AccesslogAdd> accesslog) {
		this.accesslog = accesslog;
	}

	

}
