/* xxqmrp004.p  ������Ʒ��ѯ����                                                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                      */
/* All rights reserved worldwide.  This is an unpublished work.                             */
/*V8:ConvertMode=NoConvert                                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/05/08   BY: Softspeed roger xiao   ECO:*xp001*    */
/*-Revision end------------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */

define var cu_ln    like xxcpt_ln format ">>>>>".
define var cu_ln1   like  xxcpt_ln  format ">>>>>" label "��" .
define var cu_part  like xxcpt_cu_part .
define var cu_part1 like  xxcpt_cu_part label "��" .



define  frame a.

form
    SKIP(.2)
    skip(1)

    cu_part     colon 18 label "��Ʒ����"
    cu_part1    colon 50 label {t001.i}
    cu_ln       colon 18 label "��Ʒ���"
    cu_ln1      colon 50 


    skip (2)
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause . {xxtop.i}
    view frame  a  .
    if cu_part1 = hi_char       then cu_part1 = "".
    if cu_ln1   = 99999         then cu_ln1   = 0 .

    update cu_part cu_part1 cu_ln cu_ln1   with frame a.

    if cu_ln1   = 0         then cu_ln1   = 99999 .
    if cu_part1 = ""        then cu_part1 = hi_char.


    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    

/*
PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp003" SKIP.
PUT UNFORMATTED "#def :end" SKIP.
*/

{mfphead.i}


for each xxcpt_mstr 
        where xxcpt_domain = global_domain 
        and xxcpt_cu_part >= cu_part      and xxcpt_cu_part <= cu_part1 
        and xxcpt_ln >= cu_ln             and xxcpt_ln <= cu_ln1 
        no-lock break by xxcpt_ln by xxcpt_cu_part with frame x width 300 :

        disp xxcpt_ln      label "���"
             xxcpt_cu_part label "��Ʒ����"
             xxcpt_desc    label "����Ʒ��"
             xxcpt_um      label "���ص�λ"
             xxcpt_wt_conv label "���ص���"
             xxcpt_price   label "����"
             xxcpt_tax     label "��������"
       with frame x .



end. /*for each xxcpt_mstr*/
      

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
