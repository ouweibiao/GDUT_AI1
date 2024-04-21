function showWaitMsg(){
	var IfrRef = document.getElementById('DivShim');
	var DivRef = document.getElementById('waitmsg');
	DivRef.style.pixelTop = (document.body.offsetHeight - 120) / 2 + document.body.scrollTop;
	DivRef.style.pixelLeft = (document.body.offsetWidth - 360) / 2 + document.body.scrollLeft;
	DivRef.style.display = "block";
	IfrRef.style.width = DivRef.offsetWidth;
	IfrRef.style.height = DivRef.offsetHeight;
	IfrRef.style.top = DivRef.style.top;
	IfrRef.style.left = DivRef.style.left;
	IfrRef.style.zIndex = DivRef.style.zIndex - 1;
	IfrRef.style.display = "block";
	document.getElementById('sbar').width = 1;
	times = setInterval('showloading();',100);
}
function hideWaitMsg(){
	var IfrRef = document.getElementById('DivShim');
	var DivRef = document.getElementById('waitmsg');
	DivRef.style.display = "none";
	IfrRef.style.display = "none";
}
function showloading()
{
	if (document.getElementById('sbar').width>356)
	{
		document.getElementById('sbar').width=1
	}
	else
	{
		document.getElementById('sbar').width += 2;
	}
}

