/* SS - 090403.1 By: Neil Gao */
/* SS - 090812.1 By: Neil Gao */
/* SS - 091112.1 By: Neil Gao */
/* SS - 100623.1 By: Kaine Zhang */

/* SS - 100624.1 - RNB
[100624.1]
#将财务暂估处理产生的xxtr,xxld,xxglpod记录,加上一个_is_zgcl标记.
#在入库处理的时候,不删除有这个标记的记录.
以上问题,不知本程序处理,在[入库处理]程序中处理.
取消修改,本次除mfdtitle的日期版本外,未修改任何实际代码.
[100624.1]
SS - 100624.1 - RNE */

{mfdtitle.i "100624.1"}

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
define variable xxsg as logical format "Y)手工/D)导入".
define variable ponbr like po_nbr.
define variable poline like pod_line.
define buffer trhist for tr_hist.
define var yn as logical.
define var site like in_site init "10000".
define var tnbr as char.

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

define temp-table tt1
	field tt1_f1 like xxtr_vend
	field tt1_f2 like xxtr_part
	field tt1_f3 like xxtr_qty
  .

form
	 yr												colon 15 label "日期"
	 per											colon 15
	 xxsg											colon 15 label "Y)手工/D)导入"
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	vend colon 15
	part colon 15
	skip(1)
	xxtr_qty colon 15
  xxtr_tax_pct colon 15
	xxtr_price colon 15
with frame b side-labels width 80 attr-space.

