/* 找出那些在通用代码pt_promo中不存在的零件推销组 */
for each pt_mstr where pt_promo <> "" :
find first code_mstr 
where code_fldname = 'pt_promo'
and code_value = pt_promo no-lock no-error.
if not avail code_mstr then do:
   disp pt_part pt_promo.
end.
end.

/* 导出已维护的数据,然后去掉那些有问题的推销组. */
output to value("/home/mfg/micho/pt_promo1.txt").
put unformatted "机种号" ";" "说明" skip.
for each pt_mstr where pt_promo <> "",
each code_mstr where code_fldname = 'pt_promo'
and code_value = pt_promo 
break by pt_promo :
if last-of(pt_promo) then do:
   export delimiter ";" pt_promo code_cmmt .	
end.
end.
output close .

output to value("/home/mfg/micho/pt_promo.txt").
put UNFORMATTED "厂别" ";" "机种号" ";" "说明" skip.
FOR EACH code_mstr where code_fldname = 'pt_promo':
export delimiter ";" code_user1 code_value code_cmmt.
end.
output close .


/* 进行初始化,利用程序xxinpt01.p */
