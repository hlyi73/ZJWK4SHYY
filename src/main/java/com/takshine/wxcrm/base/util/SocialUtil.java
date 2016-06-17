package com.takshine.wxcrm.base.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;

import com.takshine.wxcrm.domain.SocialMessages;
import com.takshine.wxcrm.domain.SocialPics;
import com.takshine.wxcrm.domain.SocialTags;
import com.takshine.wxcrm.domain.SocialUserInfo;
import com.takshine.wxcrm.message.oauth.AuthorizeInfo;
import com.takshine.wxcrm.message.social.SocialUserInfoResp;

public class SocialUtil {
	private static Logger log =  Logger.getLogger(SocialUtil.class.getName());
	//是否开启微博
	public static int IS_OPEN_SOCIAL = 0; //1:Open 0:Close

	//------------------微博审核信息-----------------------
	public static String wb_auth_url = "https://open.weibo.cn/oauth2/authorize?client_id=CLIENTID&redirect_uri=RETURNURI&response_type=code";
	//微博appkey
	public static String wb_client_id = "2400573134";  
	//微博secret
	private static String wb_client_secret = "cd4b12c7e4d1ec53ab473575f6c39a0d";
	
	//------------------微博回调链接-----------------------
	public static String wb_return_uri = "http://115.28.27.20/TAKWxCrmSer/social/weibo"; 
	
	//------------------微博接口-----------------------
	//获取微博access token url
	private static String wb_access_token_url = "https://api.weibo.com/oauth2/access_token"; 
	//获取微博用户信息url
	private static String wb_get_user = "https://api.weibo.com/2/users/show.json"; 
	//获取用户的粉丝列表
	private static String wb_get_friends = "https://api.weibo.com/2/friendships/followers.json";
	//获取用户的粉丝列表-UID列表
	private static String wb_get_friends_ids="https://api.weibo.com/2/friendships/followers/ids.json";
	//获取用户双向关注的用户ID列表，即互粉UID列表
	private static String wb_get_friends_bilateral_ids = "https://api.weibo.com/2/friendships/friends/bilateral/ids.json";
	//获取双向关注列表
	private static String wb_get_friends_bilateral = "https://api.weibo.com/2/friendships/friends/bilateral.json";
	
	//搜索接口
	private static String wb_search_user = "https://api.weibo.com/2/search/suggestions/users.json";
	//根据一段微博正文推荐相关微博用户
	private static String wb_search_user_byc = "https://api.weibo.com/2/suggestions/users/by_status.json";
	
	//标签类
	//返回指定用户的标签列表
	private static String wb_get_tags = "https://api.weibo.com/2/tags.json";
	
	//获取用户标签
	public static List<SocialTags> getWBUserTags(String token, String uid) {
		List<SocialTags> tagList = null;
		String param = "access_token=" + token + "&uid=" + uid;
		JSONArray jarray = sendGet1(wb_get_tags, param);
		if (null != jarray) {
			try {
				tagList = new ArrayList<SocialTags>();
				JSONObject jobj = null;
				SocialTags tag = null;
				for(int i=0;i<jarray.size();i++){
					jobj = jarray.getJSONObject(i);
					tag = new SocialTags();
					tag.setTag(jobj.values().toArray()[0].toString());
					tagList.add(tag);
				}
			} catch (JSONException e) {
				tagList = null;
			}
		}
		return tagList;
	}
	
	//根据一段微博正文推荐相关微博用户
	public static SocialUserInfoResp searchWBUserByContent(String token, String scontent, String count) throws UnsupportedEncodingException {
		SocialUserInfoResp resp = new SocialUserInfoResp();
		List<SocialUserInfo> sList = null;
		String param = "access_token=" + token +"&content=" + URLEncoder.encode(scontent,"utf-8") + "&num=" + count;

		JSONObject jsonObject = sendGet(wb_search_user_byc, param);
		if (null != jsonObject) {
			try {
				SocialUserInfo wbuser = null;
				if (null != jsonObject.getJSONArray("users") && !"".equals(jsonObject.getJSONArray("users"))) {
					sList = new ArrayList<SocialUserInfo>();
					JSONArray jarray = jsonObject.getJSONArray("users");
					JSONObject ujson = null;
					for (int i = 0; i < jarray.size(); i++) {
						ujson = (JSONObject) jarray.get(i);
						wbuser = new SocialUserInfo();
						wbuser.setUid(ujson.getString("id"));
						wbuser.setName(ujson.getString("name"));
						wbuser.setNickname(ujson.getString("screen_name"));
						wbuser.setLocation(ujson.getString("location"));
						wbuser.setHeadimgurl(ujson.getString("profile_image_url"));
						wbuser.setFollowers_count(ujson.getString("followers_count"));
						wbuser.setFriends_count(ujson.getString("friends_count"));
						wbuser.setStatuses_count(ujson.getString("statuses_count"));
						wbuser.setDesc(ujson.getString("description"));
						sList.add(wbuser);
					}
					resp.setSlist(sList);
				}
			} catch (JSONException e) {
				resp = null;
				// 获取token失败
				log.error("获取微博用户信息errcode:" + jsonObject.getInt("error_code") + ",errmsg:" + jsonObject.getString("error"));
			}
		}
		return resp;
	}
	
