package com.takshine.wxcrm.base.common;

import com.takshine.wxcrm.base.util.PropertiesUtil;

public class Constants {

	public static final int WS_SUCCESS_CODE = 1;
	
	// 第三方用户唯一凭证
	//德成鸿业测试号："wx53707e024e8311e8"; 我自己的测试帐号：wx9b487088b37b15b1  【对应手机号:15810726455的测试号】
	public static final String APPID = PropertiesUtil.getAppContext("wxcrm.appid");
	
	// 第三方用户唯一凭证密钥
	//德成鸿业测试号："fd549c6e8b52d80515745bde649c831d"; 我自己的测试帐号：dccbca121cea1b841498b704afe2f611
	public static final String APPSECRET = PropertiesUtil.getAppContext("wxcrm.appsecret");
	
	//网页用户授权 回调URL
	public static final String REDIRECTURI = "http://115.28.27.20/TAKWxCrmSer/oauth2/response";
	
	//weibo appkey值
	public static final String CLIENTID = "";
	
	//weibo 网页用户授权 回调UR
	public static final String WBREDIRECTURI = "http://115.28.27.20/TAKWxCrmSer/oauth2/wbresp";
	
	/**
	 * 调用SUGAR 配置区域如下
	 */
	//调用次数是否 多次调用
	public static final String INVOKE_MULITY = "mulity";
	public static final String INVOKE_SINGLE = "single";
	
	//调用sugar的源头
	public static final String SYS_SOURCE = "takwxcrm";
	
	//任务状态
	public static final String TASKS_STATUS = "完成";
	
	//调用SUGAR接口 查询模块的类型
	public static final String MODEL_TYPE_TASK = "task";//模块类型为日程
	public static final String MODEL_TYPE_AUTH = "auth";//模块类型为账户绑定
	public static final String MODEL_TYPE_USER = "user";//模块类型为用户
	public static final String MODEL_TYPE_LOV = "lov";//模块类型为lov
	public static final String MODEL_TYPE_ACCNT = "accnt";//模块类型为客户
	public static final String MODEL_TYPE_OPPTY = "oppty";//模块类型为业务机会
	public static final String MODEL_TYPE_CONTACT = "contact";//模块类型为联系人
	public static final String MODEL_TYPE_PARTNER = "partner";//模块类型为合作伙伴
	public static final String MODEL_TYPE_COMPETITOR = "competitor";//模块类型为竞争对手
	public static final String MODEL_TYPE_EXPENSE = "expense";//模块类型为费用
	public static final String MODEL_TYPE_GATHERING="gathering";//模块类型为收款
	public static final String MODEL_TYPE_CONTRACT="contract";//模块类型为合同
	public static final String MODEL_TYPE_AUDIT="audit";//模块类型为审批
	public static final String MODEL_TYPE_COMMON = "common";//查询首字母列表
	public static final String MODEL_TYPE_PROJ = "project";//模块类型为项目
	public static final String MODEL_TYPE_CAMP = "campaigns";//模块类型为市场活动
	public static final String MODEL_TYPE_FEED = "feed";//模块类型为活动流
	public static final String MODEL_TYPE_NOTICE = "notice";//模块类型为所有的信息
	public static final String MODEL_TYPE_TAS = "tas";//模块类型为TAS销售方法论
	public static final String MODEL_TYPE_REPORT = "report";//模块类型为报告
	public static final String MODEI_TYPE_PRODUCT = "product";  //模块类型为产品
	public static final String MODEI_TYPE_PRODUCTTYPE = "productType";  //模块类型为产品类别
	public static final String MODEI_TYPE_VALIDATE = "validate";  //检查是否重名
	public static final String MODEL_TYPE_SHARE = "share";  //分享
	public static final String MODEL_TYPE_COMPLAINT = "case";  //服务请求和投诉
	public static final String MODEL_TYPE_CASEEXEC = "caseexec";  //服务执行
	public static final String MODEL_TYPE_CASEVISIT = "casevisit";  //服务回访
	public static final String MODEL_TYPE_WEEKREPORT = "weekreport";  //周报
	public static final String MODEL_TYPE_BUG="bug";//缺陷
	public static final String MODEL_TYPE_ATTACHMENT = "document";//模块类型为附件
	public static final String MODEL_TYPE_FOLLOW = "follow";//跟进
	public static final String MODEL_TYPE_EXEC= "caseexec";//执行casevisit caseexec
	public static final String MODEL_TYPE_VISIT = "casevisit";//回访 casevisit caseexec
	public static final String MODEL_TYPE_ACTIVITY = "activity";//活动
	public static final String MODEL_TYPE_ACCESSLOG = "accesslog";  //访问 
	public static final String MODEL_TYPE_QUOTE = "quote";  //报价
	public static final String MODEL_TYPE_REQUOTE = "requote";  //重新报价
	public static final String MODEL_TYPE_MXQUOTE = "mxquote";  //报价明细
	
