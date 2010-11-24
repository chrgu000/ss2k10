/* SS - 090403.1 By: Neil Gao */

{mfdeclre.i}  
{gplabel.i} 

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
  vend			colon 12
  ifsel			colon	12 label "默认选择"
  ifxg			colon 12 label "允许修改"
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
   
   update 
   	yr
   	per
   	vend
   	ifsel
   	ifxg
   with frame a.
   
   	find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
		  if not avail glc_cal then do:
		  	message "期间不存在".
		  	next.
		end.
		find prev glc_cal where glc_domain = global_domain no-lock no-error.
		if avail glc_cal then do:
			yr1 = glc_year.
			per1 = glc_per.
		end.
   
	 empty temp-table ttr_det.
	 
	 for each xxtr_mstr where xxtr_domain = global_domain 
	 		and xxtr_loc <> "NC2" and xxtr_loc <> "NC3" and xxtr_loc <> "ic1"
	 		and xxtr_part < "T" and (xxtr_vend = vend or vend = "")
	 		and xxtr_year = yr and xxtr_per = per no-lock,
	 		each vd_mstr where vd_domain = global_domain and vd_addr = xxtr_vend no-lock
	 		break by xxtr_vend	by xxtr_part:
	 		
	 		find first xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr and xxgzd_site = "10000"
      	and xxgzd_per = per and xxgzd_vend   = xxtr_vend and xxgzd_part = xxtr_part no-lock no-error.
    	if avail xxgzd_det then do:
    		/*message "供应商:" xxtr_vend xxtr_part "已经挂账".*/
    		next.
    	end.
	 			
	 		find last xxpc_mstr where xxpc_domain = global_domain and xxpc_list = xxtr_vend and xxpc_part = xxtr_part
				and (xxpc_start = ? or xxpc_start <= today ) and (xxpc_expire = ? or xxpc_expire >= today )	no-lock no-error.
	 		
	 		if vd_type = "IN" then do:
	 			if ( xxtr_type = "rct-tr" and xxtr_sort = "po" ) or xxtr_type = "iss-prv"
	 	    then tmpqty = tmpqty + xxtr_qty.
	 	  end.
	 		else do:
	 			if ( xxtr_type = "iss-wo" or xxtr_type = "iss-unp" or xxtr_type = "iss-so" or xxtr_type = "TAG-CNT")
	 			then tmpqty = tmpqty - xxtr_qty.
	 		end.
	 		if last-of(xxtr_part) and tmpqty <> 0 then do:
	 			/* 加上上期未开数量 */
	 			find first xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr1 and xxgzd_site = "10000"
      		and xxgzd_per = per1 and xxgzd_vend   = xxtr_vend and xxgzd_part = xxtr_part no-lock no-error.
	 			if avail xxgzd_det then tmpqty = tmpqty + xxgzd_end_qty.
	 			
	 			create 	ttr_det.
	 			if ifsel then ttr_sel = "*".
	 			if vd_type = "IN" then ttr_sort = "入库".
	 			else ttr_sort = "耗用".
	 			assign 	ttr_vend = xxtr_vend
	 							ttr_part = xxtr_part.
	 			if avail xxpc_mstr then do:
	 				ttr_price = xxpc_amt[1].
	 				ttr_qty   = tmpqty.
	 			end.
	 			else ttr_qty1 = tmpqty.
	 			tmpqty = 0.
	 		end.
	 end.
	 
	 	find first ttr_det no-lock no-error.
	 	if not avail ttr_det then do:
	 		message "记录不存在".
	 		next.
		end.
	 
	 hide frame a no-pause.
   view frame d.
   pause 0.
   sw_reset = yes.
   scroll_loop:
   repeat with frame d:
	 	 
	   	/*pause 0.*/
      if sw_reset then do:
      end.
   
      do:
        {xusel.i
         	&detfile = ttr_det
         	&scroll-field = ttr_sel
         	&framename = "d"
         	&framesize = 8
         	&searchkey = " "
         	&display1     = ttr_sel
         	&display2     = ttr_sort
         	&display3     = ttr_vend
         	&display4     = ttr_part
         	&display5     = ttr_price
         	&display6     = ttr_qty
         	&display7     = ttr_qty1
         	&sel_on    = ""*""
         	&sel_off   = """"
         	&exitlabel = scroll_loop
         	&exit-flag = true
         	&record-id = tt_recid
         	&CURSORDOWN = "find first ad_mstr where ad_domain = global_domain and ad_addr = ttr_vend no-lock no-error.
         								 if avail ad_mstr then disp ad_name with frame c.
         								 disp ttr_price * ttr_qty @ xxgzamt with frame c.
         								 find first cd_det where cd_domain = global_domain and cd_ref = ttr_part and cd_type = 'SC' 
         								 	and cd_lang = 'ch' no-lock no-error.
         								 	if avail cd_det then disp cd_cmmt[1] cd_cmmt[2] cd_cmmt[3] with frame c.
         								"
        	&CURSORUP   = "find first ad_mstr where ad_domain = global_domain and ad_addr = ttr_vend no-lock no-error.
         								 if avail ad_mstr then disp ad_name with frame c.
         								 disp ttr_price * ttr_qty @ xxgzamt with frame c.
         								 find first cd_det where cd_domain = global_domain and cd_ref = ttr_part and cd_type = 'SC' 
         								 	and cd_lang = 'ch' no-lock no-error.
         								 	if avail cd_det then disp cd_cmmt[1] cd_cmmt[2] cd_cmmt[3] with frame c.
         								"         
   				}
      end.
      
      
      if keyfunction(lastkey) = "end-error" then do:
      	update-yn = no.
       	{pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
       	if update-yn = yes then leave.
     	end.

			/* If you press return then in modify mode */
      if lastkey = 24 /*and recno <> ?*/
      then do:
      	if ifxg then do:
      		tmpqty = ttr_qty.
      		update ttr_qty with frame d.
      		ttr_qty1 = ttr_qty1 + (tmpqty - ttr_qty).
      	end.
			end. /* if keyfunction */
			else if keyfunction(lastkey) = "insert-mode" then 
			do on error undo,retry:
			end.
			else if keyfunction(lastkey) = "go"
      then do:
      	update-yn = no.
       	{pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=update-yn}
       	if update-yn = no then leave.
      	
      	for each ttr_det where ttr_sel = "*" and ( ttr_qty <> 0 or ttr_qty1 <> 0 ) no-lock ,
      		each pt_mstr where pt_domain = global_domain and pt_part = ttr_part no-lock
      		break by ttr_vend:
      		
      		create 	xxgzd_det.
      		assign 	xxgzd_domain = global_domain
      						xxgzd_year   = yr
      						xxgzd_per    = per
      						xxgzd_vend   = ttr_vend
      						xxgzd_sort   = ttr_sort
      						xxgzd_site   = "10000"
      						xxgzd_part   = ttr_part
      						xxgzd_price  = ttr_price
      						xxgzd_qty    = ttr_qty
      						xxgzd_end_qty = ttr_qty1
      						xxgzd_amt    = ttr_qty * ttr_price.
      		
      		accumulate xxgzd_amt ( total by ttr_vend ).
      		
      		if last-of(ttr_vend) then do:
      			find first xxgz_mstr where xxgz_domain = global_domain and xxgz_year = yr and xxgz_per = per
      				and xxgz_site = "10000" and xxgz_sort = ttr_sort and xxgz_vend = ttr_vend no-error.
      			if not avail xxgz_mstr then do:
      				create 	xxgz_mstr.
      				assign 	xxgz_domain = global_domain
      							xxgz_year		= yr
      							xxgz_per    = per
      							xxgz_site   = "10000"
      							xxgz_sort   = ttr_sort
      							xxgz_vend   = ttr_vend
      							xxgz_amt    = accum total by ttr_vend xxgzd_amt.
      			end.
      			else do:
      				xxgz_amt = xxgz_amt + accum total by ttr_vend xxgzd_amt.
      			end.
      		end.
      		
      	end.
      	leave.
      end. /*else if keyfunction(lastkey) = "go"*/
			sw_reset = no.
   end. /* do with frame d */
   
   hide frame d no-pause.
   
end. /* repeat with frame a */

status input.