	//搜索用户
	public static SocialUserInfoResp searchWBUser(String token,String scontent,String count) throws UnsupportedEncodingException{
		SocialUserInfoResp resp = new SocialUserInfoResp();
		List<SocialUserInfo> sList = null;
		String param = "access_token=" + token + "&q=" + URLEncoder.encode(scontent,"utf-8")+"&count="+count;
		JSONArray jarray  = sendGet1(wb_search_user, param);
		if (null != jarray) {
			try {
				sList = new ArrayList<SocialUserInfo>();
				SocialUserInfo socialUserInfo = null;
				for(int i=0 ; i < jarray.size() ;i++){
					socialUserInfo = new SocialUserInfo();
				    //获取每一个JsonObject对象
				    JSONObject ujson = jarray.getJSONObject(i);
				    socialUserInfo.setUid(ujson.getString("uid"));
				    socialUserInfo.setNickname(ujson.getString("screen_name"));
				    socialUserInfo.setFollowers_count(ujson.getString("followers_count"));
					SocialUserInfo sUserInfo = getWBUserInfo(token, ujson.getString("uid"));
					socialUserInfo.setHeadimgurl(sUserInfo.getHeadimgurl());
					socialUserInfo.setStatuses_count(sUserInfo.getStatuses_count());
					sList.add(socialUserInfo);
				}
				resp.setSlist(sList);
			} catch (JSONException e) {
				resp = null;
			}
		}
		return resp;
	}
	
	
	// 获取二度人脉列表
	public static SocialUserInfoResp getWBSecondConnectionList(String token, String uid, String count, String cursor) {
		SocialUserInfoResp resp = new SocialUserInfoResp();
		List<SocialUserInfo> sList = null;
		String param = "access_token=" + token + "&uid=" + uid + "&count=" + count + "&cursor=" + cursor;

		JSONObject jsonObject = sendGet(wb_get_friends, param);
		if (null != jsonObject) {
			try {
				SocialUserInfo wbuser = null;
				if (null != jsonObject.getJSONArray("users") && !"".equals(jsonObject.getJSONArray("users"))) {
					sList = new ArrayList<SocialUserInfo>();
					JSONArray jarray = jsonObject.getJSONArray("users");
					JSONObject ujson = null;
					for (int i = 0; i < jarray.size(); i++) {
						ujson = (JSONObject) jarray.get(i);
						wbuser = new SocialUserInfo();
						wbuser.setUid(ujson.getString("id"));
						wbuser.setName(ujson.getString("name"));
						wbuser.setNickname(ujson.getString("screen_name"));
						wbuser.setLocation(ujson.getString("location"));
						wbuser.setHeadimgurl(ujson.getString("profile_image_url"));
						wbuser.setFollowers_count(ujson.getString("followers_count"));
						wbuser.setFriends_count(ujson.getString("friends_count"));
						wbuser.setStatuses_count(ujson.getString("statuses_count"));
						sList.add(wbuser);
					}
					resp.setSlist(sList);
				}
			} catch (JSONException e) {
				resp = null;
				// 获取token失败
				log.error("获取微博用户信息errcode:" + jsonObject.getInt("error_code") + ",errmsg:" + jsonObject.getString("error"));
			}
		}
		return resp;
	}
	
	//二度人脉 ids
	public static int getWBSecondConnectionCount(String token,String uid){
		int count = 0;
		String param = "access_token="+token+"&uid="+uid;
		JSONObject jsonObject = sendGet(wb_get_friends_ids,param);
		if (null != jsonObject) {
			try {
				if(null != jsonObject.getString("total_number") && !"".equals(jsonObject.getString("total_number"))){
					count = Integer.parseInt(jsonObject.getString("total_number"));
				}
			} catch (JSONException e) {
				count = 0 ;
				// 获取token失败
				log.error("获取token失败01 errcode:"+ jsonObject.getInt("error_code") +",errmsg:"+ jsonObject.getString("error"));
			}
		}
		return count;
	}
	
