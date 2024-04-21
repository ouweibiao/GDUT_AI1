<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=utf-8"%>
<%@ include file="/taglibs.jsp"%>
<link rel="StyleSheet" href="${ctx }/admin/css/mobile_main.css" type="text/css" />
<html>
	<body class="mobile">
		<form id="form1" name="form1" method="post" action="list.html"
			target="query">
			<table class="mobile">
				<tr class="pageheader" height="6%">
					<td colspan="2">
						来访管理
					</td>
				</tr>
				<tr class="pagesearch" height="5%">
					<td style="text-align: left;">
						&nbsp;&nbsp;
						来访人姓名：
						<input type="text" name="name" style="width:100px;">
						&nbsp;&nbsp;
						<input type="button" class="btn" value="查 询" onClick="sch();" />
						&nbsp;&nbsp;
						<input type="button" class="btn" value="新 增" onClick="add();" />
					</td>
				</tr>
			</table>
			<iframe id="query" name="query" frameborder="0" height="88%"
				width="100%" scrolling="yes"></iframe>
		</form>
		<script>
		sch();
		function sch() {
			form1.action="list.html";
			form1.submit();
		}
		function keylog() {
			if(window.event.keyCode == 13){
				sch();
			}
		}
		
		function add(){
			MyWindow.OpenCenterWindow('edit.html','addSee',500,600);
		}
   </script>
	</body>
</html>
