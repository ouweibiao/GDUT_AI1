package com.sxl.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;


/**
 * @author shixiaolong
 * Oct 12, 2012
 */
/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class FlightUtil {
	
	private static String SERVICES_HOST = "www.webxml.com.cn";
    private static String TRAN_QUERY_URL = "http://webservice.webxml.com.cn/webservices/DomesticAirline.asmx/getDomesticAirlinesTime?UserID=";
    
    public static List<Map<String, String>> getAirs(String start, String end, String theDate){
    	List<Map<String, String>> tranList = new ArrayList<Map<String, String>>();
        Document doc;
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        
        try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			
			InputStream is = getSoapInputStream(TRAN_QUERY_URL + "&startCity=" + URLEncoder.encode(start, "utf-8")+ "&lastCity=" + URLEncoder.encode(end, "utf-8")+"&theDate="+theDate);
			doc = db.parse(is);

			NodeList nl = doc.getElementsByTagName("AirlinesTime");
			int len = nl.getLength();
			
			for (int i = 0; i < len; i++)
			{
			    Node n = nl.item(i);
			    NodeList nodeMap = n.getChildNodes();
			    
			    Map<String, String> mapTran = new HashMap<String, String>();
			    if(!nodeMap.item(1).getTextContent().equalsIgnoreCase("没有航班")){
			    	mapTran.put("Company", nodeMap.item(1).getTextContent());
			    	mapTran.put("AirlineCode", nodeMap.item(3).getTextContent());
			    	mapTran.put("StartDrome", nodeMap.item(5).getTextContent());
			    	mapTran.put("ArriveDrome", nodeMap.item(7).getTextContent());
			    	mapTran.put("StartTime", nodeMap.item(9).getTextContent());
			    	mapTran.put("ArriveTime", nodeMap.item(11).getTextContent());
			    	tranList.add(mapTran);
			    }
			}
			is.close();
		} catch (UnsupportedEncodingException e) {
			
			e.printStackTrace();
		} catch (DOMException e) {
			
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			
			e.printStackTrace();
		} catch (SAXException e) {
			
			e.printStackTrace();
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		
        return tranList;
    }
    
    /**
     * 自己写的加载方法
     * @param url
     * @return
     */
    private static InputStream getSoapInputStream(String url)
    {
        InputStream is = null;

        try {
			URL U = new URL(url);
			URLConnection conn = U.openConnection();
			conn.setRequestProperty("Host", SERVICES_HOST);
			conn.connect();
			is = conn.getInputStream();
		} catch (MalformedURLException e) {
			
			e.printStackTrace();
		} catch (IOException e) {
			
			e.printStackTrace();
		}
        return is;
    }
    
	public static void main(String[] args){
		List<Map<String, String>> listTrans = FlightUtil.getAirs("上海", "北京", "2014-03-24");
		for(Map<String,String> m:listTrans){
		    System.out.println("航空公司："+m.get("Company"));
		    System.out.println("航班班次："+m.get("AirlineCode"));
		    System.out.println("起点："+m.get("StartDrome"));
		    System.out.println("终点："+m.get("ArriveDrome"));
		    System.out.println("开始时间："+m.get("StartTime"));
		    System.out.println("到站时间："+m.get("ArriveTime"));
		    System.out.println("--------------------------");
		}
	}
}
