package com.takshine.wxcrm.message.resp;

import com.takshine.wxcrm.base.message.resp.BaseMessage;

/** 
 * 音乐消息 
 *  
 * @author liulin 
 * @date 2014-02-26 
 */  
public class MusicMessage extends BaseMessage {  
    // 音乐   
    private Music Music;  
  
    public Music getMusic() {  
        return Music;  
    }  
  
    public void setMusic(Music music) {  
        Music = music;  
    }  
} 
