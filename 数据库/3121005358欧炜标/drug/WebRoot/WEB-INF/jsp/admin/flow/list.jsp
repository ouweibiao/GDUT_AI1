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
			id="row" cellspacing="0" cellpadding="0" pagesize="5">
			<display:column style="width:60px;" media="html" title="编号">
				<c:out value="${row_rowNum}"/>
			</display:column>
			<display:column title="供货商" property="name"/>
			<display:column title="销售" property="name1"/>
			<display:column title="药品" property="name2"/>
			<display:column title="医院" property="name3"/>
			<display:column title="数量" property="sl"/>
			<display:column title="时间" property="insertDate"/>
			<display:column title="是否回款">
				<c:if test="${row.isHk=='1' }">是</c:if>
				<c:if test="${row.isHk!='1' }">否</c:if>
			</display:column>
						<c:choose>
							<c:when test="${param.flag==1 }"></c:when>
							<c:when test="${param.flag==2 }"></c:when>
							<c:when test="${param.flag==3 }"></c:when>
							<c:otherwise>
							
							</c:otherwise>
						</c:choose>
			<%--
			<display:column title="修改" style="width:40px;">
				<img src="${ctx}/resource/admin/images/pencil.png"
					onclick="return modifyOne('${row.id}');" style="cursor:hand;"/>
			</display:column>
			 --%>
			<display:column title="删除" style="width:40px;">
				<img src="${ctx}/resource/admin/images/delete.png"
					onclick="return deleteOne('${row.id}');" style="cursor:hand;"/>
			</display:column>
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
