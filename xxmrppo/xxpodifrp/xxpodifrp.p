/*xxpodifrp.p                                                                */
/*revision: 120612.1   created on: 20110831   by: zhang yun                  */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "120618.1"}

define variable vend  like po_vend no-undo.
define variable vend1 like po_vend no-undo.
define variable part  like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable due   as   date    no-undo.
define variable due1  as   date    no-undo.
define variable ptdesc like pt_desc1 no-undo.
define variable vdsort like vd_sort no-undo.
define variable codecmmt like code_cmmt no-undo.
define variable posdiff as decimal no-undo format "->,>>,>>>,>>9.9<".
define variable qty   as decimal no-undo.
define variable tqty  as decimal no-undo format "->,>>,>>>,>>9.9<".
define variable tdate as date no-undo.

define temp-table tmp_pod
    fields tpd_vend like vd_addr format "x(12)"
    fields tpd_part like pt_part
    fields tpd_tdate as date
    fields tpd_tqty like pod_qty_ord format "->,>>,>>>,>>9.9<"
    fields tpd_qty  like pod_qty_ord format "->,>>,>>>,>>9.9<"
    fields tpd_mqty like pod_qty_ord format "->,>>,>>>,>>9.9<"
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
                &printwidth = 152
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
   assign tdate = ?.
   for each pod_det no-lock use-index pod_partdue where pod_part >= part and
           (pod_part <= part1 or part1 = "") and
            pod_due_date >= due and
           (pod_due_date <= due1 or due1 = ?) and
           pod_type = "T",
       each po_mstr no-lock where po_nbr = pod_nbr and
            po_vend >= vend and
           (po_vend <= vend1 or vend1 = "") break by pod_part
           by pod_due_date:
        if first-of(pod_due_date) then do:
        	 assign tdate = pod_due_date.
        end.
        find first tmp_pod where tpd_part = pod_part no-error.
        if not available tmp_pod then do:
           create tmp_pod.
           assign tpd_part = pod_part
                  tpd_vend = po_vend
                  tpd_tdate = tdate.
        end.
        assign tpd_tqty = tpd_tqty + pod_qty_ord.
   end.

   for each tmp_pod exclusive-lock:
   		 assign qty = 0.
   		 if due = ? then do:
   	   		assign tdate = tpd_tdate.
   	   end.
   	   else do:
   	   		assign tdate = due.
   	   end.
       for each pod_det no-lock where pod_part = tpd_part and
                pod_due_date >= tpd_tdate and
                pod_due_date >= tdate and
               (pod_due_date <= due1 or due1 = ?) and
                pod_type = "",
          each po_mstr no-lock where po_nbr = pod_nbr and
               po_vend >= vend and
              (po_vend <= vend1 or vend1 = ""):
           assign qty = qty + pod_qty_ord.
       end.  		 
       assign tpd_qty = qty.
   end.

   for each tmp_pod exclusive-lock:
       assign qty = 0.
       for EACH mrp_det no-lock WHERE mrp_det.mrp_part = tpd_part and
                mrp_det.mrp_detail = "¼Æ»®µ¥" and
                mrp_site = "gsa01" and
                mrp_due_date >= due and (mrp_due_date <= due1 or due1 = ?)
                USE-INDEX mrp_part.
                assign qty = qty + mrp_qty.
       end.
       assign tpd_mqty = qty.
   end.

  {mfphead.i}
   for each tmp_pod no-lock with frame x with width 152:
       setframelabels(frame x:handle).
       find first vd_mstr no-lock where vd_addr = tpd_vend no-error.
       if available vd_mstr then do:
            display tpd_vend vd_sort format "x(24)" tpd_part tpd_tdate tpd_tqty
                    tpd_qty tpd_qty - tpd_tqty @ posdiff tpd_mqty
                    tpd_mqty - (tpd_tqty - tpd_qty) @ tqty.
       end.
       {mfrpchk.i}
   end.
end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}

