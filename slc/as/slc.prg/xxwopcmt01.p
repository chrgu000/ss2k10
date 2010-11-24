/*By: Neil Gao 08/10/04 ECO: *SS 20081004* */

{mfdeclre.i}  
{gplabel.i} 

define new shared var site like pt_site no-undo.
define var stdate as date label "日期".
define new shared var sonbr  like so_nbr no-undo.
define new shared var sonbr1 like so_nbr no-undo.
define new shared var ord		like so_ord_date no-undo.
define new shared var ord1	like so_ord_date no-undo.
define new shared var line   like ln_line no-undo.
define new shared var line1  like ln_line no-undo.
define new shared var sodline like sod_line no-undo.
define var xxdate1 as date.
define var i as int.
define new shared variable prline   like  rps_line.
define new shared variable line_rate      like lnd_rate.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define new shared variable part         like seq_part.
define new shared variable tmpqty like sod_qty_ord.
define var update-yn as logical.
define buffer ptmstr for pt_mstr.
define buffer xxseqmstr for xxseq_mstr.
define variable del-yn like mfc_logical.
define var xxsodnbrline as char.
define var pcdate as date.
define var xxper as int.

define var xxprline as char.

	DEFINE VARIABLE vchr_filename_in AS CHARACTER.
	DEFINE VARIABLE vchr_filename_out AS CHARACTER.	
	DEFINE VARIABLE vlog_fail_flag AS LOGICAL.

	vchr_filename_in = "./ssi" + mfguser.
	vchr_filename_out = "./sso" + mfguser.

define temp-table xusod_det
	field xusod_sel as char format "x(1)"
	field xusod_nbr like sod_nbr
	field xusod_line like sod_line
	field xusod_cust like so_cust
	field xusod_part like sod_part
	field xusod_ord_date like so_ord_date
	field xusod_due_date like sod_due_date
	field xusod_qty_ord like sod_qty_ord
	field xusod_type as char
	field xusod_wod_lot like wod_lot
	index xusod_nbr
	xusod_nbr
	xusod_part
	xusod_due_date.

define new shared temp-table xuln_det no-undo
	field xuln_sel as char format "x(1)"
	field xuln_line like ln_line
	field xuln_seq  like lnd_run_seq1
	field xuln_rate like lnd_rate
	field xuln_rate1 like lnd_rate
	index xuln_line 
	xuln_seq 
	xuln_line.

define new shared temp-table tmtwo no-undo
	field tmtwo_f1 like xxseq_priority
	field tmtwo_f2 like xxseq_site.

form
   site     colon 12
   sonbr    colon 12   sonbr1 colon 45
   ord 			colon 12   ord1		colon 45
   line     colon 12   
   sodline  colon 45 label "项"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form 
	xusod_sel column-label "选"
	xusod_nbr column-label "订单"
	xusod_line column-label "项"
	xusod_cust column-label "客户"
	xusod_part column-label "物料号"
	xusod_ord_date column-label "订单日期"
	xusod_due_date column-label "发货日期"
	xusod_qty_ord column-label "数量"
with frame b width 80 8 down scroll 1 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
	
		
/* DISPLAY */
view frame a.
stdate = today.
site = global_site.