	//获取一度人脉列表
	public static SocialUserInfoResp getWBFirstConnectionList(String token,String uid,String count,String cursor){
		SocialUserInfoResp resp = new SocialUserInfoResp();
		List<SocialUserInfo> sList = null;
		String param = "access_token="+token+"&uid="+uid+"&count="+count+"&page="+cursor;
		
		JSONObject jsonObject = sendGet(wb_get_friends_bilateral,param);
		if (null != jsonObject) {
			try {
				SocialUserInfo wbuser = null;
				if(null != jsonObject.getJSONArray("users") && !"".equals(jsonObject.getJSONArray("users"))){
					sList = new ArrayList<SocialUserInfo>();
					JSONArray jarray = jsonObject.getJSONArray("users");
					JSONObject ujson = null;
					for(int i=0;i<jarray.size();i++){
						ujson = (JSONObject)jarray.get(i);
						wbuser = new SocialUserInfo();
						wbuser.setUid(ujson.getString("id"));
						wbuser.setName(ujson.getString("name"));
						wbuser.setNickname(ujson.getString("screen_name"));
						wbuser.setLocation(ujson.getString("location"));
						wbuser.setHeadimgurl(ujson.getString("profile_image_url"));
						wbuser.setFollowers_count(ujson.getString("followers_count"));
						wbuser.setFriends_count(ujson.getString("friends_count"));
						wbuser.setStatuses_count(ujson.getString("statuses_count"));
						sList.add(wbuser);
					}
					resp.setSlist(sList);
				}
			} catch (JSONException e) {
				resp = null;
				// 获取token失败
				log.error("获取微博用户信息errcode:"+ jsonObject.getInt("error_code") +",errmsg:"+ jsonObject.getString("error"));
			}
		}
		return resp;
	}
	//一度人脉 ids
	public static int getWBFirstConnectionCount(String token,String uid){
		int count = 0;
		String param = "access_token="+token+"&uid="+uid;
		JSONObject jsonObject = sendGet(wb_get_friends_bilateral_ids,param);
		if (null != jsonObject) {
			try {
				if(null != jsonObject.getString("total_number") && !"".equals(jsonObject.getString("total_number"))){
					count = Integer.parseInt(jsonObject.getString("total_number"));
				}
			} catch (JSONException e) {
				count = 0 ;
				// 获取token失败
				log.error("获取token失败02 errcode:"+ jsonObject.getInt("error_code") +",errmsg:"+ jsonObject.getString("error"));
			}
		}
		return count;
	}
	
	//获取微博用户信息
	public static SocialUserInfo getWBUserInfo(String token,String uid){
		SocialUserInfo wbuser = null;
		String param = "access_token="+token+"&uid="+uid;
		JSONObject jsonObject = sendGet(wb_get_user,param);
		if (null != jsonObject) {
			try {
				wbuser = new SocialUserInfo();
				wbuser.setUid(jsonObject.getString("id"));
				wbuser.setNickname(jsonObject.getString("screen_name"));
				wbuser.setWbname(jsonObject.getString("name"));
				wbuser.setHeadimgurl(jsonObject.getString("profile_image_url"));
				wbuser.setFollowers_count(jsonObject.getString("followers_count"));
				wbuser.setFriends_count(jsonObject.getString("friends_count"));
				wbuser.setStatuses_count(jsonObject.getString("statuses_count"));
				wbuser.setLocation(jsonObject.getString("location"));
				wbuser.setDesc(jsonObject.getString("description"));
				wbuser.setUrl(jsonObject.getString("url"));
				if(null != jsonObject.getJSONObject("status")){
					JSONObject jobj = jsonObject.getJSONObject("status");
					SocialMessages msg = new SocialMessages();
					List<SocialMessages> msgList = new ArrayList<SocialMessages>();
					msg.setCreateTime(DateTime.dateTimeParse2(jobj.getString("created_at"), "yyyy-MM-dd"));
					msg.setId(jobj.getString("id"));
					msg.setText(jobj.getString("text"));
					msg.setSource(jobj.getString("source"));
					msg.setReposts_count(jobj.getString("reposts_count"));
					msg.setComments_count(jobj.getString("comments_count"));
					if(null != jobj.getJSONArray("pic_urls")){
						JSONArray jarr = jobj.getJSONArray("pic_urls");
						List<SocialPics> picList = new ArrayList<SocialPics>();
						for(int j=0;j<jarr.size();j++){
							SocialPics pic = new SocialPics();
							JSONObject picjson = jarr.getJSONObject(j);
							pic.setPic_urls(picjson.getString("thumbnail_pic"));
							picList.add(pic);
						}
						msg.setPicList(picList);
					}
					msgList.add(msg);
					wbuser.setMsgList(msgList);
				}
			} catch (JSONException e) {
				wbuser = null;
				// 获取token失败
				log.error("获取微博用户信息errcode:"+ jsonObject.getInt("error_code") +",errmsg:"+ jsonObject.getString("error"));
			}
		}
		return wbuser;
	}
	
