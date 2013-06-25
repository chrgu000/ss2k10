/* Creation: eB21SP3 Chui Last Modified: 20080421 By: Davild Xu *ss-20080421.1*/
/***
xxcermt4.i 调用
同一零件、同一供应商，不能存在OK/QTY/ALLOC三种类型的CER生效日期重叠的情况；
	 BEGIN  在保存时，一定需要检查判别此条件
	{gprun.i ""xxcecheckeffdate.p""
	"(input danju,
	  input xxcer_part,
	  input xxcer_vend,
	  input xxcer_dec_result,
	  input xxcer_effdate,
	  input xxcer_expire,
	  output checkEffdateError
	)"}
	if checkEffdateError then do:
		next-prompt xxcer_effdate with frame a42 .
		undo,retry .
	end.
****/
{mfdtitle.i "dd"}

pause 0 .
def input parameter pro_xxcer_nbr	like xxcer_nbr	 .
def input parameter pro_xxcer_part	like xxcer_part	 .
def input parameter pro_xxcer_vend	like xxcer_vend	 .
def input parameter pro_xxcer_dec_result like xxcer_dec_result .
def input parameter pro_xxcer_effdate	like xxcer_effdate	 .
def input parameter pro_xxcer_expire	like xxcer_expire	 .
def output parameter pro_Error as logi .
DEFINE VARIABLE dteTmpB as date .
pro_Error = no .

if pro_xxcer_effdate = ? then assign pro_xxcer_expire = low_date .
if pro_xxcer_expire = ? then assign pro_xxcer_expire = hi_date .
for each xxcer_mstr where 
	xxcer_avail = yes	/*---Add by davild 20080707.1*/
		     and  xxcer_part = pro_xxcer_part
		     and  xxcer_vend = pro_xxcer_vend
		     and  xxcer_nbr <> pro_xxcer_nbr
		     and  xxcer_dec_result <> "不合格(NG)"
		     no-lock :
	dteTmpB = xxcer_expire .
	if dteTmpB = ? then assign dteTmpB = hi_date .

	if xxcer_effdate = ? then assign pro_Error = yes .
	if xxcer_effdate >= pro_xxcer_effdate and xxcer_effdate <= pro_xxcer_expire then assign pro_Error = yes .
	if dteTmpB >= pro_xxcer_effdate and dteTmpB <= pro_xxcer_expire then assign pro_Error = yes .
	
	if pro_error then do:
		message "申请单号 " + xxcer_nbr + " 的生效日期 " + string(xxcer_effdate) + " 结束日期 " + string(dteTmpB)
		skip 
		"与现在输入的日期的有重叠,请重新输入" view-as alert-box .
	end.
end.