/* xxqmrp014.p   进口申报单打印                                             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 2008/05/15   BY: Softspeed RogerXiao         */
/******************************************************************************/

{mfdtitle.i "1.0"}

define var v_form_type as char . v_form_type = "1" .   /*customs declaration form type*/
define var v_bk_type  like xxcbkd_bk_type initial  "IMP" .

define var eff_date as date label "报关日期" .
define var eff_date1 as date label "至" .
define var nbr  as char format "x(18)" label "申报单号".
define var nbr1 as char format "x(18)" label "至".
define var cu_part  as char format "x(18)" label "商品编号".
define var cu_part1 as char format "x(18)" label "至".
define var cu_ln   like xxcpt_ln format ">>>>>" label "商品序" .
define var cu_ln1  like xxcpt_ln  format ">>>>>" label "至" .
define var v_bk_nbr like xxcbk_bk_nbr  label "手册号" .
define var v_bk_nbr1 like xxcbk_bk_nbr  label "至" .
define var v_yn as logical label "仅限未结" initial yes .
define var jj  as integer format ">>9" label "行".


define temp-table temp1
    field t1_nbr like xximpd_nbr 
    field t1_line as integer format ">>9" 
    field t1_pr_nbr like xximpd_nbr 
    field t1_pr_line as integer format ">>9" 
    field t1_cu_ln   like xxcpt_ln
    field t1_cu_part like xxcpt_cu_part
    field t1_desc    like xxcpt_desc
    field t1_qty     like xxiprd_cu_qty
    field t1_um      like xxcpt_um
    field t1_ctry    like xxiprd_ctry
    field t1_price   like xxiprd_price
    field t1_amt     like xxiprd_amt
    field t1_bk_nbr  like xxcbkd_bk_nbr
    field t1_bk_nbr_true like xxcbk_contract
    field t1_bk_ln   like xxcbkd_bk_ln
    field t1_stat    like xxiprd_stat 
    field t1_ship_nbr like xxipr_ship_nbr
    field t1_license like xxipr_license
    field t1_loc     like xxipr_loc
    field t1_car     like xxipr_car
    field t1_driver  like xxipr_driver
    field t1_box_num like xxipr_box_num
    field t1_gross   like xxipr_gross

    index t1_pr_nbr  t1_pr_nbr t1_pr_line
    .


define frame a .


form
    skip(1)
    nbr         colon 18  
    /*nbr1        colon 45
    eff_Date    colon 18  
    eff_date1   colon 45 
    v_bk_nbr    colon 18
    v_bk_nbr1   colon 45
    cu_ln      colon 18  
    cu_ln1     colon 45 
    cu_part     colon 18  
    cu_part1    colon 45 
    v_yn       colon 18*/



    skip(1)
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).


