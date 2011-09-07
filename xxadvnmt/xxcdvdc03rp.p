/*xxsorp002.p                                                                */
/* revision: 110314.1   created on: 20110314   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/
/*ע�⣺cim-showa.xla vba project password:rogercimshowa                     */

{mfdtitle.i "110314"}
&SCOPED-DEFINE sosoiq_p_1 "Qty Open"

define variable term0  like code_value no-undo.
define variable term1 like code_value no-undo.

form
   skip(.2)
   term0  colon 15
   term1 colon 49 label {t001.i}
skip(1)
with frame a  side-labels width 80 attr-space.
setframelabels(frame a:handle).

{wbrp01.i}
repeat:

    if term1 = hi_char then term1 = "".

    update term0 term1 with frame a.

    if term1 = "" then term1 = hi_char.

  /*excel����ר��,�����ٸĳ�ʽ��*/
/*    if index(execname,".p") <> 0 then v_prgname = entry(1,execname,".p").  */
/*    else do:                                                               */
/*        message "����:��Ч��ʽ����ʽ" execname .                           */
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
put unformat "�ͻ���ʽ����" skip.
export delimiter "~t" "�ͻ���ʽ" "˵��" skip.
for each code_mstr no-lock where code_fldname = "vd__chr03" and 
				 code_value >= term0 and code_value <= term1:
 					 
		 export delimiter "~t" code_value code_cmmt.
 
end.
put unformatted skip(1) "�������"  skip .
end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}
