var cnt = 2;
function addRow() {
	if(cnt<=document.forms[0].cnt.value)
		cnt=document.forms[0].cnt.value;
	var itemCode='itemCode'+cnt;
	var itemName='itemName'+cnt;
	var itemInputCode='itemInputCode'+cnt;
	tr = document.createElement("TR");
	td1 = document.createElement("TD");
	td2 = document.createElement("TD");
	td3=document.createElement("TD");
	td4=document.createElement("TD");
	td4=document.createElement("TD");
	
	td1.innerHTML = cnt+1;
	td1.align="center";
	td2.innerHTML='<html:text property='+itemCode+'style="width:100%;height:20px" />';
	th2.innerHTML='文件路径';
	td2.colSpan=3;
	td2.innerHTML = '<input type="file" name="'+accPath+'" id="'+accPath+'" style="width:100%;height:20px" value=""><input type="hidden" name="'+accId+'" value="">';
	td3.colSpan=1;
	td3.innerHTML='<BUTTON style="HEIGHT:25px" onClick="deleteRow();">删除</BUTTON><BUTTON style="HEIGHT:25px" onClick="javascript:addRow();">继续添加</BUTTON>';

	accCnt++; 
	
	tr.appendChild(th1);
	tr.appendChild(td1);
	tr.appendChild(th2);
	tr.appendChild(td2);
	tr.appendChild(td3);
    document.all("accessoryList").appendChild(tr);

}

function addRows() {
	if(accCnt<=document.forms[0].accCnt.value)
		accCnt=document.forms[0].accCnt.value;
	var accPath = 'filePath' + accCnt;
	var accTitle='fileTitle'+accCnt;
	var accId='fileId'+accCnt;
	tr = document.createElement("TR");
	th1=document.createElement("TH");
	td1 = document.createElement("TD");
	th2=document.createElement("TH");
	td2 = document.createElement("TD");
	td3=document.createElement("TD");
	th1.innerHTML='附件标题';
	td1.colSpan=2;
	td1.innerHTML = '<input type="text" name="'+accTitle+'" id="'+accTitle+'" style="width:100%;height:20px" value="">';
	th2.innerHTML='文件路径';
	td2.colSpan=2;
	td2.innerHTML = '<input type="file" name="'+accPath+'" id="'+accPath+'" style="width:100%;height:20px" value=""><input type="hidden" name="'+accId+'" value="">';
	td3.colSpan=2;
	td3.innerHTML='&nbsp;&nbsp;&nbsp;<BUTTON style="HEIGHT:25px" onClick="deleteRow();">删除</BUTTON><BUTTON style="HEIGHT:25px" onClick="javascript:addRows();">继续添加</BUTTON>';

	accCnt++; 
	
	tr.appendChild(th1);
	tr.appendChild(td1);
	tr.appendChild(th2);
	tr.appendChild(td2);
	tr.appendChild(td3);
    document.all("accessoryList").appendChild(tr);

}

function addRowPage() {
	if(accCnt<=document.forms[0].accCnt.value)
		accCnt=document.forms[0].accCnt.value;
	var accPath = 'filePath' + accCnt;
	var accTitle='fileTitle'+accCnt;
	var accId='fileId'+accCnt;
	tr = document.createElement("TR");
	th1=document.createElement("TH");
	td1 = document.createElement("TD");
	th2=document.createElement("TH");
	td2 = document.createElement("TD");
	td3=document.createElement("TD");
	th1.innerHTML='附件标题';
	
	td1.innerHTML = '<input type="text" name="'+accTitle+'" id="'+accTitle+'" style="width:100%;height:20px" value="">';
	th2.innerHTML='文件路径';
	td2.colSpan=2;
	td2.innerHTML = '<input type="file" name="'+accPath+'" id="'+accPath+'" style="width:100%;height:20px" value=""><input type="hidden" name="'+accId+'" value="">';
	td3.innerHTML='<BUTTON style="HEIGHT:25px" onClick="deleteRow();">删除</BUTTON><BUTTON style="HEIGHT:25px" onClick="javascript:addRowPage();">继续添加</BUTTON>';

	accCnt++; 
	
	tr.appendChild(th1);
	tr.appendChild(td1);
	tr.appendChild(th2);
	tr.appendChild(td2);
	tr.appendChild(td3);
    document.all("accessoryList").appendChild(tr);

}

function uploadingFile(sSrc) {
 	var xmlHttp=false;
	if(window.XMLHttpRequest){ //Mozilla 
 		xmlHttp=new XMLHttpRequest();
 	}
 	else if(window.ActiveXObject){
 		try{
 			xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
 			}catch(e){
 			try{
 				xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
 			}catch(e){}
 		}
 	}
    xmlHttp.open("GET", sSrc, true);	// async
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4) {
            checkUploadBack(xmlHttp.responseText);
        }
    };
	// call in new thread to allow ui to update
    window.setTimeout(function () {
        xmlHttp.send(null);
    }, 10);
}
function checkUploadBack(s){
  	if(s!=null){
  		if(s=="0"){
  			alert("附件上传成功");
  		}
  		if(s=="1"){
  			alert("附件上传失败，请稍候重试！");
  		}
  	}	
  }
function _uploadFile(baseUrl){
  	var frm = document.forms[0];
  	var objTitle;
  	var objPath;
  	var objId;
  	var sTitle;
  	var sFileId;
  	var sFilePath;
  	if(frm.docId.value!=null && frm.docId.value!=""){
  		if(accCnt==2){
  			objTitle=document.all("fileTitle");
  			objPath=document.all("filePath");
  			objId=frm.docId.value+"01";
  			sTitle=objTitle.value;
  			sFilePath=objPath.value;
  			sFileId="S"+frm.docId.value+"01";
		}else{
			var s=accCnt-1;
  			objTitle=document.all("fileTitle_"+s);
  			objPath=document.all("filePath_"+s);
  			objId=document.all("fileId_"+s);
	  		sTitle=objTitle.value;
  			sFilePath=objPath.value;
  			sFileId="S"+frm.docId.value+getFileSort();
  		}
  		var sSrc=baseUrl+"/servlet/saveDocAccesoryServlet?fileId="+sFileId+"&filePath="+sFilePath+"&fileTitle="+sTitle;
  		uploadingFile(baseUrl);
  	}else{
  		alert("请先输入公文编号并验证后再上传附件！");
  		frm.docId.select();
  	}
  }
//取消附件
function deleteRow() {
	var oel=event.srcElement;
	var oTa = getRealTag(oel, "TR");

	if(accCnt>2){
		oTa.removeNode(true);
		accCnt=accCnt-1;
		if(accCnt==2){
			document.forms[0].accCnt.value=1;
		}		
	}else{
		var frm = document.forms[0];
  		frm.fileTitle1.value="";
  		frm.filePath1.value="";
  		frm.fileId1.value="";
  		document.forms[0].accCnt.value=1;
	}
}

  
//获取标签所在的对象 
function getRealTag(__oSrc, __tag) {
	if(null == __oSrc) 
		return;
	if(__tag.toUpperCase() == __oSrc.tagName) 
		return __oSrc;
	return getRealTag(__oSrc.parentNode, __tag);
}