package com.takshine.wxcrm.base.util;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import com.takshine.wxcrm.message.resp.Article;
import com.takshine.wxcrm.message.resp.MusicMessage;
import com.takshine.wxcrm.message.resp.NewsMessage;
import com.takshine.wxcrm.message.resp.TextMessage;
import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.core.util.QuickWriter;
import com.thoughtworks.xstream.io.HierarchicalStreamWriter;
import com.thoughtworks.xstream.io.xml.PrettyPrintWriter;
import com.thoughtworks.xstream.io.xml.XppDriver;

/** 
* 消息工具类 
*  
* @author liulin 
* @date 2014-02-26 
*/  
public class WxMsgUtil {
	
   private static Logger log = Logger.getLogger(WxMsgUtil.class.getName());
 
   /** 
    * 返回消息类型：文本 
    */  
   public static final String RESP_MESSAGE_TYPE_TEXT = "text";  
 
   /** 
    * 返回消息类型：音乐 
    */  
   public static final String RESP_MESSAGE_TYPE_MUSIC = "music";  
 
   /** 
    * 返回消息类型：图文 
    */  
   public static final String RESP_MESSAGE_TYPE_NEWS = "news";  
 
   /** 
    * 请求消息类型：文本 
    */  
   public static final String REQ_MESSAGE_TYPE_TEXT = "text";  
 
   /** 
    * 请求消息类型：图片 
    */  
   public static final String REQ_MESSAGE_TYPE_IMAGE = "image";  
 
   /** 
    * 请求消息类型：链接 
    */  
   public static final String REQ_MESSAGE_TYPE_LINK = "link";  
 
   /** 
    * 请求消息类型：地理位置 
    */  
   public static final String REQ_MESSAGE_TYPE_LOCATION = "location";  
 
   /** 
    * 请求消息类型：音频 
    */  
   public static final String REQ_MESSAGE_TYPE_VOICE = "voice";  
 
   /** 
    * 请求消息类型：推送 
    */  
   public static final String REQ_MESSAGE_TYPE_EVENT = "event";  
 
   /** 
    * 事件类型：subscribe(订阅) 
    */  
   public static final String EVENT_TYPE_SUBSCRIBE = "subscribe";  
 
   /** 
    * 事件类型：unsubscribe(取消订阅) 
    */  
   public static final String EVENT_TYPE_UNSUBSCRIBE = "unsubscribe";  
 
   /** 
    * 事件类型：CLICK(自定义菜单点击事件) 
    */  
   public static final String EVENT_TYPE_CLICK = "CLICK";  
   /** 
    * 事件类型：LOCATION(位置上报事件) 
    */  
   public static final String EVENT_TYPE_LOCATION = "LOCATION";  
 
   /** 
    * 解析微信发来的请求（XML） 
    *  
    * @param request 
    * @return 
    * @throws Exception 
    */  
    @SuppressWarnings("unchecked")  
    public static Map<String, String> parseXml(HttpServletRequest request) throws Exception {  
        // 将解析结果存储在HashMap中   
        Map<String, String> map = new HashMap<String, String>();  
  
        // 从request中取得输入流   
        InputStream inputStream = request.getInputStream();  
        // 读取输入流   
        SAXReader reader = new SAXReader();  
        Document document = reader.read(inputStream);  
        // 得到xml根元素   
        Element root = document.getRootElement();  
        // 得到根元素的所有子节点   
        List<Element> elementList = root.elements();  
  
        // 遍历所有子节点   
        for (Element e : elementList)  
            map.put(e.getName(), e.getText());  
  
        // 释放资源   
        inputStream.close();  
        inputStream = null;  
  
        return map;  
    }  
  
    /** 
     * 文本消息对象转换成xml 
     *  
     * @param textMessage 文本消息对象 
     * @return xml 
     */  
    public static String textMessageToXml(TextMessage textMessage) {  
        xstream.alias("xml", textMessage.getClass());  
        return xstream.toXML(textMessage);  
    }  
  
