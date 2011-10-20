/*xxpodifrp.p                                                                  */
/* revision: 110831.1   created on: 20110831   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "111017.1"}

define variable vend  like po_vend no-undo.
define variable vend1 like po_vend no-undo.
define variable part  like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable due   as   date    no-undo.
define variable due1  as   date    no-undo.
define variable ptdesc like pt_desc1 no-undo.
define variable vdsort like vd_sort no-undo.
define variable codecmmt like code_cmmt no-undo.

define temp-table tmp_pod 
		fields tpd_vend like vd_addr
		fields tpd_part like pt_part
		fields tpd_tqty like pod_qty_ord
		fields tpd_qty  like pod_qty_ord
		index tpd_part tpd_part.

form
   skip(.2)
   vend  colon 15
   vend1 colon 49 label {t001.i}
   part  colon 15
   part1 colon 49 label {t001.i}
   due   colon 15
   due1  colon 49 label {t001.i}  
   skip(2)
with frame a  side-labels width 80 attr-space.
setframelabels(frame a:handle).

{wbrp01.i}
repeat:
		assign due = today - day(today) + 1.
		assign due1 = date(month(today),28,year(today)) + 5.
		assign due1 = due1 - day(due1).
    if vend1 = hi_char then vend1 = "".
		if part1 = hi_char then part1 = "".
		if due   = low_date then due = ?.
		if due1  = hi_date  then due1 = ?.
    update vend vend1 part part1 due due1 with frame a.

    if vend1 = "" then vend1 = hi_char.
		if part1 = "" then part1 = hi_char.
		if due = ? then due = low_date.
		if due1 = ? then due1 = hi_date.
 
    {gpselout.i &printtype = "printer"
                &printwidth = 80
                &pagedflag = "nopage"
                &stream = " "
                &appendtofile = " "
                &streamedoutputtoterminal = " "
                &withbatchoption = "yes"
                &displaystatementtype = 1
                &withcancelmessage = "yes"
                &pagebottommargin = 6
                &withemail = "yes"
                &withwinprint = "yes"
                &definevariables = "yes"}
mainloop:
do on error undo, return error on endkey undo, return error: 
	 empty temp-table tmp_pod no-error.
	 for each pod_det no-lock where pod_part >= part and
	 				 (pod_part <= part1 or part1 = "") and
	 				  pod_due_date >= due and
	 				 (pod_due_date <= due1 or due1 = ?) and
	 				 pod_type = "T",
	 		 each po_mstr no-lock where po_nbr = pod_nbr and 
	 		 		  po_vend >= vend and 
	 		 		 (po_vend <= vend1 or vend1 = ""):
 		 	  find first tmp_pod where tpd_part = pod_part no-error.
 		 	  if not available tmp_pod then do:
 		 	  	 create tmp_pod.
 		 	  	 assign tpd_part = pod_part
 		 	  	 			  tpd_vend = po_vend.
 		 	  end.
 		 	  assign tpd_tqty = tpd_tqty + pod_qty_ord.	 		 	  
	 end.
	 		 		 
	 for each pod_det no-lock where pod_part >= part and
	 				 (pod_part <= part1 or part1 = "") and
	 				  pod_due_date >= due and
	 				 (pod_due_date <= due1 or due1 = ?) and
	 				 pod_type <> "T",
	 		 each xvp_ctrl no-lock where xvp_part = pod_part,
	 		 each po_mstr no-lock where po_nbr = pod_nbr and 
	 		 		  po_vend >= vend and 
	 		 		 (po_vend <= vend1 or vend1 = ""):
	     find first tmp_pod where tpd_part = pod_part no-error.
	     if not available tmp_pod then do:
 		 	  	 create tmp_pod.
 		 	  	 assign tpd_part = pod_part
 		 	  	 			  tpd_vend = po_vend.
 		 	  end.
 		 	  assign tpd_qty = tpd_qty + pod_qty_ord.		 		  
	 end.
  {mfphead.i}
	 for each tmp_pod no-lock with frame x with width 80:
	     setframelabels(frame x:handle).
	     find first vd_mstr no-lock where vd_addr = tpd_vend no-error.
	     if available vd_mstr then do:
	 	   	  display tpd_vend vd_sort format "x(24)" tpd_part tpd_tqty tpd_qty.
	 	   end.
	 	   {mfrpchk.i}
	 end.	 				 
end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}