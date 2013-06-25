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
for each xxcer_mstr where xxcer_nbr = pro_xxcer_nbr :
	delete xxcer_mstr .
end.