{wbrp01.i}                                                                                   
mainloop:
repeat:
    
    for each temp1: delete temp1. end.
    
    hide all no-pause . {xxtop.i}
    view frame  a  .
    clear frame a no-pause .
    if eff_date = low_date  then eff_date = ? .
    if eff_date1 = hi_date  then eff_date1 = ? .
    if cu_part1 = hi_char   then cu_part1 = "" .
    if cu_ln1 = 99999      then cu_ln1 = 0 .
    /*if nbr1 = hi_char       then nbr1 = "" .*/
    if v_bk_nbr1 = hi_char       then v_bk_nbr1 = "" .

    update nbr /*eff_date eff_date1 v_bk_nbr v_bk_nbr1  cu_part cu_part1 cu_ln cu_ln1 v_yn*/ with frame a editing:
        if frame-field="nbr" then do:
            {mfnp01.i xxipr_mstr nbr xxipr_nbr global_domain xxipr_domain xxipr_nbr}
            if recno <> ? then do:
                disp xxipr_nbr @ nbr  
                with frame a.
            end.
        end. /*
        else if frame-field="cu_part" then do:
            {mfnp01.i xxcpt_mstr cu_part xxcpt_cu_part global_domain xxcpt_domain xxcpt_cu_part}
            if recno <> ? then do:
                disp xxcpt_cu_part @ cu_part  
                with frame a.
            end.
        end.
        else if frame-field="cu_part1" then do:
            {mfnp01.i xxcpt_mstr cu_part1 xxcpt_cu_part global_domain xxcpt_domain xxcpt_cu_part}
            if recno <> ? then do:
                disp xxcpt_cu_part @ cu_part1  
                with frame a.
            end.
        end.
        else if frame-field="v_bk_nbr" then do:
            {mfnp01.i xxcbk_mstr v_bk_nbr xxcbk_bk_nbr global_domain xxcbk_domain xxcbk_bk_nbr}
            if recno <> ? then do:
                disp xxcbk_bk_nbr @ v_bk_nbr  
                with frame a.
            end.
        end.
        else if frame-field="v_bk_nbr1" then do:
            {mfnp01.i xxcbk_mstr v_bk_nbr1 xxcbk_bk_nbr global_domain xxcbk_domain xxcbk_bk_nbr}
            if recno <> ? then do:
                disp xxcbk_bk_nbr @ v_bk_nbr1  
                with frame a.
            end.
        end.
        else if frame-field="cu_ln" then do:
            {mfnp01.i xxcpt_mstr cu_ln xxcpt_ln global_domain xxcpt_domain xxcpt_ln}
            if recno <> ? then do:
                disp xxcpt_ln @ cu_ln  
                with frame a.
            end.
        end.
        else if frame-field="cu_ln1" then do:
            {mfnp01.i xxcpt_mstr cu_ln1 xxcpt_ln global_domain xxcpt_domain xxcpt_ln}
            if recno <> ? then do:
                disp xxcpt_ln @ cu_ln1  
                with frame a.
            end.
        end. */
        else do:
            status input ststatus.
            readkey.
            apply lastkey.
        end.
    end. /*update 
    assign eff_date eff_date1 v_bk_nbr v_bk_nbr1 nbr cu_part cu_part1 cu_ln cu_ln1 v_yn .*/
    assign nbr .


    if cu_ln1 = 0    then cu_ln1 = 99999 .
    if cu_part1 = ""  then cu_part1 = hi_char .
    if eff_date = ?   then eff_date = low_date .
    if eff_date1 = ?  then eff_date1 = hi_date .
    /*if nbr1 = ""      then nbr1 = hi_char .*/
    if v_bk_nbr1 = ""      then v_bk_nbr1 = hi_char .



    printloop:
    do on error undo, retry:

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


        PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp014" SKIP.
        PUT UNFORMATTED "#def :end" SKIP.

        jj = 0 .
        for each xxipr_mstr 
                where xxipr_domain = global_domain 
                and xxipr_nbr = nbr /*and xxipr_nbr <= nbr1
                and xxipr_bk_nbr  >= v_bk_nbr and xxipr_bk_nbr <= v_bk_nbr1
                and xxipr_req_date >= eff_date and xxipr_req_date <= eff_date1*/
                no-lock ,
            each xxiprd_det 
                where xxiprd_domain = global_domain 
                and xxiprd_nbr = xxipr_nbr /*
                and xxiprd_cu_part >= cu_part  and xxiprd_cu_part <= cu_part1 
                and xxiprd_cu_ln  >= cu_ln   and xxiprd_cu_ln <= cu_ln1
                and (xxiprd_stat = "" or v_yn = no )*/
            no-lock break by xxiprd_nbr by xxiprd_line :

            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxiprd_cu_ln no-lock no-error.
            find first xxcbkd_det 
                where xxcbkd_domain = global_domain 
                and xxcbkd_bk_type     = v_bk_type 
                and xxcbkd_bk_nbr   = xxipr_bk_nbr
                and xxcbkd_cu_ln    = xxiprd_cu_ln
            no-lock no-error .

            find first xxcbk_mstr 
                where xxcbk_domain = global_domain 
                and xxcbk_bk_nbr   = xxipr_bk_nbr
            no-lock no-error .
            

            find first temp1 
                where t1_pr_nbr = xxiprd_nbr
                and t1_pr_line  = xxiprd_line
                and t1_cu_ln = xxiprd_cu_ln 
            no-error .
            if not avail temp1 then do:
                jj = jj + 1 .
                create temp1 .
                assign 
                    t1_nbr   = ""
                    t1_line  = jj
                    t1_pr_nbr   = xxiprd_nbr
                    t1_pr_line  = xxiprd_line
                    t1_stat     = xxiprd_stat
                    t1_cu_ln    = xxiprd_cu_ln 
                    t1_cu_part = xxiprd_cu_part 
                    t1_desc    = if avail xxcpt_mstr then xxcpt_desc else ""
                    t1_qty     = xxiprd_cu_qty
                    t1_um      = xxiprd_cu_um 
                    t1_ctry    = xxiprd_ctry
                    t1_price   = xxiprd_price
                    t1_amt     = xxiprd_amt 
                    t1_bk_nbr  = xxipr_bk_nbr
                    t1_bk_nbr_true = if avail xxcbk_mstr then xxcbk_contract else xxipr_bk_nbr
                    t1_bk_ln   = if avail xxcbkd_det then xxcbkd_bk_ln else 0 
                    t1_gross   = xxipr_gross
                    t1_box_num = xxipr_box_num
                    t1_driver  = xxipr_driver
                    t1_car     = xxipr_car
                    t1_loc     = xxipr_loc
                    t1_license = xxipr_license
                    t1_ship_nbr = xxipr_ship_nbr

                    .
            end.

        end. /*for each xxipr_mstr*/
        
        jj = 0 .
        for each temp1 
            break by t1_nbr by t1_line by t1_cu_ln :
            jj = jj + 1 .
            put unformatted 
                t1_bk_nbr_true ";" 
                t1_ship_nbr ";"
                t1_license ";"
                "来料加工;"
                t1_loc ";"
                t1_bk_ln ";"
                t1_desc ";"
                t1_ctry ";"
                t1_qty ";"
                t1_um ";"
                "美元;"
                t1_amt ";"
                t1_driver ";"
                t1_car ";"
                t1_box_num ";"
                t1_gross skip .
               

        end. /*for each temp1*/

