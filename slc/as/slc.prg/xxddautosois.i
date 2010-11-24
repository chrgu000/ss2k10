/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
 /* 销售出货CIMLOAD
{1} = 销售订单号
{2} = 项次		字符型
{3} = 数量
{4} = 地点
{5} = 库位
{6} = 批号
{7} = 参考
""" """  输入固定值或空值要输入3对引号
{xxddautosois.i
	 xxsovd_nbr
	 string(xxsovd_line)
	 """1"""
	 """10000"""
	 locfrom
	 xxsovd_id1
	 """ """
	}
*/
/* define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/". */
define variable usection as char format "x(16)". 

usection = "SOIS" + string(today,"999999")  + string(time,"HH:MM:SS") + trim({5}) + trim({6}) .

output to value( trim(usection) + ".i") .
	
	put unformatted {1} + " - N N " at 1 skip .
	put unformatted {2} + " - " at 1 skip .		
	put unformatted {3} +  " " + {4} + " " 
		+  {5} + " " + {6} + " " + {7} at 1 skip .		
	put unformatted "." at 1 skip .
	put unformatted "Y" at 1 skip .
	put unformatted "Y" at 1 skip .
	put unformatted "-" at 1 skip .
	put unformatted "- - - - " at 1 skip .
	/*+ trim(xxshd_inv_no) 
	+ " N Y " */	/*---Remark by davild 20071228.1*/
	
	put unformatted "." at 1 skip  .
	/*with fram finput no-box no-labels width 200.*/

output close.

input from value ( usection + ".i") .
output to  value ( usection + ".o") .
        {gprun.i ""sosois.p""}
input close.
output close.

/*
unix silent value ( "rm "  + Trim(usection) + ".i").
unix silent value ( "rm "  + Trim(usection) + ".o"). 
*/	