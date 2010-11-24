/* SS - 091012.1 By: Neil Gao */

{mfdtitle.i "091012.1"}

define var part like pt_part.
define var part2 like pt_part.
define var xxi as int.
define var qtyper like ps_qty_per.
define var maxprice like pt_price.
define var minprice like pt_price.
define var maxvend like ad_addr.
define var minvend like ad_addr.
define var totamt   like ar_amt.
define var totpct   like vp_tp_pct.
define var perprice like pt_price.
define var parpart  like pt_part.
define temp-table tt1
	field tt1_f1 like pt_part
	field tt1_f2 like pt_part
	field tt1_f3 like ps_qty_per.

define buffer btt1 for tt1.
define buffer ptmstr for pt_mstr.

form
	skip(1)
	part colon 12
	part2 colon 45
	skip(1)
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).
	
mainloop:
repeat:
	
	if part2 = hi_char then part2 = "".
	
	update part part2 with frame a.
	
	if part2 = "" then part2 = hi_char.
	
	{mfselprt.i "printer" 132}
	
	empty temp-table tt1.
	for each pt_mstr where pt_domain = global_domain and pt_part begins "D" and index(pt_part,"-") > 0 
		and pt_part >= part and pt_part <= part2 no-lock:
		
		for each ps_mstr where ps_domain = global_domain and ps_par = pt_part no-lock:
			find first tt1 where tt1_f1 = pt_part and tt1_f2 = ps_comp no-error.
			if not avail tt1 then do:
				create 	tt1.
				assign 	tt1_f1 = pt_part
								tt1_f2 = ps_comp
								.
			end.
			tt1_f3 = tt1_f3 + ps_qty_per.
		end.
		
	end.
	xxi = 0.
	repeat: 
		for each tt1 ,
			each pt_mstr where pt_domain = global_domain and pt_part = tt1_f2 and pt_pm_code = "M" no-lock:
			qtyper = tt1_f3 .
			parpart = tt1_f1.
			delete tt1.
			for each ps_mstr where ps_domain = global_domain and ps_par = pt_part no-lock:
				find first btt1 where btt1.tt1_f1 = parpart and btt1.tt1_f2 = ps_comp no-error.
				if not avail btt1 then do:
					create 	btt1.
					assign 	btt1.tt1_f1 = parpart
									btt1.tt1_f2 = ps_comp
									.
				end.
				btt1.tt1_f3 = btt1.tt1_f3 + ps_qty_per * qtyper.
			end.
		end.
		xxi = xxi + 1.
		if xxi > 5 then leave.
	end.
	
	for each tt1 no-lock,
		each pt_mstr where pt_mstr.pt_domain = global_domain and pt_mstr.pt_part = tt1_f2 no-lock
		break by tt1_f1 by tt1_f2:
		
		if first-of(tt1_f1) then do:
			put "成车编码;" skip.
			put tt1_f1 ";" skip.
			put "成车状态描述" skip.
			find first cd_det where cd_domain = global_domain and cd_type = "sc" and cd_ref = tt1_f1 and cd_lang = "ch" no-lock no-error.
			if avail cd_det then do:
				put cd_cmmt ";" skip.
			end.
			put ";;;;;;;" "最低成本;;;" "最高成本;;;" "均价成本;" skip.
			put "物料编码;物料名称;车型;物料描述;单位;单车用量;厂家编号;最低价格;金额;厂家编号;最高价格;金额;均价;金额;" skip.
		end.
		put tt1_f2 ";" pt_mstr.pt_desc1 ";" .
		if pt_mstr.pt_group <> "" then do:
			find first ptmstr where ptmstr.pt_domain = global_domain and ptmstr.pt_part = pt_mstr.pt_group no-lock no-error.
			if avail ptmstr then do:
				put unformat replace(ptmstr.pt_desc1,";","").
			end.
		end.
		put ";".
		
		find first cd_det where cd_domain = global_domain and cd_type = "sc" and cd_ref = tt1_f2 and cd_lang = "ch" no-lock no-error.
		if avail cd_det then do:
			put unformat replace(cd_cmmt[1] + cd_cmmt[2] + cd_cmmt[3] + cd_cmmt[4] + cd_cmmt[5] + cd_cmmt[6],";","").
		end.
		put ";" pt_mstr.pt_um ";"  tt1_f3 ";" .
		
		maxprice = 0.
		minprice = 0.
		totamt = 0.
		totpct = 0.
		for each vp_mstr where vp_domain = global_domain and vp_part = tt1_f2 and vp_vend <> "" no-lock break by vp_part:
			find first xxpc_mstr where xxpc_domain = global_domain and xxpc_part = tt1_f2 and (xxpc_start <= today or xxpc_start = ?)
				and xxpc_list = vp_vend and (xxpc_expire >= today or xxpc_expire = ?) no-lock no-error.
			if avail xxpc_mstr then do:
				if maxprice = 0 then assign maxprice = xxpc_amt[1] maxvend = vp_vend.
				else if maxprice < xxpc_amt[1] then assign maxprice = xxpc_amt[1] maxvend = vp_vend.
				if minprice = 0 then assign minprice = xxpc_amt[1] minvend = vp_vend.
				else if minprice > xxpc_amt[1] then assign minprice = xxpc_amt[1] minvend = vp_vend.
				totamt = totamt + xxpc_amt[1] * vp_tp_pct.
				totpct = totpct + vp_tp_pct.
			end.
		end. 
		put unformat minvend ";" minprice ";" minprice * tt1_f3 ";".
		put unformat maxvend ";" maxprice ";" maxprice * tt1_f3 ";".
		if totamt <> 0 then 
		put unformat totamt / totpct ";" totamt / totpct * tt1_f3 ";".
		else put ";" ";".
		put skip.
		
	end.	
	
	{mfreset.i}
	{mfgrptrm.i}
	
end. /* mainloop */
