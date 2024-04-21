package com.hilary.ping;

/**
 * @author һ˫��Ьһ����
 *
 */
public class IPUnit {
	/**
	 * ��ip��ַ���ɳ�����
	 * @param ip ��ֵ�ʮ����IP��ַ
	 * @return ������IP
	 */
	public static long ip2long(String ip) {
		String[] ips = ip.split("[.]");
		return 16777216L * Long.parseLong(ips[0]) + 65536L * Long.parseLong(ips[1]) + 256 * Long.parseLong(ips[2])
				+ Long.parseLong(ips[3]);
	}

	/**
	 * @param ip ������IP
	 * @return ���ʮ����ip
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
