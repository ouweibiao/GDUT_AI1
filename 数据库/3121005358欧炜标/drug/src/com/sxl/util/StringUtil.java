
package com.sxl.util;

import java.util.Random;

import org.apache.commons.lang.StringUtils;

/**
 * Creat date:Feb 25, 2010 9:31:19 AM Author:张胜
 */
public final class StringUtil extends StringUtils {
	private StringUtil() {
	}
	public static void main(String[] args) {
		for (int i = 0; i < 9; ++i) {
			System.out.println(StringUtil.random(6));
		}
		
	}
	/**
	 * 
	 * @param str
	 * @param maxSize
	 * @return String
	 */
	public static String addZeroByMaxSize(String str, int maxSize) {
		String emptyStr = "";
		if (str == null)
			return str;
		for (int i = 0; i < maxSize - str.length(); i++) {
			emptyStr += "0";
		}
		return emptyStr + str;
	}

	public static String random(int size) {
		Random r = new Random();
		String code = "";
		for (int i = 0; i < size; ++i) {
			if (r.nextInt(size) % 2 == 0){		// 偶数位生产随机整数
				code = code + r.nextInt(10);
			} else{					// 奇数产生随机字母包括大小写
				int temp = r.nextInt(52);
				char x = (char) (temp < 26 ? temp + 97 : (temp % 26) + 65);
				code += x;
			}
		}
		return code;
	}
	
	public static String randomNum(int size) {
		Random r = new Random();
		String code = "";
		for (int i = 0; i < size; ++i) {
			code = code + r.nextInt(10);
		}
		return code;
	}
	
	public static final String randomString(int length) {
		Random randGen = null;
		char[] numbersAndLetters = null;
        
		if (length < 1) {
            return null;
        }
        
		if (randGen == null) {
           randGen = new Random();
           numbersAndLetters = ("0123456789abcdefghijklmnopqrstuvwxyz" + "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ").toCharArray();
        }
        
		char [] randBuffer = new char[length];
        for (int i=0; i<randBuffer.length; i++) {
            randBuffer[i] = numbersAndLetters[randGen.nextInt(71)];
        }
        
        return new String(randBuffer);
	}	
}
