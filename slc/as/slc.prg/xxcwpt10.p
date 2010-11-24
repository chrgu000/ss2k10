/* SS - 090521.1 By: Neil Gao */
{mfdtitle.i "090521.1"}

define variable yr like glc_year.
define variable per like glc_per.
define variable part like mrp_part.
define variable part2 like mrp_part.
define variable date as date .
define variable date2 as date.
define variable effdate as date init today.
define variable xxdesc2 like pt_desc2.
define variable vend like po_vend.
define variable vend1 like po_vend.
define variable ponbr like po_nbr.
define variable poline like pod_line.
define buffer trhist for tr_hist. 
define var yn as logical.
define var site like in_site init "10000".
define var tnbr as char.
define var tt_recid as recid.
define var first-recid as recid.
define var update-yn as logical.
define var tqty01 like ld_qty_oh.

define temp-table tt1
	field tt1_f1 like xxtr_vend
	field tt1_f2 like pod_nbr
	field tt1_f3 like pod_line
	field tt1_f4 like xxtr_part
	field tt1_f5 like xxtr_qty
	field tt1_f6 like pod_pur_cost
	field tt1_f7 as logical 
	index tt1_f2 tt1_f2 tt1_f3
  .
	 
define temp-table tt2
	field tt2_f1 like pod_nbr
	field tt2_f2 like pod_line
	field tt2_f3 like tr_trnbr
	.

form
	 yr					colon 15 
	 per				colon 15 
	 vend 			colon 15
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form                                  
  tt1_f2 column-label "采购单"        
	tt1_f3 column-label "项"         
	tt1_f4 column-label "物料号"          
	tt1_f5 column-label "数量"          
	tt1_f6 column-label "价格"
	tt1_f7 column-label "挂账"          
with frame b width 80 5 down scroll 1.
	
mainloop:
REPEAT ON ENDKEY UNDO, LEAVE:

		update
	   	yr
	   	per
			vend
			WITH FRAME a.

		 find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
		 if not avail glc_cal then do:
		 	message "期间不存在".
		 	next.
		 end.
		 if glc_user1 <> "" then do:
				message "挂账已经关闭".
				next.
		 end.
		 date 	= glc_start.
		 date2 = glc_end.
			
			/*检查是否有价格 */
