/* SS - 090623.1 By: Neil Gao */
/* SS - 091112.1 By: Neil Gao */

{mfdtitle.i "091112.1"}

define var site like in_site init "10000".
define var yr like glc_year.
define var per like glc_per.
define var part like pt_part.
define var part2 like pt_part.
define var vend like po_vend.

define temp-table tt1 
	field tt1_f1 like po_vend
	field tt1_f2 like pt_part
	field tt1_f3 like tr_qty_loc
	index tt1_f1 tt1_f1 tt1_f2
	.

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
	
	empty  temp-table tt1.
	
	for each tr_hist where tr_domain = global_domain and tr_part < "A"
		and tr_effdate >= glc_start and tr_effdate <= glc_end
		and tr_part >= part and tr_part <= part2
		and tr_qty_loc <> 0	and tr_ship_type = "" 
		and tr_loc <> "ic01" and tr_loc <> "nc02" no-lock:
		
		vend = substring(tr_serial,7).
		if /*tr_serial begins "A" or*/ tr_serial begins "B" then do:
			if (tr_type = "rct-tr" and tr_program = "xxtrchmt.p" )
					or tr_type = "RCT-PO" or tr_type = "rct-unp" or tr_type = "iss-prv" or tr_type = "rct-wo"
					or (tr_loc = "nc01" and tr_type = "iss-unp")
			then do:
				find first tt1 where tt1_f1 = vend and tt1_f2 = tr_part no-error.
				if not avail tt1 then do:
					create 	tt1.
					assign  tt1_f1 = vend
								tt1_f2 = tr_part
								tt1_f3  = tr_qty_loc
								.
				end.
				else do:
					assign	tt1_f3 = tt1_f3 + tr_qty_loc.
				end.
			end.
		end. /* if tr_serial begins "B" */
		else if tr_serial begins "C" then do:
			if tr_type = "iss-wo" or tr_type = "iss-unp" or tr_type = "iss-so" then do:
				find first tt1 where tt1_f1 = vend and tt1_f2 = tr_part no-error.
				if not avail tt1 then do:
					create 	tt1.
					assign  tt1_f1 = vend
								tt1_f2 = tr_part
								tt1_f3  = - tr_qty_loc
								.
				end.
				else do:
					assign	tt1_f3 = tt1_f3 - tr_qty_loc.
				end. 
			end.
		end.
						
	end.			
	
	for each tt1 no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = tt1_f2 no-lock:
		
		find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_vend = tt1_f1 
			and xxzgp_part = tt1_f2 no-lock no-error.
		
		find first ad_mstr where ad_domain = global_domain and ad_addr = tt1_f1 no-lock no-error.
		
		disp 	tt1_f1 		column-label "供应商"
					ad_name 	column-label "供应商名称" when avail ad_mstr
					tt1_f2 		column-label "物料号"
					pt_desc1 	column-label "名称"
					pt_desc2	column-label "规格"
					tt1_f3 		column-label "数量"
					xxzgp_price column-label "价格" when avail xxzgp_det
		with stream-io width 200.
		
	
	end. /* for each */
	
	put " " skip.
	
	{mfreset.i}
	{mfgrptrm.i}


end. /* mainloop */