package com.sxl.util;


import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;

/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class HssfHelper {
	public HSSFFont headFont;
	public HSSFCellStyle headStyle;
	public HSSFWorkbook wb;

	public HssfHelper() {
		wb = new HSSFWorkbook();
		headFont = wb.createFont();
		headFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		headFont.setColor(HSSFColor.BLACK.index);

		headStyle = wb.createCellStyle();
		headStyle.setFont(headFont);
		headStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		headStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	}

	public HSSFCell createCell(HSSFWorkbook wb, HSSFRow row, int column,
			int align, int valign) {
		HSSFCell cell = row.createCell((short) column);
		HSSFCellStyle cellStyle = wb.createCellStyle();
		cellStyle.setAlignment((short) align);
		cellStyle.setVerticalAlignment((short) valign);
		cell.setCellStyle(cellStyle);
		cell.setEncoding((short) 1); // ֧�����ĵ���
		return cell;
	}
	
	public HSSFCell createHeadCell(HSSFWorkbook wb, HSSFRow row, int column) {
		HSSFFont headFont = wb.createFont();
		headFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		headFont.setColor(HSSFColor.BLACK.index);
		HSSFCellStyle headStyle = wb.createCellStyle();
		headStyle.setFont(headFont);
		headStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		headStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		HSSFCell cell = row.createCell((short) column);
		cell.setEncoding((short) 1); // ֧�����ĵ���
		cell.setCellStyle(headStyle);
		return cell;
	}

	/**
	 * ȱʡ���뷽ʽΪ:����
	 * 
	 * @param wb
	 * @param row
	 * @param column
	 * @return
	 */
	public HSSFCell createCenterMiddleCell(HSSFWorkbook wb, HSSFRow row,
			int column) {
		HSSFCell cell = row.createCell((short) column);
		HSSFCellStyle cellStyle = wb.createCellStyle();
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		cell.setCellStyle(cellStyle);
		cell.setEncoding((short) 1); // ֧�����ĵ���
		return cell;
	}

	public HSSFCell createCell(HSSFWorkbook wb, HSSFRow row, int column) {
		HSSFCell cell = row.createCell((short) column);
		cell.setEncoding((short) 1); // ֧�����ĵ���
		return cell;
	}
	
	public void merge(HSSFSheet sheet, int row1, int col1, int row2, int col2){
		sheet.addMergedRegion(new Region(row1, (short) col1, row2,(short) col2));
	}

	public static void main(String args[]) throws Exception {
		HssfHelper hssfHelper = new HssfHelper();
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet("new sheet");
		HSSFRow row = sheet.createRow((short) 2);
		// HSSFCell cell=hssfHelper.createCell(wb, row,
		// 0,HSSFCellStyle.ALIGN_CENTER,HSSFCellStyle.VERTICAL_CENTER);
		HSSFCell cell = hssfHelper.createCell(wb, row, 2);
		cell.setCellValue("���Ĳ���");
		FileOutputStream fileOut = new FileOutputStream("workbook.xls");
		System.out.println("BOLD:" + HSSFFont.BOLDWEIGHT_BOLD);
		wb.write(fileOut);
		fileOut.close();
	}


	public HSSFCellStyle createCellStyle(HSSFWorkbook wb, HSSFFont font,
			short valign, short align) {
		HSSFCellStyle cellStyle1 = wb.createCellStyle();
		if (font != null)
			cellStyle1.setFont(font);
		if (valign != -1)
			cellStyle1.setVerticalAlignment(valign);
		if (align != -1)
			cellStyle1.setAlignment(align);
		return cellStyle1;
	}

	public HSSFRow createRow(HSSFSheet sheet, int rowIndex) {
		HSSFRow row = sheet.createRow(rowIndex);
		return row;
	}

	/**
	 * eg: new HssfHelper().export(list, new String[][]{ {"�û�����", "MSISDN"},
	 * {"����", "NAME"}, {"Ͷ������", "COMPLAIN_TYPE"}, {"������ˮ��","TASKNO"},
	 * {"¼����ˮ��","RECORDNO"}, {"Ͷ������","COMPLAIN_CONTENT"}});
	 * 
	 * @param list
	 * @param map
	 * @return
	 */
	public HSSFWorkbook export(List list, String[][] map, String sheetName) {
		HssfHelper hssfHelper = new HssfHelper();
		HSSFSheet sheet = wb.createSheet(sheetName);
		HSSFRow row = sheet.createRow((short) 0);
		HSSFCell cell = null;
		for (int i = 0; i < map.length; i++) {
			cell = hssfHelper.createCell(wb, row, i);
			cell.setCellStyle(headStyle);
			cell.setCellValue(map[i][0]);
		}
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((short) i + 1);
			Map hash = (Map) list.get(i);
			for (int j = 0; j < map.length; j++) {
				hssfHelper.createCell(wb, row, j).setCellValue(
						notEmpty(hash.get(map[j][1])));
			}
		}
		return wb;
	}

	
	



	public String getCellStringValue(HSSFCell cell) {
		DecimalFormat df = new DecimalFormat();
		if (cell == null)
			return "";
		switch (cell.getCellType()) {
			case HSSFCell.CELL_TYPE_STRING :
				return cell.getStringCellValue().trim();
			case HSSFCell.CELL_TYPE_NUMERIC :
				// System.out.println(String.valueOf(cell.getNumberValue()));
				try {
					return df.parse(String.valueOf(cell.getNumericCellValue()))
							.toString().trim();
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			default :
				return "";
		}
	}

	
	
	public HSSFWorkbook export(List list,String sheet_name )
	{
		HssfHelper hssfHelper = new HssfHelper();
		HSSFSheet sheet = wb.createSheet(sheet_name);
		HSSFRow row;
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((short) i );
			Map map = (Map) list.get(i);
			Object[] values=map.values().toArray();
			for (int j = 0; j < values.length; j++) {
				hssfHelper.createCell(wb, row, j).setCellValue(
						notEmpty(values[j]));
			}
		}
		return wb;
	}
	
	 public static  String notEmpty(Object value){
		    /*** 使null值转锟斤拷锟斤拷""*/
		        if(value == null){
		            value = "";
		        }
		        return String.valueOf(value);
		    }
	 
	 public int importExcelToTable(HSSFWorkbook wb, short[] map,List<Object[]> list) {
			HSSFSheet sheet = wb.getSheetAt(0);
			if (sheet == null) {
				return -3;
			}
			Iterator iter = sheet.rowIterator();
			for (int i = 0; iter.hasNext(); i++) {
				
				HSSFRow row = (HSSFRow) iter.next();
				if (i == 0) {
					continue;
				}
				Object[] params = new Object[map.length];
				for (int j = 0; j < map.length; j++) {
					HSSFCell cell = row.getCell(map[j]);
					params[j] = getCellStringValue(cell);
				}
				list.add(params);
			}
			return 1;
		}
	 
	 
	 public void downloadFile(String fileName,HttpServletRequest request,HttpServletResponse response)throws IOException {
			String file_path =request.getRealPath("/") + "/download/temp/";
			fileName = java.net.URLEncoder.encode(fileName, "UTF-8").replace('+',' ');
			File downfile = new File(file_path+fileName);
			ServletOutputStream out1 = response.getOutputStream();

			if (!downfile.exists()) {
				response.setContentType("application/x-download");
				out1.print("file doesn't exist");
				return;
			} else {
				response.setContentType("application/x-download");
				response.setHeader("Content-Disposition", "attachment; filename=\""
						+ fileName + "\"");
				response.setHeader("Cache-Control",
						"must-revalidate, post-check=0, pre-check=0");
				response.setHeader("Pragma", "public");
			}
			BufferedInputStream bis = null;
			BufferedOutputStream bos = null;
			try {
				bis = new BufferedInputStream(new FileInputStream(downfile));
				bos = new BufferedOutputStream(out1);
				byte[] buff = new byte[2048];
				int bytesRead;
				while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
					bos.write(buff, 0, bytesRead);
				}
			} catch (IOException e) {
				throw e;
			} finally {
				if (bis != null)
					bis.close();
				if (bos != null)
					bos.close();
			}
		}
	 
}
