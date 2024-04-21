
function _loadSecCatType(catType) {
    var catTypeSec=document.getElementById("catTypeSec");
    catTypeSec.options.length=0;
    var option=new Option("请选择","",false,true);
    catTypeSec.add(option);
    if (catType=="0"||catType=="1"||catType=="2")
    {
		var option1=new Option("按操作人员统计",3); 
		catTypeSec.add(option1);
		var option2=new Option("按操作类别统计",4); 
		catTypeSec.add(option2);
     }
    if (catType=="3")
    {
    	var option4=new Option("按天统计",0); 
		catTypeSec.add(option4);
		var option5=new Option("按月统计",1); 
		catTypeSec.add(option5);
		var option6=new Option("按年统计",2); 
		catTypeSec.add(option6);
		var option7=new Option("按操作类别统计",4); 
		catTypeSec.add(option7);
    }
    if (catType=="4")
    {
    	var option8=new Option("按天统计",0); 
		catTypeSec.add(option8);
		var option9=new Option("按月统计",1); 
		catTypeSec.add(option9);
		var option10=new Option("按年统计",2); 
		catTypeSec.add(option10);
		var option11=new Option("按操作人员统计",3); 
		catTypeSec.add(option11);
    }    
    
    //开始处理列表框展示的抬头
    var parent=document.getElementById("catTable"); 
    var last=parent.lastChild;
    while(!(last=="null")){
    	parent.removeChild(last); 
    }
    var catName="";
    if(catType=="0"){
    	catName="日期";
    }
    if(catType=="1"){
    	catName="月份";
    }
    if(catType=="2"){
    	catName="年份";
    }
    if(catType=="3"){
    	catName="操作人员";
	}
    if(catType=="4"){
    	catName="操作类型";
    }
    tr = document.createElement("TR");
	th1=document.createElement("TH");
	th2=document.createElement("TH");
	th3=document.createElement("TH");
	th1.width="15%";
	th1.innerHTML="<strong>序号</strong>";
	th2.width="40%";
	th2.innerHTML = "<strong>"+catName+"</strong>";
	th3.width="45%";
	th3.innerHTML = "<strong>日志数</strong>";
	tr.appendChild(th1);
	tr.appendChild(th2);
	tr.appendChild(th3);
	parent.appendChild(tr);
}

function _loadCatTitle(catType,catTypeSec) {
    //开始处理列表框展示的抬头
    var catName="";
    var catName2="";
    var parent=document.getElementById("catTable"); 
    var last=parent.lastChild;
    while(!(last=="null")){
    	parent.removeChild(last); 
    }
    if(catType=="0"){
    	catName="日期";
    }
    if(catType=="1"){
    	catName="月份";
    }
    if(catType=="2"){
    	catName="年份";
    }
    if(catType=="3"){
    	catName="操作人员";
	}
    if(catType=="4"){
    	catName="操作类型";
    }  
    
    if(catTypeSec=="0"){
    	catName2="日期";
    }
    if(catTypeSec=="1"){
    	catName2="月份";
    }
    if(catTypeSec=="2"){
    	catName2="年份";
    }
    if(catTypeSec=="3"){
    	catName2="操作人员";
	}
    if(catTypeSec=="4"){
    	catName2="操作类型";
    }
    tr = document.createElement("TR");
	th1=document.createElement("TH");
	th2=document.createElement("TH");
	th3=document.createElement("TH");
	th4=document.createElement("TH");
	th1.width="15%";
	th1.innerHTML="<strong>序号</strong>";
	th2.width="30%";
	th2.innerHTML = "<strong>"+catName+"</strong>";
	th3.width="30%";
	th3.innerHTML = "<strong>"+catName2+"</strong>";
	th4.width="25%";
	th4.innerHTML = "<strong>日志数</strong>";
	tr.appendChild(th1);
	tr.appendChild(th2);
	tr.appendChild(th3);
	tr.appendChild(th4);
	parent.appendChild(tr);
}




