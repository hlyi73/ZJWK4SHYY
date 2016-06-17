package com.takshine.wxcrm.base.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;

public class MD5Util {
	private static final char DIGITS_LOWER[] = { '0', '1', '2', '3', '4', '5','6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
	private static final char DIGITS_UPPER[] = { '0', '1', '2', '3', '4', '5','6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
	private static final String DEFAULT_ENCODING = "UTF8";
	private static final String ALGORITH = "MD5";
	private static final MessageDigest md = getMessageDigest(ALGORITH);

	/**
	 * MD5(32位的十六进制表示)
	 * 
	 * @param srcStr
	 *            源字符串
	 * @param encode
	 *            编码方式
	 * @return
	 */
	public static String digest(String srcStr, String encode) {
		byte[] rstBytes;
		try {
			rstBytes = md.digest(srcStr.getBytes(encode));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return null;
		}
		return toHex(rstBytes, true);
	}

	/**
	 * 默认使用UTF8编码进行解析
	 * 
	 * @param srcStr
	 *            源字符串
	 * @return
	 */
	public static String digest(String srcStr) {
		return digest(srcStr, DEFAULT_ENCODING);
	}

	/**
	 * 获取摘要处理实例
	 * 
	 * @param algorithm
	 *            摘要的算法
	 * @return
	 */
	private static MessageDigest getMessageDigest(String algorithm) {
		try {
			return MessageDigest.getInstance(algorithm);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 字节码转十六进制的字符串
	 * 
	 * @param bytes
	 *            字节数组
	 * @param flag
	 *            大小写标志,true为小写，false为大写
	 * @return
	 */
	public static String toHex(byte[] bytes, boolean flag) {
		return new String(processBytes2Hex(bytes, flag ? DIGITS_LOWER : DIGITS_UPPER));
	}

	/**
	 * 将字节数组转化为十六进制字符串
	 * 
	 * @param bytes
	 *            字节数组
	 * @param digits
	 *            数字加字母字符数组
	 * @return
	 */
	private static char[] processBytes2Hex(byte[] bytes, char[] digits) {
		// bytes.length << 1肯定是32，左移1位是因为一个字节是8位二进制，一个十六进制用4位二进制表示
		// 当然可以写成l = 32，因为MD5生成的字节数组必定是长度为16的字节数组
		int l = bytes.length << 1;
		char[] rstChars = new char[l];
		int j = 0;
		for (int i = 0; i < bytes.length; i++) {
			// 得到一个字节中的高四位的值
			rstChars[j++] = digits[(0xf0 & bytes[i]) >>> 4];
			// 得到一个字节中低四位的值
			rstChars[j++] = digits[0x0f & bytes[i]];
		}
		return rstChars;
	}
	
	/*
	 * 方法名称：getMD5 
	 * 功    能：字符串MD5加密 
	 * 参    数：待转换字符串 
	 * 返 回 值：加密之后字符串
	 */
	public static  String getMD5(String sourceStr) throws UnsupportedEncodingException {
		String resultStr = "";
		try {
			byte[] temp = sourceStr.getBytes();
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			md5.update(temp);
			// resultStr = new String(md5.digest());
			byte[] b = md5.digest();
			for (int i = 0; i < b.length; i++) {
				char[] digit = { '0', '1', '2', '3', '4', '5', '6', '7', '8',
						'9', 'A', 'B', 'C', 'D', 'E', 'F' };
				char[] ob = new char[2];
				ob[0] = digit[(b[i] >>> 4) & 0X0F];
				ob[1] = digit[b[i] & 0X0F];
				resultStr += new String(ob);
			}
			return resultStr;
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return null;
		}
	}

	public static void main(String[] args) {
		System.out.println(MD5Util.digest("中国"));

	}

}
