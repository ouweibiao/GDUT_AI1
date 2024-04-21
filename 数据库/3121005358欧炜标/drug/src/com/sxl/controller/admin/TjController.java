package com.sxl.controller.admin;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sxl.controller.MyController;

@Controller("TjController")
@RequestMapping(value = "/admin/tj")
public class TjController extends MyController {

	@RequestMapping(value = "/tj1")
	public String tj1(Model model, HttpServletRequest request, String flag)
			throws Exception {
		
		String sql="select date_format(insertDate,'%y-%m') months ,sum(case when a.isHk=1 then b.money*a.sl else 0 end) sum1," +
				" sum(case when a.isHk is null then b.money*a.sl else 0 end) sum2 from t_flow a left join t_yp b on a.ypId=b.id " +
				" group by  date_format(insertDate,'%y-%m') ";
		List<Map> list = db.queryForList(sql);
		model.addAttribute("list", list);
		return "/admin/tj/tj1";
	}

	
}
