package com.hilary.ping;

import java.awt.BorderLayout;
import java.awt.TextArea;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.LinkedList;
import java.util.Queue;

import javax.swing.Box;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class MainFrame extends JFrame{
	private JTextField ip;//输入IP的文本框
	private JButton command;//控制按钮
	private TextArea info;//输出结果的文本域
	
	public MainFrame(){
		setTitle("Ping程序的设计与实现");// 设置窗体标题
		setLayout(new BorderLayout());//设置窗体为边界布局
		Box box=Box.createHorizontalBox();//创建一个水平的箱子
		box.add(new JLabel("请输入IP或IP段："));
		box.add(Box.createHorizontalStrut(8));//间距
		ip=new JTextField(20);//文本框大小
		box.add(ip);
		box.add(Box.createHorizontalStrut(8));
		command=new JButton("Ping");
		box.add(command);
		JPanel p=new JPanel(new BorderLayout());//新建一个面板
		p.add(box,BorderLayout.CENTER);//把箱子加在面板的中间
		add(p,BorderLayout.NORTH);//将这个面板加在边界布局的北面
		p.add(Box.createHorizontalStrut(5),BorderLayout.EAST);
		p.add(Box.createHorizontalStrut(5),BorderLayout.WEST);//面板水平方向北边的间距
		p.add(Box.createVerticalStrut(8),BorderLayout.NORTH);
		
		info=new TextArea();//新建一个输出信息框
		info.setEditable(false);
		p=new JPanel(new BorderLayout());//新建一个面板
		p.add(info,BorderLayout.CENTER);//把输出信息框加在面板中间
		p.add(Box.createVerticalStrut(10),BorderLayout.NORTH);//设置面板边界间距
		p.add(Box.createVerticalStrut(10),BorderLayout.SOUTH);
		p.add(Box.createHorizontalStrut(10),BorderLayout.WEST);
		p.add(Box.createHorizontalStrut(10),BorderLayout.EAST);
		add(p,BorderLayout.CENTER);//将这个面板加在边界布局的中间
		pack();//根据空间调整窗体的大小
		setLocationRelativeTo(null);//将窗体居中显示
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//关闭
		
		
		command.addActionListener(new ActionListener(){//添加按钮的动作侦听器
			@Override
			public void actionPerformed(ActionEvent arg0) {
				// TODO Auto-generated method stub
				if(ip.getText().equals("")){
					JOptionPane.showMessageDialog(null,"输入ip地址为空");//如果没有输入ip地址，则提示输入ip地址为空
				}else{
					command.setEnabled(false);
					new Thread(new PingRunnable(ip.getText())).start();//执行ping线程
				}
			}
		});
	}
	
	private class PingRunnable implements Runnable{
		
		private String ip_address;
		private Queue<String> ips;
		
		public PingRunnable(String ip){
			ip_address=ip;
			ips=new LinkedList<String>();
		}
		
		@Override
		public void run() {
			// TODO Auto-generated method stub
			int pos=ip_address.indexOf("-");
			if(pos<0){//没有出现“-”，填入的ip是单个IP
				ips.offer(ip_address);//进队
			}else{//如果有“-”，则把整个ip段进队
				String temp[]=ip_address.split("-");//如果遇到“-”，则把-左右的元素加进数组里
				long ip_from,ip_to;
				if(temp.length!=2){//如果数组的长度不为2，则错误
					info.append("输入的IP地址段有误");
				}else{
					ip_from=IPUnit.ip2long(temp[0]);//开始的ip为第一个数组值
					ip_to=IPUnit.ip2long(temp[1]);//最后的ip为最后一个数组值
					for(long i=ip_from;i<=ip_to;i++){
						ips.offer(IPUnit.long2ip(i));//IP地址段一个个进队
					}
				}
			}
			Ping ping;
			while(!ips.isEmpty()){
				ip_address=ips.poll();//出队
				ping=new Ping(ip_address);
				if(ping.ping()){
					info.append("Ping "+ip_address+"耗时"+ping.getUsage()+"ms,生存时间:"+ping.getTtl()+"\n");
				}else{
					info.append("地址"+ip_address+"不可达\n");//在文本域输出内容
				}
			}
			command.setEnabled(true);//按钮可以按
		}
	}
}