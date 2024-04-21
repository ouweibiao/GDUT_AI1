
package com.sxl.controller.admin;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sxl.controller.MyController;

@Controller("ypController")
@RequestMapping(value = "/admin/yp")
public class YpController extends MyController {
	

	@RequestMapping(value = "/frame")
	public String frame(Model model, HttpServletRequest request,String flag)throws Exception {
		return "/admin/yp/frame";
	}
	
	@RequestMapping(value = "/frame2")
	public String frame2(Model model, HttpServletRequest request,String flag)throws Exception {
		return "/admin/yp/frame2";
	}
	
	@RequestMapping(value = "/list")
	public String list(Model model, HttpServletRequest request,String flag,String name)throws Exception {
		String sql="select a.* from t_yp a where 1=1";


	if(name!=null&&!"".equals(name)){
			sql+=" and name like '%"+name+"%'";
		}
		sql+=" order by id desc";
		List list = db.queryForList(sql);
		request.setAttribute("list", list);
		return "/admin/yp/list";
	}
	
	@RequestMapping(value = "/list2")
	public String list2(Model model, HttpServletRequest request,String flag,String name)throws Exception {
		String sql="select a.* from t_yp a where 1=1";


	if(name!=null&&!"".equals(name)){
			sql+=" and name like '%"+name+"%'";
		}
		sql+=" order by id desc";
		List list = db.queryForList(sql);
		request.setAttribute("list", list);
		return "/admin/yp/list2";
	}
	
	@RequestMapping(value = "/editSave")
	public ResponseEntity<String> editSave(Model model,HttpServletRequest request,Long id,String flag
		,String name,String gg,String dw,Integer money,Integer kc) throws Exception{
		int result = 0;
		if(id!=null){
			String sql="update t_yp set name=?,gg=?,dw=?,money=?,kc=? where id=?";
			result = db.update(sql, new Object[]{name,gg,dw,money,kc,id});
		}else{
			String sql="insert into t_yp(name,gg,dw,money,kc) values(?,?,?,?,?)";
			result = db.update(sql, new Object[]{name,gg,dw,money,kc});
		}
		if(result==1){
			return renderData(true,"操作成功",null);
		}else{
			return renderData(false,"操作失败",null);
		}
	}
	
	@RequestMapping(value = "/editSave2")
	public ResponseEntity<String> editSave2(Model model,HttpServletRequest request,Long id,Integer kc) throws Exception{
		int result = 0;
		String sql="update t_yp set kc=? where id=?";
		result = db.update(sql, new Object[]{kc,id});
		if(result==1){
			return renderData(true,"操作成功",null);
		}else{
			return renderData(false,"操作失败",null);
		}
	}
	
	@RequestMapping(value = "/editDelete")
	public ResponseEntity<String> editDelete(Model model,HttpServletRequest request,Long id,String flag) throws Exception {
		
		String sql="delete from t_yp where id=?";
		int result = db.update(sql, new Object[]{id});
		if(result==1){
			return renderData(true,"操作成功",null);
		}else{
			return renderData(false,"操作失败",null);
		}
		
	}
	
	@RequestMapping(value = "/edit")
	public String edit(Model model, HttpServletRequest request,Long id,String flag)throws Exception {
		if(id!=null){
			//修改
			String sql="select * from t_yp where id=?";
			Map map = db.queryForMap(sql,new Object[]{id});
			model.addAttribute("map", map);
		}String sql="";

		return "/admin/yp/edit";
	}
	
	@RequestMapping(value = "/edit2")
	public String edit2(Model model, HttpServletRequest request,Long id,String flag)throws Exception {
		if(id!=null){
			//修改
			String sql="select * from t_yp where id=?";
			Map map = db.queryForMap(sql,new Object[]{id});
			model.addAttribute("map", map);
		}String sql="";

		return "/admin/yp/edit2";
	}
}
