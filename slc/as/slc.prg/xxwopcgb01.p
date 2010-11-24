/* By: Neil Gao Date: 07/10/11 ECO: * ss 20071011 */
/* By: Neil Gao Date: 07/11/28 ECO: * ss 20071128 */
/*By: Neil Gao 08/04/15 ECO: *SS 20080415* */
/*By: Neil Gao 08/04/17 ECO: *SS 20080417* */

{mfdeclre.i}  
{gplabel.i} 

define new shared var site like pt_site.
define var stdate as date label "日期".
define var date1 as date.
define var date2 as date.
define var sonbr  like so_nbr.
define var sonbr1 like so_nbr.
define var ord		like so_ord_date.
define var ord1		like so_ord_date.
define var line   like ln_line.
define var line1  like ln_line.
define var xxdate1 as date.
define var i as int.
define new shared variable prline   like  rps_line.
define new shared variable line_rate      like lnd_rate.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define new shared variable part         like seq_part.
define new shared variable hours          as   decimal extent 4.
define new shared variable cap            as   decimal extent 4.
define variable sw_reset     like mfc_logical. 
define var tmpqty like ld_qty_oh.
define var tmppick like ld_qty_oh.
define var tmpqty1 as int. /* 缺料种类 */
define var tmpqty2 like ld_qty_oh. /* 缺料数量 */
define var inpqty like ld_qty_oh.
define var update-yn as logical.
define var tothours as decimal format "->>>>>>>9.9<".
define var totqty   as decimal.
define var tmprmks as char.
define var ii like xxseq_priority.
define var duedate as date.
define var isel as logical init yes.
define var icomp as logical init yes.
define var tcomp as logical.
define buffer womstr for wo_mstr.

define variable new_priority   as   decimal no-undo.
	DEFINE VARIABLE vchr_filename_in AS CHARACTER.
	DEFINE VARIABLE vchr_filename_out AS CHARACTER.	
	DEFINE VARIABLE vlog_fail_flag AS LOGICAL.

	vchr_filename_in = "./ssi" + mfguser.
	vchr_filename_out = "./sso" + mfguser.

define temp-table xuseq_mstr
	field xuseq_sel  as char format "x(1)"
	field xuseq_site like xxseq_site
	field xuseq_priority like xxseq_priority
	field xuseq_ii like xxseq_priority
  field xuseq_wod_lot like xxseq_wod_lot
  field xuseq_wo_comp like wo_qty_comp
  field xuseq_wod_qty like xxseq_qty_req format "->>>>>>>>"
  field xuseq_wod_comp like xxseq_qty_req format "->>>>>>>>"
  field xuseq_sod_nbr like xxseq_sod_nbr
  field xuseq_sod_line like xxseq_sod_line   
  field xuseq_due_date like xxseq_due_date   
  field xuseq_line like xxseq_line       
  field xuseq_part like xxseq_part       
  field xuseq_qty_req like xxseq_qty_req
  field xuseq_qty_pick like xxseq_qty_req
  field xuseq_pick_rmks as char
  field xuseq_qty2 like xxseq_qty_req
  field xuseq_chgtype as char
  field xuseq_shift1 like xxseq_shift1
  field xuseq_status as char format "x(1)"
  index xuseq_ii
  xuseq_ii
  index xuseq_priority
  xuseq_priority.

define buffer s1 for xuseq_mstr.
define buffer s2 for xxseq_mstr.

form
   sonbr    colon 15  sonbr1  colon 45
   date1 		colon 15  date2		colon 45
   icomp 		colon 15 label "只显示完成WO"
   isel			colon 45 label "默认选择"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


form
	 xuseq_sel  column-label "选"  format "x(1)"
   xuseq_ii   column-label "序号" format ">>>>>>>"
   xuseq_wod_lot column-label "ID" 
   xuseq_sod_nbr column-label "订单号"
   xuseq_due_date   column-label "生产日期"
   xuseq_part       column-label "物料号"
   xuseq_qty_req    column-label "数量"
   xuseq_wod_comp   column-label "入库数量"
   /*xuseq_status     column-label "R"*/
with frame d down no-attr-space width 80
title color normal (getFrameTitle("AVAILABLE_SEQUENCE_RECORDS",34)).
/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).
	
/* DISPLAY */
view frame a.

stdate = today.
site = "10000".
date2 = today.

