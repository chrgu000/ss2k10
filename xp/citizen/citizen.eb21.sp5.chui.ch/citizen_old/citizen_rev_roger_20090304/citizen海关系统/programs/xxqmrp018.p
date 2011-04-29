/* xxqmrp018.p  供应商转厂状况报表                                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                      */
/* All rights reserved worldwide.  This is an unpublished work.                             */
/*V8:ConvertMode=NoConvert                                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/05/08   BY: Softspeed roger xiao   ECO:*xp001*    */
/*-Revision end------------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */
define var v_bk_type  as char initial "IMP" .


define var nbr       as char  .
define var nbr1      as char   .
define var year      as integer format "9999" label "年".
define var month     as integer format "99" label "月".
define var bk_ln     like xxcpt_ln .
define var bk_ln1    like xxcpt_ln .
define var vend      like po_vend .
define var vend1     like po_vend .


define variable v_wt_um    like  pt_net_wt_um initial "KG".  /*重量单位*/
define variable v_conv     like um_conv initial 1 no-undo.  /*重量单位转换率*/

define var v_desc1 like xxcpt_Desc .
define var v_desc2 like xxcpt_Desc .
define var v_qty_m like tr_qty_loc .

define temp-table temp1 
    field t1_bk_nbr  like xxcbkd_bk_nbr
    field t1_bk_ln   like xxcbkd_bk_ln 
    field t1_vend    like po_vend
    field t1_cu_ln   like xxcbkd_cu_ln
    field t1_cu_part like xxcpt_cu_part
    field t1_cu_um   like xxcpt_um
    field t1_year    as integer
    field t1_month   as integer 
    field t1_qty_a   like tr_qty_loc 
    field t1_qty_b   like tr_qty_loc
    field t1_qty_c   like tr_qty_loc
    field t1_qty_d   like tr_qty_loc
    field t1_qty_e   like tr_qty_loc
    field t1_qty_f   like tr_qty_loc
    .

year = year(today) .
month = month(today) .


define  frame a.

form
    SKIP(.2)
    skip(1)

    year      colon 18 
    month     colon 18
    nbr       colon 18
    nbr1      colon 50
    bk_ln     colon 18
    bk_ln1    colon 50
    vend      colon 18
    vend1     colon 50

    skip (2)
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause . {xxtop.i}
    view frame  a  .

    if nbr1 = hi_char        then nbr1 = "".
    if vend1 = hi_char       then vend1 = "".
    if bk_ln1 = 999999       then bk_ln1 = 0 . 

    update year month nbr nbr1 bk_ln bk_ln1 vend vend1   with frame a.

    if nbr1 = "" then nbr1 = hi_char.
    if vend1 = "" then vend1 = hi_char.
    if bk_ln1 = 0 then bk_ln1 = 999999 .

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

PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp018" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

for each temp1 : delete temp1 . end .


for each xxcbk_mstr 
        where xxcbk_domain = global_domain 
        and xxcbk_bk_nbr   >= nbr and xxcbk_bk_nbr <= nbr1
        and date(month(xxcbk_cr_date),1,year(xxcbk_cr_date)) <= date(month,1,year) 
        no-lock,
    each xxcbkd_det 
        where xxcbkd_domain = global_domain
        and xxcbkd_bk_type  = v_bk_type
        and xxcbkd_bk_nbr   = xxcbk_bk_nbr
        and xxcbkd_bk_ln    >= bk_ln and xxcbkd_bk_ln <= bk_ln1 
        no-lock,
    each xxtrh_hist
        where xxtrh_domain = global_domain 
        and xxtrh_cu_ln = xxcbkd_cu_ln
        and xxtrh_year  = year
        and xxtrh_month = month
        and xxtrh_vend >= vend and xxtrh_vend <= vend1
        break by xxcbkd_bk_nbr by xxcbkd_bk_ln by xxtrh_vend :
        
        find first temp1 
            where t1_bk_nbr = xxcbkd_bk_nbr
            and t1_bk_ln    = xxcbkd_bk_ln
            and t1_vend     = xxtrh_vend
        no-error .
        if not avail temp1 then do:
            create temp1 .
            assign 
            t1_bk_nbr = xxcbkd_bk_nbr
            t1_bk_ln  = xxcbkd_bk_ln
            t1_vend   = xxtrh_vend
            t1_cu_ln  = xxcbkd_cu_ln
            t1_cu_part  = xxcbkd_cu_part
            t1_cu_um    = xxcbkd_um
            t1_year     = year
            t1_month    = month
            t1_qty_a    = xxtrh_qty_begin 
            .
        end.
        else do:
            assign t1_qty_a = t1_qty_a + xxtrh_qty_begin .
        end.

end. /*for each */


for each temp1 :
    v_qty_m = 0 .
    for each xxsl_mstr 
            where xxsl_domain = global_domain 
            and xxsl_type = yes 
            and xxsl_addr_from = t1_vend 
            and date(month(xxsl_start),1,year(xxsl_start)) = date(month,1,year)
            no-lock,
        each xxsld_det 
            where xxsld_domain = global_domain 
            and xxsld_nbr = xxsl_nbr
            and xxsld_bk_to = t1_bk_nbr
            and xxsld_cu_ln = t1_cu_ln
            no-lock :
        v_qty_m = v_qty_m + xxsld_qty_ord .
    end.
    t1_qty_b = v_qty_m .
    t1_qty_c = t1_qty_a - t1_qty_b .
end.

for each temp1 :
    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = t1_cu_ln no-lock no-error.
    v_desc1 = if avail xxcpt_mstr then xxcpt_desc else "" .
    find first ad_mstr where ad_domain = global_domain and ad_addr = t1_vend no-lock no-error.
    v_desc2 = if avail ad_mstr then ad_name else "" .

    put unformatted  
    t1_bk_nbr ";" 
    "PARTS;"    
    t1_bk_ln ";" 
    t1_cu_ln  ";" 
    t1_cu_part ";" 
    v_desc1  ";" 
    t1_cu_um ";" 
    t1_vend ";" 
    v_desc2 ";" 
    "MPP" + string(t1_bk_ln) ";"  
    v_desc1 ";" 
    t1_qty_a  ";" 
    t1_qty_b ";" 
    t1_qty_c   ";"
    string(t1_year, "9999") + "年" + string(t1_month, "99") + "月;;" 
    skip .
    
end.



end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