setframelabels(frame b:handle).


	{wbrp01.i}
	mainloop:
	REPEAT ON ENDKEY UNDO, LEAVE:

		update
	   	yr
	   	per
	   	xxsg
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
		if xxsg then repeat on error undo,leave:

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

			find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per
					and xxzgp_vend = vend and xxzgp_part = part no-lock no-error.
			if not avail xxzgp_det then do:
				find last xxpc_mstr use-index xxpc_nbr where xxpc_domain = global_domain
					and xxpc_list = vend and xxpc_part = part and xxpc_approve_userid <> ""
					and (xxpc_start <= today or xxpc_start = ? ) and ( xxpc_expire >= today or xxpc_expire  = ? ) no-lock no-error.
				if not avail xxpc_mstr then do:
					message "没有价格不能入库".
      		undo,retry.
      	end.
      	create xxzgp_det.
      	assign xxzgp_domain = global_domain
      				 xxzgp_year = yr
      				 xxzgp_per = per
      				 xxzgp_part = part
      				 xxzgp_vend = vend
      				 xxzgp_type = "正常"
      				 xxzgp_price = xxpc_amt[1]
      				 xxzgp_curr  = "RMB"
      				 .
			end.

			loop1:
			do on error undo,leave :

				create xxtr_hist.

				assign 	xxtr_domain = global_domain
								xxtr_site = site
								xxtr_year = yr
								xxtr_per	= per
								xxtr_vend = vend
								xxtr_type = if xxzgp_type = "正常" then "RCT-PO" else "RCT-ZG"
								xxtr_sort = "in"
								xxtr_part = part
								xxtr_price = xxzgp_price
								xxtr_effdate = today
								xxtr_time  = time
								xxtr_rmks  = "手工录入"
								/* SS - 100624.1 - B */
								xxtr_create_by_calc = yes
								/* SS - 100624.1 - E */
								.

				find first ad_mstr where ad_domain = global_domain and ad_addr = vend no-lock no-error.
				if avail ad_mstr then do:
					xxtr_tax_pct = int(ad_taxc) no-error.
				end.

				disp xxtr_price with frame b.
				update xxtr_qty xxtr_tax_pct with frame b.

				if xxtr_qty = 0 then do:
					message "错误: 数量不能为零".
					undo,retry.
				end.

				/* 库存记录 */
				find first xxld_det where xxld_domain = global_domain and xxld_year = yr and xxld_per = per
					and xxld_part = xxtr_part and xxld_vend = xxtr_vend
					and xxld_nbr = xxtr_nbr and xxld_line = xxtr_line no-error.
				if not avail xxld_det then do:

					create xxld_det .
					assign xxld_domain = global_domain
						     xxld_year   = yr
						     xxld_per    = per
						     xxld_vend   = xxtr_vend
						     xxld_part   = xxtr_part
						     xxld_nbr    = xxtr_nbr
						     xxld_line   = xxtr_line
						     xxld_qty    = xxtr_qty
						     xxld_tax_price  = xxtr_price
						     xxld_type   = xxzgp_type
						     xxld_tax_pct = xxtr_tax_pct
						     xxld_price  = xxtr_price / ( 1 + xxld_tax_pct / 100 )
						     xxld_amt = xxtr_price * xxtr_qty
						     xxld_tax_amt = xxtr_amt
						     .

				end.
				else do:
					xxld_qty  = xxld_qty + xxtr_qty.
					xxld_tax_amt = xxld_tax_amt + xxtr_amt.
					xxld_amt = xxld_amt + xxtr_amt / ( 1 + xxld_tax_pct / 100 ).
				end.

				/*增加收货表*/
				if xxtr_type = "RCT-PO" then do:
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
								 /* SS - 100624.1 - B */
								 xxglpod_create_by_calc = yes
								 /* SS - 100624.1 - E */
								 .
					end.
					else do:
						xxglpod_qty   = xxglpod_qty + xxtr_qty.
						xxglpod_amt   = xxglpod_amt + xxtr_amt.
					end.
				end.

				/*总帐记录*/
				tnbr = "PO" + substring(string(yr,"9999"),3,2) + string(per,"99") .
				find last xxglt_det where xxglt_domain = global_domain and xxglt_ref begins tnbr no-error.
				if avail xxglt_det then tnbr = tnbr + string((int(substring(xxglt_ref,7,6)) + 1),"999999").
				else tnbr = tnbr + "000001".

				create 	xxglt_det.
				assign  xxglt_domain = global_domain
								xxglt_ref = tnbr
								xxglt_year = yr
								xxglt_per  = per
								xxglt_type = if xxtr_type = "RCT-PO" then "PO" else "POZG"
								xxglt_nbr  = xxtr_nbr
								xxglt_line = xxtr_line
								xxglt_effdate = today
								xxglt_date = today
								xxglt_time = time
								xxglt_price = xxtr_price / ( 1 + xxld_tax_pct / 100 )
								xxglt_part  = xxtr_part
								xxglt_qty   = xxtr_qty
								xxglt_amt   = xxtr_amt / ( 1 + xxld_tax_pct / 100 )
								/* SS - 100624.1 - B */
								xxglt_create_by_calc = yes
								/* SS - 100624.1 - E */
								.
				xxtr_glnbr = tnbr.

			end. /* loop1: */

		end.
		else do:
			find first xxtr_hist where xxtr_domain = global_domain and xxtr_site = site and xxtr_sort = "in"
				and xxtr_year = yr and xxtr_per = per	no-lock no-error.
			if avail xxtr_hist then do:
				message "记录已存在,是否导入" update yn.
				if yn then do:
/* SS - 100624.1 - B
/* SS 090812.1 - B */
					for each xxtr_hist where xxtr_domain = global_domain and xxtr_year = yr and xxtr_per = per:
						delete xxtr_hist.
					end.
					for each xxld_det where xxld_domain = global_domain and xxld_year = yr and xxld_per = per :
						delete xxld_det.
					end.
					for each xxglpod_det where xxglpod_domain = global_domain and xxglpod_year = yr and xxglpod_per = per :
						delete xxglpod_det.
					end.
					for each xxglt_det where xxglt_domain = global_domain and xxglt_year = yr and xxglt_per = per :
						delete xxglt_det.
					end.
