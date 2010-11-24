/* SS - 090828.1 By: Neil Gao */

{mfdtitle.i "090828.1"}

define var receive like prh_receiver.
define var receive1 like prh_receiver.
define var rdate   as date.
define var rdate1   as date.
define buffer ptmstr for pt_mstr.

form
	rdate 	colon 15
	rdate1	colon 40
	receive colon 15
	receive1 colon 40
with frame a side-label width 80 attr-space.

setframelabels(frame a:handle).
	
mainloop:
repeat:
	
	if rdate = low_date then rdate = ?.
	if rdate1 = hi_date then rdate1 = ?.
	if receive1 = hi_char then receive1 = "".
	
	update rdate rdate1 receive receive1 with frame a.
	
	if rdate = ? then rdate = low_date.
	if rdate1 = ? then rdate1 = hi_date.
	if receive1 = "" then receive1 = hi_char.
	
	{mfselbpr.i "printer" 132}
	
	for each prh_hist where prh_domain = global_domain and prh_rcp_date >= rdate and prh_rcp_date <= rdate1
		and prh_receiver >= receive and prh_receiver <= receive1 no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = prh_part no-lock,
		each ad_mstr where ad_domain = global_domain and ad_addr = prh_vend no-lock:
		
		find first ptmstr where ptmstr.pt_domain = global_domain and ptmstr.pt_part = pt_mstr.pt_group no-lock no-error.
		
		disp 	prh_receiver     	column-label "待检单号"
					prh_rcp_date			column-label "打单时间"
					prh_part					column-label "编码"
					pt_mstr.pt_desc1	column-label "零件名称"
					prh_rcvd					column-label "送检数量"
					ptmstr.pt_desc1	when avail ptmstr	column-label "车型"
					prh_vend 					column-label "厂家编码" 
					ad_name						column-label "厂家名称"
		with stream-io width 200.
			
	end.
	
	{mfreset.i}
	{mfgrptrm.i}
	
end. /* mainloop */	
