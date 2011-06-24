/*By: Neil Gao 08/06/30 ECO: *SS 20080630* */

{mfdeclre.i}  
{gplabel.i} 

define new shared var site like pt_site init "CF".
define var xxvend  like po_vend.
define var xxvend1 like po_vend.
define var xxreq	like req_nbr.
define var xxreq1 like req_nbr.
define var xxreldate like req_rel_date.
define var xxreldate1 like req_rel_date. 
define var i as int.
define var tt_recid as recid no-undo.
define var xxmsg1 as char format "x(70)".
define var xxmsg2 as char format "x(70)".

define new shared temp-table xxreq_det
	field xxreq_sel as char format "x(1)"
	field xxreq_vend like po_vend
	field xxreq_nbr like pod_nbr
	field xxreq_reldate like req_rel_date
	field xxreq_part like req_part
	field xxreq_qty like req_qty
	field xxreq_sonbr like so_nbr
	field xxreq_wolot like wo_lot
	field xxreq_type  as char format "x(2)"
	field xxreq_expert as char
	index xxreq_vend
	xxreq_type
	xxreq_vend
	xxreq_nbr.


form
   site     colon 12
   xxvend     colon 12 label "供应商"
   xxvend1    colon 45 label "至"
   xxreq		colon 12   label "申请号"
   xxreq1		colon 45   label "至"
   xxreldate   colon 12   label "发放日期"
   xxreldate1  colon 45   label "至"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
		
form
	xxreq_sel   label "选"
	xxreq_vend  label "供应商"
	xxreq_nbr   label "申请号"
	xxreq_sonbr label "订单"
	xxreq_wolot label "派工单"
	xxreq_reldate label "发放日期"
	xxreq_part  label "物料号"
	xxreq_qty   label "数量" format ">>>>>>>9.9<"
	/*xxreq_type  label "类"*/
with frame b down width 80 .

setFrameLabels(frame b:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
   
   if xxvend1 = hi_char then xxvend1 = "".
   if xxreq1 = hi_char  then xxreq1 = "".
   if xxreldate  = low_date then xxreldate = ?.
   if xxreldate1 = hi_date  then xxreldate1 = ?.
   
   update 
   	site 
    xxvend xxvend1
   	xxreq  xxreq1
   	xxreldate xxreldate1
   with frame a.
   
   if xxvend1 = "" then xxvend1 = hi_char.
   if xxreq1 = "" then xxreq1 = hi_char.
   if xxreldate  = ? then xxreldate  = low_date.
   if xxreldate1 = ? then xxreldate1 = hi_date.
   
	 for each xxreq_det:
	 	delete xxreq_det.
	 end.
	 
	 for each req_det where req_site = site
	 	and req_nbr >= xxreq and req_nbr <= xxreq1 
	 	and req_rel_date >= xxreldate and req_rel_date <= xxreldate1
	 	and req_user1 >= xxvend and req_user1 <= xxvend1 no-lock,
	 	each pt_mstr where pt_part = req_part 
	 	/*and (pt_buyer = global_userid or global_userid = "mfg")*/
	 	no-lock:
	 		
	 	create xxreq_det.
	 	assign xxreq_sel = ""
	 				 xxreq_vend = req_user1 
	 				 xxreq_nbr  = req_nbr
	 				 xxreq_part = req_part
	 				 xxreq_reldate = req_rel_date
	 				 xxreq_qty  = req_qty
	 				 xxreq_wolot = req_so_job
	 				 xxreq_expert = req_user2.
	 	if req_user2 = "SO" then xxreq_type = "SO".
	 	
	 	find first wo_mstr where wo_lot = req_so_job no-lock no-error.
	 	if avail wo_mstr then assign xxreq_sonbr = wo_so_job.
	 	
	 end.
	 
	 
   find first xxreq_det no-lock no-error.
   if not avail xxreq_det then do:
   		message "没有未安排的申请".
   		next.
   end.
   
   scroll_loop:
   do with frame b:
   	 	
    	{xusel.i
         &detfile = xxreq_det
         &scroll-field = xxreq_sel
         &framename = "b"
         &framesize = 8
         &display1     = xxreq_sel
         &display2     = xxreq_vend
         &display3     = xxreq_nbr
         &display4     = xxreq_sonbr
         &display5     = xxreq_wolot
         &display6     = xxreq_part
         &display7     = xxreq_reldate
         &display8     = xxreq_qty
         &sel_on    = ""*""
         &sel_off   = """"
         &exitlabel = scroll_loop
         &exit-flag = true
         &record-id = tt_recid
         &CURSORDOWN = "
         								xxmsg1 = ''.
         								find first pt_mstr where pt_part = xxreq_part no-lock no-error.
         								if avail pt_mstr then xxmsg1 = pt_desc1.
                  			xxmsg2 = ''.
                  			find first ad_mstr where ad_addr = xxreq_vend no-lock no-error.
                  			if avail ad_mstr then xxmsg2 = '供应商:' + ad_name + '  '.
                  			find first pt_mstr where pt_part = xxmsg1 no-lock no-error.
                  			if avail pt_mstr then xxmsg2 = xxmsg2 + pt_desc1.
                  			message xxmsg2.
                       "
         &CURSORUP   = "
         								xxmsg1 = ''.
         								find first pt_mstr where pt_part = xxreq_part no-lock no-error.
         								if avail pt_mstr then xxmsg1 = pt_desc1.
                  			xxmsg2 = ''.
                  			find first ad_mstr where ad_addr = xxreq_vend no-lock no-error.
                  			if avail ad_mstr then xxmsg2 = '供应商:' + ad_name + '  '.
                  			find first pt_mstr where pt_part = xxmsg1 no-lock no-error.
                  			if avail pt_mstr then xxmsg2 = xxmsg2 + pt_desc1.
                  			message xxmsg2.
                       "         
   		}
   		
   		hide frame b no-pause.
   		
   end. /* do with frame b */
   hide frame a no-pause.
   hide frame b no-pause.
   
   find first xxreq_det where xxreq_sel <> "" no-lock no-error.
   if not avail xxreq_det then do:
   		message "没有选择申请".
   end.
   else do:
   	for each xxreq_det where xxreq_sel <> "" no-lock break by xxreq_type by xxreq_vend :
   		if first-of(xxreq_vend) then 
   			{gprun.i ""xxpomt02.p"" "(input false,
   																input xxreq_type,
   	 														 input xxreq_vend)"}
   	 	pause 0.
   	end.
   end.
   
end. /* mainloop */     														  
   
status input.


