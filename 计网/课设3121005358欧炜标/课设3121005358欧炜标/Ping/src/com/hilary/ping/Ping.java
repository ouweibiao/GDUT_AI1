package com.hilary.ping;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Ping {
	
	private static final int TIME_OUT=3000;//超时在3钞以上 
	private String ip;
	private int ttl;//生存时间
	private int usage;//耗时
	private Runtime runtime;
	private Pattern pattern;
	
	public Ping(String ip){
		this.ip=ip;
		runtime=Runtime.getRuntime(); // 将要执行的ping命令,此命令是windows格式的命令
		 // 通过 compile 静态方法实例化 Pattern 对象  ，构造用来匹配耗时和TTl的正则表达式
		pattern=Pattern.compile("(\\d+)ms\\s+TTL=(\\d+)",Pattern.CASE_INSENSITIVE);
		ttl=0;
		usage=0;
	}
	
	public boolean ping(){
		try {
			//直接调用系统的ping命令，求要发送的回显请求数和等待每次回复的超时时间（ms）
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
