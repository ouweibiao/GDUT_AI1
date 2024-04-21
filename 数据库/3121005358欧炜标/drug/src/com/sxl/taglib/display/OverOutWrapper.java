package com.sxl.taglib.display;

import org.displaytag.decorator.TableDecorator;

/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class OverOutWrapper extends TableDecorator {   
    public OverOutWrapper(){   
        super();   
    }   
    @Override  
    public String addRowId() {   
        return "i_d\" onmouseover=\"if (typeof(window.m_over)=='function') window.m_over(this);\" onmouseout=\"if (typeof(window.m_out)=='function') window.m_out(this);\" ";   
    }   
}  
