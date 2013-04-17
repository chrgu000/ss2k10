/*xxmrpporpt.p - pod_type = "T" (T Type) PO Report                           */
/* revision: 110831.1   created on: 20110831   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "120217.1"}

define variable vend  like vd_addr no-undo.
define variable vend1 like vd_addr no-undo.
define variable part  like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable due   as   date no-undo.
define variable due1  as   date no-undo.
define variable line_type as logical initial Yes.
define variable ptdesc like pt_desc1 no-undo.
define variable vdchr03 as character no-undo.

form
   skip(.2)
   vend  colon 15
   vend1 colon 49 label {t001.i}
   part  colon 15
   part1 colon 49 label {t001.i}
   due   colon 15
   due1  colon 49 label {t001.i}
   Line_type colon 15
skip(1)
with frame a  side-labels width 80 attr-space.
setframelabels(frame a:handle).

{wbrp01.i}
repeat:

    if part1 = hi_char then part1 = "".
    if vend1 = hi_char then vend1 = "".
    if due = low_date then due = ?.
    if due1 = hi_date  then due1 = ?.
    update vend vend1 part part1 due due1 Line_Type with frame a.

    if part1 = "" then part1 = hi_char.
    if due = ? then due = low_date.
    if due1 = ? then due1 = hi_date.
    if vend1 = "" then vend1 = hi_char.

    {gpselout.i &printtype = "printer"
                &printwidth = 132
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

export delimiter "~t" getTermLabel("ITEM_NUMBER",18)
                      getTermLabel("DESCRIPTION",18)
                      getTermLabel("SUPPLIER",18)
                      getTermLabel("NAME",18)
                      getTermLabel("TYPE",18)
                      getTermLabel("QUANTITY" ,18).
FOR EACH pod_det no-lock use-index pod_partdue where
         pod_part >= part and pod_part <= part1 and
         pod_due_date >= due and pod_due_date <= due1 and
         ((pod_type = "T" and Line_Type) or (line_type = NO)),
    each po_mstr no-lock where po_nbr = pod_nbr and
         po_vend >= vend and po_vend <= vend1:
    find first pt_mstr no-lock where pt_part = pod_part no-error.
    find first vd_mstr no-lock where vd_addr = po_vend no-error.
    assign ptdesc = ""
           vdchr03 = "".
    if available pt_mstr then do:
       assign ptdesc = pt_desc1.
    end.
    if available vd_mstr then do:
       assign vdchr03 = vd_sort.
    end.
    export delimiter "~011" pod_part ptdesc po_vend vdchr03 pod_type pod_qty_ord.
end.
put unformatted skip(1) getTermLabel("END_OF_REPORT",20)  skip .
end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}
