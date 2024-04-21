package com.sxl.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class LngLat {
    
    /**
     * 根据经纬度，获取两点间的距离
     * 
     * @author zhijun.wu
     * @param lng1 经度
     * @param lat1 纬度
     * @param lng2
     * @param lat2
     * @return
     *
     * @date 2011-8-10
     */
    public static double distanceByLngLat(double lng1, double lat1, double lng2, double lat2) {
        double radLat1 = lat1 * Math.PI / 180;
        double radLat2 = lat2 * Math.PI / 180;
        double a = radLat1 - radLat2;
        double b = lng1 * Math.PI / 180 - lng2 * Math.PI / 180;
        double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2) + Math.cos(radLat1)
                * Math.cos(radLat2) * Math.pow(Math.sin(b / 2), 2)));
        s = s * 6378137.0;// 取WGS84标准参考椭球中的地球长半径(单位:m)
        s = Math.round(s * 10000) / 10000;

        return s;
    }
    
    public static List<Map<String, String>> decodePoly(String encoded) {
  	  List<Map<String, String>> poly = new ArrayList<Map<String, String>>();
  	  Map<String, String> mapLatLng = null;
  	  
  	  int index = 0, len = encoded.length();
  	  int lat = 0, lng = 0;

  	  while (index < len) {
  	      int b, shift = 0, result = 0;
  	      do {
  	          b = encoded.charAt(index++) - 63;
  	          result |= (b & 0x1f) << shift;
  	          shift += 5;
  	      } while (b >= 0x20);
  	      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  	      lat += dlat;

  	      shift = 0;
  	      result = 0;
  	      do {
  	          b = encoded.charAt(index++) - 63;
  	          result |= (b & 0x1f) << shift;
  	          shift += 5;
  	      } while (b >= 0x20);
  	      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  	      lng += dlng;
  	      
  	      mapLatLng = new HashMap<String, String>();
  	      
  	        Double finalLat = lat * 1E-5;
  	        Double finalLon = lng * 1E-5;
  	        
  	        mapLatLng.put("lat", finalLat+"");
  	        mapLatLng.put("lng", finalLon+"");
  	        poly.add(mapLatLng);
  	  }

  	  return poly;
  	}
    
	public static JSONObject exe(String urlAsString) {
		StringBuilder sb = new StringBuilder("");
		
		try {
			URL url = new URL(urlAsString);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			InputStream in = (InputStream) conn.getContent();
			BufferedReader br = new BufferedReader(new InputStreamReader(in, "UTF-8"));

			String line = null;
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			
			return JSONObject.fromObject(sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		sb.append("{}");
		return JSONObject.fromObject(sb.toString());
	}

    /**
     * 说明：
     * 
     * @author zhijun.wu
     * @param args
     * @throws Exception 
     *
     * @date 2008-5-16
     */
    public static void main(String[] args) throws Exception {
        System.out.println(distanceByLngLat(102.7749, 25.0751, 102.7655, 25.0751));
    }
}
