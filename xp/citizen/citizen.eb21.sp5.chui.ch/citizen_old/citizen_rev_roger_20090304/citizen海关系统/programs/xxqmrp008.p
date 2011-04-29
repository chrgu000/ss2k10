/* xxqmrp008.p  手册bom明细报表                                                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                      */
/* All rights reserved worldwide.  This is an unpublished work.                             */
/*V8:ConvertMode=NoConvert                                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/05/08   BY: Softspeed roger xiao   ECO:*xp001*    */
/*-Revision end------------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */
define var nbr as char label "手册编号" .
define var nbr1 as char  label "至"  .

define var bk_par like xxcbkd_bk_ln format ">>>" .
define var bk_par1 like xxcbkd_bk_ln  format ">>>" .
define var bk_comp like xxcbkd_bk_ln  format ">>>" .
define var bk_comp1 like xxcbkd_bk_ln  format ">>>" .

define var cu_par like  xxcpt_ln     format ">>>>>>" .
define var cu_par1 like   xxcpt_ln   format ">>>>>>"  .
define var cu_comp like   xxcpt_ln   format ">>>>>>"  .
define var cu_comp1 like   xxcpt_ln  format ">>>>>>"  .

define var v_par_um  like xxcpt_um .
define var v_comp_um like xxcpt_um .
define var v_wt_par  like xxcps_wt_par .
define var v_wt_conv like xxcps_wt_conv  .

define var v_cu_desc1  like xxcpt_Desc .
define var v_cu_desc2  like xxcpt_Desc  .
define var v_price     like xxcpt_price label "海关单价(USD)".
define var v_attach    like xxccpt_attach . 

define  frame a.

form
    SKIP(.2)
    "--海关手册BOM查询报表--" colon 25
    skip(1)
    nbr        colon 18
    nbr1       colon 50

    bk_par     colon 18 label "父手册序"
    bk_par1    colon 50 label {t001.i}

    cu_par     colon 18 label "父商品序"
    cu_par1    colon 50 label {t001.i}

    bk_comp    colon 18  label "子手册序"
    bk_comp1   colon 50  label {t001.i}

    cu_comp    colon 18  label "子商品序"
    cu_comp1   colon 50  label {t001.i}



    skip (2)
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause . {xxtop.i}
    view frame  a  .

    if bk_par1 = 999999       then bk_par1 = 0.
    if bk_comp1 = 999999       then bk_comp1 = 0.
    if cu_par1 = 999999       then cu_par1 = 0.
    if cu_comp1 = 999999       then cu_comp1 = 0.

    if nbr1 = hi_char        then nbr1 = "".

    update nbr nbr1 bk_par bk_par1 cu_par cu_par1 bk_comp bk_comp1  cu_comp cu_comp1   with frame a.

    if bk_par1 = 0 then bk_par1 = 999999.
    if bk_comp1 = 0 then bk_comp1 = 999999.
    if cu_par1 = 0 then cu_par1 = 999999.
    if cu_comp1 = 0 then cu_comp1 = 999999.

    if nbr1 = "" then nbr1 = hi_char.

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

PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp008" SKIP.
PUT UNFORMATTED "#def :end" SKIP.


/*{mfphead.i}*/

for each xxcbkps_mstr 
        where xxcbkps_domain = global_domain 
        and xxcbkps_bk_nbr >= nbr and xxcbkps_bk_nbr <= nbr1
        and xxcbkps_ln_par >=  bk_par and xxcbkps_ln_par <= bk_par1
        and xxcbkps_ln_comp >= bk_comp  and xxcbkps_ln_comp <= bk_comp1
        and xxcbkps_cu_ln_par >= cu_par and xxcbkps_cu_ln_par <= cu_par1
        and xxcbkps_cu_ln_comp >= cu_comp and xxcbkps_cu_ln_comp <= cu_comp1
        no-lock break by xxcbkps_bk_nbr by xxcbkps_ln_par by xxcbkps_ln_comp 
        with frame x width 300 :

        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcbkps_cu_ln_par no-lock no-error .
        v_par_um = if avail xxcpt_mstr then xxcpt_um else  "" .
        v_cu_desc1 = if avail xxcpt_mstr then xxcpt_desc else  "" .

        
        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcbkps_cu_ln_comp no-lock no-error .
        v_price    = if avail xxcpt_mstr then xxcpt_price else  0 .
        v_cu_desc2 = if avail xxcpt_mstr then xxcpt_desc else  "" .
        v_comp_um = if avail xxcpt_mstr then xxcpt_um else  "" .
        find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_ln = xxcbkps_cu_ln_comp no-lock no-error .
        v_attach   = if avail xxccpt_mstr then xxccpt_attach else no .

        find first xxcps_mstr where xxcps_domain = global_domain and xxcps_par_ln = xxcbkps_cu_ln_par no-lock no-error .
        v_wt_par = if avail xxcps_mstr then xxcps_wt_par else  0 .
        find first xxcps_mstr where xxcps_domain = global_domain and xxcps_par_ln = xxcbkps_cu_ln_par and xxcps_comp_ln = xxcbkps_cu_ln_comp no-lock no-error .
        v_wt_conv = if avail xxcps_mstr then xxcps_wt else 0 .
        
        put unformatted 
                 xxcbkps_bk_nbr   ";" 
                 xxcbkps_ln_par   ";" 
                 xxcbkps_cu_par   ";" 
                 v_cu_desc1       ";" 
                 v_par_um         ";" 
                 v_wt_par         ";" 
                 xxcbkps_ln_comp  ";" 
                 xxcbkps_cu_comp  ";" 
                 v_cu_desc2       ";" 
                 v_attach         ";" 
                 v_price          ";" 
                 v_comp_um        ";" 
                 xxcbkps_qty_per  ";" 
                 xxcbkps_scrap    ";"      
                 v_wt_conv       skip.

end. /*for each xxcps_mstr*/
      

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
