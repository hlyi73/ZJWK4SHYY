package com.takshine.wxcrm.base.util;

import java.awt.BasicStroke;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Shape;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Hashtable;
import org.apache.log4j.Logger;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;

import org.apache.commons.net.ftp.FTPClient;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import com.takshine.wxcrm.controller.DcCrmOperatorController;

/**
 *  二维码工具类
 * @author dengbo
 *
 */
public class QRCodeUtil {  
	protected static Logger logger = Logger
			.getLogger(QRCodeUtil.class.getName());
		private static final String CHARSET = "utf-8";
		private static final String FORMAT_NAME = "JPEG";
		// 二维码尺寸
		private static final int QRCODE_SIZE = 300;
		// LOGO宽度
		private static final int WIDTH = 60;
		// LOGO高度
		private static final int HEIGHT = 60;

		private static BufferedImage createImage(String content, String imgPath,
				boolean needCompress) throws Exception {
			Hashtable<EncodeHintType, Object> hints = new Hashtable<EncodeHintType, Object>();
			hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
			hints.put(EncodeHintType.CHARACTER_SET, CHARSET);
			hints.put(EncodeHintType.MARGIN, 1);
			BitMatrix bitMatrix = new MultiFormatWriter().encode(content,
					BarcodeFormat.QR_CODE, QRCODE_SIZE, QRCODE_SIZE, hints);
			int width = bitMatrix.getWidth();
			int height = bitMatrix.getHeight();
			BufferedImage image = new BufferedImage(width, height,
					BufferedImage.TYPE_INT_RGB);
			for (int x = 0; x < width; x++) {
				for (int y = 0; y < height; y++) {
					image.setRGB(x, y, bitMatrix.get(x, y) ? 0xFF000000
							: 0xFFFFFFFF);
				}
			}
			if (imgPath == null || "".equals(imgPath)) {
				return image;
			}
			// 插入图片
			if(StringUtils.isNotNullOrEmptyStr(imgPath)){
				QRCodeUtil.insertImage(image, imgPath, needCompress);
			}
			return image;
		}

		/**
		 * 插入LOGO
		 * 
		 * @param source
		 *            二维码图片
		 * @param imgPath
		 *            LOGO图片地址
		 * @param needCompress
		 *            是否压缩
		 * @throws Exception
		 */
		private static void insertImage(BufferedImage source, String imgPath,
				boolean needCompress) throws Exception {
			 //new一个URL对象  
	        URL url = new URL(imgPath);  
	        //打开链接  
	        HttpURLConnection conn = (HttpURLConnection)url.openConnection();  
	        //设置请求方式为"GET"  
	        conn.setRequestMethod("GET");  
	        //超时响应时间为5秒  
	        conn.setConnectTimeout(5 * 1000);  
	        //通过输入流获取图片数据  
	        InputStream is = conn.getInputStream(); 
			Image src = ImageIO.read(is);
//			Image src = ImageIO.read(new File(imgPath));
			int width = src.getWidth(null);
			int height = src.getHeight(null);
			if (needCompress) { // 压缩LOGO
				if (width > WIDTH) {
					width = WIDTH;
				}
				if (height > HEIGHT) {
					height = HEIGHT;
				}
				Image image = src.getScaledInstance(width, height,
						Image.SCALE_SMOOTH);
				BufferedImage tag = new BufferedImage(width, height,
						BufferedImage.TYPE_INT_RGB);
				Graphics g = tag.getGraphics();
				g.drawImage(image, 0, 0, null); // 绘制缩小后的图
				g.dispose();
				src = image;
			}
			// 插入LOGO
			Graphics2D graph = source.createGraphics();
			int x = (QRCODE_SIZE - width) / 2;
			int y = (QRCODE_SIZE - height) / 2;
			graph.drawImage(src, x, y, width, height, null);
			Shape shape = new RoundRectangle2D.Float(x, y, width, width, 6, 6);
			graph.setStroke(new BasicStroke(3f));
			graph.draw(shape);
			graph.dispose();
		}

		/**
		 * 生成二维码(内嵌LOGO)
		 * 
		 * @param content
		 *            内容
		 * @param imgPath
		 *            LOGO地址
		 * @param destPath
		 *            存放目录
		 * @param needCompress
		 *            是否压缩LOGO
		 * @param loaPath
		 *            本地存储路径
		 * @throws Exception
		 */
		public static String encode(String openId,String content, String imgPath,
				boolean needCompress,String loaPath) throws Exception {
			try{
				BufferedImage image = QRCodeUtil.createImage(content, imgPath,
						needCompress);
				String filename = openId+".jpeg";
				File file = new File(loaPath+"/"+filename);
				logger.info(file);
				File parentFile = file.getParentFile();
				logger.info(parentFile);
				if(!parentFile.isDirectory()){
					parentFile.mkdirs();
				}
				if(file.exists()){
					file.delete();
					file.createNewFile();
				}else{
					file.createNewFile();
				}
				boolean flag = ImageIO.write(image, FORMAT_NAME, file);
				if(true==flag){
					return filename;
				}else{
					return "0";
				}
			}catch(Exception ex){
				logger.error("QRCodeUtil ----   encode --- error"+ex.toString());
				return "0";
			}
//			mkdirs(destPath);
			//直接存储到ftp服务器
//			ByteArrayOutputStream bs =new ByteArrayOutputStream();
//        	ImageOutputStream imOut =ImageIO.createImageOutputStream(bs);
//			ImageIO.write(image, FORMAT_NAME, imOut);
//			InputStream is =new ByteArrayInputStream(bs.toByteArray());
//			FTPUtil fu = new FTPUtil();  
//        	FTPClient ftp = fu.getConnectionFTP(PropertiesUtil.getAppContext("file.service"),Integer.parseInt(PropertiesUtil.getAppContext("file.service.port")), PropertiesUtil.getAppContext("file.service.uid"), PropertiesUtil.getAppContext("file.service.pwd"));  
//        	if(fu.uploadPic(ftp, PropertiesUtil.getAppContext("file.service.path.qrcode"), filename, is)){
//        		fu.closeFTP(ftp);
//        		return filename;
//        	}else{
//        		fu.closeFTP(ftp);
//        		return "0";
//        	}
		}

		/**
		 * 当文件夹不存在时，mkdirs会自动创建多层目录，区别于mkdir．(mkdir如果父目录不存在则会抛出异常)
		 * @param destPath 存放目录
		 */
//		public static void mkdirs(String destPath) {
//			File file =new File(destPath);    
//			if (!file.exists() && !file.isDirectory()) {
//				file.mkdirs();
//			}
//		}
		
		public static void main(String[] args) throws Exception {  
			String logoPath = "d:/123.jpg";
			String contents = 
					"MECARD:N:MR ZHANG;" + 
		    		"ADR:中国上海徐汇;" + 
		    		"ORG:XXXX;" + 
		    		"DIV:研发一部;" + 
		    		"TIL:高级软件开发工程师;" + 
		    		"TEL:138********;" + 
		    		"EMAIL:ztyjr88@163.com;" + 
		    		"URL:www.baidu.com;" + 
		    		"NOTE:QQ :gomain@vip.qq.com;";
		    QRCodeUtil.encode("asdasd",contents,null,true,"d:/");  
		}  
}  