	//获取新浪微博token
	public static AuthorizeInfo getWBAccessToken(String code){
		AuthorizeInfo auth = null;
		String param = "client_id="+wb_client_id+"&client_secret="+wb_client_secret+"&grant_type=authorization_code&code="+code+"&redirect_uri="+wb_return_uri;
		JSONObject jsonObject = sendPost(wb_access_token_url,param);
		if (null != jsonObject) {
			try {
				auth = new AuthorizeInfo();
				auth.setAccessToken(jsonObject.getString("access_token"));
				auth.setExpiresIn(jsonObject.getInt("expires_in"));
				auth.setOpenId(jsonObject.getString("uid"));
			} catch (JSONException e) {
				auth = null;
				// 获取token失败
				log.error("获取token失败03 errcode:"+ jsonObject.getInt("error_code") +",errmsg:"+ jsonObject.getString("error"));
			}
		}
		return auth;
	}
	
	
	
	//发送http请求
	private static JSONObject sendPost(String url, String param) {
		JSONObject jsonObject = null;
        PrintWriter out = null;
        BufferedReader in = null;
        StringBuffer buffer = new StringBuffer();
        try {
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            // 设置通用的请求属性
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("user-agent",
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            // 发送POST请求必须设置如下两行
            conn.setDoOutput(true);
            conn.setDoInput(true);
            // 获取URLConnection对象对应的输出流
            out = new PrintWriter(conn.getOutputStream());
            // 发送请求参数
            out.print(param);
            // flush输出流的缓冲
            out.flush();
            // 定义BufferedReader输入流来读取URL的响应
            in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = in.readLine()) != null) {
            	buffer.append(line);
            }
            line = buffer.toString();
            jsonObject = JSONObject.fromObject(line.substring(line.indexOf("{")));
        } catch (Exception e) {
        	log.info("==SocialController==sendPost== 发送POST请求出现异常！" + e.toString());
            e.printStackTrace();
        }
        //使用finally块来关闭输出流、输入流
        finally{
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
            catch(IOException ex){
                ex.printStackTrace();
            }
        }
        return jsonObject;
    }     
	
	//发送GET请求
	public static JSONObject sendGet(String url, String param) {
		JSONObject jsonObject = null;
		StringBuffer buffer = new StringBuffer();
        BufferedReader in = null;
        try {
            String urlNameString = url + "?" + param;
            URL realUrl = new URL(urlNameString);
            // 打开和URL之间的连接
            URLConnection connection = realUrl.openConnection();
            // 设置通用的请求属性
            connection.setRequestProperty("accept", "*/*");
            connection.setRequestProperty("connection", "Keep-Alive");
            connection.setRequestProperty("user-agent",
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            // 建立实际的连接
            connection.connect();
//            // 获取所有响应头字段
//            Map<String, List<String>> map = connection.getHeaderFields();
//            // 遍历所有的响应头字段
//            for (String key : map.keySet()) {
//               log.info(key + "--->" + map.get(key));
//            }
            // 定义 BufferedReader输入流来读取URL的响应
            in = new BufferedReader(new InputStreamReader(
                    connection.getInputStream(),"UTF-8"));
            String line;
            while ((line = in.readLine()) != null) {
            	buffer.append(line);
            }
            line = buffer.toString();
            jsonObject = JSONObject.fromObject(line.substring(line.indexOf("{")));
        } catch (Exception e) {
        	log.info("==SocialController==sendPost== 发送GET请求出现异常！" + e);
            e.printStackTrace();
        }
        // 使用finally块来关闭输入流
        finally {
            try {
                if (in != null) {
                    in.close();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return jsonObject;
    }
	
	
	// 发送GET请求
	public static JSONArray sendGet1(String url, String param) {
		JSONArray jarray = null;
		StringBuffer buffer = new StringBuffer();
		BufferedReader in = null;
		try {
			String urlNameString = url + "?" + param;
			URL realUrl = new URL(urlNameString);
			// 打开和URL之间的连接
			URLConnection connection = realUrl.openConnection();
			// 设置通用的请求属性
			connection.setRequestProperty("accept", "*/*");
			connection.setRequestProperty("connection", "Keep-Alive");
			connection.setRequestProperty("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
			// 建立实际的连接
			connection.connect();
			// 定义 BufferedReader输入流来读取URL的响应
			in = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
			String line;
			while ((line = in.readLine()) != null) {
				buffer.append(line);
			}

			line = buffer.toString();
			jarray = JSONArray.fromObject(line);
		} catch (Exception e) {
			log.info("==SocialController==sendGet1== 发送GET请求出现异常！" + e);
			e.printStackTrace();
		}
		// 使用finally块来关闭输入流
		finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return jarray;
	}


}
