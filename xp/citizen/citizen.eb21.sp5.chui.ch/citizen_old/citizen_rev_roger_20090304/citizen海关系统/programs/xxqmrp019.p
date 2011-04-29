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

define var year      as integer format "9999" label "年".
define var month     as integer format "99" label "月".
define var vend      like po_vend .
define var v_bk_nbr    like xxcbk_bk_nbr  .
define var v_bk_ln     like xxcpt_ln format ">>>>>>".
define var v_cu_ln     like xxcpt_ln format ">>>>>>".

define var v_qty_a like tr_qty_loc .
define var v_qty_b like tr_qty_loc .
define var jj as integer .

define temp-table temp1 
    field t1_year as integer
    field t1_month1 as integer 
    field t1_month2 as integer
    field t1_qty_a like tr_qty_loc 
    field t1_qty_b like tr_qty_loc 
    field t1_qty_c like tr_qty_loc 
    field t1_qty_d like tr_qty_loc
    .


year = year(today) .
month = month(today) .


define  frame a.

form
    SKIP(.2)
    skip(1)

    year                colon 14 
    month               colon 14 
    vend                colon 14 label "供应商" 
    ad_name             no-label 
    v_bk_nbr              colon 14 label "手册号"
    v_bk_ln               colon 14 label "手册序号"
    xxcbkd_cu_ln        colon 14 label "商品序号"
    xxcpt_cu_part       colon 14 label "商品编码"
    xxcpt_desc          colon 14 label "商品名称"

    skip (2)
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause . {xxtop.i}
    view frame  a  .


    update year month vend v_bk_nbr v_bk_ln  with frame a editing:
        if frame-field="v_bk_nbr" then do:
            {mfnp01.i xxcbk_mstr v_bk_nbr xxcbk_bk_nbr global_domain xxcbk_domain xxcbk_bk_nbr}
            if recno <> ? then do:
                disp xxcbk_bk_nbr @ v_bk_nbr  
                with frame a.
            end.
        end.
        else if frame-field="v_bk_ln" then do:
            {mfnp01.i xxcbkd_det v_bk_ln xxcbkd_bk_ln v_bk_type "xxcbkd_domain = global_domain and xxcbkd_bk_nbr = input v_bk_nbr and xxcbkd_bk_type " xxcbkd_bk_nbr}
            if recno <> ? then do:
                disp xxcbkd_bk_ln @ v_bk_ln xxcbkd_cu_ln   
                with frame a.
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcbkd_cu_ln no-lock no-error.
                if avail xxcpt_mstr then disp xxcpt_cu_part xxcpt_desc with frame a.
            end.
        end.
        else if frame-field="vend" then do:
            {mfnp01.i ad_mstr vend ad_addr global_domain ad_domain ad_addr}
            if recno <> ? then do:
                disp ad_addr @ vend ad_name  
                with frame a.
            end.
        end.
        else do:
            status input ststatus.
            readkey.
            apply lastkey.
        end.
    end. /*update */
    assign year month vend v_bk_nbr v_bk_ln .

    find first ad_mstr 
        where ad_domain  = global_domain 
        and ad_addr = vend 
    no-lock no-error .
    if not avail ad_mstr then do:
        message "无效供应商,请重新输入" view-as alert-box .
        undo,retry.
    end.

    find first xxcbkd_det 
        where xxcbkd_domain = global_domain 
        and xxcbkd_bk_type = v_bk_type 
        and xxcbkd_bk_nbr = v_bk_nbr 
        and xxcbkd_bk_ln  = v_bk_ln
    no-lock no-error .
    v_cu_ln = if avail xxcbkd_det then xxcbkd_cu_ln else 0 .
    if avail xxcbkd_det then do:
        disp xxcbkd_bk_ln @ v_bk_ln xxcbkd_cu_ln   
        with frame a.
        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcbkd_cu_ln no-lock no-error.
        if avail xxcpt_mstr then disp xxcpt_cu_part xxcpt_desc with frame a.
        else do:
            message "无效商品,请重新输入" view-as alert-box.
            undo,retry.
        end.  
    end.
    else do:
        message "无效手册/项,请重新输入" view-as alert-box.
        undo,retry.
    end.


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

PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp019" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

for each temp1 : delete temp1 . end .

jj = 0 .
do jj = 0 to 12 :
    create temp1 .
    assign t1_year = year t1_month1 = jj t1_month2 = jj + 1 .
end.

for each temp1 :
    find first xxtrh_hist 
        where xxtrh_domain = global_domain 
        and xxtrh_year     = t1_year
        and xxtrh_month    = t1_month2
        and xxtrh_vend     = vend 
        and xxtrh_cu_ln    = v_cu_ln 
    no-lock no-error.
    if avail xxtrh_hist then t1_qty_d = xxtrh_qty_begin .
end.  /*for each temp1:*/

for each temp1:
    v_qty_a = 0 . /*此供应商,本月生效的,转入关封数,是申请数非剩余数*/
    for each xxsl_mstr 
            where xxsl_domain = global_domain
            and xxsl_type = yes 
            and xxsl_addr_from = vend 
            and date(month(xxsl_start),1,year(xxsl_start)) = date(t1_month1,1,t1_year)
            no-lock,
        each xxsld_det 
            where xxsld_domain = global_domain 
            and xxsld_nbr = xxsl_nbr
            /*and xxsld_bk_to = v_bk_nbr */
            and xxsld_cu_ln = v_cu_ln
            no-lock :

        v_qty_a = v_qty_a + xxsld_qty_ord .

    end.
    t1_qty_a = v_qty_a .


    v_qty_b = 0 . /*此合同项,此供应商(关封),本月的报关数 */
    for each xximp_mstr 
            where  xximp_domain = global_domain
            and ( xximp_type = "2") 
            and date(month(xximp_req_date),1,year(xximp_req_date)) = date(t1_month1,1,t1_year)
            /*and xximp_bk_nbr = v_bk_nbr*/
            no-lock ,
        each xximpd_det 
            where xximpd_domain = global_domain
            and xximpd_nbr = xximp_nbr
            and xximpd_cu_ln = v_cu_ln
            no-lock :

        find first xxsl_mstr 
            where xxsl_domain = global_domain
            and xxsl_type = yes 
            and xxsl_nbr  = xximp_sl_nbr
            and xxsl_addr_from = vend 
        no-lock no-error .
        if not avail xxsl_mstr then next .

        v_qty_b = v_qty_b + xximpd_cu_qty .
    end.

    t1_qty_b = v_qty_b .
    

    find first xxtrh_hist 
        where xxtrh_domain = global_domain 
        and xxtrh_year     = t1_year
        and xxtrh_month    = t1_month1
        and xxtrh_vend     = vend 
        and xxtrh_cu_ln    = v_cu_ln 
    no-lock no-error .
    if avail xxtrh_hist then t1_qty_c = xxtrh_qty_send .

end. /*for each temp1:*/

for each temp1 break by t1_year by t1_month1:
    put unformatted 
    v_bk_nbr  ";"
    ad_name ";"
    vend ";"
    "MPP" + string(v_cu_ln) ";"
    xxcpt_desc ";"
    v_bk_ln ";"
    xxcpt_desc ";"
    xxcpt_um ";"
    "PARTS;" 
    .
    
    if t1_month1 = 0 
    then put unformatted "承上年;" .
    else put unformatted string(t1_year,"9999") + "年" + string(t1_month1,"99") + "月;" .
    
    put unformatted 
        t1_qty_d ";"
        t1_qty_c ";"
        t1_qty_b ";"
        t1_qty_a ";"
        skip.

end. /*for each temp1:*/
    







end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
