/* xxqmrp003.p  ���ڼƻ��嵥����                                                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                      */
/* All rights reserved worldwide.  This is an unpublished work.                             */
/*V8:ConvertMode=NoConvert                                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/05/08   BY: Softspeed roger xiao   ECO:*xp001*    */
/*-Revision end------------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */
define var nbr as char label "�ƻ��嵥��" .
define var nbr1 as char  label "��"  .
define var part like pt_part .
define var part1 like pt_part label "��" .
define var cu_comp like xxcpt_cu_part .
define var cu_comp1 like  xxcpt_cu_part label "��" .
define var v_yn    as logical initial yes label "����δ��".



define variable v_wt_um    like  pt_net_wt_um initial "KG".  /*������λ*/
define variable v_conv     like um_conv initial 1 no-undo.  /*������λת����*/
define var v_cu_desc1  like xxcpt_Desc .
define var v_cu_desc2  like xxcpt_Desc .
define var v_price     like xxcpt_price label "���ص���(USD)".
define var v_amt       like tr_qty_loc  .
define var v_wt        like pt_net_wt .

define var v_total_qty       like xxcpl_qty .
define var v_total_amt       like tr_qty_loc  .
define var v_total_wt        like pt_net_wt .

define  frame a.

form
    SKIP(.2)
    "--���ڼƻ��嵥����--" colon 25 
    skip(1)

    nbr       colon 18 label "�嵥��"
    nbr1      colon 50
    cu_comp     colon 18 label "��Ʒ����"
    cu_comp1    colon 50 label {t001.i}
    part       colon 18 label "�����"
    part1      colon 50 

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
    if cu_comp1 = hi_char       then cu_comp1 = "".

    update nbr nbr1  cu_comp cu_comp1 part part1 v_yn   with frame a.

    if part1 = "" then part1 = hi_char.
    if nbr1 = "" then nbr1 = hi_char.
    if cu_comp1 = "" then cu_comp1 = hi_char.


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

v_total_qty = 0 .
v_total_amt = 0 .
v_total_wt  = 0 .
for each xxcpld_det 
        where xxcpld_domain = global_domain 
        and xxcpld_list_nbr >= nbr and xxcpld_list_nbr <=nbr1
        and xxcpld_cu_comp >= cu_comp      and xxcpld_cu_comp <= cu_comp1 
        and xxcpld_comp >= part      and xxcpld_comp <= part1 
        and (v_yn = no or xxcpld_stat = "" )
        no-lock break by xxcpld_list_nbr by xxcpld_comp with frame x width 300 :

        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcpld_cu_ln no-lock no-error .
        v_cu_desc1 = if avail xxcpt_mstr then xxcpt_desc else  "" .
        v_price    = if avail xxcpt_mstr then xxcpt_price else  0 .

        v_wt = 0 .
        find first pt_mstr where pt_domain = global_domain and pt_part = xxcpld_comp no-lock no-error .
        if avail pt_mstr then do:
            if v_wt_um <> pt_net_wt_um then do:
                  {gprun.i ""gpumcnv.p""
                     "(pt_net_wt_um , v_wt_um ,  xxcpld_comp , output v_conv)"}
                  if v_conv = ? then v_conv = 1.
            end.
            else v_conv = 1.
            v_wt  =  pt_net_wt * v_conv  .
        end.
        v_cu_desc2 = if avail pt_mstr then pt_desc1 else  "" .


        v_amt       = v_price * xxcpld_cu_qty .
        v_total_amt = v_total_amt + v_amt .
        v_total_qty = v_total_qty + xxcpld_qty .
        v_total_wt  = v_total_wt  + v_wt * xxcpld_qty .




        disp xxcpld_list_nbr   label "�嵥��"
             xxcpld_cu_ln      label "���"
             xxcpld_cu_comp    label "��Ʒ����" 
             v_cu_desc1       label "����Ʒ��"
             v_price          label "���ص���(USD)"
             xxcpld_cu_um      label "���ص�λ" 
             xxcpld_cu_qty     label "����"             
             v_amt            label "��ֵ(USD)"             
             /*xxcpld_comp        label "���" 
             v_cu_desc2       label "��˾Ʒ��"
             xxcpld_qty        label "����"
             xxcpld_um         label "��λ" 
             v_wt             label "����(KG)"*/
             xxcpld_stat       label "״̬"
        with frame x .

        if last(xxcpld_list_nbr) then do:
            down 1 with frame x.
            disp "========" @ xxcpld_list_nbr  
                 "==============" @ v_amt
                 /*"==============" @ xxcpld_qty
                 "=============="  @ v_wt */
                 with frame x.

            down 1 with frame x.
            disp "Total:" @ xxcpld_list_nbr  
                 v_total_amt @ v_amt
                 /*v_total_qty @ xxcpld_qty
                 v_total_wt  @ v_wt */
                 with frame x.
        end.


end. /*for each xxcps_mstr*/
      

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