do while jj < 8 :
    jj = jj + 1 .
    put unformatted ";;;;;;;;;;;;;;;" skip .
end.

        {mfreset.i}  /*{mfrtrail.i}   REPORT TRAILER  */
        {wbrp04.i &frame-spec = a}
    end. /*printloop:*/
end. /*mainloop*/


/*
put unformatted "中华人民共和国深圳海关;;;;;;;" skip.
put unformatted "进口集中报关货物申报单;;;;;;;" skip.
put unformatted "沙集进;;;;;;;" skip .
put unformatted ";;;;;;;" skip.
put unformatted "手册编号/电子账册编码：;;;;;;;" skip.

put unformatted "收货单位;;深圳市龙岗区坑梓镇冠润电子制品厂;;统一载货清单号;;" . 
put unformatted xxx ";" skip.

put unformatted "许可证件号;;" .
put unformatted xxx ";".
put unformatted "监管方式;".
put unformatted xxx ";".
put unformatted "贸易国别（地区）;" .
put unformatted xxx ";" skip .

put unformatted "项号;备案序号;货名及规格;原产国;数（重）量;单位;币值;总价" skip.
put unformatted "1;;;;;;;" skip.
put unformatted "2;;;;;;;" skip.
put unformatted "3;;;;;;;" skip.
put unformatted "4;;;;;;;" skip.
put unformatted "5;;;;;;;" skip.
put unformatted "6;;;;;;;" skip.
put unformatted "7;;;;;;;" skip.
put unformatted "8;;;;;;;" skip.

put unformatted "司机薄海关编号;;" .
put unformatted xxx ";;" .
put unformatted "境内车牌号" .
put unformatted xxx ";;;" skip .

put unformatted "总件数;" .
put unformatted xxx ";" .
put unformatted "总重量（公斤）;" .
put unformatted xxx ";" .
put unformatted "集装箱号码;" .
put unformatted xxx ";;" skip.
put unformatted "上述无讹：;;;;海关批注：;;;" skip .
put unformatted ";;;;;;;" skip .
put unformatted ";;;;;;;" skip .
put unformatted "运输公司（签章）;;境内企业（签章）;;;;;" skip.
put unformatted ";;;;;;;" skip .
put unformatted ";;;;;;;" skip .
put unformatted "驾驶员签名：;;;;海关签章：;;;" skip .
put unformatted ";;;;;;;" skip .
put unformatted ";;;;;;;" skip .
put unformatted "进口日期：          年          月       日;;;;                                年          月       日;;;" skip .
*/