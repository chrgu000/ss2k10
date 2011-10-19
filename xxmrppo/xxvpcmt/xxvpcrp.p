/*xxvpcrp.p                                                                  */
/* revision: 110831.1   created on: 20110831   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "110831.1"}

define variable vend  like po_vend no-undo.
define variable vend1 like po_vend no-undo.
define variable part  like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable ptdesc like pt_desc1 no-undo.
define variable vdsort like vd_sort no-undo.
define variable codecmmt like code_cmmt no-undo.

form
   skip(.2)
   vend  colon 15
   vend1 colon 49 label {t001.i}
   part  colon 15
   part1 colon 49 label {t001.i}
skip(1)
with frame a  side-labels width 80 attr-space.
setframelabels(frame a:handle).

{wbrp01.i}
repeat:

    if vend1 = hi_char then vend1 = "".
		if part1 = hi_char then part1 = "".
    update vend vend1 part part1 with frame a.

    if vend1 = "" then vend1 = hi_char.
		if part1 = "" then part1 = hi_char.
 
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

export delimiter "~t" getTermLabel("SUPPLIER",18) vend + "-" + vend1.
export delimiter "~t" getTermLabel("SUPPLIER",18)
										  getTermLabel("SORT_NAME",18)
										  getTermLabel("ITEM_NUMBER",18)
										  getTermLabel("DESCRIPTION",18)
										  getTermLabel("RULE",18)
										  getTermLabel("COMMENTS",20)
										  getTermLabel("STANDARD_PACK",18)
										  getTermLabel("WEEK",18)
										  getTermLabel("PURCHASE_TYPE",18).
for each xvp_ctrl no-lock where xvp_vend >= vend and xvp_vend <= vend1 and
				 xvp_part >= part and xvp_part <= part1 
				 break by xvp_vend by xvp_part: 
		assign ptdesc = "" vdsort = "" codecmmt = "".
	  find first pt_mstr no-lock where pt_part = xvp_part no-error.
	  if available pt_mstr then do:
	  	 assign ptdesc = pt_desc1.
	  end.
	  find first vd_mstr no-lock where vd_addr = xvp_vend no-error.
	  if available vd_mstr then do:
	  	 assign vdsort = vd_sort.
	  end.
	  find first code_mstr no-lock where code_fldname = "vd__chr03" 
	  			 and code_value = xvp_rule no-error.
	  if available code_mstr then do:
	  	 assign codecmmt = code_cmmt.
	  end.
		export delimiter "~011" xvp_vend vdsort xvp_part ptdesc xvp_rule
					 codecmmt xvp_ord_min xvp_week xvp__chr01.
end.
put unformatted skip(1) getTermLabel("END_OF_REPORT",20)  skip .
end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}