mainloop:
repeat with frame a:
   
   if date1	 = low_date then date1  = ?.
   if date2  = hi_date  then date2 = ?.
   if sonbr1 = hi_char then sonbr1 = "".
   
   update 
   	sonbr sonbr1
   	date1	date2
   	icomp
   	isel
   with frame a.
   
   if date1 = ? then date1 = low_date.
   if date2 = ? then date2 = hi_date.
	 if sonbr1 = "" then sonbr1 = hi_char.
	 
   empty temp-table xuseq_mstr.
   
   i = 1.
   
   for each xxseq_mstr where xxseq_domain = global_domain 
    and xxseq_site = site and xxseq_user1 = "R"
    and xxseq_sod_nbr >= sonbr and xxseq_sod_nbr <= sonbr1
   	and xxseq_due_date >= date1 and xxseq_due_date <= date2
   	by xxseq_due_date by xxseq_line by xxseq_shift4:
   		
   		tcomp = no.
			find first wo_mstr where wo_mstr.wo_domain = global_domain and wo_mstr.wo_lot = xxseq_wod_lot no-lock no-error.
			if avail wo_mstr then do:
				if index(wo_mstr.wo_part,"BZ") > 0 then do: 
					find first womstr where womstr.wo_domain = global_domain and womstr.wo_nbr = string(xxseq_sod_nbr) + string(xxseq_sod_line,"999") 
						and womstr.wo_status <> "C" no-lock no-error.
					if avail womstr and icomp then next.
					if not avail womstr then tcomp = yes.
				end.
				else do:
					if wo_mstr.wo_qty_ord > wo_mstr.wo_qty_comp and icomp then next.
					if wo_mstr.wo_qty_ord > wo_mstr.wo_qty_comp then tcomp = yes.
				end.
				find first wod_det where wod_domain = global_domain and wod_lot = xxseq_wod_lot
		 			and wod_part < "A" and wod_qty_req > wod_qty_iss no-lock no-error.
		 		if not avail wod_det and tcomp then .
		 		else tcomp = no.
				if icomp and not tcomp then next.
			end.
			else next.

   		create xuseq_mstr.
   		assign xuseq_ii       = i
   					 xuseq_site     = xxseq_site
   					 xuseq_priority = xxseq_priority
   					 xuseq_due_date = xxseq_due_date
   					 xuseq_line     = xxseq_line
   					 xuseq_part     = xxseq_part
   					 xuseq_qty_req  = xxseq_qty_req
   					 xuseq_wod_qty  = xxseq_qty_req
   					 xuseq_wod_comp = wo_mstr.wo_qty_comp
   					 xuseq_wod_lot  = xxseq_wod_lot
   					 xuseq_sod_nbr  = xxseq_sod_nbr
   					 xuseq_sod_line = xxseq_sod_line
   					 xuseq_shift1   = xxseq_shift1.
   	 	if xxseq_user1 <> "F" then xuseq_status = xxseq_user1.
		 	i = i + 1.
		 	if tcomp and isel then do:
		 		xuseq_sel = "*".
		 		/*
		 		if xuseq_wod_comp = 0 then xuseq_wod_comp = xxseq_qty_req.
		 		*/
		 	end.
   end.
   
   find first xuseq_mstr no-lock no-error.
   if not avail xuseq_mstr then next mainloop.
      
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
         	&detfile = xuseq_mstr
         	&scroll-field = xuseq_sel
         	&framename = "d"
         	&framesize = 8
         	&display1     = xuseq_sel
         	&display2     = xuseq_ii
         	&display3     = xuseq_wod_lot
         	&display4     = xuseq_sod_nbr
         	&display5     = xuseq_due_date
         	&display7     = xuseq_part
         	&display8     = xuseq_qty_req
         	&display9 		= xuseq_wod_comp
         	&sel_on    = ""*""
         	&sel_off   = """"
         	&exitlabel = scroll_loop
         	&exit-flag = true
         	&record-id = tt_recid
         	&CURSORDOWN = "         	             "
        	&CURSORUP   = "          	             "         
   				}
      end.     
      if keyfunction(lastkey) = "end-error" then do:
      	update-yn = no.
       	{pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
       	if update-yn = yes then leave.
     	end.

			/* If you press return then in modify mode */
      if keyfunction(lastkey) = "return" and recno <> ?
      then do:
			end. /* if keyfunction */
			else if keyfunction(lastkey) = "insert-mode" then 
			do on error undo,retry:
			end.
			else if keyfunction(lastkey) = "go"
      then do:
      	update-yn = no.
       	{pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=update-yn}
       	if update-yn = no then next.
      	for each xuseq_mstr where xuseq_sel = "*" no-lock:
      		find first wo_mstr where wo_mstr.wo_domain = global_domain and wo_mstr.wo_lot = xuseq_wod_lot no-lock no-error.
      		if not avail wo_mstr then do:
      			message "加工单ID" xuseq_wod_lot "不存在".
      			next.
      		end.
      		if wo_mstr.wo_rel_date > wo_mstr.wo_due_date then duedate = wo_mstr.wo_rel_date.
      		else duedate = wo_mstr.wo_due_date.
      		
      		&GLOBAL-DEFINE dputline1 "" .
					&GLOBAL-DEFINE dputline2 "" .
					&GLOBAL-DEFINE dputline3 "" .
					&GLOBAL-DEFINE dputline4 "" .
					&GLOBAL-DEFINE dputline5 "" .
					
					{xxcimmd.i &putline1 = "'- ' xuseq_wod_lot"
					           &putline2 = "'- - - ' duedate ' C' "
					           &putline3 = "'.'"
					           &putline4 = "'-'"
					           &putline5 = "'.'"
					           &execname = "wowomt.p"
								           }
					
      		for each xxseq_mstr where xxseq_domain = global_domain and xxseq_priority = xuseq_priority
      			and xxseq_site = xuseq_site ,
      			each wo_mstr where wo_mstr.wo_domain = global_domain and wo_mstr.wo_lot = xxseq_wod_lot and wo_mstr.wo_status = "c" no-lock :
      			delete xxseq_mstr.
      		end.
      		
      	end.
      	message "完成".
      	leave.
      end.
			
   end. /* do with frame d */
   
   hide frame d no-pause.
   
end. /* repeat with frame a */

status input.

