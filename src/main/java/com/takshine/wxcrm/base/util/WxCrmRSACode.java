package com.takshine.wxcrm.base.util;

import java.math.BigInteger;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.Security;
import java.security.Signature;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.RSAPrivateKeySpec;
import java.security.spec.RSAPublicKeySpec;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Cipher;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.util.encoders.Base64;

public class WxCrmRSACode {

	public static final String KEY_ALGORITHM = "RSA";
	public static final String KEY_PROVIDER = "BC";
	public static final String SIGNATURE_ALGORITHM = "SHA1WithRSA";

	/**
	 * 初始化密钥对
	 */
	public static Map<String, Object> initKeys(String seed) throws Exception {

		Map<String, Object> keyMap = new HashMap<String, Object>();
		Security.addProvider(new BouncyCastleProvider());
		KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(
				KEY_ALGORITHM, KEY_PROVIDER);

		keyPairGenerator.initialize(1024, new SecureRandom(seed.getBytes()));
		KeyPair pair = keyPairGenerator.generateKeyPair();
		RSAPublicKey rsaPublicKey = (RSAPublicKey) pair.getPublic();
		RSAPrivateKey rsaPrivateKey = (RSAPrivateKey) pair.getPrivate();

		KeyFactory factory = KeyFactory
				.getInstance(KEY_ALGORITHM, KEY_PROVIDER);
		RSAPublicKeySpec pubKeySpec = new RSAPublicKeySpec(new BigInteger(
				rsaPublicKey.getModulus().toString()), new BigInteger(
				rsaPublicKey.getPublicExponent().toString()));
		RSAPrivateKeySpec priKeySpec = new RSAPrivateKeySpec(new BigInteger(
				rsaPrivateKey.getModulus().toString()), new BigInteger(
				rsaPrivateKey.getPrivateExponent().toString()));

		PublicKey publicKey = factory.generatePublic(pubKeySpec);
		PrivateKey privateKey = factory.generatePrivate(priKeySpec);

		System.out.println("公钥：" + pubKeySpec.getModulus() + "----"
				+ pubKeySpec.getPublicExponent());
		System.out.println("私钥：" + priKeySpec.getModulus() + "----"
				+ priKeySpec.getPrivateExponent());
		keyMap.put("publicKey", publicKey);
		keyMap.put("privateKey", privateKey);

		return keyMap;
	}

	/**
	 * 私钥加密
	 * */
	public static byte[] encryptRSA(byte[] data, PrivateKey privateKey)
			throws Exception {

		Cipher cipher = Cipher.getInstance(KEY_ALGORITHM, KEY_PROVIDER);
		cipher.init(Cipher.ENCRYPT_MODE, privateKey);
		int dataSize = cipher.getOutputSize(data.length);
		int blockSize = cipher.getBlockSize();
		int blockNum = 0;
		if (data.length % blockSize == 0) {
			blockNum = data.length / blockSize;
		} else {
			blockNum = data.length / blockSize + 1;
		}
		byte[] raw = new byte[dataSize * blockNum];
		int i = 0;
		while (data.length - i * blockSize > 0) {
			if (data.length - i * blockSize > blockSize) {
				cipher.doFinal(data, i * blockSize, blockSize, raw, i
						* dataSize);
			} else {
				cipher.doFinal(data, i * blockSize,
						data.length - i * blockSize, raw, i * dataSize);
			}
			i++;
		}

		return raw;
	}

	/**
	 * 生成数字签名
	 * */
	public static String sign(byte[] encoderData, PrivateKey privateKey)
			throws Exception {

		Signature sig = Signature
				.getInstance(SIGNATURE_ALGORITHM, KEY_PROVIDER);
		sig.initSign(privateKey);
		sig.update(encoderData);

		return new String(Base64.encode(sig.sign()));
	}

	/**
	 * 校验数字签名
	 * */
	public static boolean verify(byte[] encoderData, String sign,
			PublicKey publicKey) throws Exception {

		Signature sig = Signature
				.getInstance(SIGNATURE_ALGORITHM, KEY_PROVIDER);
		sig.initVerify(publicKey);
		sig.update(encoderData);

		return sig.verify(Base64.decode(sign));
	}

	public static void main(String[] args) throws Exception {
		//生成公钥、私钥对。公钥公开，注意保管好私钥（如果泄露，则有可能被随意创建license）
		Map<String, Object> keyMap = WxCrmRSACode.initKeys("0");
		PublicKey publicKey = (PublicKey) keyMap.get("publicKey");
		PrivateKey privateKey = (PrivateKey) keyMap.get("privateKey");

		String str = "您好！";
		byte[] encoderData = WxCrmRSACode
				.encryptRSA(str.getBytes(), privateKey);
		//License 生成方式：利用版本号，有效期等一些与此工程有关的信息，生成一段数字签名,私钥用来生成签名
		String sign = WxCrmRSACode.sign(encoderData, privateKey);
		//利用公钥对license进行合法性验证, 公钥用来校验签名
		boolean status = WxCrmRSACode.verify(encoderData, sign, publicKey);

		System.out.println("原文：" + str);
		System.out.println("密文：" + new String(encoderData));
		System.out.println("签名：" + sign);
		System.out.println("验证结果：" + status);
	}
}
