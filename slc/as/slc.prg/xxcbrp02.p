/* SS - 091012.1 By: Neil Gao */
/* SS - 091021.1 By: Neil Gao */

{mfdtitle.i "091021.1"}

define var sonbr like so_nbr.
define var sonbr1 like so_nbr.
define var part like pt_part.
define var part2 like pt_part.
define var xxi as int.
define var xxqty like tr_qty_loc.
define var maxprice like pt_price.
define var minprice like pt_price.
define var maxvend like ad_addr.
define var minvend like ad_addr.
define var totamt   like ar_amt.
define var totqty   like tr_qty_loc.
define var totpct   like vp_tp_pct.
define var xxprice like pt_price.
define var parpart  like pt_part.
define var vend like po_vend.

form
	sonbr colon 12
	sonbr1 colon 45
	part colon 12
	part2 colon 45
	skip(1)
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).

form
	so_nbr column-label "订单号"	
	wo_nbr column-label "工单号"	
	wo_lot column-label "工单ID"
	sod_part column-label	"成品编码"
	pt_desc1 column-label "成品名称" 
	cd_cmmt[1]	column-label "成品描述" format "x(30)"
	tr_part column-label "物料编码"
	pt_desc2 column-label "物料名称" 
	cd_cmmt[2] column-label "物料描述"
	vend     column-label "供应商编码"
	vd_sort  column-label "供应商简称" format "x(8)"
	totqty   column-label "领用数量"
	minprice format ">>>,>>9.9<<<"	column-label "实际单价"
	totamt   column-label "金额"
with frame c down width 300 no-attr-space.

mainloop:
repeat:
	
	if sonbr1 = hi_char then sonbr1 = "".
	if part2 = hi_char then part2 = "".
	
	update sonbr sonbr1 part part2 with frame a.
	
	if part2 = "" then part2 = hi_char.
	if sonbr1 = "" then sonbr1 = hi_char.
	
	{mfselprt.i "printer" 132}
	
	for each so_mstr where so_domain = global_domain and so_nbr >= sonbr and so_nbr <= sonbr1 no-lock,
		each sod_det where sod_domain = global_domain and sod_nbr = so_nbr 
			and sod_part >= part and sod_part <= part2 no-lock:
		if so_nbr begins "D" then do:
			for each wo_mstr where wo_domain = global_domain and wo_nbr begins (so_nbr + string(sod_line,"999")) no-lock,
				each wod_det where wod_domain = global_domain and wod_nbr = wo_nbr and wod_lot = wo_lot and wod_part < "D" no-lock,
				each tr_hist where tr_domain = global_domain and tr_nbr = wo_nbr and tr_lot = wo_lot and tr_type = "iss-wo"
					and tr_part = wod_part no-lock 
				break by wod_part by substring(tr_serial,7):
				
				vend = substring(tr_serial,7).
				{gprun.i ""xxgetprice.p"" "(input vend,input wod_part,input tr_effdate,output xxprice)"}
				totamt = totamt + xxprice * ( - tr_qty_loc ).
				totqty = totqty - tr_qty_loc.
				if last-of( substring(tr_serial,7)) then do:
					find first pt_mstr where pt_domain = global_domain and pt_part = wo_part no-lock no-error.
					find first cd_det where cd_domain = global_domain and cd_ref = wo_part and cd_lang = "ch" and cd_type = "sc" no-lock no-error.
					disp 	so_nbr
								wo_nbr	
								wo_lot
								sod_part 
								pt_desc1 when avail pt_mstr
								cd_cmmt[1]	when avail cd_det
					with frame c .
					
					find first pt_mstr where pt_domain = global_domain and pt_part = wod_part no-lock no-error.
					find first cd_det where cd_domain = global_domain and cd_ref = wod_part and cd_lang = "ch" and cd_type = "sc" no-lock no-error.
					find first vd_mstr where vd_domain = global_domain and vd_addr = vend no-lock no-error.
					disp 	tr_part 
							  pt_desc1 when avail pt_mstr @ pt_desc2
								cd_cmmt[1] when avail cd_det  @ cd_cmmt[2]
								vend     
								vd_sort  when avail vd_mstr format "x(8)"
								totqty   
								(totamt / totqty) @ minprice 
								totamt 
					with frame c.
					down with frame c.
					totqty = 0.
					totamt = 0.
				end. /* last-of */
			end. /* for each wo_mstr */
		end. /* if so_nbr begins */
		else do:
			for each tr_hist where tr_domain = global_domain and tr_part = sod_part and tr_type = "iss-so" and tr_nbr = so_nbr
				and tr_line = sod_line no-lock 
				break by substring(tr_serial,7):
				
				vend = substring(tr_serial,7).
				{gprun.i ""xxgetprice.p"" "(input vend,input tr_part,input tr_effdate,output xxprice)"}
				totamt = totamt + xxprice * ( - tr_qty_loc ).
				totqty = totqty - tr_qty_loc.
				
				if last-of( substring(tr_serial,7)) then do:
					find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
					find first cd_det where cd_domain = global_domain and cd_ref = tr_part and cd_lang = "ch" and cd_type = "sc" no-lock no-error.
					disp 	so_nbr 
								sod_part 
								pt_desc1 when avail pt_mstr
								cd_cmmt[1] when avail cd_det
					with frame c .
					
					find first vd_mstr where vd_domain = global_domain and vd_addr = vend no-lock no-error.
					disp 	tr_part 
								pt_desc1 when avail pt_mstr  @ pt_desc2
								cd_cmmt[1] when avail cd_det @ cd_cmmt[2]
								vend     
								vd_sort  when avail vd_mstr format "x(8)"
								totqty   
								(totamt / totqty) @ minprice 
								totamt 
					with frame c.
					down with frame c.
					totqty = 0.
					totamt = 0.
				end. /* last-of */
					
			end. /* for each */
		end.
	
	end. /* for each so_mstr */
	
	{mfreset.i}
	{mfgrptrm.i}
	
end. /* mainloop */
