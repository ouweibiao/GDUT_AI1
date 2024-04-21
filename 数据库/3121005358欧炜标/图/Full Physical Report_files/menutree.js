function arrange(prt) {
   var b = true;
   var prev = 0;
   var prevprev = 0;
   var subTotal = 0;
   var height = 0;
   if (prt == document) {
      for (var i=0; i<document.layers.length; i++) {
         var whichEl = document.layers[i];
         if (whichEl.visibility != "hide") {
            if (!b) {
               height = document.layers[prev].document.height + arrange(document.layers[prev]);
               document.layers[prev].clip.height = height;
               document.layers[prev].clip.width = window.outerWidth;
               whichEl.pageY = document.layers[prev].pageY + height;
            }
            if (document.layers[prevprev])
            {
               if ((parseInt(document.layers[prevprev].name.substr(4)) == parseInt(document.layers[prev].name.substr(4)))
                   && (document.layers[prevprev].name + " - " + document.layers[prev].name))
               {
                  if (document.layers[prevprev].document.images['imEx'])
                     document.layers[prevprev].document.images['imEx'].src = "i_colpse.gif";
               }
            }
            subTotal += height;
            b = false;
            prevprev = prev;
            prev = i;
         }
      }
      if (document.layers.length && !b) {
         height = document.layers[prev].document.height + arrange(document.layers[prev]);
         document.layers[prev].clip.height = height;
         document.layers[prev].clip.width = window.outerWidth;
         if (document.layers[prevprev])
         {
            if ((parseInt(document.layers[prevprev].name.substr(4)) == parseInt(document.layers[prev].name.substr(4)))
                && (document.layers[prevprev].name + " - " + document.layers[prev].name))
            {
               if (document.layers[prevprev].document.images['imEx'])
                  document.layers[prevprev].document.images['imEx'].src = "i_colpse.gif";
            }
         }
         subTotal += height;
      }
   }
   else {
      for (var i=0; i<prt.document.layers.length; i++) {
         var whichEl = prt.document.layers[i];
         if (whichEl.visibility != "hide") {
            if (b) {
               height = prt.document.height;
               whichEl.pageY = prt.pageY + height;
            }
            else {
               height = prt.document.layers[prev].document.height + arrange(prt.document.layers[prev]);
               prt.document.layers[prev].clip.height = height;
               prt.document.layers[prev].clip.width = window.outerWidth;
               whichEl.pageY = prt.document.layers[prev].pageY + height;
            }
            if (prt.document.layers[prevprev])
            {
               if ((parseInt(prt.document.layers[prevprev].name.substr(4)) == parseInt(prt.document.layers[prev].name.substr(4)))
                   && (prt.document.layers[prevprev].name != prt.document.layers[prev].name))
               {
                  if (prt.document.layers[prevprev].document.images['imEx'])
                     prt.document.layers[prevprev].document.images['imEx'].src = "i_colpse.gif";
               }
            }
            subTotal += height;
            b = false;
            prevprev = prev;
            prev = i;
         }
      }
      if (prt.document.layers.length && !b) {
         height = prt.document.layers[prev].document.height + arrange(prt.document.layers[prev]);
         prt.document.layers[prev].clip.height = height;
         prt.document.layers[prev].clip.width = window.outerWidth;
         if (prt.document.layers[prevprev])
         {
            if ((parseInt(prt.document.layers[prevprev].name.substr(4)) == parseInt(prt.document.layers[prev].name.substr(4)))
                && (prt.document.layers[prevprev].name != prt.document.layers[prev].name))
            {
               if (prt.document.layers[prevprev].document.images['imEx'])
                  prt.document.layers[prevprev].document.images['imEx'].src = "i_colpse.gif";
            }
         }
         subTotal += height;
      }
   }
   return subTotal;
}

function InitNS(prt) {
   prt.visibility = "hide";
   if (prt.document.layers) {
      for (var i=0; i<prt.document.layers.length; i++) {
         var nested = prt.document.layers[i];
         InitNS(nested);
      }
   }
}

function initIt(){
    if (NS4) {
        var nHeight
        for (var i=0; i<document.layers.length; i++) {
            var nested = document.layers[i];
            if (nested.id.indexOf("list") != -1) InitNS(nested);
        }
        nHeight = arrange(document) + 30;
        if (document.height < nHeight)
           document.height = nHeight;
    }
}

function expandIt(el) {
    if (!ver4) return;
    if (IE4)
       expandIE(el);
    else if (NS4)
       expandNS4("", "elmt" + el, document);
    else if (NS6)
       expandNS6(el);
}

function expandNS6(el) { 
    var nested = document.getElementById("elmt" + el + "list");
    var nstdImg = document.getElementsByName('imEx')[el-1];
    if (nested.style.display == "block") {
        nested.style.display = "none";
        nstdImg.src = "i_expand.gif";
    }
    else {
        nested.style.display = "block";
        nstdImg.src = "i_colpse.gif";
    }
}

function expandIE(el) { 
    var nested = eval("elmt" + el + "list");
    var nstdImg = event.srcElement;
    if (nested.style.display == "block") {
        nested.style.display = "none";
        nstdImg.src = "i_expand.gif";
    }
    else {
        nested.style.display = "block";
        nstdImg.src = "i_colpse.gif";
    }
}

function hideChild(prt) {
   prt.visibility = "hide";
   for (var i=0; i < prt.document.layers.length; i++) {
      if (prt.document.layers[i].id.indexOf("prnt") != -1) {
         prt.document.layers[i].document.images['imEx'].src = "i_expand.gif";
      }
      hideChild(prt.document.layers[i]);
   }
}

function expandNS4(sub, el, prt) {
   var nested  = eval(sub + "document." + el + "list");
   var nHeight;
   if (nested) {
      var nstdImg = eval(sub + "document." + el + "prnt.document.images['imEx']");
      if (nested.visibility == "hide") {
         nested.visibility = "show";
         nstdImg.src = "i_colpse.gif";
         for (var i=0; i < nested.document.layers.length; i++) {
            if (nested.document.layers[i].id.indexOf("list") == -1)
               nested.document.layers[i].visibility = "show";
         }
         nHeight = arrange(document) + 30;
         if (nHeight > document.height)
            document.height = arrange(document) + 30;
      }
      else {
         nstdImg.src = "i_expand.gif";
         hideChild(nested);
         arrange(document);
      }
   }
   else {
      if (prt == document) {
         for (var i=0; i < document.layers.length; i++) {
            var nested2 = document.layers[i];
            if (nested2.visibility != "hide") {
               expandNS4("document." + nested2.name + "." + sub, el, nested2);
            }
         }
      }
      else {
         for (var i=0; i < prt.document.layers.length; i++) {
            var nested2 = prt.document.layers[i];
            if (nested2.visibility != "hide") {
               expandNS4(sub + "document." + nested2.name + ".", el, nested2);
            }
         }
      }

   }
}

function refresh() {
   if (NS4)
      arrange(document);
}

with (document) {
    write("<style type=\"text/css\">");
    if (NS4) {
        write(".list {position:absolute; visibility:hidden}");
        write(".prnt {position:absolute; visibility:shown}");
        write(".sngl {position:absolute; visibility:shown}");
    }
    else if (IE4) {
        write(".list {display:none}")
    }
    else if (NS6){
        write(".list {display:none}")
    }
    else {
        write(".list {display:true}")
    }
    write("</style>");
}

onload = initIt;
onresize = refresh;