    /** 
     * 音乐消息对象转换成xml 
     *  
     * @param musicMessage 音乐消息对象 
     * @return xml 
     */  
    public static String musicMessageToXml(MusicMessage musicMessage) {  
        xstream.alias("xml", musicMessage.getClass());  
        return xstream.toXML(musicMessage);  
    }  
  
    /** 
     * 图文消息对象转换成xml 
     *  
     * @param newsMessage 图文消息对象 
     * @return xml 
     */  
    public static String newsMessageToXml(NewsMessage newsMessage) {  
        xstream.alias("xml", newsMessage.getClass());  
        xstream.alias("item", new Article().getClass());  
        return xstream.toXML(newsMessage);  
    }  
  
    /** 
     * 扩展xstream，使其支持CDATA块 
     *  
     * @date 2013-05-19 
     */  
    @SuppressWarnings("rawtypes")
    private static XStream xstream = new XStream(new XppDriver() {  
        public HierarchicalStreamWriter createWriter(Writer out) {  
            return new PrettyPrintWriter(out) {  
                // 对所有xml节点的转换都增加CDATA标记   
                boolean cdata = true;  
  
                public void startNode(String name,  Class clazz) {  
                    super.startNode(name, clazz);  
                }  
  
                protected void writeText(QuickWriter writer, String text) {  
                    if (cdata) {  
                        writer.write("<![CDATA[");  
                        writer.write(text);  
                        writer.write("]]>");  
                    } else {  
                        writer.write(text);  
                    }  
                }  
            };  
        }  
    }); 
    
   /** 
    * 计算采用utf-8编码方式时字符串所占字节数 
    *  
    * @param content 
    * @return 
    */  
    public static int getByteSize(String content) {  
        int size = 0;  
        if (null != content) {  
            try {  
                // 汉字采用utf-8编码时占3个字节   
                size = content.getBytes("utf-8").length;  
            } catch (UnsupportedEncodingException e) {  
                e.printStackTrace();  
            }  
        }  
        return size;  
    }  
    
    /** 
     * 判断是否是QQ表情 
     *  
     * @param content 
     * @return 
     */  
    public static boolean isQqFace(String content) {  
        boolean result = false;  
      
        // 判断QQ表情的正则表达式   
        String qqfaceRegex = "/::\\)|/::~|/::B|/::\\||/:8-\\)|/::<|/::$|/::X|/::Z|/::'\\(|/::-\\||/::@|/::P|/::D|/::O|/::\\(|/::\\+|/:--b|/::Q|/::T|/:,@P|/:,@-D|/::d|/:,@o|/::g|/:\\|-\\)|/::!|/::L|/::>|/::,@|/:,@f|/::-S|/:\\?|/:,@x|/:,@@|/::8|/:,@!|/:!!!|/:xx|/:bye|/:wipe|/:dig|/:handclap|/:&-\\(|/:B-\\)|/:<@|/:@>|/::-O|/:>-\\||/:P-\\(|/::'\\||/:X-\\)|/::\\*|/:@x|/:8\\*|/:pd|/:<W>|/:beer|/:basketb|/:oo|/:coffee|/:eat|/:pig|/:rose|/:fade|/:showlove|/:heart|/:break|/:cake|/:li|/:bome|/:kn|/:footb|/:ladybug|/:shit|/:moon|/:sun|/:gift|/:hug|/:strong|/:weak|/:share|/:v|/:@\\)|/:jj|/:@@|/:bad|/:lvu|/:no|/:ok|/:love|/:<L>|/:jump|/:shake|/:<O>|/:circle|/:kotow|/:turn|/:skip|/:oY|/:#-0|/:hiphot|/:kiss|/:<&|/:&>";  
        Pattern p = Pattern.compile(qqfaceRegex);  
        Matcher m = p.matcher(content);  
        if (m.matches()) {  
            result = true;  
        }  
        return result;  
    }  
    
    /** 
     * 将微信消息中的CreateTime转换成标准格式的时间（yyyy-MM-dd HH:mm:ss） 
     *  
     * @param createTime 消息创建时间 
     * @return 
     */  
    public static String formatTime(String createTime) {  
        // 将微信传入的CreateTime转换成long类型，再乘以1000   
        long msgCreateTime = Long.parseLong(createTime) * 1000L;  
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
        return format.format(new Date(msgCreateTime));  
    }  
    
