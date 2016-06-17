package com.takshine.wxcrm.message.req;

import com.takshine.wxcrm.base.message.req.BaseMessage;

/** 
 * 音频消息 
 *  
 * @author liulin 
 * @date 2014-02-26 
 */  
public class VoiceMessage extends BaseMessage {  
    // 媒体ID   
    private String MediaId;  
    // 语音格式   
    private String Format;  
  
    public String getMediaId() {  
        return MediaId;  
    }  
  
    public void setMediaId(String mediaId) {  
        MediaId = mediaId;  
    }  
  
    public String getFormat() {  
        return Format;  
    }  
  
    public void setFormat(String format) {  
        Format = format;  
    }  
}  

