/*  ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100412.1 By: Kaine Zhang */
/* SS - 100625.1 By: Kaine Zhang */
/* SS - 100701.1 By: Kaine Zhang */


/*  
 *  20100701
 *  1. 入库,出库.统计的金额,都用含税价.
 */
/*  
 *  20100701
 *  对于CY-ZGCL,CY-WGZ这两种类型,不统计它们的数量和金额.
 *  因为RCT-ZG,RCT-PO已经体现了数量与金额的差异,不需再重复统计
 */
/* 
 *  *ss_20100625* 
 *  取消库位分级.
 *  挂账类型,取xxgz_sort的类型 .
 */
/* *ss_20100421* 材料账材料汇总表 */

{mfdtitle.i "100701.1"}

define variable iYear as integer format ">>>9" label "年份" no-undo.
define variable iMonth as integer format ">9" label "期间" no-undo.
define variable sVendorA as character label "供应商" no-undo.
define variable sVendorB as character label "至" no-undo.
define variable sProdA as character no-undo.
define variable sProdB as character no-undo.

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
define variable sVendorType as character no-undo.

define temp-table t1_tmp no-undo
    field t1_vendor as character
    field t1_vendor_type as character
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
    .
    
form
    iYear   colon 15
    iMonth  colon 15
    sVendorA    colon 15
    sVendorB    colon 45
    sProdA      colon 15    label "产品线"
    sProdB      colon 45    label "至"
with frame a side-labels width 80.
setframelabels(frame a:handle).

form
    pt_prod_line        column-label "产品线"
    pl_desc             column-label "说明"
    t1_vendor_type      column-label "挂账类型"
    decStartAmt         format "->>>>>>>>9.9<<<"    column-label "期初金额"
    t1_in_amt           format "->>>>>>>>9.9<<<"    column-label "入库金额"
    t1_out_amt          format "->>>>>>>>9.9<<<"    column-label "出库金额"
    decFinishAmt        format "->>>>>>>>9.9<<<"    column-label "期末金额"
with frame b down width 320.
setframelabels(frame b:handle).



{wbrp01.i}
repeat on endkey undo, leave:
    {xxxxrpinput01.i}

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

    /* SS - 100625.1 - B
    {xxgettmpvd.i
        iYear
        iMonth
    }
    SS - 100625.1 - E */

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
        if first-of(xxld_vend) then do:
            find first tmpvd_tmp
                no-lock
                where tmpvd_addr = xxld_vend
                no-error.
            if available(tmpvd_tmp) then do:
                sVendorType = tmpvd_type_desc.
            end.
        end.
        SS - 100625.1 - E */
        /* SS - 100625.1 - B */
        if first-of(xxld_vend) then do:
            for first xxgz_mstr
                no-lock
                where xxgz_domain = global_domain
                    and xxgz_year = iYear
                    and xxgz_per = iMonth
                    and xxgz_vend = xxld_vend
            :
            end.
            if available(xxgz_mstr) then do:
                sVendorType = xxgz_sort.
            end.
            else do:
                sVendorType = "".
            end.
        end.
        /* SS - 100625.1 - E */
        
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
                t1_vendor_type = sVendorType
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
        /* SS - 100625.1 - B
        if first-of(xxtr_vend) then do:
            find first tmpvd_tmp
                no-lock
                where tmpvd_addr = xxtr_vend
                no-error.
            if available(tmpvd_tmp) then do:
                sVendorType = tmpvd_type_desc.
            end.
        end.
        SS - 100625.1 - E */
        /* SS - 100625.1 - B */
        if first-of(xxtr_vend) then do:
            for first xxgz_mstr
                no-lock
                where xxgz_domain = global_domain
                    and xxgz_year = iYear
                    and xxgz_per = iMonth
                    and xxgz_vend = xxtr_vend
            :
            end.
            if available(xxgz_mstr) then do:
                sVendorType = xxgz_sort.
            end.
            else do:
                sVendorType = "".
            end.
        end.
        /* SS - 100625.1 - E */
        
        accumulate xxtr_qty (total by xxtr_sort).
        /* SS - 100701.1 - B
        accumulate (xxtr_amt / (1 + xxtr_tax_pct / 100)) (total by xxtr_sort).
        SS - 100701.1 - E */
        /* SS - 100701.1 - B */
        accumulate xxtr_amt (total by xxtr_sort).
        /* SS - 100701.1 - E */

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
                    t1_vendor_type = sVendorType
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
        ,
    each pl_mstr
        no-lock
        where pl_domain = global_domain
            and pl_prod_line = pt_prod_line
        break
        by pt_prod_line
        by t1_vendor_type
        /* by t1_loc */
        with frame b
    :
        accumulate (t1_current_amt - t1_overperiod_amt - t1_in_amt + t1_out_amt) (total by t1_vendor_type).
        accumulate t1_in_amt (total by t1_vendor_type).
        accumulate t1_out_amt (total by t1_vendor_type).
        accumulate (t1_current_amt - t1_overperiod_amt) (total by t1_vendor_type).
        
        if last-of(t1_vendor_type) then do:
            display
                pt_prod_line
                pl_desc
                t1_vendor_type
                accum total by t1_vendor_type (t1_current_amt - t1_overperiod_amt - t1_in_amt + t1_out_amt)
                    @ decStartAmt
                accum total by t1_vendor_type t1_in_amt
                    @ t1_in_amt
                accum total by t1_vendor_type t1_out_amt
                    @ t1_out_amt
                accum total by t1_vendor_type (t1_current_amt - t1_overperiod_amt)
                    @ decFinishAmt
                .
            down.
        end.
    end.


    {mfreset.i}
    {mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}










