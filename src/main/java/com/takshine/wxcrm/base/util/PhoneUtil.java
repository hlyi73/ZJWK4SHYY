package com.takshine.wxcrm.base.util;

import java.io.InputStreamReader;

import net.sf.json.JSONObject;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

public class PhoneUtil {
	public static String getPhonePlace(String phone) {
		String url = "http://virtual.paipai.com/extinfo/GetMobileProductInfo?mobile="
				+ phone + "&amount=10000";
		HttpClient client = new DefaultHttpClient();
		HttpGet get = new HttpGet(url);
		String place = "";
		StringBuffer json = new StringBuffer();
		try {
			HttpResponse res = client.execute(get);
			if (res.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
				HttpEntity entity = res.getEntity();
				InputStreamReader reader = new InputStreamReader(
						entity.getContent(), "GBK");

				char[] buff = new char[1024];
				int length = 0;
				while ((length = reader.read(buff)) != -1) {
					json.append(new String(buff, 0, length));
				}
			}
			JSONObject jsonObject = JSONObject.fromObject(json.substring(
					json.indexOf("{"), json.lastIndexOf("}") + 1));
			place = jsonObject.get("province") + ""
					+ jsonObject.get("cityname");
		} catch (Exception e) {
			throw new RuntimeException(e);

		} finally {
			// 关闭连接 ,释放资源
			client.getConnectionManager().shutdown();
		}
		return place;
	}
	
	/**
	 * 根据手机号码获取城市
	 * @param phone
	 * @return
	 */
	public static String getCityByPhone(String phone) {
		String url = "http://virtual.paipai.com/extinfo/GetMobileProductInfo?mobile=" + phone + "&amount=10000";
		HttpClient client = new DefaultHttpClient();
		HttpGet get = new HttpGet(url);
		String place = "";
		StringBuffer json = new StringBuffer();
		try {
			HttpResponse res = client.execute(get);
			if (res.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
				HttpEntity entity = res.getEntity();
				InputStreamReader reader = new InputStreamReader(
						entity.getContent(), "GBK");

				char[] buff = new char[1024];
				int length = 0;
				while ((length = reader.read(buff)) != -1) {
					json.append(new String(buff, 0, length));
				}
			}
			JSONObject jsonObject = JSONObject.fromObject(json.substring(
					json.indexOf("{"), json.lastIndexOf("}") + 1));
			place = ""+jsonObject.get("cityname");
		} catch (Exception e) {
			throw new RuntimeException(e);

		} finally {
			// 关闭连接 ,释放资源
			client.getConnectionManager().shutdown();
		}
		return place;
	}

	public static void main(String[] args) {
		System.out.println(PhoneUtil.getPhonePlace("18007499307"));
	}
}
