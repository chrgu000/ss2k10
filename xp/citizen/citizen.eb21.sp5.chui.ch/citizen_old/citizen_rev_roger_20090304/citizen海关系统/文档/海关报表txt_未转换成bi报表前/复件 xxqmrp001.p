/* xxqmrp001.p  bom明细报表                                                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                      */
/* All rights reserved worldwide.  This is an unpublished work.                             */
/*V8:ConvertMode=NoConvert                                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/05/08   BY: Softspeed roger xiao   ECO:*xp001*    */
/*-Revision end------------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */
define var cu_par like xxcpt_cu_part .
define var cu_par1 like  xxcpt_cu_part label "至" .
define var cu_comp like  xxcpt_cu_part .
define var cu_comp1 like  xxcpt_cu_part label "至" .
define var par like pt_part .
define var par1 like pt_part label "至" .
define var comp like pt_part .
define var comp1 like pt_part label "至" .
define var par_ln like xxcpt_ln .
define var par_ln1 like xxcpt_ln .
define var comp_ln like xxcpt_ln .
define var comp_ln1 like xxcpt_ln .

define var v_cu_um  like xxcpt_um .
define var v_um     like xxcpt_um .
define var v_par_conv like xxccpt_um_conv .
define var v_comp_conv like xxccpt_um_conv .
define var v_cu_desc1  like xxcpt_Desc .
define var v_cu_desc2  like xxcpt_Desc .
define var v_price     like xxcpt_price label "海关单价(USD)".
define var v_attach    like xxccpt_attach . 
define var v_wt_conv   like xxcpt_wt_conv .


define  frame a.

form
    SKIP(.2)
    "--海关BOM查询报表--" colon 25
    skip(1)
    cu_par     colon 18 label "父商品编码"
    cu_par1    colon 50 label {t001.i}
    par        colon 18  label "父零件"
    par1       colon 50 label {t001.i}
    cu_comp    colon 18  label "子商品编码"
    cu_comp1   colon 50  label {t001.i}
    comp       colon 18 label "子零件"
    comp1      colon 50  label {t001.i}


    skip (2)
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause . {xxtop.i}
    view frame  a  .

    if cu_par1 = hi_char       then cu_par1 = "".
    if cu_comp1 = hi_char       then cu_comp1 = "".
    if par1 = hi_char       then par1 = "".
    if comp1 = hi_char       then comp1 = "".


    update cu_par cu_par1  par par1 cu_comp cu_comp1 comp comp1   with frame a.

    if cu_par1 = "" then cu_par1 = hi_char.
    if cu_comp1 = "" then cu_comp1 = hi_char.
    if par1 = "" then par1 = hi_char.
    if comp1 = "" then comp1 = hi_char.



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
PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp001" SKIP.
PUT UNFORMATTED "#def :end" SKIP.
*/

{mfphead.i}

for each xxcps_mstr 
        where xxcps_domain = global_domain 
        and xxcps_cu_par >= cu_par and xxcps_par <= cu_par1
        and xxcps_cu_comp >= cu_comp and xxcps_cu_comp <= cu_comp1
        and xxcps_par >= par and xxcps_par <= par1 
        and xxcps_comp >= comp and xxcps_comp <= comp1 
        no-lock break by xxcps_par by xxcps_comp with frame x width 300 :

        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcps_par_ln no-lock no-error .
        v_cu_um = if avail xxcpt_mstr then xxcpt_um else  "" .
        v_cu_desc1 = if avail xxcpt_mstr then xxcpt_desc else  "" .
        
        
        find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_ln = xxcps_par_ln no-lock no-error .
        if avail xxccpt_mstr then do:
            v_par_conv = xxccpt_um_conv .
            v_attach   = xxccpt_attach .
            find first pt_mstr where pt_domain = global_domain and pt_part = xxccpt_part no-lock no-error .
            v_um = if avail pt_mstr then pt_um else  "" .
        end.
        else assign v_um = "" v_par_conv = 0 v_attach   = no .

        find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_ln = xxcps_comp_ln no-lock no-error .
        if avail xxccpt_mstr then do:
            v_comp_conv = xxccpt_um_conv .
        end.
        else assign v_comp_conv = 0 .
        
        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcps_comp_ln no-lock no-error .
        v_price    = if avail xxcpt_mstr then xxcpt_price else  0 .
        v_cu_desc2 = if avail xxcpt_mstr then xxcpt_desc else  "" .
        v_wt_conv  = if avail xxcpt_mstr then xxcpt_wt_conv else  0 .

        disp 
                 xxcps_par_ln     label "序号"
                 xxcps_cu_par     label "父商品编码" 
                 v_cu_desc1       label "海关品名"
                 v_cu_um          label "海关单位" 
                 xxcps_wt_par     label "重量(KG)"
                 xxcps_comp_ln    label "序号"
                 xxcps_cu_comp    label "子商品编码"
                 v_cu_desc2       label "海关品名" 
                 v_attach         label "附属件"
                 v_price          label "海关单价(USD)"
                 xxcps_cu_qty_per label "单耗"
                 xxcps_cu_um      label "海关单位"
                 v_wt_conv        label "第二单位"
        with frame x .

        /*xxcps_par label "父零件" v_um label "单位" v_par_conv label "父单位转换率"*/  
        /*xxcps_comp label "子零件"  xxcps_um label "单位"  v_comp_conv label "子单位转换率"*/ 
        /*xxcps_qty_per xxcps_cu_qty_per_b xxcps_qty_per_b xxcps_wt_b*/ 


end. /*for each xxcps_mstr*/
      

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
