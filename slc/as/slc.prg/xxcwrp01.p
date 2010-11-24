/* SS - 090520.1 By: Neil Gao */
/* SS - 091112.1 By: Neil Gao */

{mfdtitle.i "091112.1"}

define var yr like glc_year.
define var per like glc_per.
define var part like pt_part.
define var part2 like pt_part.
define var tqty01 like ld_qty_oh.

form
	yr 			colon 15
	per 		colon 15
	part 		colon 15
	part2 	colon 48
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).
	
mainloop:
repeat:
	
	if part2 = hi_char then part2 = "".
	
	update yr per part part2 with frame a.
	
	if part2 = "" then part2 = hi_char.
	
	find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
	if not avail glc_cal then do:
	 	message "期间不存在".
	 	next.
	end.
	if glc_user1 <> "" then do:
		message "挂账已经关闭".
		next.
	end.

	{mfselprt.i "printer" 132}
	
	for each tr_hist use-index tr_part_eff where tr_domain = global_domain and tr_qty_loc <> 0 and tr_part < "A"
 		and tr_part >= part and tr_part <= part2 and tr_ship_type = "" and tr_loc <> "ic01"
 		and tr_effdate >= glc_start and tr_effdate <= glc_end no-lock,
 		each pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock
 		break by tr_part by substring(tr_serial,7)
 		with frame c width 200 down :
 		
 		if (tr_type = "rct-tr" and tr_program = "xxtrchmt.p" )
				or tr_type = "RCT-PO" or tr_type = "rct-unp" or tr_type = "iss-prv" 
				or tr_type = "rct-wo" then tqty01 = tqty01 + tr_qty_loc.
				
 		if last-of(substring(tr_serial,7)) then do:
 			
 			find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per 
 				and xxzgp_vend = substring(tr_serial,7) and xxzgp_part = tr_part no-lock no-error.
 			if avail xxzgp_det then next.
 			
 			find last xxpc_mstr where xxpc_domain = global_domain and xxpc_nbr <> "" and xxpc_approve_userid <> "" 
				and xxpc_list = substring(tr_serial,7) and xxpc_part = tr_part
				and (xxpc_start <= today or xxpc_start = ? ) and ( xxpc_expire >= today or xxpc_expire  = ? ) no-lock no-error.
			if avail xxpc_mstr then next.
			
 			find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,7) no-lock no-error.
 			
 			find last xxzgp_det where xxzgp_domain = global_domain  
 					and xxzgp_vend = substring(tr_serial,7) and xxzgp_part = tr_part no-lock no-error.
 			
 			disp 	tr_part column-label "物料号"
 						pt_desc1 column-label "名称"
 						pt_desc2 column-label "规格" format "x(76)"
 						substring(tr_serial,7) column-label "供应商"
 						substring(vd_sort,1,4) when avail vd_mstr column-label "简称"
 						tqty01	column-label "入库数量"
 						xxzgp_price when avail xxzgp_det column-label "前期暂估价"
 		  with frame c.
 		  
/* SS 090717.1 - B */
 		  find first cd_det where cd_domain = global_domain and cd_ref = tr_part and cd_type = "SC"	
 		  	and cd_lang = "CH" no-lock no-error.
 		  if avail cd_det then do:
 		  	disp cd_cmmt[1] @ pt_desc2 with frame c.
 		  end.
/* SS 090717.1 - E */
 		  
 		  down with frame c.
 			tqty01 = 0.
 		end. /* if last-of(substring(tr_serial,7)) then do */
 	
 	end. /* for each tr_hist */

	{mfreset.i}
	{mfgrptrm.i}
	
end.