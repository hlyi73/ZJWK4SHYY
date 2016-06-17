package com.takshine.wxcrm.base.util;

import java.net.URL;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import com.sun.syndication.feed.synd.SyndContent;
import com.sun.syndication.feed.synd.SyndEntry;
import com.sun.syndication.feed.synd.SyndFeed;
import com.sun.syndication.io.SyndFeedInput;
import com.sun.syndication.io.XmlReader;
import com.takshine.wxcrm.domain.RssNews;
  
/**
 * 解析rss新闻订阅
 * @author dengbo
 *
 */
public class ParseRss {  
	
		/**
		 * rome解析rss
		 * @param rss
		 * @return
		 * @throws Exception
		 */
	    public static List<RssNews> parseRss(String rss) throws Exception{  
    		List<RssNews> list = new ArrayList<RssNews>();
            URL url = new URL(rss);  
            // 读取Rss源     
            XmlReader reader = new XmlReader(url);  
            SyndFeedInput input = new SyndFeedInput();  
            // 得到SyndFeed对象，即得到Rss源里的所有信息     
            SyndFeed feed = input.build(reader);  
            // 得到Rss新闻中子项列表     
            List entries = feed.getEntries();  
            // 循环得到每个子项信息     
            for (int i = 0; i < entries.size(); i++) {  
            	RssNews rssNews = new RssNews();
                SyndEntry entry = (SyndEntry) entries.get(i);  
                // 标题、连接地址、标题简介、时间是一个Rss源项最基本的组成部分     
                rssNews.setTitle(entry.getTitle());  
                rssNews.setLink(entry.getLink()); 
                SyndContent description = entry.getDescription(); 
                String desc = description.getValue();
                if(null != desc){
                	if(desc.indexOf("<a") != -1 && desc.indexOf("</a>") != -1){
                		String imgurl = desc.substring(desc.indexOf("<a"),desc.indexOf("</a>")+4).replace("http://t1.baidu.com/it/u=", "");
                		try{
	                		imgurl = java.net.URLDecoder.decode(imgurl, "UTF-8");
	                		imgurl = imgurl.substring(imgurl.indexOf("src=\"")+5,imgurl.lastIndexOf("&amp;fm=30"));
	                		rssNews.setImgurl(imgurl);
                		}catch(Exception ex){
                			rssNews.setImgurl("");
                		}
                	}
                }
                if(null!=entry.getPublishedDate()){
                	rssNews.setPubdate(DateTime.date2Str(entry.getPublishedDate(),DateTime.DateFormat1));  
                }else{
                	rssNews.setPubdate(DateTime.currentDate(DateTime.DateFormat1));
                }
//                if(StringUtils.isNotNullOrEmptyStr(desc)){
//        			if(desc.contains("src=\"")){
//        				String img = desc.substring(desc.indexOf("src=\"")+5,desc.lastIndexOf("fm=30\">")+5);
//        				img=img.replaceAll("amp;", "");
//        				rssNews.setImgurl(img);
//        			}else{
//		                rssNews.setImgurl("http://img.baidu.com/img/logo-news.gif");
//        			}
//        		}
                rssNews.setDesc(desc);  
                rssNews.setAuthor(entry.getAuthor());  
//                此标题所属的范畴     
//                List categoryList = entry.getCategories();  
//                if (categoryList != null) {  
//                    for (int m = 0; m < categoryList.size(); m++) {  
//                        SyndCategory category = (SyndCategory) categoryList.get(m);  
//                    }  
//                }  
//                得到流媒体播放文件的信息列表     
//                List enclosureList = entry.getEnclosures();  
//                if (enclosureList != null) {  
//                    for (int n = 0; n < enclosureList.size(); n++) {  
//                        SyndEnclosure enclosure = (SyndEnclosure) enclosureList.get(n);  
//                    }  
//                }  
                list.add(rssNews);
            }  
        return list;
    }  
    
    /**
     * 使用dom4j解析rss
     * @param url
     * @throws Exception
     */
    public static List<RssNews> parseRssNews(String url) throws Exception{
    	List<RssNews> list = new ArrayList<RssNews>();
    	SAXReader reader = new SAXReader();
    	Document document = reader.read(url);
    	Element root = document.getRootElement();
    	List<Element> ele_Items = root.element("channel").elements("item");
    	Iterator<Element> iterator_Item = ele_Items.iterator();
    	while(iterator_Item.hasNext()){
    		RssNews rssNews = new RssNews();
    		// 新闻项节点
    		Element ele_Item = iterator_Item.next();
    		rssNews.setTitle(ele_Item.elementText("title"));
    		rssNews.setLink(ele_Item.elementText("link"));
    		rssNews.setAuthor(ele_Item.elementText("author"));
//    		String date = ele_Item.elementText("pubDate");
    		rssNews.setPubdate(DateTime.currentDate(DateTime.DateFormat1));
    		String desc = ele_Item.elementText("description");
    		if(StringUtils.isNotNullOrEmptyStr(desc)){
    			if(desc.contains("src=\"")){
    				String img = desc.substring(desc.indexOf("src=\"")+5,desc.lastIndexOf("fm=30\">")+5);
    				img=img.replaceAll("amp;", "");
    				rssNews.setImgurl(img);
    			}
    		}
    		rssNews.setDesc(desc);
    		list.add(rssNews);
    	}
    	return list;
    }
    
    public static void main(String[] args) throws Exception {
    	String str="<a href=http://ent.ifeng.com/a/20140919/40312771_0.shtml target=_blank><img src=http://t12.baidu.com/it/u=549624176,229468441&amp;fm=55&amp;s=45E2BD44441AB3D84CEC699601009092&amp;w=121&amp;h=81&amp;img.JPEG border=0></a><br>再问向华强是否很生气,他发出三下笑声:“哈哈哈!” 向太连日护夫,又发律师信追究无线报道未经证实的传闻,她在微博留言:“绝对不能够忍,一个个讨回公道。不...";
	}
}  
