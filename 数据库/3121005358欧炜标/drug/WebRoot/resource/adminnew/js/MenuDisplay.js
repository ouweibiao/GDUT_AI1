function ShowHide(tableId,imageID,showImage,hideImage){
if(tableId.style.display=="none"){
   tableId.style.display="block";
   document[imageID].src=""+showImage+".gif";
}
 else  {
 tableId.style.display="none";
 document[imageID].src=""+hideImage+".gif";
 }
}
