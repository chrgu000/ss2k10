/* xxqmrp007.p  进口备案清单报表                                                                 */
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
define var cu_part like xxcpt_cu_part .
define var cu_part1 like  xxcpt_cu_part label "至" .
define var par_ln like xxcpt_ln .
define var par_ln1 like xxcpt_ln .
define var v_yn    as logical initial yes label "仅限未结".
define var v_bk_type  as char initial "IMP" .


define var v_cu_desc1  like xxcpt_Desc  .
define var v_price     like xxcpt_price label "海关单价(USD)".
define var v_total_amt       like tr_qty_loc  .
define var v_amt       like tr_qty_loc  .


define  frame a.

form
    SKIP(.2)
    "--进口备案清单报表--" colon 25 
    skip(1)

    nbr       colon 18 label "手册编号"
    nbr1      colon 50  label "至"
    cu_part     colon 18 label "商品编码"
    cu_part1    colon 50  label "至"


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


v_total_amt = 0 .
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
        v_total_amt = v_total_amt + v_amt .




        disp xxcbkd_bk_nbr    label "手册编号"
             xxcbkd_bk_ln     label "手册序"
             xxcbkd_cu_part   label "商品编码" 
             v_cu_desc1       label "海关品名"
             xxcbkd_um        label "海关单位"
             xxcbkd_qty_ord   label "备案数量"
             v_price          label "海关单价(USD)"
             v_amt            label "总值(USD)"                           
             xxcbkd_stat       label "状态"
        with frame x .

        if last(xxcbkd_bk_nbr) then do:
            down 1 with frame x.
            disp "========" @ xxcbkd_bk_nbr  
                 "==============" @ v_amt
                 with frame x.

            down 1 with frame x.
            disp "Total:" @ xxcbkd_bk_nbr  
                 v_total_amt @ v_amt
                 with frame x.
        end.


end. /*for each xxcps_mstr*/
      

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
