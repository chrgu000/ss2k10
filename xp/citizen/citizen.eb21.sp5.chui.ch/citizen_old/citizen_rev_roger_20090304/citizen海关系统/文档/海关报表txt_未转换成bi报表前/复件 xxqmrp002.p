/* xxqmrp002.p  出口计划清单报表                                                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                      */
/* All rights reserved worldwide.  This is an unpublished work.                             */
/*V8:ConvertMode=NoConvert                                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/05/08   BY: Softspeed roger xiao   ECO:*xp001*    */
/*-Revision end------------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */
define var nbr as char label "计划清单号" .
define var nbr1 as char  label "至"  .
define var part like pt_part .
define var part1 like pt_part label "至" .
define var cu_par like xxcpt_cu_part .
define var cu_par1 like  xxcpt_cu_part label "至" .
define var par_ln like xxcpt_ln .
define var par_ln1 like xxcpt_ln .
define var v_yn    as logical initial yes label "仅限未结".



define variable v_wt_um    like  pt_net_wt_um initial "KG".  /*重量单位*/
define variable v_conv     like um_conv initial 1 no-undo.  /*重量单位转换率*/
define var v_cu_desc1  like xxcpt_Desc .
define var v_cu_desc2  like xxcpt_Desc .
define var v_price     like xxcpt_price label "海关单价(USD)".
define var v_amt       like tr_qty_loc  .
define var v_wt        like pt_net_wt .

define var v_total_qty       like xxcpl_qty .
define var v_total_amt       like tr_qty_loc  .
define var v_total_wt        like pt_net_wt .

define  frame a.

form
    SKIP(.2)
    "--出口计划清单报表--" colon 25 
    skip(1)

    nbr       colon 18
    nbr1      colon 50
    cu_par     colon 18 label "商品编码"
    cu_par1    colon 50 label {t001.i}
    part       colon 18 
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
    if cu_par1 = hi_char       then cu_par1 = "".

    update nbr nbr1  cu_par cu_par1 part part1 v_yn   with frame a.

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

v_total_qty = 0 .
v_total_amt = 0 .
v_total_wt  = 0 .
for each xxcpl_mstr 
        where xxcpl_domain = global_domain 
        and xxcpl_list_nbr >= nbr and xxcpl_list_nbr <=nbr1
        and xxcpl_cu_part >= cu_par      and xxcpl_cu_part <= cu_par1 
        and xxcpl_par >= part      and xxcpl_par <= part1 
        and (v_yn = no or xxcpl_stat = "" )
        no-lock break by xxcpl_list_nbr by xxcpl_par with frame x width 300 :

        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcpl_cu_ln no-lock no-error .
        v_cu_desc1 = if avail xxcpt_mstr then xxcpt_desc else  "" .
        v_price    = if avail xxcpt_mstr then xxcpt_price else  0 .

        v_wt = 0 .
        find first pt_mstr where pt_domain = global_domain and pt_part = xxcpl_par no-lock no-error .
        if avail pt_mstr then do:
            if v_wt_um <> pt_net_wt_um then do:
                  {gprun.i ""gpumcnv.p""
                     "(pt_net_wt_um , v_wt_um ,  xxcpl_par , output v_conv)"}
                  if v_conv = ? then v_conv = 1.
            end.
            else v_conv = 1.
            v_wt  =  pt_net_wt * v_conv  .
        end.
        v_cu_desc2 = if avail pt_mstr then pt_desc1 else  "" .


        v_amt       = v_price * xxcpl_cu_qty .
        v_total_amt = v_total_amt + v_amt .
        v_total_qty = v_total_qty + xxcpl_qty .
        v_total_wt  = v_total_wt  + v_wt * xxcpl_qty .




        disp xxcpl_list_nbr   label "清单号"
             xxcpl_cu_ln      label "序号"
             xxcpl_cu_part    label "商品编码" 
             v_cu_desc1       label "海关品名"
             v_price          label "海关单价(USD)"
             xxcpl_cu_qty     label "数量"
             xxcpl_cu_um      label "海关单位" 
             v_amt            label "总值(USD)"             
             xxcpl_par        label "公司零件" 
             v_cu_desc2       label "公司品名"
             xxcpl_qty        label "数量"
             xxcpl_um         label "单位" 
             v_wt             label "单重(KG)"
             xxcpl_stat       label "状态"
        with frame x .

        if last(xxcpl_list_nbr) then do:
            down 1 with frame x.
            disp "========" @ xxcpl_list_nbr  
                 "==============" @ v_amt
                 "==============" @ xxcpl_qty
                 "=============="  @ v_wt 
                 with frame x.

            down 1 with frame x.
            disp "Total:" @ xxcpl_list_nbr  
                 v_total_amt @ v_amt
                 v_total_qty @ xxcpl_qty
                 v_total_wt  @ v_wt 
                 with frame x.
        end.


end. /*for each xxcps_mstr*/
      

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
