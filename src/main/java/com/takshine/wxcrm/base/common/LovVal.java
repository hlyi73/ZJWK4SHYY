package com.takshine.wxcrm.base.common;

public class LovVal {
	public static final String PROJECT_NAME = "指尖微客";
	
	public static final String SPM_CODE_CARD_EXCHANGE = "1.1.1.1";//名片交换申请
	public static final String SPM_CODE_GROUP_JOIN = "1.1.2.1";//群加入申请
	
	public static final String MESSAGE_RELA_MODEL_USER = "System_Uroup";//名片
	public static final String MESSAGE_RELA_MODEL_GROUP = "System_Group";//组
	
	//消息类型   入群申请 group_apply 入群驳回 group_reject 交换名片申请 exchange_apply 交换名片驳回 exchange_reject
	public static final String MESSAGE_TYPE_GROUP_NOTICE = "group_notice";//入群通知
	public static final String MESSAGE_TYPE_GROUP_APPLY = "group_apply";//入群申请
	public static final String MESSAGE_TYPE_GROUP_CHANGE = "group_change";//群改变
	public static final String MESSAGE_TYPE_GROUP_AGREE= "group_agree";//交换名片同意
	public static final String MESSAGE_TYPE_GROUP_DISMISS= "group_dismiss";//解散群
	public static final String MESSAGE_TYPE_GROUP_REJECT = "group_reject";//入群驳回
	public static final String MESSAGE_TYPE_EXCHANGE_APPLY = "exchange_apply";//交换名片申请
	public static final String MESSAGE_TYPE_EXCHANGE_AGREE = "exchange_agree";//交换名片同意
	public static final String MESSAGE_TYPE_EXCHANGE_REJECT = "exchange_reject";//交换名片驳回
	
	//消息狀態標誌  未读 not_read (默认状态  )已处理 already_handle  已读:already_read（级别比较低）
	public static final String MESSAGE_STATUS_ALREADY_HANDLE = "already_handle";//已处理
	public static final String MESSAGE_STATUS_ALREADY_READ = "already_read";//已读
	public static final String MESSAGE_STATUS_NOT_READ = "not_read";//未读 
	
	//履历类型
	public static final String USER_EXPERIENCE_TYPE_EDUCATION = "education";//教育经历:education    
	public static final String USER_EXPERIENCE_TYPE_PROJECT = "project";// 项目经历: project   
	public static final String USER_EXPERIENCE_TYPE_TRAIN = "train";//培训经历：train   
	public static final String USER_EXPERIENCE_TYPE_WORK = "work";//工作经历：work,   

	//用户与用户的关联关系
	public static final String USER_RELATION_TYPE_BACKLIST = "backlist";//黑名单：backlist  
	public static final String USER_RELATION_TYPE_WHITELIST = "whitelist";//白名单：whitelist   
	
	//群状态
	public static final String GROUP_STATUS_ACTIVE = "active";//激活:active
	public static final String GROUP_STATUS_CLOSE = "close";//关闭:close

	//群等级
	public static final String GROUP_LEVEL_COMMOM = "commom";//普通群:commom 
	public static final String GROUP_LEVEL_VIP = "vip";//高级群:vip

	//群类型
	public static final String GROUP_TYPE_VIP = "open";//公开群：open  
	public static final String GROUP_TYPE_AUTHENTICATION = "authentication";//认证：authentication
	
	//群验证类型
	public static final String GROUP_VERIFY_TYPE_ANYBODY = "anybody";//允许任何人: anybody
	public static final String GROUP_VERIFY_TYPE_NONE= "none";//不允许任何人 :none
	public static final String GROUP_VERIFY_TYPE_OWNER_VERIFY = "owner_verify";//需要群主管理验证 : owner_verify
	public static final String GROUP_VERIFY_TYPE_QUESTION_VERIFY = "question_verify";//问题验证：question_verify

	//群认证
	public static final String GROUP_CERTIFICATE_YES = "yes";//已认证 : yes 
	public static final String GROUP_CERTIFICATE_NO = "no";//未认证: no
	
	//模块标签类型
	public static final String MODEL_TAG_TYPE_INDUSTRY_CRM = "industry_crm";//crm 行业标签
	public static final String MODEL_TAG_TYPE_COMMON = "common";//普通标签：common
	
	//群通讯录 群成员类型
	public static final String GROUP_USER_TYPE_OWNER = "owner";//群主
	public static final String GROUP_USER_TYPE_ADMIN = "admin";//管理员
	public static final String GROUP_USER_TYPE_COMMON = "common";// 普通
	public static final String GROUP_USER_TYPE_TEMP = "temp";// 未审核,临时

	//群通讯录 群成员状态
	public static final String GROUP_USER_STATUS_NORMAL = "normal";// 正常 : normal  
	public static final String GROUP_USER_STATUS_DELETE = "delete";// 删除：delete
	
	//性别
	public static final String ACCOUNT_SEX_MAN = "0";//男
	public static final String ACCOUNT_SEX_FEMAN = "1";//女
	
	//威客同步标志 
	public static final String WK_SYNCFLAG_ALEADY = "1";//已同步
	public static final String WK_SYNCFLAG_NOT = "0";
	
	//是否 boolean值的数据表示
	public static final String BOOLEAN_TURE ="0";
	public static final String BOOLEAN_FLASE ="1";
	
	//redis 缓存的key
	public static final String REDIS_KEY_RM_PARTY_USER ="S_PARTY_USER_";
	
	public static final String PRINT_OPERATIVE_TYPE_VISIT="VISIT";
	public static final String PRINT_OPERATIVE_TYPE_PRAISE="PRAISE";
	public static final String PRINT_OBJECT_TYPE_PERSONAL_HOMEPAGE="PERSONAL_HOMEPAGE";
	public static final String PRINT_OBJECT_TYPE_TAG="TAG";

}
