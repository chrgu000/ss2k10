/* SS - 110801.1 By: Kaine Zhang */

empty temp-table t1_tmp.

for each ld_det
    no-lock
    use-index ld_loc_p_lot
    where ld_domain = global_domain
        and ld_site = sSite
        and ld_loc >= sLocA
        and ld_loc <= sLocB
        and ld_part >= sPartA
        and ld_part <= sPartB
        and (ld_loc begins "Z1" or ld_loc begins "Z301" or ld_loc begins "Z302" or ld_loc begins "Z4")
    ,
each pt_mstr
    no-lock
    where pt_domain = ld_domain
        and pt_part = ld_part
        and pt_prod_line >= sProdLineA
        and pt_prod_line <= sProdLineB
    break
    by ld_loc
    by ld_part
    by ld_lot
:
    accumulate ld_qty_oh (total by ld_lot).

    if last-of(ld_lot) then do:
        create t1_tmp.
        assign
            t1_type = if ld_loc begins "Z302" then "原材料" else if ld_loc begins "Z4" then "产成品" else "半成品"
            t1_loc = ld_loc
            t1_part = ld_part
            t1_lot = ld_lot
            t1_qty = accum total by ld_lot ld_qty_oh
            .
    end.
end.


for each wo_mstr
    no-lock
    where wo_domain = global_domain
        and wo_site = sSite
        and (wo_status <> "C" and wo_status <> "P")
        and wo_qty_ord - wo_qty_comp - wo_qty_rjct > 0
:
    create t1_tmp.
    assign
        t1_type = "在制品"
        t1_part = wo_part
        t1_lot = wo_nbr + "/" + wo_lot
        t1_qty = wo_qty_ord - wo_qty_comp - wo_qty_rjct
        .
end.


empty temp-table tfoo1_tmp.
empty temp-table tfoo2_tmp.
/* [qad.menu.30.16.3.6.3] */
{gprun.i
    ""xxfoocost1.p""
    "(
        input """",
        input """",
        input sSite,
        input sSite,
        input """",
        input """",
        input """",
        input """",
        input iYear,
        input iMonth
    )"
}
/* [qad.menu.30.16.3.2.13] */
{gprun.i
    ""xxfoocost2.p""
    "(
        input """",
        input """",
        input sSite,
        input sSite,
        input """",
        input """",
        input """",
        input """",
        input iYear,
        input iMonth
    )"
}

for each t1_tmp
    break
    by t1_part
:
    if first-of(t1_part) then do:
        find first pi_mstr
            no-lock
            use-index pi_list
            where pi_domain = global_domain
                and pi_list = "A"
                and pi_cs_type = "9"
                and pi_cs_code = "qadall--+--+--+--+--+"
                and pi_part_type = "6"
                and pi_part_code = t1_part
                /* todo curr um */
                and (pi_start <= today or pi_start = ?)
                and (pi_expire >= today or pi_expire = ?)
            no-error.
        decPrice = if available(pi_mstr) then pi_list_price else 0.
    end.
    t1_price = decPrice.
end.

put unformat "类别" at 1 sDelimiter 
						 "库位代码"   sDelimiter
						 "库位名称"   sDelimiter
						 "产品线"     sDelimiter
						 "物资代码"   sDelimiter
						 "物资名称"   sDelimiter
						 "物资规格"   sDelimiter
						 "批号"       sDelimiter
						 "数量"       sDelimiter
						 "成本额"     sDelimiter
						 "预计销售额" .

for each t1_tmp,
first pt_mstr
    no-lock
    where pt_domain = global_domain
        and pt_part = t1_part
    ,
first loc_mstr
    no-lock
    where loc_domain = global_domain
        and loc_site = sSite
        and loc_loc = t1_loc
    break
    by t1_type
    by t1_loc
    by t1_part
:
    if t1_type = "在制品" then do:
        find first tfoo1_tmp
            where tfoo1_part = t1_part
            no-error.
        if available(tfoo1_tmp) then t1_cost = tfoo1_cost.
    end.
    else do:
        find first tfoo2_tmp
            where tfoo2_part = t1_part
            no-error.
        if available(tfoo2_tmp) then t1_cost = tfoo2_cost.
    end.

    put
        unformatted
        t1_type     at 1    sDelimiter
        t1_loc              sDelimiter
        loc_desc            sDelimiter
        pt_prod_line        sDelimiter
        t1_part             sDelimiter
        pt_desc1            sDelimiter
        pt_desc2            sDelimiter
        t1_lot              sDelimiter
        t1_qty              sDelimiter
        t1_qty * t1_cost    sDelimiter
        t1_qty * t1_price   
        .
end.




