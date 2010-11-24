/* SS - 090813.1 By: Neil Gao */
/* SS - 091118.1 By: Neil Gao */

{mfdtitle.i "091118.1"}

define var date1 as date.
define var date2 as date.
define var part like pt_part.
define var part2 like pt_part.
define var wolot like wo_lot.
define var wolot1 like wo_lot.
define var sodpart like sod_part.
define var sodpart1 like sod_part.
/* SS 091118.1 - B */
define var sonbr like so_nbr.
define var sonbr1 like so_nbr.
/* SS 091118.1 - E */

form
	date1 colon 12 
	date2 colon 45
	part colon 12
	part2 colon 45
/* SS 091118.1 - B */
	sonbr colon 12
	sonbr1 colon 45
/* SS 091118.1 - E */
	wolot colon 12
	wolot1 colon 45
	sodpart 	colon 12 label "成品编码"
	sodpart1 	colon 45 label "至"
with frame a side-labels width 80 attr-space.
setframelabels(frame a:handle).
	
mainloop:
repeat:
	
	if date1 = low_date then date1 = ?.
	if date2 = hi_date  then date2 = ?.
	if part2 = hi_char  then part2 = "".
	if wolot1 = hi_char then wolot1 = "".
/* SS 091118.1 - B */
	if sonbr1 = hi_char then sonbr1 = "".
/* SS 091118.1 - E */
	if sodpart1 = hi_char then sodpart1 = "".
	
	update date1 date2 part part2 sonbr sonbr1 wolot wolot1 sodpart sodpart1 with frame a.
	
	if date1 = ? then date1 = low_date.
	if date2 = ? then date2 = hi_date.
	if part2 = "" then part2 = hi_char.
	if wolot1 = "" then wolot1 = hi_char.
	if sodpart1 = "" then sodpart1 = hi_char.
/* SS 091118.1 - B */
	if sonbr1 = "" then sonbr1 = hi_char.
/* SS 091118.1 - E */
	
	{mfselprt.i "printer" 400}
	
	for each xxtr_hist where xxtr_domain = global_domain 
		and xxtr_effdate >= date1 and xxtr_effdate <= date2
		and xxtr_part  >= part and xxtr_part <= part2 
		and xxtr_lot >= wolot and xxtr_lot <= wolot1
		no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = xxtr_part no-lock,
		each vd_mstr where vd_domain = global_domain and vd_addr = xxtr_vend no-lock:
		
		find first wo_mstr where wo_domain = global_domain and wo_lot = xxtr_lot no-lock no-error.
		if avail wo_mstr then do:
			if wo_part < part or wo_part > part2 then next.
/* SS 091118.1 - B */
			if wo_so_job < sonbr or wo_so_job > sonbr1 then next.
/* SS 091118.1 - E */
		end.
		else do:
			if part > "" then next.
		end.
		
		find first cd_det where cd_domain = global_domain and cd_type = "sc" and cd_lang = "ch" 
			and cd_ref = xxtr_part no-lock no-error.
		
		disp 	xxtr_year column-label "年份"
					xxtr_per column-label "期间"
					xxtr_effdate column-label "日期"
					xxtr_type  column-label "事务类型"
					xxtr_nbr column-label "订单"
					xxtr_lot column-label "工单ID"
					wo_part when avail wo_mstr column-label "成品编码"
					pt_part column-label "物料编码"
					pt_desc1 column-label "物料名称"
					xxtr_vend column-label "供应商编码"
					vd_sort format "x(8)" column-label "供应商简称" 
					xxtr_qty column-label "数量"
					xxtr_price column-label "含税单价"
					xxtr_amt column-label "金额"
					cd_cmmt[1] when avail cd_det column-label "物料描述"
		with stream-io width 400.
			
	end.
	
	{mfreset.i}
	{mfgrptrm.i}
	
end. /* mainloop */