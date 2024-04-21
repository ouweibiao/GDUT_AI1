package com.sxl.taglib.display;



/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class ExcelView extends org.displaytag.export.ExcelView{

	@Override
	public String getMimeType() {
		 return "application/vnd.ms-excel;charset=UTF-8";
	}

	
}
