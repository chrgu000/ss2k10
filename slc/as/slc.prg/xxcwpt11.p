/* SS - 090625.1 By: Neil Gao */
/* SS - 091023.1 By: Neil Gao */

{mfdtitle.i "091023.1"}

define var yr like glc_year.
define var per like glc_per.
define var tsq01 as int.
define var tqty01 like ld_qty_oh.
define var tqty02 like ld_qty_oh.
define var tqty03 like ld_qty_oh.
define var tqty04 like ld_qty_oh.
define var tqty05 like ld_qty_oh.
define var tqty06 like ld_qty_oh.
define var tqty07 like ld_qty_oh.
define var tqty08 like ld_qty_oh.
define var tqty09 like ld_qty_oh.
define var tqty10 like ld_qty_oh.
define var tqty11 like ld_qty_oh.
define var tqty12 like ld_qty_oh.
define var tqty13 like ld_qty_oh.
define var tqty14 like ld_qty_oh.
define var tqty15 like ld_qty_oh.
define var tqty16 like ld_qty_oh.
define var ifdel  as logical.

form
	yr 			colon 15
	per 		colon 15
	ifdel   colon 15 label "删除存在记录"
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).
	
mainloop:
repeat:

	update yr per ifdel with frame a.
	
	
	find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
	if not avail glc_cal then do:
	 	message "期间不存在".
	 	next.
	end.

	
	if not ifdel then do:
		find first xxkc_det where xxkc_domain = global_domain and xxkc_year = yr and xxkc_per = per no-lock no-error.
		if avail xxkc_det then do:
			message "记录已经存在".
			next.
		end.
	end.
	else do:
		for each xxkc_det where xxkc_domain = global_domain and xxkc_year = yr and xxkc_per = per :
			delete xxkc_det.
		end.
	end.
	
	for each tr_hist where tr_domain = global_domain and tr_qty_loc <> 0 and tr_part < "A"
		and tr_effdate >= glc_start /*and tr_effdate <= glc_end*/ 
		and tr_loc <> "IC01" and tr_loc <> "nc02" and tr_loc <> "cs01" and tr_ship_type = "" no-lock
		break by tr_part by substring(tr_serial,7)
		:
		
		if first-of( substring(tr_serial,7) ) then do:
			tqty12 = 0.
			for each ld_det where ld_loc <> "IC01" and ld_loc <> "nc02" and ld_loc <> "cs01" and ld_domain = global_domain and ld_part = tr_part 
				and substring(ld_lot,7)  = substring(tr_serial,7) no-lock :
				tqty12 = tqty12 + ld_qty_oh.
			end.	
			tsq01 = current-value(tr_sq01).
		end.
		if tr_trnbr < tsq01 then do:
			if tr_effdate <= glc_end then do:
				if (tr_type = "rct-tr" and tr_program = "xxtrchmt.p") or tr_type = "rct-po" or tr_type = "iss-prv" then do:
					tqty01 = tqty01 + tr_qty_loc.
				end.
				else if tr_type = "rct-unp" then do:
					tqty02 = tqty02 + tr_qty_loc.
				end.
				else if tr_type = "rct-wo" then do:
					tqty03 = tqty03 + tr_qty_loc.
				end.
				else if tr_type = "rct-tr" then do:
					tqty10 = tqty10 + tr_qty_loc.
				end.
				else if tr_type begins "rct" then do:
					tqty04 = tqty04 + tr_qty_loc.
				end.
				else if tr_type = "iss-wo" then do:
					tqty05 = tqty05 - tr_qty_loc.
				end.
				else if tr_type = "iss-so" then do:
					tqty06 = tqty06 - tr_qty_loc.
				end.
				else if tr_type = "iss-unp" then do:
					tqty07 = tqty07 - tr_qty_loc.
				end.
				else if tr_type = "iss-tr" then do:
					tqty10 = tqty10 + tr_qty_loc.
				end.
				else if tr_type begins "iss" then do:
					tqty08 = tqty08 - tr_qty_loc.
				end.
				else if tr_type = "CYC-CNT" or tr_type = "CYC-RCNT" or tr_type = "TAG-CNT" then do:
					tqty09 = tqty09 + tr_qty_loc.
				end.
				else do:
					tqty11 = tqty11 + tr_qty_loc.
				end.
				tqty13 = tqty13 + tr_qty_loc.
			end. /* if tr_effdate > glc_end then do:*/
			else do:
				tqty14 = tqty14 + tr_qty_loc.
			end.
			
		end. /* if tr_trnbr < tsq01 */
		
		if last-of( substring(tr_serial,7) ) then do:
			
			tqty15 = tqty12 - tqty13 - tqty14.
			tqty16 = tqty12 - tqty14.
			
			create xxkc_det.
			assign xxkc_domain = global_domain 
						 xxkc_year = yr
						 xxkc_per  = per
						 xxkc_part = tr_part
						 xxkc_vend = substring(tr_serial,7)
						 xxkc_beg_qty = tqty15
					 	 xxkc_rct_po  = tqty01
					 	 xxkc_rct_unp = tqty02
					   xxkc_rct_wo  = tqty03 
					   xxkc_rct_qt  = tqty04
					   xxkc_iss_wo  = tqty05
					   xxkc_iss_so  = tqty06
					   xxkc_iss_unp = tqty07
					   xxkc_iss_qt  = tqty08
					   xxkc_cyc     = tqty09
					   xxkc_tr      = tqty10
					   xxkc_chg_qty = tqty13
					   xxkc_end_qty = tqty16
					   .
			
			tqty01  = 0.
			tqty02  = 0.
			tqty03  = 0.
			tqty04  = 0.
			tqty05  = 0.
			tqty06  = 0.
			tqty07  = 0.
			tqty08  = 0.
			tqty09  = 0.
			tqty10  = 0.
			tqty11  = 0.
			tqty12  = 0.
			tqty13  = 0.
			tqty14  = 0.
			tqty15  = 0.
			tqty16  = 0.
			
		end.
		
	end.
	
	for each ld_det where ld_loc <> "IC01" and ld_loc <> "nc02" and ld_loc <> "cs01" and ld_qty_oh <> 0 no-lock 
		break by ld_part by substring(ld_lot,7):
		
		tqty16 = tqty16 + ld_qty_oh.
		if last-of(substring(ld_lot,7)) then do:
			find first xxkc_det where xxkc_domain = global_domain and xxkc_year = yr and xxkc_per = per
				and xxkc_part = ld_part and xxkc_vend = substring(ld_lot,7) no-lock no-error.
			if avail xxkc_det then .
			else do:
				create xxkc_det.
				assign xxkc_domain = global_domain 
						 xxkc_year = yr
						 xxkc_per  = per
						 xxkc_part = ld_part
						 xxkc_vend = substring(ld_lot,7)
						 xxkc_beg_qty = tqty16
					 	 xxkc_end_qty = tqty16
					   .
			end.
			tqty16 = 0.
		end. /* if last-of(substring(ld_lot,7)) */
	end.

end. /* mainloop */
