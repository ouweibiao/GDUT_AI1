package com.sxl.controller;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import com.sxl.util.JacksonJsonUtil;
import com.sxl.util.DBHelper;

public class MyController extends BaseController {
	@Autowired
	public DBHelper db;
	
	public Map getAdmin(HttpServletRequest request){
		Map customerBean = (Map)request.getSession().getAttribute("adminBean");
		return customerBean;
	}
	public ResponseEntity<String> renderMsg(Boolean status, String msg) {
		if (StringUtils.isEmpty(msg)) {
			msg = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("{");
		sb.append("\"status\":\"" + status + "\",\"msg\":\"" + msg + "\"");
		sb.append("}");
		ResponseEntity<String> responseEntity = new ResponseEntity<String>(
				sb.toString(), initHttpHeaders(), HttpStatus.OK);
		return responseEntity;
	}
	
	public void writeToExcel(HSSFWorkbook wb, String fileName,HttpServletResponse response)
			throws IOException {
		fileName = (fileName == null || fileName.equals("")) ? "result"
				: fileName;
		fileName = java.net.URLEncoder.encode(fileName, "UTF-8").replace('+',
				' ');
		response.reset();
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-Disposition", "attachment;filename="
				+ fileName + ".xls");
		wb.write(response.getOutputStream());
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}
	
	public ResponseEntity<String> renderData(Boolean status, String msg,
			Object obj) {
		if (StringUtils.isEmpty(msg)) {
			msg = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("{");
		sb.append("\"status\":\"" + status + "\",\"msg\":\"" + msg + "\",");
		sb.append("\"data\":" + JacksonJsonUtil.toJson(obj) + "");
		sb.append("}");
		ResponseEntity<String> responseEntity = new ResponseEntity<String>(
				sb.toString(), initHttpHeaders(), HttpStatus.OK);
		return responseEntity;
	}
	
	public ResponseEntity<String> renderComboBoxAjax(Object obj) {
		ResponseEntity<String> responseEntity = new ResponseEntity<String>(
				JacksonJsonUtil.toJson(obj), initHttpHeaders(), HttpStatus.OK);
		return responseEntity;
	}
}