    /** 
     * emoji表情转换(hex -> utf-16) 
     *  
     * @param hexEmoji 
     * @return 
     */  
    public static String emoji(int hexEmoji) {  
        return String.valueOf(Character.toChars(hexEmoji));  
    } 
    
    
    /**
	 * 返回默认的图文信息
	 * @param fromUserName
	 * @param toUserName
	 * @param content
	 * @return
	 */
	public static String textMsg(String fromUserName, String toUserName, String content){
		String respMessage = null;
		// 回复文本消息
		TextMessage textMessage = new TextMessage();
		textMessage.setToUserName(fromUserName);
		textMessage.setFromUserName(toUserName);
		textMessage.setCreateTime(new Date().getTime());
		textMessage.setMsgType(WxMsgUtil.RESP_MESSAGE_TYPE_TEXT);
		textMessage.setFuncFlag(0);
		textMessage.setContent(content);
		respMessage = textMessageToXml(textMessage);
		
		return respMessage;
	}
	
	/**
	 * 发送当条图文信息
	 * @param fromUserName
	 * @param toUserName
	 * @param title
	 * @param desc
	 * @param picUrl
	 * @param url
	 * @return
	 */
	public static String singleMapTextMsg(String fromUserName, String toUserName, String title,
			                            String desc, String picUrl, String url){
		String respMessage = "";
		// 创建图文消息   
        NewsMessage newsMessage = new NewsMessage();  
        newsMessage.setToUserName(fromUserName);  
        newsMessage.setFromUserName(toUserName);  
        newsMessage.setCreateTime(new Date().getTime());  
        newsMessage.setMsgType(WxMsgUtil.RESP_MESSAGE_TYPE_NEWS);  
        newsMessage.setFuncFlag(0);  
        
        List<Article> articleList = new ArrayList<Article>();  
        
        Article article = new Article();  
        article.setTitle(title);//标题  
        article.setDescription(desc);//表述  
        article.setPicUrl(picUrl);//图片路径
        article.setUrl(url);  //超链接url
        articleList.add(article);  
        // 设置图文消息个数   
        newsMessage.setArticleCount(articleList.size());  
        // 设置图文消息包含的图文集合   
        newsMessage.setArticles(articleList);  
        // 将图文消息对象转换成xml字符串   
        respMessage = newsMessageToXml(newsMessage); 
        
		return respMessage;
	}
	
	/**
	 * 发送多条图文信息
	 * @param fromUserName
	 * @param toUserName
	 * @return
	 */
	public static String mulityMapTextMsg(String fromUserName, String toUserName, List<Article> articleList){
		String respMessage = "";
		// 创建图文消息   
		NewsMessage newsMessage = new NewsMessage();  
		newsMessage.setToUserName(fromUserName);  
		newsMessage.setFromUserName(toUserName);  
		newsMessage.setCreateTime(new Date().getTime());  
		newsMessage.setMsgType(WxMsgUtil.RESP_MESSAGE_TYPE_NEWS);  
		newsMessage.setFuncFlag(0);
		
		// 设置图文消息个数   
		newsMessage.setArticleCount(articleList.size());  
		// 设置图文消息包含的图文集合   
		newsMessage.setArticles(articleList);  
		// 将图文消息对象转换成xml字符串   
		respMessage = newsMessageToXml(newsMessage); 
		
		return respMessage;
	}
	
