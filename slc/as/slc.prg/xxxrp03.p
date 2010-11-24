/*  ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100412.1 By: Kaine Zhang */
/* SS - 100423.1 By: Kaine Zhang */
/* SS - 100625.1 By: Kaine Zhang */
/* SS - 100701.1 By: Kaine Zhang */

/*  
 *  20100701
 *  1. 入库,出库.统计的金额,都用含税价.
 */

/*  20100701
 *  对于CY-ZGCL,CY-WGZ这两种类型,不统计它们的数量和金额.
 *  因为RCT-ZG,RCT-PO已经体现了数量与金额的差异,不需再重复统计
 */
/* *ss_20100625* 取消库位的分级 */
/* *ss_20100421* 材料账材料明细表 */
/* *ss_20100423* 本期暂估入库金额 */

{mfdtitle.i "100701.1"}

define variable iYear as integer format ">>>9" label "年份" no-undo.
define variable iMonth as integer format ">9" label "期间" no-undo.
define variable sVendorA as character label "供应商" no-undo.
define variable sVendorB as character label "至" no-undo.

define variable decTrSoQty like ld_qty_oh no-undo.
define variable decTrSoAmt like ld_qty_oh no-undo.
define variable decTrWoQty like ld_qty_oh no-undo.
define variable decTrWoAmt like ld_qty_oh no-undo.
define variable sVendorSort like vd_sort no-undo.
define variable sVendorTypeDesc as character format "x(10)" no-undo.
define variable decStartQty like ld_qty_oh no-undo.
define variable decStartAmt like ld_qty_oh no-undo.
define variable decFinishQty like ld_qty_oh no-undo.
define variable decFinishAmt like ld_qty_oh no-undo.
/* SS - 100423.1 - B */
define variable decZGQty as decimal no-undo.
define variable decZGAmt as decimal no-undo.
/* SS - 100423.1 - E */

define temp-table t1_tmp no-undo
    field t1_vendor as character
    field t1_part like pt_part
    /* SS - 100625.1 - B
    field t1_loc like ld_loc
    SS - 100625.1 - E */
    field t1_current_qty like ld_qty_oh
    field t1_current_amt like ld_qty_oh
    field t1_in_qty like ld_qty_oh
    field t1_in_amt like ld_qty_oh
    field t1_out_qty like ld_qty_oh
    field t1_out_amt like ld_qty_oh
    field t1_overperiod_qty like ld_qty_oh
    field t1_overperiod_amt like ld_qty_oh
    field t1_out_so_qty like ld_qty_oh
    field t1_out_so_amt like ld_qty_oh
    field t1_out_wo_qty like ld_qty_oh
    field t1_out_wo_amt like ld_qty_oh
    /* SS - 100423.1 - B */
    field t1_zg_qty like ld_qty_oh
    field t1_zg_amt like ld_qty_oh
    /* SS - 100423.1 - E */
    .
    
form
    iYear   colon 15
    iMonth  colon 15
    sVendorA    colon 15
    sVendorB    colon 45
with frame a side-labels width 80.
setframelabels(frame a:handle).

form
    t1_vendor           column-label "供应商"
    sVendorSort         column-label "简称"
    t1_part             column-label "零件"
    pt_desc1            column-label "说明"
    /* SS - 100625.1 - B
    t1_loc              column-label "库位"
    SS - 100625.1 - E */
    pt_prod_line        column-label "产品线"
    sVendorTypeDesc     column-label "挂账类型"
    decStartQty         column-label "期初数量"
    decStartAmt         column-label "期初金额"
    t1_in_qty           column-label "入库数量"
    t1_in_amt           column-label "入库金额"
    t1_out_qty          column-label "出库数量"
    t1_out_amt          column-label "出库金额"
    decFinishQty        column-label "期末数量"
    decFinishAmt        column-label "期末金额"
    t1_out_so_qty       column-label "出销售数量"
    t1_out_so_amt       column-label "出销售金额"
    t1_out_wo_qty       column-label "出工单数量"
    t1_out_wo_amt       column-label "出工单金额"
    /* SS - 100423.1 - B */
    t1_zg_qty           column-label "暂估入库数量"
    t1_zg_amt           column-label "暂估入库金额"
    /* SS - 100423.1 - E */
