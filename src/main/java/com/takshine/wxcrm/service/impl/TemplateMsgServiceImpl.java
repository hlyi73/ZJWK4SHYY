package com.takshine.wxcrm.service.impl;

import java.util.Iterator;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.model.BaseModel;
import com.takshine.wxcrm.base.services.BaseServiceImpl;
import com.takshine.wxcrm.base.util.PropertiesUtil;
import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.message.tplmsg.ApproveTemp;
import com.takshine.wxcrm.message.tplmsg.ScheduleTemp;
import com.takshine.wxcrm.message.tplmsg.TemplateText;
import com.takshine.wxcrm.message.tplmsg.ToDoWorkTemp;
import com.takshine.wxcrm.message.tplmsg.ValColor;
import com.takshine.wxcrm.service.TemplateMsgService;

/**
 * 发送 模板消息服务
 * @author liulin
 *
 */
@Service("templateMsgService")
public class TemplateMsgServiceImpl extends BaseServiceImpl implements TemplateMsgService{

	 // 日志
	protected static Logger logger = Logger.getLogger(TemplateMsgServiceImpl.class.getName());
	
	@Override
	protected String getDomainName() {
		return "TemplateMsg";
	}
	
	/**
	 * 获取sql配置文件命名空间
	 * @return
	 */
	@Override
	protected String getNamespace(){
		return "templateMsgSql.";
	}
	
	public BaseModel initObj() {
		return null;
	}

	/**
	 * 发送日程任务模板消息 
	 */
	public JSONObject sendScheduleMsg(String openId, String topcolor, String url,
			Map<String, ValColor> map) {
		//日程模板
		ScheduleTemp st = new ScheduleTemp();
		//迭代map
		for (Iterator<String> iterator = map.keySet().iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			ValColor v = map.get(key);
			if(key.equals("first")){
				st.setFirst(v);//标题值
			}
			if(key.equals("schedule")){
				st.setSchedule(v);//事件值
			}
			if(key.equals("time")){
				st.setTime(v);//时间值
			}
			if(key.equals("remark")){
				st.setRemark(v);//备注值
			}
		}
		//模板消息
		TemplateText ct = new TemplateText();
		ct.setTouser(openId);//"on478tyhwR3fkCAOQpd6lT0rUjxc"
		ct.setTemplate_id(PropertiesUtil.getAppContext("tpl.msg.schedule.id"));//消息模板ID
		ct.setTopcolor(topcolor);//"#FF0000"
		ct.setUrl(url);//"http://www.takshine.com"
		ct.setData(st);
		//发送模板消息
		JSONObject jst = WxUtil.templateMsgSend(ct);
		//发送结果
		log.info(jst.getString("errcode"));
		log.info(jst.getString("errmsg"));
		log.info(jst.getString("msgid"));
		
		return jst;
		
	}
	
	/**
	 * 审批 模板消息 
	 */
	public JSONObject sendApproveMsg(String openId, String topcolor, String url,
			Map<String, ValColor> map) {
		//审批模板
		ApproveTemp st = new ApproveTemp();
		//迭代map
		for (Iterator<String> iterator = map.keySet().iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			ValColor v = map.get(key);
			if(key.equals("first")){
				st.setFirst(v);//标题值
			}
			if(key.equals("keyword1")){
				st.setKeyword1(v);//审批事项
			}
			if(key.equals("keyword2")){
				st.setKeyword2(v);//审批结果
			}
			if(key.equals("remark")){
				st.setRemark(v);//备注值
			}
		}
		//模板消息
		TemplateText ct = new TemplateText();
		ct.setTouser(openId);//openId
		ct.setTemplate_id(PropertiesUtil.getAppContext("tpl.msg.approve.id"));//审批结果消息模板ID
		ct.setTopcolor(topcolor);//"#FF0000"
		ct.setUrl(url);//"http://www.takshine.com"
		ct.setData(st);
		//发送模板消息
		JSONObject jst = WxUtil.templateMsgSend(ct);
		//发送结果
		log.info(jst.getString("errcode"));
		log.info(jst.getString("errmsg"));
		log.info(jst.getString("msgid"));
		
		return jst;
	}
	
	/**
	 * 待办任务 模板消息 
	 */
	public JSONObject sendToDoWorkMsg(String openId, String topcolor, String url,
			Map<String, ValColor> map) {
		//待办工作模板
		ToDoWorkTemp st = new ToDoWorkTemp();
		//迭代map
		for (Iterator<String> iterator = map.keySet().iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			ValColor v = map.get(key);
			if(key.equals("first")){
				st.setFirst(v);//标题值
			}
			if(key.equals("work")){
				st.setWork(v);//待办工作
			}
			if(key.equals("remark")){
				st.setRemark(v);//备注值
			}
		}
		//模板消息
		TemplateText ct = new TemplateText();
		ct.setTouser(openId);//openId
		ct.setTemplate_id(PropertiesUtil.getAppContext("tpl.msg.todowork.id"));//待办工作消息模板ID
		ct.setTopcolor(topcolor);//"#FF0000"
		ct.setUrl(url);//"http://www.takshine.com"
		ct.setData(st);
		//发送模板消息
		JSONObject jst = WxUtil.templateMsgSend(ct);
		//发送结果
		log.info(jst.getString("errcode"));
		log.info(jst.getString("errmsg"));
		log.info(jst.getString("msgid"));
				
		return jst;
	}
	
}