	//------分析报表
	public static final String MODEL_TYPE_ANALYTICS = "analytics"; //分析
	//费用相关
	public static final String ANALYTICS_TOPIC_EXPENSE = "expense"; //费用统计主题 
	public static final String ANALYTICS_REPORT_EXPENSE_DEPART = "depart"; //按部门统计报表
	public static final String ANALYTICS_REPORT_EXPENSE_TYPE = "expenseType"; //按费用类型统计费用
	public static final String ANALYTICS_REPORT_EXPENSE_SUB_TYPE = "expenseSubType"; //按费用类型统计费用
	
	//业务机会相关
	public static final String ANALYTICS_TOPIC_OPPTY = "oppty"; //业务机会统计主题 
	public static final String ANALYTICS_REPORT_OPPTY_STAGE = "stage"; //按销售阶段统计业务机会报表
	public static final String ANALYTICS_REPORT_OPPTY_PIPELINE = "pipeline"; //按销售阶段统计业务机会报表
	public static final String ANALYTICS_REPORT_OPPTY_REASON = "reason"; //按失败原因统计业务机会报表
	public static final String ANALYTICS_REPORT_OPPTY_RESIDENCE = "residence"; //按停留时间统计业务机会报表
	public static final String ANALYTICS_REPORT_OPPTY_RATE = "rate";  //  商机成单率报表
	public static final String ANALYTICS_REPORT_OPPTY_RANK = "rank" ; //  商机成单排名
	public static final String ANALYTICS_REPORT_OPPTY_COUNT = "count";  // 商机成单数量
	public static final String ANALYTICS_REPORT_OPPTY_YEARCOMPARE = "yearcompare" ; //商机同比
	public static final String ANALYTICS_REPORT_OPPTY_MONTHCOMPARE = "monthcompare" ; //商机环比
	public static final String ANALYTICS_REPORT_OPPTY_FUNNEL= "funnel" ; //销售漏斗
	//客户相关
	public static final String ANALYTICS_REPORT_CUSTOMER_INDUSTRY = "industry"; //按客户行业分析报表
	public static final String ANALYTICS_REPORT_CUSTOMER_LEADS = "leads"; //按潜在客户时间分析报表
	public static final String ANALYTICS_TOPIC_CUSTOMER = "accnt"; //客户统计主题 
	public static final String ANALYTICS_TOPIC_CUSTOMER_CONTRIBUTION = "contribution";//按客户贡献分析报表
	public static final String ANALYTICS_TOPIC_CUSTOMER_DISTRIBUTE = "distribute";//按客户地理分布分析报表
	public static final String ANALYTICS_TOPIC_CUSTOMER_FUTUREOPPTY= "futureoppty";//按客户贡未来业务机会分析报表
	
	//联系人相关
	public static final String ANALYTICS_TOPIC_CONTACT = "contact"; //联系人统计主题 
	public static final String ANALYTICS_TOPIC_CONTACT_CONTRIBUTION = "contribution";//按客户贡献分析报表
	public static final String ANALYTICS_TOPIC_CONTACT_FUTUREOPPTY= "futureoppty";//按客户贡未来业务机会分析报表
	
	//相关回款
	public static final String ANALYTICS_TOPIC_RECEIVABLE = "receivable"; //回款统计主题 
	public static final String ANALYTICS_REPORT_RECEIVABLE_MONTH = "month"; //按月统计回款
	public static final String ANALYTICS_REPORT_RECEIVABLE_DEPART = "depart"; //按部门统计回款
	public static final String ANALYTICS_REPORT_RECEIVABLE_CUSTOMER = "customer"; //按客户统计回款
	public static final String ANALYTICS_REPORT_RECEIVABLE_UNUSUAL = "unusual"; //异常回款
	
	//服务请求分析
	public static final String ANALYTICS_TOPIC_CASE= "case"; //服务请求/投诉统计主题 
	public static final String ANALYTICS_REPORT_SR_TYPE = "sr_type"; //按类型统计服务请求
	public static final String ANALYTICS_REPORT_SR_MONTH = "sr_month"; //按月统计服务请求
	public static final String ANALYTICS_REPORT_SR_DEPART = "sr_depart"; //服务请求-部门
	
