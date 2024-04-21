var http_request = false;
function initRequest(){
 http_request = false;
 //initialize XMLHttpRequest object
 if(window.XMLHttpRequest){//Mozilla browser
  http_request = new XMLHttpRequest();
  if(http_request.overrideMimeType){//MiME type
   http_request.overrideMimeType("text/xml");
  }
 }
 else if (window.ActiveXObject){//IE browser
  try {
   http_request = new ActiveXObject("Msxml2.XMLHTTP");
  }catch (e) {
   try {
    http_request = new ActiveXObject("Microsoft.XMLHTTP");
   } catch (e) {}
  }
 }
 if (!http_request){ // cann't initialize XMLHttpRequest object
  window.alert("cann't initialize XMLHttpRequest object instance");
  return false;
 }
}
function byId(str){
 return document.getElementById(str);
}
function byName(str){
 return document.getElementsByName(str);
}
function byTagName(str){
 return document.getElementsByTagName(str);
}
//check browser type: IE ,FireFox...
var isIE = false;
function checkType(){
 if(document.all){
  isIE = true;
 }
}
/**
计算包含中文的长度
*/
function strlen(str){
 return str.replace(/[^\x00-\xff]/g,"**").length;
}
//设置查询结果iframe的高度,让它的横向滚动条显示在浏览器的最下方
function changeHeight(hei){
 //document.getElementById("resultHeight").height = hei;
 var he = document.body.clientHeight;
 var obj = document.getElementById("resultHeight");
 var rec = getoffset(obj);
 if(he<rec[0]) return;
 obj.height = he - rec[0];
}
//获得元素的绝对位置,返回一个数组,长度为2,rec[0]为top value(距离网页顶端的px),rec[1]为left value(距离网页左边的px)
function getoffset(e) 
{  
  var t=e.offsetTop;  
  var l=e.offsetLeft;  
  while(e=e.offsetParent) 
  {  
   t+=e.offsetTop;  
   l+=e.offsetLeft;  
  }  
  var rec = new Array(1); 
  rec[0]  = t; 
  rec[1] = l; 
  return rec 
}
/*
判断是否为整数,例如:
isNumber("+1234");返回true;
isNumber("-1234");返回true;
isNumber("1234");返回true;
也就是说输入的数可以为正整数（前面可以有+号，也可以没有），也可以为负整数
*/
function isNumber(str){
 var pattern = /^[+-]{0,1}\d+$/;
 if(pattern.test(str)){
  return true;
 }
 return false;
}
/*
判断是否为小数,例如:
isNumber("+1234.00");返回true;
isNumber("-1234.01");返回true;
isNumber("1234.11");返回true;
也就是说输入的数可以为正数（前面可以有+号，也可以没有），也可以为负数
*/
function isDec(str){
 var pattern = /^[+-]{0,1}\d+\.{0,1}\d*$/;
 if(pattern.test(str)){
  return true;
 }
 else{
  return false;
 }
}
function isEmpty(fData)
{
    if(fData==null)
		return true;
	var qdata=fData.replace(/(^\s*)|(\s*$)/g, "")
	if(qdata=="")
		return true;
	return false;
}
/**-----------------------------------------------------------
* 名　　称：isBigStr
* 功    能：判断字符串是否超过了额定的长度,汉字按两个字符计算
* 入口参数：fData：要检查的数据；maxLen：规定的最大长度
* 出口参数：True：超过了最大长度                              
*           False：没有超过最大长度
* -------------------------------------------------------------
**/
function isBigStr(fData,maxLen){	
    if(fData!=null && fData.replace(/[^\x00-\xff]/g,"**").length>maxLen){
    	return true;
    }else{
    	return false;
    }
}

/**-----------------------------------------------------------
* 名　　称：isCheckChina
* 功    能：判断字符串是否含有汉字
* 入口参数：fData：要检查的数据对象；msg：提示字符串
* 出口参数：return  返回                      
*           
* -------------------------------------------------------------
**/
function isCheckChina(fData,msg){	
	  obj= document.all(fData);
    if(obj!=null && obj.value.replace(/[^\x00-\xff]/g,"**").length!=obj.value.length){
    	alert(msg);
    	obj.selected;
    	return;
    }else{

    }
}
/*
给String增加trim函数,用法如下:
var str = "  test  ".trim();
这样得到的str的内容就是test
*/
String.prototype.trim=function(){
 return this.replace(/(^\s*)|(\s*$)/g,"");
}
/*
表格排序,参数说明
id : 待排序的表格的名称
type : 排序的类型(num:按数字;str:按字符串)
obj : 排序的列(使用的时候写入this即可)
start : 排序的起始行(主要是去掉无须排序的其它行)
end : table最后无需参与排序的行数
例如:
需要对table1进行排序,由于第一行是表头,所以不参与排序,其余行全部都需要参与排序,所以写法如下,需要增加一个sortType
<td onClick="sortTable('table1','str',this,1,0)" sortType="asc">
*/
function sortTable(id,type,obj,start,end) {
 var tblEl = document.getElementById(id);
 var i, j;
 var minVal, minIdx;
 var testVal;
 var cmp;
 var col = obj.cellIndex;
 var start = 1;
 var total = new Array();
 var str = new Array();
 var order = obj.sortType;
 var rowCount = tblEl.rows.length;//得到行数
 if (isNaN(rowCount) || rowCount==start) return;//没有纪录就不需要排序了
 for(i = start;i<rowCount - end;i++)
 {
  total[i - start] = tblEl.rows[i];
  str[i - start] = tblEl.rows[i].cells[col].innerText.trim();
 }
 
 for (var step = str.length >> 1; step > 0; step >>= 1)
    {
        for (var i = 0; i < step; ++i)
        {
            for (var j = i + step; j < str.length; j += step)
            {
                var k = j;
                var value = str[j];
                var rowValue = total[j];
                while (k >= step && compareValues(str[k - step],value,type,order) > 0 )
                {
                    str[k] = str[k - step];
                    total[k] = total[k - step];
                    k -= step;
                }
                str[k] = value;
                total[k] = rowValue;
            }
        }
    }
 
 for(i = 0;i<total.length;i++)
 { 
  tblEl.rows[start - 1].insertAdjacentElement("beforeEnd",total[i]);
 }
 
 if(order=="asc"){
  obj.sortType = "desc";
 }
 else{
  obj.sortType = "asc";
 }
}
function compareValues(v1, v2,type,order) {
 var f1, f2;
 if(v1=="" && order=="asc") {
  return 1;//如果内容为空,排序时就放置在最后一行
 }
 if(v2=="" && order=="asc") {
  return -1;//如果内容为空,排序时就放置在最后一行
 }
 
 if (type=="num"){
  re = /,/g;
  v1 = v1.replace(re,"");
  v2 = v2.replace(re,"");
  if (isDec(v1)){
   v1 = parseFloat(v1);
  }
   
  if (isDec(v2)){
   v2 = parseFloat(v2);
  }
 }
 
 if (v1 == v2) {
 return 0;
 }
 if (v1 > v2){
  if(order=="asc"){
   
   return 1;
  }
  else{
   return -1;
 
  }
 }
 else{
  if(order=="asc"){
   return -1;
  }
  else{
   return 1;
 
  }
 }
}
