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
define var part     like  pt_part .
define var part1    like  pt_part label "��" .

define variable v_wt_um    like  pt_net_wt_um initial "KG".  /*������λ*/
define variable v_conv     like um_conv initial 1 no-undo.  /*������λת����*/
define var v_wt        like pt_net_wt .
define var v_ctry like xxctry_name .

define  frame a.

form
    SKIP(.2)
    skip(1)

    cu_part     colon 18 label "��Ʒ����"
    cu_part1    colon 50 label "��"
    cu_ln       colon 18 label "��Ʒ���"
    cu_ln1      colon 50 label "��"
    part        colon 18 
    part1       colon 50 label "��"


    skip (2)
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause . {xxtop.i}
    view frame  a  .
    if cu_part1 = hi_char       then cu_part1 = "".
    if cu_ln1   = 99999         then cu_ln1   = 0 .
    if part1 = hi_char       then part1 = "".

    update cu_part cu_part1 cu_ln cu_ln1  part part1 with frame a.

    if cu_ln1   = 0         then cu_ln1   = 99999 .
    if cu_part1 = ""        then cu_part1 = hi_char.
    if part1 = "" then part1 = hi_char.


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


for each xxcpt_mstr no-lock 
        where xxcpt_domain = global_domain 
        and xxcpt_cu_part >= cu_part      and xxcpt_cu_part <= cu_part1 
        and xxcpt_ln >= cu_ln             and xxcpt_ln <= cu_ln1 ,
    each xxccpt_mstr no-lock
        where xxccpt_domain = global_domain 
        and xxccpt_ln = xxcpt_ln 
        and xxccpt_part >= part and xxccpt_part <= part1 ,
    each pt_mstr no-lock 
        where pt_domain = global_domain 
        and pt_part = xxccpt_part
    break by xxcpt_cu_part by xxcpt_ln by xxccpt_part with frame x width 300 :
        if v_wt_um <> pt_net_wt_um then do:
              {gprun.i ""gpumcnv.p""
                 "(pt_net_wt_um , v_wt_um ,  v_wt_um , output v_conv)"}
              if v_conv = ? then v_conv = 1.
        end.
        else v_conv = 1.
        v_wt  =  pt_net_wt * v_conv  .    
        
        find first xxctry_mstr where xxctry_domain = global_domain and xxctry_code = xxccpt_ctry no-lock no-error .
        v_ctry = if avail xxctry_mstr then xxctry_name else "" .

        disp xxcpt_ln      label "���"
             xxcpt_cu_part label "������Ʒ����"
             xxcpt_desc    label "����Ʒ��"
             xxcpt_um      label "���ص�λ"
             xxcpt_price   label "����"
             xxccpt_part   label "��˾���"
             pt_desc1      label "��˾Ʒ��"
             pt_Desc2      label "��˾���"
             v_wt          label "����(KG)"
             pt_um         label "��˾��λ"             
             xxccpt_um_conv  label "��λת������"
             xxccpt_key_bom  label "����BOMģ��"
             xxccpt_attach   label "������"
             xxccpt_ctry     label "���յ�"
             v_ctry          label "���յ�����"

       with frame x .



end. /*for each xxcpt_mstr*/
      

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
