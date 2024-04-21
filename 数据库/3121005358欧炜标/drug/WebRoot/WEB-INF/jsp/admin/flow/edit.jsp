<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=utf-8"%>
<%@ include file="/taglibs.jsp"%>
<script type="text/javascript" src="${ctx}/js/easy_validator.pack.js"></script>
<script type="text/javascript" src="${ctx}/js/jquery.bgiframe.min.js"></script>
<script type="text/javascript"
	src="${ctx }/resource/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"
	src="${ctx}/resource/admin/js/ajaxfileupload.js"></script>
<link href="${ctx}/css/validate.css" rel="stylesheet" type="text/css" />
<html>
<head>
<title>信息内容功能</title>
</head>
<body>
	<form id="form1" name="form1" action="" method="post">
		<input type="hidden" value="${param.flag }" name="flag" /> <input
			type="hidden" value="${map.id }" name="id" id="id" />
		<center>
			<table class="mobile" style="width: 95%;">
				<tr class="pageheader">
					<td colspan="2"><strong>信息处理</strong></td>
				</tr>
				<tr height="25">
					<td class="outDetail" style="width: 30%">供货商： <label
						style="font-weight: bold; color: red"> </label></td>
					<td class="outDetail2"><select id="ghsId" name="ghsId">
							<c:forEach items="${ghsList }" var="lists">
								<option value="${lists.id }" ${map.ghsId==lists.id?'selected':'' }>${lists.name
									}</option>
							</c:forEach>
					</select></td>
				</tr>
				<tr height="25">
					<td class="outDetail" style="width: 30%">销售： <label
						style="font-weight: bold; color: red"> </label></td>
					<td class="outDetail2"><select id="xsId" name="xsId">
							<c:forEach items="${xsList }" var="lists">
								<option value="${lists.id }" ${map.xsId==lists.id?'selected':'' }>${lists.name
									}</option>
							</c:forEach>
					</select></td>
				</tr>
				<tr height="25">
					<td class="outDetail" style="width: 30%">药品： <label
						style="font-weight: bold; color: red"> </label></td>
					<td class="outDetail2"><select id="ypId" name="ypId">
							<c:forEach items="${ypList }" var="lists">
								<option value="${lists.id }" ${map.ypId==lists.id?'selected':'' }>${lists.name
									}</option>
							</c:forEach>
					</select></td>
				</tr>
				<tr height="25">
					<td class="outDetail" style="width: 30%">医院： <label
						style="font-weight: bold; color: red"> </label></td>
					<td class="outDetail2"><select id="yyId" name="yyId">
							<c:forEach items="${yyList }" var="lists">
								<option value="${lists.id }" ${map.yyId==lists.id?'selected':'' }>${lists.name
									}</option>
							</c:forEach>
					</select></td>
				</tr>
				<tr height="25">
					<td class="outDetail" style="width: 30%">数量： <label
						style="font-weight: bold; color: red"> </label></td>
					<td class="outDetail2"><input id="sl" type="text"
						value="${map.sl }" name="sl" /></td>
				</tr>
				<%--
				<tr height="25">
					<td class="outDetail" style="width: 30%">是否回款： <label
						style="font-weight: bold; color: red"> </label></td>
					<td class="outDetail2"><select id="isHk" name="isHk">
							<option value="是" ${map.isHk=='是'?'selected':'' }>是</option>
							<option value="否" ${map.isHk=='否'?'selected':'' }>否</option>
					</select></td>
				</tr>
				 --%>
				<c:if test="${1==1 }"></c:if>
				<%--<input name="newDate" id="newDate" value="${map.newDate }" type="text" onClick="WdatePicker()"/> --%>
				<%--
				<tr height="25">
					<td class="outDetail" style="width: 30%">图片： <label
						style="font-weight: bold; color: red"> * </label></td>
					<td class="outDetail2"><input id="f_file" name="cmfile"
						onchange="triggerUpload(this);" title="选择图片" type="file">
						<input class="text" type="hidden" name="img" value="${map.img }">
						<img id="imgUrlShow" style="width: 100px;" src="${ctx}/${map.img }" />
					</td>
				</tr>
				--%>
				<%--
				<tr height="25">
					<td class="outDetail" style="width: 30%">是否特价： <label
						style="font-weight: bold; color: red"> * </label></td>
					<td class="outDetail2">
					<select name="isSale">
							<option value="是" ${map.isSale=='是'?'selected':'' }>是</option>
							<option value="否" ${map.isSale=='否'?'selected':'' }>否</option>
					</select>
				</tr>
				 --%>
				<%--
				<tr height="25">
					<td class="outDetail" style="width: 30%">图书分类的外键： <label
						style="font-weight: bold; color: red"> * </label></td>
					<td class="outDetail2">
					<select name="typeId">
							<c:forEach items="${typeList }" var="lists">
								<option value="${lists.id }" ${map.typeId==lists.id?'selected':'' }>${lists.typeName
									}</option>
							</c:forEach>
					</select>
				</tr>
				 --%>
			</table>
		</center>
		<p align="center">
			<br> <input type="button" class="btn" value="保  存"
				onclick="save(this);" /> <input type="button" class="btn"
				value="关  闭" onclick="window.close();" />
		</p>
	</form>
</body>
<script type="text/javascript">
	function save(src) {
		var sl = $("#sl").val();
		if ($.trim(sl) == '') {
			alert('数量不能为空');
			return false;
		}
		$.post("editSave.html", $("#form1").serializeArray(), function(result) {
			result = eval("(" + result + ")");
			if (result.status == "true" || result.status == true) {
				alert('成功');
				saveAnd();
			} else {
				alert('保存失败，请重试');
			}
		});
	}
	function triggerUpload(src) {
		$.ajaxFileUpload({
			url : '${ctx}/file/upload.json',
			secureuri : false,
			fileElementId : 'f_file',
			dataType : 'json',
			data : {
				fileloc : 'upload/',
				dir : 'temp'
			},
			success : function(data, status) {
				$("input[name='img']").val(data.data.filepath);
				$("#imgUrlShow").attr("src",
						"${ctx}/" + data.data.filepath + "");
			},
			error : function(data, status, e) {
				alert('文件上传失败');
			}
		});
	}
</script>
</html>
