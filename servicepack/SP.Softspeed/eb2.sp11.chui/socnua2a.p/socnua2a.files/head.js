<!--
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_setTextOfLayer(objName,x,newText) { //v4.01
  if ((obj=MM_findObj(objName))!=null) with (obj)
    if (document.layers) {document.write(unescape(newText)); document.close();}
    else innerHTML = unescape(newText);
}

function MM_swapImgRestore() { 
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { 
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImage() { 
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function StartUpPage() {
/*	cswmMenuBarInit();  */
/*	alert("StartUpPage"); */
	MM_preloadImages('/images/arrow7C95CB.gif','/images/arrowff9900.gif','/images/arrowffffff.gif');
}

function nw(URL) {
    width = 700;
    height = 375;
    x = 10; 
    y = 10;
    if (screen) {
        y = ((screen.availHeight - height)/2)-50;
        x = (screen.availWidth - width)/2;
    }
openwindow = window.open(URL,'new_window','width=' + width + ',height=' + height + ',menubar=yes,location=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,screenX='+x+',screenY='+y+',top='+y+',left='+x);
openwindow.focus();
}

function swm(URL) {
    x = 0; 
    y = 0;
supportwindow = window.open(URL,'support','maximize=1,menubar=yes,location=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,top='+y+',left='+x);
supportwindow.focus();
}

function sw(URL) {
    width = 800;
    height = 375;
    x = 0; 
    y = 0;
supportwindow = window.open(URL,'support','width=' + width + ',height=' + height + ',menubar=yes,location=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,top='+y+',left='+x);
supportwindow.focus();
}

function swbig(URL) {
    width = 955;
    height = 550;
    x = 0; 
    y = 0;
supportwindow = window.open(URL,'support','width=' + width + ',height=' + height + ',menubar=yes,location=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,top='+y+',left='+x);
supportwindow.focus();
}

function e06(URL) {
    width = 840;
    height = 500;
    x = 0; 
    y = 0;
supportwindow = window.open(URL,'explore','width=' + width + ',height=' + height + ',menubar=yes,location=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,top='+y+',left='+x);
supportwindow.focus();
}


function cw() {
window.close();
}

function cnw(url_out) 
{ 
nw(url_out);
window.close(); 
} 

function help(URL) { 
    width = 400;
    height = 300;
    x = 10; 
    y = 10;
    if (screen) {
        y = ((screen.availHeight - height)/2)-50;
        x = (screen.availWidth - width)/2;
    }
helpwindow = window.open(URL,'help_window','width=' + width + ',height=' + height + ',menubar=0,location=0,resizable=0,toolbar=0,scrollbars=1,status=0,screenX='+x+',screenY='+y+',top='+y+',left='+x);
helpwindow.focus();
}
/* added by rcy */
function notice_pop(url) {
accountswindow = window.open(url,"Alert",'width=790,height=300,toolbar=no,top=55,left=55,scrollbars=1,resizable=1');
}
/* added by lca */
function pdfpop(url) {
accountswindow = window.open(url,"PDF",'width=700,height=370,toolbar=yes,top=140,left=160,scrollbars=1,status,location,menubar,resizable=1');
}

function lppop(url) {
accountswindow = window.open(url,"PDF",'width=700,height=370,toolbar=yes,top=140,left=160,scrollbars=1,status,menubar,resizable=1');
}

function qbitpop(url) {
accountswindow = window.open(url,"QBit",'width=802,height=560,toolbar=no,top=55,left=55,scrollbars=1,resizable=1');
}

function tplpop(url) {
accountswindow = window.open(url,"PDF",'width=800,height=370,toolbar=yes,top=140,left=160,scrollbars=1,status,location,menubar,resizable=1');
}

function popit(widthpop, heightpop, filepath, typeofpopup)
   {

   var w = 640;
   var h = 480;
   var popW = widthpop;
   var popH = heightpop;

   if (document.all) {
     w = document.body.clientWidth;
     h = document.body.clientHeight;
   }
   else if (document.layers) {
     w = window.innerWidth;
     h = window.innerHeight;
   }

   var leftPos = (w-popW)/2;
   var topPos = (h-popH)/2;
   
   var options1 = 'directories=0,location=0,menubar=0,resizable=0,scrollbars=0,status=0,toolbar=0,width=' + popW + ',height='+popH ;
   var options2 = 'directories=0,location=0,menubar=0,resizable=0,scrollbars=0,status=0,toolbar=0,width=' + popW + ',height='+popH+',top='+topPos+',left='+leftPos ;
   
   if (typeofpopup == 'centered') {
     window.open(filepath, 'popit', options2);
   } else {
     window.open(filepath, 'popit', options1);
   }
}
/* added by agu & rcy - survey */
var expdate = new Date ();
expdate.setTime (expdate.getTime() + (24 * 60 * 60 * 365 * 1000));

function surveyYes(){
DeleteCookie('qadclicks');
setDaysToWait('15');
window.location.href='http://www3.qad.com/support/tqmsurvey.nsf/WSS?OpenForm';
//window.close();
}

function surveyNo(){
DeleteCookie('qadclicks');  // remove clicks counted up to now
setDaysToWait('15');
window.close();
}

function getClicks(){
var clicks = GetCookie('qadclicks');
if (clicks != ""){
	return clicks;
}
else{
return 0;
}
}

function setClicks(){
var clickt = GetCookie("qadclicks");
if (clickt != ""){
	clickt = parseInt(clickt) + 1;
}
else{
clickt = 1;
}
SetCookie ("qadclicks", clickt, expdate, "/");
}

function getDaysToWait(){
var gdays = GetCookie("qaddays");
if (gdays != ""){
	return gdays;}
else{                       
now = new Date();
return now;
}
}

function setDaysToWait(dtot){   // value set will be a date value
if (dtot == ""){
dot = 0;
}
now = new Date();
now = now.setDate(now.getDate() +parseInt(dtot));
SetCookie ("qaddays", now, expdate, "/");
}


function SetCookie (name,value,expires,path,domain,secure) {
  document.cookie = name + "=" + escape (value) +
    ((expires) ? "; expires=" + expires.toGMTString() : "") +
    ((path) ? "; path=" + path : "") +
    ((domain) ? "; domain=" + domain : "") +
    ((secure) ? "; secure" : "");
}


function GetCookie (name) {
  var arg = name + "=";
  var alen = arg.length;
  var clen = document.cookie.length;
  var i = 0;
  while (i < clen) {
    var j = i + alen;
    if (document.cookie.substring(i, j) == arg)
      return getCookieVal (j);
    i = document.cookie.indexOf(" ", i) + 1;
    if (i == 0) break; 
  }
return "";
}

function getCookieVal (offset) {
  var endstr = document.cookie.indexOf (";", offset);
  if (endstr == -1)
    endstr = document.cookie.length;
  return unescape(document.cookie.substring(offset, endstr));
}

function DeleteCookie (name,path,domain) {  // may be useful
  if (GetCookie(name)) {
    document.cookie = name + "=" +
      ((path) ? "; path=" + path : "") +
      ((domain) ? "; domain=" + domain : "") +
      "; expires=Thu, 01-Jan-70 00:00:01 GMT";
  }
}

function surveyLaunch() {
var x = getDaysToWait();
now = new Date();
var z = x - now;
days = Math.round(z/(1000*60*60*24));
	if (days < 1 && getClicks() > 2) {
		//window.location.href="http://www3.qad.com/support/tqmsurvey.nsf/WSSE?OpenForm";
		window.open("http://www3.qad.com/support/tqmsurvey.nsf/WSSE?OpenForm","new_win","width=800,height=700,toolbar=yes,status=yes,location=yes,menubar=yes,scrollbars=yes,resizable=yes,directories=yes");
		setDaysToWait('15');
		}
		DeleteCookie("qadclicks");
}
/* end survey */
/* String manipulation functions */
/* trims left whitespace */
function strltrim() {
    return this.replace(/^\s+/,'');
}
/* trims right whitespace */
function strrtrim() {
    return this.replace(/\s+$/,'');
}
/* trims right and left whitespace */
function strtrim() {
    return this.ltrim().rtrim();
}
/* adds trim functions to prototype String class */
String.prototype.ltrim = strltrim;
String.prototype.rtrim = strrtrim;
String.prototype.trim = strtrim;
/* String.unescape() isn't reliable. This decodes url space characters (+) to white space. */
function unescapestr(str){
  return str = str.replace(/(\+|\%20)/g,' ');
}

function Jump_Menu(rawdatastring) {
	var splitstringARR = rawdatastring.split('|');
	var howtojump = splitstringARR[0]; 
	var urltojumpto = splitstringARR[1];
	if (howtojump == 'newwindow') {
		windowHandle = window.open(urltojumpto,'windowName','resizable=1,scrollbars=yes,status=yes,toolbar=yes,directories=yes,location=yes,menubar=yes');
	} else {
		top.location.href = urltojumpto;
	}
}
//-->
