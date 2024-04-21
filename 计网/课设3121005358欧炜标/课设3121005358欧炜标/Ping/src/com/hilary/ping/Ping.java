package com.hilary.ping;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Ping {
	
	private static final int TIME_OUT=3000;//��ʱ��3������ 
	private String ip;
	private int ttl;//����ʱ��
	private int usage;//��ʱ
	private Runtime runtime;
	private Pattern pattern;
	
	public Ping(String ip){
		this.ip=ip;
		runtime=Runtime.getRuntime(); // ��Ҫִ�е�ping����,��������windows��ʽ������
		 // ͨ�� compile ��̬����ʵ���� Pattern ����  ����������ƥ���ʱ��TTl��������ʽ
		pattern=Pattern.compile("(\\d+)ms\\s+TTL=(\\d+)",Pattern.CASE_INSENSITIVE);
		ttl=0;
		usage=0;
	}
	
	public boolean ping(){
		try {
			//ֱ�ӵ���ϵͳ��ping�����Ҫ���͵Ļ����������͵ȴ�ÿ�λظ��ĳ�ʱʱ�䣨ms��
			Process p=runtime.exec("ping "+ip+" -n 1 -w "+TIME_OUT);
			if(p==null)return false;
			BufferedReader buff=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			Matcher m;
			while((line=buff.readLine())!=null){
				m=pattern.matcher(line);
				if(m.find()){
					usage=Integer.parseInt(m.group(1));
					ttl=Integer.parseInt(m.group(2));
					return true;
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
	
	public int getTtl(){
		return this.ttl;
	}
	
	public int getUsage(){
		return this.usage;
	}
}
