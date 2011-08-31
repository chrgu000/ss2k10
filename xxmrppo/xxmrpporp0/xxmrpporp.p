/*xxmrpporp.p                                                                */
/* revision: 110831.1   created on: 20110831   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/
/*注意：cim-showa.xla vba project password:rogercimshowa                     */

{mfdtitle.i "110831.1"}
&SCOPED-DEFINE sosoiq_p_1 "Qty Open"

define variable part  like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable due   as   date no-undo.
define variable due1  as   date no-undo.
define variable ptdesc like pt_desc1 no-undo.

form
   skip(.2)
   part  colon 15
   part1 colon 49 label {t001.i}
   due   colon 15
   due1  colon 49 label {t001.i}
skip(1)
with frame a  side-labels width 80 attr-space.
setframelabels(frame a:handle).

{wbrp01.i}
repeat:

		if part1 = hi_char then part1 = "".
		if due = low_date then due = ?.
		if due1 = hi_date  then due1 = ?.
    update part part1 due due1 with frame a.

		if part1 = "" then part1 = hi_char.
		if due = ? then due = low_date.
		if due1 = ? then due1 = hi_date.
  /*excel报表专用,不用再改程式名*/
/*    if index(execname,".p") <> 0 then v_prgname = entry(1,execname,".p").  */
/*    else do:                                                               */
/*        message "错误:无效程式名格式" execname .                           */
/*        undo,retry.                                                        */
/*    end.                                                                   */

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
										  getTermLabel("DUE_DATE",18)
										  getTermLabel("QUANTITY" ,18).
FOR EACH mrp_det WHERE mrp_part >= part and mrp_part <= part1 and
         mrp_due_date >= due and mrp_due_date <= due1 and
         mrp_detail = "计划单" USE-INDEX mrp_part:
		assign ptdesc = "".
	  find first pt_mstr no-lock where pt_part = mrp_part no-error.
	  if available pt_mstr then do:
	  	 assign ptdesc = pt_desc1.
	  end. 
		export delimiter "~011" mrp_part ptdesc mrp_due_date mrp_qty.
end.
put unformatted skip(1) "报表结束"  skip .
end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}
