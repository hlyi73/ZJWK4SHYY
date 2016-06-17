package com.takshine.wxcrm.base.common;

public class ErrCode {
	//ERROR 返回编码
	public static final String ERR_CODE_0 = "0";//编码
	public static final String ERR_MSG_SUCC = "操作成功";//msg
	
	public static final String ERR_CODE__1 = "1";//编码
	public static final String ERR_MSG_FAIL = "操作失败";//msg
	
	public static final String ERR_CODE_1 = "-1";//编码
	public static final String ERR_MSG_1 = "您没有任何操作权限";//msg
	
	public static final String ERR_CODE_1001001 = "1001001";//错误编码 : 账号未绑定 
	public static final String ERR_MSG_UNBIND = "账号未绑定";//msg
	
	public static final String ERR_CODE_1001002 = "1001002";//错误编码 : type为空
	public static final String ERR_MSG_TYPEISNULL = "type为空";//msg
	
	public static final String ERR_CODE_1001007 = "1001007";
	public static final String ERR_MSG_1001007 = "没有找到数据，或已被管理员删除！"; 
	
	public static final String ERR_CODE_1001003 = "1001003";//错误编码 : 查询数据为空
	public static final String ERR_MSG_ARRISEMPTY = "查询数据为空";//msg
	
	public static final String ERR_CODE_1001004 = "100007";//错误编码 : 没有找到数据
	public static final String ERR_MSG_SEARCHEMPTY = "没有找到数据";//msg
	
	public static final String ERR_CODE_1001005_001 = "100005_001";//错误编码 : 请您购买 LICENSES
	public static final String ERR_MSG_LICENSES_NON = "请您购买 LICENSES ";//msg
	
	public static final String ERR_CODE_1001005_002 = "100005_002";//错误编码 : LICENSES 非法
	public static final String ERR_MSG_LICENSES_ILLEGAL = "LICENSES 非法 ";//msg
	
	public static final String ERR_CODE_1001006 = "1001006";//错误编码 : 调用接口失败
	public static final String ERR_CODE_1001006_MSG = "调用接口失败 ";//msg
	
	public static final String ERR_CODE_1001008 = "1001008";//用户id不能为空
	public static final String ERR_CODE_1001008_MSG = "用户id不能为空 ";
	
	public static final String ERR_CODE_999999 = "999999 ";
	public static final String ERR_CODE_999999_MSG = "该链接访问已失效！ ";
	
	public static final String ERR_CODE_999988 = "999988 ";
	public static final String ERR_CODE_999988_MSG = "无法访问！ ";
	
	public static final String ERR_CODE_SESSION_INVALID = "session_invalid"; //Session失效
	public static final String ERR_CODE_SESSION_INVALID_MSG = "会话失效"; //Session失效
	
	public static final String ERR_CODE_AUTH_INVALID = "auth_invalid"; //没有权限访问
	
	public static final String ERR_CODE_1001001_MSG = "请求参数不合法";//错误编码 : 
	public static final String ERR_CODE_1001002_MSG = "没有找到您要的信息";//错误编码 : 
	
	public static final String ERR_CODE_100007 = "100007";  //后台CRM返回的错误编码
	public static final String ERR_CODE_100007_MSG = "没有找到数据或没有权限查看！";  //后台CRM返回的错误
	
	public static final String ERR_CODE_100007001 = "100007001";  //后台CRM返回的错误编码
	public static final String ERR_CODE_100007001_MSG = "没有下一篇文章了！";  //后台CRM返回的错误
	
	public static final String ERR_CODE_UNKNOWN = "-200";//编码
	public static final String ERR_MSG_UNKNOWN = "不知道的错误";//msg
	
	public static final String ERR_CODE_100008 = "100008";//编码
	public static final String ERR_CODE_100008_MSG = "数据重复";//msg

}
