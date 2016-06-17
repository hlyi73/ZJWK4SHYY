package com.takshine.wxcrm.message.req;

import com.takshine.wxcrm.base.message.req.BaseMessage;

/** 
 * 链接消息 
 *  
 * @author liulin 
 * @date 2014-02-26 
 */  
public class LinkMessage extends BaseMessage {  
    // 消息标题   
    private String Title;  
    // 消息描述   
    private String Description;  
    // 消息链接   
    private String Url;  
  
    public String getTitle() {  
        return Title;  
    }  
  
    public void setTitle(String title) {  
        Title = title;  
    }  
  
    public String getDescription() {  
        return Description;  
    }  
  
    public void setDescription(String description) {  
        Description = description;  
    }  
  
    public String getUrl() {  
        return Url;  
    }  
  
    public void setUrl(String url) {  
        Url = url;  
    }  
} 
