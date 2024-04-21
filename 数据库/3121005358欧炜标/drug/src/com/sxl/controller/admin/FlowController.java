package com.sxl.controller.admin;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sxl.controller.MyController;

@Controller("flowController")
@RequestMapping(value = "/admin/flow")
public class FlowController extends MyController {

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
		return "/admin/flow/frame";
	}

	@RequestMapping(value = "/list")
	public String list(Model model, HttpServletRequest request, String flag,
			String ghsId, String xsId, String ypId, String yyId)
			throws Exception {
		String sql = "select a.*,(select name from t_ghs b where a.ghsId=b.id) name ,(select name from t_xs b where a.xsId=b.id) name1 ,(select name from t_yp b where a.ypId=b.id) name2 ,(select name from t_yy b where a.yyId=b.id) name3  from t_flow a where 1=1";

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
		return "/admin/flow/list";
	}
	
	
	@RequestMapping(value = "/frame2")
	public String frame2(Model model, HttpServletRequest request, String flag)
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
		return "/admin/flow/frame2";
	}

	@RequestMapping(value = "/list2")
	public String list2(Model model, HttpServletRequest request, String flag,
			String ghsId, String xsId, String ypId, String yyId)
			throws Exception {
		String sql = "select a.*,(select name from t_ghs b where a.ghsId=b.id) name ,(select name from t_xs b where a.xsId=b.id) name1 ,(select name from t_yp b where a.ypId=b.id) name2 ,(select name from t_yy b where a.yyId=b.id) name3  from t_flow a where 1=1";

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
		return "/admin/flow/list2";
	}

	@RequestMapping(value = "/editSave")
	public ResponseEntity<String> editSave(Model model,
			HttpServletRequest request, Long id, String flag, Integer ghsId,
			Integer xsId, Integer ypId, Integer yyId, Integer sl,
			String insertDate, String hkType, String isHk) throws Exception {
		int result = 0;
		if (id != null) {
			String sql = "update t_flow set ghsId=?,xsId=?,ypId=?,yyId=?,sl=?,hkType=?,isHk=? where id=?";
			result = db.update(sql, new Object[] { ghsId, xsId, ypId, yyId, sl,
					hkType, isHk, id });
		} else {
			String sql = "insert into t_flow(ghsId,xsId,ypId,yyId,sl,insertDate,hkType,isHk) values(?,?,?,?,?,now(),?,?)";
			result = db.update(sql, new Object[] { ghsId, xsId, ypId, yyId, sl,
					hkType, isHk });
		}
		if (result == 1) {
			return renderData(true, "操作成功", null);
		} else {
			return renderData(false, "操作失败", null);
		}
	}

	@RequestMapping(value = "/editDelete")
	public ResponseEntity<String> editDelete(Model model,
			HttpServletRequest request, Long id, String flag) throws Exception {

		String sql = "delete from t_flow where id=?";
		int result = db.update(sql, new Object[] { id });
		if (result == 1) {
			return renderData(true, "操作成功", null);
		} else {
			return renderData(false, "操作失败", null);
		}

	}
	
	@RequestMapping(value = "/editUpdate")
	public ResponseEntity<String> editUpdate(Model model,
			HttpServletRequest request, Long id, String flag) throws Exception {

		String sql = "update t_flow set isHk=1 where id=?";
		int result = db.update(sql, new Object[] { id });
		if (result == 1) {
			return renderData(true, "操作成功", null);
		} else {
			return renderData(false, "操作失败", null);
		}

	}

	@RequestMapping(value = "/edit")
	public String edit(Model model, HttpServletRequest request, Long id,
			String flag) throws Exception {
		if (id != null) {
			// 修改
			String sql = "select * from t_flow where id=?";
			Map map = db.queryForMap(sql, new Object[] { id });
			model.addAttribute("map", map);
		}
		String sql = "";

		sql = "select * from t_ghs";
		model.addAttribute("ghsList", db.queryForList(sql));

		sql = "select * from t_xs";
		model.addAttribute("xsList", db.queryForList(sql));

		sql = "select * from t_yp";
		model.addAttribute("ypList", db.queryForList(sql));

		sql = "select * from t_yy";
		model.addAttribute("yyList", db.queryForList(sql));

		return "/admin/flow/edit";
	}
}