	/**
	 * 返回不同的图文信息
	 * @param fromUserName
	 * @param toUserName
	 * @param content 用户发送的文本消息内容   
	 * @return
	 */
	public String mapAndTextMsg(String fromUserName, String toUserName, String content){
		String respMessage = "";
        // 创建图文消息   
        NewsMessage newsMessage = new NewsMessage();  
        newsMessage.setToUserName(fromUserName);  
        newsMessage.setFromUserName(toUserName);  
        newsMessage.setCreateTime(new Date().getTime());  
        newsMessage.setMsgType(WxMsgUtil.RESP_MESSAGE_TYPE_NEWS);  
        newsMessage.setFuncFlag(0);  

        List<Article> articleList = new ArrayList<Article>();  
        // 单图文消息   
        if ("single map01".equals(content)) {  
            Article article = new Article();  
            article.setTitle("微信公众帐号开发教程Java版");  
            article.setDescription("德成鸿业，80后，微信公众帐号开发经验4个月。为帮助初学者入门，特推出此系列教程，也希望借此机会认识更多同行！");  
            article.setPicUrl("http://0.xiaoqrobot.duapp.com/images/avatar_liufeng.jpg");  
            article.setUrl("http://blog.csdn.net/lyq8479");  
            articleList.add(article);  
            // 设置图文消息个数   
            newsMessage.setArticleCount(articleList.size());  
            // 设置图文消息包含的图文集合   
            newsMessage.setArticles(articleList);  
            // 将图文消息对象转换成xml字符串   
            respMessage = WxMsgUtil.newsMessageToXml(newsMessage);  
        }  
        // 单图文消息---不含图片   
        else if ("single map02".equals(content)) {  
            Article article = new Article();  
            article.setTitle("微信公众帐号开发教程Java版");  
            // 图文消息中可以使用QQ表情、符号表情   
            article.setDescription("德成鸿业，80后，" + WxMsgUtil.emoji(0x1F6B9)  
                    + "，微信公众帐号开发经验4个月。为帮助初学者入门，特推出此系列连载教程，也希望借此机会认识更多同行！\n\n目前已推出教程共12篇，包括接口配置、消息封装、框架搭建、QQ表情发送、符号表情发送等。\n\n后期还计划推出一些实用功能的开发讲解，例如：天气预报、周边搜索、聊天功能等。");  
            // 将图片置为空   
            article.setPicUrl("");  
            article.setUrl("http://blog.csdn.net/lyq8479");  
            articleList.add(article);  
            newsMessage.setArticleCount(articleList.size());  
            newsMessage.setArticles(articleList);  
            respMessage = WxMsgUtil.newsMessageToXml(newsMessage);  
        }  
        // 多图文消息   
        else if ("multi map01".equals(content)) {  
             Article article1 = new Article();  
             article1.setTitle("微信公众帐号开发教程\n引言");  
             article1.setDescription("");  
             article1.setPicUrl("http://0.xiaoqrobot.duapp.com/images/avatar_liufeng.jpg");  
             article1.setUrl("http://blog.csdn.net/lyq8479/article/details/8937622");  

             Article article2 = new Article();  
             article2.setTitle("第2篇\n微信公众帐号的类型");  
             article2.setDescription("");  
             article2.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
             article2.setUrl("http://blog.csdn.net/lyq8479/article/details/8941577");  

             Article article3 = new Article();  
             article3.setTitle("第3篇\n开发模式启用及接口配置");  
             article3.setDescription("");  
             article3.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
             article3.setUrl("http://blog.csdn.net/lyq8479/article/details/8944988");  

             articleList.add(article1);  
             articleList.add(article2);  
             articleList.add(article3);  
             newsMessage.setArticleCount(articleList.size());  
             newsMessage.setArticles(articleList);  
             respMessage = WxMsgUtil.newsMessageToXml(newsMessage);  
         }  
         // 多图文消息---首条消息不含图片   
         else if ("multi map02".equals(content)) {  
             Article article1 = new Article();  
             article1.setTitle("微信公众帐号开发教程Java版");  
             article1.setDescription("");  
             // 将图片置为空   
             article1.setPicUrl("");  
             article1.setUrl("http://blog.csdn.net/lyq8479");  

             Article article2 = new Article();  
             article2.setTitle("第4篇\n消息及消息处理工具的封装");  
             article2.setDescription("");  
             article2.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
             article2.setUrl("http://blog.csdn.net/lyq8479/article/details/8949088");  

             Article article3 = new Article();  
             article3.setTitle("第5篇\n各种消息的接收与响应");  
             article3.setDescription("");  
             article3.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
             article3.setUrl("http://blog.csdn.net/lyq8479/article/details/8952173");  

             Article article4 = new Article();  
             article4.setTitle("第6篇\n文本消息的内容长度限制揭秘");  
             article4.setDescription("");  
             article4.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
             article4.setUrl("http://blog.csdn.net/lyq8479/article/details/8967824");  

             articleList.add(article1);  
             articleList.add(article2);  
             articleList.add(article3);  
             articleList.add(article4);  
             newsMessage.setArticleCount(articleList.size());  
             newsMessage.setArticles(articleList);  
             respMessage = WxMsgUtil.newsMessageToXml(newsMessage);  
         }  
         // 多图文消息---最后一条消息不含图片   
         else if ("multi map03".equals(content)) {  
             Article article1 = new Article();  
             article1.setTitle("第7篇\n文本消息中换行符的使用");  
             article1.setDescription("");  
             article1.setPicUrl("http://0.xiaoqrobot.duapp.com/images/avatar_liufeng.jpg");  
             article1.setUrl("http://blog.csdn.net/lyq8479/article/details/9141467");  

             Article article2 = new Article();  
             article2.setTitle("第8篇\n文本消息中使用网页超链接");  
             article2.setDescription("");  
             article2.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
             article2.setUrl("http://blog.csdn.net/lyq8479/article/details/9157455");  

             Article article3 = new Article();  
             article3.setTitle("如果觉得文章对你有所帮助，请通过博客留言或关注微信公众帐号xiaoqrobot来支持德成鸿业！");  
             article3.setDescription("");  
             // 将图片置为空   
             article3.setPicUrl("");  
             article3.setUrl("http://blog.csdn.net/lyq8479");  

             articleList.add(article1);  
             articleList.add(article2);  
             articleList.add(article3);  
             newsMessage.setArticleCount(articleList.size());  
             newsMessage.setArticles(articleList);  
             respMessage = WxMsgUtil.newsMessageToXml(newsMessage);  
         }
        
		 return respMessage;
	}
	
