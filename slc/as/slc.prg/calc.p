/*
 *  计算暂估处理的物料,在5月的出库数量.
 *  对这部分出库数量.在6月份,对应手动生成出库金额的差异
 */
{mfdtitle.i}

define temp-table t1_tmp
    field t1_vend as character format "x(8)"
    field t1_part as character format "x(18)"
    field t1_qty as decimal
    field t1_old_price as decimal
    field t1_new_price as decimal
    .

empty temp-table t1_tmp.

procedure getoutqty:
    for each xxtr_hist
        no-lock
        where xxtr_domain = global_domain
            and xxtr_year = 2010
            and xxtr_per = 5
            and xxtr_sort = "out"
        break 
        by xxtr_vend
        by xxtr_part
        :
        accumulate xxtr_qty (total by xxtr_part).
        if last-of(xxtr_part) then do:
            find first t1_tmp
                where t1_vend = xxtr_vend
                    and t1_part = xxtr_part
                no-error.
            if not(available(t1_tmp)) then do:
                create t1_tmp.
                assign
                    t1_vend = xxtr_vend
                    t1_part = xxtr_part
                    .
            end.
            t1_qty = t1_qty + accum total by xxtr_part xxtr_qty.
        end.    
    end.
end procedure.
    
procedure getoldprice:
    for each xxtr_hist
        where xxtr_year = 2010 and xxtr_per = 6 and xxtr_rmks = "暂估处理" and xxtr_type = "rct-zg":
        find first t1_tmp
            where t1_vend = xxtr_vend
                and t1_part = xxtr_part
            no-error.
        if not(available(t1_tmp)) then do:
            create t1_tmp.
            assign
                t1_vend = xxtr_vend
                t1_part = xxtr_part
                .
        end.
        t1_old_price = xxtr_price.
    end.
end procedure.
    
    
procedure getnewprice:
    for each xxtr_hist
        where xxtr_year = 2010 and xxtr_per = 6 and xxtr_rmks = "暂估处理" and xxtr_type = "rct-po":
        find first t1_tmp
            where t1_vend = xxtr_vend
                and t1_part = xxtr_part
            no-error.
        if not(available(t1_tmp)) then do:
            create t1_tmp.
            assign
                t1_vend = xxtr_vend
                t1_part = xxtr_part
                .
        end.
        t1_new_price = xxtr_price.
    end.
end procedure.
    
run getoldprice .
run getnewprice .
run getoutqty .


for each t1_tmp
    where t1_old_price <> 0 or t1_new_price <> 0,
first xxld_det
    no-lock
    where xxld_domain = global_domain
        and xxld_year = 2010
        and xxld_per = 5
        and xxld_vend = t1_vend
        and xxld_part = t1_part
:
    create xxtr_hist.
    assign 
        xxtr_domain = global_domain
        xxtr_site = "10000"
        xxtr_year = 2010
        xxtr_per	= 6
        xxtr_vend = t1_vend
        xxtr_type = "iss-wo"   /* 将之前暂估出库的差异金额,在这里发出去 */
        xxtr_sort = "out"
        xxtr_part = t1_part
        xxtr_tax_pct = xxld_tax_pct
        xxtr_price = t1_new_price - t1_old_price
        xxtr_qty   = 0
        xxtr_amt   = xxtr_price * t1_qty
        xxtr_effdate  = today
        xxtr_time  = time
        xxtr_rmks  = "暂估处理"
        xxtr_glnbr = ""
        .
end.


    
    
    
    