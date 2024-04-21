package com.sxl.controller.admin;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sxl.controller.MyController;

@Controller("AllController")
@RequestMapping(value = "/admin/all")
public class AllController extends MyController {

	@RequestMapping(value = "/frame")
	public String frame(Model model, HttpServletRequest request, String flag)
			throws Exception {
		String sql="";
		sql = "select * from t_ghs";
		model.addAttribute("ghsList", db.queryForList(sql));

		sql = "select * from t_xs";
		model.addAttribute("xsList", db.queryForList(sql));

		sql = "select * from t_yp";
		model.addAttribute("ypList", db.queryForList(sql));

		sql = "select * from t_yy";
		model.addAttribute("yyList", db.queryForList(sql));
		return "/admin/all/frame";
	}

	@RequestMapping(value = "/list")
	public String list(Model model, HttpServletRequest request, String flag,
			String ghsId, String xsId, String ypId, String yyId)
			throws Exception {
		String sql = "select a.*,(select name from t_ghs b where a.ghsId=b.id) ghs ,(select name from t_xs b where a.xsId=b.id) xs ,(select name from t_yp b where a.ypId=b.id) yp ,(select name from t_yy b where a.yyId=b.id) yy  from t_flow a where 1=1";

		if (ghsId != null && !"".equals(ghsId)) {
			sql += " and ghsId ="+ghsId;
		}
		if (xsId != null && !"".equals(xsId)) {
			sql += " and xsId ="+xsId;
		}
		if (ypId != null && !"".equals(ypId)) {
			sql += " and ypId ="+ypId;
		}
		if (yyId != null && !"".equals(yyId)) {
			sql += " and yyId ="+yyId;
		}
		sql += " order by id desc";
		List list = db.queryForList(sql);
		request.setAttribute("list", list);
		return "/admin/all/list";
	}
	
	@RequestMapping(value = "/list4")
	public String list4(Model model, HttpServletRequest request, String flag)
			throws Exception {
		
		String sql="select date_format(insertDate,'%y-%m-%d') months ,sum(b.money*a.sl) sum1" +
				"  from t_flow a left join t_yp b on a.ypId=b.id " +
				" group by  date_format(insertDate,'%y-%m-%d') ";
		List<Map> list = db.queryForList(sql);
		model.addAttribute("list", list);
		return "/admin/all/list4";
	}
	
	@RequestMapping(value = "/list5")
	public String list5(Model model, HttpServletRequest request, String flag)
			throws Exception {
		
		String sql="select date_format(insertDate,'%y-%m') months ,sum(b.money*a.sl) sum1 " +
				"  from t_flow a left join t_yp b on a.ypId=b.id " +
				" group by  date_format(insertDate,'%y-%m') ";
		List<Map> list = db.queryForList(sql);
		model.addAttribute("list", list);
		return "/admin/all/list5";
	}

}