mainloop:
repeat transaction on error undo,retry with frame a:
   
   if sonbr1 = hi_char then sonbr1 = "".
   if ord 	 = low_date then ord = ?.
   if ord1   = hi_date then ord1 = ?.
   
   update 
   	site 
   	sonbr	sonbr1
   	ord		ord1
   	line 	sodline
   with frame a.
   
   if sonbr1 = "" then sonbr1 = hi_char.
   if ord = ? then ord = low_date.
   if ord1 = ? then ord1 = hi_date.
   if line1 = "" then line1 = hi_char.
	 global_site = site.
	 
	 for each xusod_det:
	 	delete xusod_det.
	 end.
	 
		empty temp-table tmtwo.
	 
	 for each so_mstr where so_domain = global_domain
	 		and so_nbr >= sonbr and so_nbr <= sonbr1 
	 		no-lock,
	 	each sod_det where sod_domain = global_domain 
	 		and not sod_confirm 
	 		and sod__log01 /* 评审完成 */
			and (sodline = 0 or sod_line = sodline)
	 		and sod_nbr = so_nbr and sod_site = site no-lock,
	 	each pt_mstr where pt_domain = global_domain 
	 		and pt_part = sod_part 
			and pt_pm_code <> "P"	 		
	 		no-lock:
	 			
	 	/*已经排程订单不显示*/
	 	find first xxseq_mstr where xxseq_domain = global_domain and xxseq_part = sod_part
				and xxseq_site = site and xxseq_sod_nbr = sod_nbr and xxseq_sod_Line = sod_line no-lock no-error.
			if avail xxseq_mstr then next.
			
	 	find last lnd_det where lnd_domain = global_domain 
			and lnd_site = site	and lnd_part = pt_part and lnd_start <= today
			and (line = "" or lnd_line = line ) no-lock no-error.
		if not avail lnd_det then 
	 	find last lnd_det where lnd_domain = global_domain 
			and lnd_site = site	and lnd_part = pt_group and lnd_start <= today
			and (line = "" or lnd_line = line ) no-lock no-error.
	 		
	 		
	 		if not avail lnd_det then message sod_part "没有维护生产线" view-as alert-box. 
	 		else do:
	 			create xusod_det.
	 			assign xusod_nbr = sod_nbr
	 					 xusod_line = sod_line
	 					 xusod_cust = so_cust
	 					 xusod_part = sod_part
	 					 xusod_ord_date = so_ord_date
	 					 xusod_due_date = sod_due_date
	 					 xusod_qty_ord = sod_qty_ord.
	 		end.
	 end.
	 				
   find first xusod_det no-lock no-error.
   if not avail xusod_det then do:
   		message "没有未安排的订单".
   end.
   
   scroll_loop:
   do with frame b:
   	  tt_recid = ?.
   	  first-recid = ?.
   		if avail xusod_det then
    	{xusel.i
         &detfile = xusod_det
         &scroll-field = xusod_nbr
         &framename = "b"
         &framesize = 8
         &display1     = xusod_sel
         &display2     = xusod_nbr
         &display3     = xusod_line
         &display4     = xusod_cust
         &display5     = xusod_part
         &display6     = xusod_ord_date
         &display7     = xusod_due_date
         &display8     = xusod_qty_ord
         &sel_on    = ""*""
         &sel_off   = """"
         &exitlabel = scroll_loop
         &exit-flag = true
         &record-id = tt_recid
         &include1 = " "
         &include2 = " "
         }
   		   		
   end. /* do with frame b */

   	if lastkey = keycode("CTRL-D") and avail xusod_det then do:
      del-yn = yes.
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
      if del-yn = yes then do:
  			if xusod_type = "" then do:
  				message "请确认此订单".
  			end.
  			hide frame b no-pause.
  			next mainloop.
   		end.
   	end.
   
   if keyfunction(lastkey) = "end-error" then do:
   		release xusod_det.
   end.
   
   if avail xusod_det then do:
   		xxsodnbrline = "".
   		for each xusod_det where xusod_sel = "*" no-lock:
   			
   			if xxsodnbrline = "" then xxsodnbrline = xusod_nbr + string(xusod_line).
   			else xxsodnbrline = xxsodnbrline + "," + xusod_nbr + string(xusod_line).
   			/*bom的采购提前期*/
   			{gprun.i ""xxwopcmt01x01.p"" "(input site,
   																		 input xusod_nbr,
   																		 input xusod_line,
   																		 output xxper)"}
   		
   			pcdate = today + xxper.
   			/*message "开始排产日期:" pcdate.*/
   			if pcdate = ? then leave.
   			
   			{gprun.i ""xxwopcmt02.p"" "(input site,
   														input xusod_part)"}

   			part = xusod_part.
   			tmpqty = xusod_qty_ord.
   			
   			find first so_mstr where so_domain  = global_domain and so_nbr  = xusod_nbr exclusive-lock no-error.
   			find first sod_det where sod_domain = global_domain and sod_nbr = xusod_nbr 
   				and sod_line = xusod_line and sod_confirm = no exclusive-lock no-error.
   			if not avail sod_det then next.
   			
   			xxprline = "".
				for each xuln_det where xuln_sel = "*" no-lock by xuln_rate:
					if xuln_Line = line or line  = "" then
						xxprline = xxprline + xuln_line + ",".
				end.
   			if xxprline = "" then next.
   			
   			{gprun.i ""xxwopcmt04.p"" "(input xusod_nbr,
														input xusod_line,
														input xusod_part,
   													input pcdate,
   													input sod_due_date,
   													input yes,
   													input-output tmpqty,
   													input xxprline)"
   													}
   		
   			if tmpqty = 0 then do:

   			end.
  			else do:
  				message "撤销排产".
  				undo,next mainloop.
  			end.
   			
   		end. /* for each xusod_det */
   		if xxsodnbrline <> "" then do:
   			{gprun.i ""xxwopcmt03.p"" "(input xxsodnbrline,
   														 input '',
   														 input '',
   														 input today,
   														 input-output tmpqty)"
   														 }
   		end.
   end.
   
   hide frame b no-pause.   
   
   
  	{gprun.i ""xxwopcmt03.p"" "(input '',
   														 input '',
   														 input '',
   														 input today,
   														 input-output tmpqty)"
   														 }
   														 
   update-yn = yes.
   {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=update-yn}
   if update-yn = no then do: 
			message "撤销排产".
  		undo mainloop,next mainloop.
   end.
   else do:
   end.
end. /* repeat with frame a */

status input.
