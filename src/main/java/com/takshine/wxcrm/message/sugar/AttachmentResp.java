package com.takshine.wxcrm.message.sugar;

import java.util.ArrayList;
import java.util.List;


/**
 * 获取样品接口
 * @author dengbo
 *
 */
public class AttachmentResp extends BaseCrm{
	
	private String count;//总条数
	private List<AttachmentAdd> datas = new ArrayList<AttachmentAdd>();//样品列表
	
	public String getCount() {
		return null == count ? "0" : count;
	}
	public void setCount(String count) {
		this.count = count;
	}
	
	public List<AttachmentAdd> getDatas() {
		return datas;
	}
	public void setDatas(List<AttachmentAdd> datas) {
		this.datas = datas;
	}
}
