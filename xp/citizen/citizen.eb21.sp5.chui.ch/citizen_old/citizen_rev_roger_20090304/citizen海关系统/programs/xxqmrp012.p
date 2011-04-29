/* xxqmrp012.p   出口申报单查询                                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 2008/05/15   BY: Softspeed RogerXiao         */
/******************************************************************************/

{mfdtitle.i "1.0"}

define var v_form_type as char . v_form_type = "1" .   /*customs declaration form type*/
define var v_bk_type  like xxcbkd_bk_type initial  "OUT" .

define var eff_date as date label "出口日期" .
define var eff_date1 as date label "至" .
define var nbr  as char format "x(18)"  label "申报单号" .
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
    field t1_cu_ln like xxcpt_ln
    field t1_cu_part like xxcpt_cu_part
    field t1_desc    like xxcpt_desc
    field t1_qty     like xxeprd_cu_qty
    field t1_um      like xxcpt_um
    field t1_ctry    like xxeprd_ctry
    field t1_price   like xxeprd_price
    field t1_amt     like xxeprd_amt
    field t1_bk_nbr  like xxcbkd_bk_nbr
    field t1_bk_ln   like xxcbkd_bk_ln
    field t1_stat    like xxeprd_stat 
    index t1_pr_nbr  t1_pr_nbr t1_pr_line
    .


define frame a .


form
    skip(1)

    eff_Date    colon 18  
    eff_date1   colon 45 
    v_bk_nbr    colon 18
    v_bk_nbr1   colon 45
    nbr         colon 18 
    nbr1        colon 45 
    cu_part     colon 18  
    cu_part1    colon 45 
    cu_ln      colon 18  
    cu_ln1     colon 45 
    v_yn       colon 18



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
    if nbr1 = hi_char       then nbr1 = "" .
    if v_bk_nbr1 = hi_char       then v_bk_nbr1 = "" .

    update eff_date eff_date1 v_bk_nbr v_bk_nbr1 nbr nbr1 cu_part cu_part1 cu_ln cu_ln1 v_yn with frame a editing:
        if frame-field="cu_part" then do:
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
        end.
        else do:
            status input ststatus.
            readkey.
            apply lastkey.
        end.
    end. /*update */
    assign eff_date eff_date1 v_bk_nbr v_bk_nbr1 nbr nbr1 cu_part cu_part1 cu_ln cu_ln1 v_yn .


    if cu_ln1 = 0    then cu_ln1 = 99999 .
    if cu_part1 = ""  then cu_part1 = hi_char .
    if eff_date = ?   then eff_date = low_date .
    if eff_date1 = ?  then eff_date1 = hi_date .
    if nbr1 = ""      then nbr1 = hi_char .
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

        {mfphead.i}
        jj = 0 .
        for each xxepr_mstr 
                where xxepr_domain = global_domain 
                and xxepr_nbr >= nbr and xxepr_nbr <= nbr1
                and xxepr_bk_nbr  >= v_bk_nbr and xxepr_bk_nbr <= v_bk_nbr1
                and xxepr_date >= eff_date and xxepr_date <= eff_date1
                no-lock ,
            each xxeprd_det 
                where xxeprd_domain = global_domain 
                and xxeprd_nbr = xxepr_nbr
                and xxeprd_cu_part >= cu_part  and xxeprd_cu_part <= cu_part1 
                and xxeprd_cu_ln  >= cu_ln   and xxeprd_cu_ln <= cu_ln1
                and (xxeprd_stat = "" or v_yn = no )
            no-lock break by xxeprd_nbr by xxeprd_line :

            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxeprd_cu_ln no-lock no-error.
            find first xxcbkd_det 
                where xxcbkd_domain = global_domain 
                and xxcbkd_bk_type     = v_bk_type 
                and xxcbkd_bk_nbr   = xxepr_bk_nbr
                and xxcbkd_cu_ln    = xxeprd_cu_ln
            no-lock no-error .
            


            find first temp1 
                where t1_pr_nbr = xxeprd_nbr
                and t1_pr_line  = xxeprd_line
                and t1_cu_ln = xxeprd_cu_ln 
            no-error .
            if not avail temp1 then do:
                jj = jj + 1 .
                create temp1 .
                assign 
                    t1_nbr   = ""
                    t1_line  = jj
                    t1_pr_nbr   = xxeprd_nbr
                    t1_pr_line  = xxeprd_line
                    t1_stat     = xxeprd_stat
                    t1_cu_ln    = xxeprd_cu_ln 
                    t1_cu_part = xxeprd_cu_part 
                    t1_desc    = if avail xxcpt_mstr then xxcpt_desc else ""
                    t1_qty     = xxeprd_cu_qty
                    t1_um      = xxeprd_cu_um 
                    t1_ctry    = xxeprd_ctry
                    t1_price   = xxeprd_price
                    t1_amt     = xxeprd_amt 
                    t1_bk_nbr  = xxepr_bk_nbr
                    t1_bk_ln   = if avail xxcbkd_det then xxcbkd_bk_ln else 0 .
            end.

        end. /*for each xxepr_mstr*/

        for each temp1 
            break by t1_nbr by t1_line by t1_cu_ln 
            with frame x width 300 :
                disp
                    t1_line    label "项" 
                    t1_pr_nbr  label "申报单号"
                    t1_pr_line label "项"
                    t1_bk_nbr  label "手册号"
                    t1_bk_ln   label "手册项"
                    t1_cu_ln   label "公司序"
                    t1_cu_part label "商品编码"
                    t1_desc    label "商品品名"
                    t1_qty     label "数量"
                    t1_um      label "单位"
                    t1_ctry    label "原产地"
                    t1_price   label "单价"
                    t1_amt     label "金额"
                    t1_stat    label "状态"
                    
                with frame x.
        end. /*for each temp1*/

        {mfreset.i}  /*{mfrtrail.i}   REPORT TRAILER  */
        {wbrp04.i &frame-spec = a}
    end. /*printloop:*/
end. /*mainloop*/

