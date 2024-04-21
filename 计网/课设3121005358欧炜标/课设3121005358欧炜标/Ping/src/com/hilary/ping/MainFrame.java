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
	private JTextField ip;//����IP���ı���
	private JButton command;//���ư�ť
	private TextArea info;//���������ı���
	
	public MainFrame(){
		setTitle("Ping����������ʵ��");// ���ô������
		setLayout(new BorderLayout());//���ô���Ϊ�߽粼��
		Box box=Box.createHorizontalBox();//����һ��ˮƽ������
		box.add(new JLabel("������IP��IP�Σ�"));
		box.add(Box.createHorizontalStrut(8));//���
		ip=new JTextField(20);//�ı����С
		box.add(ip);
		box.add(Box.createHorizontalStrut(8));
		command=new JButton("Ping");
		box.add(command);
		JPanel p=new JPanel(new BorderLayout());//�½�һ�����
		p.add(box,BorderLayout.CENTER);//�����Ӽ��������м�
		add(p,BorderLayout.NORTH);//����������ڱ߽粼�ֵı���
		p.add(Box.createHorizontalStrut(5),BorderLayout.EAST);
		p.add(Box.createHorizontalStrut(5),BorderLayout.WEST);//���ˮƽ���򱱱ߵļ��
		p.add(Box.createVerticalStrut(8),BorderLayout.NORTH);
		
		info=new TextArea();//�½�һ�������Ϣ��
		info.setEditable(false);
		p=new JPanel(new BorderLayout());//�½�һ�����
		p.add(info,BorderLayout.CENTER);//�������Ϣ���������м�
		p.add(Box.createVerticalStrut(10),BorderLayout.NORTH);//�������߽���
		p.add(Box.createVerticalStrut(10),BorderLayout.SOUTH);
		p.add(Box.createHorizontalStrut(10),BorderLayout.WEST);
		p.add(Box.createHorizontalStrut(10),BorderLayout.EAST);
		add(p,BorderLayout.CENTER);//����������ڱ߽粼�ֵ��м�
		pack();//���ݿռ��������Ĵ�С
		setLocationRelativeTo(null);//�����������ʾ
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//�ر�
		
		
		command.addActionListener(new ActionListener(){//��Ӱ�ť�Ķ���������
			@Override
			public void actionPerformed(ActionEvent arg0) {
				// TODO Auto-generated method stub
				if(ip.getText().equals("")){
					JOptionPane.showMessageDialog(null,"����ip��ַΪ��");//���û������ip��ַ������ʾ����ip��ַΪ��
				}else{
					command.setEnabled(false);
					new Thread(new PingRunnable(ip.getText())).start();//ִ��ping�߳�
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
			if(pos<0){//û�г��֡�-���������ip�ǵ���IP
				ips.offer(ip_address);//����
			}else{//����С�-�����������ip�ν���
				String temp[]=ip_address.split("-");//���������-�������-���ҵ�Ԫ�ؼӽ�������
				long ip_from,ip_to;
				if(temp.length!=2){//�������ĳ��Ȳ�Ϊ2�������
					info.append("�����IP��ַ������");
				}else{
					ip_from=IPUnit.ip2long(temp[0]);//��ʼ��ipΪ��һ������ֵ
					ip_to=IPUnit.ip2long(temp[1]);//����ipΪ���һ������ֵ
					for(long i=ip_from;i<=ip_to;i++){
						ips.offer(IPUnit.long2ip(i));//IP��ַ��һ��������
					}
				}
			}
			Ping ping;
			while(!ips.isEmpty()){
				ip_address=ips.poll();//����
				ping=new Ping(ip_address);
				if(ping.ping()){
					info.append("Ping "+ip_address+"��ʱ"+ping.getUsage()+"ms,����ʱ��:"+ping.getTtl()+"\n");
				}else{
					info.append("��ַ"+ip_address+"���ɴ�\n");//���ı����������
				}
			}
			command.setEnabled(true);//��ť���԰�
		}
	}
}