/* SS 090812.1 - E */
SS - 100624.1 - E */
                    /* SS - 100624.1 - B */
					for each xxtr_hist where xxtr_domain = global_domain and xxtr_year = yr and xxtr_per = per
					    and xxtr_create_by_calc:
						delete xxtr_hist.
					end.
					for each xxld_det where xxld_domain = global_domain and xxld_year = yr and xxld_per = per :
						delete xxld_det.
					end.
					for each xxglpod_det where xxglpod_domain = global_domain and xxglpod_year = yr and xxglpod_per = per
					    and xxglpod_create_by_calc:
						delete xxglpod_det.
					end.
					for each xxglt_det where xxglt_domain = global_domain and xxglt_year = yr and xxglt_per = per
					    and xxglt_create_by_calc:
						delete xxglt_det.
					end.
                    /* SS - 100624.1 - E */
				end.
				else next mainloop.
			end.

			/* SS - 100624.1 - B
			/* *ss_20100624* 因为本段代码,未执行任何内容,所以删掉它 */
			/*检查是否有价格 */
			for each tr_hist where tr_domain = global_domain and tr_part < "A"
				and tr_effdate >= date and tr_effdate <= date2
				and tr_qty_loc <> 0	and tr_ship_type = ""
				and tr_loc <> "ic01" and tr_loc <> "nc02" no-lock:

				/*
				find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per
					and xxzgp_vend = substring(tr_serial,7) and xxzgp_part = tr_part no-lock no-error.
				if not avail xxzgp_det then do:
					message "错误:" substring(tr_serial,7) tr_part "没有价格".
					next mainloop.
				end.
				*/
			end.
			SS - 100624.1 - E */

			empty temp-table tt1.

			for each tr_hist where tr_domain = global_domain and tr_part < "A"
				and tr_effdate >= date and tr_effdate <= date2
				and tr_qty_loc <> 0	and tr_ship_type = ""
				and tr_loc <> "ic01" and tr_loc <> "nc02" no-lock:

				vend = substring(tr_serial,7).

				if tr_serial begins "B" then do:
					if (tr_type = "rct-tr" and tr_program = "xxtrchmt.p" )
						or tr_type = "RCT-PO" or tr_type = "rct-unp" or tr_type = "iss-prv" or tr_type = "rct-wo"
					then do:
						find first tt1 where tt1_f1 = vend and tt1_f2 = tr_part no-error.
						if not avail tt1 then do:
							create 	tt1.
							assign 	tt1_f1 = vend
											tt1_f2 = tr_part
											tt1_f3  = tr_qty_loc
											.
						end.
						else do:
							assign	tt1_f3 = tt1_f3 + tr_qty_loc.
						end.
					end.
				end. /*if tr_serial begins "A" or tr_serial begins "B" then do: */
				else if tr_serial begins "C" then do:
					if tr_type = "iss-wo" or tr_type = "iss-unp" or tr_type = "iss-so"
					then do:
						find first tt1 where tt1_f1 = vend and tt1_f2 = tr_part no-error.
						if not avail tt1 then do:
							create 	tt1.
							assign 	tt1_f1 = vend
											tt1_f2 = tr_part
											tt1_f3  = - tr_qty_loc
											.
						end.
						else do:
							assign	tt1_f3 = tt1_f3 - tr_qty_loc.
						end.
					end.
				end. /* if tr_serial begins "C" */

			end. /* for each */

			/*修改库存记录 */
			for each tt1 where tt1_f3 <> 0 no-lock:
				find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per
					and xxzgp_vend = tt1_f1 and xxzgp_part = tt1_f2 no-lock no-error.
				if not avail xxzgp_det then next.

				/* 事物记录 */
				/* SS - 100624.1 - B
				create  xxtr_hist.
				assign 	xxtr_domain = global_domain
								xxtr_year = yr
								xxtr_per	= per
								xxtr_vend = tt1_f1
								xxtr_effdate = today
								xxtr_time = time
								xxtr_type = if xxzgp_type = "正常" then "RCT-PO" else "RCT-ZG"
								xxtr_sort = "IN"
								xxtr_part = tt1_f2
								xxtr_price = xxzgp_price
				        xxtr_qty  = tt1_f3
				        xxtr_amt = xxtr_qty * xxtr_price.
				        xxtr_rmks = "导入"
				        .
                SS - 100624.1 - E */
                /* SS - 100624.1 - B */
                create xxtr_hist.
				assign
				    xxtr_domain = global_domain
					xxtr_year = yr
					xxtr_per	= per
					xxtr_vend = tt1_f1
					xxtr_effdate = today
					xxtr_time = time
					xxtr_type = if xxzgp_type = "正常" then "RCT-PO" else "RCT-ZG"
					xxtr_sort = "IN"
					xxtr_part = tt1_f2
					xxtr_price = xxzgp_price
				    xxtr_qty  = tt1_f3
				    xxtr_amt = xxtr_qty * xxtr_price
				    xxtr_rmks = "导入"
				    xxtr_create_by_calc = yes
				    .
                /* SS - 100624.1 - E */

				find first ad_mstr where ad_domain = global_domain and ad_addr = vend no-lock no-error.
				if avail ad_mstr then do:
					xxtr_tax_pct = int(ad_taxc) no-error.
				end.

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
						     xxld_type = if xxtr_type = "RCT-PO" then "正常" else "暂估"
						     .
				end.
				else do:
					xxld_qty  = xxld_qty + xxtr_qty.
					xxld_tax_amt = xxld_tax_amt + xxtr_amt.
					xxld_amt = xxld_amt + xxtr_amt / ( 1 + xxld_tax_pct / 100 ).
				end.

				/*增加收货表*/
				if xxtr_type = "RCT-PO" then do:
					find first xxglpod_det where xxglpod_domain = global_domain and xxglpod_year = yr
						and xxglpod_per = per and xxglpod_nbr = xxtr_nbr and xxglpod_line = xxtr_line
						and xxglpod_vend = xxtr_vend and xxglpod_part = xxtr_part
						/* SS - 100624.1 - B */
						and xxglpod_create_by_calc = yes
						/* SS - 100624.1 - E */
						no-error.
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
								 /* SS - 100624.1 - B */
								 xxglpod_create_by_calc = yes
								 /* SS - 100624.1 - E */
								 .
					end.
					else do:
						xxglpod_qty   = xxglpod_qty + xxtr_qty.
						xxglpod_amt   = xxglpod_amt + xxtr_amt.
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
								xxglt_type = if xxtr_type = "RCT-PO" then "PO" else "POZG"
								xxglt_nbr  = xxtr_nbr
								xxglt_line = xxtr_line
								xxglt_effdate = today
								xxglt_date = today
								xxglt_time = time
								xxglt_price = xxtr_price / ( 1 + xxld_tax_pct / 100 )
								xxglt_part  = xxtr_part
								xxglt_qty   = xxtr_qty
								xxglt_amt   = xxtr_amt / ( 1 + xxld_tax_pct / 100 )
								/* SS - 100624.1 - B */
								xxglt_create_by_calc = yes
								/* SS - 100624.1 - E */
								.
				xxtr_glnbr = tnbr.


			end.

			{mfselprt.i "printer" 650}

		  /* 显示 */
			for each xxld_det where xxld_domain = global_domain and xxld_year = yr and xxld_per = per no-lock:
				disp xxld_vend xxld_part xxld_type xxld_nbr xxld_qty format "->>>,>>9.9<<"
							xxld_price	xxld_amt with stream-io width 200.
			end.

			{mfreset.i}
			{mfgrptrm.i}
		end. /* else do: */
		hide frame b no-pause.

	END.

	{wbrp04.i &frame-spec = a}

