/*xxpgverrp.p                                                                */
/* revision: 110314.1   created on: 20110314   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "120322.1"}
&SCOPED-DEFINE sosoiq_p_1 "Qty Open"

define variable program  like po_vend no-undo.
define variable program1 like po_vend no-undo.

form
   skip(.2)
   program  colon 15
   program1 colon 49 label {t001.i}
skip(1)
with frame a  side-labels width 80 attr-space.
setframelabels(frame a:handle).

{wbrp01.i}
repeat:

    if program1 = hi_char then program1 = "".
    update program program1 with frame a.
    if program1 = "" then program1 = hi_char.

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

put unformat getTermLabel("APPLICATION_VERSION",20) 
						 getTermLabel("Report",12) skip.
export delimiter "~t" getTermLabel("PROGRAM_NAME",20)
											getTermLabel("APPLICATION_INTERFACES",20)
											getTermLabel("VERSION",20)
											getTermLabel("USER_ID",20)
											getTermLabel("DATE",20)
											getTermLabel("TIME",20)
											getTermLabel("ENTER_NUMBER_OF_TIMES_TO_EXECUTE",20)
											getTermLabel("ACCESS_CODE/PATH",20) skip.
											
FOR EACH usrw_wkfl NO-LOCK WHERE {xxusrwdomver.i} {xxand.i}
		     usrw_key1 >= program and (usrw_key2 <= program1 or program1 = ""):
 		 export delimiter "~t" usrw_key1 
 		                       usrw_key2 
 		                       usrw_key3 
 		                       usrw_key4 
 		                       usrw_datefld[1] 
 		                       STRING(usrw_intfld[1],"hh:mm:ss") 
 		                       usrw_intfld[2] 
 		                       usrw_charfld[1].
end.

put unformatted skip(1) getTermLabel("END_OF_REPORT",20)  skip .
end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}