	//销售目标分析
	public static final String ANALYTICS_TOPIC_QUOTA = "quota"; //销售目标统计主题 
	public static final String ANALYTICS_REPORT_QUOTA_MONTH = "month"; //按月统计销售
	public static final String ANALYTICS_REPORT_QUOTA_QUARTER = "quarter"; //按季度统计销售
	
	//产品报价分析
	public  static final String ANALYTICS_TOPIC_QUOTE="quote";//产品报价分析
	public  static final String ANALYTICS_REPORT_QUOTE_PRODUCT="product";//产品报价分析
	//动作的类别
	public static final String ACTION_ADD = "add";//动作为新增类别
	public static final String ACTION_OPEN = "open";//开户
	public static final String ACTION_ADDITEM = "additem";//动作为新增类别
	public static final String ACTION_ADDPAYS = "addpays";//动作为新增类别
	public static final String ACTION_ADDRELA = "addrela";//动作为新增联系人关系类别
	public static final String ACTION_UPDATE = "update";//动作为修改类别
	public static final String ACTION_VALIDATE = "validate"; //验证类型
	public static final String ACTION_UPDATE_PWD = "updatepwd"; //修改密码
	public static final String ACTION_UPDATE_PARENT = "updateparent";//动作为修改相关类别
	public static final String ACTION_UPDATE_BASIC = "updatebasic";//动作为修改基本信息
	public static final String ACTION_UPDATEITEM = "updateitem";//动作为修改类别
	public static final String ACTION_DELETE = "delete";//动作为删除类别
	public static final String ACTION_DELETEITEM = "deleteitem";//动作为删除类别
	public static final String ACTION_SEARCH = "search";//动作为查询类别
	public static final String ACTION_SEARCHITEM = "searchitem";//动作为查询类别
	public static final String ACTION_SEARCHROW= "search_row";//动作为查询类别
	public static final String ACTION_SEARCHID = "searchid";//动作为单个查询类别
	public static final String ACTION_BINDING = "binding";//动作为绑定类别
	public static final String ACTION_COMPLETE= "complete";//动作为完成日程
	public static final String ACTION_FOLLOWUP = "followup";//动作为跟进
	public static final String ACTION_CHECK = "check";//财务审核
	public static final String ACTION_SEARCH_GATHERING= "search_gathering";//动作为查询回款信息
	public static final String ACTION_SEARCH_TASK= "search_task";//动作为查询任务信息
	public static final String ACTION_SEARCH_EXPENSE= "search_expense";//动作为查询费用信息
	public static final String ACTION_SEARCH_MESSAGE = "feedmsg"; //活动流新消息
	public static final String ACTION_CHANGEAPPROVAL = "changeapproval"; //转交
	public static final String ACTION_SEARCHPID = "searchpid"; //查询业务机会联系人
	public static final String ACTION_RELA = "rela"; //联系人关系
	public static final String ACTION_ADDEFFECT = "addeffect"; //影响力
	public static final String ACTION_UPDEFFECT = "updeffect"; //影响力
	public static final String ACTION_DELEFFECT = "deleffect"; //影响力
	
	//模块URL
	public static final String MODEL_URL_ENTRY = "/wxcrm/entry.php";//查询实体的连接 
	public static final String MODEL_URL_FEED = "/wxcrm/feed.php";//查询活动流的连接 
	public static final String MODEL_URL_AUTH = "/wxcrm/auth.php";//帐号绑定的连接 
	public static final String MODEL_URL_INIT = "/wxcrm/init.php";//查询lov 和 user 的连接 
	public static final String MODEL_URL_ANALYTICS = "/wxcrm/analytics.php"; //统计分析
	public static final String MODEL_URL_VALIDATE = "/wxcrm/validate.php"; //检查是否重名
	public static final String MODEL_URL_SHARE = "/wxcrm/share.php"; //分享
	public static final String MODEL_URL_NOTICE = "/wxcrm/notice.php"; //日报
	
