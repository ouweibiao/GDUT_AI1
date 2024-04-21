<%@page language="java" pageEncoding="UTF-8" contentType="text/html;charset=utf-8"%>
<%@include file="/taglibs.jsp"%>
<%@taglib uri="http://displaytag.sf.net/el" prefix="display"%>
<style type="text/css">
@import url("${ctx}/resource/admin/displaytag/zdisplaytag.css");
@import url("${ctx}/resource/admin/displaytag/alternative.css");
</style>
<html>
	<body>
		<display:table name="list"
			requestURI="list.html" class="list"
			id="row" cellspacing="0" cellpadding="0">
			<display:column style="width:60px;" media="html" title="编号">
				<c:out value="${row_rowNum}"/>
			</display:column>
			<c:if test="${param.flag==1 }">
				<display:column title="药品" property="yp"/>
				<display:column title="医院" property="yy"/>
				<display:column title="时间" property="insertDate"/>
			</c:if>
			<c:if test="${param.flag==2 }">
				<display:column title="医院" property="yy"/>
				<display:column title="药品" property="yp"/>
				<display:column title="时间" property="insertDate"/>
			</c:if>
			<c:if test="${param.flag==3 }">
				<display:column title="销售" property="xs"/>
				<display:column title="药品" property="yp"/>
				<display:column title="时间" property="insertDate"/>
			</c:if>
		<c:if test="${1==1 }"></c:if>
		</display:table>
	</body>
	<script type="text/javascript">
	function updateColumnghsId(ghsId,id){
		if(!confirm("确定要更新为"+ghsId+"吗?")){
			return false;
		}
		var params={id:id,ghsId:ghsId};
		$.post("updateColumnghsId.html",params,function(
				result){
			result=eval("("+result+")");
			if(result.status=="true"||result.status==true){
				alert('成功');
			window.parent.form1.submit();
			}
		});
	}
	function updateColumnxsId(xsId,id){
		if(!confirm("确定要更新为"+xsId+"吗?")){
			return false;
		}
		var params={id:id,xsId:xsId};
		$.post("updateColumnxsId.html",params,function(
				result){
			result=eval("("+result+")");
			if(result.status=="true"||result.status==true){
				alert('成功');
			window.parent.form1.submit();
			}
		});
	}
	function updateColumnypId(ypId,id){
		if(!confirm("确定要更新为"+ypId+"吗?")){
			return false;
		}
		var params={id:id,ypId:ypId};
		$.post("updateColumnypId.html",params,function(
				result){
			result=eval("("+result+")");
			if(result.status=="true"||result.status==true){
				alert('成功');
			window.parent.form1.submit();
			}
		});
	}
	function updateColumnyyId(yyId,id){
		if(!confirm("确定要更新为"+yyId+"吗?")){
			return false;
		}
		var params={id:id,yyId:yyId};
		$.post("updateColumnyyId.html",params,function(
				result){
			result=eval("("+result+")");
			if(result.status=="true"||result.status==true){
				alert('成功');
			window.parent.form1.submit();
			}
		});
	}
	function updateColumnisHk(isHk,id){
		if(!confirm("确定要更新为"+isHk+"吗?")){
			return false;
		}
		var params={id:id,isHk:isHk};
		$.post("updateColumnisHk.html",params,function(
				result){
			result=eval("("+result+")");
			if(result.status=="true"||result.status==true){
				alert('成功');
			window.parent.form1.submit();
			}
		});
	}
	function deleteOne(id){
		if(!confirm("确定要删除吗?")){
			return false;
		}
		var params={id:id};
		$.post("editDelete.html",params,function(
				result){
			result=eval("("+result+")");
			if(result.status=="true"||result.status==true){
				alert('成功');
			window.parent.form1.submit();
			}
		});
	}
	function modifyOne(id){
			MyWindow.OpenCenterWindow('edit.html?id='+id+'&flag=${param.flag}','modify',500,600);
	}
</script>
</html>
