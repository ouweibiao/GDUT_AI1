<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script>
var ctx='${ctx}';
</script>
<!DOCTYPE>
<html>
<head>
<title>药品管理系统</title>
<link type="text/css" rel="stylesheet" href="${ctx }/resource/index/one/css/style.css" />
<script type="text/javascript" src="${ctx }/resource/index/one/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="${ctx }/resource/index/one/js/menu.js"></script>
</head>

<body>
<div class="top"></div>
<div id="header">
	<div class="logo">药品管理系统</div>
	<div class="navigation">
		<ul>
		 	<li>欢迎您！</li>
			<li><a href="">${adminBean.username }</a></li>
			<%--
			<li><a href="">修改密码</a></li>
			<li><a href="">设置</a></li> --%>
			<li><a href="${ctx }/adminLogin/out.html">退出</a></li>
		</ul>
	</div>
</div>
<div id="content">
	<div class="left_menu">
	<ul id="nav_dot">
			<li>
	          <h4 class="M1"><span></span>个人中心</h4>
	          <div class="list-item none">
	            <a href='${ctx}/admin/password.html' target="page">修改密码</a>
	          </div>
	        </li>
			<li>
	          <h4 class="M1"><span></span>供货商管理</h4>
	          <div class="list-item none">
	            <a href='${ctx}/admin/ghs/frame.html?flag=1' target="page">供货商列表</a>
	          </div>
	        </li>
			<li>
	          <h4 class="M1"><span></span>销售人员管理</h4>
	          <div class="list-item none">
	            <a href='${ctx}/admin/xs/frame.html?flag=1' target="page">销售人员列表</a>
	          </div>
	        </li>
			<li>
	          <h4 class="M1"><span></span>药品管理</h4>
	          <div class="list-item none">
	            <a href='${ctx}/admin/yp/frame.html?flag=1' target="page">药品列表</a>
	          </div>
	        </li>
			<li>
	          <h4 class="M1"><span></span>医院管理</h4>
	          <div class="list-item none">
	            <a href='${ctx}/admin/yy/frame.html?flag=1' target="page">医院列表</a>
	          </div>
	        </li>
	        <li>
	          <h4 class="M1"><span></span>药品进出流向管理</h4>
	          <div class="list-item none">
	            <a href='${ctx}/admin/flow/frame.html?flag=1' target="page">药品进出流向列表</a>
	            <a href='${ctx}/admin/yp/frame2.html' target="page">库存管理</a>
	          </div>
	        </li>
	        <li>
	          <h4 class="M1"><span></span>回款管理</h4>
	          <div class="list-item none">
	            <a href='${ctx}/admin/flow/frame2.html?flag=1' target="page">回款药品流向列表</a>
	            <a href='${ctx}/admin/tj/tj1.html' target="page">月回款金额统计</a>
	          </div>
	        </li>
	        <li>
	          <h4 class="M1"><span></span>销售管理</h4>
	          <div class="list-item none">
	            <a href='${ctx}/admin/all/frame.html?flag=1' target="page">医院流向查询</a>
	            <a href='${ctx}/admin/all/frame.html?flag=2' target="page">药品流向查询</a>
	            <a href='${ctx}/admin/all/frame.html?flag=3' target="page">销售人员销售情况查询</a>
	            <a href='${ctx}/admin/all/list4.html' target="page">销售日报表</a>
	            <a href='${ctx}/admin/all/list5.html' target="page">销售月报表</a>
	          </div>
	        </li>
 	 </ul>
		</div>
		<div class="m-right">
			<div class="main">
				<iframe src="${ctx }/admin/main.html" width="100%" height="100%" frameborder="0" scrolling="yes" name="page"></iframe>
			</div>
		</div>
</div>
<div class="bottom"></div>
<div id="footer"><p>药品管理系统</p></div>
<script>navList(12);</script>
</body>
</html>