with frame b down width 320.
setframelabels(frame b:handle).



{wbrp01.i}
repeat on endkey undo, leave:
    {xxxxrpinput.i}

    /* output destination selection */
    {gpselout.i
        &printtype = "printer"
        &printwidth = 132
        &pagedflag = " "
        &stream = " "
        &appendtofile = " "
        &streamedoutputtoterminal = " "
        &withbatchoption = "yes"
        &displaystatementtype = 1
        &withcancelmessAge = "yes"
        &pagebottommargin = 6
        &withemail = "yes"
        &withwinprint = "yes"
        &definevariables = "yes"
    }



    empty temp-table t1_tmp.

    for each xxld_det
        no-lock
        where xxld_domain = global_domain
            and xxld_vend >= sVendorA
            and xxld_vend <= sVendorB
        break
        by xxld_vend
        by xxld_part
        /* SS - 100625.1 - B
        by xxld_loc
        SS - 100625.1 - E */
    :
        /* SS - 100625.1 - B
        accumulate xxld_qty (total by xxld_loc).
        accumulate xxld_qty * xxld_tax_price (total by xxld_loc).
        SS - 100625.1 - E */
        /* SS - 100625.1 - B */
        accumulate xxld_qty (total by xxld_part).
        accumulate xxld_qty * xxld_tax_price (total by xxld_part).
        /* SS - 100625.1 - E */
        

        /* SS - 100625.1 - B
        if last-of(xxld_loc) then do:
        SS - 100625.1 - E */
        /* SS - 100625.1 - B */
        if last-of(xxld_part) then do:
        /* SS - 100625.1 - E */
            create t1_tmp.
            assign
                t1_vendor = xxld_vend
                t1_part = xxld_part
                /* SS - 100625.1 - B
                t1_loc = xxld_loc
                t1_current_qty = accum total by xxld_loc xxld_qty
                t1_current_amt = accum total by xxld_loc xxld_qty * xxld_tax_price
                SS - 100625.1 - E */
                /* SS - 100625.1 - B */
                t1_current_qty = accum total by xxld_part xxld_qty
                t1_current_amt = accum total by xxld_part xxld_qty * xxld_tax_price
                /* SS - 100625.1 - E */
                .
        end.
    end.

    for each xxtr_hist
        no-lock
        where xxtr_domain = global_domain
            and xxtr_year * 100 + xxtr_per >= iYear * 100 + iMonth
            and xxtr_vend >= sVendorA
            and xxtr_vend <= sVendorB
            /* SS - 100701.1 - B */
            and xxtr_type <> "CY-ZGCL"
            and xxtr_type <> "CY-WGZ"
            /* SS - 100701.1 - E */
        break
        by xxtr_vend
        by xxtr_part
        /* SS - 100625.1 - B
        by xxtr_loc
        SS - 100625.1 - E */
        by xxtr_year
        by xxtr_per
        by xxtr_sort
    :
        /* SS - 100423.1 - B */
        decZGQty = 0.
        decZGAmt = 0.
        if xxtr_year = iYear and xxtr_per = iMonth then do:
            decZGQty = 
                if xxtr_type = "RCT-ZG" and xxtr_rmks <> "暂估处理" then xxtr_qty
                else 0
                .
            /* SS - 100701.1 - B
            decZGAmt = 
                if xxtr_type = "RCT-ZG" and xxtr_rmks <> "暂估处理" then (xxtr_amt / (1 + xxtr_tax_pct / 100))
                else 0
                .
            SS - 100701.1 - E */
            /* SS - 100701.1 - B */
            decZGAmt = 
                if xxtr_type = "RCT-ZG" and xxtr_rmks <> "暂估处理" then xxtr_amt
                else 0
                .
            /* SS - 100701.1 - E */
        end.
        /* SS - 100423.1 - E */
        
        accumulate xxtr_qty (total by xxtr_sort).
        /* SS - 100701.1 - B
        accumulate (xxtr_amt / (1 + xxtr_tax_pct / 100)) (total by xxtr_sort).
        SS - 100701.1 - E */
        /* SS - 100701.1 - B */
        accumulate xxtr_amt (total by xxtr_sort).
        /* SS - 100701.1 - E */
        /* SS - 100423.1 - B */
        accumulate decZGQty (total by xxtr_sort).
        accumulate decZGAmt (total by xxtr_sort).
        /* SS - 100423.1 - E */

        assign
            decTrSoQty = 0
            decTrSoAmt = 0
            decTrWoQty = 0
            decTrWoAmt = 0
            .
        if xxtr_sort = "out" and xxtr_year = iYear and xxtr_per = iMonth then do:
            find first so_mstr
                no-lock
                where so_domain = global_domain
                    and so_nbr = xxtr_nbr
                no-error.
            if available(so_mstr) then
                assign
                    decTrSoQty = xxtr_qty
                    /* SS - 100701.1 - B
                    decTrSoAmt = (xxtr_amt / (1 + xxtr_tax_pct / 100))
                    SS - 100701.1 - E */
                    /* SS - 100701.1 - B */
                    decTrSoAmt = xxtr_amt
                    /* SS - 100701.1 - E */
                    .
            find first wo_mstr
                no-lock
                where wo_domain = global_domain
                    and wo_lot = xxtr_lot
                no-error.
            if available(wo_mstr) then
                assign
                    decTrWoQty = xxtr_qty
                    /* SS - 100701.1 - B
                    decTrWoAmt = (xxtr_amt / (1 + xxtr_tax_pct / 100))
                    SS - 100701.1 - E */
                    /* SS - 100701.1 - B */
                    decTrWoAmt = xxtr_amt
                    /* SS - 100701.1 - E */
                    .
        end.
        accumulate decTrSoQty (total by xxtr_per).
        accumulate decTrSoAmt (total by xxtr_per).
        accumulate decTrWoQty (total by xxtr_per).
        accumulate decTrWoAmt (total by xxtr_per).


        if last-of(xxtr_sort) then do:
            find first t1_tmp
                where t1_vendor = xxtr_vend
                    and t1_part = xxtr_part
                    /* SS - 100625.1 - B
                    and t1_loc = xxtr_loc
                    SS - 100625.1 - E */
                no-error.
            if not(available(t1_tmp)) then do:
                create t1_tmp.
                assign
                    t1_vendor = xxtr_vend
                    t1_part = xxtr_part
                    /* SS - 100625.1 - B
                    t1_loc = xxtr_loc
                    SS - 100625.1 - E */
                    .
            end.
            if xxtr_year = iYear and xxtr_per = iMonth then do:
                if xxtr_sort = "in" then do:
                    t1_in_qty = accum total by xxtr_sort xxtr_qty.
                    /* SS - 100701.1 - B
                    t1_in_amt = accum total by xxtr_sort (xxtr_amt / (1 + xxtr_tax_pct / 100)).
                    SS - 100701.1 - E */
                    /* SS - 100701.1 - B */
                    t1_in_amt = accum total by xxtr_sort xxtr_amt.
                    /* SS - 100701.1 - E */
                    /* SS - 100423.1 - B */
                    t1_zg_qty = accum total by xxtr_sort decZGQty.
                    t1_zg_amt = accum total by xxtr_sort decZGAmt.
                    /* SS - 100423.1 - E */
                end.
                else do:
                    t1_out_qty = accum total by xxtr_sort xxtr_qty.
                    /* SS - 100701.1 - B
                    t1_out_amt = accum total by xxtr_sort (xxtr_amt / (1 + xxtr_tax_pct / 100)).
                    SS - 100701.1 - E */
                    /* SS - 100701.1 - B */
                    t1_out_amt = accum total by xxtr_sort xxtr_amt.
                    /* SS - 100701.1 - E */
                end.
                assign
                    t1_out_so_qty = accum total by xxtr_per decTrSoQty
                    t1_out_so_amt = accum total by xxtr_per decTrSoAmt
                    t1_out_wo_qty = accum total by xxtr_per decTrWoQty
                    t1_out_wo_amt = accum total by xxtr_per decTrWoAmt
                    .
            end.
            else do:
                /* SS - 100701.1 - B
                assign
                    t1_overperiod_qty = t1_overperiod_qty
                        + (if xxtr_sort = "in" then 1 else -1) * accum total by xxtr_sort xxtr_qty
                    t1_overperiod_amt = t1_overperiod_amt
                        + (if xxtr_sort = "in" then 1 else -1) * accum total by xxtr_sort (xxtr_amt / (1 + xxtr_tax_pct / 100))
                    .
                SS - 100701.1 - E */
                /* SS - 100701.1 - B */
                assign
                    t1_overperiod_qty = t1_overperiod_qty
                        + (if xxtr_sort = "in" then 1 else -1) * accum total by xxtr_sort xxtr_qty
                    t1_overperiod_amt = t1_overperiod_amt
                        + (if xxtr_sort = "in" then 1 else -1) * accum total by xxtr_sort xxtr_amt
                    .
                /* SS - 100701.1 - E */
            end.
        end.
    end.
    
    for each t1_tmp,
    each pt_mstr
        no-lock
        where pt_domain = global_domain
            and pt_part = t1_part
        break
        by t1_vendor
        by t1_part
        /* SS - 100625.1 - B
        by t1_loc
        SS - 100625.1 - E */
        with frame b
    :
        if first-of(t1_vendor) then do:
            find first vd_mstr
                no-lock
                where vd_domain = global_domain
                    and vd_addr = t1_vendor
                no-error.
            sVendorSort = if available(vd_mstr) then vd_sort else "".
            
            /* SS - 100625.1 - B
            sVendorTypeDesc = "".
            find first xvd_mstr
                no-lock
                where xvd_domain = global_domain
                    and xvd_addr = t1_vendor
                    and xvd_start_year * 100 + xvd_start_month <= iYear * 100 + iMonth
                    and xvd_finish_year * 100 + xvd_finish_month >= iYear * 100 + iMonth
                no-error.
            if available(xvd_mstr) then do:
                find first code_mstr
                    no-lock
                    where code_domain = global_domain
                        and code_fldname = "xvd_type"
                        and code_value = xvd_type
                    no-error.
                if available(code_mstr) then sVendorTypeDesc = code_cmmt.
            end.
            SS - 100625.1 - E */
            /* SS - 100625.1 - B */
            for first xxgz_mstr
                no-lock
                where xxgz_domain = global_domain
                    and xxgz_year = iYear
                    and xxgz_per = iMonth
                    and xxgz_vend = t1_vendor
            :
            end.
            if available(xxgz_mstr) then do:
                sVendorTypeDesc = xxgz_sort.
            end.
            else do:
                sVendorTypeDesc = "".
            end.
            /* SS - 100625.1 - E */
        end.
        display
            t1_vendor
            sVendorSort
            t1_part
            /* SS - 100625.1 - B
            t1_loc
            SS - 100625.1 - E */
            pt_desc1
            pt_prod_line
            sVendorTypeDesc
            (t1_current_qty - t1_overperiod_qty - t1_in_qty + t1_out_qty) @ decStartQty
            (t1_current_amt - t1_overperiod_amt - t1_in_amt + t1_out_amt) @ decStartAmt
            t1_in_qty
            t1_in_amt
            t1_out_qty
            t1_out_amt
            (t1_current_qty - t1_overperiod_qty) @ decFinishQty
            (t1_current_amt - t1_overperiod_amt) @ decFinishAmt
            t1_out_so_qty
            t1_out_so_amt
            t1_out_wo_qty
            t1_out_wo_amt
            /* SS - 100423.1 - B */
            t1_zg_qty
            t1_zg_amt
            /* SS - 100423.1 - E */
            .
        down.
    end.


    {mfreset.i}
    {mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}