	//查询时视图的类型  myview , teamview, focusview, allview
	public static final String SEARCH_VIEW_TYPE_MYVIEW = "myview";
	public static final String SEARCH_VIEW_TYPE_TEAMVIEW = "teamview";
	public static final String SEARCH_VIEW_TYPE_DEPARTVIEW = "departview";
	public static final String SEARCH_VIEW_TYPE_SHAREVIEW = "shareview";
	public static final String SEARCH_VIEW_TYPE_FOCUSVIEW = "focusview";
	public static final String SEARCH_VIEW_TYPE_ALLVIEW = "allview";
	public static final String SEARCH_VIEW_TYPE_MYALLVIEW = "myallview";
	public static final String SEARCH_VIEW_TYPE_BOOKSVIEW = "booksview"; //通讯录视图
	public static final String SEARCH_VIEW_TYPE_MYFOLLOWINGVIEW = "myfollowingview";
	public static final String SEARCH_VIEW_TYPE_MYWONVIEW = "mywonview";
	public static final String SEARCH_VIEW_TYPE_MYCLOSEDVIEW = "myclosedview";
	public static final String SEARCH_VIEW_TYPE_OPENVIEW = "openview";
	public static final String SEARCH_VIEW_TYPE_HOMEVIEW = "homeview";
	public static final String SEARCH_VIEW_TYPE_TODAYVIEW = "todayview";
	public static final String SEARCH_VIEW_TYPE_HISTORYVIEW = "historyview";
	public static final String SEARCH_VIEW_TYPE_NOTICEVIEW = "noticeview";
	public static final String SEARCH_VIEW_TYPE_PLANVIEW = "planview";
	public static final String SEARCH_VIEW_TYPE_CALENDAR_VIEW = "calendarview";
	//费用统计报表权限
	public static final String FUNC_WXCRM_MENU_ANALYTICS_EXPENSE_DEP = "WXCRM_MENU_ANALYTICS_EXPENSE_DEP";
	
	//邮件模板
	public static final String MAILTEMPLATE="<div>@@assigner@@，您好！</br></br>您有@@count@@笔回款需要催收，请及时跟进！ <br/><br/>@@content@@</div>";
//	
//	public static final String MAILAPPROVAL="<div>@@assigner@@，您好！</br></br>您有@@count@@笔报销需要审批，请及时审批！ <br/><br/>@@content@@</div>";
//	
//	public static final String MAILREJECT="<div>@@assigner@@，您好！</br></br>您有@@count@@笔报销被驳回，请及时查看！ <br/><br/>@@content@@</div>";
	
	//系统管理员crmid
	public static final String CRMID= "1";
	
	public static final String PROJECT_NAME = "指尖微客";
	
	//查询权限的类别
	public static final String SEARCH_FUNC_TYPE_SUB = "sub";//子类别
	public static final String SEARCH_FUNC_TYPE_PARENT = "parent";//父类别
	
	//查询单个用户的信息
	public static final String SEARCH_USER_INFO="single";
	//查询用户列表的信息
	public static final String SEARCH_USER_LIST="approve";
	
	public static final String MESSAGE_TYPE_1 = "feed_oppty";
	//邮件的签名档
//	public static final String SIGNATURE="</br></br></br><div><h3 class='strong'>Best Regards!</h3></div><p style='margin-bottom: 0px; margin-top: 0px;'><b><span style='FONT-SIZE: 10pt; FONT-FAMILY: 微软雅黑; COLOR: #333399'>德成微信CRM研发团队</span></b></p><span style='FONT-SIZE: 10pt; FONT-FAMILY: 微软雅黑; COLOR: #333399'>电话:073188319336</span></b></p><p style='margin-bottom: 0px; margin-top: 0px;'><b><span style='FONT-SIZE: 10pt;COLOR: black'>湖南省长沙市岳麓区麓谷大道627号新长海中心B2栋702</span></b></p>";
	
	public static final String DCCRMOPER_STATUS_OPEN = "1";//启用
	public static final String DCCRMOPER_STATUS_CLOSE = "0";//关闭
	
	//RSS订阅(关键字)
	public static final String RSSNEWS_KEYWORDS_URL="http://news.baidu.com/ns?word=%word&tn=newsrss&sr=0&cl=2&rn=5&ct=0";
	//RSS订阅(分类最新新闻订阅)
	public static final String RSSNEWS_DIGEST_URL="http://news.baidu.com/n?%class&tn=rss";
	
	//存入redis的key值(当前登录用户的最后一次登录时间)
	public static final String LOGINTIME_KEY = "TAKWxCrmSer_UserLastLoginTime";
	
	//缓存唯一的系统账号
	public static final String ZJWK_UNIQUE_ACCOUNT="ZJWK_Unique_Account_";
	
	//缓存市场活动的OrgId
	public static final String ZJWK_ACTIVITY_ORGID="ZJWK_Activity_Orgid_";
	
	//org表中标志位
	public static final String ZJWK_ORGANIZATION_FLAG_DISABLED="disabled"; 
	public static final String ZJWK_ORGANIZATION_FLAG_ENABLED="enabled";    
	public static final String ZJWK_ORGANIZATION_FLAG_APPLY="apply";
	
