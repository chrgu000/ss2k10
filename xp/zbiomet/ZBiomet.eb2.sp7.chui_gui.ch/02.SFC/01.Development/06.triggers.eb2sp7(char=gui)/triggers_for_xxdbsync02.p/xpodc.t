
TRIGGER PROCEDURE FOR CREATE OF POD_DET .


/*
/*ss - 20090401.1 - B*/
define var v_file as char format "x(60)" label "导入导出临时文件" initial "xxdbsync01.d" .

do:
    find first xpod_det 
	where xpod_nbr  = pod_nbr 
	and   xpod_line = pod_line 
    no-error .
    if not avail xpod_det then do:
	{xxdbsync01.i "pod_det"  "xpod_det"}
    end.
    else /*if 
	 xpod_part   <> pod_part
      or xpod_wo_lot <> pod_wo_lot
      or xpod_op     <> pod_op
    then*/ do:
	delete xpod_det .
	{xxdbsync01.i "pod_det"  "xpod_det"}
    end. 
end.
/*ss - 20090401.1 - E*/
*/



