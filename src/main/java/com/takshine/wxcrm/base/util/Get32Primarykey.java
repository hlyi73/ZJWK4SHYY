package com.takshine.wxcrm.base.util;

import java.util.Random;
import java.util.UUID;

import org.neo4j.cypher.internal.compiler.v2_1.docbuilders.internalDocBuilder;

public  class Get32Primarykey {

	/***
	 * 随机产生32位16进制字符串
	 * @return
	 */
	public static String getRandom32PK(){
		return UUID.randomUUID().toString().replaceAll("-", "");
	} 
	
	/***
	 * 随机产生32位16进制字符串，以时间开头
	 * @return
	 */
	public static String getRandom32BeginTimePK(){
		String timeStr = DateTime.currentDateTime("yyyyMMddHHmmssSSS");
		String random32 = getRandom32PK();
		return timeStr+random32.substring(17,random32.length());
	}
	
	/***
	 * 随机产生32位16进制字符串，以时间结尾
	 * @return
	 */
	public static String getRandom32EndTimePK(){
		String timeStr = DateTime.currentDateTime("yyyyMMddHHmmssSSS");
		String random32 = getRandom32PK();
		return random32.substring(0,random32.length()-17)+timeStr;
	}
	
	/**
	 * 获取随机的验证码 
	 * @return
	 */
	public static String getRandomValiteCode(int size){
		if(size <= 0) size = 6;//默认6位 
		String randString = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";//随机产生的字符串
		Random random = new Random();//随机种子
		String rst = "";//返回值
		for (int i = 0; i < size; i++) {
			rst += randString.charAt(random.nextInt(36));
		}
		return rst;
	}
	
	/**
	 * 获取8位随机字符串 
	 * @return
	 */
	public static String get8RandomValiteCode(int size){
		if(size <= 0) size = 8;//默认8位 
		String randString = "0123456789";//随机产生的字符串
		Random random = new Random();//随机种子
		String rst = "";//返回值
		for (int i = 0; i < size; i++) {
			rst += randString.charAt(random.nextInt(10));
		}
		return rst;
	}
	
	
	public static void main(String[] args) {
		System.out.println("随机验证码6位:"+getRandomValiteCode(6));
		System.out.println("随机"+Get32Primarykey.getRandom32PK().length()+"位："+Get32Primarykey.getRandom32PK());
		System.out.println("随机"+Get32Primarykey.getRandom32BeginTimePK().length()+"位以时间打头："+Get32Primarykey.getRandom32BeginTimePK());
		System.out.println("随机"+Get32Primarykey.getRandom32EndTimePK().length()+"位以时间结尾："+Get32Primarykey.getRandom32EndTimePK());
		System.out.println(get8RandomValiteCode(8));
	}
}

