<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=utf-8"%>
<%@ include file="/taglibs.jsp"%>
<%@ taglib uri="http://displaytag.sf.net/el" prefix="display"%>
<style type="text/css">
@import url("${ctx}/admin/displaytag/zdisplaytag.css");
@import url("${ctx}/admin/displaytag/alternative.css");
</style>
<html>
	<body>
		<display:table name="list"
			requestURI="list.html" class="list"
			id="row" cellspacing="0" cellpadding="0" pagesize="10">
			<display:column style="width: 60px;" media="html" title="编号">
				<c:out value="${row_rowNum}" />
			</display:column>
			<display:column title="来访人姓名" property="SEENAME" />
			<display:column title="来访人电话" property="SEEMOBILE" />
			<display:column title="看望老人" property="OLDNAME" />
			<display:column title="登记时间" property="SEEDATE" />
		</display:table>
	</body>
	<script type="text/javascript">
</script>
</html>