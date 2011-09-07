/*xxmrpporp.p                                                                */
/* revision: 110831.1   created on: 20110831   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "110831.1"}

define variable part  like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable due   as   date no-undo.
define variable due1  as   date no-undo.
define variable ptdesc like pt_desc1 no-undo.
define variable vdchr03 as character no-undo.

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
 										  getTermLabel("DUE_DATE",18)
										  getTermLabel("DAY_OF_WEEK",18)
										  getTermLabel("QUANTITY" ,18)
										  getTermLabel("WEEK",18)
										  getTermLabel("SHIP_TERMS",18)
										  getTermLabel("STANDARD_PACK",18).
FOR EACH mrp_det WHERE mrp_part >= part and mrp_part <= part1 and
         mrp_due_date >= due and mrp_due_date <= due1 and
         mrp_detail = "¼Æ»®µ¥" USE-INDEX mrp_part:
		assign ptdesc = "" vdchr03 = "".
	  find first pt_mstr no-lock where pt_part = mrp_part no-error.
	  if available pt_mstr then do:
	  	 assign ptdesc = pt_desc1.
	  end. 
	  find first vd_mstr no-lock where vd_addr = pt_vend no-error.
	  if available vd_mstr then do:
	  	 assign vdchr03 = vd__chr03.
	  end.
	  find first xvp_ctrl no-lock where xvp_part = mrp_part no-error.
	  if availabl xvp_ctrl then do:
	  	 export delimiter "~011" mrp_part ptdesc pt_vend mrp_due_date 
	  	 				weekday(mrp_due_date) - 1 mrp_qty xvp_week 
	  	 				if vdchr03 <> "" then vdchr03 else xvp_rule
	  	 			  xvp_ord_min.
	  end.
	  else do:
	     export delimiter "~011" mrp_part ptdesc pt_vend mrp_due_date 
	     				weekday(mrp_due_date) - 1 mrp_qty.
	  end.
		
end.
put unformatted skip(1) getTermLabel("END_OF_REPORT",20)  skip .
end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}
