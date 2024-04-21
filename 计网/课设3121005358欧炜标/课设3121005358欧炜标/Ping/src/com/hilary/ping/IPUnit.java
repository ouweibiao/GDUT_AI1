package com.hilary.ping;

/**
 * @author 一双拖鞋一夏天
 *
 */
public class IPUnit {
	/**
	 * 把ip地址换成长整形
	 * @param ip 点分的十进制IP地址
	 * @return 长整形IP
	 */
	public static long ip2long(String ip) {
		String[] ips = ip.split("[.]");
		return 16777216L * Long.parseLong(ips[0]) + 65536L * Long.parseLong(ips[1]) + 256 * Long.parseLong(ips[2])
				+ Long.parseLong(ips[3]);
	}

	/**
	 * @param ip 长整形IP
	 * @return 点分十进制ip
	 */
	public static String long2ip(long ip) {
		long mask[] = { 0x000000FF, 0x0000FF00, 0x00FF0000, 0xFF000000 };
		long num = 0;
		StringBuffer ipInfo = new StringBuffer();
		for (int i = 0; i < 4; i++) {
			num = (ip & mask[i]) >> (i * 8);
			if (i > 0)
				ipInfo.insert(0, ".");
			ipInfo.insert(0, Long.toString(num, 10));
		}
		return ipInfo.toString();
	}
}
