/* xxqmrp013.p  手册bom复核表                                                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                      */
/* All rights reserved worldwide.  This is an unpublished work.                             */
/*V8:ConvertMode=NoConvert                                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/05/08   BY: Softspeed roger xiao   ECO:*xp001*    */
/*-Revision end------------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */
define var v_bk_type  like xxcbkd_bk_type initial  "OUT" .

define var nbr as char label "手册编号" .
define var nbr1 as char  label "至"  .
define var cu_par like xxcpt_ln format ">>>>>>".
define var cu_par1 like  xxcpt_ln label "至" .
define var cu_comp like  xxcpt_cu_part .
define var cu_comp1 like  xxcpt_cu_part label "至" .

define var par_ln like xxcpt_ln .
define var par_ln1 like xxcpt_ln .
define var comp_ln like xxcpt_ln .
define var comp_ln1 like xxcpt_ln .

define var v_par_um  like xxcpt_um .
define var v_comp_um like xxcpt_um .
define var v_wt_par  like xxcps_wt_par .
define var v_wt_conv like xxcps_wt_conv  .

define var v_cu_desc1  like xxcpt_Desc .
define var v_cu_desc2  like xxcpt_Desc  .
define var v_price     like xxcpt_price label "海关单价(USD)".
define var v_attach    like xxccpt_attach . 


define var v_wt_total  like xxcps_wt_par .

define  frame a.

form
    SKIP(.2)
    skip(1)
    nbr              colon 15
    cu_par           colon 15 label "父手册序"
    xxcpt_ln         colon 15 label "父商品序"
    xxcpt_cu_part    colon 15 no-label 
    xxcpt_desc       colon 15 no-label
    /*nbr1      colon 50

    
    cu_par1    colon 50 label {t001.i}

    cu_comp    colon 18  label "子商品编码"
    cu_comp1   colon 50  label {t001.i}
*/


    skip (2)
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause . {xxtop.i}
    view frame  a  .

    /*if cu_comp1 = hi_char       then cu_comp1 = "".
    if nbr1 = hi_char        then nbr1 = "".
    if cu_par1 = hi_char       then cu_par1 = "".*/

    update nbr  cu_par  with frame a editing:
        if frame-field="nbr" then do:
            {mfnp01.i xxcbk_mstr nbr xxcbk_bk_nbr global_domain xxcbk_domain xxcbk_bk_nbr}
            if recno <> ? then do:
                disp xxcbk_bk_nbr @ nbr  
                with frame a.
            end.
        end.
        else if frame-field="cu_par" then do:
            {mfnp01.i xxcbkd_det cu_par xxcbkd_bk_ln v_bk_type " xxcbkd_domain = global_domain and xxcbkd_bk_nbr = input nbr and xxcbkd_bk_type " xxcbkd_bk_nbr }
            if recno <> ? then do:
                disp xxcbkd_bk_ln @ cu_par  
                with frame a.
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcbkd_cu_ln no-lock no-error .
                if avail xxcpt_mstr then 
                disp xxcpt_cu_part xxcpt_desc xxcpt_ln  
                with frame a.
            end.
        end.
         
        else do:
            status input ststatus.
            readkey.
            apply lastkey.
        end.
    end. /*update */
    assign  nbr cu_par .

    /*if cu_comp1 = "" then cu_comp1 = hi_char.
    if cu_par1 = "" then cu_par1 = hi_char.
    if nbr1 = "" then nbr1 = hi_char.*/

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

PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp013" SKIP.
PUT UNFORMATTED "#def :end" SKIP.


v_wt_total = 0 .
for each xxcbkps_mstr 
        where xxcbkps_domain = global_domain 
        and xxcbkps_bk_nbr = nbr 
        and xxcbkps_ln_par = cu_par 
        /*and xxcbkps_cu_comp >= cu_comp and xxcbkps_cu_comp <= cu_comp1*/
        no-lock break by xxcbkps_bk_nbr by xxcbkps_ln_par by xxcbkps_ln_comp :
        
        find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_ln = xxcbkps_cu_ln_comp no-lock no-error .
        v_attach   = if avail xxccpt_mstr then xxccpt_attach else no .
        
        if v_attach then next .

        find first xxcps_mstr where xxcps_domain = global_domain and xxcps_par_ln = xxcbkps_cu_ln_par and xxcps_comp_ln = xxcbkps_cu_ln_comp no-lock no-error .
        v_wt_conv = if avail xxcps_mstr then xxcps_wt else 0 .

        v_wt_total = v_wt_total + xxcbkps_qty_per * v_wt_conv .

end. /*for each xxcps_mstr*/
      
for each xxcbkps_mstr 
        where xxcbkps_domain = global_domain 
        and xxcbkps_bk_nbr = nbr 
        and xxcbkps_ln_par = cu_par 
        /*and xxcbkps_cu_comp >= cu_comp and xxcbkps_cu_comp <= cu_comp1*/
        no-lock break by xxcbkps_bk_nbr by xxcbkps_ln_par by xxcbkps_ln_comp :

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
                 xxcbkps_ln_par   ";" 
                 xxcbkps_cu_par   ";" 
                 v_cu_desc1       ";"  
                 ";"
                 v_par_um         ";" 
                 v_wt_par         ";" 
                 v_wt_total       ";"

                 xxcbkps_ln_comp  ";" 
                 xxcbkps_cu_comp  ";" 
                 v_cu_desc2       ";" 
                 ";"
                 v_comp_um        ";" 
                 v_wt_conv        ";"
                 v_attach         ";" 
                 xxcbkps_qty_per  ";" 
                 xxcbkps_scrap     
                 skip.

end. /*for each xxcps_mstr*/






end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
