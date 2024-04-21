<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=utf-8"%>
<%@ include file="/taglibs.jsp"%>
<script type="text/javascript" src="${ctx}/js/easy_validator.pack.js"></script>
<script type="text/javascript" src="${ctx}/js/jquery.bgiframe.min.js"></script>
<link href="${ctx}/css/validate.css" rel="stylesheet" type="text/css" />
<html>
	<head>
		<title>来访信息添加</title>
	</head>
	<body>
		<form id="form1" name="form1"
			method="post">
			<center>
				<table class="mobile" style="width: 95%;">
					<tr class="pageheader">
						<td colspan="2">
							<strong>添加来访信息</strong>
						</td>
					</tr>
					<tr height="25">
						<td class="outDetail" style="width: 30%">
							来访人姓名：
							<label style="font-weight: bold; color: red">
								*
							</label>
						</td>
						<td class="outDetail2">
								<input type="text"  name="seeName"/>
						</td>
					</tr>
					<tr height="25">
						<td class="outDetail" style="width: 30%">
							来访人电话：
							<label style="font-weight: bold; color: red">
								*
							</label>
						</td>
						<td class="outDetail2">
								<input type="text"  name="seeMobile"/>
						</td>
					</tr>
					<tr height="25">
						<td class="outDetail" style="width: 30%">
							看望的老人：
							<label style="font-weight: bold; color: red">
								*
							</label>
						</td>
						<td class="outDetail2">
								<select name="oldInfo">
									<c:forEach items="${list }" var="lists">
										<option value="${lists.ID }@@@${lists.NAME}">${lists.NAME }</option>
									</c:forEach>
								</select>
						</td>
					</tr>
				</table>
			</center>
			<p align="center">
				<br>
					<input type="button" class="btn" value="保  存" onclick="save(this);" />
				<input type="button" class="btn" value="关  闭"
					onclick="window.close();" />
			</p>
		</form>
	</body>
	<script type="text/javascript">
	function save(src) {
		$.post("editSave.html",$("#form1").serializeArray(),
		       function(result){
		        	result = eval("("+result+")");
		    		if(result.status == "true" || result.status == true){
		    			alert('成功');
		    			saveAnd();
		    		}else{
		    			alert('保存失败，请重试');
		    		}
		        }
			);
		
	}

	
</script>
</html>