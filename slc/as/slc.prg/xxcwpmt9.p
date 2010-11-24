/* SS - 090403.1 By: Neil Gao */

{mfdtitle.i "090623.1"}

define variable site like in_site init "10000".
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
define variable ttqty1 like tr_qty_loc.
define variable ttprice like pt_price.
define variable ttamt like ar_amt.
define var xxtype as logical format "Y)正常/N)暂估" init yes.
define variable ponbr like po_nbr.
define variable poline like pod_line.
define var tnbr as char.
define buffer trhist for tr_hist. 

	DEFINE VARIABLE wpage     AS integer format ">>>" init 1.
	DEFINE VARIABLE wct_desc  LIKE ct_desc NO-UNDO.
	DEFINE VARIABLE i		AS	INTEGER.
	DEFINE VARIABLE xxrmk as char format "x(4)" label "其他".
	DEFINE VARIABLE xxi   as int label "序" format ">>>" .
	define variable v_ok  as logical.
	define variable adname like ad_name.
	define variable xxqty1 like tr_qty_loc.
	define variable xxqty2 like xxqty1.
	define variable xxqty3 like xxqty1.
	 
form
	 yr												colon 15
	 per											colon 15
	 xxtype 									colon 15 label "Y)正常/N)暂估"
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	vend colon 15
	part colon 15
	skip(1) 
	xxtr_qty colon 15
	xxtr_price colon 15
  xxtr_tax_pct colon 15 
with frame b side-labels width 80 attr-space.

setframelabels(frame b:handle).
	
	
	{wbrp01.i}
	mainloop:
	REPEAT ON ENDKEY UNDO, LEAVE:

		update
	   	yr
	   	per
	   	xxtype
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
		  
		vend = "".
		part = "".
		repeat on error undo,leave:
			
			update vend part with frame b.
			
			find first vd_mstr where vd_domain = global_domain and vd_addr = vend no-lock no-error.
			if not avail vd_mstr then do:
				message "错误: 供应商代码不存在".
				next-prompt vend with frame b.
				undo,retry.
			end.
				
			find first pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error.
			if not avail pt_mstr then do:
				message "错误:物料号不存在".
				next-prompt part with frame b.
				undo,retry.
			end.
			
			loop1:
			do on error undo,leave :
				
				create xxtr_hist.
				
				assign 	xxtr_domain = global_domain
								xxtr_site = site
								xxtr_year = yr
								xxtr_per	= per
								xxtr_vend = vend
								xxtr_effdate = today
								xxtr_time = time
								xxtr_type = if xxtype then "RCT-PO" else "RCT-ZG"
								xxtr_sort = "IN"
								xxtr_part = part
								xxtr_tax_pct = 17
								.
				disp xxtr_price with frame b.
				update xxtr_qty xxtr_price xxtr_tax_pct  with frame b.

/* SS 090609.1 - B */
/*				
				if xxtr_qty = 0 or xxtr_price = 0 then do:
					message "错误: 数量或者价格不能为零 ".
					undo,retry.
				end.
*/
/* SS 090609.1 - E */
				xxtr_amt = xxtr_qty * xxtr_price.
				
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
						     xxld_type = if xxtype then "正常" else "暂估"
						     xxld_zg_qty = if xxtype then 0 else xxtr_qty
						     .
				end.
				else do:
					xxld_qty  = xxld_qty + xxtr_qty.
					xxld_zg_qty = if xxtype then xxld_zg_qty else (xxld_zg_qty + xxtr_qty).
					xxld_tax_amt = xxld_tax_amt + xxtr_amt.
					xxld_amt = xxld_amt + xxtr_amt / ( 1 + xxld_tax_pct / 100 ).
				end.
				
				/*增加收货表*/
				if xxtype then do:
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
								 xxglpod_type = "正常"
								 .
					end.
					else do:
						xxglpod_amt   = xxglpod_amt + xxtr_amt.
						xxglpod_qty   = xxglpod_qty + xxtr_qty.
					end.
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
								xxglt_type = if xxtype then "PO" else "POZG"
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
			end. /* loop1: */
		  		 
		end.
		
		hide frame b no-pause.
		
	END.

	{wbrp04.i &frame-spec = a}

