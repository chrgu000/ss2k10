/* SS - 090625.1 By: Neil Gao */
/* SS - 091025.1 By: Neil Gao */

{mfdtitle.i "091025.1"}

define var yr like glc_year.
define var per like glc_per.
define var part like pt_part.
define var part2 like pt_part.
define var vend like po_vend.
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

	{mfselprt.i "printer" 132}

	form
	with frame c stream-io width 400 down no-attr-space. 
	
	for each tr_hist where tr_domain = global_domain and tr_qty_loc <> 0 and tr_part < "A"
		and tr_effdate >= glc_start /*and tr_effdate <= glc_end*/ 
		and tr_loc <> "IC01" and tr_loc <> "nc02" and tr_loc <> "cs01" and tr_ship_type = ""
		and tr_part >= part and tr_part <= part2 no-lock
		break by tr_part by substring(tr_serial,7)
		:
		
		if first-of( substring(tr_serial,7) ) then do:
			tqty12 = 0.
			for each ld_det where ld_domain = global_domain and ld_part = tr_part 
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
			
			find first ad_mstr where ad_domain = global_domain and ad_addr = substring(tr_serial,7) no-lock no-error.
			find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
			
			disp substring(tr_serial,7) @ vend column-label "供应商"
					 ad_name      column-label "名称" when avail ad_mstr
					 tr_part      column-label "物料号"
					 pt_desc1     column-label "名称" when avail pt_mstr
					 tqty15       column-label "期初数量"
					 tqty01       column-label "采购收货"
					 tqty02       column-label "计划外入库"
					 tqty03       column-label "工单入库"
					 tqty04       column-label "其它入库"
					 tqty05       column-label "工单出库"
					 tqty06       column-label "销售出库"
					 tqty07       column-label "计划外出库"
					 tqty08       column-label "其它出库"
					 tqty09       column-label "盘点调整"
					 tqty10       column-label "转仓"
					 tqty16       column-label "期间结存"
			with frame c.
			down with frame c.
			
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
	
	for each ld_det where ld_loc <> "IC01" and ld_loc <> "nc02" and ld_loc <> "cs01" and ld_qty_oh <> 0 
		and ld_part >= part and ld_part <= part2 no-lock 
		break by ld_part by substring(ld_lot,7):
	
		tqty16 = tqty16 + ld_qty_oh.
		if last-of(substring(ld_lot,7)) then do:
			find first tr_hist where tr_domain = global_domain and tr_qty_loc <> 0 and tr_part = ld_part
				and tr_effdate >= glc_start	and tr_loc <> "IC01" and tr_loc <> "nc02" 
				and ld_loc <> "cs01" and tr_ship_type = "" no-lock no-error.
			if avail tr_hist then .
			else do:
				find first ad_mstr where ad_domain = global_domain and ad_addr = substring(ld_lot,7) no-lock no-error.
				find first pt_mstr where pt_domain = global_domain and pt_part = ld_part no-lock no-error.
			
				disp  substring(ld_lot,7) @ vend column-label "供应商"
					 ad_name      column-label "名称" when avail ad_mstr
					 ld_part @ tr_part      column-label "物料号"
					 pt_desc1     column-label "名称" when avail pt_mstr
					 tqty16 @ tqty15       column-label "期初数量"
					 0 @ tqty01       column-label "采购收货"
					 0 @ tqty02       column-label "计划外入库"
					 0 @ tqty03       column-label "工单入库"
					 0 @ tqty04       column-label "其它入库"
					 0 @ tqty05       column-label "工单出库"
					 0 @ tqty06       column-label "销售出库"
					 0 @ tqty07       column-label "计划外出库"
					 0 @ tqty08       column-label "其它出库"
					 0 @ tqty09       column-label "盘点调整"
					 0 @ tqty10       column-label "转仓"
					 tqty16       column-label "期间结存"
				with with frame c.
				down with frame c.
				
			end.
			tqty16 = 0.
		end. /* if last-of(substring(ld_lot,7)) */
	end.
	
	{mfreset.i}
	{mfgrptrm.i}


end. /* mainloop */