	//用户状态
	public static final String CRM_USER_STATUS_INACTIVE = "Inactive";
	
	public static final String SPM_CODE_CARD_EXCHANGE = "1.1.1.1";//名片交换申请
	public static final String SPM_CODE_GROUP_JOIN = "1.1.2.1";//群加入申请
	public static final String MESSAGE_RELA_MODEL_GROUP = "group";//组
	public static final String MESSAGE_TYPE_GROUP_REJECT = "group_reject";//入群驳回
	public static final String MESSAGE_STATUS_NOT_READ = "not_read";//未读 
	public static final String MESSAGE_TYPE_GROUP_AGREE= "group_agree";//入群同意
	public static final String MESSAGE_MODULE_TYPE_BATCH_IMP_CONTACTS = "Batch_Import_Contacts"; //批量导入联系人
	
	//add by zhihe
	public static final boolean NEED_COMPRESS = true;//是否需要压缩
	public static final int DEFAULT_WIDTH = 60;//压缩默认宽度
	public static final int DEFAULT_HEIGHT = 60;//压缩默认高度
	public static final String MIN_IMG_SIZE = "46";
	public static final String MAX_IMG_SIZE = "0";
	public static final String OTHER_IMG_SIZE_64 = "64";
	public static final String OTHER_IMG_SIZE_96 = "96";
	public static final String OTHER_IMG_SIZE_132 = "132";
	public static final String KEY_NEED_FTP_FLAG = "needFtpFlag";
	public static final String KEY_NEED_COMPRESS_FLAG = "needCompressFlag";
	public static final String KEY_IMAGE_WIDTH = "customWidth";
	public static final String KEY_IMAGE_HEIGHT = "customHeight";
	public static final String KEY_RETURN_OBJECT_IMAGE = "retunImg";
	public static final String KEY_RETURN_OBJECT_FILENAME = "retunStr";
	public static final String KEY_INPUT_OBJECT_FILE = "file";
	public static final String KEY_INPUT_OBJECT_IMAGE = "image";
	public static final String KEY_INPUT_OBJECT_URL = "url";
	
	
	public static final String SHORT_URL_PREFIX = "zjwk";  //长链接生成短链接前缀
	public static final String SHORT_CACHE_KEY = "ZJWK_SHORT_URL_KEY"; //短链接缓存key
	public static final String COOKIE_ZJWK_PARTYID = "Activity_PartyId";  //临时，与活动对应
	public static final int COOKIE_PARTYID_VALIDE_TIME = 3600*24*90; //90天
	
	//
	public static final String ZJWK_SESSION = "ZJWK_SESSION_";
	public static final String ZJWK_SESSION_ORG = "ZJWK_SESSION_ORG_";
	
	//消息类型
	public static final String MSG_TYPE_SYSTEM = "System";
	
	public static final int ZERO = 0;
	public static final int ALL_PAGECOUNT = 100000;
	
	//默认组织
	public static final String DEFAULT_ORGANIZATION = "Default Organization";
	
	//通知发送
	public static final String ZJWK_NOTICE_SEND="ZJWK_Notice_Send";
	
	//缓存工作日报orgId和rowId的关系
	public static final String  ZJWK_WORKPLAN_ROWID_RELA_ORGID= "ZJWK_WorkPlan_rowId_Rela_OrgId_";
	
	//用户设置默认账户key
	public static final String ZJWK_USER_DEFAULT_ORGANIZATION  = "ZJWK_User_Default_Organization";

	//活动分享cookie的key
	public static final String ACTIVITY_PARTYID="Activity_PartyId";
	public static final String ACTIVITY_UNIOD="Activity_Uniod";
	
	//parentType常量定义
	public static final String PARENT_TYPE_CUSTOMER = "Accounts";//客户
	
	//跟进历史opType常量定义
	public static final String AUDIT_OP_TYPE_TASK = "tasks";
	public static final String AUDIT_OP_TYPE_OPPTY = "oppty";
	public static final String AUDIT_OP_TYPE_CONTACT = "contact";
	
	//查询条件redis键前缀
	public static final String SEARCH_REDIS_KEY_PREFIX_CUSTOMER = "customer_search_";
	
	//工作计划全局开启标志位和类型
	public static final String ZJWK_WORKPLAN_GLOBAL_FLAG_TYPE="zjwk_workplan_global_flag_type_";
	//工作计划个人开启标志位和类型
	public static final String ZJWK_WORKPLAN_PERSONAL_FLAG_TYPE="zjwk_workplan_personal_flag_type_";
}
