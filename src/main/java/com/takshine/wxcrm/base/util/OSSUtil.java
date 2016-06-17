package com.takshine.wxcrm.base.util;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.aliyun.oss.OSSClient;
import com.aliyun.oss.model.DeleteObjectsRequest;
import com.aliyun.oss.model.GetObjectRequest;
import com.aliyun.oss.model.ListObjectsRequest;
import com.aliyun.oss.model.OSSObjectSummary;
import com.aliyun.oss.model.ObjectListing;
import com.aliyun.oss.model.ObjectMetadata;

/**
 * 
 * 阿里云OSS工具 <br>
 *
 * 创建日期:2016年1月29日<br>
 * 修改历史:<br>
 * 1. [2016年1月29日]创建文件 by dkload<br>
 */
public class OSSUtil {

	public static final String BUCKET_PIC = PropertiesUtil.getAppContext("aliyun.oss.bucket.pic");
	public static final String BUCKET_JSCSS = PropertiesUtil.getAppContext("aliyun.oss.bucket.jscss");

	public static String endpoint = PropertiesUtil.getAppContext("aliyun.oss.endpoint");
	public static String accessKeyId = PropertiesUtil.getAppContext("aliyun.oss.access.key");
	public static String accessKeySecret = PropertiesUtil.getAppContext("aliyun.oss.access.secret");
	protected static Logger logger = Logger.getLogger(OSSUtil.class.getName());
	private static OSSClient getClient() {
		return new OSSClient(endpoint, accessKeyId, accessKeySecret);
	}

	/**
	 * 
	 * 根据指定key删除在bucket中的对象<br>
	 *
	 * @param bucketName
	 * @param key
	 */
	public static void deleteObject(String bucketName, String key) {
		OSSClient client = getClient();
		try {
			client.deleteObject(bucketName, key);
		} catch (Exception ex) {
			logger.error("deleteObject :出现错误 bucketName:{"+bucketName+"},key:{"+key+"}, error:{"+ex.getMessage()+"}");
		} finally {
			client.shutdown();
		}
	}

	/**
	 * 
	 * 根据前缀批量删除在bucket中的对象<br>
	 *
	 * @param bucketName
	 * @param prefix
	 */
	public static void deleteObjectWithPrefix(String bucketName, String prefix) {
		OSSClient client = getClient();
		try {
			ObjectListing objectListing = client.listObjects(new ListObjectsRequest(bucketName).withPrefix(prefix));
			if (!objectListing.getObjectSummaries().isEmpty()) {
				List<String> keys = new ArrayList<String>();
				for (OSSObjectSummary objectSummary : objectListing.getObjectSummaries()) {
					keys.add(objectSummary.getKey());
				}
				// 批量删除
				client.deleteObjects(new DeleteObjectsRequest(bucketName).withKeys(keys));
			}
		} catch (Exception ex) {
			logger.error("deleteObjectWithPrefix :出现错误 bucketName:{"+bucketName+"},key:{"+prefix+"}, error:{"+ex.getMessage()+"}");
		} finally {
			client.shutdown();
		}
	}

	/**
	 * 
	 * 根据sourceKey查找对象拷贝至destinationKey<br>
	 *
	 * @param bucketName
	 *            说明:oss支持跨bucket拷贝,咱这里只需要bucket内部拷贝,因此就只用了一个bucketName
	 * @param sourceKey
	 * @param destinationKey
	 */
	public static void copyObject(String bucketName, String sourceKey, String destinationKey) {
		OSSClient client = getClient();
		try {
			client.copyObject(bucketName, sourceKey, bucketName, destinationKey);
		} catch (Exception ex) {
			logger.error("copyObject :出现错误 bucketName:{"+bucketName+"},key:{"+sourceKey+"}, error:{"+ex.getMessage()+"}");
		} finally {
			client.shutdown();
		}
	}

	/**
	 * 
	 * 根据前缀sourcePrefix查找对象集合进行批量拷贝至destinationPrefix前缀下<br>
	 *
	 * @param bucketName
	 * @param sourcePrefix
	 * @param destinationPrefix
	 */
	public static void copyObjectWithPrefix(String bucketName, String sourcePrefix, String destinationPrefix) {
		OSSClient client = getClient();
		try {
			ObjectListing objectListing = client.listObjects(new ListObjectsRequest(bucketName).withPrefix(sourcePrefix));
			if (!objectListing.getObjectSummaries().isEmpty()) {
				String sourceKey = null;
				for (OSSObjectSummary objectSummary : objectListing.getObjectSummaries()) {
					sourceKey = objectSummary.getKey();
					client.copyObject(bucketName, sourceKey, bucketName, sourceKey.replace(sourcePrefix, destinationPrefix));
				}
			}
		} catch (Exception ex) {
			logger.error("copyObjectWithPrefix :出现错误 bucketName:{"+bucketName+"},key:{"+sourcePrefix+"}, error:{"+ex.getMessage()+"}");
		} finally {
			client.shutdown();
		}
	}

