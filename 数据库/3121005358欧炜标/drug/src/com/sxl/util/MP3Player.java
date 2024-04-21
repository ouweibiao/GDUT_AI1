package com.sxl.util;

import java.io.BufferedInputStream;
import java.io.FileInputStream;

import javazoom.jl.player.Player;

/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class MP3Player {
	 private String filename;
	    private Player player;
	    
	    public MP3Player(String filename) {
	        this.filename = filename;
	    }
	 
	    public void play() {
	        try {
	            BufferedInputStream buffer = new BufferedInputStream(
	                    new FileInputStream(filename));
	            player = new Player(buffer);
	            player.play();
	        } catch (Exception e) {
	            System.out.println(e);
	        }
	 
	    }
	 
	    public static void main(String[] args) {
	    	MP3Player mp3 = new MP3Player("F://music/yyl.mp3");
	        mp3.play();
	    }
}
