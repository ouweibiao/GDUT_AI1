
package com.sxl.support;

import java.util.Locale;

import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.http.converter.StringHttpMessageConverter;

public class MessageSourceHelper extends StringHttpMessageConverter {
	private ReloadableResourceBundleMessageSource messageSource;

	public String getMessage(String code, Object[] args, String defaultMessage,
			Locale locale) {
		String msg = messageSource.getMessage(code, args, defaultMessage,
				locale);

		return msg != null ? msg.trim() : msg;
	}

	public void setMessageSource(
			ReloadableResourceBundleMessageSource messageSource) {
		this.messageSource = messageSource;
	}
}
