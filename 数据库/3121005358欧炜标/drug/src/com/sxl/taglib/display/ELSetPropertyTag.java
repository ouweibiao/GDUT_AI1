package com.sxl.taglib.display;



/**
 * Licensed under the Artistic License; you may not use this file
 * except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://displaytag.sourceforge.net/license.html
 *
 * THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
 * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 */

import javax.servlet.jsp.JspException;

import org.displaytag.tags.SetPropertyTag;
import org.displaytag.tags.el.ExpressionEvaluator;


/**
 * Adds EL support to SetPropertyTag.
 * @author Fabrizio Giustina
 * @version $Revision: 1081 $ ($Author: fgiust $)
 */
/* 请关注微信公众号：bysjbng,各种免费毕设相关模板提供下载*/
public class ELSetPropertyTag extends SetPropertyTag
{

    /**
     * D1597A17A6.
     */
    private static final long serialVersionUID = 899149338534L;

    /**
     * Expression for the "name" tag attribute.
     */
    private String nameExpr;

    /**
     * Expression for the "value" tag attribute.
     */
    private String valueExpr;

    /**
     * @see org.displaytag.tags.SetPropertyTag#setName(java.lang.String)
     */
    public void setName(String value)
    {
        nameExpr = value;
    }

    /**
     * @see org.displaytag.tags.SetPropertyTag#setValue(java.lang.String)
     */
    public void setValue(String value)
    {
        valueExpr = value;
        try{
            //this.valueExpr = new String(value.getBytes("GBK"),"ISO-8859-1");
          }catch(Exception e){
            this.valueExpr = value;
          }
          super.setValue(this.valueExpr);

    }

    /**
     * @see javax.servlet.jsp.tagext.Tag#doStartTag()
     */
    public int doStartTag() throws JspException
    {
        evaluateExpressions();
        return super.doStartTag();
    }

    /**
     * Evaluates the expressions for all the given attributes and pass results up to the parent tag.
     * @throws JspException for exceptions occurred during evaluation.
     */
    private void evaluateExpressions() throws JspException
    {
        ExpressionEvaluator eval = new ExpressionEvaluator(this, pageContext);

        super.setName(eval.evalString("name", nameExpr)); //$NON-NLS-1$

        if (valueExpr != null)
        {
            super.setValue(eval.evalString("value", valueExpr)); //$NON-NLS-1$
        }
    }

    /**
     * @see javax.servlet.jsp.tagext.Tag#release()
     */
    public void release()
    {
        super.release();
        this.nameExpr = null;
        this.valueExpr = null;
    }

}