	/**
	 * 
	 * 根据前缀sourcePrefix查找对象集合进行批量更名为destinationPrefix前缀<br>
	 *
	 * @param bucketName
	 * @param sourcePrefix
	 * @param destinationPrefix
	 */
	public static void renameObjectWithPrefix(String bucketName, String sourcePrefix, String destinationPrefix) {
		OSSClient client = getClient();
		try {
			ObjectListing objectListing = client.listObjects(new ListObjectsRequest(bucketName).withPrefix(sourcePrefix));
			if (!objectListing.getObjectSummaries().isEmpty()) {
				List<String> keys = new ArrayList<String>();
				String sourceKey = null;
				for (OSSObjectSummary objectSummary : objectListing.getObjectSummaries()) {
					sourceKey = objectSummary.getKey();
					client.copyObject(bucketName, sourceKey, bucketName, sourceKey.replace(sourcePrefix, destinationPrefix));
					keys.add(sourceKey);
				}
				// 批量删除
				client.deleteObjects(new DeleteObjectsRequest(bucketName).withKeys(keys));
			}
		} catch (Exception ex) {
			logger.error("renameObjectWithPrefix :出现错误 bucketName:{"+bucketName+"},key:{"+sourcePrefix+"}, error:{"+ex.getMessage()+"}");
		} finally {
			client.shutdown();
		}
	}

	/**
	 * 
	 * 根据前缀prefix查找对象集合,将content中未引用的对象删除<br>
	 *
	 * @param bucketName
	 * @param prefix
	 * @param content
	 */
	public static void cleanObjectWithPrefixAndContent(String bucketName, String prefix, String content) {
		OSSClient client = getClient();
		try {
			ObjectListing objectListing = client.listObjects(new ListObjectsRequest(bucketName).withPrefix(prefix));
			if (!objectListing.getObjectSummaries().isEmpty()) {
				List<String> keys = new ArrayList<String>();
				String sourceKey = null;
				for (OSSObjectSummary objectSummary : objectListing.getObjectSummaries()) {
					sourceKey = objectSummary.getKey();
					sourceKey=sourceKey.replace("%","%25").replace("!","%21").replace("\"","%22").replace("#","%23").replace("$","%24").replace("&","%26").replace("\'","%27");
					if (!content.contains(sourceKey)) {
						keys.add(sourceKey);
					}
				}
				// 批量删除
				if(!keys.isEmpty()){
					client.deleteObjects(new DeleteObjectsRequest(bucketName).withKeys(keys));
				}
			}
		} catch (Exception ex) {
			logger.error("cleanObjectWithPrefixAndContent :出现错误 bucketName:{"+bucketName+"},key:{"+prefix+"}, error:{"+ex.getMessage()+"}");
			ex.printStackTrace();
		} finally {
			client.shutdown();
		}
	}

	public static String uploadFile(String bucketName,String key,InputStream source)throws Exception{
		OSSClient client=null;
		try{
			client = getClient();
			client.putObject(bucketName, key, source);
		}catch (Exception e){
			logger.error("uploadFile :出现错误 bucketName:{"+bucketName+"},key:{"+key+"}, error:{"+e.getMessage()+"}");
		}finally {
			client.shutdown();
		}
		logger.info("uploadOss : 上传后key！" + key);
		return key;
	}

	public static InputStream downLoadFile(String bucketName,String key)throws Exception{
		OSSClient client = getClient();
		try{
			return  client.getObject(bucketName, key).getObjectContent();
		}catch (Exception e){
			logger.error("downLoadFile :出现错误 bucketName:{"+bucketName+"},key:{"+key+"}, error:{"+e.getMessage()+"}");
		}finally {
			client.shutdown();
		}
		return  null;
	}
	public static boolean downLoadFile(String bucketName,String key,File downloadFile)throws Exception{
		OSSClient client = getClient();	
		boolean bool=false;
		try{
			 ObjectMetadata  result =client.getObject(new GetObjectRequest(bucketName, key),downloadFile);
			 bool=true;
		}catch (Exception e){
			logger.error("downLoadFile :出现错误 bucketName:{"+bucketName+"},key:{"+key+"}, error:{"+e.getMessage()+"}");
		}finally {
			client.shutdown();
		}
		return  bool;
	}
	
	 

}