/* SS 090521.1 - B */
/*			
			for each tr_hist where tr_domain = global_domain and tr_site = site and tr_part < "A"
				and tr_effdate >= date and tr_effdate <= date2 and tr_serial begins "A"
				and tr_qty_loc <> 0	and tr_ship_type = "" and tr_loc <> "ic01" no-lock:
				
				find first pod_det where pod_domain = global_domain and pod_nbr = tr_nbr
				if not avail xxzgp_det then do:
					message "错误:" substring(tr_serial,7) tr_part "没有价格".
					next mainloop.
				end.
			end.
*/
/* SS 090521.1 - E */			
			empty temp-table tt1.
			
			for each tr_hist where tr_domain = global_domain and tr_site = site and tr_part < "A"
				and tr_effdate >= date and tr_effdate <= date2 and tr_serial begins "A"
				and (tr_type = "rct-tr" and tr_program = "xxtrchmt.p" ) and tr_rmks begins "RC"
				and substring(tr_serial,7) = vend and not tr__log02
				and tr_qty_loc <> 0	and tr_ship_type = "" and tr_loc <> "ic01" no-lock:

				find first prh_hist use-index prh_receiver where prh_domain = global_domain 
					and prh_receiver = entry(1,tr_rmks,"-") no-lock no-error.
				if not avail prh_hist then next.
						
				find first tt1 where tt1_f1 = prh_vend and tt1_f2 = prh_nbr and tt1_f3 = prh_line
					and prh_part = tt1_f4 no-error.
				if not avail tt1 then do:
					find first pod_det where pod_domain = global_domain and pod_nbr = prh_nbr 
						and pod_line = prh_line no-lock no-error.
					create 	tt1.
					assign 	tt1_f1 = prh_vend
									tt1_f2 = prh_nbr
									tt1_f3 = prh_line
									tt1_f4 = prh_part
									tt1_f5 = tr_qty_loc
									.
					if avail pod_det then do:
						assign tt1_f6 = pod_pur_cost.
						if pod_pur_cost <> 0 then tt1_f7 = yes.
					end.
				end.
				else do:
					tt1_f5 = tt1_f5 + tr_qty_loc.
				end.
				
				create tt2.
				assign tt2_f1 = prh_nbr
							 tt2_f2 = prh_line
							 tt2_f3 = tr_trnbr
							 .
			
			end. /* for each tr_hist */
	
	find first tt1 no-lock no-error.
	if not avail tt1 then do:
		message "无记录".
		next.
	end.
			
	loop1:
	repeat on error undo, leave:
		{xuview.i
    	     &buffer = tt1
    	     &scroll-field = tt1_f2
    	     &framename = "b"
    	     &framesize = 5
    	     &display1     = tt1_f2
    	     &display2     = tt1_f3
    	     &display3     = tt1_f4
    	     &display4     = tt1_f5
    	     &display5     = tt1_f6
    	     &display6     = tt1_f7
    	     &searchkey    = true
    	     &logical1     = false
    	     &first-recid  = first-recid
    	     &exitlabel = loop1
    	     &exit-flag = true
    	     &record-id = tt_recid
    	     &cursordown = " 		
                         "
    	     &cursorup   = " 
                         "
    	     }
    
		if keyfunction(lastkey) = "end-error" then do:
			update-yn = no.
      {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
       if update-yn = yes then next mainloop.
       else next loop1.
		end.
		
		if keyfunction(lastkey) = "return" then 
		do on error undo,retry :
			update tt1_f7 with frame b.
		end.
		
		if keyfunction(lastkey) = "go" then do:
			update-yn = yes.
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=update-yn}
      if update-yn = no then next loop1.
			
			for each tt1 no-lock where tt1_f7:
				
				tqty01 = 0.
				for each tt2 where tt2_f1 = tt1_f2 and tt2_f2 = tt1_f3 no-lock,
					each tr_hist where tr_domain = global_domain and tr_trnbr = tt2_f3 and not tr__log02:
						
					tqty01 = tqty01 + tr_qty_loc.
					tr__log02 = yes.
					
				end.
				if tqty01 = 0 then next.
				
				/* 事物记录 */
				create  xxtr_hist.
				assign 	xxtr_domain = global_domain
								xxtr_year = yr 
								xxtr_per	= per
								xxtr_vend = tt1_f1
								xxtr_nbr  = tt1_f2
								xxtr_line = tt1_f3
								xxtr_effdate = today
								xxtr_time = time
								xxtr_type = "RCT-XC"
								xxtr_sort = "IN"
								xxtr_part = tt1_f4
								xxtr_tax_pct = 17
								xxtr_price = tt1_f6
				        xxtr_qty  = tqty01
				        xxtr_amt = tqty01 * tt1_f6.
				        .	
				
				/* 库存记录 */
				find first xxld_det where xxld_domain = global_domain and xxld_part = xxtr_part and xxld_vend = xxtr_vend
					and xxld_nbr = xxtr_nbr and xxld_line = xxtr_line and xxld_year = yr and xxld_per = per no-error.
				if not avail xxld_det then do:	
					create xxld_det .
					assign xxld_domain = global_domain
						     xxld_vend   = xxtr_vend
						     xxld_part   = xxtr_part
						     xxld_nbr    = xxtr_nbr
						     xxld_qty    = xxtr_qty
						     xxld_year   = yr
						     xxld_per  	 = per
						     xxld_tax_price = xxtr_price
						     xxld_tax_pct = xxtr_tax_pct
						     xxld_price  = xxtr_price / ( 1 + xxld_tax_pct / 100 )
						     xxld_amt = xxtr_price * xxtr_qty
						     xxld_tax_amt = xxtr_amt
						     xxld_type = "现采" 
						     .
				end.
				else do:
					xxld_qty  = xxld_qty + xxtr_qty.
					xxld_tax_amt = xxld_tax_amt + xxtr_amt.
					xxld_amt = xxld_amt + xxtr_amt / ( 1 + xxld_tax_pct / 100 ).
				end.
				
				/*增加收货表*/
				find first xxglpod_det where xxglpod_domain = global_domain and xxglpod_year = yr
					and xxglpod_per = per and xxglpod_nbr = xxtr_nbr and xxglpod_line = xxtr_line 
					and xxglpod_vend = xxtr_vend and xxglpod_part = xxtr_part no-error.
				if not avail xxglpod_det then do:
					create xxglpod_det.
					assign xxglpod_domain = global_domain
							 xxglpod_year   = yr
							 xxglpod_per    = per
							 xxglpod_nbr    = xxtr_nbr
							 xxglpod_line   = xxtr_line
							 xxglpod_vend   = xxtr_vend
							 xxglpod_part   = xxtr_part
							 xxglpod_curr   = "RMB"
							 xxglpod_tax_pct = xxtr_tax_pct
							 xxglpod_price  = xxtr_price
							 xxglpod_qty    = xxtr_qty
							 xxglpod_amt    = xxtr_amt
							 xxglpod_type = "现采"
							 .
				end.
				else do:
					xxglpod_qty   = xxglpod_qty + xxtr_qty.
					xxglpod_amt   = xxglpod_amt + xxtr_amt.
				end.
				
				/*增加总帐记录*/
				tnbr = "PO" + substring(string(yr,"9999"),3,2) + string(per,"99") .
				find last xxglt_det where xxglt_domain = global_domain and xxglt_ref begins tnbr no-error.
				if avail xxglt_det then tnbr = tnbr + string((int(substring(xxglt_ref,7,6)) + 1),"999999").
				else tnbr = tnbr + "000001".
				
				create 	xxglt_det.
				assign  xxglt_domain = global_domain
								xxglt_ref = tnbr
								xxglt_year = yr
								xxglt_per  = per
								xxglt_type = "POXC"
								xxglt_nbr  = xxtr_nbr
								xxglt_line = xxtr_line
								xxglt_effdate = today
								xxglt_date = today
								xxglt_time = time
								xxglt_price = xxtr_price / ( 1 + xxld_tax_pct / 100 )
								xxglt_part  = xxtr_part
								xxglt_qty   = xxtr_qty
								xxglt_amt   = xxtr_amt / ( 1 + xxld_tax_pct / 100 )
								.
				xxtr_glnbr = tnbr.
			end. /* for each tt1 no-lock */
			leave loop1.
		end. /* if keyfunction(lastkey) = "go" then do: */
	end. /* repeat on error undo, leave */
	
	hide frame b no-pause.
	
END. /* mainloop */ 

