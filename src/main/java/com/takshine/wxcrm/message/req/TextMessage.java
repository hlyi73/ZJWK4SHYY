package com.takshine.wxcrm.message.req;

import com.takshine.wxcrm.base.message.req.BaseMessage;

/** 
 * 文本消息 
 *  
 * @author liulin 
 * @date 2014-02-26 
 */  
public class TextMessage extends BaseMessage {  
    // 消息内容   
    private String Content;  
  
    public String getContent() {  
        return Content;  
    }  
  
    public void setContent(String content) {  
        Content = content;  
    }  
}  