	/**
	 * 绑定账户的消息提示
	 * @param openId
	 * @param publicId
	 * @return
	 */
	public static String bindAcctTip(String openId, String publicId){
		//未绑定帐号的情况下
		StringBuffer buffer = new StringBuffer("");
		//绑定手机号
	    buffer.append("亲，您还未绑定帐号哦,<a href=\"").append(PropertiesUtil.getAppContext("app.content"));
	    buffer.append("operMobile/get?openId="+ openId +"&publicId="+ publicId +"\">赶紧去绑定吧！</a>");
	    return WxMsgUtil.textMsg(openId, publicId, buffer.toString());
	}
	
	
	public static final Map<String,Map<String,String>> cacheMessageId = new ConcurrentHashMap<String, Map<String,String>>();
	/**
	 * 根据产生的短id取得消息ID何消息类型
	 * @param shortid 短id
	 * @return Map，key为消息Id，Value为类型
	 */
	public static final Map<String,String> getMessageIdAndType(String shortid){
		if (cacheMessageId.containsKey(shortid)) return cacheMessageId.get(shortid);
		throw new RuntimeException("该消息没有被缓存");
	}
	/**
	 * 将消息ID何消息类型，缓存，产生短ID
	 * @param messageid 消息ID
	 * @param type 消息类型
	 * @return 短ID
	 */
	public static final String getMessageShortId(String messageid,String type){
		String shortid = random(4);
		while(cacheMessageId.containsKey(shortid)){
			shortid = random(4);
		}
		Map<String,String> map = new HashMap<String,String>();
		map.put(messageid, type);
		cacheMessageId.put(shortid, map);
		return shortid;
	}

	/**
	 * 产生N位随机数
	 * @param n 位数
	 * @return 随机数
	 */
	public static String random(int n) {
        if (n < 1 || n > 10) {
            throw new IllegalArgumentException("cannot random " + n + " bit number");
        }
        Random ran = new Random();
        if (n == 1) {
            return String.valueOf(ran.nextInt(10));
        }
        int bitField = 0;
        char[] chs = new char[n];
        for (int i = 0; i < n; i++) {
            while(true) {
                int k = ran.nextInt(10);
                if( (bitField & (1 << k)) == 0) {
                    bitField |= 1 << k;
                    chs[i] = (char)(k + '0');
                    break;
                }
            }
        }
        return new String(chs);
    }

} 
