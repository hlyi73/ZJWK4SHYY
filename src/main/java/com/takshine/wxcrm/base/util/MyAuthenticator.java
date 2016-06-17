package com.takshine.wxcrm.base.util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

/**
 * 验证发件人信息
 * @author dengbo
 *
 */
public class MyAuthenticator extends Authenticator {  
	//用户名
    private String username;  
    //密码
    private String password;  
  
    public MyAuthenticator(String username, String password) {  
        super();  
        this.username = username;  
        this.password = password;  
    }  
  
    protected PasswordAuthentication getPasswordAuthentication() {  
        return new PasswordAuthentication(username, password);  
    }  
}  
