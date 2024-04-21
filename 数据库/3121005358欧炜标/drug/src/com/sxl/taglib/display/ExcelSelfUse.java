package com.sxl.taglib.display;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.displaytag.export.excel.ExcelHssfView;

/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class ExcelSelfUse extends ExcelHssfView{
protected String escapeColumnValue(Object rawValue){
if (rawValue == null)
{
return null;
}
String returnString = ObjectUtils.toString(rawValue);
// escape the String to get the tabs, returns, newline explicit as \t \r \n
returnString = StringEscapeUtils.escapeJava(StringUtils.trimToEmpty(returnString));
// remove tabs, insert four whitespaces instead
returnString = StringUtils.replace(StringUtils.trim(returnString), "\\t", "    ");
// remove the return, only newline valid in excel
returnString = StringUtils.replace(StringUtils.trim(returnString), "\\r", " ");
// unescape so that \n gets back to newline
returnString = StringEscapeUtils.unescapeJava(returnString);

//return returnString;

Pattern p = Pattern.compile("</?[div|span|a][^>]*>", Pattern.CASE_INSENSITIVE);
Matcher m = p.matcher(returnString);
return m.replaceAll("");
}
}
