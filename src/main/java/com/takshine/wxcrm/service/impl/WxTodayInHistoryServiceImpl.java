package com.takshine.wxcrm.service.impl;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.takshine.wxcrm.base.util.WxUtil;
import com.takshine.wxcrm.service.WxTodayInHistoryService;

/** 
 * 封装历史上的今天查询方法，供外部调用 
 * @author liulin 
 *  
 */
@Service("wxTodayInHistoryService")
public class WxTodayInHistoryServiceImpl implements WxTodayInHistoryService{
	
	private static Logger log = Logger.getLogger(WxTodayInHistoryServiceImpl.class.getName());
  
    /** 
     * 从html中抽取出历史上的今天信息 
     *  
     * @param html 
     * @return 
     */  
    private  String extract(String html) {  
        StringBuffer buffer = null;  
        // 日期标签：区分是昨天还是今天  
        String dateTag = getMonthDay(0);  
  
        //抽取数据的正则表达式
        Pattern p = Pattern.compile("(.*)(<div class=\"listren\">)(.*?)(</div>)(.*)");  
        Matcher m = p.matcher(html);  
        if (m.matches()) {  
            buffer = new StringBuffer();  
            if (m.group(3).contains(getMonthDay(-1)))  
                dateTag = getMonthDay(-1);  
  
            // 拼装标题  
            buffer.append("≡≡ ").append("历史上的").append(dateTag).append(" ≡≡").append("\n\n");  
  
            // 抽取需要的数据  
            for (String info : m.group(3).split("  ")) {  
                info = info.replace(dateTag, "").replace("（图）", "").replaceAll("</?[^>]+>", "").trim();  
                // 在每行末尾追加2个换行符  
                if (!"".equals(info)) {  
                    buffer.append(info).append("\n\n");  
                }  
            }  
        }  
        // 将buffer最后两个换行符移除并返回  
        return (null == buffer) ? null : buffer.substring(0, buffer.lastIndexOf("\n\n"));  
    }  
  
    /** 
     * 获取前/后n天日期(M月d日) 
     *  
     * @return 
     */  
    private  String getMonthDay(int diff) {  
        DateFormat df = new SimpleDateFormat("M月d日");  
        Calendar c = Calendar.getInstance();  
        c.add(Calendar.DAY_OF_YEAR, diff);  
        return df.format(c.getTime());  
    }  
  
    /** 
     * 封装历史上的今天查询方法，供外部调用 
     *  
     * @return 
     */  
    public String getTodayInHistoryInfo() {  
        // 获取网页源代码  
        String html = WxUtil.httpRequest("http://www.rijiben.com/");  
        log.info("getTodayInHistoryInfo html =: > " + html);
        // 从网页中抽取信息  
        String result = extract(html);  
        log.info("getTodayInHistoryInfo result =: > " + result);
        
        return result;  
    }

}
