/* SS - 090403.1 By: Neil Gao */
/* SS - 090813.1 By: Neil Gao */
/* SS - 100625.1 By: Kaine Zhang */

/* SS - 100625.1 - RNB
[100625.1]
将本期供应商的挂账类型,记入xxgz_sort.供以后报表统计用.
[100625.1]
SS - 100625.1 - RNE */

{mfdtitle.i "100625.1"}

define new shared var site like pt_site.
define var yr like glc_year.
define var per like glc_per.
define var yr1 like glc_year.
define var per1 like glc_per.
define var stdate as date label "日期".
define var date1 as date.
define var date2 as date.
define var sonbr  like so_nbr.
define var sonbr1 like so_nbr.
define var ord		like so_ord_date.
define var ord1		like so_ord_date.
define var part   like pt_part.
define var part1  like pt_part.
define var xxdate1 as date.
define var i as int.
define new shared variable prline   like  rps_line.
define new shared variable line_rate      like lnd_rate.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define variable sw_reset     like mfc_logical. 
define var tmpqty like ld_qty_oh.
define var tmppick like ld_qty_oh.
define var tmpqty1 as int.
define var tmpqty2 like ld_qty_oh.
define var inpqty like ld_qty_oh.
define var update-yn as logical.
define var tothours as decimal format "->>>>>>>9.9<".
define var totqty   as decimal.
define var tmprmks as char.
define var ii like xxseq_priority.
define var duedate as date.
define var tdate1 as date.
define var tdate2 as date.
define var vend  like po_vend.
define var vend1 like po_vend.
define var xxgzqty like xxgzd_qty.
define var xxgzamt like xxgzd_amt.
define var ifxg as logical.
define var ifsel as logical init yes.

define temp-table ttr_det
	field ttr_sel as char format "x(1)"
	field ttr_sort as char format "x(4)"
	field ttr_vend like po_vend
	field ttr_part like pod_part
	field ttr_qty  like pod_qty_ord
	field ttr_qty1 like pod_qty_ord
	field ttr_price like pod_pur_cost
	index ttr_vend
				ttr_sort ttr_vend ttr_part.

form
  yr    		colon 12
  per     	colon 12
  vend			colon 12 vend1 colon 35
  ifxg			colon 12 label "重新生成"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	ad_name no-label
	xxgzamt label "挂账金额" skip
	cd_cmmt[1] no-label at 1
	cd_cmmt[2] no-label at 1
	cd_cmmt[3] no-label at 1
with frame c side-labels width 80 attr-space.

form
	 ttr_sel  	column-label "选"  format "x(1)"
   ttr_sort  	column-label "类别" 
   ttr_vend  	column-label "供应商" 
   ttr_part   column-label "物料号"
   ttr_price  column-label "单价"
   ttr_qty 		column-label "挂账数量"
   ttr_qty1   column-label "未挂数量"
with frame d down no-attr-space width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).
	
/* DISPLAY */
view frame a.

stdate = today.
site = "10000".

