package com.takshine.wxcrm.connet;

import java.net.URLEncoder;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.takshine.wxcrm.base.common.Constants;
import com.takshine.wxcrm.base.util.WxHttpConUtil;
import com.takshine.wxcrm.message.sugar.ScheduleAdd;

public class SugarHttpConnetServiceTest {
	//log
	private static Logger logger = Logger.getLogger(SugarHttpConnetServiceTest.class.getName());
	// http  服务
	@Autowired
	@Qualifier("wxHttpConUtil")
	private WxHttpConUtil util;

	@Test
	public void getRCinfoByXml(){
		/*logger.info("getRCinfo start");
		//request content 请求内容
		String xmlStr = "<xml>";
		xmlStr += "<ToUserName><![CDATA[gh_8ee68d0bc875]]></ToUserName>";
		xmlStr += "<FromUserName><![CDATA[ocLV5t9HKRj3dIZKZobBzctvVJwU]]></FromUserName>";
		xmlStr += "<CreateTime>1348831860</CreateTime>";
		xmlStr += "<MsgType><![CDATA[text]]></MsgType>";
		xmlStr += "<Content><![CDATA[this is a test]]></Content>";
		xmlStr += "<MsgId>1234567890123456</MsgId>";
		xmlStr += "</xml>";
		logger.info("getRCinfo　rst =>" + util.postXmlData(xmlStr, Constants.INVOKE_MULITY));
		logger.info("getRCinfo end");*/
	}
	
	/**
	 * 获取日程数据
	 */
	@Test
	public void getRCinfoByJson(){
		
	}
	
	@Test
	public void printCurrDate(){
		/*try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String startDate = sdf.format(DateTime.addTimeByDays(DateTime.currentDate(), -30));
			String endDate = sdf.format(DateTime.addTimeByDays(DateTime.currentDate(), 365));
			
			logger.info("searchTasks startDate=>"+ startDate);
			logger.info("searchTasks endDate=>"+ endDate);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
	}
	
	@Test
	public void addRCinfo() throws Exception {
		
		ScheduleAdd sa = new ScheduleAdd();
		sa.setCrmaccount("5da1ce9f-74b5-d233-c286-51c64d153d5a");
		sa.setModeltype(Constants.MODEL_TYPE_TASK);
		sa.setType(Constants.ACTION_ADD);
		sa.setTitle("标题");//标题
		sa.setStartdate("2014-03-21 23:46:40");//开始日期
		sa.setEnddate("2014-03-21 23:46:40");//结束日期
		sa.setStatus("Not Started");//状态
		sa.setDesc("描述");//描述
		sa.setDriority("Medium");//优先级
		sa.setAssigner("5da1ce9f-74b5-d233-c286-51c64d153d5a");//责任人 -> obj.getAssignerId()
		
		String jsonStr = JSONObject.fromObject(sa).toString();
		//单次调用sugar接口 
		//String rst = util.postJsonData(Constants.MODEL_URL_ENTRY, jsonStr, Constants.INVOKE_SINGLE);
		
		//System.out.println(rst);
	}
}
