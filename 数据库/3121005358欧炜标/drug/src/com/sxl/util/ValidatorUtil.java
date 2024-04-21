package com.sxl.util;

import java.util.regex.Matcher;  
import java.util.regex.Pattern; 

/**
 * 字段验证工具 
 */
/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class ValidatorUtil {
	
	 static boolean flag = false;
	 static String regex = "";

	 public static boolean check(String str, String regex) {
		 try {
		     Pattern pattern = Pattern.compile(regex);
		     Matcher matcher = pattern.matcher(str);
		     flag = matcher.matches();
		 } catch (Exception e) {
		     flag = false;
		 }
		 return flag;
	 }

	    /**
	     * 验证非空
	     *
	     * @param email
	     * @return
	     */
	 public static boolean checkNotEmputy(String notEmputy) {
		 regex = "^\\s*$";
		 return check(notEmputy, regex) ? false : true;
	 }

	    /**
	     * 验证邮箱
	     *
	     * @param email
	     * @return
	     */
    public static boolean checkEmail(String email) {
		 regex = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
		 return check(email, regex);
    }

	    /**
	     * 验证手机号码
	     *
	     * 移动号码段:139   138   137   136   135   134   147   150   151   152   157   158    159   178  182   183   184   187   188  
	     * 联通号码段:130   131   132   155   156   185   186   145   176  
	     * 电信号码段:133   153   177   180   181   189  
	     *
	     * @param cellphone
	     * @return
	     */
    public static boolean checkCellphone(String cellphone) {
		 regex = "^((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(17[0|6|7|8])|(18[0-9]))\\d{8}$"; 
		 return check(cellphone, regex);
    }
    
    public static  boolean checkPhone(String cellphone) {
		 regex = "^1\\d{10}$"; 
		 return check(cellphone, regex);
    }

	    /**
	     * 验证固话号码
	     *
	     * @param telephone
	     * @return
	     */
    public static boolean checkTelephone(String telephone) {
		 regex = "^(0\\d{2}-\\d{8}(-\\d{1,4})?)|(0\\d{3}-\\d{7,8}(-\\d{1,4})?)$";
		 return  check(telephone, regex);
    }

	    /**
	     * 验证传真号码
	     *
	     * @param fax
	     * @return
	     */
    public static boolean checkFax(String fax) {
		 regex = "^(0\\d{2}-\\d{8}(-\\d{1,4})?)|(0\\d{3}-\\d{7,8}(-\\d{1,4})?)$"; 
		 return check(fax, regex);
    }

	    /**
	     * 验证QQ号码
	     *
	     * @param QQ
	     * @return
	     */
    public static boolean checkQQ(String QQ) {
		 regex = "^[1-9][0-9]{4,} $";
		 return check(QQ, regex);
    }
	
	
	/** 
     * 判断是否为浮点数或者整数 
     * @param str 
     * @return true Or false 
     */  
    public static boolean isNumeric(String str){  
    	regex="^(-?\\d+)(\\.\\d+)?$";
		return check(str, regex);  
    }  
      
   /////////////////////////////////////////////////////////////////////
    /** 
     * 判断字符串是否为合法手机号 11位 13 14 15 18开头 
     * @param str 
     * @return boolean 
     */  
    public static boolean isMobile(String str){  
        if(isEmpty(str))  
            return false;  
        return str.matches("^(13|14|15|18)\\d{9}$");  
    }  
      
    /** 
     * 判断是否为数字 
     * @param str 
     * @return 
     */  
    public static boolean isNumber(String str) {  
        try{  
            Integer.parseInt(str);  
            return true;  
        }catch(Exception ex){  
            return false;  
        }  
    }  
      
          
    /** 
     * 判断字符串是否为非空(包含null与"") 
     * @param str 
     * @return 
     */  
    public static boolean isNotEmpty(String str){  
        if(str == null || "".equals(str))  
            return false;  
        return true;  
    }  
      
    /** 
     * 判断字符串是否为非空(包含null与"","    ") 
     * @param str 
     * @return 
     */  
    public static boolean isNotEmptyIgnoreBlank(String str){  
        if(str == null || "".equals(str) || "".equals(str.trim()))  
            return false;  
        return true;  
    }  
      
    /** 
     * 判断字符串是否为空(包含null与"") 
     * @param str 
     * @return 
     */  
    public static boolean isEmpty(String str){  
        if(str == null || "".equals(str))  
            return true;  
        return false;  
    }  
      
    /** 
     * 判断字符串是否为空(包含null与"","    ") 
     * @param str 
     * @return 
     */  
    public static boolean isEmptyIgnoreBlank(String str){  
        if(str == null || "".equals(str) || "".equals(str.trim()))  
            return true;  
        return false;  
    }  
      
      
    //禁止实例化  
    private ValidatorUtil(){}   
}
