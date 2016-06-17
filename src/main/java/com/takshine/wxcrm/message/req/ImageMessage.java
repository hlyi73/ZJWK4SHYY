package com.takshine.wxcrm.message.req;

import com.takshine.wxcrm.base.message.req.BaseMessage;

/** 
 * 图片消息 
 *  
 * @author liulin 
 * @date 2014-02-26 
 */  
public class ImageMessage extends BaseMessage {  
    // 图片链接   
    private String PicUrl;  
  
    public String getPicUrl() {  
        return PicUrl;  
    }  
  
    public void setPicUrl(String picUrl) {  
        PicUrl = picUrl;  
    }  
}
