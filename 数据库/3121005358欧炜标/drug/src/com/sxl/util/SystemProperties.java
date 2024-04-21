
package com.sxl.util;

import java.io.*;
import java.util.Properties;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

public class SystemProperties extends PropertyPlaceholderConfigurer{
	private static Properties properties = new Properties();
	private Resource[] resources; 
	
	/**
	 * 初始化资源文件
	 */
	public void init() {
		long lastModified = 0L;
		
		for(Resource r:resources) {
			try {
				if (lastModified != r.getFile().lastModified()) {
					properties.load(r.getInputStream());
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}


	/**
	 * <p>
	 * 根据<key>得到属性</key>
	 * </p>
	 * 
	 * @param key
	 * @return String
	 */
	public String getProperties(String key) {
		return properties.getProperty(key, StringUtils.EMPTY);
	}

	/**
	 * 设置资源文件路径，初始化资源文件
	 * @param locationFiles
	 */
	public void setLocationFiles(String[] locationFiles) {
		resources = new Resource[locationFiles.length];
		
		for(int i=0;i<locationFiles.length;i++) {
			Resource resource = new ClassPathResource(locationFiles[i]);
			resources[i] = resource;
		}
		
		setLocations(resources);
	}
}
