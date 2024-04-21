package com.sxl.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

/**
 * 通过java获取图片的宽和高
 * 
 * @author sunlightcs 2011-6-1 http://hi.juziku.com/sunlightcs/
 */
/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class ImageTools {

	/**
	 * 获取图片宽度
	 * 
	 * @param file
	 *            图片文件
	 * @return 宽度
	 */
	public static int getImgWidth(File file) {
		InputStream is = null;
		BufferedImage src = null;
		int ret = -1;
		try {
			is = new FileInputStream(file);
			src = javax.imageio.ImageIO.read(is);
			ret = src.getWidth(null); // 得到源图宽
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ret;
	}

	/**
	 * 获取图片高度
	 * 
	 * @param file
	 *            图片文件
	 * @return 高度
	 */
	public static int getImgHeight(File file) {
		InputStream is = null;
		BufferedImage src = null;
		int ret = -1;
		try {
			is = new FileInputStream(file);
			src = javax.imageio.ImageIO.read(is);
			ret = src.getHeight(null); // 得到源图高
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ret;
	}
}
