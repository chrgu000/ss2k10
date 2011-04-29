/* xxqmrp009.p  ���ں�ͬ״������                                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                      */
/* All rights reserved worldwide.  This is an unpublished work.                             */
/*V8:ConvertMode=NoConvert                                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/05/08   BY: Softspeed roger xiao   ECO:*xp001*    */
/*-Revision end------------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */
define var nbr as char.
define var nbr1 as char   .
define var part like pt_part .
define var part1 like pt_part label "��" .
define var cu_part like xxcpt_cu_part .
define var cu_part1 like  xxcpt_cu_part label "��" .
define var par_ln like xxcpt_ln .
define var par_ln1 like xxcpt_ln .
define var v_yn    as logical initial yes label "����δ��".
define var v_bk_type  as char initial "IMP" .


define var v_cu_desc1  like xxcpt_Desc  .
define var v_price     like xxcpt_price label "���ص���(USD)".
define var v_amt       like tr_qty_loc  .
define var v_qty_oh       like xxcpl_qty .
define var v_qty_oh2      as decimal format "->>,>>9.9999".



define  frame a.

form
    SKIP(.2)
    skip(1)

    nbr       colon 18 label "�ֲ���" 
    nbr1      colon 50 label "��"
    cu_part     colon 18 label "��Ʒ����"
    cu_part1    colon 50 label "��" 


    skip(1)
    v_yn      colon 18

    skip (2)
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause . {xxtop.i}
    view frame  a  .

    if part1 = hi_char       then part1 = "".
    if nbr1 = hi_char        then nbr1 = "".
    if cu_part1 = hi_char       then cu_part1 = "".

    update nbr nbr1  cu_part cu_part1 v_yn   with frame a.

    if part1 = "" then part1 = hi_char.
    if nbr1 = "" then nbr1 = hi_char.
    if cu_part1 = "" then cu_part1 = hi_char.

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
PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp002" SKIP.
PUT UNFORMATTED "#def :end" SKIP.
*/
{mfphead.i}



for each xxcbkd_det 
        where xxcbkd_domain = global_domain
        and xxcbkd_bk_type  = v_bk_type 
        and xxcbkd_bk_nbr >= nbr and xxcbkd_bk_nbr <=nbr1
        and xxcbkd_cu_part >= cu_part      and xxcbkd_cu_part <= cu_part1 
        and (v_yn = no or xxcbkd_stat = "" )
        no-lock break by xxcbkd_bk_nbr by xxcbkd_bk_ln with frame x width 300 :

        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcbkd_cu_ln no-lock no-error .
        v_cu_desc1 = if avail xxcpt_mstr then xxcpt_desc else  "" .
        v_price    = if avail xxcpt_mstr then xxcpt_price else  0 .
        v_amt       = v_price *  xxcbkd_qty_ord .



        v_qty_oh = ( xxcbkd_qty_ord + xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) .
        v_qty_oh2 = v_qty_oh / xxcbkd_qty_ord * 100 . 



        disp xxcbkd_bk_nbr    label "�ֲ���"
             xxcbkd_bk_ln     label "�ֲ���"
             xxcbkd_cu_ln     label "��Ʒ��"
             xxcbkd_cu_part   label "��Ʒ����" 
             v_cu_desc1       label "����Ʒ��"
             xxcbkd_um        label "���ص�λ"
             /*v_price          label "���ص���(USD)"*/
             xxcbkd_qty_ord   label "��������"
             xxcbkd_qty_io    label "��������"
             xxcbkd_qty_sl    label "ת������"
             xxcbkd_qty_rjct  label "�˸�����"
             xxcbkd_qty_tsf   label "��ת����"
             v_qty_oh         label "��ͬ����"
             v_qty_oh2        label "������%"
                          
             /*xxcbkd_stat       label "״̬"*/
        with frame x .

end. /*for each xxcps_mstr*/
      

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
