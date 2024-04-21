package com.sxl.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
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
 * @author albaba
 */
/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class WeatherUtil {
	
	private static String SERVICES_HOST = "www.webxml.com.cn";
	
    private static String WEATHER_QUERY_URL = "http://webservice.webxml.com.cn/WebServices/WeatherWS.asmx/getWeather?theUserID=&theCityCode=";
    private static String PROVINCE_QUERY_URL = "http://webservice.webxml.com.cn/WebServices/WeatherWS.asmx/getRegionProvince";
    private static String CITY_QUERY_URL = "http://webservice.webxml.com.cn/WebServices/WeatherWS.asmx/getSupportCityString?theRegionCode=";
    
    /**
     * 获取支持省份
     * @return
     */
    public static List<Map<Integer, String>> getProvice(){
    	
    	List<Map<Integer, String>> provinceList = new ArrayList<Map<Integer, String>>();
        Document doc;
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        
        try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			InputStream is = getSoapInputStream(PROVINCE_QUERY_URL);
			doc = db.parse(is);
			NodeList nl = doc.getElementsByTagName("string");
			
			int len = nl.getLength();
			for (int i = 0; i < len; i++){
			    Node n = nl.item(i);
			    String value = n.getFirstChild().getNodeValue();
			    String[] array = value.split(",");
			    Map<Integer, String> map = new HashMap<Integer, String>();
			    map.put(Integer.parseInt(array[1]), array[0]);
			    provinceList.add(map);
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
		
		return provinceList;
    }
    
    /**
     * 获取支持城市
     * @return
     */
    public static List<Map<Integer, String>> getCity(Integer province){
    	
    	List<Map<Integer, String>> cityList = new ArrayList<Map<Integer, String>>();
        Document doc;
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        
        try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			InputStream is = getSoapInputStream(CITY_QUERY_URL+province);
			doc = db.parse(is);
			NodeList nl = doc.getElementsByTagName("string");
			
			int len = nl.getLength();
			for (int i = 0; i < len; i++){
			    Node n = nl.item(i);
			    String value = n.getFirstChild().getNodeValue();
			    String[] array = value.split(",");
			    Map<Integer, String> map = new HashMap<Integer, String>();
			    map.put(Integer.parseInt(array[1]), array[0]);
			    cityList.add(map);
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
		
		return cityList;
    }
   
    
    /**
     * 通过cityCode获取天气信息
     * @param cityCode
     * @return
     */
    public static List<String> getWeather(int cityCode){
        List<String> weatherList = new ArrayList<String>();
            Document doc;
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            dbf.setNamespaceAware(true);
            
            try {
				DocumentBuilder db = dbf.newDocumentBuilder();
				
				InputStream is = getSoapInputStream(WEATHER_QUERY_URL + cityCode);
				doc = db.parse(is);
				NodeList nl = doc.getElementsByTagName("string");
				
				int len = nl.getLength();
				
				for (int i = 0; i < len; i++)
				{
				    Node n = nl.item(i);
				    String weather = n.getFirstChild().getNodeValue();
				    weatherList.add(weather);
				    System.out.println(weather);
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
        return weatherList;
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
}