mainloop:
repeat with frame a:
   
   hide frame d no-pause.
   hide frame c no-pause.
   
   
   	if vend1 = hi_char then vend1 = "".
   	
   	update yr	per vend 	vend1 ifxg with frame a.
   	
   	if vend1 = "" then vend1 = hi_char.
   	
   	find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
		  if not avail glc_cal then do:
		  	message "期间不存在".
		  	next.
		end.
		if glc_user1 <> "" then do:
			message "挂账已经关闭".
			next.
		end.
   
  	for each xxgzd_det where xxgzd_domain = global_domain 
   		and xxgzd_year = yr and xxgzd_per = per 
   		and xxgzd_vend >= vend and xxgzd_vend <= vend1 :
   		if not ifxg then do:
   			message "错误: 有记录存在".
   			next mainloop.
   		end.
  	end.
	 	
	 	{mfselprt.i "printer" 250}
	 	
	 	for each xxglpod_det where xxglpod_domain = global_domain and xxglpod_year = yr and xxglpod_per = per
	 		and xxglpod_vend >= vend and xxglpod_vend <= vend1 no-lock,
	 		each pt_mstr where pt_domain = global_domain and pt_part = xxglpod_part no-lock
	 		break by xxglpod_vend by xxglpod_part 
	 		with frame f width 200 down :
	 			
	 		find first vd_mstr where vd_domain = global_domain and vd_addr = xxglpod_vend no-lock no-error.
	 		disp 	xxglpod_vend 
	 					substring(vd_sort,1,4) column-label "简称"
	 					xxglpod_part 
	 					pt_desc1  column-label "名称"
	 					xxglpod_type
	 					xxglpod_qty 
	 					xxglpod_price 
	 					xxglpod_amt with frame f.
	 		down with frame f.
	 	end.
	 
	 	{mfreset.i}
		{mfgrptrm.i}
	 
	 	
	 	message "以上信息是否正确，是否生成挂账表" update update-yn.
	 
	 	if update-yn then do:
	 		for each xxgz_mstr where xxgz_domain = global_domain and xxgz_year = yr and xxgz_per = per
	 			and xxgz_vend >= vend and xxgz_vend <= vend1 :
	 			delete xxgz_mstr.
	 		end.
	 		
	 		for each xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr and xxgzd_per = per
	 			and xxgzd_vend >= vend and xxgzd_vend <= vend1:
	 			delete xxgzd_det.
	 		end.
	 		
	 		for each xxglpod_det where xxglpod_domain = global_domain and xxglpod_year = yr and xxglpod_per = per
	 			and xxglpod_vend >= vend and xxglpod_vend <= vend1 no-lock:
	 			
	 			find first xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr 
      		and xxgzd_per = per and xxgzd_vend  = xxglpod_vend and xxgzd_part = xxglpod_part no-error.
      	if not avail xxgzd_det then do:
      		create xxgzd_det.
      		assign xxgzd_domain = global_domain 
      					 xxgzd_year   = yr
      					 xxgzd_per    = per
      					 xxgzd_vend   = xxglpod_vend
      					 xxgzd_part   = xxglpod_part
      					 xxgzd_price  = xxglpod_price
      					 xxgzd_tax_pct = xxglpod_tax_pct
      				   xxgzd_amt    = xxglpod_amt
      					 .
      		if xxglpod_type = "正常"	then xxgzd_qty  = xxglpod_qty.
/* SS 090813.1 - B */
      		/*else xxgzd_zg_qty = xxglpod_qty.*/
/* SS 090813.1 - E */
      	end. /* if not avail xxgzd_det then do: */
      	else do:
      		if xxglpod_type = "正常" then do:
      			xxgzd_qty = xxgzd_qty + xxglpod_qty.
      			xxgzd_amt = xxgzd_amt + xxglpod_amt.
      		end.
      		else do:
/* SS 090813.1 - B */
						/*xxgzd_zg_qty = xxgzd_zg_qty + xxglpod_qty.*/
/* SS 090813.1 - E */      			
      		end.
      	end. /* else do: */
      	find first xxgz_mstr where xxgz_domain = global_domain and xxgz_vend = xxglpod_vend 
      		and xxgz_year = yr and xxgz_per = per	no-error.
      	if not avail xxgz_mstr then do:
      		create xxgz_mstr.
      		assign xxgz_domain = global_domain
      					 xxgz_year   = yr
      					 xxgz_per    = per
      					 xxgz_vend   = xxglpod_vend
      					 .
            
            /* SS - 100625.1 - B */
            find first vd_mstr where vd_domain = global_domain and vd_addr = xxglpod_vend no-lock no-error.
            if available(vd_mstr) then xxgz_sort = vd_type.
            /* SS - 100625.1 - E */
      	end.
      	xxgz_amt = xxgz_amt + xxglpod_amt.
      	
	 		end. /* for each ttr_det no-lock */
	 	end.	
	 	
end. /* repeat with frame a */

status input.

