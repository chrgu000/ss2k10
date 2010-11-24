/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
{mfdtitle.i "dd"}
/*
input tmp_char ,	输入字符变量
input 108,		每行多少个字节
output tmp_char ,	输出字符变量
output k		总共有多少行
*/
define input  parameter iptstring as char.
define input  parameter iptlength as int.
define output parameter optstring as char.
define output parameter xxk as int.	/*---Add by davild 20071220.1*/
define var xxs as char.
define var xxss as char.
define var xxi as int.
define var xxj as int.

optstring = "".
xxss = "".
xxi = 1.

if iptlength < 2 then return.

repeat while xxi <= length(iptstring,"RAW") :
	xxs = substring(iptstring,xxi,1).
	if length( xxss + xxs , "RAW") > iptlength then do:
		optstring = optstring + xxss + "^".
		xxss = "".
		next.
	end.
	xxi = xxi + 1.
	xxss = xxss + xxs.
end.
optstring = optstring + xxss.

/*---Add Begin by davild 20071220.1*/
xxk = 1 .
do xxj = 1 to length(optstring):
	if substring(optstring,xxj,1) = "^" then assign xxk = xxk + 1 .
end.
/*---Add End   by davild 20071220.1*/