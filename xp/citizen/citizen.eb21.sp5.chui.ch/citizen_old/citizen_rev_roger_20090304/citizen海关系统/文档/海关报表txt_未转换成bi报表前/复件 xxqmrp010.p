/* xxqmrp010.p  出口合同状况报表                                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                      */
/* All rights reserved worldwide.  This is an unpublished work.                             */
/*V8:ConvertMode=NoConvert                                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/05/08   BY: Softspeed roger xiao   ECO:*xp001*    */
/*-Revision end------------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */
define var nbr as char  .
define var nbr1 as char   .
define var part like pt_part .
define var part1 like pt_part label "至" .
define var cu_par like xxcpt_cu_part .
define var cu_par1 like  xxcpt_cu_part label "至" .
define var par_ln like xxcpt_ln .
define var par_ln1 like xxcpt_ln .
define var v_yn    as logical initial yes label "仅限未结".
define var v_bk_type  as char initial "OUT" .


define variable v_wt_um    like  pt_net_wt_um initial "KG".  /*重量单位*/
define variable v_conv     like um_conv initial 1 no-undo.  /*重量单位转换率*/
define var v_cu_desc1  like xxcpt_Desc .
define var v_part like pt_part .
define var v_um   like pt_um .
define var v_desc  like pt_Desc1 .
define var v_price     like xxcpt_price label "海关单价(USD)".
define var v_amt       like tr_qty_loc  .
define var v_wt        like pt_net_wt .

define var v_qty_oh       like xxcpl_qty .
define var v_qty_oh2      as decimal format "->>,>>9.9999".

define  frame a.

form
    SKIP(.2)
    skip(1)

    nbr       colon 18 label "手册编号"
    nbr1      colon 50 label "至" 
    cu_par     colon 18 label "商品编码"
    cu_par1    colon 50 label "至" 


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
    if cu_par1 = hi_char       then cu_par1 = "".

    update nbr nbr1  cu_par cu_par1 v_yn   with frame a.

    if part1 = "" then part1 = hi_char.
    if nbr1 = "" then nbr1 = hi_char.
    if cu_par1 = "" then cu_par1 = hi_char.

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
        and xxcbkd_cu_part >= cu_par      and xxcbkd_cu_part <= cu_par1 
        and (v_yn = no or xxcbkd_stat = "" )
        no-lock break by xxcbkd_bk_nbr by xxcbkd_bk_ln with frame x width 300 :

        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcbkd_cu_ln no-lock no-error .
        v_cu_desc1 = if avail xxcpt_mstr then xxcpt_desc else  "" .
        v_price    = if avail xxcpt_mstr then xxcpt_price else  0 .

        
        find first xxcps_mstr where xxcps_domain = global_domain and xxcps_par_ln = xxcbkd_cu_ln no-lock no-error .
        v_wt = if avail xxcps_mstr then xxcps_wt_par else 0 .

        find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_ln = xxcbkd_cu_ln and xxccpt_key_bom = yes no-lock no-error.
        if avail xxccpt_mstr then do:
                find first pt_mstr where pt_domain = global_domain and pt_part = xxccpt_part no-lock no-error .
                v_part = if avail pt_mstr then pt_part  else  "" .
                v_um   = if avail pt_mstr then pt_um    else  "" .
                v_desc = if avail pt_mstr then pt_desc1 else  "" .
        end.
        else do:
            find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_ln = xxcbkd_cu_ln no-lock no-error.
            if avail xxccpt_mstr then do:
                find first pt_mstr where pt_domain = global_domain and pt_part = xxccpt_part no-lock no-error .
                v_part = if avail pt_mstr then pt_part  else  "" .
                v_um   = if avail pt_mstr then pt_um    else  "" .
                v_desc = if avail pt_mstr then pt_desc1 else  "" .
            end.
        end.



        v_qty_oh = ( xxcbkd_qty_ord + xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) .
        v_qty_oh2 = v_qty_oh / xxcbkd_qty_ord * 100 . 

        disp xxcbkd_bk_nbr    label "手册号"
             xxcbkd_bk_ln     label "手册序"
             xxcbkd_cu_ln     label "商品序"
             xxcbkd_cu_part   label "商品编码" 
             v_cu_desc1       label "海关品名"
             xxcbkd_um        label "海关单位"
             /*v_price          label "海关单价(USD)"*/
             xxcbkd_qty_ord   label "备案数量"
             xxcbkd_qty_io    label "出口数量"
             xxcbkd_qty_sl    label "转厂数量"
             /*xxcbkd_qty_rjct  label "退厂数量"*/
             xxcbkd_qty_tsf   label "结转数量"
             v_qty_oh         label "合同余数"
             v_qty_oh2        label "余额比率%"
             /*xxcbkd_stat       label "状态"*/             
        with frame x .

end. /*for each xxcps_mstr*/
      

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
